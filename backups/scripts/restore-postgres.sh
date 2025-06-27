#!/bin/bash
set -euo pipefail

# === Couleurs pour logs ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# === Détection de l’environnement ===
APP_ENV=${APP_ENV:-local}
echo -e "${YELLOW}Environnement détecté : ${APP_ENV}${NC}"

if [ "$APP_ENV" = "production" ]; then
  echo -e "${RED}⚠️⚠️⚠️ Attention : script exécuté en environnement de production !${NC}"
fi

# === Détection chemin script ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# === Choix du fichier .env selon APP_ENV ===
case "$APP_ENV" in
  production)
    ENV_FILE="$PROJECT_ROOT/.env.production"
    ;;
  local|development)
    ENV_FILE="$PROJECT_ROOT/.env.local"
    ;;
  *)
    if [ -f "$PROJECT_ROOT/.env" ]; then
      ENV_FILE="$PROJECT_ROOT/.env"
    else
      echo -e "${RED}❌ Fichier d’environnement introuvable pour APP_ENV=$APP_ENV${NC}"
      exit 1
    fi
    ;;
esac

if [ ! -f "$ENV_FILE" ]; then
  echo -e "${RED}❌ Fichier d’environnement introuvable : $ENV_FILE${NC}"
  exit 1
fi

get_env_var() {
  grep -E "^$1=" "$ENV_FILE" | cut -d '=' -f2- | tr -d '\r' || true
}

POSTGRES_USER=$(get_env_var "POSTGRES_USER")
POSTGRES_PASSWORD=$(get_env_var "POSTGRES_PASSWORD")
POSTGRES_HOST=$(get_env_var "POSTGRES_HOST")
POSTGRES_PORT=$(get_env_var "POSTGRES_PORT")
POSTGRES_DATABASE=$(get_env_var "POSTGRES_DATABASE")

# === Vérification des variables PostgreSQL ===
required_vars=("POSTGRES_USER" "POSTGRES_PASSWORD" "POSTGRES_HOST" "POSTGRES_PORT" "POSTGRES_DATABASE")
missing_vars=()

for var in "${required_vars[@]}"; do
  if [[ -z "${!var+x}" || -z "${!var}" ]]; then
    missing_vars+=("$var")
  fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
  echo -e "${RED}❌ Variables PostgreSQL manquantes ou vides dans $ENV_FILE : ${missing_vars[*]}${NC}"
  exit 1
fi

# === Génération d’un fichier .pgpass temporaire sécurisé ===
PGPASS_FILE="$SCRIPT_DIR/.pgpass"
echo "$POSTGRES_HOST:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > "$PGPASS_FILE"
chmod 600 "$PGPASS_FILE"
export PGPASSFILE="$PGPASS_FILE"
echo -e "${GREEN}✅ Fichier .pgpass temporaire généré${NC}"

cleanup_pgpass() {
  rm -f "$PGPASS_FILE"
  echo -e "${GREEN}❌ Fichier .pgpass temporaire supprimé${NC}"
}
trap cleanup_pgpass EXIT

# === Détection du dossier de backup le plus récent ===
BACKUPS_DIR="$PROJECT_ROOT/backups"
LATEST_BACKUP_DIR=$(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name scripts | sort -r | head -n 1 || true)

if [ -z "$LATEST_BACKUP_DIR" ]; then
  echo -e "${RED}❌ Aucun dossier de backup trouvé dans $BACKUPS_DIR${NC}"
  exit 1
fi

echo -e "${GREEN}Dernier dossier de backup détecté : $LATEST_BACKUP_DIR${NC}"

# === Bases à restaurer et leurs fichiers ===
declare -A DATABASES=(
  ["$POSTGRES_DATABASE"]="$LATEST_BACKUP_DIR/$POSTGRES_DATABASE.sql"
  ["keycloak"]="$LATEST_BACKUP_DIR/keycloak.sql"
  ["openfga"]="$LATEST_BACKUP_DIR/openfga.sql"
)

echo ""
echo -e "${YELLOW}Bases à restaurer (si fichier présent) :${NC}"
for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    echo -e " - ${GREEN}$DB_NAME${NC} ✔ ($FILE_PATH)"
  else
    echo -e " - ${YELLOW}$DB_NAME${NC} ⚠ (fichier absent)"
  fi
done

echo ""
read -rp "❓ Continuer avec cette restauration ? (Y/n) : " CONFIRM
CONFIRM=${CONFIRM:-y}
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "${RED}❌ Restauration annulée.${NC}"
  exit 0
fi

# === Arrêt temporaire des services dépendants ===
echo ""
echo -e "${YELLOW}🛑 Arrêt des services FastAPI, Keycloak et OpenFGA...${NC}"
docker compose stop fastapi keycloak openfga

# === Démarrage de PostgreSQL seul ===
echo "🟡 Démarrage temporaire de PostgreSQL pour la restauration..."
docker compose up -d postgres

echo "⏳ Attente de la disponibilité de PostgreSQL..."
until docker exec postgres_ssl pg_isready -U postgres > /dev/null 2>&1; do
  sleep 2
done
echo "✅ PostgreSQL est prêt."

# === Restauration ===
echo ""
echo -e "${YELLOW}Démarrage de la restauration...${NC}"
echo ""

declare -A STATUS

for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    echo -e "${YELLOW}⚠️ Déconnexion des connexions actives sur la base '$DB_NAME'...${NC}"
    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "
    SELECT pg_terminate_backend(pid)
    FROM pg_stat_activity
    WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();
    "
    echo -e "${YELLOW}Suppression + recréation de la base '$DB_NAME'...${NC}"
    dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"
    createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"
    echo -e "${YELLOW}Restauration depuis le fichier : $FILE_PATH${NC}"
    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH"
    STATUS["$DB_NAME"]="${GREEN}✅ Restaurée${NC}"
  else
    STATUS["$DB_NAME"]="${YELLOW}⏩ Ignorée (fichier absent)${NC}"
  fi
done

# === Redémarrage des services dépendants ===
echo ""
echo -e "${GREEN}Redémarrage des services FastAPI, Keycloak et OpenFGA...${NC}"
docker compose up -d fastapi keycloak openfga

# === Résumé ===
echo ""
echo -e "${GREEN}✅ Restauration terminée. Résumé :${NC}"
for DB_NAME in "${!DATABASES[@]}"; do
  echo -e " - $DB_NAME : ${STATUS[$DB_NAME]}"
done

# === Synchronisation automatique du FGA_STORE_ID restauré ===
echo ""
echo -e "${YELLOW}Synchronisation de FGA_STORE_ID depuis le fichier de backup openfga.sql...${NC}"

OPENFGA_SQL_FILE="$LATEST_BACKUP_DIR/openfga.sql"

if [ -f "$OPENFGA_SQL_FILE" ]; then
  RESTORED_STORE_ID=$(awk '/^COPY public.store / {getline; print $1}' "$OPENFGA_SQL_FILE" | grep -E '^[0-9A-Z]{26}$' | head -n 1 || true)

  if [ -n "$RESTORED_STORE_ID" ]; then
    echo -e "${GREEN}✅ Store restauré détecté : $RESTORED_STORE_ID${NC}"
    echo -e "${YELLOW}Mise à jour de $ENV_FILE avec FGA_STORE_ID=$RESTORED_STORE_ID...${NC}"
    if grep -Eq "^FGA_STORE_ID\s*=" "$ENV_FILE"; then
      sed -i.bak -E "s/^FGA_STORE_ID\s*=.*/FGA_STORE_ID=$RESTORED_STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
      echo -e "${GREEN}🔁 Variable FGA_STORE_ID mise à jour dans $ENV_FILE${NC}"
    else
      echo -e "\nFGA_STORE_ID=$RESTORED_STORE_ID" >> "$ENV_FILE"
      echo -e "${GREEN}➕ Variable FGA_STORE_ID ajoutée à $ENV_FILE${NC}"
    fi
  else
    echo -e "${RED}⚠️ Aucun store valide trouvé dans $OPENFGA_SQL_FILE. FGA_STORE_ID non modifié.${NC}"
  fi
else
  echo -e "${RED}⚠️ Fichier $OPENFGA_SQL_FILE introuvable. FGA_STORE_ID non modifié.${NC}"
fi
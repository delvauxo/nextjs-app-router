#!/bin/bash
set -euo pipefail

# === Couleurs pour logs ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# === Détection de l’environnement ===
APP_ENV=${APP_ENV:-local}
echo ""
echo -e "${BLUE}🔍 Environnement détecté :${NC} ${YELLOW}${APP_ENV}${NC}"

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
  echo -e "${GREEN}✅ Fichier .pgpass temporaire supprimé${NC}"
  echo ""
}
trap cleanup_pgpass EXIT

# === Sélection interactive du dossier de backup ===
BACKUPS_DIR="$PROJECT_ROOT/backups"
BACKUP_DIRS=($(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name scripts | sort -r))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
  echo -e "${RED}❌ Aucun dossier de backup trouvé dans $BACKUPS_DIR${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}📁 Dossiers de backup disponibles :${NC}"
echo ""

OPTIONS=("${BACKUP_DIRS[@]##*/}" "Annuler")

echo -e "${CYAN}➤ Choisis un dossier avec son numéro :${NC}"
select DIR_NAME in "${OPTIONS[@]}"; do
  if [ "$DIR_NAME" = "Annuler" ]; then
    echo ""
    echo -e "${RED}❌ Opération annulée.${NC}"
    exit 0
  elif [ -n "$DIR_NAME" ]; then
    SELECTED_BACKUP_DIR="$BACKUPS_DIR/$DIR_NAME"
    echo ""
    echo -e "${GREEN}✅ Dossier sélectionné : ${MAGENTA}$SELECTED_BACKUP_DIR${NC}"
    break
  else
    echo ""
    echo -e "${RED}⛔ Sélection invalide. Choisis un numéro valide.${NC}"
  fi
done

# === Proposition de backup préventif ===
echo ""
echo -ne "${CYAN}➤ Souhaites-tu faire un backup de l'état actuel avant la restauration ? (Y/n) : ${NC}"
read -r DO_BACKUP
DO_BACKUP=${DO_BACKUP:-y}

if [[ "$DO_BACKUP" == "y" || "$DO_BACKUP" == "Y" ]]; then
  echo ""
  echo -e "${YELLOW}Lancement du script de backup avant restauration...${NC}"
  bash "$SCRIPT_DIR/backup-postgres.sh"
fi

# === Bases à restaurer et sélection interactive ===
LATEST_BACKUP_DIR="$SELECTED_BACKUP_DIR"
declare -A DATABASES=(
  ["$POSTGRES_DATABASE"]="$LATEST_BACKUP_DIR/$POSTGRES_DATABASE.sql"
  ["keycloak"]="$LATEST_BACKUP_DIR/keycloak.sql"
  ["openfga"]="$LATEST_BACKUP_DIR/openfga.sql"
)

declare -A DATABASES_TO_RESTORE=()

echo ""
echo -e "${BLUE}💾 Bases à restaurer détectées :${NC}"
echo ""
for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    echo -e " - ${GREEN}$DB_NAME${NC} ✔  ${MAGENTA}($FILE_PATH)${NC}"
  else
    echo -e " - ${YELLOW}$DB_NAME${NC} ⚠  ${MAGENTA}($FILE_PATH)${NC}"
  fi
done

echo ""
echo -ne "${CYAN}➤ Tout restaurer sans sélection individuelle ? (Y/n) : ${NC}"
read -r FULL_RESTORE

FULL_RESTORE=${FULL_RESTORE:-y}

for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    if [[ "$FULL_RESTORE" == "y" || "$FULL_RESTORE" == "Y" ]]; then
      DATABASES_TO_RESTORE["$DB_NAME"]="$FILE_PATH"
    else
      echo -ne "${CYAN}   ➤ Restaurer la base ${NC}$DB_NAME${CYAN} ? (Y/n) : ${NC}"
      read -r CHOICE
      CHOICE=${CHOICE:-y}
      if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
        DATABASES_TO_RESTORE["$DB_NAME"]="$FILE_PATH"
      else
        echo -e "   ⏩ ${YELLOW}Ignorée${NC}"
      fi
    fi
  fi
done

if [ ${#DATABASES_TO_RESTORE[@]} -eq 0 ]; then
  echo ""
  echo -e "${RED}❌ Aucune base sélectionnée pour la restauration. Opération annulée.${NC}"
  exit 0
fi

# === Arrêt temporaire des services dépendants ===
echo ""
echo -e "${BLUE}🛑 Arrêt des services FastAPI, Keycloak et OpenFGA...${NC}"
echo ""
docker compose stop fastapi keycloak openfga

# === Démarrage de PostgreSQL seul ===
echo ""
echo -e "${BLUE}🟡 Démarrage temporaire de PostgreSQL pour la restauration...${NC}"
echo ""
docker compose up -d postgres

echo ""
echo -e "${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
echo ""
until docker exec postgres_ssl pg_isready -U postgres > /dev/null 2>&1; do
  sleep 2
done
echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"

# === Restauration ===
echo ""
echo -e "${BLUE}🚀 Démarrage de la restauration...${NC}"
echo ""

declare -A STATUS

for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
  FILE_PATH="${DATABASES_TO_RESTORE[$DB_NAME]}"
  echo -e "${YELLOW}⚠️ Déconnexion des connexions actives sur la base '$DB_NAME'...${NC}"
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();
  "
  echo -e "${YELLOW}🔄 Suppression + recréation de la base '$DB_NAME'...${NC}"
  dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"
  createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"
  echo -e "${YELLOW}📥 Restauration depuis le fichier : ${MAGENTA}$FILE_PATH${NC}"
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH"
  STATUS["$DB_NAME"]="${GREEN}✅ Restaurée${NC}"
done

# === Redémarrage des services dépendants ===
echo ""
echo -e "${BLUE}🔁 Redémarrage des services FastAPI, Keycloak et OpenFGA...${NC}"
echo ""
docker compose up -d fastapi keycloak openfga

# === Résumé ===
echo ""
echo -e "${BLUE}✅ Restauration terminée. Résumé :${NC}"
echo ""
for DB_NAME in "${!DATABASES[@]}"; do
  if [[ -n "${STATUS[$DB_NAME]+x}" ]]; then
    echo -e " - $DB_NAME : ${STATUS[$DB_NAME]}"
  else
    echo -e " - $DB_NAME : ${YELLOW}⏩ Ignorée${NC}"
  fi
done

# === Synchronisation automatique du FGA_STORE_ID restauré si la base openfga a été restaurée ===
if [[ -n "${STATUS["openfga"]+x}" ]]; then
  echo ""
  echo -e "${BLUE}🔄 Synchronisation de FGA_STORE_ID depuis la base restaurée 'openfga'...${NC}"

  OPENFGA_SQL_FILE="$LATEST_BACKUP_DIR/openfga.sql"

  if [ -f "$OPENFGA_SQL_FILE" ]; then
    RESTORED_STORE_ID=$(awk '/^COPY public.store / {getline; print $1}' "$OPENFGA_SQL_FILE" | grep -E '^[0-9A-Z]{26}$' | head -n 1 || true)

    if [ -n "$RESTORED_STORE_ID" ]; then
      echo -e "${GREEN}✅ Store restauré détecté : $RESTORED_STORE_ID${NC}"
      echo -e "${YELLOW}✏️ Mise à jour de ${MAGENTA}$ENV_FILE${YELLOW} avec FGA_STORE_ID=$RESTORED_STORE_ID...${NC}"
      if grep -Eq "^FGA_STORE_ID\s*=" "$ENV_FILE"; then
        sed -i.bak -E "s/^FGA_STORE_ID\s*=.*/FGA_STORE_ID=$RESTORED_STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
        echo -e "${GREEN}✅ Variable FGA_STORE_ID mise à jour dans ${MAGENTA}$ENV_FILE${NC}"
      else
        echo -e "\nFGA_STORE_ID=$RESTORED_STORE_ID" >> "$ENV_FILE"
        echo -e "${GREEN}➕ Variable FGA_STORE_ID ajoutée à ${MAGENTA}$ENV_FILE${NC}"
      fi
    else
      echo -e "${RED}⚠️ Aucun store valide trouvé dans $OPENFGA_SQL_FILE. FGA_STORE_ID non modifié.${NC}"
    fi
  else
    echo -e "${RED}⚠️ Fichier $OPENFGA_SQL_FILE introuvable. FGA_STORE_ID non modifié.${NC}"
  fi
else
  echo ""
  echo -e "${YELLOW}⏩ Base 'openfga' non restaurée, FGA_STORE_ID inchangé.${NC}"
fi
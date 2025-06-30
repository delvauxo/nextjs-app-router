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
  production) ENV_FILE="$PROJECT_ROOT/.env.production" ;;
  local|development) ENV_FILE="$PROJECT_ROOT/.env.local" ;;
  *) ENV_FILE="$PROJECT_ROOT/.env" ;;
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

required_vars=("POSTGRES_USER" "POSTGRES_PASSWORD" "POSTGRES_HOST" "POSTGRES_PORT" "POSTGRES_DATABASE")
missing_vars=()
for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    missing_vars+=("$var")
  fi
done
if [ ${#missing_vars[@]} -ne 0 ]; then
  echo -e "${RED}❌ Variables manquantes dans $ENV_FILE : ${missing_vars[*]}${NC}"
  exit 1
fi

# === Fichier .pgpass temporaire ===
PGPASS_FILE="$SCRIPT_DIR/.pgpass"
echo "$POSTGRES_HOST:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > "$PGPASS_FILE"
chmod 600 "$PGPASS_FILE"
export PGPASSFILE="$PGPASS_FILE"
trap 'rm -f "$PGPASS_FILE"; echo -e "${GREEN}✅ Fichier .pgpass temporaire supprimé${NC}"; echo ""; ' EXIT
echo -e "${GREEN}✅ Fichier .pgpass temporaire généré${NC}"

# === Container PostgreSQL ===
CONTAINER_NAME=postgres_ssl

if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo -e "${YELLOW}🔄 Lancement du container PostgreSQL...${NC}"
  docker compose up -d postgres
  echo -e "${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
  until docker exec "$CONTAINER_NAME" pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; do sleep 2; done
  echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"
else
  echo -e "${GREEN}✅ Container PostgreSQL déjà actif.${NC}"
fi

# === Bases à sauvegarder ===
DATABASES=("openfga" "$POSTGRES_DATABASE" "keycloak")

echo ""
echo -ne "${CYAN}➤ Sauvegarder toutes les bases (${DATABASES[*]}) ? (Y/n) : ${NC}"
read -r SAVE_ALL
SAVE_ALL=${SAVE_ALL:-y}

SELECTED_DATABASES=()
if [[ "$SAVE_ALL" == "y" || "$SAVE_ALL" == "Y" ]]; then
  SELECTED_DATABASES=("${DATABASES[@]}")
else
  echo ""
  for db in "${DATABASES[@]}"; do
    echo -ne "${CYAN}   ➤ Sauvegarder ${NC}$db${CYAN} ? (Y/n) : ${NC}"
    read -r ANSWER
    ANSWER=${ANSWER:-y}
    if [[ "$ANSWER" =~ ^[yY]$ ]]; then
      SELECTED_DATABASES+=("$db")
    fi
  done
fi

if [ ${#SELECTED_DATABASES[@]} -eq 0 ]; then
  echo -e "${RED}❌ Aucune base sélectionnée. Abandon.${NC}"
  exit 1
fi

# === Nom du dossier de sauvegarde ===
BACKUP_ROOT="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo ""
echo -ne "${CYAN}➤ Nom personnalisé pour le dossier de backup (optionnel) : ${NC}"
read -r CUSTOM_NAME
if [[ -z "$CUSTOM_NAME" ]]; then
  BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
else
  BACKUP_DIR="$BACKUP_ROOT/${TIMESTAMP}_$CUSTOM_NAME"
fi

mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}📁 Dossier créé : $BACKUP_DIR${NC}"

# === Confirmation ===
echo ""
echo -e "${CYAN}Bases sélectionnées :${NC} ${MAGENTA}${SELECTED_DATABASES[*]}${NC}"
echo -e "${CYAN}Destination :${NC} ${MAGENTA}$BACKUP_DIR${NC}"
echo -ne "${YELLOW}➤ Confirmer et lancer la sauvegarde ? (Y/n) : ${NC}"
read -r CONFIRM
CONFIRM=${CONFIRM:-y}
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "${RED}❌ Sauvegarde annulée.${NC}"
  exit 0
fi

# === Backup ===
for DB in "${SELECTED_DATABASES[@]}"; do
  echo -e "${YELLOW}📦 Backup de $DB...${NC}"
  if ! docker exec -t "$CONTAINER_NAME" pg_dump -U "$POSTGRES_USER" "$DB" > "$BACKUP_DIR/$DB.sql"; then
    echo -e "${RED}❌ Erreur lors de la sauvegarde de $DB${NC}"
    exit 1
  fi
done

# === Dump global ===
echo -e "${YELLOW}🌐 Dump global (pg_dumpall)...${NC}"
if docker exec -t "$CONTAINER_NAME" pg_dumpall -U "$POSTGRES_USER" > "$BACKUP_DIR/full_postgres_dump.sql"; then
  gzip "$BACKUP_DIR/full_postgres_dump.sql"
  echo -e "${GREEN}✅ Dump global compressé : $BACKUP_DIR/full_postgres_dump.sql.gz${NC}"
else
  echo -e "${RED}❌ Erreur lors du dump global${NC}"
fi

echo ""
echo -e "${GREEN}✅ Sauvegarde terminée avec succès dans : ${MAGENTA}$BACKUP_DIR${NC}"

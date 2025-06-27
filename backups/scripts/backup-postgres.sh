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

# Fonction pour récupérer une variable dans le fichier .env (sans commentaires ni espaces)
get_env_var() {
  grep -E "^$1=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f2- | tr -d '\r' | tr -d '"'
}

POSTGRES_USER=$(get_env_var "POSTGRES_USER")
POSTGRES_DATABASE=$(get_env_var "POSTGRES_DATABASE")

# Vérification variables essentielles
required_vars=("POSTGRES_USER" "POSTGRES_DATABASE")
missing_vars=()
for var in "${required_vars[@]}"; do
  if [[ -z "${!var}" ]]; then
    missing_vars+=("$var")
  fi
done
if [ ${#missing_vars[@]} -ne 0 ]; then
  echo -e "${RED}❌ Variables manquantes ou vides dans $ENV_FILE : ${missing_vars[*]}${NC}"
  exit 1
fi

# === Variables principales ===
CONTAINER_NAME=postgres_ssl

# Vérifier si le container PostgreSQL est en cours d'exécution
if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo -e "${YELLOW}Le container $CONTAINER_NAME n'est pas en cours d'exécution. Lancement...${NC}"
  docker compose up -d postgres
  
  echo -e "${YELLOW}Attente de la disponibilité de PostgreSQL...${NC}"
  until docker exec "$CONTAINER_NAME" pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; do
    sleep 2
  done
  echo -e "${GREEN}PostgreSQL est prêt.${NC}"
else
  echo -e "${GREEN}Container $CONTAINER_NAME déjà en cours d'exécution.${NC}"
fi

# Bases à sauvegarder : base principale + celles fixées
DATABASES=("$POSTGRES_DATABASE" "keycloak" "openfga")

BACKUP_ROOT="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

# === Création dossier backup ===
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}📦 Dossier de sauvegarde créé : $BACKUP_DIR${NC}"

# === Backup bases ===
for DB in "${DATABASES[@]}"; do
  echo -e "${YELLOW}🔹 Sauvegarde de la base $DB${NC}"
  if ! docker exec -t "$CONTAINER_NAME" pg_dump -U "$POSTGRES_USER" "$DB" > "$BACKUP_DIR/$DB.sql"; then
    echo -e "${RED}❌ Erreur lors de la sauvegarde de $DB${NC}"
    exit 1
  fi
done

# === Dump global (rôles + bases) ===
echo -e "${YELLOW}🌐 Dump complet (pg_dumpall)${NC}"
if ! docker exec -t "$CONTAINER_NAME" pg_dumpall -U "$POSTGRES_USER" > "$BACKUP_DIR/full_postgres_dump.sql"; then
  echo -e "${RED}❌ Erreur lors du dump global${NC}"
  exit 1
fi

# Compression du dump complet
gzip "$BACKUP_DIR/full_postgres_dump.sql"
echo -e "${GREEN}✅ Dump global compressé : $BACKUP_DIR/full_postgres_dump.sql.gz${NC}"

echo -e "${GREEN}✅ Backup terminé dans $BACKUP_DIR${NC}"

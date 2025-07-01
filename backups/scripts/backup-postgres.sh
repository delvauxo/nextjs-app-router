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

# === Estimation de l'espace disque nécessaire ===
estimate_backup_size_mb() {
  local total_bytes=0

  echo ""
  echo -e "${BLUE}📝 Estimation taille des bases :${NC}"
  echo ""
  for db in "${SELECTED_DATABASES[@]}"; do
    size_bytes=$(docker exec "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE" -t -A -c "SELECT pg_database_size('$db');" 2>/dev/null | tr -d '[:space:]')
    if [[ "$size_bytes" =~ ^[0-9]+$ ]]; then
      size_mb=$((size_bytes / 1024 / 1024))
      echo -e "   - $db : ${size_mb} Mo${NC}"
      total_bytes=$((total_bytes + size_bytes))
    else
      echo -e "${YELLOW}⚠️ Impossible d'estimer la taille de $db. Résultat brut : '$size_bytes'. Ignorée.${NC}"
    fi
  done

  ESTIMATED_REQUIRED_MB=$(awk "BEGIN {printf \"%d\", $total_bytes / 1024 / 1024}")
}

# === Vérification de l'espace disque nécessaire ===
check_disk_space() {
  local backup_path="$1"
  local required_mb="$2"

  local free_kb
  free_kb=$(df -k --output=avail "$(dirname "$backup_path")" | tail -1)

  local free_gb
  free_gb=$(awk "BEGIN {printf \"%.1f\", $free_kb/1024/1024}")
  local required_gb
  required_gb=$(awk "BEGIN {printf \"%.2f\", $required_mb/1024}")

  echo ""
  echo -e "Espace requis : ${required_mb} Mo${NC}"
  echo -e "Espace disponible : ${free_gb} Go${NC}"

  if (( free_kb < required_mb * 1024 )); then
    echo -e "${RED}❌ Espace disque insuffisant (< ${required_mb} Mo) pour effectuer le backup.${NC}"
    exit 1
  fi
}

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

# === Nettoyage si interruption après création du dossier vide ===
CLEANUP_ON_EXIT() {
  if [[ -n "${BACKUP_DIR:-}" && -d "$BACKUP_DIR" && -z "$(ls -A "$BACKUP_DIR")" ]]; then
    echo ""
    echo -e "${YELLOW}🧹 Interruption détectée : suppression du dossier vide ${MAGENTA}$BACKUP_DIR${NC}"
    rm -rf "$BACKUP_DIR"
  fi
}

trap CLEANUP_ON_EXIT SIGINT SIGTERM

# === Estimation taille backup en Mo ===
estimate_backup_size_mb
check_disk_space "$BACKUP_DIR" "$ESTIMATED_REQUIRED_MB"

# === Confirmation ===
echo ""
echo -ne "${CYAN}➤ Confirmer et lancer la sauvegarde ? (Y/n) : ${NC}"
read -r CONFIRM
CONFIRM=${CONFIRM:-y}
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo ""
  echo -e "${RED}❌ Sauvegarde annulée.${NC}"
  exit 0
fi

# === Création du dossier de backup apres confirmation ===
mkdir -p "$BACKUP_DIR"
echo ""
echo -e "${GREEN}📁 Dossier créé : ${MAGENTA}$BACKUP_DIR${NC}"

# === Backup ===
echo ""
for DB in "${SELECTED_DATABASES[@]}"; do
  echo -e "${YELLOW}📦 Backup de $DB...${NC}"
  if ! docker exec -t "$CONTAINER_NAME" pg_dump -U "$POSTGRES_USER" "$DB" > "$BACKUP_DIR/$DB.sql"; then
    echo -e "${RED}❌ Erreur lors de la sauvegarde de $DB${NC}"
    exit 1
  fi
done

# === Dump global ===
echo -e "${YELLOW}📦 Dump global (pg_dumpall)...${NC}"
if docker exec -t "$CONTAINER_NAME" pg_dumpall -U "$POSTGRES_USER" > "$BACKUP_DIR/full_postgres_dump.sql"; then
  gzip "$BACKUP_DIR/full_postgres_dump.sql"
  echo -e "${GREEN}✅ Dump global compressé : ${MAGENTA}full_postgres_dump.sql.gz${NC}"
else
  echo -e "${RED}❌ Erreur lors du dump global${NC}"
fi

echo ""
echo -e "${GREEN}✅ Sauvegarde terminée avec succès dans : ${MAGENTA}$BACKUP_DIR${NC}"

# Affichage taille réelle des fichiers dumps
echo ""
echo -e "${BLUE}📊 Tailles réelles des dumps :${NC}"
echo ""
for DB in "${SELECTED_DATABASES[@]}"; do
  file_size=$(du -h "$BACKUP_DIR/$DB.sql" | cut -f1)
  echo -e "   - $DB ➜ $file_size"
done
echo ""

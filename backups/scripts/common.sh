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

# === Détection chemin script & projet ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# === Fonction pour afficher l’environnement ===
detect_environment() {
  APP_ENV=${APP_ENV:-local}
  echo ""
  echo -e "${BLUE}🔍 Environnement détecté :${NC} ${YELLOW}${APP_ENV}${NC}"
  if [ "$APP_ENV" = "production" ]; then
    echo -e "${RED}⚠️⚠️⚠️ Attention : script exécuté en environnement de production !${NC}"
  fi
}

# === Chargement du fichier .env ===
load_env_variables() {
  case "$APP_ENV" in
    production) ENV_FILE="$PROJECT_ROOT/.env.production" ;;
    local|development) ENV_FILE="$PROJECT_ROOT/.env.local" ;;
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

  # === Vérification des variables PostgreSQL ===
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
}

# === Fichier .pgpass temporaire ===
create_pgpass() {
  PGPASS_FILE="$SCRIPT_DIR/.pgpass"
  echo "$POSTGRES_HOST:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > "$PGPASS_FILE"
  chmod 600 "$PGPASS_FILE"
  export PGPASSFILE="$PGPASS_FILE"
  echo -e "${GREEN}✅ Fichier .pgpass temporaire généré dans ${MAGENTA}${PGPASS_FILE}${NC}"

  cleanup_pgpass() {
  rm -f "$PGPASS_FILE"
  echo -e "${GREEN}✅ Fichier .pgpass temporaire supprimé${NC}"
  echo ""
  }
  
  trap cleanup_pgpass EXIT
}
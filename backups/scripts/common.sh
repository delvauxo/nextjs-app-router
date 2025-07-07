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
  echo ""
}

# === Chargement des variables depuis le fichier .env
load_env_variables() {
  case "$APP_ENV" in
    production) ENV_FILE="$PROJECT_ROOT/.env.production" ;;
    local|development) ENV_FILE="$PROJECT_ROOT/.env.local" ;;
    *) ENV_FILE="$PROJECT_ROOT/.env" ;;
  esac

  if [[ ! -f "$ENV_FILE" ]]; then
    echo -e "${RED}❌ Fichier d’environnement introuvable : $ENV_FILE${NC}"
    exit 1
  fi

  echo -e "${GREEN}✅ Chargement du fichier d’environnement : ${MAGENTA}${ENV_FILE}${NC}"

  # Charge uniquement les lignes KEY=VALUE (ignore commentaires et invalides)
  set -a
  source "$ENV_FILE"
  set +a

  # Vérification des variables critiques PostgreSQL
  required_vars=("POSTGRES_USER" "POSTGRES_PASSWORD" "POSTGRES_HOST" "POSTGRES_PORT" "POSTGRES_DATABASE" "FGA_STORE_ID")
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

  # Liste centralisée des bases de données à gérer
  # Important : POSTGRES_DATABASE doit être défini avant cette ligne
  DATABASES_TO_MANAGE=("openfga" "$POSTGRES_DATABASE" "keycloak")

  # Variables Keycloak utilisateur avec valeurs par défaut si absentes
  KEYCLOAK_REALM="${KEYCLOAK_REALM:-nextjs-dashboard}"
  KEYCLOAK_CLIENT_ID="${KEYCLOAK_CLIENT_ID:-parkigo}"
  KEYCLOAK_CLIENT_SECRET="${KEYCLOAK_CLIENT_SECRET:-}"
  KEYCLOAK_ISSUER="${KEYCLOAK_ISSUER:-http://localhost:8081/realms/nextjs-dashboard}"
  KEYCLOAK_REFRESH_TOKEN_URL="${KEYCLOAK_REFRESH_TOKEN_URL:-${KEYCLOAK_ISSUER}/protocol/openid-connect/token}"

  # Variables Keycloak admin
  KEYCLOAK_ADMIN_USERNAME="${KEYCLOAK_ADMIN_USERNAME:-admin}"
  KEYCLOAK_ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-yolo}"
  KEYCLOAK_ADMIN_CLIENT_ID="${KEYCLOAK_ADMIN_CLIENT_ID:-admin-cli}"
  KEYCLOAK_ADMIN_REALM="${KEYCLOAK_ADMIN_REALM:-master}"
  KEYCLOAK_BASE_URL="${KEYCLOAK_BASE_URL:-http://localhost:8081}"

  POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-postgres_ssl}"
  KEYCLOAK_CONTAINER_NAME="${KEYCLOAK_CONTAINER_NAME:-keycloak}"
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
    echo ""
    echo -e "${GREEN}✅ Fichier .pgpass temporaire supprimé${NC}"
    echo ""
  }
  
  trap cleanup_pgpass EXIT
}
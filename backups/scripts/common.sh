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

wait_for_realm_ready() {
  local attempts=0
  echo ""
  echo -e "${CYAN}⏳ Vérification que le realm '${KEYCLOAK_REALM}' est disponible (attente max : $((MAX_ATTEMPTS * SLEEP_SECONDS))s)...${NC}"

  until check_realm_exists "$KEYCLOAK_REALM"; do
    exit_code=$?
    ((attempts++))

    case "$exit_code" in
      1)
        echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : realm '${KEYCLOAK_REALM}' introuvable. Keycloak démarre peut-être, ou le realm n'existe pas.${NC}"
        ;;
      2)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : échec d'authentification avec Keycloak. Vérifiez les identifiants.${NC}"
        ;;
      3)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : erreur inconnue lors de la vérification du realm.${NC}"
        ;;
      *)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : erreur inattendue (code $exit_code).${NC}"
        ;;
    esac

    if [ "$attempts" -ge "$MAX_ATTEMPTS" ]; then
      echo ""
      echo -e "${RED}❌ Le realm '${KEYCLOAK_REALM}' est toujours indisponible après $((MAX_ATTEMPTS * SLEEP_SECONDS)) secondes.${NC}"
      echo -e "${RED}   - Vérifiez que Keycloak est bien démarré, que le realm '${KEYCLOAK_REALM}' existe et que les identifiants sont corrects.${NC}"
      return 1
    fi

    sleep "$SLEEP_SECONDS"
  done

  echo ""
  echo -e "${GREEN}✅ Le realm '${KEYCLOAK_REALM}' est prêt.${NC}"
}

# === Vérification de l'existence du realm dans Keycloak ===
check_realm_exists() {
  if [[ -z "${1:-}" ]]; then
    echo -e "${RED}❌ Paramètre manquant pour check_realm_exists : nom du realm attendu.${NC}"
    return 2
  fi
  local REALM_TO_CHECK="$1"

  # 🔑 Récupérer le token d'accès admin
  local TOKEN_RESPONSE
  TOKEN_RESPONSE=$(curl -s -X POST "${KEYCLOAK_BASE_URL}/realms/${KEYCLOAK_ADMIN_REALM}/protocol/openid-connect/token" \
    -d "client_id=${KEYCLOAK_ADMIN_CLIENT_ID}" \
    -d "username=${KEYCLOAK_ADMIN_USERNAME}" \
    -d "password=${KEYCLOAK_ADMIN_PASSWORD}" \
    -d "grant_type=password")

  # Extraire access_token manuellement
  local ACCESS_TOKEN
  ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*"' | head -1 | sed 's/"access_token":"\(.*\)"/\1/')

  if [[ -z "$ACCESS_TOKEN" ]]; then
    echo ""
    echo -e "${RED}❌ Impossible d'obtenir le token d'accès Keycloak.${NC}"
    return 1
  fi

  # 🔍 Vérifier le realm
  local HTTP_CODE
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    "${KEYCLOAK_BASE_URL}/admin/realms/${REALM_TO_CHECK}")

  if [[ "$HTTP_CODE" == "200" ]]; then
    echo ""
    echo -e "${GREEN}✅ Le realm '${REALM_TO_CHECK}' existe dans Keycloak.${NC}"
    return 0
  elif [[ "$HTTP_CODE" == "404" ]]; then
    echo ""
    echo -e "${YELLOW}⚠️ Le realm '${REALM_TO_CHECK}' est introuvable (HTTP 404).${NC}"
    return 1
  elif [[ "$HTTP_CODE" == "401" ]]; then
    echo ""
    echo -e "${RED}❌ Échec d'authentification (HTTP 401). Vérifiez les identifiants Keycloak.${NC}"
    return 2
  else
    echo ""
    echo -e "${RED}❌ Erreur inattendue lors de la vérification du realm (HTTP ${HTTP_CODE}).${NC}"
    return 3
  fi
}

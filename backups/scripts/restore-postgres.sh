#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# === Initialisation ===
detect_environment
load_env_variables
create_pgpass

# === Fonctions de vérification Keycloak ===
wait_for_keycloak_ready() {
  local attempts=0
  local MAX_ATTEMPTS=12 # Paramètres d'attente Keycloak
  local SLEEP_SECONDS=5

  echo -e "${CYAN}⏳ Vérification que Keycloak est prêt (attente max : $((MAX_ATTEMPTS * SLEEP_SECONDS))s)...${NC}"
  echo -e "   (en vérifiant la disponibilité du realm '${KEYCLOAK_ADMIN_REALM}')...${NC}"

  until check_realm_exists "$KEYCLOAK_ADMIN_REALM"; do
    exit_code=$?
    ((attempts++))

    case "$exit_code" in
      0)
        break # Succès, sortir de la boucle
        ;;
      1)
        echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Impossible de contacter Keycloak ou identifiants admin invalides. Keycloak démarre peut-être...${NC}"
        ;;
      2)
        echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Le realm admin '${KEYCLOAK_ADMIN_REALM}' est introuvable. Keycloak n'est probablement pas prêt.${NC}"
        ;;
      3)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur d'authentification (HTTP 401) en vérifiant le realm admin. Token invalide ?${NC}"
        ;;
      4)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur HTTP inattendue lors de la vérification du realm admin.${NC}"
        ;;
      *)
        echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur inconnue (code $exit_code).${NC}"
        ;;
    esac

    if [ "$attempts" -ge "$MAX_ATTEMPTS" ]; then
      echo -e "${RED}❌ Keycloak n'est toujours pas disponible après $((MAX_ATTEMPTS * SLEEP_SECONDS)) secondes.${NC}"
      echo -e "   - Causes possibles : Keycloak non démarré ou identifiants admin incorrects dans le .env.${NC}"
      return 1
    fi

    sleep "$SLEEP_SECONDS"
  done

  echo -e "${GREEN}✅ Keycloak est prêt.${NC}"
}

check_realm_exists() {
  if [[ -z "${1:-}" ]]; then
    echo -e "${RED}❌ Paramètre manquant pour check_realm_exists : nom du realm attendu.${NC}"
    return 255 # Code d'erreur interne
  fi
  local REALM_TO_CHECK="$1"

  # 🔑 Récupérer le token d'accès admin
  local TOKEN_RESPONSE
  TOKEN_RESPONSE=$(curl -s -X POST "${KEYCLOAK_BASE_URL}/realms/${KEYCLOAK_ADMIN_REALM}/protocol/openid-connect/token" \
    -d "client_id=${KEYCLOAK_ADMIN_CLIENT_ID}" \
    -d "username=${KEYCLOAK_ADMIN_USERNAME}" \
    -d "password=${KEYCLOAK_ADMIN_PASSWORD}" \
    -d "grant_type=password")

  local ACCESS_TOKEN
  ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')

  if [[ -z "$ACCESS_TOKEN" ]]; then
    return 1
  fi

  # 🔍 Vérifier le realm
  local HTTP_CODE
  HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' -X GET \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    "${KEYCLOAK_BASE_URL}/admin/realms/${REALM_TO_CHECK}")

  if [[ "$HTTP_CODE" == "200" ]]; then
    return 0 # Succès
  elif [[ "$HTTP_CODE" == "404" ]]; then
    return 2 # Realm non trouvé
  elif [[ "$HTTP_CODE" == "401" ]]; then
    return 3 # Authentification échouée avec le token
  else
    return 4 # Autre erreur HTTP
  fi
}


# === Sélection du dossier de backup ===
BACKUPS_DIR="$PROJECT_ROOT/backups"
BACKUP_DIRS=($(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name scripts | sort -r))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
  echo -e "${RED}❌ Aucun dossier de backup trouvé dans $BACKUPS_DIR${NC}"
  exit 1
fi

echo -e "\n${BLUE}📁 Dossiers de backup disponibles :${NC}\n"
OPTIONS=("${BACKUP_DIRS[@]##*/}" "Annuler")
echo -e "${CYAN}➤ Choisis un dossier avec son numéro :${NC}\n"
select DIR_NAME in "${OPTIONS[@]}"; do
  if [ "$DIR_NAME" = "Annuler" ]; then
    echo -e "\n${RED}❌ Opération annulée.${NC}"
    exit 0
  elif [ -n "$DIR_NAME" ]; then
    SELECTED_BACKUP_DIR="$BACKUPS_DIR/$DIR_NAME"
    echo -e "\n${GREEN}✅ Dossier sélectionné : ${MAGENTA}$SELECTED_BACKUP_DIR${NC}"
    break
  else
    echo -e "\n${RED}⛔ Sélection invalide. Choisis un numéro valide.${NC}"
  fi
done

# === Proposition de backup préventif ===
echo -ne "\n${CYAN}➤ Souhaites-tu faire un backup de l'état actuel avant la restauration ? (Y/n) : ${NC}"
read -r DO_BACKUP
DO_BACKUP=${DO_BACKUP:-y}

if [[ "$DO_BACKUP" == "y" || "$DO_BACKUP" == "Y" ]]; then
  echo -e "\n${YELLOW}Lancement du script de backup avant restauration...${NC}"
  bash "$SCRIPT_DIR/backup-postgres.sh"
fi

# === Détection et sélection des options de restauration ===
LATEST_BACKUP_DIR="$SELECTED_BACKUP_DIR"
declare -A DATABASES
for db_name in "${DATABASES_TO_MANAGE[@]}"; do
  DATABASES["$db_name"]="$LATEST_BACKUP_DIR/$db_name.sql"
done

declare -A DATABASES_TO_RESTORE=()
IMPORT_KC_REALM="n"

echo -e "\n${BLUE}💾 Éléments de restauration disponibles dans le dossier sélectionné :${NC}\n"
for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    echo -e " - ${GREEN}$DB_NAME${NC} (Base de données) ✔"
  fi
done

KEYCLOAK_JSON_IMPORT_FILE="$LATEST_BACKUP_DIR/keycloak-realm.json"
if [ -f "$KEYCLOAK_JSON_IMPORT_FILE" ]; then
  echo -e " - ${GREEN}keycloak-realm.json${NC} (Realm Keycloak) ✔"
fi
echo ""

# --- Sélection des bases de données ---
echo -ne "${CYAN}➤ Restaurer toutes les bases de données détectées ? (Y/n) : ${NC}"
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
      fi
    fi
  fi
done

# --- Sélection de l'import Keycloak ---
if [ -f "$KEYCLOAK_JSON_IMPORT_FILE" ]; then
  echo -ne "${CYAN}➤ Importer le realm Keycloak depuis ${MAGENTA}keycloak-realm.json${CYAN} ? (Y/n) : ${NC}"
  read -r IMPORT_KC_REALM
  IMPORT_KC_REALM=${IMPORT_KC_REALM:-y}
fi

if [ ${#DATABASES_TO_RESTORE[@]} -eq 0 ] && [[ "$IMPORT_KC_REALM" != "y" ]]; then
  echo -e "\n${RED}❌ Rien à restaurer. Opération annulée.${NC}"
  exit 0
fi

# === Résumé et Confirmation Finale ===
echo -e "\n${YELLOW}⚠️ RÉSUMÉ DE L'OPÉRATION DE RESTAURATION ⚠️${NC}"
echo -e "${RED}Les actions suivantes vont être exécutées :${NC}\n"

if [ ${#DATABASES_TO_RESTORE[@]} -gt 0 ]; then
  echo -e "${YELLOW}Les bases de données suivantes seront SUPPRIMÉES et restaurées :${NC}"
  for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
    echo -e " - $DB_NAME"
  done
fi

if [[ "$IMPORT_KC_REALM" == "y" || "$IMPORT_KC_REALM" == "Y" ]]; then
  echo -e "\n${YELLOW}Le realm Keycloak sera importé depuis :${NC}"
  echo -e " - ${MAGENTA}$KEYCLOAK_JSON_IMPORT_FILE${NC}"
fi

echo -ne "\n${CYAN}➤ Confirmer et lancer la restauration ? (y/N) : ${NC}"
read -r CONFIRM_RESTORE
CONFIRM_RESTORE=${CONFIRM_RESTORE:-n}

if [[ "$CONFIRM_RESTORE" != "y" && "$CONFIRM_RESTORE" != "Y" ]]; then
  echo -e "\n${RED}❌ Restauration annulée par l’utilisateur.${NC}"
  exit 0
fi

# === Exécution de la Restauration ===
echo -e "\n${BLUE}🚀 Démarrage de la restauration...${NC}"

# --- Arrêt des services ---
echo -e "\n${BLUE}🛑 Arrêt des services dépendants (FastAPI, Keycloak, OpenFGA)...${NC}"
docker compose stop fastapi keycloak openfga

# --- Démarrage de PostgreSQL ---
echo -e "\n${BLUE}🟡 Démarrage de PostgreSQL...${NC}"
docker compose up -d postgres
echo -e "\n${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
until docker exec postgres_ssl pg_isready -U postgres > /dev/null 2>&1; do
  sleep 2
done
echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"

# --- Restauration des bases de données (sauf Keycloak) ---
declare -A STATUS
if [ ${#DATABASES_TO_RESTORE[@]} -gt 0 ]; then
  echo -e "\n${BLUE}🔄 Restauration des bases de données (Keycloak est traité séparément)...${NC}"
  for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
    if [ "$DB_NAME" == "keycloak" ]; then
      continue
    fi
    FILE_PATH="${DATABASES_TO_RESTORE[$DB_NAME]}"
    echo -e "\n${YELLOW}Traitement de la base '$DB_NAME'...${NC}"
    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();"
    dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"
    createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"
    if psql --set=ON_ERROR_STOP=on -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH"; then
      echo -e "${GREEN}✅ Restauration de '$DB_NAME' réussie.${NC}"
      STATUS["$DB_NAME"]="${GREEN}✅ Restaurée${NC}"
    else
      echo -e "${RED}❌ Erreur lors de la restauration de '$DB_NAME'.${NC}"
      STATUS["$DB_NAME"]="${RED}❌ Échouée${NC}"
    fi
  done
fi

# --- Traitement de Keycloak (Import JSON ou Restauration SQL) ---
# L'import JSON est prioritaire sur la restauration SQL.
if [[ "$IMPORT_KC_REALM" == "y" || "$IMPORT_KC_REALM" == "Y" ]]; then
  echo -e "\n${BLUE}🚀 Restauration de Keycloak via import de realm (JSON)...${NC}"
  echo -e "${YELLOW}Nettoyage de l'état précédent de Keycloak (conteneur et volume)...${NC}"
  docker compose rm -sfv keycloak
  
  echo -e "${YELLOW}Démarrage de Keycloak pour initialisation...${NC}"
  docker compose up -d keycloak

  if ! wait_for_keycloak_ready; then
    echo -e "${RED}❌ Keycloak n'est pas devenu sain. Impossible d'importer le realm.${NC}"
    STATUS["Keycloak"]="${RED}❌ Échoué (Keycloak non sain)${NC}"
  else
    echo -e "${GREEN}✅ Keycloak est sain et prêt pour l'import.${NC}"
    TEMP_REALM_FILE="/tmp/realm.json"
    echo -e "${YELLOW}Copie du fichier realm.json vers le conteneur...${NC}"
    if ! docker cp "$KEYCLOAK_JSON_IMPORT_FILE" keycloak:"$TEMP_REALM_FILE"; then
      echo -e "${RED}❌ Erreur lors de la copie du fichier realm.json.${NC}"
      STATUS["Keycloak"]="${RED}❌ Échoué (copie fichier)${NC}"
    else
      echo -e "${YELLOW}Configuration de kcadm.sh...${NC}"
      docker exec keycloak /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user "$KEYCLOAK_ADMIN_USERNAME" --password "$KEYCLOAK_ADMIN_PASSWORD" > /dev/null
      
      echo -e "${YELLOW}Suppression du realm existant '${KEYCLOAK_REALM}' (pour idempotence)...${NC}"
      docker exec keycloak /opt/keycloak/bin/kcadm.sh delete realms/"$KEYCLOAK_REALM" > /dev/null 2>&1 || true
      echo -e "${GREEN}✅ Ancien realm '${KEYCLOAK_REALM}' supprimé (ou non trouvé).${NC}"

      echo -e "${YELLOW}Importation du nouveau realm '${KEYCLOAK_REALM}'...${NC}"
      if docker exec keycloak /opt/keycloak/bin/kcadm.sh create realms -f "$TEMP_REALM_FILE"; then
        echo -e "${GREEN}✅ Realm '${KEYCLOAK_REALM}' importé avec succès.${NC}"
        STATUS["Keycloak"]="${GREEN}✅ Restauré via import JSON${NC}"
      else
        echo -e "${RED}❌ Erreur lors de l'import du realm '${KEYCLOAK_REALM}'.${NC}"
        STATUS["Keycloak"]="${RED}❌ Échoué (import kcadm)${NC}"
      fi
    fi
  fi
  # Si l'import JSON est fait, on s'assure que le statut de la DB keycloak est cohérent
  if [[ -v DATABASES_TO_RESTORE["keycloak"] ]]; then
      STATUS["keycloak"]="${YELLOW}⏩ Ignorée (import JSON prioritaire)${NC}"
  fi

elif [[ -v DATABASES_TO_RESTORE["keycloak"] ]]; then
  echo -e "\n${BLUE}🚀 Restauration de Keycloak via base de données (SQL)...${NC}"
  echo -e "${YELLOW}Nettoyage de l'état précédent de Keycloak (conteneur et volume)...${NC}"
  docker compose rm -sfv keycloak
  
  echo -e "${YELLOW}Restauration de la base de données 'keycloak'...${NC}"
  dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "keycloak"
  createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "keycloak"
  if psql --set=ON_ERROR_STOP=on -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "keycloak" -f "${DATABASES_TO_RESTORE["keycloak"]}"; then
    echo -e "${GREEN}✅ Restauration de la base de données 'keycloak' réussie.${NC}"
    STATUS["keycloak"]="${GREEN}✅ Restaurée via SQL${NC}"
  else
    echo -e "${RED}❌ Erreur lors de la restauration de la base de données 'keycloak'.${NC}"
    STATUS["keycloak"]="${RED}❌ Échouée (restauration SQL)${NC}"
  fi
else
  # Ni import JSON, ni restauration SQL pour keycloak
  STATUS["Keycloak"]="${YELLOW}⏩ Ignoré${NC}"
fi

# --- Redémarrage des services ---
echo -e "\n${BLUE}🔁 Redémarrage des services (FastAPI, Keycloak, OpenFGA)...${NC}"
if ! docker compose up -d fastapi keycloak openfga; then
  echo -e "\n${YELLOW}⚠️ Certains services ont échoué à démarrer. La suite du script continue…${NC}"
fi

# === Résumé Final ===
echo -e "\n${BLUE}✅ Restauration terminée. Résumé :${NC}\n"
# Initialise status for all potential databases to "Ignorée"
for DB_NAME in "${!DATABASES[@]}"; do
    # Check if the key exists to avoid unbound variable error with "set -u"
    if ! [[ -v STATUS["$DB_NAME"] ]]; then
        STATUS["$DB_NAME"]="${YELLOW}⏩ Ignorée${NC}"
    fi
done

for ITEM in "${!STATUS[@]}"; do
  echo -e " - ${ITEM} : ${STATUS[$ITEM]}"
done | sort


# === Synchronisation FGA_STORE_ID ===
if [[ -n "${STATUS["openfga"]:-}" ]] && [[ "${STATUS["openfga"]}" == "${GREEN}✅ Restaurée${NC}" ]]; then
  echo -e "\n${BLUE}🔄 Synchronisation de FGA_STORE_ID...${NC}"
  OPENFGA_SQL_FILE="$LATEST_BACKUP_DIR/openfga.sql"
  if [ -f "$OPENFGA_SQL_FILE" ]; then
    RESTORED_STORE_ID=$(awk '/^COPY public.store / {getline; print $1}' "$OPENFGA_SQL_FILE" | grep -E '^[0-9A-Z]{26}' | head -n 1 || true)
    if [ -n "$RESTORED_STORE_ID" ]; then
      echo -e "${GREEN}✅ Store ID restauré détecté : $RESTORED_STORE_ID${NC}"
      echo -e "${YELLOW}✏️ Mise à jour de ${MAGENTA}$ENV_FILE${NC}"
      if grep -Eq "^FGA_STORE_ID\s*=" "$ENV_FILE"; then
        sed -i.bak -E "s/^FGA_STORE_ID\s*=.*/FGA_STORE_ID=$RESTORED_STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
      else
        echo -e "\nFGA_STORE_ID=$RESTORED_STORE_ID" >> "$ENV_FILE"
      fi
      echo -e "${GREEN}✅ FGA_STORE_ID mis à jour.${NC}"
    else
      echo -e "${RED}⚠️ Aucun Store ID valide trouvé dans $OPENFGA_SQL_FILE. FGA_STORE_ID non modifié.${NC}"
    fi
  else
    echo -e "${RED}⚠️ Fichier $OPENFGA_SQL_FILE introuvable. FGA_STORE_ID non modifié.${NC}"
  fi
else
  echo -e "\n${YELLOW}⏩ Base 'openfga' non restaurée ou échec, FGA_STORE_ID inchangé.${NC}"
fi
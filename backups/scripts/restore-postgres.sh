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
      0) break ;;
      1) echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Impossible de contacter Keycloak ou identifiants admin invalides. Keycloak démarre peut-être...${NC}" ;;
      2) echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Le realm admin '${KEYCLOAK_ADMIN_REALM}' est introuvable. Keycloak n'est probablement pas prêt.${NC}" ;;
      3) echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur d'authentification (HTTP 401) en vérifiant le realm admin. Token invalide ?${NC}" ;;
      4) echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur HTTP inattendue lors de la vérification du realm admin.${NC}" ;;
      *) echo -e "${RED}   - Tentative ${attempts}/${MAX_ATTEMPTS} : Erreur inconnue (code $exit_code).${NC}" ;;
    esac

    if [ "$attempts" -ge "$MAX_ATTEMPTS" ]; then
      echo -e "${RED}❌ Keycloak n'est toujours pas disponible après $((MAX_ATTEMPTS * SLEEP_SECONDS)) secondes.${NC}"
      return 1
    fi
    sleep "$SLEEP_SECONDS"
  done
  echo -e "${GREEN}✅ Keycloak est prêt.${NC}"
}

check_realm_exists() {
  if [[ -z "${1:-}" ]]; then return 255; fi
  local REALM_TO_CHECK="$1"
  local TOKEN_RESPONSE
  TOKEN_RESPONSE=$(curl -s -X POST "${KEYCLOAK_BASE_URL}/realms/${KEYCLOAK_ADMIN_REALM}/protocol/openid-connect/token" \
    -d "client_id=${KEYCLOAK_ADMIN_CLIENT_ID}" -d "username=${KEYCLOAK_ADMIN_USERNAME}" \
    -d "password=${KEYCLOAK_ADMIN_PASSWORD}" -d "grant_type=password")
  local ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')
  if [[ -z "$ACCESS_TOKEN" ]]; then return 1; fi
  local HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' -X GET -H "Authorization: Bearer ${ACCESS_TOKEN}" "${KEYCLOAK_BASE_URL}/admin/realms/${REALM_TO_CHECK}")
  case "$HTTP_CODE" in
    200) return 0 ;;
    404) return 2 ;;
    401) return 3 ;;
    *) return 4 ;;
  esac
}

# === Sélection du dossier de backup ===
BACKUPS_DIR="$PROJECT_ROOT/backups"
BACKUP_DIRS=($(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name scripts | sort -r))
if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
  echo -e "${RED}❌ Aucun dossier de backup trouvé dans $BACKUPS_DIR${NC}"; exit 1
fi
echo -e "\n${BLUE}📁 Dossiers de backup disponibles :${NC}\n"
select DIR_NAME in "${BACKUP_DIRS[@]##*/}" "Annuler"; do
  if [ "$DIR_NAME" = "Annuler" ]; then echo -e "\n${RED}❌ Opération annulée.${NC}"; exit 0; fi
  if [ -n "$DIR_NAME" ]; then
    SELECTED_BACKUP_DIR="$BACKUPS_DIR/$DIR_NAME"
    echo -e "\n${GREEN}✅ Dossier sélectionné : ${MAGENTA}$SELECTED_BACKUP_DIR${NC}"; break
  else
    echo -e "\n${RED}⛔ Sélection invalide. Choisis un numéro valide.${NC}"
  fi
done

# === Proposition de backup préventif ===
echo -ne "\n${CYAN}➤ Souhaites-tu faire un backup de l'état actuel avant la restauration ? (Y/n) : ${NC}"
read -r DO_BACKUP; DO_BACKUP=${DO_BACKUP:-y}
if [[ "$DO_BACKUP" == "y" || "$DO_BACKUP" == "Y" ]]; then
  echo -e "\n${YELLOW}Lancement du script de backup avant restauration...${NC}"
  bash "$SCRIPT_DIR/backup-postgres.sh"
fi

# === Sélection des options de restauration (par service) ===
declare -A CHOICES
declare -A STATUS

# --- Détection des fichiers disponibles ---
KEYCLOAK_SQL_BACKUP="$SELECTED_BACKUP_DIR/keycloak.sql"
KEYCLOAK_JSON_BACKUP="$SELECTED_BACKUP_DIR/keycloak-realm.json"
KEYCLOAK_JSON_DEV="$PROJECT_ROOT/docker/keycloak/config/realm.json"
OPENFGA_SQL_BACKUP="$SELECTED_BACKUP_DIR/openfga.sql"
# OPENFGA_YAML_BACKUP="$SELECTED_BACKUP_DIR/openfga-store.yaml" # Placeholder for future use
# OPENFGA_YAML_DEV="$PROJECT_ROOT/docker/openfga/config/store.yaml" # Placeholder for future use

echo -e "\n${BLUE}⚙️ Configuration de la restauration...${NC}"

# --- Menu pour Keycloak ---
kc_options=()
[[ -f "$KEYCLOAK_SQL_BACKUP" ]] && kc_options+=("Restaurer depuis SQL du backup")
[[ -f "$KEYCLOAK_JSON_BACKUP" ]] && kc_options+=("Restaurer depuis JSON du backup")
[[ -f "$KEYCLOAK_JSON_DEV" ]] && kc_options+=("Restaurer depuis JSON de dev")
kc_options+=("Ignorer Keycloak" "Annuler")

if [ ${#kc_options[@]} -gt 2 ]; then
  echo -e "\n${CYAN}➤ Comment restaurer Keycloak ?${NC}"
  select opt in "${kc_options[@]}"; do
    case "$opt" in
      "Restaurer depuis SQL du backup") CHOICES["keycloak"]="sql_backup"; break;;
      "Restaurer depuis JSON du backup") CHOICES["keycloak"]="json_backup"; break;;
      "Restaurer depuis JSON de dev") CHOICES["keycloak"]="json_dev"; break;;
      "Ignorer Keycloak") CHOICES["keycloak"]="skip"; break;;
      "Annuler") echo -e "\n${RED}❌ Opération annulée.${NC}"; exit 0;;
      *) echo -e "${RED}⛔ Sélection invalide.${NC}";;
    esac
  done
else
  CHOICES["keycloak"]="skip"
  echo -e "\n${YELLOW}⏩ Aucun fichier de restauration trouvé pour Keycloak, service ignoré.${NC}"
fi

# --- Menu pour OpenFGA (structure prête pour le futur) ---
# Pour l'instant, on utilise une simple question Y/N pour le SQL
if [[ -f "$OPENFGA_SQL_BACKUP" ]]; then
    echo -ne "\n${CYAN}➤ Restaurer la base de données 'openfga' depuis SQL ? (Y/n) : ${NC}"
    read -r restore_openfga; restore_openfga=${restore_openfga:-y}
    if [[ "$restore_openfga" == "y" || "$restore_openfga" == "Y" ]]; then
        CHOICES["openfga"]="sql_backup"
    else
        CHOICES["openfga"]="skip"
    fi
else
    CHOICES["openfga"]="skip"
fi

# --- Menu pour les autres bases de données ---
for db_name in "${DATABASES_TO_MANAGE[@]}"; do
  if [[ "$db_name" == "keycloak" || "$db_name" == "openfga" ]]; then continue; fi
  DB_SQL_BACKUP="$SELECTED_BACKUP_DIR/$db_name.sql"
  if [[ -f "$DB_SQL_BACKUP" ]]; then
    echo -ne "\n${CYAN}➤ Restaurer la base de données '$db_name' depuis SQL ? (Y/n) : ${NC}"
    read -r restore_db; restore_db=${restore_db:-y}
    if [[ "$restore_db" == "y" || "$restore_db" == "Y" ]]; then
        CHOICES["$db_name"]="sql_backup"
    else
        CHOICES["$db_name"]="skip"
    fi
  fi
done

# === Résumé et Confirmation Finale ===
echo -e "\n${YELLOW}⚠️ RÉSUMÉ DE L'OPÉRATION DE RESTAURATION ⚠️${NC}"
echo -e "${RED}Les actions suivantes vont être exécutées :${NC}\n"
ACTION_PLANNED=false
for service in "${!CHOICES[@]}"; do
  choice=${CHOICES[$service]}
  if [[ "$choice" != "skip" ]]; then
    ACTION_PLANNED=true
    description=""
    case "$choice" in
      "sql_backup") description="sera SUPPRIMÉE et restaurée depuis SQL";;
      "json_backup") description="sera réinitialisé et restauré depuis le JSON du backup";;
      "json_dev") description="sera réinitialisé et restauré depuis le JSON de dev";;
    esac
    echo -e " - ${MAGENTA}${service}${NC} : $description"
  fi
done

if ! $ACTION_PLANNED; then
  echo -e "${RED}❌ Rien à restaurer. Opération annulée.${NC}"; exit 0
fi

echo -ne "\n${CYAN}➤ Confirmer et lancer la restauration ? (y/N) : ${NC}"
read -r CONFIRM_RESTORE; CONFIRM_RESTORE=${CONFIRM_RESTORE:-n}
if [[ "$CONFIRM_RESTORE" != "y" && "$CONFIRM_RESTORE" != "Y" ]]; then
  echo -e "\n${RED}❌ Restauration annulée par l’utilisateur.${NC}"; exit 0
fi

# === Exécution de la Restauration ===
echo -e "\n${BLUE}🚀 Démarrage de la restauration...${NC}"
echo -e "\n${BLUE}🛑 Arrêt des services dépendants...${NC}"
docker compose stop fastapi keycloak openfga
echo -e "\n${BLUE}🟡 Démarrage de PostgreSQL...${NC}"
docker compose up -d postgres
echo -e "\n${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
until docker exec postgres_ssl pg_isready -U postgres > /dev/null 2>&1; do sleep 2; done
echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"

# --- Exécution des restaurations SQL ---
for service in "${!CHOICES[@]}"; do
  if [[ "${CHOICES[$service]}" == "sql_backup" ]]; then
    DB_NAME=$service
    FILE_PATH="$SELECTED_BACKUP_DIR/$DB_NAME.sql"
    echo -e "\n${BLUE}🔄 Restauration de '$DB_NAME' depuis SQL...${NC}"
    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();" >/dev/null 2>&1
    dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"
    createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"
    if psql --set=ON_ERROR_STOP=on -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH" >/dev/null; then
      echo -e "${GREEN}✅ Restauration de '$DB_NAME' réussie.${NC}"
      STATUS["$DB_NAME"]="${GREEN}✅ Restaurée (SQL)${NC}"
    else
      echo -e "${RED}❌ Erreur lors de la restauration de '$DB_NAME'.${NC}"
      STATUS["$DB_NAME"]="${RED}❌ Échouée (SQL)${NC}"
    fi
  fi
done

# --- Exécution de la restauration de Keycloak (JSON) ---
if [[ "${CHOICES[keycloak]}" == "json_backup" || "${CHOICES[keycloak]}" == "json_dev" ]]; then
  SOURCE_FILE=""
  SOURCE_DESC=""
  if [[ "${CHOICES[keycloak]}" == "json_backup" ]]; then
    SOURCE_FILE="$KEYCLOAK_JSON_BACKUP"
    SOURCE_DESC="JSON du backup"
  else
    SOURCE_FILE="$KEYCLOAK_JSON_DEV"
    SOURCE_DESC="JSON de dev"
  fi
  
  echo -e "\n${BLUE}🚀 Restauration de Keycloak depuis ${SOURCE_DESC}...${NC}"
  echo -e "${YELLOW}Nettoyage de l'état précédent de Keycloak (conteneur et volume)...${NC}"
docker compose rm -sfv keycloak
  echo -e "${YELLOW}Démarrage de Keycloak pour initialisation...${NC}"
  docker compose up -d keycloak

  if ! wait_for_keycloak_ready; then
    echo -e "${RED}❌ Keycloak n'est pas devenu sain. Impossible d'importer le realm.${NC}"
    STATUS["Keycloak"]="${RED}❌ Échoué (Keycloak non sain)${NC}"
  else
    TEMP_REALM_FILE="/tmp/realm.json"
    if ! docker cp "$SOURCE_FILE" keycloak:"$TEMP_REALM_FILE"; then
      echo -e "${RED}❌ Erreur lors de la copie du fichier realm.json.${NC}"
      STATUS["Keycloak"]="${RED}❌ Échoué (copie fichier)${NC}"
    else
      docker exec keycloak /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user "$KEYCLOAK_ADMIN_USERNAME" --password "$KEYCLOAK_ADMIN_PASSWORD" > /dev/null
      echo -e "${YELLOW}Suppression du realm existant '${KEYCLOAK_REALM}' (pour idempotence)...${NC}"
      docker exec keycloak /opt/keycloak/bin/kcadm.sh delete realms/"$KEYCLOAK_REALM" > /dev/null 2>&1 || true
      echo -e "${YELLOW}Importation du nouveau realm '${KEYCLOAK_REALM}'...${NC}"
      if docker exec keycloak /opt/keycloak/bin/kcadm.sh create realms -f "$TEMP_REALM_FILE"; then
        echo -e "${GREEN}✅ Realm '${KEYCLOAK_REALM}' importé avec succès.${NC}"
        STATUS["Keycloak"]="${GREEN}✅ Restauré (${SOURCE_DESC})${NC}"
      else
        echo -e "${RED}❌ Erreur lors de l'import du realm '${KEYCLOAK_REALM}'.${NC}"
        STATUS["Keycloak"]="${RED}❌ Échoué (import kcadm)${NC}"
      fi
    fi
  fi
fi

# --- Redémarrage des services ---
echo -e "\n${BLUE}🔁 Redémarrage des services restants...${NC}"
if ! docker compose up -d fastapi keycloak openfga; then
  echo -e "\n${YELLOW}⚠️ Certains services ont échoué à démarrer. La suite du script continue…${NC}"
fi

# === Résumé Final ===
echo -e "\n${BLUE}✅ Restauration terminée. Résumé :${NC}\n"
for service in parkigo keycloak openfga; do
    if ! [[ -v STATUS["$service"] ]]; then
        STATUS["$service"]="${YELLOW}⏩ Ignoré${NC}"
    fi
done
for ITEM in "${!STATUS[@]}"; do
  echo -e " - ${ITEM} : ${STATUS[$ITEM]}"
done | sort

# === Synchronisation FGA_STORE_ID ===
if [[ "${STATUS[openfga]}" == "${GREEN}✅ Restaurée (SQL)${NC}" ]]; then
  echo -e "\n${BLUE}🔄 Synchronisation de FGA_STORE_ID...${NC}"
  OPENFGA_SQL_FILE="$SELECTED_BACKUP_DIR/openfga.sql"
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

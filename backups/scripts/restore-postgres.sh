#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# === Vérification des dépendances ===
check_dependencies() {
  local missing_deps=()
  if ! command -v fga &> /dev/null; then
    missing_deps+=("fga (OpenFGA CLI)")
  fi
  if ! command -v jq &> /dev/null; then
    missing_deps+=("jq")
  fi

  if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "${RED}❌ Dépendances manquantes requises pour ce script :${NC}"
    for dep in "${missing_deps[@]}"; do
      echo -e "   - ${YELLOW}${dep}${NC}"
    done
    echo -e "${CYAN}Veuillez les installer pour continuer.${NC}"
    exit 1
  fi
}

# === Initialisation ===
detect_environment
load_env_variables
create_pgpass
check_dependencies

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

wait_for_openfga_ready() {
  local attempts=0
  local MAX_ATTEMPTS=12
  local SLEEP_SECONDS=5
  # L'URL du health check pour le service OpenFGA, utilisant le port correct
  local OPENFGA_HEALTH_URL="http://localhost:8080/healthz" 

  echo -e "${CYAN}⏳ Vérification que OpenFGA est prêt (attente max : $((MAX_ATTEMPTS * SLEEP_SECONDS))s)...${NC}"

  until curl -sf -o /dev/null "$OPENFGA_HEALTH_URL"; do
    ((attempts++))
    if [ "$attempts" -ge "$MAX_ATTEMPTS" ]; then
      echo -e "${RED}❌ OpenFGA n'est toujours pas disponible après $((MAX_ATTEMPTS * SLEEP_SECONDS)) secondes.${NC}"
      return 1
    fi
    echo -e "${YELLOW}   - Tentative ${attempts}/${MAX_ATTEMPTS} : OpenFGA n'est pas encore joignable sur ${OPENFGA_HEALTH_URL}...${NC}"
    sleep "$SLEEP_SECONDS"
  done
  echo -e "${GREEN}✅ OpenFGA est prêt.${NC}"
  return 0
}

# === Fonction pour recréer une base de données ===
recreate_database() {
  local DB_NAME=$1
  if [ -z "$DB_NAME" ]; then
    echo -e "${RED}❌ Nom de base de données non fourni à la fonction recreate_database.${NC}"
    return 1
  fi

  echo -e "\n${BLUE}🔄 Préparation de la base de données '$DB_NAME'...${NC}"
  echo -e "${YELLOW}   - Fermeture des connexions existantes...${NC}"
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();" >/dev/null 2>&1
  
  echo -e "${YELLOW}   - Suppression de la base de données (si elle existe)...${NC}"
  if ! dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"; then
    echo -e "${RED}❌ Échec de la suppression de la base de données '$DB_NAME'. Le script va s'arrêter.${NC}"
    exit 1
  fi
  
  echo -e "${YELLOW}   - Création de la base de données vierge...${NC}"
  if ! createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"; then
    echo -e "${RED}❌ Échec de la création de la base de données '$DB_NAME'. Le script va s'arrêter.${NC}"
    exit 1
  fi
  
  echo -e "${GREEN}✅ Base de données '$DB_NAME' prête.${NC}"
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
    echo -e "\n${GREEN}✅ Dossier sélectionné : ${MAGENTA}$SELECTED_BACKUP_DIR${NC}"
    
    # Tente d'extraire et d'afficher la date et le nom custom du backup
    datetime_part=$(echo "$DIR_NAME" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}')
    if [ -n "$datetime_part" ]; then
        date_part=${datetime_part%_*}
        time_part=${datetime_part#*_}
        time_part_formatted=${time_part//-/:}
        full_date_string="$date_part $time_part_formatted"

        human_readable_date=$(LC_TIME=fr_FR.UTF-8 date -d "$full_date_string" "+%A %e %B %Y - %Hh %Mm %Ss" 2>/dev/null)
        
        if [ -n "$human_readable_date" ]; then
            # Extrait le nom custom (ce qui suit la date)
            custom_name_part=${DIR_NAME#"$datetime_part"}
            custom_name=${custom_name_part#_}

            # Construit la chaîne d'affichage
            display_string="   ${GREEN}Date du backup : ${MAGENTA}$human_readable_date${NC}"
            if [ -n "$custom_name" ]; then
                display_string+=" ${GREEN}[${MAGENTA}$custom_name${GREEN}]${NC}"
            fi
            echo -e "$display_string"
        fi
    fi
    break
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

# --- Détection et affichage des fichiers disponibles ---
echo -e "\n${BLUE}💾 Éléments de restauration disponibles dans le dossier sélectionné :${NC}"
FOUND_FILES=$(find "$SELECTED_BACKUP_DIR" -maxdepth 1 -type f \( -name "*.sql" -o -name "*.json" -o -name "*.yaml" \) | sort)
if [ -z "$FOUND_FILES" ]; then
    echo -e " - ${YELLOW}Aucun fichier de restauration trouvé.${NC}"
else
    while IFS= read -r file; do
        echo -e " - ${GREEN}$(basename "$file")${NC}"
    done <<< "$FOUND_FILES"
fi

# --- Définition des chemins de fichiers ---
KEYCLOAK_SQL_BACKUP="$SELECTED_BACKUP_DIR/keycloak.sql"
KEYCLOAK_JSON_BACKUP="$SELECTED_BACKUP_DIR/keycloak-realm.json"
KEYCLOAK_JSON_DEV="$PROJECT_ROOT/docker/keycloak/config/realm.json"
OPENFGA_SQL_BACKUP="$SELECTED_BACKUP_DIR/openfga.sql"
OPENFGA_YAML_BACKUP="$SELECTED_BACKUP_DIR/openfga-store.yaml"
OPENFGA_YAML_DEV="$PROJECT_ROOT/docker/openfga/config/store.yaml"

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
  # Fallback si aucun fichier n'est trouvé (même pas dev), on ignore
  CHOICES["keycloak"]="skip"
fi

# --- Menu pour OpenFGA ---
fga_options=()
[[ -f "$OPENFGA_SQL_BACKUP" ]] && fga_options+=("Restaurer depuis SQL du backup")
[[ -f "$OPENFGA_YAML_BACKUP" ]] && fga_options+=("Restaurer depuis YAML du backup")
[[ -f "$OPENFGA_YAML_DEV" ]] && fga_options+=("Restaurer depuis YAML de dev")
fga_options+=("Ignorer OpenFGA" "Annuler")

if [ ${#fga_options[@]} -gt 2 ]; then
  echo -e "\n${CYAN}➤ Comment restaurer OpenFGA ?${NC}"
  select opt in "${fga_options[@]}"; do
    case "$opt" in
      "Restaurer depuis SQL du backup") CHOICES["openfga"]="sql_backup"; break;;
      "Restaurer depuis YAML du backup") CHOICES["openfga"]="yaml_backup"; break;;
      "Restaurer depuis YAML de dev") CHOICES["openfga"]="yaml_dev"; break;;
      "Ignorer OpenFGA") CHOICES["openfga"]="skip"; break;;
      "Annuler") echo -e "\n${RED}❌ Opération annulée.${NC}"; exit 0;;
      *) echo -e "${RED}⛔ Sélection invalide.${NC}";;
    esac
  done
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
      "yaml_backup") description="sera réinitialisé et restauré depuis le YAML du backup";;
      "yaml_dev") description="sera réinitialisé et restauré depuis le YAML de dev";;
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
    
    recreate_database "$DB_NAME"

    echo -e "${YELLOW}   - Importation du contenu depuis le fichier SQL...${NC}"
    if psql --set=ON_ERROR_STOP=on -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH" >/dev/null; then
      echo -e "${GREEN}✅ Restauration de '$DB_NAME' depuis SQL réussie.${NC}"
      STATUS["$DB_NAME"]="${GREEN}✅ Restaurée (SQL)${NC}"
    else
      echo -e "${RED}❌ Erreur lors de l'importation SQL pour '$DB_NAME'.${NC}"
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
    STATUS["keycloak"]="${RED}❌ Échoué (Keycloak non sain)${NC}"
  else
    TEMP_REALM_FILE="/tmp/realm.json"
    if ! docker cp "$SOURCE_FILE" keycloak:"$TEMP_REALM_FILE"; then
      echo -e "${RED}❌ Erreur lors de la copie du fichier realm.json.${NC}"
      STATUS["keycloak"]="${RED}❌ Échoué (copie fichier)${NC}"
    else
      docker exec keycloak /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user "$KEYCLOAK_ADMIN_USERNAME" --password "$KEYCLOAK_ADMIN_PASSWORD" > /dev/null
      echo -e "${YELLOW}Suppression du realm existant '${KEYCLOAK_REALM}' (pour idempotence)...${NC}"
      docker exec keycloak /opt/keycloak/bin/kcadm.sh delete realms/"$KEYCLOAK_REALM" > /dev/null 2>&1 || true
      echo -e "${YELLOW}Importation du nouveau realm '${KEYCLOAK_REALM}'...${NC}"
      if docker exec keycloak /opt/keycloak/bin/kcadm.sh create realms -f "$TEMP_REALM_FILE"; then
        echo -e "${GREEN}✅ Realm '${KEYCLOAK_REALM}' importé avec succès.${NC}"
        if [[ "${CHOICES[keycloak]}" == "json_dev" ]]; then
          STATUS["keycloak"]="${GREEN}✅ Rechargé (${SOURCE_DESC})${NC}"
        else
          STATUS["keycloak"]="${GREEN}✅ Restauré (${SOURCE_DESC})${NC}"
        fi
      else
        echo -e "${RED}❌ Erreur lors de l'import du realm '${KEYCLOAK_REALM}'.${NC}"
        STATUS["keycloak"]="${RED}❌ Échoué (import kcadm)${NC}"
      fi
    fi
  fi
fi

# --- Exécution de la restauration d'OpenFGA (YAML) ---
if [[ "${CHOICES[openfga]}" == "yaml_backup" || "${CHOICES[openfga]}" == "yaml_dev" ]]; then
  SOURCE_FILE=""
  SOURCE_DESC=""
  if [[ "${CHOICES[openfga]}" == "yaml_backup" ]]; then
    SOURCE_FILE="$OPENFGA_YAML_BACKUP"
    SOURCE_DESC="YAML du backup"
  else
    SOURCE_FILE="$OPENFGA_YAML_DEV"
    SOURCE_DESC="YAML de dev"
  fi

  echo -e "\n${BLUE}🚀 Restauration/Rechargement d'OpenFGA depuis ${SOURCE_DESC}...${NC}"
  
  # On s'assure que la base de données existe et est vierge avant de continuer
  recreate_database "openfga"

  echo -e "${YELLOW}Nettoyage de l'état précédent d'OpenFGA (conteneur et volume)...${NC}"
  docker compose rm -sfv openfga
  
  # On ne copie que si la source est différente de la destination (cas du backup)
  if [[ "$SOURCE_FILE" != "$OPENFGA_YAML_DEV" ]]; then
    echo -e "${YELLOW}Copie du nouveau fichier de configuration store...${NC}"
    if cp "$SOURCE_FILE" "$OPENFGA_YAML_DEV"; then
      echo -e "${GREEN}✅ Fichier de configuration copié avec succès.${NC}"
      STATUS["openfga"]="${GREEN}✅ Restauré (${SOURCE_DESC})${NC}"
    else
      echo -e "${RED}❌ Erreur lors de la copie du fichier de configuration.${NC}"
      STATUS["openfga"]="${RED}❌ Échoué (copie fichier)${NC}"
    fi
  else
    # Si la source est le fichier de dev, aucune copie n'est nécessaire
    echo -e "${GREEN}✅ Utilisation du fichier de configuration de dev existant.${NC}"
    STATUS["openfga"]="${GREEN}✅ Rechargé (${SOURCE_DESC})${NC}"
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
FGA_RESTORE_STATUS=${STATUS[openfga]:-}
NEW_FGA_STORE_ID=""

# --- Logique pour la restauration SQL ---
if [[ "$FGA_RESTORE_STATUS" == "${GREEN}✅ Restaurée (SQL)${NC}" ]]; then
  echo -e "\n${BLUE}🔄 Synchronisation de FGA_STORE_ID depuis le backup SQL...${NC}"
  OPENFGA_SQL_FILE="$SELECTED_BACKUP_DIR/openfga.sql"
  if [ -f "$OPENFGA_SQL_FILE" ]; then
    NEW_FGA_STORE_ID=$(awk '/^COPY public.store / {getline; print $1}' "$OPENFGA_SQL_FILE" | grep -E '^[0-9A-Z]{26}' | head -n 1 || true)
    if [ -z "$NEW_FGA_STORE_ID" ]; then
      echo -e "${RED}⚠️ Aucun Store ID valide trouvé dans $OPENFGA_SQL_FILE.${NC}"
    fi
  else
    echo -e "${RED}⚠️ Fichier $OPENFGA_SQL_FILE introuvable pour extraire le Store ID.${NC}"
  fi
# --- Logique pour la restauration YAML ---
elif [[ "$FGA_RESTORE_STATUS" == *"${GREEN}✅"* ]]; then # Catches both "Rechargé" and "Restauré"
  echo -e "\n${BLUE}🔄 Importation du modèle OpenFGA et synchronisation du FGA_STORE_ID...${NC}"
  if ! wait_for_openfga_ready; then
    echo -e "${RED}❌ OpenFGA n'est pas disponible. Impossible d'importer le modèle.${NC}"
  else
    # Détermine quel fichier YAML utiliser pour l'importation
    IMPORT_FILE=""
    if [[ "$FGA_RESTORE_STATUS" == *"YAML de dev"* ]]; then
      IMPORT_FILE="$OPENFGA_YAML_DEV"
    else
      IMPORT_FILE="$OPENFGA_YAML_BACKUP"
    fi
    
    echo -e "${YELLOW}   - Importation depuis le fichier ${MAGENTA}$(basename "$IMPORT_FILE")...${NC}"
    
    # On désactive temporairement l'arrêt sur erreur pour gérer l'échec manuellement
    set +e
    # On s'assure que FGA_STORE_ID est vide pour forcer la création d'un nouveau store
    IMPORT_OUTPUT=$(FGA_API_URL="http://localhost:8080" FGA_STORE_ID="" fga store import --file "$IMPORT_FILE" 2>&1)
    EXIT_CODE=$?
    set -e # On réactive l'arrêt sur erreur

    echo -e "${CYAN}DEBUG: Output from 'fga store import':${NC}"
    echo "$IMPORT_OUTPUT"
    echo -e "${CYAN}DEBUG: End of output from 'fga store import'.${NC}"
    
    if [ $EXIT_CODE -ne 0 ]; then
      echo -e "${RED}❌ La commande 'fga store import' a échoué (code: $EXIT_CODE).${NC}"
      echo -e "${RED}   Erreur retournée :${NC}
$IMPORT_OUTPUT"
      NEW_FGA_STORE_ID=""
    elif [ -z "$IMPORT_OUTPUT" ]; then
      echo -e "${RED}❌ La commande 'fga store import' a réussi mais n'a rien retourné.${NC}"
      NEW_FGA_STORE_ID=""
    else
      # La commande a réussi, on tente de parser le JSON en toute sécurité
      set +e
      NEW_FGA_STORE_ID=$(jq -r '.store.id' <<< "$IMPORT_OUTPUT" 2>/dev/null)
      JQ_EXIT_CODE=$?
      set -e

      if [ $JQ_EXIT_CODE -ne 0 ] || [ -z "$NEW_FGA_STORE_ID" ] || [ "$NEW_FGA_STORE_ID" == "null" ]; then
        # Fallback extraction using grep and sed
        FALLBACK_FGA_STORE_ID=$(echo "$IMPORT_OUTPUT" | grep -o '"id":"[^"]*"' | head -n 1 | sed 's/"id":"\([^"]*\)"/\1/' || true)
        if [ -n "$FALLBACK_FGA_STORE_ID" ]; then
          echo -e "${GREEN}✅ Store ID extrait avec grep/sed : $FALLBACK_FGA_STORE_ID${NC}"
          NEW_FGA_STORE_ID="$FALLBACK_FGA_STORE_ID"
        else
          echo -e "${RED}❌ Impossible d'extraire le nouveau Store ID depuis la sortie JSON.${NC}"
          echo -e "   Sortie reçue : $IMPORT_OUTPUT"
          echo -e "${RED}❌ Échec de l'extraction avec grep/sed également.${NC}"
          NEW_FGA_STORE_ID=""
        fi
      fi
    fi
  fi
else
  echo -e "\n${YELLOW}⏩ Base 'openfga' non restaurée ou échec, FGA_STORE_ID inchangé.${NC}"
fi

# --- Mise à jour du fichier .env si un nouvel ID a été trouvé ---
if [ -n "$NEW_FGA_STORE_ID" ]; then
  echo -e "${GREEN}✅ Nouveau Store ID détecté : $NEW_FGA_STORE_ID${NC}"
  echo -e "${YELLOW}✏️ Mise à jour de ${MAGENTA}$ENV_FILE${NC}"
  if grep -Eq "^FGA_STORE_ID\s*=" "$ENV_FILE"; then
    sed -i.bak -E "s/^FGA_STORE_ID\s*=.*/FGA_STORE_ID=$NEW_FGA_STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
  else
    echo -e "\nFGA_STORE_ID=$NEW_FGA_STORE_ID" >> "$ENV_FILE"
  fi
  echo -e "${GREEN}✅ FGA_STORE_ID mis à jour.${NC}"
elif [[ "$FGA_RESTORE_STATUS" == *"${GREEN}✅"* ]]; then
  # Ce cas se produit si la restauration a réussi mais que la récupération de l'ID a échoué
  echo -e "${RED}⚠️ La restauration d'OpenFGA a réussi, mais la synchronisation du Store ID a échoué. Votre application pourrait ne pas fonctionner.${NC}"
fi

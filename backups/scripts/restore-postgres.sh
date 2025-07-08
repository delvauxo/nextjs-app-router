#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# === Initialisation ===
detect_environment
load_env_variables
create_pgpass

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

# --- Restauration des bases de données ---
declare -A STATUS
if [ ${#DATABASES_TO_RESTORE[@]} -gt 0 ]; then
  echo -e "\n${BLUE}🔄 Restauration des bases de données...${NC}"
  for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
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

# --- Import du realm Keycloak ---
if [[ "$IMPORT_KC_REALM" == "y" || "$IMPORT_KC_REALM" == "Y" ]]; then
  echo -e "\n${BLUE}🚀 Import du realm Keycloak depuis JSON...${NC}"
  echo -e "${YELLOW}Démarrage de Keycloak pour préparer l'import...${NC}"
  docker compose up -d keycloak
  echo -e "${YELLOW}Création du dossier d'import dans le conteneur Keycloak...${NC}"
  docker exec keycloak mkdir -p /opt/keycloak/data/import
  echo -e "${YELLOW}Copie du fichier realm.json...${NC}"
  docker cp "$KEYCLOAK_JSON_IMPORT_FILE" keycloak:/opt/keycloak/data/import/realm.json
  echo -e "${YELLOW}Redémarrage de Keycloak pour forcer l'import...${NC}"
  docker compose restart keycloak
  echo -e "${GREEN}✅ Realm JSON copié. Keycloak redémarre pour un import automatique.${NC}"
  STATUS["Keycloak Realm"]="${GREEN}✅ Importé${NC}"
else
  STATUS["Keycloak Realm"]="${YELLOW}⏩ Ignoré${NC}"
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



source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# === Détection de l’environnement ===
detect_environment

# === Choix du fichier .env selon APP_ENV ===
load_env_variables

# === Génération d’un fichier .pgpass temporaire sécurisé ===
create_pgpass

# === Sélection interactive du dossier de backup ===
BACKUPS_DIR="$PROJECT_ROOT/backups"
BACKUP_DIRS=($(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name scripts | sort -r))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
  echo -e "${RED}❌ Aucun dossier de backup trouvé dans $BACKUPS_DIR${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}📁 Dossiers de backup disponibles :${NC}"
echo ""

OPTIONS=("${BACKUP_DIRS[@]##*/}" "Annuler")

echo -e "${CYAN}➤ Choisis un dossier avec son numéro :${NC}"
echo ""
select DIR_NAME in "${OPTIONS[@]}"; do
  if [ "$DIR_NAME" = "Annuler" ]; then
    echo ""
    echo -e "${RED}❌ Opération annulée.${NC}"
    exit 0
  elif [ -n "$DIR_NAME" ]; then
    SELECTED_BACKUP_DIR="$BACKUPS_DIR/$DIR_NAME"
    echo ""
    echo -e "${GREEN}✅ Dossier sélectionné : ${MAGENTA}$SELECTED_BACKUP_DIR${NC}"
    break
  else
    echo ""
    echo -e "${RED}⛔ Sélection invalide. Choisis un numéro valide.${NC}"
  fi
done

# === Proposition de backup préventif ===
echo ""
echo -ne "${CYAN}➤ Souhaites-tu faire un backup de l'état actuel avant la restauration ? (Y/n) : ${NC}"
read -r DO_BACKUP
DO_BACKUP=${DO_BACKUP:-y}

if [[ "$DO_BACKUP" == "y" || "$DO_BACKUP" == "Y" ]]; then
  echo ""
  echo -e "${YELLOW}Lancement du script de backup avant restauration...${NC}"
  bash "$SCRIPT_DIR/backup-postgres.sh"
fi

# === Bases à restaurer et sélection interactive ===
LATEST_BACKUP_DIR="$SELECTED_BACKUP_DIR"
declare -A DATABASES=(
  ["$POSTGRES_DATABASE"]="$LATEST_BACKUP_DIR/$POSTGRES_DATABASE.sql"
  ["keycloak"]="$LATEST_BACKUP_DIR/keycloak.sql"
  ["openfga"]="$LATEST_BACKUP_DIR/openfga.sql"
)

declare -A DATABASES_TO_RESTORE=()

echo ""
echo -e "${BLUE}💾 Bases à restaurer détectées :${NC}"
echo ""
for DB_NAME in "${!DATABASES[@]}"; do
  FILE_PATH="${DATABASES[$DB_NAME]}"
  if [ -f "$FILE_PATH" ]; then
    echo -e " - ${GREEN}$DB_NAME${NC} ✔  ${MAGENTA}($FILE_PATH)${NC}"
  else
    echo -e " - ${YELLOW}$DB_NAME${NC} ⚠  ${MAGENTA}($FILE_PATH)${NC}"
  fi
done

echo ""
echo -ne "${CYAN}➤ Tout restaurer sans sélection individuelle ? (Y/n) : ${NC}"
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
      else
        echo -e "   ⏩ ${YELLOW}Ignorée${NC}"
      fi
    fi
  fi
done

if [ ${#DATABASES_TO_RESTORE[@]} -eq 0 ]; then
  echo ""
  echo -e "${RED}❌ Aucune base sélectionnée pour la restauration. Opération annulée.${NC}"
  exit 0
fi

# === Confirmation finale avant suppression/restauration des bases sélectionnées ===
echo ""
echo -e "${RED}⚠️ Attention : les bases suivantes vont être SUPPRIMÉES puis RESTAURÉES :${NC}"
echo ""
for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
  echo -e " - $DB_NAME"
done
echo ""
echo -ne "${CYAN}➤ Confirmer la restauration ? (y/N) : ${NC}"
read -r CONFIRM_RESTORE
CONFIRM_RESTORE=${CONFIRM_RESTORE:-n}

if [[ "$CONFIRM_RESTORE" != "y" && "$CONFIRM_RESTORE" != "Y" ]]; then
  echo ""
  echo -e "${RED}❌ Restauration annulée par l’utilisateur.${NC}"
  exit 0
fi

# === Arrêt temporaire des services dépendants ===
echo ""
echo -e "${BLUE}🛑 Arrêt des services FastAPI, Keycloak et OpenFGA...${NC}"
echo ""
docker compose stop fastapi keycloak openfga

# === Démarrage de PostgreSQL seul ===
echo ""
echo -e "${BLUE}🟡 Démarrage temporaire de PostgreSQL pour la restauration...${NC}"
echo ""
docker compose up -d postgres

echo ""
echo -e "${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
echo ""
until docker exec postgres_ssl pg_isready -U postgres > /dev/null 2>&1; do
  sleep 2
done
echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"

# === Restauration ===
echo ""
echo -e "${BLUE}🚀 Démarrage de la restauration...${NC}"
echo ""

declare -A STATUS
declare -A MISSING_BY_DB

for DB_NAME in "${!DATABASES_TO_RESTORE[@]}"; do
  FILE_PATH="${DATABASES_TO_RESTORE[$DB_NAME]}"
  echo -e "${YELLOW}⚠️ Déconnexion des connexions actives sur la base '$DB_NAME'...${NC}"
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();
  "
  echo -e "${YELLOW}🔄 Suppression + recréation de la base '$DB_NAME'...${NC}"
  dropdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" --if-exists "$DB_NAME"
  createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$DB_NAME"
  echo -e "${YELLOW}📥 Restauration depuis le fichier : ${MAGENTA}$FILE_PATH${NC}"
  
  RESTORE_SUCCESS=true
  if ! psql --set=ON_ERROR_STOP=on -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$DB_NAME" -f "$FILE_PATH"; then
    echo ""
    echo -e "${RED}❌ Erreur lors de la restauration de la base '${YELLOW}$DB_NAME${RED}'.${NC}"
    echo ""
    echo -e "${RED}➡️ Vérifie le fichier de backup pour voir l’origine du problème : ${MAGENTA}$FILE_PATH${NC}"
    RESTORE_SUCCESS=false
  fi

  # === Validation dynamique de la structure et du contenu post-restauration ===
  echo ""
  echo -e "${CYAN}🔍 Vérification de l’intégrité post-restauration de la base '${YELLOW}$DB_NAME${CYAN}'...${NC}"
  echo ""

  FAILED_VALIDATION=false
  FOUND_TABLES=()
  MISSING_TABLES=()
  EMPTY_TABLES=()

  for TABLE in assertion authorization_model changelog goose_db_version store tuple; do
    # 1️⃣ Vérifier l’existence de la table
    EXISTS=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" \
      -U "$POSTGRES_USER" -d "$DB_NAME" \
      -tAc "SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='${TABLE}';" | xargs)

    if [[ "$EXISTS" != "1" ]]; then
      MISSING_TABLES+=("$TABLE")
      echo -e "${RED}❌ Table manquante après restauration : ${YELLOW}$TABLE${NC}"
      FAILED_VALIDATION=true
      continue
    fi

    FOUND_TABLES+=("$TABLE")

    # 2️⃣ Vérifier si elle contient des lignes
    ROW_COUNT=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" \
      -U "$POSTGRES_USER" -d "$DB_NAME" \
      -tAc "SELECT count(*) FROM public.\"$TABLE\";" | xargs)

    if [[ "$ROW_COUNT" -eq 0 ]]; then
      EMPTY_TABLES+=("$TABLE")
      echo -e "${YELLOW}⚠️ Table créée mais vide : ${TABLE}${NC}"
      # pas de FAILED_VALIDATION ici, on autorise les tables vides
    fi
  done

  # 3️⃣ Rapport synthétique pour cette base
  echo ""
  if [ ${#MISSING_TABLES[@]} -gt 0 ]; then
    echo -e "${RED}📉 Tables totalement manquantes : ${YELLOW}${MISSING_TABLES[*]}${NC}"
  fi
  if [ ${#EMPTY_TABLES[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️ Tables vides : ${EMPTY_TABLES[*]}${NC}"
  fi

  # 4️⃣ Détermination du statut final
  if [ ${#MISSING_TABLES[@]} -gt 0 ]; then
    STATUS["$DB_NAME"]="${RED}❌ Restauration incomplète${NC}"
  elif [[ "$RESTORE_SUCCESS" == true ]]; then
    STATUS["$DB_NAME"]="${GREEN}✅ Restaurée${NC}"
  else
    STATUS["$DB_NAME"]="${RED}❌ Échec de la restauration (tables existantes)${NC}"
  fi

  # 5️⃣ Conserver la liste des tables manquantes pour le résumé final
  MISSING_BY_DB["$DB_NAME"]="${MISSING_TABLES[*]}"

  echo ""

done


# === Redémarrage des services dépendants ===
echo ""
echo -e "${BLUE}🔁 Redémarrage des services FastAPI, Keycloak et OpenFGA...${NC}"
echo ""
if ! docker compose up -d fastapi keycloak openfga; then
  echo -e "${YELLOW}⚠️ Certains services (ex: migrate) ont échoué à démarrer. La suite du script continue…${NC}"
fi

# === Résumé ===
echo ""
echo -e "${BLUE}✅ Restauration terminée. Résumé :${NC}"
echo ""

for DB_NAME in "${!DATABASES[@]}"; do
  STATUS_MSG=${STATUS[$DB_NAME]:-${YELLOW}⏩ Ignorée${NC}}
  echo -e " - ${DB_NAME} : ${STATUS_MSG}"
  if [[ "${STATUS_MSG}" != *"✅ Restaurée"* ]]; then
    MISSING="${MISSING_BY_DB[$DB_NAME]:-}"
    if [[ -n "$MISSING" ]]; then
      echo -e "     ${RED}📉 Tables manquantes:${NC} ${YELLOW}$MISSING${NC}"
    fi
  fi
done

# === Synchronisation automatique du FGA_STORE_ID restauré si la base openfga a été restaurée ===
if [[ -n "${STATUS["openfga"]+x}" ]]; then
  echo ""
  echo -e "${BLUE}🔄 Synchronisation de FGA_STORE_ID depuis la base restaurée 'openfga'...${NC}"

  OPENFGA_SQL_FILE="$LATEST_BACKUP_DIR/openfga.sql"

  if [ -f "$OPENFGA_SQL_FILE" ]; then
    RESTORED_STORE_ID=$(awk '/^COPY public.store / {getline; print $1}' "$OPENFGA_SQL_FILE" | grep -E '^[0-9A-Z]{26}$' | head -n 1 || true)

    if [ -n "$RESTORED_STORE_ID" ]; then
      echo -e "${GREEN}✅ Store restauré détecté : $RESTORED_STORE_ID${NC}"
      echo -e "${YELLOW}✏️ Mise à jour de ${MAGENTA}$ENV_FILE${YELLOW} avec FGA_STORE_ID=$RESTORED_STORE_ID...${NC}"
      if grep -Eq "^FGA_STORE_ID\s*=" "$ENV_FILE"; then
        sed -i.bak -E "s/^FGA_STORE_ID\s*=.*/FGA_STORE_ID=$RESTORED_STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
        echo -e "${GREEN}✅ Variable FGA_STORE_ID mise à jour dans ${MAGENTA}$ENV_FILE${NC}"
      else
        echo -e "\nFGA_STORE_ID=$RESTORED_STORE_ID" >> "$ENV_FILE"
        echo -e "${GREEN}➕ Variable FGA_STORE_ID ajoutée à ${MAGENTA}$ENV_FILE${NC}"
      fi
    else
      echo -e "${RED}⚠️ Aucun store valide trouvé dans $OPENFGA_SQL_FILE. FGA_STORE_ID non modifié.${NC}"
    fi
  else
    echo -e "${RED}⚠️ Fichier $OPENFGA_SQL_FILE introuvable. FGA_STORE_ID non modifié.${NC}"
  fi
else
  echo ""
  echo -e "${YELLOW}⏩ Base 'openfga' non restaurée, FGA_STORE_ID inchangé.${NC}"
fi
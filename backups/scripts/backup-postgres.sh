source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# === Paramètres d'attente Keycloak ===
MAX_ATTEMPTS=12
SLEEP_SECONDS=5

# === Détection de l’environnement ===
detect_environment

# === Choix du fichier .env selon APP_ENV ===
load_env_variables

# === Realm Keycloak ===
REALM_NAME="${KEYCLOAK_REALM:-nextjs-dashboard}"

# === Création conditionnelle du .pgpass ===
if [[ -z "${PGPASSFILE-}" || ! -f "$PGPASSFILE" ]]; then
  create_pgpass
else
  echo -e "${GREEN}✅ Utilisation du fichier .pgpass existant : ${MAGENTA}$PGPASSFILE${NC}"
fi

# === Container PostgreSQL ===
CONTAINER_NAME=postgres_ssl

if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo ""
  echo -e "${YELLOW}🔄 Lancement du container PostgreSQL...${NC}"
  echo ""
  docker compose up -d postgres
  echo ""
  echo -e "${CYAN}⏳ Attente de la disponibilité de PostgreSQL...${NC}"
  until docker exec "$CONTAINER_NAME" pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; do sleep 2; done
  echo ""
  echo -e "${GREEN}✅ PostgreSQL est prêt.${NC}"
else
  echo ""
  echo -e "${GREEN}✅ Container PostgreSQL déjà actif.${NC}"
fi

# === Vérification de la présence du fichier realm.json pour le montage ===
REALM_FILE="./docker/keycloak/config/realm.json"

if [[ ! -f "$REALM_FILE" ]]; then
  echo ""
  echo -e "${YELLOW}⚠️ Attention : le fichier realm.json n'existe pas (${REALM_FILE})."
  echo -e "   Le montage du fichier dans le container Keycloak ne pourra pas se faire."
  echo -e "   Keycloak démarrera sans import automatique de configuration.${NC}"
  
  # Optionnel : modifier dynamiquement le fichier docker-compose.yml ou docker-compose override 
  # pour commenter le montage realm.json.
else
  echo -e "${GREEN}✅ Fichier realm.json détecté, import automatique possible.${NC}"
fi

# === Container Keycloak ===
KC_CONTAINER=keycloak

if ! docker ps --format '{{.Names}}' | grep -q "^$KC_CONTAINER$"; then
  echo ""
  echo -e "${YELLOW}🔄 Lancement du container Keycloak...${NC}"
  echo ""
  docker compose up -d keycloak
else
  echo -e "${GREEN}✅ Container Keycloak déjà actif.${NC}"
fi

# === Vérification du realm (avec attente progressive) ===
if ! wait_for_realm_ready; then
  exit 1
fi

# === Bases à sauvegarder ===
DATABASES=("openfga" "$POSTGRES_DATABASE" "keycloak")

echo ""
echo -e "💾 ${BLUE}Liste des bases de données SQL à sauvegarder :${NC}"
echo ""
for db in "${DATABASES[@]}"; do
  echo -e "   - $db"
done
echo ""
echo -ne "${CYAN}➤ Sauvegarder toutes les bases ? (Y/n) : ${NC}"
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
  exit 1
fi

# === Affichage taille réelle des fichiers dumps ===
echo ""
echo -e "${BLUE}📊 Tailles réelles des dumps :${NC}"
echo ""
for DB in "${SELECTED_DATABASES[@]}"; do
  file_size=$(du -h "$BACKUP_DIR/$DB.sql" | cut -f1)
  echo -e "   - $DB ➜ $file_size"
done

echo ""
echo -ne "${CYAN}➤ Exporter la configuration Keycloak (realm '$REALM_NAME') au format JSON ? (Y/n) : ${NC}"
read -r EXPORT_REALM
EXPORT_REALM=${EXPORT_REALM:-y}

if [[ "$EXPORT_REALM" =~ ^[yY]$ ]]; then
  if ! docker ps --format '{{.Names}}' | grep -q "^keycloak$"; then
    echo -e "${YELLOW}⚠️ Le container 'keycloak' n'est pas actif, export Keycloak ignoré.${NC}"
  elif ! check_realm_exists "$REALM_NAME"; then
    echo -e "${RED}❌ Le realm '$REALM_NAME' n'existe PAS dans Keycloak.${NC}"
    echo -e "${YELLOW}⚠️ Keycloak semble vierge ou non configuré.${NC}"
    echo -e "${YELLOW}   Vérifiez que Keycloak est bien initialisé avec ce realm avant de faire l'export.${NC}"
  else
    echo -e "${YELLOW}📦 Export Keycloak realm '$REALM_NAME'...${NC}"
    echo ""
    if docker exec keycloak /opt/keycloak/bin/kc.sh export --realm "$REALM_NAME" --file /tmp/keycloak-realm.json; then
      if docker exec keycloak test -f /tmp/keycloak-realm.json; then
        docker cp keycloak:/tmp/keycloak-realm.json "$BACKUP_DIR/keycloak-realm.json" \
          && echo "" \
          && echo -e "${GREEN}✅ Export Keycloak sauvegardé dans : ${MAGENTA}$BACKUP_DIR/keycloak-realm.json${NC}" \
          && docker exec keycloak rm /tmp/keycloak-realm.json \
          || echo -e "${RED}❌ Erreur lors de la copie du fichier exporté Keycloak.${NC}"
      else
        echo -e "${YELLOW}⚠️ Fichier export Keycloak introuvable dans le container, export ignoré.${NC}"
      fi
    else
      echo -e "${RED}❌ Erreur lors de l’export du realm Keycloak dans le container.${NC}"
    fi
  fi
else
  echo -e "${YELLOW}⚠️ Export Keycloak realm ignoré.${NC}"
fi

echo ""
echo -e "${GREEN}✅ Sauvegarde terminée avec succès dans : ${MAGENTA}$BACKUP_DIR${NC}"

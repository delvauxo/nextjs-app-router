#!/bin/bash
set -e

FILE_PATH="/import/config/store.yaml"
OPENFGA_HOST="http://openfga:8080"
ENV_FILE="/app/.env.local"

echo "⏳ Attente de la disponibilité d'OpenFGA..."
until curl -s "$OPENFGA_HOST/healthz" | grep '"SERVING"' > /dev/null; do
  sleep 2
done
echo "✅ OpenFGA est prêt."

REUSE_STORE=false
STORE_ID=""

# Vérifie si une valeur FGA_STORE_ID existe dans le .env.local
if grep -q "^FGA_STORE_ID=" "$ENV_FILE"; then
  CURRENT_STORE_ID=$(grep "^FGA_STORE_ID=" "$ENV_FILE" | cut -d'=' -f2)
  echo "🔍 FGA_STORE_ID trouvé dans .env.local : $CURRENT_STORE_ID"

  # Vérifie que ce store existe dans OpenFGA
  STORE_CHECK=$(curl -s "$OPENFGA_HOST/stores/$CURRENT_STORE_ID")
  if echo "$STORE_CHECK" | grep -q "\"id\":\"$CURRENT_STORE_ID\""; then
    echo "✅ Store $CURRENT_STORE_ID est valide. Réutilisation."
    REUSE_STORE=true
    STORE_ID=$CURRENT_STORE_ID
  else
    echo "❌ Store $CURRENT_STORE_ID n'existe pas dans OpenFGA. Création d'un nouveau store."
  fi
fi

if [ "$REUSE_STORE" = false ]; then
  echo "🛠️ Création d'un nouveau store..."
  STORE_RESPONSE=$(fga --api-url "$OPENFGA_HOST" store create --name "parkigo-store")
  STORE_ID=$(echo "$STORE_RESPONSE" | grep -oE '"id":"[^"]+"' | cut -d':' -f2 | tr -d '"')
  echo "✅ Nouveau store créé : $STORE_ID"

  echo "📦 Import du modèle dans le store..."
  fga --api-url "$OPENFGA_HOST" store import --store-id "$STORE_ID" --file "$FILE_PATH"
  echo "✅ Modèle importé dans le store $STORE_ID"

  # Mise à jour propre de la variable dans .env.local
  if grep -q "^FGA_STORE_ID=" "$ENV_FILE"; then
    sed -i "s/^FGA_STORE_ID=.*/FGA_STORE_ID=$STORE_ID/" "$ENV_FILE"
  else
    echo -e "\nFGA_STORE_ID=$STORE_ID" >> "$ENV_FILE"
  fi

  echo "📝 .env.local mis à jour avec FGA_STORE_ID=$STORE_ID"
else
  echo "ℹ️ Pas besoin de créer un nouveau store."
fi
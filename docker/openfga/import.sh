#!/bin/bash
set -e

FILE_PATH="/import/open-fga.yaml"
OPENFGA_HOST="http://openfga:8080"

# Attente que le service OpenFGA soit prêt
echo "⏳ Attente de la disponibilité d'OpenFGA..."
until curl -s "$OPENFGA_HOST/healthz" | grep '"SERVING"' > /dev/null; do
  sleep 2
done
echo "✅ OpenFGA est prêt."

# Création du store
echo "🛠️ Création d'un nouveau store..."
STORE_RESPONSE=$(fga --api-url "$OPENFGA_HOST" store create --name "parkigo-store")
STORE_ID=$(echo "$STORE_RESPONSE" | grep -oE '"id":"[^"]+"' | cut -d':' -f2 | tr -d '"')
echo "✅ Nouveau store créé avec ID : $STORE_ID"

# Import du modèle
echo "📦 Import du fichier $FILE_PATH dans le store..."
fga --api-url "$OPENFGA_HOST" store import --store-id "$STORE_ID" --file "$FILE_PATH"
echo "✅ Import terminé dans le store $STORE_ID"

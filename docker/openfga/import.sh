#!/bin/bash
set -e

FILE_PATH="/import/open-fga.yaml"
OPENFGA_HOST="http://openfga:8080"
OUTPUT_DIR="/output"
OUTPUT_JSON="$OUTPUT_DIR/store.json"

# Attente que le service OpenFGA soit prêt
echo "⏳ Attente de la disponibilité d'OpenFGA..."
until curl -s "$OPENFGA_HOST/healthz" | grep '"SERVING"' > /dev/null; do
  sleep 2
done
echo "✅ OpenFGA est prêt."

# Création du dossier output même si le fichier n'existe pas encore
echo "📁 Vérification ou création du dossier $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

REUSE_STORE=false

if [ -f "$OUTPUT_JSON" ]; then
  STORE_ID=$(grep -oE '"FGA_STORE_ID"\s*:\s*"[^"]+"' "$OUTPUT_JSON" | cut -d':' -f2 | tr -d ' "')
  echo "🔍 store.json trouvé, tentative de réutilisation du STORE_ID : $STORE_ID"

  # Vérifie que le store existe réellement
  STORE_CHECK=$(curl -s "$OPENFGA_HOST/stores/$STORE_ID")
  if echo "$STORE_CHECK" | grep -q "\"id\":\"$STORE_ID\""; then
    echo "✅ Store $STORE_ID confirmé valide dans OpenFGA. Réutilisation."
    REUSE_STORE=true
  else
    echo "❌ Le store ID n'existe plus dans OpenFGA. Recréation nécessaire."
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

  echo "📝 Enregistrement du store ID dans $OUTPUT_JSON"
  echo "{\"FGA_STORE_ID\": \"$STORE_ID\"}" > "$OUTPUT_JSON"
fi

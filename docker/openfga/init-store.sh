#!/bin/bash
set -e

APP_ENV=${APP_ENV:-development}
FORCE_IMPORT=${FORCE_IMPORT:-false}
ALLOW_CREATE=${ALLOW_CREATE:-false}

echo "🔧 Environnement détecté : $APP_ENV"
if [ "$APP_ENV" = "production" ]; then
  echo "⚠️⚠️⚠️  Attention : script exécuté en environnement de production !"
fi

FILE_PATH="/import/config/store.yaml"
OPENFGA_HOST="http://openfga:8080"

# Choix du bon fichier .env selon l’environnement
if [ "$APP_ENV" = "production" ]; then
  ENV_FILE="/app/.env.production"
else
  ENV_FILE="/app/.env.local"
fi

echo "Attente de la disponibilité d'OpenFGA..."
until curl -s "$OPENFGA_HOST/healthz" | grep '"SERVING"' > /dev/null; do
  sleep 2
done
echo "✅ OpenFGA est prêt."

REUSE_STORE=false
STORE_ID=""

# Vérifie si une valeur FGA_STORE_ID existe dans le .env
if grep -q "^FGA_STORE_ID=" "$ENV_FILE"; then
  CURRENT_STORE_ID=$(grep "^FGA_STORE_ID=" "$ENV_FILE" | cut -d'=' -f2)
  echo "FGA_STORE_ID trouvé dans $ENV_FILE : $CURRENT_STORE_ID"

  STORE_CHECK=$(curl -s "$OPENFGA_HOST/stores/$CURRENT_STORE_ID")
  if echo "$STORE_CHECK" | grep -q "\"id\":\"$CURRENT_STORE_ID\""; then
    echo "✅ Store $CURRENT_STORE_ID est valide. Réutilisation."
    REUSE_STORE=true
    STORE_ID=$CURRENT_STORE_ID
  else
    echo "❌ Store $CURRENT_STORE_ID introuvable."
  fi
else
  echo "⚠️ Aucune variable FGA_STORE_ID trouvée dans $ENV_FILE."
fi

# Création si store invalide ou absent
if [ "$REUSE_STORE" = false ]; then
  if [ "$ALLOW_CREATE" = true ]; then
    echo "🛠️ Création d'un nouveau store..."
    STORE_ID=$(fga --api-url "$OPENFGA_HOST" store create --name "parkigo-store" | jq -r .store.id)
    echo "✅ Nouveau store créé : $STORE_ID"

    echo "Mise à jour de $ENV_FILE avec FGA_STORE_ID=$STORE_ID..."
    if grep -q "^FGA_STORE_ID=" "$ENV_FILE"; then
      sed -i.bak "s/^FGA_STORE_ID=.*/FGA_STORE_ID=$STORE_ID/" "$ENV_FILE" && rm -f "$ENV_FILE.bak"
      echo "Variable FGA_STORE_ID mise à jour."
    else
      echo -e "\nFGA_STORE_ID=$STORE_ID" >> "$ENV_FILE"
      echo "➕ Variable FGA_STORE_ID ajoutée à la fin du fichier."
    fi

    echo "Import du modèle et des tuples..."
    fga --api-url "$OPENFGA_HOST" store import --store-id "$STORE_ID" --file "$FILE_PATH"
    echo "✅ Modèle importé dans le nouveau store $STORE_ID"
  else
    echo "🚫 ALLOW_CREATE=false → Aucun store valide trouvé et création interdite."
    echo "❌ Le fichier $ENV_FILE contient une référence invalide, ou le store n'existe plus."
    echo "💡 Vérifiez que la base OpenFGA est bien restaurée ou définissez ALLOW_CREATE=true pour créer un nouveau store."
    exit 1
  fi
else
  echo "ℹ️ Store existant réutilisé : $STORE_ID"
  if [ "$FORCE_IMPORT" = true ]; then
    echo "FORCE_IMPORT activé → réimport du modèle et des tuples..."
    fga --api-url "$OPENFGA_HOST" store import --store-id "$STORE_ID" --file "$FILE_PATH"
    echo "✅ Réimport terminé."
  else
    echo "⏩ FORCE_IMPORT désactivé → pas de réimport."
  fi
fi

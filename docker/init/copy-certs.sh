#!/bin/bash
set -e

echo "[entrypoint] Starting SSL certs copy process..."

# Vérification que les fichiers existent avant de copier
if [[ ! -f /tmp/certs/server.crt ]]; then
  echo "[entrypoint][ERROR] SSL certificate file /tmp/certs/server.crt not found!"
  exit 1
fi

if [[ ! -f /tmp/certs/server.key ]]; then
  echo "[entrypoint][ERROR] SSL key file /tmp/certs/server.key not found!"
  exit 1
fi

# Copie des fichiers cert et clé
cp /tmp/certs/server.crt /etc/ssl/server.crt
cp /tmp/certs/server.key /etc/ssl/server.key

echo "[entrypoint] SSL certs copied."

# Attribution des droits utilisateurs et permissions strictes sur la clé privée
chown postgres:postgres /etc/ssl/server.crt /etc/ssl/server.key
chmod 600 /etc/ssl/server.key

echo "[entrypoint] Permissions set: owner=postgres, mode=600 on server.key"

# Démarrage du vrai entrypoint PostgreSQL avec les arguments fournis
exec docker-entrypoint.sh "$@"


# Pour rendre le script exécutable avant de lancer :
# chmod +x ./docker/init/copy-certs.sh
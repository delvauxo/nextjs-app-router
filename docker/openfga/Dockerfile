FROM alpine:latest

# Installer les outils nécessaires
RUN apk add --no-cache curl bash tar

# Définir le répertoire de travail
WORKDIR /usr/local/bin

# Télécharger le client FGA CLI (PAS le serveur)
# Télécharger et installer la dernière version du CLI OpenFGA
RUN curl -s https://api.github.com/repos/openfga/cli/releases/latest \
  | grep "browser_download_url.*linux_amd64.tar.gz" \
  | cut -d '"' -f 4 \
  | xargs curl -L -o fga.tar.gz && \
  tar -xzf fga.tar.gz && \
  mv fga /usr/local/bin/fga && \
  chmod +x /usr/local/bin/fga && \
  rm -f fga.tar.gz


# Copier les fichiers d'import
COPY import.sh /import/import.sh
COPY open-fga.yaml /import/open-fga.yaml

# Donner les droits d'exécution
RUN chmod +x /import/import.sh

# Point d’entrée
ENTRYPOINT ["sh", "/import/import.sh"]

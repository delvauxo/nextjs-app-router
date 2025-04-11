-- Créer la base de données Keycloak si elle n'existe pas déjà
CREATE DATABASE keycloak;

-- Utilisation de la base de données yolo
\c yolo;

-- Exécution du script pour initialiser la base de données yolo
\i /docker-entrypoint-initdb.d/db-schema-and-seed.sql;
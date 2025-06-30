
# Restore PostgreSQL - Documentation Complète

Ce document décrit le fonctionnement, les exigences, la sécurité et l'utilisation du script `restore-postgres.sh` conçu pour restaurer les bases de données PostgreSQL de l'application Parkigo.

---

## 📄 Objectif

Restaurer automatiquement les bases PostgreSQL du projet (API principale, Keycloak, OpenFGA) à partir des dumps SQL sauvegardés, avec :

- arrêt des services dépendants (FastAPI, Keycloak, OpenFGA)
- sélection du dossier de backup
- choix individuel ou global des bases à restaurer
- restauration propre des bases
- redémarrage des services
- mise à jour dynamique de `FGA_STORE_ID` dans le fichier `.env`
- proposition de faire un backup complet avant restauration pour plus de sécurité

---

## 📊 Bases concernées

- `POSTGRES_DATABASE` (base principale de l'application)
- `keycloak`
- `openfga`

---

## ⚖️ Prérequis

### Variables d'environnement requises dans `.env.local` / `.env.production`

```env
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_HOST=
POSTGRES_PORT=
POSTGRES_DATABASE=
FGA_STORE_ID=  # optionnel : sera mis à jour automatiquement
```

### Outils nécessaires

- `bash`, `psql`, `dropdb`, `createdb`
- Docker / Docker Compose

### Rendre le script exécutable (si ce n’est pas déjà fait)

```bash
chmod +x ./backups/scripts/restore-postgres.sh
```

---

## 🔐 Sécurité : gestion du mot de passe PostgreSQL

Le mot de passe est stocké temporairement dans un fichier `.pgpass` sécurisé (permissions 600), supprimé automatiquement à la fin du script.

---

## 🔄 Fonctionnement détaillé

### 1. Détection de l'environnement

Le script lit `APP_ENV` (`local` par défaut) et sélectionne le fichier `.env` approprié :
- `.env.local` pour local/dev
- `.env.production` pour production

### 2. Extraction des variables PostgreSQL

Les variables suivantes doivent être présentes dans le fichier `.env` :
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_DATABASE`

### 3. Sélection du dossier de backup

Tous les sous-dossiers de `./backups/` sont listés, sauf `scripts/`. L’utilisateur choisit un dossier contenant les dumps `.sql`.

### 4. Proposition de backup préventif

Avant de procéder à la restauration, le script propose à l’utilisateur de faire un backup complet de l’état actuel des bases.

Cela permet de sécuriser les données actuelles en cas d’erreur ou de mauvaise manipulation pendant la restauration.

### 5. Sélection des bases à restaurer

- Si tous les fichiers `.sql` sont présents, on peut restaurer toutes les bases d’un coup (`Y/n`)
- Sinon, sélection individuelle par base, avec chemin affiché

### 6. Arrêt automatique des services dépendants

Avant restauration :
```bash
docker compose stop fastapi keycloak openfga
```

### 7. Démarrage de PostgreSQL seul

```bash
docker compose up -d postgres
```

Attente active de disponibilité via `pg_isready`.

### 8. Restauration

Pour chaque base sélectionnée :
- Déconnexion des connexions actives (`pg_terminate_backend`)
- `dropdb` + `createdb`
- Restauration avec `psql -f`

### 9. Redémarrage des services

```bash
docker compose up -d fastapi keycloak openfga
```

### 10. Mise à jour du `FGA_STORE_ID`

Si la base `openfga` a été restaurée :
- Le script extrait le Store ID depuis `openfga.sql`
- Il met à jour (ou ajoute) `FGA_STORE_ID` dans le fichier `.env`

---

## 🚀 Commande de lancement

```bash
./backups/scripts/restore-postgres.sh
```

### Forcer un environnement spécifique

```bash
APP_ENV=production ./backups/scripts/restore-postgres.sh
```

---

## ⚠️ Bonnes pratiques & recommandations

- **Ne jamais lancer en production sans avoir validé les dumps.**
- Pour une restauration propre :
  ```bash
  docker compose down -v
  ```
- Vérifie manuellement les fichiers `.sql` si besoin.
- Inspecte la mise à jour de `FGA_STORE_ID` dans le `.env` :

```bash
grep FGA_STORE_ID .env.local
```

---

## 📦 Exemple de structure de dossier

```
.
├── backups/
│   ├── scripts/
│   │   ├── restore-postgres.sh
│   │   └── restore-postgres.md
│   ├── 2025-06-26_21-41-35/
│   │   ├── openfga.sql
│   │   ├── keycloak.sql
│   │   └── yolo.sql
├── .env.local
```

---

## ✅ Historique des améliorations

- ✔ Ajout d’un `.pgpass` temporaire sécurisé
- ✔ Sélection interactive des dossiers et bases
- ✔ Mise à jour dynamique de `FGA_STORE_ID` uniquement si `openfga` est restaurée
- ✔ Robustesse : détection environnement + validation des variables
- ✔ Arrêt/redémarrage automatique des services Docker concernés
- ✔ Proposition de backup préventif avant restauration

---

## 🎉 C’est prêt !

Tu peux restaurer tes bases en toute confiance 🚀  
Et en cas de doute : relance un `docker compose down -v` pour repartir de zéro.

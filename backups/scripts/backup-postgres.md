
# Backup PostgreSQL - Documentation Complète

Ce document décrit le fonctionnement, les exigences, la sécurité et l'utilisation du script `backup-postgres.sh` conçu pour sauvegarder les bases de données PostgreSQL de l'application Parkigo.

---

## 📄 Objectif

Sauvegarder automatiquement les bases PostgreSQL du projet (API principale, Keycloak, OpenFGA) avec :

- détection automatique de l’environnement (local, production)
- création d’un dossier horodaté dans `backups/`
- export de chaque base au format SQL
- export global complet (rôles + bases)

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
POSTGRES_DATABASE=
```

### Outils

- `bash`, `pg_dump`, `pg_dumpall`
- Docker (pour exécuter les commandes dans le conteneur PostgreSQL)

### Rendre le script exécutable (si ce n’est pas déjà fait)

```bash
chmod +x ./backups/scripts/backup-postgres.sh
```

---

## 🔄 Fonctionnement global

### 1. Lecture de l'environnement

- Détection du fichier `.env.local` ou `.env.production` selon `APP_ENV`
- Extraction des variables PostgreSQL

### 2. Création d’un dossier horodaté dans `backups/`

### 3. Sauvegarde de chaque base (principal + keycloak + openfga)

- Dump via `pg_dump` exécuté dans le conteneur Docker PostgreSQL

### 4. Dump global complet (rôles + bases)

- Dump via `pg_dumpall` exécuté dans le conteneur Docker PostgreSQL

---

## 🚧 Commande pour lancer la sauvegarde

```bash
./backups/scripts/backup-postgres.sh
```

### Optionnel : forcer un environnement spécifique

```bash
APP_ENV=production ./backups/scripts/backup-postgres.sh
```

---

## ⚠️ Risques et bonnes pratiques

- Assure-toi que le conteneur PostgreSQL est démarré avant d’exécuter le script.
- Vérifie la présence des fichiers `.env` avant exécution.
- Le script est idempotent pour les sauvegardes.

---

## 📃 Exemple de structure de dossier

```
.
├── backups/
│   ├── scripts/
│   │   ├── backup-postgres.sh
│   │   └── backup-postgres.md
│   ├── 2025-06-27_15-46-40/
│   │   ├── openfga.sql
│   │   ├── keycloak.sql
│   │   └── yolo.sql
├── .env.local
```

---

## 📅 Historique des améliorations

- ✅ Détection automatique d'environnement
- ✅ Validation des variables obligatoires
- ✅ Dump bases + dump global
- ✅ Sécurité renforcée

---

## 🎉 That's it!

Tu peux maintenant sauvegarder tes bases PostgreSQL automatiquement 🚀

Pour toute modification future, pense à tester avec un conteneur PostgreSQL lancé.

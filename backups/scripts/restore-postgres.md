# Restore PostgreSQL - Documentation Complète

Ce document décrit le fonctionnement, les exigences, la sécurité et l'utilisation du script `restore-postgres.sh` conçu pour restaurer les bases de données PostgreSQL de l'application Parkigo.

---

# Restore PostgreSQL - Documentation Complète

Ce document décrit le fonctionnement, les exigences, la sécurité et l'utilisation du script `restore-postgres.sh` conçu pour restaurer les bases de données PostgreSQL de l'application Parkigo.

---

## 📄 Objectif

Restaurer automatiquement les bases PostgreSQL du projet (API principale, Keycloak, OpenFGA) à partir des dumps SQL sauvegardés, avec :

- arrêt des services dépendants (FastAPI, Keycloak, OpenFGA)
- restauration propre des bases
- redémarrage des services
- mise à jour dynamique de `FGA_STORE_ID` dans le fichier `.env`

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

### Outils

- `bash`, `psql`, `dropdb`, `createdb`
- Docker / Docker Compose (pour arrêter/redémarrer les services)

### Rendre le script exécutable (si ce n’est pas déjà fait)

```bash
chmod +x ./backups/scripts/restore-postgres.sh
```

---

## ⚖️ Sécurité : gestion du mot de passe PostgreSQL

Le mot de passe n'est **pas exporté dans le shell**. Un fichier `.pgpass` temporaire est généré dans le même dossier que le script avec les permissions `600`, supprimé à la fin du script automatiquement.

```bash
PGPASS_FILE="$SCRIPT_DIR/.pgpass"
echo "$POSTGRES_HOST:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > "$PGPASS_FILE"
chmod 600 "$PGPASS_FILE"
export PGPASSFILE="$PGPASS_FILE"
trap 'rm -f "$PGPASS_FILE"' EXIT
```

---

## 🔄 Fonctionnement global

### 1. Lecture de l'environnement

- Détection du fichier `.env.local` ou `.env.production` selon `APP_ENV`
- Extraction des variables PostgreSQL

### 2. Sélection du dernier dossier de backup

- Chemin : `./backups/YYYY-MM-DD_HH-MM-SS`

### 3. Restauration de chaque base si le fichier SQL correspondant existe

- Suppression de la base existante
- Recréation
- Restauration via `psql -f`

### 4. Mise à jour automatique du `FGA_STORE_ID`

- Extraction de l'ID de store le plus utilisé dans la table `tuple` (via `GROUP BY store ORDER BY COUNT(*) DESC`)
- Mise à jour du fichier `.env.local` (ou `.env.production`)

---

## 🚧 Commande pour lancer la restauration

```bash
./backups/scripts/restore-postgres.sh
```

### Optionnel : forcer un environnement spécifique

```bash
APP_ENV=production ./backups/scripts/restore-postgres.sh
```

---

## ⚠️ Risques et bonnes pratiques

- **Jamais lancer en production sans vérifier les fichiers de backup**.
- Toujours utiliser un `docker compose down -v` si vous voulez une restauration **propre** sans conflit avec des stores existants (OpenFGA).
- Attention aux **collisions d'identifiants** dans OpenFGA si le store ID change mais que le dump contient d’autres ID.

---

## 🪤 Tips & recommandations

- Le script est **idempotent** : relancer deux fois sans changement de dump ne modifie rien.
- En cas de doute sur l'état de votre backup : inspectez `openfga.sql` et `keycloak.sql` manuellement.
- Vous pouvez vérifier la mise à jour effective du `FGA_STORE_ID` dans `.env.local` avec :

```bash
grep FGA_STORE_ID .env.local
```

---

## 📃 Exemple de structure de dossier

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

## 📅 Historique des améliorations

- ✅ Ajout d’un `.pgpass` temporaire pour éviter `PGPASSWORD`
- ✅ Synchronisation dynamique de `FGA_STORE_ID` à partir de la table `tuple`
- ✅ Validation des variables obligatoires
- ✅ Sécurité renforcée pour les environnements de production

---

## 🎉 That's it!

Vous pouvez maintenant restaurer tes bases PostgreSQL en toute confiance 🚀

Pour toute modification future, pense à bien tester avec un `docker compose down -v` + `./backups/scripts/restore-postgres.sh` complet.


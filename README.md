# Guide de démarrage – Parkigo

## 1. Lancer le frontend

```bash
npm run dev
```

## 2. Lancer les services Docker (OpenFGA, PostgreSQL, etc.)

### Développement

```bash
docker compose up --build
```

### Production

```bash
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up --build -d
```

## 3. Vérifier la configuration combinée (utile pour debug)

```bash
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml config
```

### Fichiers utilisés

- `docker-compose.yaml` : configuration commune
- `docker-compose.override.yaml` : spécifique au développement (automatique)
- `docker-compose.prod.yaml` : spécifique à la production (manuel)

Chaque fichier ne contient que les différences spécifiques à son environnement.

---

## Commandes Docker utiles

### Lancer les services

```bash
docker compose up --build
```

### Rebuild sans utiliser le cache

```bash
docker compose build --no-cache
```

### Utiliser un fichier `.env` spécifique (ex : production)

```bash
APP_ENV=production docker compose --env-file .env.production up --build
```

### Utiliser plusieurs fichiers docker-compose (ex : prod)

```bash
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up --build
```

---

## Observation & debug

### Voir les conteneurs en cours d’exécution

```bash
docker ps
```

### Voir tous les conteneurs (même arrêtés)

```bash
docker ps -a
```

### Voir les logs d’un service en temps réel

```bash
docker compose logs -f <nom_du_service>
```

---

## Nettoyage & suppression

### Supprimer tout ce qui n’est pas utilisé (conteneurs arrêtés, images, réseaux, cache)

```bash
docker system prune -a
```

### Supprimer uniquement les images non utilisées

```bash
docker image prune -a
```

### Supprimer tous les conteneurs et images créées par Docker Compose

```bash
docker compose down --rmi all
```

### Supprimer tous les volumes (réinitialise les bases de données)

```bash
docker compose down -v
```

---

## Gestion des environnements

- `.env.local` : utilisé automatiquement en développement
- `.env.production` : utilisé manuellement en production (via `--env-file`)
- Variable `APP_ENV` disponible pour savoir dans quel environnement tourne le script (`development` ou `production`)

# 1. Lancer le frontend

npm run dev

# 2. Lancer les services Docker (OpenFGA, PostgreSQL, etc.)

[DEV]   
docker compose up --build

[PROD]  
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up --build -d


## Astuce : Pour vérifier les fichiers combinés

[PROD]  
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml config

Fichiers :

- docker-compose.yaml (commun)
- docker-compose.override.yaml (développement)
- docker-compose.prod.yaml (production)

Ces fichiers docker-compose ne font qu'override le fichier de base commun aux différents environements.


# 3 Commandes Docker

## Supprimer tout ce qui n’est pas utilisé (Images, Conteneurs, Réseaux)
docker system prune -a

## ABC
docker compose up --build

## Rebuild sans cache
docker compose build --no-cache

## Supprimer toutes les images créées (built) par docker compose
docker compose down --rmi all



## Supprimer tous les volumes
docker compose down -v



#################

### Lancer les services

#### Lancer tous les services avec reconstruction (build)
```bash
docker compose up --build
```

#### Rebuild sans utiliser le cache
```bash
docker compose build --no-cache
```

### Arrêter et supprimer les services

#### Arrêter tous les services
```bash
docker compose down
```

#### Supprimer tous les conteneurs + images créées par Docker Compose
```bash
docker compose down --rmi all
```

#### Supprimer tous les volumes (utile pour réinitialiser les bases de données)
```bash
docker compose down -v
```

### Nettoyage général Docker

#### Supprimer tout ce qui n’est pas utilisé (conteneurs arrêtés, images, réseaux, cache)
```bash
docker system prune -a
```

#### Supprimer uniquement les images non utilisées
```bash
docker image prune -a
```

### Observation et debug

#### Voir les conteneurs en cours d’exécution
```bash
docker ps
```

#### Voir tous les conteneurs (même arrêtés)
```bash
docker ps -a
```

#### Voir les logs d’un service en temps réel
```bash
docker compose logs -f <nom_du_service>
```

### Gestion des environnements

- `.env.local` : utilisé automatiquement en développement.
- `.env.production` : peut être chargé manuellement pour la production.

#### Utiliser un fichier `.env` spécifique
```bash
APP_ENV=production docker compose --env-file .env.production up --build
```

#### Utiliser plusieurs fichiers `docker-compose` (ex: prod)
```bash
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up --build
```

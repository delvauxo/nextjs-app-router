# Nom des services
POSTGRES_CONTAINER_NAME=postgres_ssl
KEYCLOAK_CONTAINER_NAME=keycloak

# Commandes Docker
DOCKER_COMPOSE=docker-compose -f docker-compose.yaml

# Commande pour démarrer les services
up:
	$(DOCKER_COMPOSE) up -d

# Commande pour arrêter les services
down:
	$(DOCKER_COMPOSE) down

# Commande pour arrêter les services et supprimer les volumes existants
down-v:
	$(DOCKER_COMPOSE) down -v

# Commande pour vérifier les logs de Keycloak
logs-keycloak:
	$(DOCKER_COMPOSE) logs -f keycloak

# Commande pour vérifier les logs de PostgreSQL
logs-postgres:
	$(DOCKER_COMPOSE) logs -f postgres

# Commande pour reconstruire les services (si nécessaire)
build:
	$(DOCKER_COMPOSE) build

# Commande pour redémarrer les services
restart:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d

# Commande pour voir les services en cours d'exécution
ps:
	$(DOCKER_COMPOSE) ps

# Commande pour voir les services en cours d'exécution avec un watch de 5s
docker-ps-watch:
	watch -n 5 docker ps

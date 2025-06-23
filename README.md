git clone ton-projet
cd ton-projet

# 1. Lancer les services Docker (OpenFGA, PostgreSQL, etc.)
docker compose up --build

# 2. Lancer le frontend
npm run dev

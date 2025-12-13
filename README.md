Rodar container
docker compose up --build

Ver a bd
docker exec -it mariadb_db mariadb -u admin -p
Poe senha
USE netflix_db;
SHOW TABLES;



NA VM NA CLOUD
docker compose down
docker compose build --no-cache
docker compose up -d



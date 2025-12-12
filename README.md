Rodar container
docker compose up --build

Ver a bd
docker exec -it mariadb_db mariadb -u admin -p
Poe senha
USE netflix_db;
SHOW TABLES;

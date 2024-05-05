# Integrantes

- Eric Bracamonte
- Grover Ugarte

# Enlace del video demostración

https://youtu.be/6PpFhZ0iNYk

# Actividad 1

## Actividad 1.1

Crear un volumen con el nombre boston-data
```sh
docker volume create boston-data 
```

## Actividad 1.2

Comando para desplegar un contenedor de la base de datos
```sh
docker run \
    -d \
    --net boston \
    --name boston-db \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=boston \
    -p 5432:5432 \
    -v boston-data:/var/lib/postgresql/data/ \
    --rm \
    -i postgres:latest
```

## Actividad 1.3

Comando para inicializar una base de datos
```sh
docker exec \
    -it boston-db psql \
    -U postgres -d boston -c "CREATE TABLE IF NOT EXISTS product (id SERIAL PRIMARY KEY, name VARCHAR(255) UNIQUE, description TEXT, price NUMERIC, stock INTEGER);"
```

# Actividad 3

# Actividad 3.1

Diseño de Dockerfile
```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["sh", "init.sh"]
```

## Actividad 3.2

Comando para construir la imagen de la aplicación.

```sh
docker build -t app:v1.0 .
```

## Actividad 3.3

Ejecución del contenedor de la aplicación.

```sh
docker run \
    -d \
    --net boston \
    --name boston-app \
    -e DB_USER=postgres \
    -e DB_PASSWORD=postgres \
    -e DB_NAME=boston \
    -e DB_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' boston-db) \
    -e DB_PORT=5432 \
    -p 5000:5000 \
    --rm \
    -i app:v1.0 
```

# Actividad 4

## Actividad 4.1

Construir con el siguiente comando
```sh
docker build -t prober76/app:v1.0 .
```

Enlace de la imagen de la aplicación:
https://hub.docker.com/repository/docker/prober76/app/general

# Actividad 5

## Actividad 5.1

Docker compose
```yml
version: '3.7'
services:
  boston-db-compose:
    build: ./actividad-1
    ports:
      - 5432:5432
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=boston
    volumes:
      - boston-data:/var/lib/postgresql/data
    networks:
      - boston
  boston-app-compose:
    image: prober76/app:v1.0
    ports:
      - 5000:5000
    environment:
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_NAME=boston
      - DB_HOST=boston-db-compose
      - DB_PORT=5432
    networks:
      - boston
networks:
  boston:
volumes:
  boston-data:
```

## Actividad 5.2

Docker compose en segundo plano

```sh
docker-compose up -d
```
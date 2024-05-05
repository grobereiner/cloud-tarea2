CREATE DATABASE IF NOT EXISTS boston;

\c boston;

CREATE TABLE IF NOT EXISTS product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    description TEXT,
    price NUMERIC,
    stock INTEGER
);
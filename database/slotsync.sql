CREATE DATABASE IF NOT EXISTS syncslot;
USE syncslot;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active'
);

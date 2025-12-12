CREATE DATABASE IF NOT EXISTS netflix_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE netflix_db;

CREATE TABLE  IF NOT EXISTS users(
    id CHAR(36) PRIMARY KEY, 
    username VARCHAR(100) NOT NULL UNIQUE, 
    email VARCHAR(100) NOT NULL UNIQUE,  
    password_hash VARCHAR(255) NOT NULL, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    last_login DATETIME NULL,
    is_active BOOLEAN DEFAULT TRUE, 
    role ENUM('Admin', 'Client') NOT NULL DEFAULT 'Client'
);

CREATE TABLE  IF NOT EXISTS profiles(
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, 
    name VARCHAR(50), 
    category ENUM('Default', 'Kids') NOT NULL DEFAULT 'Default', 
    photo_url VARCHAR(2000)
);

CREATE TABLE  IF NOT EXISTS languages(
    id CHAR(36) PRIMARY KEY,
    iso_code CHAR(5), 
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS genres(
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS movies(
    id CHAR(36) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(2000) NOT NULL,
    director VARCHAR(100),
    release_year YEAR CHECK (release_year >= 1800 AND release_year <= 2025),
    duration_minutes INT NOT NULL,
    rating DECIMAL(2,1) DEFAULT 5.0 CHECK (rating >= 0.0 AND rating <= 5.0),
    indicative_classification ENUM('L','10','12','14','16','18') NOT NULL,
    cover_image VARCHAR(2000)
);

CREATE TABLE IF NOT EXISTS profile_preferred_languages(
    profile_id CHAR(36) NOT NULL,
    language_id CHAR(36) NOT NULL,
    PRIMARY KEY (profile_id, language_id),
    FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS watch_histories(
    id CHAR(36) PRIMARY KEY,
    profile_id CHAR(36) NOT NULL,
    movie_id CHAR(36) NOT NULL,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    finished_at DATETIME,
    progress_minutes INT,
    UNIQUE (profile_id, movie_id),
    FOREIGN KEY (profile_id) REFERENCES profiles(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

CREATE TABLE IF NOT EXISTS movie_genres(
    genre_id CHAR(36) NOT NULL,
    movie_id CHAR(36) NOT NULL,
    PRIMARY KEY (genre_id, movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);


CREATE TABLE IF NOT EXISTS profile_movie_list(
    id CHAR(36) PRIMARY KEY,
    profile_id CHAR(36) NOT NULL,
    movie_id CHAR(36) NOT NULL, 
    FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subtitles(
    id CHAR(36) PRIMARY KEY,
    movie_id CHAR(36) NOT NULL,
    language_id CHAR(36) NOT NULL,
    file_hash VARCHAR(64) NOT NULL,
    storage_link VARCHAR(2000) NOT NULL,
    UNIQUE (movie_id, language_id),
    FOREIGN KEY (language_id) REFERENCES languages(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

CREATE TABLE IF NOT EXISTS movie_formats(
    id CHAR(36) PRIMARY KEY,
    movie_id CHAR(36) NOT NULL,
    language_id CHAR(36) NOT NULL,
    resolution ENUM("360p","1080p") NOT NULL,
    file_hash VARCHAR(64) NOT NULL,
    storage_link VARCHAR(2000) NOT NULL,
    UNIQUE (movie_id, language_id, resolution),
    FOREIGN KEY (language_id) REFERENCES languages(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);


CREATE TABLE IF NOT EXISTS profile_favorites_genres(
    profile_id CHAR(36) NOT NULL, 
    genre_id CHAR(36) NOT NULL,
    PRIMARY KEY (profile_id, genre_id), 
    FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE, 
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);
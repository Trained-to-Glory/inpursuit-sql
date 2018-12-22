DROP DATABASE IF EXISTS qnedwtxcaccmbl1h;
CREATE DATABASE qnedwtxcaccmbl1h;
USE qnedwtxcaccmbl1h;
SET FOREIGN_KEY_CHECKS = 0;
SET GLOBAL group_concat_max_len = 1000000;
SET GLOBAL sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

CREATE TABLE pursuits(
    pursuitId INT AUTO_INCREMENT NOT NULL,
    interestId INT,
    userId VARCHAR(255) NOT NULL,
    thumbnailUrl TEXT,
    pursuit_description TEXT,
    old_pursuitId INT,
    created_at TIMESTAMP DEFAULT NOW(),
    is_visible TINYINT NOT NULL DEFAULT 1,
    is_public TINYINT NOT NULL DEFAULT 1,
    is_tried TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY(interestId) REFERENCES interests(interestId),
    FOREIGN KEY(userId) REFERENCES users(userId),
    PRIMARY KEY(pursuitId)
);

CREATE TABLE posts(
    postId INT AUTO_INCREMENT NOT NULL,
    pursuitId INT NOT NULL,
    userId VARCHAR(255) NOT NULL,
    videoUrl TEXT,
    thumbnailUrl TEXT,
    posts_description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    is_keyPost TINYINT NOT NULL DEFAULT 0,
    is_visible TINYINT NOT NULL DEFAULT 1,
    is_saved TINYINT NOT NULL DEFAULT 0,
    is_response TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY(userId) REFERENCES users(userId),
    FOREIGN KEY(pursuitId) REFERENCES pursuits(pursuitId),
    PRIMARY KEY(postId)
);

CREATE TABLE users(
    userId VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    username VARCHAR(255) UNIQUE,
    fullname VARCHAR(255) NOT NULL,
    photoUrl TEXT NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY(userId)
);

CREATE TABLE user_follows(
    followerId VARCHAR(255) NOT NULL,
    followeeId VARCHAR(255) NOT NULL,
    is_following TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(followerId) REFERENCES users(userId),
    FOREIGN KEY(followeeId) REFERENCES users(userId),
    PRIMARY KEY(followerId, followeeId)
);

CREATE TABLE block_user(
    blockerId VARCHAR(255) NOT NULL,
    blockeeId VARCHAR(255) NOT NULL,
    is_blocked TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(blockerId) REFERENCES users(userId),
    FOREIGN KEY(blockeeId) REFERENCES users(userId),
    PRIMARY KEY(blockerId, blockeeId)
);

CREATE TABLE pursuit_follows(
    pursuitId INT NOT NULL,
    userId VARCHAR(255) NOT NULL,
    is_following TINYINT NOT NULL DEFAULT 1,
    FOREIGN KEY(pursuitId) REFERENCES pursuits(pursuitId),
    FOREIGN KEY(userId) REFERENCES users(userId),
    PRIMARY KEY(pursuitId, userId)
);

CREATE TABLE similar_pursuit(
    pursuitId INT NOT NULL,
    new_pursuitId INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(pursuitId) REFERENCES pursuits(pursuitId),
    FOREIGN KEY(new_pursuitId) REFERENCES pursuits(pursuitId),
    PRIMARY KEY(pursuitId, new_pursuitId)
);

CREATE TABLE pursuit_tried(
    pursuitId INT NOT NULL,
    userId VARCHAR(255) NOT NULL, 
    is_tried TINYINT NOT NULL DEFAULT 1,
    FOREIGN KEY(pursuitId) REFERENCES pursuits(pursuitId),
    FOREIGN KEY(userId) REFERENCES users(userId),
    PRIMARY KEY(pursuitId, userId)
);

CREATE TABLE interests(
    interestId INT NOT NULL AUTO_INCREMENT,
    interest_photo TEXT,
    interest_name VARCHAR(255) UNIQUE,
    PRIMARY KEY(interestId)
);

CREATE TABLE user_interests(
    interestId INT NOT NULL,
    userId VARCHAR(255) NOT NULL,
    is_selected TINYINT NOT NULL DEFAULT 1,
    FOREIGN KEY(interestId) REFERENCES interests(interestId),
    FOREIGN KEY(userId) REFERENCES users(userId),
    PRIMARY KEY(interestId, userId)
);

CREATE TABLE posts_saved(
    postId INT NOT NULL,
    userId VARCHAR(255) NOT NULL, 
    is_saved TINYINT NOT NULL DEFAULT 1,
    FOREIGN KEY(postId) REFERENCES posts(postId),
    FOREIGN KEY(userId) REFERENCES users(userId),
    PRIMARY KEY(postId, userId)
);

CREATE TABLE posts_responses(
    postId INT NOT NULL,
    pursuitId INT NOT NULL,
    userId VARCHAR(255) NOT NULL,
    FOREIGN KEY(postId) REFERENCES posts(postId),
    FOREIGN KEY(pursuitId) REFERENCES pursuits(pursuitId),
    FOREIGN KEY(userId) REFERENCES users(userId)
);
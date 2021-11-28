CREATE TABLE Dish
(
    id            INTEGER PRIMARY KEY,
    name          TEXT,
    proteins      TEXT,
    fat           TEXT,
    carbohydrates TEXT,
    calories      TEXT,
    watter        TEXT
);

CREATE TABLE Information
(
    id            INTEGER PRIMARY KEY,
    date          DATE,
    time          TIME,
    proteins      TEXT,
    fat           TEXT,
    carbohydrates TEXT,
    calories      TEXT,
    watter        TEXT
);

CREATE TABLE User
(
    id     INTEGER PRIMARY KEY,
    height INT,
    weight INT,
    age    INT,
    mode   INT
);

INSERT INTO User VALUES (0,0,0,0,0);
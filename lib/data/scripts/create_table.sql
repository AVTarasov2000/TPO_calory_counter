CREATE TABLE Dish
(
    id            INTEGER PRIMARY KEY,
    name          TEXT,
    proteins      INT,
    fat           INT,
    carbohydrates INT,
    calories      INT,
    watter        INT
);

CREATE TABLE Information
(
    id            INTEGER PRIMARY KEY,
    date          DATE,
    time          TIME,
    dish_id       INT REFERENCES Dish(id)
);

CREATE TABLE MyUser
(
    id     INTEGER PRIMARY KEY,
    height INT,
    weight INT,
    age    INT,
    mode   INT
);

INSERT INTO MyUser(id,height,weight,age,mode) VALUES (0,0,0,0,0);

INSERT INTO Dish(name,proteins,fat,carbohydrates,calories,watter)
VALUES ('картошка', 10, 10, 10, 10, 10);

INSERT INTO Dish(name,proteins,fat,carbohydrates,calories,watter)
VALUES ('котлета', 10, 10, 10, 10, 10);

INSERT INTO Dish(name,proteins,fat,carbohydrates,calories,watter)
VALUES ('макарошки', 10, 10, 10, 10, 10);

INSERT INTO Dish(name,proteins,fat,carbohydrates,calories,watter)
VALUES ('пюрешка', 10, 10, 10, 10, 10);

-- 1
CREATE TABLE pokemon(
	pokemon_id INT NOT NULL,
    name VARCHAR(50),
    type VARCHAR(20),
    hp INT,
    attack INT,
    defence INT,
    speed INT,
    CONSTRAINT PK_POKEMON_ID PRIMARY KEY (pokemon_id)
);

CREATE TABLE trainer(
	trainer_id INT NOT NULL,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    city VARCHAR(30),
    CONSTRAINT PK_TRAINER_ID PRIMARY KEY (trainer_id)
);    

INSERT INTO pokemon (pokemon_id, name, type, hp, attack, defence, speed) VALUES
(1, "Bulbasaur", "Grass", 45, 49, 49, 45),
(2, "Ivysaur", "Grass", 60, 62, 63, 60),
(3, "Venusaur", "Grass", 80, 82, 83, 80),
(4, "Charmander", "Fire", 39, 52, 43, 65),
(5, "Charmeleon", "Fire", 58, 64, 58, 80),
(6, "Charizard", "Fire", 78, 84, 78, 100),
(7, "Squirtle", "Water", 44, 48, 65, 43),
(8, "Wartortle", "Water", 59, 63, 80, 58),
(9, "Blastoise", "Water", 79, 83, 100, 78),
(10, "Pikachu", "Electric", 35, 55, 40, 90),
(11, "Raichu", "Electric", 60, 90, 55, 110);

INSERT INTO trainer (trainer_id, first_name, last_name, city) VALUES
(1, "Ash", "Ketchum", "Pallet Town"),
(2, "Misty", "Williams", "Cerulean City"),
(3, "Brock", "Harrison", "Pewter City"),
(4, "Gary", "Oak", "Pallet Town"),
(5, "Erika", "Green", "Celadon City");

-- 2 
SELECT DISTINCT type
FROM pokemon;

-- 3
SELECT *
FROM pokemon
WHERE attack BETWEEN 50 AND 80;

-- 4
SELECT * 
FROM pokemon
WHERE name LIKE 'C%';

-- 5
SELECT * 
FROM pokemon
WHERE name LIKE '%saur%';

-- 6
SELECT * 
FROM pokemon
WHERE name LIKE '____e____';

-- 7
SELECT concat(first_name, " ", last_name) as name, city
FROM trainer;
-- 8
SELECT *
FROM pokemon
ORDER BY type ASC, attack DESC;
-- 9
CREATE TABLE trainer_pokemon(
	trainer_id INT NOT NULL,
    pokemon_id INT NOT NULL
);
-- 10
ALTER TABLE trainer_pokemon 
ADD CONSTRAINT FK_triner_id FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE trainer_pokemon 
ADD CONSTRAINT FK_pokemon_id FOREIGN KEY (pokemon_id) REFERENCES pokemon(pokemon_id)
ON DELETE CASCADE
ON UPDATE CASCADE;
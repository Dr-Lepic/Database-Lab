-- Task 1
SELECT p.name, p.type
FROM pokemon p
WHERE p.hp = (
	SELECT MAX(hp)
    FROM pokemon p2
    WHERE p2.type = p.type
);

-- Task 2
SELECT name, (hp * 0.8 + attack * 1.2 + defense * 1.0 + speed * 1.5) AS Combat_Rating
FROM pokemon
ORDER BY name;

-- Task 3
SELECT p.name, t.first_name
FROM pokemon p
JOIN owner o on p.pokemon_id = o.pokemon_id
JOIN trainer t on o.trainer_id = t.trainer_id
WHERE p.name LIKE '%saur%' AND t.first_name LIKE '_s%';

-- Task 4
SELECT t.first_name
FROM trainer t
JOIN owner o ON t.trainer_id = o.trainer_id
JOIN pokemon p ON o.pokemon_id = p.pokemon_id
WHERE p.type = 'Electric' AND p.speed > 40;

-- Task 5
SELECT p.name, a.attack_name, a.attack_power
FROM pokemon p
LEFT JOIN pokemon_attacks pa ON p.pokemon_id = pa.pokemon_id
LEFT JOIN attacks a ON pa.attack_id = a.attack_id
UNION 
SELECT p.name, a.attack_name, a.attack_power
FROM pokemon p
RIGHT JOIN pokemon_attacks pa ON p.pokemon_id = pa.pokemon_id
RIGHT JOIN attacks a ON pa.attack_id = a.attack_id

-- Task 6
SELECT CONCAT(t.first_name , ' ', t.last_name) as Full_name, p.name, p.type,  (hp * 0.8 + attack * 1.2 + defense * 1.0 + speed * 1.5) AS Combat_Rating
FROM trainer t
JOIN owner o ON t.trainer_id = o.trainer_id
JOIN pokemon p ON o.pokemon_id = p.pokemon_id
group by t.name
having Combat_Rating = (
	SELECT MAX(Combat_Rating) 
    from pokemon
    );

SELECT CONCAT(t.first_name , ' ', t.last_name) as Full_name, p.name, p.type,  (hp * 0.8 + attack * 1.2 + defense * 1.0 + speed * 1.5) AS Combat_Rating
FROM trainer t
JOIN owner o ON t.trainer_id = o.trainer_id
JOIN pokemon p ON o.pokemon_id = p.pokemon_id
group by Full_name
having Combat_Rating = (
	SELECT MAX(Combat_Rating) 
    from pokemon
    );

-- 8
DELIMITER //

CREATE FUNCTION boost_grass()
RETURNS VARCHAR(50)
DETERMINISTIC
READ SQL DATA

-- Task 10
DELIMITER //

CREATE PROCEDURE evolve_pokemon11(IN pokemon_id INT, IN new_name VARCHAR(50), IN evoultion_bonus INT)
BEGIN
	UPDATE pokemon 
    SET hp = hp + evoultion_bonus,
		attack = attack + evoultion_bonus,
		defense = defense + evoultion_bonus,
		speed = speed + evoultion_bonus,
		name = new_name
    where pokemon.pokemon_id = pokemon_id;
    
    SELECT * 
    FROM pokemon 
    WHERE pokemon.pokemon_id = pokemon_id;
END//

DELIMITER ;

CALL evolve_pokemon11(1, 'Bulbasaur', 10);
    




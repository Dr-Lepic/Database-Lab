-- 1a

DELIMITER //
CREATE FUNCTION name_and_id()
RETURNS VARCHAR(100)
DETERMINISTIC -- always returns the same results if given the same input values
NO SQL
BEGIN
    RETURN 'Mahbub, 220042148';
END //
DELIMITER ;

SELECT name_and_id() AS name_and_id;

-- 1b
DELIMITER //
CREATE FUNCTION c_product(a INT, b INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN a * b;
END //
DELIMITER ;


SELECT c_product(2, 5) AS product;

-- 1c
DELIMITER //
CREATE FUNCTION c_number_type(num DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    IF MOD(num, 1) = 0 THEN
        RETURN 'Whole Number';
    ELSE
        RETURN 'Fraction';
    END IF;
END //
DELIMITER ;

SELECT c_number_type(5.0) AS number_type;  -- Whole Number
SELECT c_number_type(5.5) AS number_type;  -- Fraction

-- 2
DELIMITER //

CREATE FUNCTION stats_count(pokemon_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_stats INT;

    SELECT hp + attack + defense + speed
    INTO total_stats
    FROM pokemon
    WHERE pokemon.pokemon_id = pokemon_id;

    RETURN total_stats;
END //

DELIMITER ;

-- Call the function
SELECT stats_count(1) AS total_stats; 

-- 3

DELIMITER //

CREATE FUNCTION get_pokemon_type(pokemon_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE type_string VARCHAR(100);

    SELECT CONCAT(t1.type_name, IFNULL(CONCAT(', ', t2.type_name), ''))
    INTO type_string
    FROM pokemon p
    LEFT JOIN types t1 ON p.primary_type_id = t1.type_id
    LEFT JOIN types t2 ON p.secondary_type_id = t2.type_id
    WHERE p.pokemon_id = pokemon_id;

    RETURN type_string;
END //

DELIMITER ;


SELECT get_pokemon_type(2) AS pokemon_type;

-- 4

DELIMITER //

CREATE PROCEDURE get_pokemon(IN trainer_id INT)
BEGIN
    SELECT p.name AS pokemon_name, get_pokemon_type(p.pokemon_id) AS pokemon_type
    FROM trainer_pokemon tp
    JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
    WHERE tp.trainer_id = trainer_id;
END //

DELIMITER ;

-- Call the procedure
CALL get_pokemon(1);

-- 5
DELIMITER //

CREATE PROCEDURE level_up(IN pokemon_id INT, IN x INT)
BEGIN
    -- Before stats
    SELECT hp, attack, defense, speed
    FROM pokemon
    WHERE pokemon.pokemon_id = pokemon_id;

    -- Update stats
    UPDATE pokemon
    SET hp = hp + x,
        attack = attack + x,
        defense = defense + x,
        speed = speed + x
    WHERE pokemon.pokemon_id = pokemon_id;

    -- Display after stats
    SELECT hp, attack, defense, speed
    FROM pokemon
    WHERE pokemon.pokemon_id = pokemon_id;
END //

DELIMITER ;

-- Call the procedure
CALL level_up(1, 10); 
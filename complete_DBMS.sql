-- Aggregation

-- Find the average HP of all Pokémon -- 
SELECT AVG(hp) AS average_hp
FROM pokemon;

-- Find the total number of Pokémon owned by each trainer.
SELECT t.name AS trainer_name, COUNT(tp.pokemon_id) AS total_pokemon
FROM trainers t
LEFT JOIN trainer_pokemon tp ON t.trainer_id = tp.trainer_id
GROUP BY t.name;

-- Find the Pokémon with the highest attack stat.
SELECT name, attack
FROM pokemon
ORDER BY attack DESC
LIMIT 1;

-- Average Stats by Primary Type --
SELECT 
    t.type_name AS primary_type,
    AVG(p.hp) AS avg_hp,
    AVG(p.attack) AS avg_attack,
    AVG(p.defense) AS avg_defense,
    AVG(p.speed) AS avg_speed
FROM pokemon p
JOIN types t ON p.primary_type_id = t.type_id
GROUP BY t.type_name
ORDER BY primary_type;


-- Most Common Secondary Type --
SELECT 
    t.type_name AS secondary_type,
    COUNT(p.pokemon_id) AS total_pokemon
FROM pokemon p
JOIN types t ON p.secondary_type_id = t.type_id
GROUP BY t.type_name
ORDER BY total_pokemon DESC
LIMIT 1;


-- Trainers Ranked by Average Pokémon Level --
SELECT 
    tr.name AS trainer_name,
    ROUND(AVG(p.level), 1) AS avg_level,
    RANK() OVER (ORDER BY AVG(p.level) DESC) AS rank 
    FROM trainers tr
JOIN trainer_pokemon tp ON tr.trainer_id = tp.trainer_id
JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
GROUP BY tr.name;


-- Total Stats by Hometown --
SELECT 
    tr.hometown,
    SUM(p.hp) AS total_hp,
    SUM(p.attack) AS total_attack,
    SUM(p.defense) AS total_defense,
    SUM(p.speed) AS total_speed
FROM trainers tr
JOIN trainer_pokemon tp ON tr.trainer_id = tp.trainer_id
JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
GROUP BY tr.hometown;

-- Pokémon Evolution Chain Analysis --
SELECT 
    p.name AS base_pokemon,
    COUNT(pe.evolved_pokemon_id) AS total_evolutions,
    AVG(pe.min_level) AS avg_min_level
FROM pokemon_evolution pe
JOIN pokemon p ON pe.base_pokemon_id = p.pokemon_id
GROUP BY p.name
ORDER BY total_evolutions DESC;

-- Badge Distribution Analysis --
SELECT 
    CASE 
        WHEN badges = 0 THEN '0 Badges'
        WHEN badges BETWEEN 1 AND 5 THEN '1-5 Badges'
        WHEN badges BETWEEN 6 AND 10 THEN '6-10 Badges'
        ELSE '10+ Badges'
    END AS badge_category,
    COUNT(*) AS total_trainers
FROM trainers
GROUP BY badge_category;

-- Most Type-Diverse Trainer --
SELECT 
    tr.name AS trainer_name,
    COUNT(DISTINCT t.type_id) AS unique_types
FROM trainers tr
JOIN trainer_pokemon tp ON tr.trainer_id = tp.trainer_id
JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
JOIN types t ON p.primary_type_id = t.type_id OR p.secondary_type_id = t.type_id
GROUP BY tr.name
ORDER BY unique_types DESC
LIMIT 3;


-- Gym Leader vs. Regular Trainer Comparison --
SELECT 
    CASE 
        WHEN is_gym_leader THEN 'Gym Leader'
        ELSE 'Regular Trainer'
    END AS trainer_type,
    AVG(pokemon_count) AS avg_pokemon_owned,
    AVG(badges) AS avg_badges
FROM (
    SELECT 
        tr.is_gym_leader,
        COUNT(tp.pokemon_id) AS pokemon_count,
        tr.badges
    FROM trainers tr
    LEFT JOIN trainer_pokemon tp ON tr.trainer_id = tp.trainer_id
    GROUP BY tr.trainer_id, tr.badges, tr.is_gym_leader
) subquery
GROUP BY trainer_type;


-- Evolution Level Requirement Analysis --
SELECT 
    MIN(min_level) AS easiest_evolution,
    MAX(min_level) AS hardest_evolution,
    ROUND(AVG(min_level), 1) AS avg_evolution_level
FROM pokemon_evolution;




-- String

-- Concatenate the Pokémon's name and its primary type. -- 
SELECT CONCAT(p.name, ' (', t.type_name, ')') AS pokemon_with_type
FROM pokemon p
JOIN types t ON p.primary_type_id = t.type_id;

-- Find Pokémon whose names start with the letter 'G' --
SELECT name
FROM pokemon
WHERE name LIKE 'G%';

-- Replace spaces in Pokémon names with underscores --
SELECT REPLACE(name, ' ', '_') AS modified_name
FROM pokemon;

-- Extract Pokémon Name Prefixes --
SELECT 
  SUBSTRING(name, 1, 3) AS prefix,
  COUNT(*) AS total_pokemon
FROM pokemon
GROUP BY prefix
ORDER BY total_pokemon DESC;

-- Find Pokémon with Hyphenated Names --
SELECT 
  name,
  SUBSTRING_INDEX(name, '-', 1) AS part1,
  SUBSTRING_INDEX(name, '-', -1) AS part2
FROM pokemon
WHERE name LIKE '%-%';

-- Generate Pokémon Type Combinations --
SELECT 
  p.name,
  CONCAT_WS('/', t1.type_name, t2.type_name) AS type_combination
FROM pokemon p
JOIN types t1 ON p.primary_type_id = t1.type_id
LEFT JOIN types t2 ON p.secondary_type_id = t2.type_id;

-- Mask Pokémon Names for Privacy --
SELECT 
  CONCAT(
    LEFT(name, 1),
    REPEAT('*', LENGTH(name) - 1)) AS masked_name
	FROM pokemon;

-- Count Vowels in Pokémon Names --
SELECT 
  name,
  LENGTH(name) - LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(
  REPLACE(LOWER(name), 'a', ''), 
  'e', ''), 'i', ''), 'o', ''), 'u', '')) AS vowel_count
FROM pokemon;

-- Reverse Pokémon Names --
SELECT 
  name,
  REVERSE(name) AS reversed_name
FROM pokemon;

-- Extract First and Last Letters --
SELECT 
  name,
  CONCAT(LEFT(name, 1), RIGHT(name, 1)) AS initials
FROM pokemon;



-- Subqueries

-- Find Pokémon with HP greater than the average HP. --
SELECT name, hp
FROM pokemon
WHERE hp > (SELECT AVG(hp) FROM pokemon);

-- Find trainers who have more than 2 Pokémon --
SELECT t.name
FROM trainers t
WHERE (SELECT COUNT(*) FROM trainer_pokemon tp WHERE tp.trainer_id = t.trainer_id) > 2;

-- Find Pokémon that are not owned by any trainer. --
SELECT name
FROM pokemon
WHERE pokemon_id NOT IN (SELECT pokemon_id FROM trainer_pokemon);


-- Trainers with Above-Average Pokémon Count --
SELECT t.name, COUNT(tp.pokemon_id) AS total_pokemon
FROM trainers t
JOIN trainer_pokemon tp ON t.trainer_id = tp.trainer_id
GROUP BY t.name
HAVING total_pokemon > (
    SELECT AVG(pokemon_count)
    FROM (
        SELECT COUNT(pokemon_id) AS pokemon_count
        FROM trainer_pokemon
        GROUP BY trainer_id
    ) AS avg_subquery
);

-- Strongest Pokémon of Each Type --
SELECT p.name, t.type_name, p.attack
FROM pokemon p
JOIN types t ON p.primary_type_id = t.type_id
WHERE p.attack = (
    SELECT MAX(attack)
    FROM pokemon p2
    WHERE p2.primary_type_id = p.primary_type_id
);

-- Trainers with Pokémon of a Specific Type --
SELECT t.name
FROM trainers t
WHERE EXISTS (
    SELECT 1
    FROM trainer_pokemon tp
    JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
    JOIN types ty ON p.primary_type_id = ty.type_id
    WHERE ty.type_name = 'Water'
    AND tp.trainer_id = t.trainer_id
);

-- Pokémon with Higher Stats Than Average --
SELECT name, hp, attack, defense, speed
FROM pokemon
WHERE hp > (SELECT AVG(hp) FROM pokemon)
AND attack > (SELECT AVG(attack) FROM pokemon)
AND defense > (SELECT AVG(defense) FROM pokemon)
AND speed > (SELECT AVG(speed) FROM pokemon);

-- Pokémon Owned by Multiple Trainers --
SELECT p.name
FROM pokemon p
WHERE p.pokemon_id IN (
    SELECT pokemon_id
    FROM trainer_pokemon
    GROUP BY pokemon_id
    HAVING COUNT(trainer_id) > 1
);

-- Pokémon with the Longest Name --
SELECT name, LENGTH(name) AS name_length
FROM pokemon
WHERE LENGTH(name) > (
    SELECT AVG(LENGTH(name))
    FROM pokemon
);


-- Evolution Chains with Level Requirements Below Average --
SELECT base_pokemon_id, evolved_pokemon_id, min_level
FROM pokemon_evolution
WHERE min_level < (
    SELECT AVG(min_level)
    FROM pokemon_evolution
);

-- Joins

-- Find all Pokémon and their types (primary and secondary) --
SELECT p.name, t1.type_name AS primary_type, t2.type_name AS secondary_type
FROM pokemon p
JOIN types t1 ON p.primary_type_id = t1.type_id
LEFT JOIN types t2 ON p.secondary_type_id = t2.type_id;

-- Find all trainers and their Pokémon (including nicknames). --
SELECT t.name AS trainer_name, p.name AS pokemon_name, tp.nickname
FROM trainers t
JOIN trainer_pokemon tp ON t.trainer_id = tp.trainer_id
JOIN pokemon p ON tp.pokemon_id = p.pokemon_id;

-- Find all Pokémon that can evolve and their evolution details --
SELECT p1.name AS base_pokemon, p2.name AS evolved_pokemon, pe.min_level
FROM pokemon_evolution pe
JOIN pokemon p1 ON pe.base_pokemon_id = p1.pokemon_id
JOIN pokemon p2 ON pe.evolved_pokemon_id = p2.pokemon_id;

-- LEFT JOIN: All Types with Pokémon Count --
SELECT 
    t.type_name,
    COUNT(p.pokemon_id) AS total_pokemon
FROM types t
LEFT JOIN pokemon p 
    ON t.type_id = p.primary_type_id OR t.type_id = p.secondary_type_id
GROUP BY t.type_name;

-- FULL OUTER JOIN (Simulated): All Types and All Pokémon --
-- Combine LEFT JOIN and RIGHT JOIN using UNION
SELECT 
    t.type_name,
    p.name AS pokemon_name
FROM types t
LEFT JOIN pokemon p 
    ON t.type_id = p.primary_type_id OR t.type_id = p.secondary_type_id
UNION
SELECT 
    t.type_name,
    p.name AS pokemon_name
FROM types t
RIGHT JOIN pokemon p 
    ON t.type_id = p.primary_type_id OR t.type_id = p.secondary_type_id;
    
-- CROSS JOIN: All Possible Type Combinations --
SELECT 
    t1.type_name AS primary_type,
    t2.type_name AS secondary_type
FROM types t1
CROSS JOIN types t2
WHERE t1.type_id <> t2.type_id;  -- Exclude same-type combinations


-- PL/SQL

				-- Function

-- Function to calculate the total stats of a Pokémon. --
DELIMITER //

CREATE FUNCTION calculate_total_stats(pokemon_id INT)
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
SELECT calculate_total_stats(1) AS total_stats;  -- Pikachu's total stats


-- Function to get a Pokémon's type as a string --
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

-- Call the function
SELECT get_pokemon_type(1) AS pokemon_type;  -- Pikachu's type


-- Check if a Pokémon Can Evolve --
DELIMITER //

CREATE FUNCTION can_evolve(
    p_trainer_id INT,
    p_pokemon_id INT
)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE current_level INT;
    DECLARE required_level INT;
    DECLARE evolved_pokemon_name VARCHAR(50);

    -- Get the Pokémon's current level
    SELECT p.level INTO current_level
    FROM pokemon p
    JOIN trainer_pokemon tp ON p.pokemon_id = tp.pokemon_id
    WHERE tp.trainer_id = p_trainer_id AND tp.pokemon_id = p_pokemon_id;

    -- Check evolution requirements
    SELECT pe.min_level, p_evolved.name INTO required_level, evolved_pokemon_name
    FROM pokemon_evolution pe
    JOIN pokemon p_evolved ON pe.evolved_pokemon_id = p_evolved.pokemon_id
    WHERE pe.base_pokemon_id = p_pokemon_id;

    IF current_level >= required_level THEN
        RETURN CONCAT('Yes! Can evolve into ', evolved_pokemon_name);
    ELSE
        RETURN CONCAT('No. Needs level ', required_level, ' to evolve.');
    END IF;
END //

DELIMITER ;

-- Example usage:
SELECT can_evolve(1, 3) AS evolution_status;  -- Check if Ash's Bulbasaur (ID 3) can evolve



-- Calculate Trainer Team Power --
DELIMITER //

CREATE FUNCTION calculate_trainer_power(
    p_trainer_id INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_power INT;

    SELECT SUM(p.hp + p.attack + p.defense + p.speed) INTO total_power
    FROM pokemon p
    JOIN trainer_pokemon tp ON p.pokemon_id = tp.pokemon_id
    WHERE tp.trainer_id = p_trainer_id;

    RETURN total_power;
END //

DELIMITER ;

-- Example usage:
SELECT calculate_trainer_power(1) AS ash_team_power;  -- Ash's total team power



-- Generate Pokémon Report --
DELIMITER //

CREATE FUNCTION generate_pokemon_report(
    p_pokemon_id INT
)
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE report TEXT;
    DECLARE owner_name VARCHAR(50);

    -- Get owner name
    SELECT t.name INTO owner_name
    FROM trainers t
    JOIN trainer_pokemon tp ON t.trainer_id = tp.trainer_id
    WHERE tp.pokemon_id = p_pokemon_id;

    -- Build the report
    SELECT CONCAT(
        'Name: ', p.name, '\n',
        'Owner: ', IFNULL(owner_name, 'Wild Pokémon'), '\n',
        'Types: ', get_pokemon_type(p_pokemon_id), '\n',
        'HP: ', p.hp, ' | Attack: ', p.attack, ' | Defense: ', p.defense, ' | Speed: ', p.speed
    ) INTO report
    FROM pokemon p
    WHERE p.pokemon_id = p_pokemon_id;

    RETURN report;
END //

DELIMITER ;

-- Example usage:
SELECT generate_pokemon_report(1) AS pikachu_report;



-- Is Pokémon Fully Evolved? --
DELIMITER //

CREATE FUNCTION is_fully_evolved(p_pokemon_id INT)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE evolution_count INT;

    -- Check if the Pokémon has any future evolutions
    SELECT COUNT(*) INTO evolution_count
    FROM pokemon_evolution
    WHERE base_pokemon_id = p_pokemon_id;

    RETURN evolution_count = 0;
END //

DELIMITER ;

-- Example usage:
SELECT is_fully_evolved(2) AS is_fully_evolved;  -- Check if Charizard (ID 2) is fully evolved



-- Find Strongest Pokémon of a Type --
DELIMITER //

CREATE FUNCTION strongest_pokemon_by_type(p_type_name VARCHAR(20))
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE strongest_name VARCHAR(50);

    SELECT p.name INTO strongest_name
    FROM pokemon p
    JOIN types t ON p.primary_type_id = t.type_id OR p.secondary_type_id = t.type_id
    WHERE t.type_name = p_type_name
    ORDER BY p.attack DESC
    LIMIT 1;

    RETURN strongest_name;
END //

DELIMITER ;

-- Example usage:
SELECT strongest_pokemon_by_type('Fire') AS strongest_fire;  -- Returns "Charizard"


-- Calculate Type Popularity --
DELIMITER //

CREATE FUNCTION type_popularity(p_type_name VARCHAR(20))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE trainer_count INT;

    SELECT COUNT(DISTINCT tp.trainer_id) INTO trainer_count
    FROM trainer_pokemon tp
    JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
    JOIN types t ON p.primary_type_id = t.type_id OR p.secondary_type_id = t.type_id
    WHERE t.type_name = p_type_name;

    RETURN trainer_count;
END //

DELIMITER ;

-- Example usage:
SELECT type_popularity('Water') AS water_trainers;  -- Trainers with Water-types


-- Calculate Battle Winner --
DELIMITER //

CREATE FUNCTION battle_winner(
    p_pokemon1_id INT,
    p_pokemon2_id INT
)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE p1_power INT;
    DECLARE p2_power INT;

    -- Calculate total power for both Pokémon
    SELECT (attack + defense + speed) INTO p1_power FROM pokemon WHERE pokemon_id = p_pokemon1_id;
    SELECT (attack + defense + speed) INTO p2_power FROM pokemon WHERE pokemon_id = p_pokemon2_id;

    IF p1_power > p2_power THEN
        RETURN (SELECT name FROM pokemon WHERE pokemon_id = p_pokemon1_id);
    ELSEIF p2_power > p1_power THEN
        RETURN (SELECT name FROM pokemon WHERE pokemon_id = p_pokemon2_id);
    ELSE
        RETURN 'Draw';
    END IF;
END //

DELIMITER ;

-- Example usage:
SELECT battle_winner(1, 2) AS winner;  -- Pikachu vs. Charizard


				-- Procedures

-- Procedure to level up a Pokémon by adding 'x' to each stat. --
DELIMITER //

CREATE PROCEDURE level_up_pokemon(IN pokemon_id INT, IN x INT)
BEGIN
    -- Display before stats
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
CALL level_up_pokemon(1, 10);  -- Level up Pikachu by adding 10 to each stat


-- Procedure to get a trainer's Pokémon and their types. --
DELIMITER //

CREATE PROCEDURE get_trainer_pokemon_and_type(IN trainer_id INT)
BEGIN
    SELECT p.name AS pokemon_name, get_pokemon_type(p.pokemon_id) AS pokemon_type
    FROM trainer_pokemon tp
    JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
    WHERE tp.trainer_id = trainer_id;
END //

DELIMITER ;

-- Call the procedure
CALL get_trainer_pokemon_and_type(1);  -- Ash's Pokémon and their types



-- Evolve a Pokémon --
DELIMITER //

CREATE PROCEDURE evolve_pokemon(
    IN p_trainer_id INT,
    IN p_pokemon_id INT
)
BEGIN
    DECLARE current_level INT;
    DECLARE required_level INT;
    DECLARE evolved_pokemon_id INT;

    -- Get current level and evolution data
    SELECT p.level, pe.min_level, pe.evolved_pokemon_id
    INTO current_level, required_level, evolved_pokemon_id
    FROM pokemon p
    JOIN pokemon_evolution pe ON p.pokemon_id = pe.base_pokemon_id
    WHERE p.pokemon_id = p_pokemon_id;

    IF current_level >= required_level THEN
        -- Update the trainer's Pokémon to the evolved form
        UPDATE trainer_pokemon
        SET pokemon_id = evolved_pokemon_id
        WHERE trainer_id = p_trainer_id AND pokemon_id = p_pokemon_id;

        SELECT CONCAT('Pokémon evolved successfully to ID ', evolved_pokemon_id) AS result;
    ELSE
        SELECT 'Evolution failed: Insufficient level.' AS result;
    END IF;
END //

DELIMITER ;

-- Example usage:
CALL evolve_pokemon(1, 3);  -- Try evolving Ash's Bulbasaur (ID 3)


-- Transfer Pokémon Between Trainers --
DELIMITER //

CREATE PROCEDURE transfer_pokemon(
    IN p_old_trainer_id INT,
    IN p_new_trainer_id INT,
    IN p_pokemon_id INT,
    IN p_transfer_date DATE
)
BEGIN
    -- Check if the new trainer exists
    IF NOT EXISTS (SELECT 1 FROM trainers WHERE trainer_id = p_new_trainer_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New trainer does not exist.';
    END IF;

    -- Transfer the Pokémon
    UPDATE trainer_pokemon
    SET trainer_id = p_new_trainer_id, caught_date = p_transfer_date
    WHERE trainer_id = p_old_trainer_id AND pokemon_id = p_pokemon_id;

    SELECT 'Transfer successful!' AS result;
END //

DELIMITER ;

-- Example usage:
CALL transfer_pokemon(1, 4, 1, CURDATE());  -- Transfer Ash's Pikachu (ID 1) to Gary (ID 4)



-- Award Badge for Type Mastery --
DELIMITER //

CREATE PROCEDURE award_type_badge(
    IN p_trainer_id INT,
    IN p_type_name VARCHAR(20)
    )
BEGIN
    DECLARE type_count INT;

    -- Count Pokémon of the given type
    SELECT COUNT(*) INTO type_count
    FROM trainer_pokemon tp
    JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
    JOIN types t ON p.primary_type_id = t.type_id OR p.secondary_type_id = t.type_id
    WHERE tp.trainer_id = p_trainer_id AND t.type_name = p_type_name;

    -- Award badge if condition met
    IF type_count >= 3 THEN
        UPDATE trainers
        SET badges = badges + 1
        WHERE trainer_id = p_trainer_id;
        SELECT CONCAT('Badge awarded! Total badges: ', badges) AS result
        FROM trainers WHERE trainer_id = p_trainer_id;
    ELSE
        SELECT 'Not enough Pokémon of this type.' AS result;
    END IF;
END //

DELIMITER ;

-- Example usage:
CALL award_type_badge(1, 'Electric');  -- Check if Ash qualifies for an Electric badge



-- Heal All Pokémon for a Trainer --
DELIMITER //

CREATE PROCEDURE heal_all_pokemon(IN p_trainer_id INT)
BEGIN
    -- Store original HP in a temporary table (if original HP were tracked)
    -- For simplicity, assume HP is restored to a fixed value (e.g., 100)
    UPDATE pokemon p
    JOIN trainer_pokemon tp ON p.pokemon_id = tp.pokemon_id
    SET p.hp = 100  -- Replace with dynamic logic if base HP is available
    WHERE tp.trainer_id = p_trainer_id;

    SELECT CONCAT('Healed all Pokémon for trainer ', name) AS result
    FROM trainers
    WHERE trainer_id = p_trainer_id;
END //

DELIMITER ;

-- Example usage:
CALL heal_all_pokemon(1);  -- Heal Ash's Pokémon



-- Swap Pokémon Types --
DELIMITER //

CREATE PROCEDURE swap_pokemon_types(IN p_pokemon_id INT)
BEGIN
    DECLARE v_primary_type INT;
    DECLARE v_secondary_type INT;

    -- Get current types
    SELECT primary_type_id, secondary_type_id
    INTO v_primary_type, v_secondary_type
    FROM pokemon
    WHERE pokemon_id = p_pokemon_id;

    -- Swap types
    UPDATE pokemon
    SET primary_type_id = v_secondary_type,
        secondary_type_id = v_primary_type
    WHERE pokemon_id = p_pokemon_id;

    SELECT CONCAT('Swapped types for ', name) AS result
    FROM pokemon
    WHERE pokemon_id = p_pokemon_id;
END //

DELIMITER ;

-- Example usage:
CALL swap_pokemon_types(5);  -- Swap Jigglypuff's types (Normal/Fairy → Fairy/Normal)



-- Award "Dragon Master" Badge (at least 1 dragon) --
DELIMITER //

CREATE PROCEDURE award_dragon_master_badge()
BEGIN
    -- Update trainers with Dragon-type Pokémon
    UPDATE trainers t
    SET badges = badges + 1
    WHERE EXISTS (
        SELECT 1
        FROM trainer_pokemon tp
        JOIN pokemon p ON tp.pokemon_id = p.pokemon_id
        JOIN types t ON p.primary_type_id = t.type_id OR p.secondary_type_id = t.type_id
        WHERE t.type_name = 'Dragon' AND tp.trainer_id = t.trainer_id
    );

    SELECT CONCAT('Badges awarded to ', COUNT(*), ' trainers') AS result
    FROM trainers
    WHERE badges > 0;
END //

DELIMITER ;

-- Example usage:
CALL award_dragon_master_badge();  -- Lance (ID 5) qualifies


-- Rename Pokémon with Validation (≤ 20) --
DELIMITER //

CREATE PROCEDURE rename_pokemon(
    IN p_pokemon_id INT,
    IN p_new_name VARCHAR(50)
)
BEGIN
    IF LENGTH(p_new_name) > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name exceeds 20 characters.';
    ELSE
        UPDATE pokemon
        SET name = p_new_name
        WHERE pokemon_id = p_pokemon_id;
        SELECT CONCAT('Renamed to ', p_new_name) AS result;
    END IF;
END //

DELIMITER ;

-- Example usage:
CALL rename_pokemon(1, 'Pikachu2024');  -- Valid
CALL rename_pokemon(1, 'PikachuTheAmazingElectricMouse');  -- Fails


			-- combining

-- Find the trainer with the most Pokémon. --
SELECT t.name, COUNT(tp.pokemon_id) AS total_pokemon
FROM trainers t
JOIN trainer_pokemon tp ON t.trainer_id = tp.trainer_id
GROUP BY t.name
ORDER BY total_pokemon DESC
LIMIT 1;

-- Find the Pokémon with the highest total stats. --
SELECT name, calculate_total_stats(pokemon_id) AS total_stats
FROM pokemon
ORDER BY total_stats DESC
LIMIT 1;



		-- MID
-- Task 1: List all customers and their cities.
SELECT customer_name, customer_city
FROM customer;

-- Task 2: List the names and cities of customers who live in 'Salt Lake'.
SELECT customer_name, customer_city
FROM customer
WHERE customer_city = 'Salt Lake';

-- Task 3: Find the average balance for each branch.
SELECT branch_name, AVG(balance) AS average_balance
FROM account
GROUP BY branch_name;

-- Task 4: Find the branch names and cities for branches that have issued more than 2 loans.
SELECT b.branch_name, b.branch_city
FROM branch b
JOIN loan l ON b.branch_name = l.branch_name
GROUP BY b.branch_name, b.branch_city
HAVING COUNT(l.loan_number) > 2;

-- Task 5: Find the branch information for cities where at least one customer lives who does not have any account or any loans.
-- The branch must have given some loans and have accounts opened by other customers.
SELECT DISTINCT b.branch_name, b.branch_city, b.assets
FROM branch b
JOIN account a ON b.branch_name = a.branch_name
JOIN loan l ON b.branch_name = l.branch_name
WHERE b.branch_city IN (
    SELECT c.customer_city
    FROM customer c
    WHERE c.customer_name NOT IN (
        SELECT d.customer_name
        FROM depositor d
    ) AND c.customer_name NOT IN (
        SELECT br.customer_name
        FROM borrower br
    )
);

-- Task 6: List all accounts with balances below the average balance of their respective branches.
SELECT a.account_number, a.balance, a.branch_name
FROM account a
JOIN (
    SELECT branch_name, AVG(balance) AS avg_balance
    FROM account
    GROUP BY branch_name
) AS branch_avg ON a.branch_name = branch_avg.branch_name
WHERE a.balance < branch_avg.avg_balance;

-- Task 7: Compute the mean loan amount for each city where branches include 'Town' in their name.
SELECT b.branch_city, AVG(l.amount) AS mean_loan_amount
FROM branch b
JOIN loan l ON b.branch_name = l.branch_name
WHERE b.branch_name LIKE '%Town%'
GROUP BY b.branch_city;

-- Task 8: Find the branch with the highest total loan amount and list its details.
SELECT b.branch_name, b.branch_city, b.assets, SUM(l.amount) AS total_loan_amount
FROM branch b
JOIN loan l ON b.branch_name = l.branch_name
GROUP BY b.branch_name, b.branch_city, b.assets
ORDER BY total_loan_amount DESC
LIMIT 1;

-- Task 9: Find the top three customers with the highest single loan amounts.
SELECT c.customer_name, l.amount
FROM customer c
JOIN borrower br ON c.customer_name = br.customer_name
JOIN loan l ON br.loan_number = l.loan_number
ORDER BY l.amount DESC
LIMIT 3;

-- Task 10: Find the names of customers along with the total amount they have deposited across all their accounts.
SELECT d.customer_name, SUM(a.balance) AS total_deposited
FROM depositor d
JOIN account a ON d.account_number = a.account_number
GROUP BY d.customer_name;

-- Find the branch with the second highest total loan amount and list its details
SELECT b.branch_name, b.branch_city, b.assets, SUM(l.amount) AS total_loan_amount
FROM branch b
JOIN loan l ON b.branch_name = l.branch_name
GROUP BY b.branch_name, b.branch_city, b.assets
ORDER BY total_loan_amount DESC
LIMIT 1 OFFSET 1;

-- Find the branch(s) with the second highest total loan amount and list their details
WITH branch_loan_totals AS (
    SELECT 
        b.branch_name, 
        b.branch_city, 
        b.assets, 
        SUM(l.amount) AS total_loan_amount
    FROM branch b
    JOIN loan l ON b.branch_name = l.branch_name
    GROUP BY b.branch_name, b.branch_city, b.assets
)
SELECT branch_name, branch_city, assets, total_loan_amount
FROM branch_loan_totals
WHERE total_loan_amount = (
    SELECT DISTINCT total_loan_amount
    FROM branch_loan_totals
    ORDER BY total_loan_amount DESC
    LIMIT 1 OFFSET 1
);

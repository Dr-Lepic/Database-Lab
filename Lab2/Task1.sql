-- Table creation
CREATE TABLE Lab1.STUDENT(
	ID INT NOT NULL,
    NAME VARCHAR(50),
    DEPT_NAME VARCHAR(30),
    TOT_CRED INT,
    PRIMARY KEY (ID),
    CONSTRAINT VALIDITY_CHECK CHECK (TOT_CRED <= 180)
);

-- Data insert
INSERT INTO STUDENT (ID, NAME, DEPT_NAME, TOT_CRED) VALUES
(00128, 'Zhang', 'Comp. Sci.', 102),
(12345, 'Shankar', 'Comp. Sci.', 32),
(19991, 'Brandt', 'History', 80),
(23121, 'Chavez', 'Finance', 110),
(44553, 'Peltier', 'Physics', 56),
(45678, 'Levy', 'Physics', 46),
(54321, 'Williams', 'Comp. Sci.', 5),
(55739, 'Sanchez', 'Music', 38),
(70557, 'Snow', 'Physics', 0),
(76543, 'Brown', 'Comp. Sci.', 58),
(76653, 'Aoi', 'Elec. Eng.', 60),
(98765, 'Bourikas', 'Elec. Eng.', 9),
(98988, 'Tanaka', 'Biology', 120);

-- 3(a)
SELECT * FROM STUDENT;
-- 3(B)
SELECT ID, NAME FROM STUDENT;
-- 3(C)
SELECT NAME, DEPT_NAME FROM STUDENT
WHERE  (TOT_CRED >=80 AND TOT_CRED <= 120); 
-- 3(D)
SELECT ID, NAME FROM STUDENT WHERE DEPT_NAME = 'Comp. Sci.';
-- 3(E)
SELECT NAME, TOT_CRED FROM STUDENT WHERE DEPT_NAME = 'Physics';
-- 3(F)
SELECT ID, NAME FROM STUDENT WHERE DEPT_NAME = 'Comp. Sci.' OR TOT_CRED < 10;
-- 3(G)
SELECT DISTINCT DEPT_NAME FROM STUDENT;
-- 3(H)
DROP TABLE STUDENT CASCADE;

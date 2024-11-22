-- 1
CREATE OR REPLACE VIEW Advisor_Selection AS
SELECT ID, name, dept_name
FROM instructor;

-- 2
CREATE OR REPLACE VIEW Student_Count AS
SELECT Advisor_Selection.name AS instructor_name, COUNT(s_ID) AS student_count
FROM Advisor_Selection
JOIN advisor ON Advisor_Selection.ID = advisor.i_id
GROUP BY Advisor_Selection.name;

-- 3
CREATE ROLE 'Student';
GRANT SELECT ON advisor TO 'Student';
GRANT SELECT ON course TO 'Student';

CREATE ROLE 'CourseTeacher';
GRANT SELECT ON student TO 'CourseTeacher';
GRANT SELECT ON course TO 'CourseTeacher';

CREATE ROLE 'HeadOfDepartment';
GRANT CourseTeacher TO 'HeadOfDepartment';
GRANT INSERT ON instructor TO 'HeadOfDepartment';

CREATE ROLE 'Admin';
GRANT SELECT ON department TO Admin;
GRANT SELECT ON instructor TO Admin;
GRANT UPDATE (budget) ON department TO Admin;

-- 4
CREATE USER 'student2'@'localhost' IDENTIFIED BY '123'
default role 'Student';

CREATE USER 'teacher1'@'localhost' IDENTIFIED BY '123'
DEFAULT ROLE 'CourseTeacher';

CREATE USER 'hod1'@'localhost' IDENTIFIED BY '123'
DEFAULT ROLE 'HeadOfDepartment';

CREATE USER 'admin1'@'localhost' IDENTIFIED BY '123'
DEFAULT ROLE 'Admin';

FLUSH PRIVILEGES;

-- must maintain the order
CREATE TABLE Publication(
	title VARCHAR(50) NOT NULL,
    conference_name VARCHAR(50),
    date DATE,
    domain VARCHAR(15),
    summary VARCHAR(90),
    lab VARCHAR(20),
    project VARCHAR(50), -- WILL ADD FOREIGN KEY LATER
    PRIMARY KEY (title)
);

CREATE TABLE ResearchGroup(
	name VARCHAR(20) NOT NULL,
	lab VARCHAR(20),
    budget numeric(8,2) check (budget > 0),
    head VARCHAR(5), -- WILL ADD FOREIGN KEY LATER
    PRIMARY KEY (name)
);

CREATE TABLE Faculty(
	ID VARCHAR(5) NOT NULL,
	name VARCHAR(20),
    number INT,
    lab VARCHAR(20),
    group_name VARCHAR(20),
    PRIMARY KEY (ID),
    FOREIGN KEY (group_name) REFERENCES ResearchGroup (name)
    ON DELETE SET NULL
);

CREATE TABLE Student(
	ID VARCHAR(5) NOT NULL,
    name VARCHAR(20), 
    number INT,
    research_lab VARCHAR(20),
    advisor VARCHAR(5),
    group_name VARCHAR(20),
    
    PRIMARY KEY (ID),
    FOREIGN KEY (advisor) REFERENCES Faculty (ID)
    ON DELETE SET NULL,
    FOREIGN KEY (group_name) REFERENCES ResearchGroup (name)
    ON DELETE SET NULL
);

ALTER TABLE ResearchGroup
ADD CONSTRAINT FK_HEAD
FOREIGN KEY (head) REFERENCES Student(ID)
ON DELETE SET NULL;

CREATE TABLE ResearchProject(
	title VARCHAR(50) NOT NULL,
    start_date DATE,
    end_date DATE,
    domain VARCHAR(30),
	group_name VARCHAR(20),
    supervisor VARCHAR(5),
    
    PRIMARY KEY (title),
    FOREIGN KEY (group_name) REFERENCES ResearchGroup (name)
    ON DELETE SET NULL,
    FOREIGN KEY (supervisor) REFERENCES Faculty (ID)
    ON DELETE SET NULL
);

ALTER TABLE Publication
ADD CONSTRAINT FK_PROJECT
FOREIGN KEY (project) REFERENCES ResearchProject(title)
ON DELETE SET NULL;

ALTER TABLE Publication
DROP CONSTRAINT FK_PROJECT;

ALTER TABLE ResearchGroup
DROP CONSTRAINT FK_HEAD;

DROP TABLE Publication;
DROP TABLE Student;
DROP TABLE ResearchProject;
DROP TABLE Faculty;
DROP TABLE ResearchGroup;


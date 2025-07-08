CREATE DATABASE assignmentone11;
GO

--USE assignmentone11;
GO

CREATE TABLE department (
    dnum INT PRIMARY KEY,
    dname VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    manager_ssn INT,
    manager_hire_date DATE
);

CREATE TABLE employee (
    ssn INT PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('m', 'f')),
    department_id INT NOT NULL,
    supervisor_ssn INT,
    FOREIGN KEY (department_id) REFERENCES department(dnum),
    FOREIGN KEY (supervisor_ssn) REFERENCES employee(ssn)
);

CREATE TABLE project (
    pnumber INT PRIMARY KEY,
    pname VARCHAR(100),
    location VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES department(dnum)
);

CREATE TABLE dependent (
    dependent_name VARCHAR(100) PRIMARY KEY,
    gender CHAR(1) CHECK (gender IN ('m', 'f')),
    birth_date DATE,
    employee_ssn INT,
    FOREIGN KEY (employee_ssn) REFERENCES employee(ssn) ON DELETE CASCADE
);

CREATE TABLE works_on (
    essn INT,
    pno INT,
    hours FLOAT,
    PRIMARY KEY (essn, pno),
    FOREIGN KEY (essn) REFERENCES employee(ssn),
    FOREIGN KEY (pno) REFERENCES project(pnumber)
);

INSERT INTO department VALUES (1, 'hr', 'cairo', 1001, NULL);
INSERT INTO department VALUES (2, 'it', 'alex', 1002, NULL);
INSERT INTO department VALUES (3, 'finance', 'giza', 1003, NULL);

INSERT INTO employee VALUES (1001, 'ali', 'hassan', '1985-03-01', 'm', 1, NULL);
INSERT INTO employee VALUES (1002, 'mona', 'ibrahim', '1990-07-12', 'f', 1, 1001);
INSERT INTO employee VALUES (1003, 'omar', 'kamal', '1988-11-22', 'm', 2, 1001);
INSERT INTO employee VALUES (1004, 'sara', 'adel', '1992-06-15', 'f', 2, 1003);
INSERT INTO employee VALUES (1005, 'hani', 'saad', '1991-09-30', 'm', 3, 1003);

ALTER TABLE department
ADD CONSTRAINT fk_manager_ssn
FOREIGN KEY (manager_ssn) REFERENCES employee(ssn)
ON DELETE SET NULL ON UPDATE CASCADE;

UPDATE department SET manager_ssn = 1001, manager_hire_date = '2010-01-01' WHERE dnum = 1;
UPDATE department SET manager_ssn = 1003, manager_hire_date = '2012-05-10' WHERE dnum = 2;
UPDATE department SET manager_ssn = 1005, manager_hire_date = '2015-08-20' WHERE dnum = 3;

INSERT INTO project VALUES (101, 'erp system', 'cairo', 1);
INSERT INTO project VALUES (102, 'website', 'alex', 2);

INSERT INTO works_on VALUES (1001, 101, 20.5);
INSERT INTO works_on VALUES (1002, 101, 15.0);
INSERT INTO works_on VALUES (1003, 102, 30.0);

INSERT INTO dependent VALUES ('omar jr', 'm', '2010-06-01', 1001);
INSERT INTO dependent VALUES ('sara jr', 'f', '2012-08-12', 1002);

UPDATE employee SET department_id = 3 WHERE ssn = 1002;

DELETE FROM dependent WHERE dependent_name = 'sara jr';

SELECT * FROM employee WHERE department_id = 2;

SELECT e.fname, e.lname, p.pname, w.hours
FROM employee e
JOIN works_on w ON e.ssn = w.essn
JOIN project p ON w.pno = p.pnumber;

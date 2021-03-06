USE daeshik_sql;

-- drop tables associated with foreign keys
SET foreign_key_checks = 0; -- 0 = off
DROP TABLE IF EXISTS employee, branch, client, branch_supplier, works_with;
SET foreign_key_checks = 1; -- 1 = on

CREATE TABLE employee (
  emp_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(40) NOT NULL,
  last_name VARCHAR(40) NOT NULL,
  birth_day DATE, -- date format: 'yyyy-mm-dd'
  sex VARCHAR(1),
  salary INT,
  super_id INT, -- foreign key to be defined later
  branch_id INT -- foreign key to be defined later
);

ALTER TABLE employee AUTO_INCREMENT = 100;
ALTER TABLE employee
RENAME COLUMN birth_day to birth_date;

ALTER TABLE employee
ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT, # foreign key to be defined later
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id), -- unique combination between two
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Corporate
INSERT INTO employee VALUES (DEFAULT, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES (1, 'Corporate', 100, '2006-02-09');

UPDATE employee SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES (DEFAULT, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES (DEFAULT, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES (2, 'Scranton', 102, '1992-04-06');

UPDATE employee SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES
	(DEFAULT, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2),
    (DEFAULT, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2),
	(DEFAULT, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES (DEFAULT, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES (3, 'Stamford', 106, '1998-02-13');

UPDATE employee SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES
	(DEFAULT, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3),
	(DEFAULT, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES
	(2, 'Hammer Mill', 'Paper'),
	(2, 'Uni-ball', 'Writing Utensils'),
	(3, 'Patriot Paper', 'Paper'),
	(2, 'J.T. Forms & Labels', 'Custom Forms'),
	(3, 'Uni-ball', 'Writing Utensils'),
	(3, 'Hammer Mill', 'Paper'),
	(3, 'Stamford Labels', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES
	(400, 'Dunmore Highschool', 2),
	(401, 'Lackawana Country', 2),
	(402, 'FedEx', 3),
	(403, 'John Daly Law, LLC', 3),
	(404, 'Scranton Whitepages', 2),
	(405, 'Times Newspaper', 3),
	(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES
	(105, 400, 55000), (102, 401, 267000), (108, 402, 22500), (107, 403, 5000),
	(108, 403, 12000), (105, 404, 33000), (107, 405, 26000), (102, 406, 15000),
	(105, 406, 130000);

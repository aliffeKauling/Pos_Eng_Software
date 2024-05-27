CREATE SCHEMA company;

CREATE DOMAIN company.t_sex AS CHAR CONSTRAINT ck_t_sex CHECK (value IN ('M', 'F', 'O'));

CREATE TABLE company.employee (
  fname VARCHAR(30),
  minit VARCHAR(10),
  lname VARCHAR(30),
  ssn INT,
  bdate DATE,
  address VARCHAR(200),
  sex company.t_sex,
  salary NUMERIC(10,2),
  super_ssn INT,
  dno INT NOT NULL,
  CONSTRAINT pk_employee PRIMARY KEY(ssn),
  CONSTRAINT fk_employee_has_supervisor FOREIGN KEY(super_ssn) REFERENCES company.employee(ssn) ON DELETE SET NULL
);

CREATE SEQUENCE company.departament_dnumber_seq START 10 INCREMENT 10;

CREATE TABLE company.department (
  dname VARCHAR(50) NOT NULL,
  dnumber INT DEFAULT nextval('company.departament_dnumber_seq'),
  mgr_ssn INT NOT NULL,
  mgr_start_date DATE DEFAULT 'today',
  CONSTRAINT pk_department PRIMARY KEY(dnumber),
  CONSTRAINT uk_department_dname UNIQUE(dname),
  CONSTRAINT fk_department_has_manager FOREIGN KEY(mgr_ssn) REFERENCES company.employee(ssn)
    DEFERRABLE INITIALLY DEFERRED
);

ALTER TABLE company.employee ADD CONSTRAINT fk_employee_worksfor_department
  FOREIGN KEY(dno) REFERENCES company.department(dnumber)
  DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE company.dept_locations (
  dnumber INT,
  dlocation VARCHAR(100),
  CONSTRAINT pk_dept_locations PRIMARY KEY(dnumber, dlocation),
  CONSTRAINT fk_deptlocations_of_department FOREIGN KEY(dnumber)
	REFERENCES company.department(dnumber) ON DELETE CASCADE
);

CREATE SEQUENCE company.project_number_seq;

CREATE TABLE company.project (
  pname VARCHAR(100) NOT NULL,
  pnumber INT DEFAULT nextval('company.project_number_seq'),
  plocation VARCHAR(100),
  dnum INT NOT NULL,
  CONSTRAINT pk_project PRIMARY KEY(pnumber),
  CONSTRAINT uk_project_pname UNIQUE(pname),
  CONSTRAINT fk_project_iscontrolledby_department FOREIGN KEY(dnum)
	REFERENCES company.department(dnumber)
);

CREATE TABLE company.works_on (
  essn INT,
  pno INT,
  hours FLOAT,
  CONSTRAINT pk_works_on PRIMARY KEY(essn, pno),
  CONSTRAINT fk_workson_employee FOREIGN KEY(essn) REFERENCES company.employee(ssn),
  CONSTRAINT fk_workson_project FOREIGN KEY(pno) REFERENCES company.project(pnumber),
  CONSTRAINT ck_workson_hours CHECK (hours >= 0.0 AND hours <= 40.00)
);

CREATE TABLE company.dependent (
  essn INT,
  dependent_name VARCHAR(200),
  bdate DATE,
  relationship VARCHAR(8),
  CONSTRAINT pk_dependent PRIMARY KEY(essn, dependent_name),
  CONSTRAINT fk_dependent_of_employee FOREIGN KEY(essn) REFERENCES company.employee(ssn),
  CONSTRAINT ck_dependent_relationship CHECK (relationship IN ('Spouse', 'Son', 'Daughter'))
);

ALTER TABLE company.dependent ADD COLUMN sex company.t_sex;

ALTER TABLE company.employee ALTER COLUMN fname SET NOT NULL, ALTER COLUMN lname SET NOT NULL;
employee(
  fname VARCHAR(30) NOT NULL,
  minit VARCHAR(10),
  lname VARCHAR(30) NOT NULL,
  ssn INT PRIMARY KEY,
  bdate DATE,
  address VARCHAR(200),
  sex CHAR(1) CHECK (sex IN ('M', 'F', 'O')),
  salary NUMERIC(10,2),
  super_ssn INT,
  dno INT NOT NULL,
  FOREIGN KEY (dno) REFERENCES department (dnumber)
);

department(
  dname VARCHAR(50) NOT NULL,
  dnumber INT PRIMARY KEY,
  mgr_ssn INT NOT NULL,
  mgr_start_date DATE DEFAULT CURRENT_DATE,
  UNIQUE (dname),
  FOREIGN KEY (mgr_ssn) REFERENCES employee (ssn) DEFERRABLE INITIALLY DEFERRED
);

dept_locations(
  dnumber INT,
  dlocation VARCHAR(100),
  PRIMARY KEY (dnumber, dlocation),
  FOREIGN KEY (dnumber) REFERENCES department (dnumber) ON DELETE CASCADE
);

project(
  pname VARCHAR(100) NOT NULL,
  pnumber INT PRIMARY KEY,
  plocation VARCHAR(100),
  dnum INT NOT NULL,
  FOREIGN KEY (dnum) REFERENCES department (dnumber)
);

works_on(
  essn INT,
  pno INT,
  hours FLOAT CHECK (hours >= 0.0 AND hours <= 40.00),
  PRIMARY KEY (essn, pno),
  FOREIGN KEY (essn) REFERENCES employee (ssn),
  FOREIGN KEY (pno) REFERENCES project (pnumber)
);

dependent(
  essn INT,
  dependent_name VARCHAR(200),
  bdate DATE,
  relationship VARCHAR(8) CHECK (relationship IN ('Spouse', 'Son', 'Daughter')),
  sex CHAR(1) CHECK (sex IN ('M', 'F', 'O')),
  PRIMARY KEY (essn, dependent_name),
  FOREIGN KEY (essn) REFERENCES employee (ssn)
);

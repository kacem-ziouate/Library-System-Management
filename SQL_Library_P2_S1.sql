--Library Management System Project 2

--Branch table
DROP TABLE IF EXISTS Branch;
CREATE TABLE Branch
            (
            branch_id	VARCHAR(15) PRIMARY KEY,
			manager_id		VARCHAR(15),
			branch_address		VARCHAR(40),
			contact_no  	VARCHAR(15)
            );

--Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
            (
			emp_id	VARCHAR(15) PRIMARY KEY,
			emp_name	VARCHAR(25),
			position	VARCHAR(15),
			salary	 INT ,
			branch_id  VARCHAR(15)
			);

ALTER TABLE employees 
ALTER COLUMNS salary TYPE FLOAT;


--BOOKS Table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books
             (
              isbn	VARCHAR(20) PRIMARY KEY,
			  book_title	VARCHAR(80),
			  category	VARCHAR(20),
			  rental_price	FLOAT,
			  status	VARCHAR(10),
			  author	VARCHAR(30),
			  publisher VARCHAR(50)
			  );
--Members Table
DROP TABLE IF EXISTS Members;
CREATE TABLE Members
             (
			 member_id	VARCHAR(20) PRIMARY KEY,
			 member_name VARCHAR(30),
			 member_address	VARCHAR(80),
			 reg_date DATE
			 );
--issued_status Table
DROP TABLE IF EXISTS issued_status ;
CREATE TABLE issued_status
             (
			 issued_id	VARCHAR(20) PRIMARY KEY,
			 issued_member_id	VARCHAR(20),
			 issued_book_name	VARCHAR(80),
			 issued_date	DATE,
			 issued_book_isbn	VARCHAR(30),
			 issued_emp_id  VARCHAR(20)			 
			 );
--Return_status Table
DROP TABLE IF EXISTS return_status ;
CREATE TABLE return_status
             (
			 return_id	VARCHAR(20) PRIMARY KEY,
			 issued_id	VARCHAR(20),
			 return_book_name	VARCHAR(80),
			 return_date	DATE,
			 return_book_isbn VARCHAR(40)
			 );

--ADD a FOREIGN KEY
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

--ADD a FOREIGN KEY for books
ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

--ADD a FOREIGN KEY for employees
ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

--
ALTER TABLE Employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

--
ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

--



























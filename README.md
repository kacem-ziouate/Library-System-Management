# Library Management System 

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_P2`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library-Management-System-pptx-1-2048](https://github.com/user-attachments/assets/d22483b3-9505-48a8-9e21-a6e0d592dcda)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup

<img width="1342" height="1014" alt="Screenshot 2025-12-19 at 17 32 07" src="https://github.com/user-attachments/assets/5fbcf88d-ca86-4e15-8cfe-873585526970" />


- **Database Creation**: Created a database named `library_P2`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
    --Branch table
      DROP TABLE IF EXISTS Branch;
      CREATE TABLE Branch
            (
            branch_id	VARCHAR(15) PRIMARY KEY,
            manager_id	VARCHAR(15),
            branch_address VARCHAR(40),
            contact_no  VARCHAR(15)
            );

    --Employees Table
    DROP TABLE IF EXISTS employees;
    CREATE TABLE employees
            (
             emp_id VARCHAR(15) PRIMARY KEY,
             emp_name VARCHAR(25),
             position	VARCHAR(15),
             salary	 INT ,
             branch_id  VARCHAR(15)
            );


    --BOOKS Table
    DROP TABLE IF EXISTS Books;
    CREATE TABLE Books
             (
              isbn VARCHAR(20) PRIMARY KEY,
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


```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '53 b3 lots my driis el merja fes'
WHERE member_id = 'C101';
SELECT * FROM members
WHERE member_id = 'C101'

```
<img width="688" height="155" alt="Screenshot 2025-12-19 at 17 50 44" src="https://github.com/user-attachments/assets/a1431815-a950-43f5-8568-eb6cf75c89f5" />

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```
<img width="1064" height="221" alt="Screenshot 2025-12-19 at 17 52 15" src="https://github.com/user-attachments/assets/4c1b475f-c6d0-41a6-b76b-fdf9ea025d2c" />


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
      issued_emp_id,
	  COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1
```
<img width="772" height="365" alt="Screenshot 2025-12-19 at 17 53 17" src="https://github.com/user-attachments/assets/927dc60d-8fe0-4e40-a9ff-fb0d8397a339" />

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_count
AS
SELECT 
      b.isbn,
	  b.book_title,
	  COUNT(ist.issued_id) AS no_issued
FROM books as b
JOIN 
issued_status as ist 
ON ist.issued_book_isbn = b.isbn
GROUP BY 1 , 2;
```
<img width="1123" height="933" alt="Screenshot 2025-12-19 at 17 55 33" src="https://github.com/user-attachments/assets/6ffde8f2-6ce9-4781-8e63-d8c777f60b93" />


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Literary Fiction'

```
<img width="1251" height="159" alt="Screenshot 2025-12-19 at 17 56 50" src="https://github.com/user-attachments/assets/b5c7c4c7-a572-430d-9f38-a5e08695ac57" />

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT
      b.category,
	  SUM(b.rental_price),
	  COUNT(*)
	 
FROM books as b
JOIN 
issued_status as ist 
ON ist.issued_book_isbn = b.isbn
GROUP BY 1 
```
<img width="771" height="386" alt="Screenshot 2025-12-19 at 17 57 40" src="https://github.com/user-attachments/assets/46f06d95-b4e8-41e1-9af7-ed698ae45b67" />

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```
<img width="628" height="207" alt="Screenshot 2025-12-19 at 17 59 22" src="https://github.com/user-attachments/assets/de5f575c-8536-4720-992c-ecef13c8a16a" />

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT
      e1.*,
	  b.manager_id,
	  e2.emp_name AS manager

FROM employees AS e1
JOIN
branch AS b
ON b.branch_id = e1.branch_id
JOIN 
employees AS e2 
ON b.manager_id = e2.emp_id
```
<img width="1208" height="404" alt="Screenshot 2025-12-19 at 18 00 27" src="https://github.com/user-attachments/assets/98a0042f-63f7-4498-bacd-8a78b2f240e0" />

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE higher_price_books
AS
SELECT * FROM books 
WHERE rental_price > 7
```
<img width="1289" height="309" alt="Screenshot 2025-12-19 at 18 00 57" src="https://github.com/user-attachments/assets/02702ac3-b9ec-49f9-8cbf-8f7fb2cc1a21" />

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
      DISTINCT ist.issued_book_name
FROM issued_status AS ist
     LEFT JOIN 
         return_status AS rs
     ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

```
<img width="610" height="653" alt="Screenshot 2025-12-19 at 18 02 05" src="https://github.com/user-attachments/assets/1a5629c2-32f2-4e62-add2-1def5fa04b46" />

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
/*
what must do 
 1 join tables like issued_status == members == books == return_status 
 2 filter books which in return
 3 overdue > 30
*/


SELECT 
      ist.issued_member_id,
	  m.member_name,
	  bk.book_title,
	  ist.issued_date,
	  CURRENT_DATE - ist.issued_date AS over_dues_days

FROM issued_status AS ist 
JOIN
members AS m 
    ON m.member_id = ist.issued_member_id
JOIN 
books AS bk 
    ON bk.isbn = issued_book_isbn
LEFT JOIN
return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE 
     rs.return_date IS NULL
	 AND (CURRENT_DATE - ist.issued_date ) > 30
ORDER BY 1
 
```
<img width="1192" height="555" alt="Screenshot 2025-12-19 at 18 03 33" src="https://github.com/user-attachments/assets/664fa425-2bcf-492d-9e4e-fe2f63c6ca57" />


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

/*
update to yes when the book return to the library and will be available 
*/
-- the code below show us how to do it manually 

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2'

SELECT * FROM books 
WHERE isbn = '978-0-451-52994-2'

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2'

SELECT * FROM return_status
WHERE issued_id = 'IS130'

--
INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
VALUES
    ('RS125', 'IS130', CURRENT_DATE, 'Good')
SELECT * FROM return_status
WHERE issued_id = 'IS130'

UPDATE books
SET status = 'yes'
WHERE isbn = '978-0-451-52994-2'

--And now we set a SQL code that do it automatically 

--store procedures 

CREATE OR REPLACE PROCEDURE  add_return_books(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$ 

DECLARE
       v_isbn VARCHAR(50);
	   v_book_name VARCHAR(80);
	   
BEGIN 
     --all code and logic
	 INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
     VALUES
     (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	 SELECT
	       issued_book_isbn,
		   issued_book_name
		   INTO
		   v_isbn,
		   v_book_name
	 FROM issued_status
	 WHERE issued_id = p_issued_id;
	 
	 UPDATE books
     SET status = 'yes'
	 WHERE isbn = v_isbn;

	 RAISE NOTICE 'thank you for returning the book: %' , v_book_name;
	 
END;
$$

--testing function 
issued_id = IS135
ISBN = WHERE isbn = '978-0-7432-7357-1'

SELECT * FROM books
WHERE isbn = '978-0-7432-7357-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-7432-7357-1';

SELECT * FROM return_status
WHERE issued_id = 'IS136';

CALL add_return_books('RS140','IS135','Good');

CALL add_return_books('RS141','IS136','Good');

```

<img width="1026" height="154" alt="Screenshot 2025-12-19 at 18 09 24" src="https://github.com/user-attachments/assets/15fe2436-e016-465a-b51a-69f35dbebe95" />



**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
--USSING JOINS

CREATE TABLE branch_report
AS

SELECT
      bc.branch_id,
	  bc.manager_id,
	  COUNT(ist.issued_id) AS number_book_issued,
	  COUNT(rs.return_id) AS number_of_return,
	  SUM(bk.rental_price) AS total_revenue

FROM issued_status AS ist 
JOIN
employees AS e 
    ON e.emp_id = ist.issued_emp_id
JOIN 
branch AS bc 
    ON e.branch_id = bc.branch_id
LEFT JOIN
return_status AS rs
    ON rs.issued_id = ist.issued_id
JOIN
books AS bk
    ON ist.issued_book_isbn = bk.isbn
GROUP BY 1 , 2 
```
<img width="893" height="250" alt="Screenshot 2025-12-19 at 18 10 25" src="https://github.com/user-attachments/assets/4c4a7f13-84ac-4ab8-8bca-60c56cae5195" />

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 

                          issued_member_id
                          FROM issued_status
                          WHERE 
                                issued_date >= CURRENT_DATE - INTERVAL '6 month'

                      )

SELECT * FROM active_members

```
<img width="613" height="253" alt="Screenshot 2025-12-19 at 18 11 36" src="https://github.com/user-attachments/assets/567f47ae-4985-4743-8cfe-38fc1c7a3993" />


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
      e.emp_name,
	  bc.*,
	  COUNT(ist.issued_id)
      
FROM issued_status AS ist 
JOIN 
employees AS e 
    ON e.emp_id = ist.issued_emp_id
JOIN 
branch AS bc
    ON e.branch_id = bc.branch_id
GROUP BY 1 , 2
```
<img width="1203" height="408" alt="Screenshot 2025-12-19 at 18 12 54" src="https://github.com/user-attachments/assets/520e2023-f0c2-4e88-9779-3b8ed357336f" />



**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

SELECT * FROM books;





CREATE OR REPLACE PROCEDURE issued_book(p_issued_id VARCHAR(10) ,
                                        p_issued_member_id VARCHAR(30), 
										p_issued_book_isbn VARCHAR(30), 
										p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
      v_status VARCHAR(10);

BEGIN

     SELECT 
	       status
		   INTO
		   v_status
	 FROM books
	 WHERE isbn = p_issued_book_isbn;

	 IF v_status = 'yes' 
	    THEN
		    INSERT INTO issued_status(issued_id,
			                          issued_member_id, 
									  issued_date , 
									  issued_book_isbn , 
									  issued_emp_id)
			VALUES
			(p_issued_id,
			 p_issued_member_id,
			 CURRENT_DATE,
			 p_issued_book_isbn,
			 p_issued_emp_id
			 );

			 UPDATE books
                   SET status = 'no'
	         WHERE isbn = p_issued_book_isbn;

	         RAISE NOTICE 'book records added successfully : %' , p_issued_book_isbn;   
			 
	 ELSE
	     RAISE NOTICE 'the book you have requested is unavailable book_isbn: %' , p_issued_book_isbn;   


	 END IF;


END;
$$
SELECT * FROM books;
--978-0-553-29698-2  yes
--978-0-375-41398-8   no

CALL issued_book('IS156','C108','978-0-375-41398-8','E104')

SELECT * FROM books
WHERE isbn = '978-0-553-29698-2'

```
<img width="1215" height="145" alt="Screenshot 2025-12-19 at 18 14 21" src="https://github.com/user-attachments/assets/8efc0589-660e-44ba-9f73-b2f2fbae0d84" />



**Task 19: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
```sql
SELECT 
       m.member_id, 
	   m.member_name, 
	   COUNT(member_id) AS books_overdue,
	   SUM((CURRENT_DATE - (ist.issued_date + INTERVAL '30 Days')::DATE) * 0.50) AS total_fines	
FROM members AS m
JOIN 
    issued_status AS ist
	ON ist.issued_member_id = m.member_id
LEFT JOIN return_status AS rs
	ON rs.issued_id = ist.issued_id
JOIN books AS b
	ON b.isbn = ist.issued_book_isbn
WHERE return_date IS NULL 
	AND CURRENT_DATE - (ist.issued_date + INTERVAL '30 Days')::DATE > 0
GROUP BY 1,2

```
<img width="668" height="326" alt="Screenshot 2025-12-19 at 18 15 39" src="https://github.com/user-attachments/assets/fe6a8944-d1be-49d5-8dde-2824f9f935ec" />

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   https://github.com/kacem-ziouate/Library-System-Management.git
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `analysis_queries.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - KACEM ZIOUATE 

This project showcases SQL skills essential for database management and analysis. 

Thank you for your interest in this project!

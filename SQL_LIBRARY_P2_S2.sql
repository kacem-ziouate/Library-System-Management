SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--Project Task 

--CRUD Operations

--1: Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

--2: Update an Existing Member's Address

UPDATE members
SET member_address = '53 b3 lots my driis el merja fes'
WHERE member_id = 'C101';
SELECT * FROM members;

--3: Delete a Record from the Issued Status Table considering THAT IT NOT EXIST IN return_status table 


DELETE FROM issued_status

WHERE  issued_id = 'IS121'


SELECT * FROM issued_status;

--4: Retrieve All Books Issued by a Specific Employee

SELECT * FROM issued_status
WHERE  issued_emp_id = 'E101' 

--5: List Members Who Have Issued More Than One Book 

SELECT
      issued_emp_id,
	  COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1

-- CTAS (Create Table As Select)

-- 6: Create Summary Tables: Used CTAS to generate new

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


SELECT * FROM book_count;

--Data Analysis & Findings


--7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Literary Fiction'

-- 8: Find Total Rental Income by Category:

SELECT
      b.category,
	  SUM(b.rental_price),
	  COUNT(*)
	 
FROM books as b
JOIN 
issued_status as ist 
ON ist.issued_book_isbn = b.isbn
GROUP BY 1 

--9 :List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'

INSERT INTO members(member_id , member_name, member_address,reg_date)
VALUES
('C122', 'MOM' , 'LOTS MY DRISS', '2025-11-01'),
('C123', 'IBRA' , 'LOTS FES', '2025-10-01');

--10  :List Employees with Their Branch Manager's Name and their branch details:
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

-- 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE higher_price_books
AS
SELECT * FROM books 
WHERE rental_price > 7

SELECT * FROM higher_price_books

--12: Retrieve the List of Books Not Yet Returned

SELECT 
      DISTINCT ist.issued_book_name
FROM issued_status AS ist
     LEFT JOIN 
         return_status AS rs
     ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL


























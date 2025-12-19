--Advanced SQL Operations

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--13: Identify Members with Overdue Books
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
 
--14: Update Book Status on Return
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

CALL add_return_books();

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

--15: Branch Performance Report
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

SELECT * FROM branch_report;

--16: CTAS: Create a Table of Active Members

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 

                          issued_member_id
                          FROM issued_status
                          WHERE 
                                issued_date >= CURRENT_DATE - INTERVAL '6 month'

                      )


--17: Find Employees with the Most Book Issues Processed

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


--18: Stored Procedure

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

--19: Create Table As Select (CTAS) Objective: Create a CTAS
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

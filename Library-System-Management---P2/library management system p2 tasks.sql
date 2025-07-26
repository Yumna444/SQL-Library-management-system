SELECT*FROM books;
SELECT*FROM branch;
SELECT*FROM employees;
SELECT*FROM issued_status;
SELECT*FROM return_status;
SELECT*FROM members;

--PROJECT TASK
--Task 1: Insert a New Book Entry
--Add a new record into the book database with the following details (rephrased for clarity):

--ISBN: 978-1-60129-456-2

1--Title: To Kill a Mockingbird

2--Genre: Classic

3--Price: 6.00

4--Availability: Yes

5--Author: Harper Lee

6--Publisher: J.B. Lippincott & Co.

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

--Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '123 Main St'
WHERE member_id = 'C101';
SELECT*FROM members;


--Task 3: Remove a Record from the Issued Status Table
--Objective is to Delete the entry from the issued_status table where issued_id is 'IS121'.
SELECT*FROM issued_status;
DELETE FROM issued_status
WHERE   issued_id =   'IS121';


--Task 4: Retrieve Books Issued by a Specific Employee
--Objective is to Display all records of books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

--Task 5: List Members Who Have Issued More Than One Book 
--Objective is to use GROUP BY to find members who have issued more than one book.

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

--CTAS
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts AS
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;


--Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic';


--Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1

--TASK 9:List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
INSERT INTO members(member_id, member_name, member_address, reg_date )
VALUES
('C120', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C122', 'Liam Walker', '789 Spruce St', '2024-07-26');

--TASK 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM books
WHERE rental_price > 7.00

SELECT * FROM
books_price_greater_than_seven


Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

--PROJECT COMPLETED





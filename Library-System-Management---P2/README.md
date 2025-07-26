📚 Library System Management – SQL Project (pgAdmin 4)
This project demonstrates the design and implementation of a relational Library Management System using PostgreSQL in pgAdmin 4. It includes database schema creation, foreign key relationships, and a series of CRUD operations and analytical queries for efficient management of library resources.

 📁 Project Structure

1. **Entity-Relationship Design**
   - Tables: `branch`, `employees`, `books`, `members`, `issued_status`, `return_status`
   - Relationships implemented via primary and foreign keys

2. **Database Setup**
   - Database Name: `library`
   - Screenshot: 📸
     <img width="3000" height="2000" alt="image" src="https://github.com/user-attachments/assets/566839ee-670e-4335-9bb4-2f7f4407e793" />


3. **Table Creation**
   - Uses `CREATE TABLE` with appropriate data types and constraints
   - Includes `ALTER TABLE` to define foreign keys

4. **CRUD Operations**
   - Perform `INSERT`, `UPDATE`, `DELETE`, `SELECT` on various tables

5. **Project Tasks**
   - 12 real-world use cases implemented via SQL queries

6. **Summary & Reporting**
   - Uses `JOIN`, `GROUP BY`, `HAVING`, `CTAS`, and subqueries for analysis

---

## 🗄️ Database Tables

| Table Name       | Description                                           |
|------------------|-------------------------------------------------------|
| `branch`         | Stores branch info and manager contact                |
| `employees`      | Employee records linked to branches                   |
| `books`          | Book catalog with pricing, status, and metadata       |
| `members`        | Library members and their registration dates          |
| `issued_status`  | Records of issued books to members                    |
| `return_status`  | Tracks returned books                                 |

---

## 🔐 Relationships & Constraints

- **`employees.branch_id` → `branch.branch_id`**
- **`issued_status.issued_member_id` → `members.member_id`**
- **`issued_status.issued_book_isbn` → `books.isbn`**
- **`issued_status.issued_emp_id` → `employees.emp_id`**
- **`return_status.issued_id` → `issued_status.issued_id`**

---

-- CREATE DATABASE library;

-- Create table "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(55),
            contact_no VARCHAR(10)
);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20)

-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(25),
            position VARCHAR(15),
            salary INT,
            branch_id VARCHAR(25) -- FK
           
);


-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(20) PRIMARY KEY,
            book_title VARCHAR(75),
            category VARCHAR(25),
            rental_price float,
            status VARCHAR(15),
            author VARCHAR(35),
            publisher VARCHAR(55)
);

ALTER TABLE books
ALTER COLUMN category TYPE VARCHAR(20);

-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(25),
            member_address VARCHAR(75),
            reg_date DATE
);

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(10), -- FK
            issued_book_name VARCHAR(75),
            issued_date DATE,
            issued_book_isbn VARCHAR(25), -- FK
            issued_emp_id VARCHAR(10) -- FK
            
);

-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(10),
            return_book_name VARCHAR(75),
            return_date DATE,
            return_book_isbn VARCHAR(20)

);

--FOREIGN KEY
ALTER TABLE issued_status
Add CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
Add CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
Add CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
Add CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
Add CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


## ✅ Project Tasks

### 1. Insert a New Book Entry
Add a record for *To Kill a Mockingbird* to the `books` table.
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;



### 2. Update an Existing Member's Address
Update the address of member with `member_id = 'C101'`.

UPDATE members
SET member_address = '123 Main St'
WHERE member_id = 'C101';
SELECT*FROM members;

### 3. Delete from Issued Status
Delete the record where `issued_id = 'IS121'`.
SELECT*FROM issued_status;
DELETE FROM issued_status
WHERE   issued_id =   'IS121';

### 4. Retrieve Books Issued by a Specific Employee
Get all books issued by `emp_id = 'E101'`.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

### 5. List Members Who Issued More Than One Book
Use `GROUP BY` and `HAVING` to filter such members.

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

### 6. Create Book Issue Summary Table
Use `CTAS` to create `book_cnts` with issue counts.
CREATE TABLE book_cnts AS
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

### 7. Retrieve Books in 'Classic' Category
Filter books by category = `'Classic'`.

SELECT * FROM books
WHERE category = 'Classic';


### 8. Calculate Rental Income by Category
Use `JOIN` + `SUM()` to get total income and issue count per category.
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

### 9. List Recent Members
Select members registered in the last 180 days.
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
INSERT INTO members(member_id, member_name, member_address, reg_date )
VALUES
('C120', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C122', 'Liam Walker', '789 Spruce St', '2024-07-26');

### 10. List Employees with Branch and Manager
Join `employees`, `branch`, and manager’s name for reporting.
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

### 11. Create Table for Books Above Price Threshold
Create `books_price_greater_than_seven` where rental_price > 7.00.

CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM books
WHERE rental_price > 7.00

SELECT * FROM
books_price_greater_than_seven
### 12. Retrieve Books Not Yet Returned
Use `LEFT JOIN` to find issued books with no return record.
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

--PROJECT COMPLETED

---

## 🛠 Technologies Used

- PostgreSQL (SQL)
- pgAdmin 4
- DDL & DML
- Joins, Grouping, Aggregation
- CTAS (Create Table As Select)
- Constraints (PK, FK)

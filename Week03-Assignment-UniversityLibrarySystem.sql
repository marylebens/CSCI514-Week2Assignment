-- ============================================================================================
-- University Library Management System Database Creation Script
-- For CSCI514 - Platform-Based Development
-- By Mary Lebens
-- January 30, 2026
-- Week 3 Assignment: Designing and Implementing a Relational Database with ER Model Assignment
-- PostgreSQL Version
-- ============================================================================================


-- ===================================
-- Step 2: Create the Database Tables
-- ===================================
-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS Fines CASCADE;
DROP TABLE IF EXISTS Loans CASCADE;
DROP TABLE IF EXISTS Books CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS Librarians CASCADE;

-- Create Students Table
CREATE TABLE Students (
    StudentID SERIAL PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Major VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    YearOfStudy INT NOT NULL CHECK (YearOfStudy BETWEEN 1 AND 4)
);

-- Create Books Table
CREATE TABLE Books (
    BookID SERIAL PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    YearOfPublication INT NOT NULL
);

-- Create Librarians Table
CREATE TABLE Librarians (
    LibrarianID SERIAL PRIMARY KEY,
    LibrarianName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Shift VARCHAR(20) NOT NULL CHECK (Shift IN ('Morning', 'Evening'))
);

-- Create Loans Table
CREATE TABLE Loans (
    LoanID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    BookID INT NOT NULL,
    LibrarianID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (LibrarianID) REFERENCES Librarians(LibrarianID)
);

-- Create Fines Table
CREATE TABLE Fines (
    FineID SERIAL PRIMARY KEY,
    LoanID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    DateIssued DATE NOT NULL,
    DatePaid DATE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- ==========================================================
-- Step 3: Insert Data
-- Stored Procedures for Inserting Sample Data into Tables
-- ==========================================================

-- Procedure to insert students
CREATE OR REPLACE PROCEDURE InsertStudents()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 1;
    -- Array of pretend student names 
    student_names TEXT[] := ARRAY[
        'Maria Garcia',
        'Abdi Hassan',
        'Lars Andersson',
        'Mai Vue',
        'Emily Johnson',
        'Carlos Lopez',
        'Fatima Omar',
        'Erik Berg',
        'Kou Yang',
        'Sofia Martinez'
    ];
    -- Array of majors to assign to students
    majors TEXT[] := ARRAY['Computer Science', 'Engineering', 'Business', 'Mathematics', 'Biology'];
BEGIN
    -- Loop through and insert 10 student records
    WHILE counter <= 10 LOOP
        INSERT INTO Students (StudentName, Major, Email, YearOfStudy)
        VALUES (
            -- Get the student name from the array
            student_names[counter],
            -- Assign a major by cycling through the majors array
            majors[MOD(counter - 1, 5) + 1],
            -- Generate email from first and last name
            LOWER(REPLACE(SPLIT_PART(student_names[counter], ' ', 1) || '.' || SPLIT_PART(student_names[counter], ' ', 2), ' ', '')) || '@university.edu',
            -- Assign year of study between 1 and 4
            MOD(counter - 1, 4) + 1
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$;

-- Procedure to insert books
CREATE OR REPLACE PROCEDURE InsertBooks()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 1;
    -- Array of book titles for the library
    book_titles TEXT[] := ARRAY[
        'Learning Python',
        'Database Design',
        'Web Development Basics',
        'Java Programming',
        'Introduction to SQL',
        'Computer Science Fundamentals',
        'Data Structures',
        'Software Testing',
        'Network Security',
        'Mobile App Development'
    ];
    -- Array of authors for the books
    authors TEXT[] := ARRAY[
        'Mark Lutz',
        'Thomas Connolly',
        'Jon Duckett',
        'Cay Horstmann',
        'Alan Beaulieu',
        'John Lewis',
        'Michael Goodrich',
        'Ron Patton',
        'William Stallings',
        'Neil Smyth'
    ];
    -- Array of book categories
    categories TEXT[] := ARRAY['Programming', 'Database', 'Web Design', 'Programming', 'Database', 'Computer Science', 'Algorithms', 'Testing', 'Security', 'Mobile'];
BEGIN
    -- Loop through and insert 10 book records
    WHILE counter <= 10 LOOP
        INSERT INTO Books (Title, Author, Category, YearOfPublication)
        VALUES (
            -- Get the book title from the array
            book_titles[counter],
            -- Get the author from the array
            authors[counter],
            -- Get the category from the array
            categories[counter],
            -- Generate publication years from 2015 to 2024
            2015 + MOD(counter - 1, 10)
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$;

-- Procedure to insert librarians
CREATE OR REPLACE PROCEDURE InsertLibrarians()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 1;
    -- Array of pretend librarian names 
    librarian_names TEXT[] := ARRAY[
        'Patricia Anderson',
        'Juan Ramirez',
        'Amina Ali',
        'Gustav Lindstrom',
        'Pao Xiong',
        'Linda Thompson',
        'Diego Gonzalez',
        'Halima Yusuf',
        'Anna Bergstrom',
        'Angela Lee'
    ];
BEGIN
    -- Loop through and insert 10 librarian records
    WHILE counter <= 10 LOOP
        INSERT INTO Librarians (LibrarianName, Email, Shift)
        VALUES (
            -- Get the librarian name from the array
            librarian_names[counter],
            -- Generate the librarian's email address from their first and last name
            LOWER(REPLACE(SPLIT_PART(librarian_names[counter], ' ', 1) || '.' || SPLIT_PART(librarian_names[counter], ' ', 2), ' ', '')) || '@library.edu',
            -- Assign the llibrarian a shift: even numbers get Morning, odd numbers get Evening
            CASE WHEN MOD(counter, 2) = 0 THEN 'Morning' ELSE 'Evening' END
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$;

-- Procedure to insert loans
CREATE OR REPLACE PROCEDURE InsertLoans()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 1;
    borrow_date DATE;
BEGIN
    -- Loop through and insert 10 loan records
    WHILE counter <= 10 LOOP
        -- Calculate borrow date by subtracting days from current date
        borrow_date := CURRENT_DATE - (counter || ' days')::INTERVAL;
        
        INSERT INTO Loans (StudentID, BookID, LibrarianID, BorrowDate, DueDate, ReturnDate)
        VALUES (
            -- Cycle through student IDs 1 through 10
            MOD(counter - 1, 10) + 1,
            -- Each loan gets a different book
            counter,
            -- Cycle through librarian IDs 1 through 10
            MOD(counter - 1, 10) + 1,
            -- Set the borrow date
            borrow_date,
            -- Due date is 14 days after borrow date
            borrow_date + INTERVAL '14 days',
            -- First 7 loans are returned, last 3 are still out (NULL return date)
            CASE WHEN counter > 7 THEN NULL ELSE borrow_date + INTERVAL '10 days' END
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$;

-- Procedure to insert fines
CREATE OR REPLACE PROCEDURE InsertFines()
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 1;
    overdue_days INT;
    loan_borrow_date DATE;
BEGIN
    -- Loop through and insert 10 fine records
    WHILE counter <= 10 LOOP
        -- Generate random number of overdue days between 1 and 10
        overdue_days := FLOOR(1 + (RANDOM() * 10))::INT;
        
        -- Get the borrow date for this loan
        SELECT BorrowDate INTO loan_borrow_date FROM Loans WHERE LoanID = counter;
        
        INSERT INTO Fines (LoanID, Amount, DateIssued, DatePaid)
        VALUES (
            -- Each fine is associated with a loan
            counter,
            -- Calculate fine amount: $2.50 per overdue day
            overdue_days * 2.50,
            -- Fine is issued 15 days after borrow date
            loan_borrow_date + INTERVAL '15 days',
            -- First 5 fines are paid, last 5 are unpaid (NULL)
            CASE WHEN counter > 5 THEN NULL ELSE loan_borrow_date + INTERVAL '20 days' END
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$;

-- Call the stored procs to run them and insert the data.

CALL InsertStudents();
CALL InsertBooks();
CALL InsertLibrarians();
CALL InsertLoans();
CALL InsertFines();

-- =======================================================================================
-- Step 5: Submit SQL Queries
-- Here are five useful queries to execute against the University Library database.
-- =======================================================================================

-- Query 1: JOIN 
-- Purpose: To show all of the loans with the student names, book titles, and librarian names.
SELECT 
    L.LoanID,
    S.StudentName,
    B.Title AS BookTitle,
    LIB.LibrarianName,
    L.BorrowDate,
    L.DueDate,
    L.ReturnDate
FROM Loans L
INNER JOIN Students S ON L.StudentID = S.StudentID
INNER JOIN Books B ON L.BookID = B.BookID
INNER JOIN Librarians LIB ON L.LibrarianID = LIB.LibrarianID
ORDER BY L.BorrowDate DESC;

-- Query 2: Aggregation
-- Purpose: This query counts the total loans per student.
SELECT 
    S.StudentName,
    S.Major,
    COUNT(L.LoanID) AS TotalLoans
FROM Students S
LEFT JOIN Loans L ON S.StudentID = L.StudentID
GROUP BY S.StudentID, S.StudentName, S.Major
ORDER BY TotalLoans DESC;

-- Query 3: Aggregation with WHERE
-- Purpose: This query calculates the total amount of unpaid fines for each of the students.
SELECT 
    S.StudentName,
    S.Email,
    SUM(F.Amount) AS TotalUnpaidFines
FROM Students S
INNER JOIN Loans L ON S.StudentID = L.StudentID
INNER JOIN Fines F ON L.LoanID = F.LoanID
WHERE F.DatePaid IS NULL
GROUP BY S.StudentID, S.StudentName, S.Email
HAVING SUM(F.Amount) > 0
ORDER BY TotalUnpaidFines DESC;

-- Query 4: Filtering and JOIN
-- Purpose: This query finds all of the overdue books that 
--          have not yet been returned to the library.
SELECT 
    S.StudentName,
    B.Title AS BookTitle,
    L.DueDate,
    CURRENT_DATE - L.DueDate AS DaysOverdue
FROM Loans L
INNER JOIN Students S ON L.StudentID = S.StudentID
INNER JOIN Books B ON L.BookID = B.BookID
WHERE L.ReturnDate IS NULL AND L.DueDate < CURRENT_DATE
ORDER BY DaysOverdue DESC;

-- Query 5: UPDATE
-- Purpose: This query marks a fine as paid (uses fine ID 1 to demonstrate)
UPDATE Fines
SET DatePaid = CURRENT_DATE
WHERE FineID = 1 AND DatePaid IS NULL;

-- Verification query to show the update worked
SELECT * FROM Fines WHERE FineID = 1;

-- ==================================
-- END SCRIPT
-- ==================================
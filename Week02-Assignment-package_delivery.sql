-- Package Delivery Database System
-- Created: January 22, 2026
-- Author: Dr. Mary Lebens

-- Drop tables if they exist (so this script can be re-run easily)
DROP TABLE IF EXISTS Packages CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Drivers CASCADE;
DROP TABLE IF EXISTS Addresses CASCADE;

-- Create the Addresses table
CREATE TABLE Addresses (
    AddressID SERIAL PRIMARY KEY,
    StreetAddress VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL
);

-- Create the Drivers table
CREATE TABLE Drivers (
    DriverID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    LicenseNumber VARCHAR(20) NOT NULL UNIQUE
);

-- Create the Customers table
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    AddressID INTEGER,
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);

-- Create the Packages table
CREATE TABLE Packages (
    PackageID SERIAL PRIMARY KEY,
    Description VARCHAR(200) NOT NULL,
    Weight DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    StatusDate TIMESTAMP NOT NULL,
    CustomerID INTEGER NOT NULL,
    DriverID INTEGER,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

-- Insert Addresses (sample data)
INSERT INTO Addresses (StreetAddress, City, State, PostalCode) VALUES
('123 Main St', 'Los Angeles', 'CA', '90001'),
('456 Elm St', 'New York', 'NY', '10001'),
('789 Oak St', 'Chicago', 'IL', '60601'),
('101 Pine St', 'San Francisco', 'CA', '94101');

-- Insert Drivers (Sample data_)
INSERT INTO Drivers (FirstName, LastName, LicenseNumber) VALUES
('David', 'Smith', 'DL12345'),
('Emily', 'Johnson', 'DL67890'),
('Michael', 'Brown', 'DL54321'),
('Olivia', 'Davis', 'DL98765'),
('Jane', 'Robert', 'TLM1289'),
('Mary', 'James', 'AO8526');

-- Insert Customers (sample data)
INSERT INTO Customers (FirstName, LastName, Email, Phone, AddressID) VALUES
('John', 'Doe', 'john@example.com', '123-456-7890', 1),
('Jane', 'Smith', 'jane@example.com', '987-654-3210', 2),
('Bob', 'Johnson', 'bob@example.com', '555-555-5555', 3),
('Alice', 'Williams', 'alice@example.com', '111-222-3333', 4);

-- Insert Packages (sample data_)
INSERT INTO Packages (Description, Weight, Status, StatusDate, CustomerID, DriverID) VALUES
('Electronics (fragile)', 5.2, 'pickup', '2024-01-05 09:15:00', 1, 1),
('Books', 2.0, 'delivered', '2024-01-08 14:30:00', 2, 2),
('Clothing', 3.5, 'on-transit', '2024-02-02 10:45:00', 3, 3),
('Furniture', 15.8, 'pickup', '2024-02-01 11:20:00', 4, 1),
('Artwork (fragile)', 5.0, 'delivered', '2024-01-05 13:10:00', 1, 4),
('Home Appliance', 100.0, 'pickup', '2024-01-14 08:00:00', 2, 2);

-- Query 3: Customer Packages
SELECT 
    c.FirstName || ' ' || c.LastName AS CustomerName,
    COUNT(p.PackageID) AS TotalPackages
FROM Customers c
LEFT JOIN Packages p ON c.CustomerID = p.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY CustomerName;

-- Query 4: Driver Workload
SELECT 
    d.FirstName || ' ' || d.LastName AS DriverName,
    COUNT(p.PackageID) AS PackagesAssigned
FROM Drivers d
LEFT JOIN Packages p ON d.DriverID = p.DriverID
GROUP BY d.DriverID, d.FirstName, d.LastName
ORDER BY DriverName;

-- Query 5: Package Status Summary
SELECT 
    Status,
    COUNT(*) AS TotalPackages
FROM Packages
GROUP BY Status
ORDER BY Status;
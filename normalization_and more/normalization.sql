-- https://www.sqlservercentral.com/articles/database-normalization-in-sql-with-examples

-- First Normal Form (1NF)

--    Data is stored in tables with rows that can be uniquely identified by a Primary Key.
--    Data within each table is stored in individual columns in its most reduced form.
--    There are no repeating groups.

-- Second Normal Form (2NF)

--    All the rules from 1NF must be satisfied.
--    Only those data that relates to a table’s primary key is stored in each table.

-- Third Normal Form (3NF)

--    All the rules from 2NF must be satisfied.
--    There should be no intra-table dependencies between the columns in each table.

-- Boyce-Codd Normal Form or Fourth Normal Form (BCNF of 4NF)
-- Fifth Normal Form (5NF)
-- Sixth Normal Form (6NF)

USE Norm

CREATE TABLE Projects(
	[ID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100),
	[Value] DECIMAL(5,2),
	StartDate DATE,
	EndDate DATE
)
GO
CREATE TABLE Employees(
	[ID] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(50),
	[LastName] VARCHAR(50),
	[HourlyWage] DECIMAL(5,2),
	[HireDate] DATE
)
GO
CREATE TABLE ProjectEmployees(
	[ID] INT PRIMARY KEY IDENTITY,
	[ProjectID] INT,
	[EmployeeID] INT,
	[Hours] DECIMAL(5,2),
	CONSTRAINT FK_ProjectEmployees_Projects FOREIGN KEY ([ProjectID]) REFERENCES  [Projects] ([ID]),
	CONSTRAINT FK_ProjectEmployees_Employees FOREIGN KEY ([EmployeeID]) REFERENCES  [Employees] ([ID])
)
GO
CREATE TABLE JobOrders(
	[ID] INT PRIMARY KEY IDENTITY,
	[EmployeeID] INT,
	[ProjectID] INT,
	[Description] TEXT,
	[OrderDateTime] DATETIME,
	[Quantity] INT,
	[Price] DECIMAL(5,2),
	CONSTRAINT FK_JobOrders_Projects FOREIGN KEY ([ProjectID]) REFERENCES  [Projects] ([ID]),
	CONSTRAINT FK_JobOrders_Employees FOREIGN KEY ([EmployeeID]) REFERENCES  [Employees] ([ID])
)
GO

CREATE TABLE Customers (
    [Name] VARCHAR(100),
    [Industry] VARCHAR(100),
    [Project1_ID] INT,
    [Project1_Feedback] TEXT,
    [Project2_ID] INT,
    [Project2_Feedback] TEXT,
    [ContactPersonID] INT,
    [ContactPersonAndRole] VARCHAR(255),
    [PhoneNumber] VARCHAR(12),
    [Address] VARCHAR(255),
    [City] VARCHAR(255),
    [Zip] VARCHAR(5)
  )
 GO

-- First Normal Form
-- The Customers table in the diagram violates all the three rules of the first normal form.
-- We do not see any Primary Key in the table.
-- The data is not found in its most reduced form. For example, the column ContactPersonAndRole can be divided further into two individual columns - ContactPerson and ContactPersonRole.
-- Also, we can see there are two repeating groups of columns in this table - (Project1_ID, Project1_FeedBack) and (Project2_ID, Project2_Feedback). We need to get these removed from this table.

-- Add a primary key
ALTER TABLE [Customers]
	ADD [ID] INT IDENTITY PRIMARY KEY
GO

-- Rename the original column from ContactPersonAndRole to ContactPerson.
-- Add a new column for ContactPersonRole.
sp_rename 'Customers.[ContactPersonAndRole]', 'ContactPerson', 'COLUMN'
GO
ALTER TABLE [Customers]
	ADD [ContactPersonRole] VARCHAR(20)
GO

-- Result so far:
CREATE TABLE [dbo].[Customers](
	[Name] [varchar](100) NULL,
	[Industry] [varchar](100) NULL,
	[Project1_ID] [int] NULL,
	[Project1_Feedback] [text] NULL,
	[Project2_ID] [int] NULL,
	[Project2_Feedback] [text] NULL,
	[ContactPersonID] [int] NULL,
	[ContactPerson] [varchar](255) NULL,
	[PhoneNumber] [varchar](12) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[Zip] [varchar](5) NULL,
	[ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[ContactPersonRole] [varchar](20) NULL
);



-- Finally, in order to satisfy the third rule of the First Normal Form, 
-- we need to move the columns Project1_ID, Project1_Feedback, Project2_ID, and Project2_Feedback into a 
-- new table. This can be done by creating a new table ProjectFeedbacks and link it back with the Customers and the Projects table.
ALTER TABLE [Customers]
	DROP COLUMN Project1_ID
ALTER TABLE [Customers]
	DROP COLUMN Project1_Feedback
ALTER TABLE [Customers]
	DROP COLUMN Project2_ID
ALTER TABLE [Customers]
	DROP COLUMN Project2_Feedback
GO

CREATE TABLE ProjectFeedback(
	[ID] INT PRIMARY KEY IDENTITY,
	[ProjectID] INT,
	[CustomerID] INT,
	[Feedback] TEXT,
	CONSTRAINT FK_ProjectFeedbacks_Projects FOREIGN KEY ([ProjectID]) REFERENCES  [Projects] ([ID]),
	CONSTRAINT FK_ProjectFeedbacks_Customers FOREIGN KEY ([CustomerID]) REFERENCES  [Customers] ([ID])
)
GO

-- Result now

CREATE TABLE [dbo].[Customers](
	[Name] [varchar](100) NULL,
	[Industry] [varchar](100) NULL,
	[ContactPersonID] [int] NULL,
	[ContactPerson] [varchar](255) NULL,
	[PhoneNumber] [varchar](12) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[Zip] [varchar](5) NULL,
	[ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[ContactPersonRole] [varchar](20) NULL,
);

-- Second Normal Form







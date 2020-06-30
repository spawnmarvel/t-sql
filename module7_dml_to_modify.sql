-- Lesson 1: Adding Data to Tables
-- Write queries that use the INSERT statement to add data to tables.
-- Use the INSERT statement with SELECT and EXEC clauses.
-- Use SELECT INTO to create and populate tables without resort to data definition language (DDL). 
-- 

USE [test]
GO

INSERT INTO [dbo].[students] (s_name,s_age) VALUES('Steven John', 30)
GO

-- multirow

USE [test]
GO

INSERT INTO [dbo].[students] (s_name,s_age)
	VALUES
	('Steven John', 30),
	('John Doe', 32),
	('Lisa Doe', 32);
GO

-- Using INSERT with Data Providers
INSERT INTO learn.students (f_name)
SELECT s_name FROM dbo.students
-- s_id	f_name	l_name
---1	Tim	Johnsen
-- 2	John Doe	Doe
-- 3	Lisa	Jack
-- 4	Ronny	Low
-- 5	Jim Town	NULL
-- 6	Tim Door	NULL
-- 7	Lisa Fresh	NULL
-- 8	Ida Back	NULL
-- 9	Tom Jones	NULL

-- Inserting Rows into a Table from a Stored Procedure

INSERT INTO Production.Products (productID, productname, supplierid, categoryid, unitprice)
EXEC Production.AddNewProducts;
GO





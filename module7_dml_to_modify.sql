-- Lesson 1: Adding Data to Tables
-- Write queries that use the INSERT statement to add data to tables.
-- Use the INSERT statement with SELECT and EXEC clauses.
-- Use SELECT INTO to create and populate tables without resort to data definition language (DDL). 
-- 

USE [test]
GO
-- Single
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

-- SELECT INTO statement to create and populate a new table with the results of a SELECT query
-- This can only be repeated once and dont use *
SELECT * INTO TestTable FROM learn.students

SELECT TOP (1000) [s_id]
      ,[f_name]
      ,[l_name]
  FROM [test].[dbo].[TestTable]
-- s_id	f_name	l_name
-- 1	Tim	Johnsen
-- 2	John Doe	Doe
-- 3	Lisa	Jack
-- 4	Ronny	Low
-- 5	Jim Town	NULL
-- 6	Tim Door	NULL
-- 7	Lisa Fresh	NULL
-- 8	Ida Back	NULL
-- 9	Tom Jones	NULL

-- Using UPDATE to Modify Data

---product_id	product_name	brand_id	category_id	model_year	list_price
---1	Trek 820 - 2016	9	6	2016	379.99
-- 2	Ritchey Timberwolf Frameset - 2016	5	6	2016	749.99
-- 3	Surly Wednesday Frameset - 2016	8	6	2016	999.99
-- 4	Trek Fuel EX 8 29 - 2016	9	6	2016	2899.99

USE BikeStores
UPDATE production.products set list_price = (list_price - 10) -- set down the price
WHERE model_year = 2016 and category_id = 6 and product_id < 10 -- on the selected rows

-- product_id	product_name	brand_id	category_id	model_year	list_price
-- 1	Trek 820 - 2016	9	6	2016	369.99
-- 2	Ritchey Timberwolf Frameset - 2016	5	6	2016	739.99
-- 3	Surly Wednesday Frameset - 2016	8	6	2016	989.99
-- 4	Trek Fuel EX 8 29 - 2016	9	6	2016	2889.99

-- Using MERGE to Modify Data
-- In database operations, there is a common need to perform a SQL MERGE operation, 
-- in which some rows within a destination table are updated or deleted and new rows are inserted from a source data table.

-- (FOR COMPLICATED UPDATE'S, WRITE IT AS A SELECT STATMENT FIRST)

-- MERGE
USE test

CREATE table ProductTarget(
product_id INT IDENTITY PRIMARY KEY,
product_name VARCHAR(20) NOT NULL,
product_number INT,
color VARCHAR(15)

);
GO

CREATE table ProductSource(
product_id INT IDENTITY PRIMARY KEY,
product_name VARCHAR(20) NOT NULL,
product_number INT,
color VARCHAR(15)

);
GO

-- Inserted some rows
SELECT [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductSource]
-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black

-- inserted just to have some data in the same id
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductTarget]

-- product_id	product_name	product_number	color
-- 1	test	2	NULL
-- 2	test	3	NULL

-- Update the rows in target from source

USE test;

UPDATE ProductTarget
SET    product_name = s.product_name,
       product_number = s.product_number,
       color = s.color
FROM   ProductTarget t
       INNER JOIN ProductSource s ON s.product_id = t.product_id

-- 
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductTarget]

-- Data is now the same
-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black

-- Add new row to the Product source

-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue

-- INSERT INTO

USE test;

INSERT INTO ProductTarget (product_name, product_number, color)
SELECT s.product_name, s.product_number, s.color
FROM ProductSource s
WHERE NOT EXISTS (SELECT t.product_id
				  FROM ProductTarget t
				  WHERE t.product_id = s.product_id)

-- and the last row is there
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductTarget]

-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue


-- DELETE
-- Added a row in target, opel, it must be removed
-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue
-- 4	opel	25	brown

USE test;

DELETE FROM ProductTarget 
FROM ProductTarget t
WHERE NOT EXISTS (SELECT s.product_id
				  FROM ProductSource s
				  WHERE t.product_id = s.product_id)

-- Result from target
-- product_id	product_name	product_number	color
-- 1	volvo	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue

-- Now that you’ve seen how to do the various operation individually, 
-- lets see how they come together in the merge statement.

-- lets update the source with a new row and modify one row, new volvo an da toyota
SELECT [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductSource]

  -- product_id	product_name	product_number	color
-- 1	volvo s90	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue
-- 4	toyota	25	brown

-- THE ACTUAL MERGE TO GET THE SAME DATA IN BOTH TABLES
USE test;

SET IDENTITY_INSERT ProductTarget ON

MERGE ProductTarget t
USING ProductSource s
ON (s.product_id= t.product_id)
WHEN MATCHED
	THEN UPDATE
	SET t.product_name = s.product_name,
		t.product_number = s.product_number,
		t.color = s.color
WHEN NOT MATCHED BY TARGET
THEN INSERT (product_id, product_name, product_number, color)
	VALUES (s.product_id, s.product_name, s.product_number, s.color)
WHEN NOT MATCHED BY SOURCE
THEN DELETE;

SET IDENTITY_INSERT ProductTarget ON

-- GET NEW DATA
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[product_number]
      ,[color]
  FROM [test].[dbo].[ProductTarget]

-- product_id	product_name	product_number	color
-- 1	volvo s90	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue
-- 4	toyota	25	brown

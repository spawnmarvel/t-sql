-- Lesson 1: Writing Queries with the UNION Operator
-- UNION, INTERSECTM EXCEPT operator
-- Write q to manupulate rows with APPLY, and combining them with
-- results of derived tabel/function

-- UNION operator
-- UNION and UNION all to add one set to another
-- 
-- Interactions between sets
-- Result of two q may be be manipulated further
-- Sets may be combined, compared, or operate against each other
-- Must have same num of comparable columns
-- ORDER BY, not allowed in input but can be used for result
-- Null is equal when comparing sets
-- SELECT Q1
-- SET OPERATOR
-- SELECT Q2
-- ORDER BY

-- UNION OPERATOR

  SELECT product_name,color
  FROM [test].[dbo].[ProductSource]
  
  SELECT product_name, color
  FROM [test].[dbo].[ProductTarget]

-- both returns the same
-- product_name	color
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown

SELECT product_name, color
FROM [test].[dbo].[ProductSource]
UNION
SELECT product_name, color
FROM dbo.ProductTarget

-- RETURNS the same result and duplicates is removed
-- product_name	color
-- bmw	black
-- fiat	blue
-- toyota	brown
-- volvo s90	red

-- remember that no sort order is guaranteed by set operators unless one is explicitly specified.
-- UNION combines all rows from each input set, and then filters out duplicates. 

-- UNION ALL
-- Returns a set with all rows from both input sets

SELECT product_name, color
FROM [test].[dbo].[ProductSource]
UNION ALL
SELECT product_name, color
FROM dbo.ProductTarget

-- product_name	color
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown

-- UNION ALL does not filter out duplicate rows. 

-- Using EXCEPT and INTERSECT
-- INTERSECT operator
-- Returns the distinct set of rows that appear in both input results sets
-- Only the rows that exists in both set will be returned
SELECT store_id 
FROM [BikeStores].[sales].[stores]
-- returns 3 rows
-- store_id
-- 1
-- 2
-- 3
SELECT store_id
FROM sales.orders
--return 1615 rows,,
-- store_id
-- 1
-- 2
-- 2
-- 1
-- 2
-- 2
SELECT store_id 
FROM [BikeStores].[sales].[stores]
INTERSECT
SELECT store_id
FROM sales.orders
-- returns 3 rows,returns only distinct rows that appear in both input sets. 

-- Using the EXCEPT Operator
-- Returns only distinct rows that appear in the left set but not the right

-- If we update the stores table with one more store
SELECT store_id, store_name
FROM [BikeStores].[sales].[stores]
-- Result
-- store_id	store_name
-- 1	Santa Cruz Bikes
-- 2	Baldwin Bikes
-- 3	Rowlett Bikes
-- 4	Bergen Bikes

-- We added Bergen Bikes
SELECT store_id
FROM [BikeStores].[sales].[stores]
EXCEPT
SELECT store_id
FROM sales.orders

-- And the result returned is just the new store
-- store_id
-- 4

-- Using the APPLY operator
-- Is a table operator used in FROM clause
-- There is 2 forms, CROSS AND OUTER APPLY
-- Operates on two tables, left and right
-- Right table may be any table expression including a derived
-- table or table-valued function

-- SELECT column
-- FROM left table AS alias
-- CROSS | OUTER APPLY
-- RIGHT table as alias

-- Evaluate rows in one input set with the second
-- Apply is a table operator, it is used like a JOIN in the FROM clause
-- Apply differs from correlated subqueries by returning a table valued result, not scalar or multi valued result.
-- The second or right table source is processed once per row in the first, left table source.

-- CROSS APPLY
-- Applies to the right table for each row in the left
-- Only rows that exists in both are returned
-- Most INNER JOIN statments can be written as CROSS APPLY


-- OUTER APPLY
-- Applies to right table source to each row in the left
-- All rows from the left table source are returned
-- Values from the right table source are returned where they exists, otherwise NULL is returned
-- Most LEFT OUTER JOIN statments can be rewritten as OUTER APPLY

-- Create some tables to demonstrate
USE BikeStores;
go
CREATE SCHEMA module12;
go
CREATE TABLE module12.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
	)

CREATE TABLE module12.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	category_id INT NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE
	)

-- data
SELECT c.category_id, c.category_name
FROM BikeStores.module12.categories as c
-- RETURNS
-- category_id	category_name
-- 1	bikes
-- 2	cars
-- 3	houses
-- 4	tools
-- OUTER APPLY

SELECT * FROM BikeStores.module12.products as i
-- product_id	product_name	category_id
-- 1	volvo	1
-- 2	bmx	2
-- 3	flat	3

-- CROSS APPLY
SELECT c.category_id, c.category_name,
od.product_id, od.product_name
FROM BikeStores.module12.categories as c
CROSS APPLY
	(SELECT product_id, product_name
	FROM BikeStores.module12.products AS i
	WHERE i.category_id=c.category_id)
AS od
-- INNER JOIN
SELECT c.category_id, c.category_name,
od.product_id, od.product_name
FROM BikeStores.module12.categories as c
	INNER JOIN BikeStores.module12.products AS od
	ON od.category_id=c.category_id

-- Returns both the same
-- category_id	category_name	product_id	product_name
-- 1	bikes	1	volvo
-- 2	cars	2	bmx
-- 3	houses	3	flat


-- OUTER APPLY
SELECT c.category_id, c.category_name,
od.product_id, od.product_name
FROM BikeStores.module12.categories as c
OUTER APPLY
	(SELECT product_id, product_name
	FROM BikeStores.module12.products AS i
	WHERE i.category_id=c.category_id)
AS od
-- LEFT JOIN
SELECT c.category_id, c.category_name,
od.product_id, od.product_name
FROM BikeStores.module12.categories as c
	LEFT JOIN BikeStores.module12.products AS od
	ON od.category_id=c.category_id

-- Returns both the same
-- category_id	category_name	product_id	product_name
-- 1	bikes	1	volvo
-- 2	cars	2	bmx
-- 3	houses	3	flat
-- 4	tools	NULL	NULL
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

--Using the APPLY operator
-- Is a table operator used in FROM clause
-- There is 2 forms, CROSS AND OUTER APPLY
-- Operates on two tables, left and right
-- Right tablemay be any table expression including a derived
-- table or table-valued function

-- SELECT column
-- FROM left table AS alias
-- CROSS | OUTER APPLY
-- RIGHT table as alias
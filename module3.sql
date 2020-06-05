-- Module 3: Writing SELECT Queries

-- Lesson 1:	Writing Simple SELECT Statements
-- Lesson 2:	Eliminating Duplicates with DISTINCT
-- Lesson 3:	Using Column and Table Aliases
-- Lesson 4:	Writing Simple CASE Expressions

-- Calculated Expression
-- For example tax

USE BikeStores;

SELECT order_id, quantity, list_price, (list_price + 25) with_tax
FROM sales.order_items


-- Black friday offer
USE BikeStores;

SELECT order_id, quantity, list_price, ((list_price * 50)/100) black_friday
FROM sales.order_items

-- Eliminating Duplicates with DISTINCT
-- Rows are not guaranteed to be unique
-- DISTINCT only unique, removes duplicates

USE BikeStores

SELECT DISTINCT brand_name
FROM production.brands

USE BikeStores

SELECT DISTINCT product_name, model_year
FROM production.products



-- Find duplicates

USE BikeStores

SELECT product_name, model_year
FROM production.products
GROUP BY product_name, model_year
HAVING COUNT(*)>1


-- Lesson 3:	Using Column and Table Aliases
USE BikeStores

SELECT DISTINCT product_name, model_year
FROM production.products as po

SELECT DISTINCT product_name, model_year
FROM production.products po

SELECT po.product_name, po.model_year
FROM production.products po

-- ORDER BY with alias
SELECT product_name, model_year, list_price as price
FROM production.products
ORDER BY price

-- Incorrect WHERE with alias
SELECT product_name, model_year, list_price as price
FROM production.products
WHERE price > 10; -- Invalid column name 'price'.

-- Order by column possition
SELECT product_name, model_year, list_price as price
FROM production.products
ORDER BY 3


-- Lesson 4 Lesson 4: Writing CASE Expressions
-- A CASE expression extends the ability of a SELECT clause to manipulate data as it is retrieved. Often when writing a query, you need to substitute a value of a column with another value. 

-- T-SQL CASE  expression return a single value, may be used in SELECT, WHERE / HAVING, ORDER BY
-- Two forms of CASE

-- Simple CASE:
-- Compares one value to a list of possible values
-- Returns first match
-- If no match, returns value found in optional ELSE clause
-- If not match and no ELSE, returns NULL

-- Search CASE
-- Evaluates a set of predicates, or logical expression
-- Returns value found in THEN clause matching first expresssion that evaluates to TRUE

USE BikeStores

SELECT p.product_name, p.list_price, p.model_year,
	CASE p.model_year
		WHEN 2017 THEN 'Old product'
		WHEN 2018 THEN 'New product'
		ELSE 'Return product'
	END AS year_description,

	CASE 
		WHEN p.list_price < 100 THEN 'Sale'
		WHEN p.list_price > 300 THEN 'Expensive'
		ELSE 'Standard'
	END AS price_description
FROM production.products p
ORDER BY 2

-- Lab: Writing Basic SELECT Statements
-- Exercise 1: Writing Simple SELECT Statements
-- Exercise 2: Eliminating Duplicates Using DISTINCT
-- Exercise 3: Using Table and Column Aliases
-- Exercise 4: Using a Simple CASE Expression

<<<<<<< HEAD
-- Terminate all T-SQL statements with a semicolon.

=======
-- clone repos 2
>>>>>>> ca4825f1c2cf1556618a20f1790baecacf6182ee




















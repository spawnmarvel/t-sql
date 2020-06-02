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











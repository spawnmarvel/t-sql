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











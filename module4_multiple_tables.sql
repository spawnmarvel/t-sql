-- Module 4: Querying Multiple Tables
-- Lesson 1:	Understanding Joins
-- Lesson 2:	Querying with Inner Joins
-- Lesson 3:	Querying with Outer Joins
-- Lesson 4:	Querying with Cross Joins and Self Joins
-- Lab:	Querying Multiple Tables

-- FROM clause determines source table to be used in SELECT statment
-- FROM caluse can contain table and operators
-- Result set of FROM clause is virtuale table
-- FROM clause can establish table aliases for use by subsequent phases of query

-- When learning about writing multitable queries in T-SQL, it is important to understand the concept of Cartesian products. 
-- In mathematics, this is the product of two sets. 
-- The product of a set of two items and a set of six is a set of 12 items—or 6 x 2. 
-- In databases, a Cartesian product is the result of joining every row of one input table to all rows of another input table.

-- Join types, description
-- Cross, Combines all rows in both tables, creates cartesian product
-- Inner, Starts with cartesian product, applies filter to match rows between tables based on predicate
-- Outer , Startes with cartesion product, all rows from designated table preserved, matching rows from other table retrieved. Additional NULLS inserted as placeholders

	
-- Describe inner joins.
-- Write queries using inner joins.
-- Describe the syntax of an inner join.

-- Returns only rows where a match is found on both tables, ON clause in SQL-92 syntax
-- Matches rows based on attributes suplied in predicate(true/false)


USE BikeStores

SELECT b.brand_id, b.brand_name, c.brand_id, c.product_name
FROM production.brands b
INNER JOIN production.products as c 
on b.brand_id = c.brand_id

USE BikeStores

SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers as c
INNER JOIN sales.orders as o
on c.customer_id = o.customer_id
--
--1	Debra	599	2016-12-09
--1	Debra	1555	2018-04-18
--1	Debra	1613	2018-11-18
--4	Daryl	1556	2018-04-18
--4	Daryl	1259	2017-11-21
--4	Daryl	700	2017-02-07
--5	Charolette	264	2016-06-10
--5	Charolette	571	2016-11-24
--5	Charolette	1544	2018-04-17

-- the FROM clause will be processed before the SELECT clause and an alias of b
-- The Join designates the production.products as the other table as caluse
-- The result, A list of customer who have placed orders, not placed order then they are filtered out with the ON

-- Lesson 3
-- Querying with Outer Joins

-- Returns all rows from one table and any matching rows from a second table
delete from sales.orders where  customer_id = 3
delete from sales.orders where  customer_id = 2
-- Deleted sowe know what customers did doed not have an order

-- You have two tables. You want to write a query to return all rows from the first table and only matches from the second table. Which of the following should you use? 
-- FROM t1 LEFT OUTER JOIN t2 ON t1.col = t2.col

-- Outer Join syntax
-- Return all rows from first table, only matches from second
USE BikeStores

SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers as c
LEFT OUTER JOIN sales.orders as o
on c.customer_id = o.customer_id
ORDER BY c.customer_id

--
--1	Debra	599	2016-12-09
--1	Debra	1555	2018-04-18
--1	Debra	1613	2018-11-18
--2	Kasha	NULL	NULL
--3	Tameka	NULL	NULL
--4	Daryl	1556	2018-04-18
--4	Daryl	1259	2017-11-21
--4	Daryl	700	2017-02-07
--5	Charolette	264	2016-06-10
--5	Charolette	571	2016-11-24
--5	Charolette	1544	2018-04-17

-- Return all rows from second table, only matches from first

SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers as c
RIGHT OUTER JOIN sales.orders as o
on c.customer_id = o.customer_id
ORDER BY c.customer_id

--
--1	Debra	599	2016-12-09
--1	Debra	1555	2018-04-18
--1	Debra	1613	2018-11-18
--4	Daryl	1556	2018-04-18
--4	Daryl	1259	2017-11-21
--4	Daryl	700	2017-02-07
--5	Charolette	264	2016-06-10
--5	Charolette	571	2016-11-24
--5	Charolette	1544	2018-04-17

-- Return all rows from first table, with no match in second

SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers as c
LEFT OUTER JOIN sales.orders as o
on c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
ORDER BY c.customer_id
--
--2	Kasha	NULL	NULL
--3	Tameka	NULL	NULL





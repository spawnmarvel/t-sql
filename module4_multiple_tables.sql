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

delete from sales.orders where  customer_id = 3
delete from sales.orders where  customer_id = 2
-- Deleted so know what customers does not have an order

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

-- Lesson 4 Querying with Cross Joins and Self Joins

--Cross join queries create a Cartesian product that, as you have learned in this module so far, are to be avoided. 
-- 
SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers as c
CROSS JOIN sales.orders as o

-- Cross Join Syntax
-- No matching performed, on ON clause used
-- Return all rows frol left table combined with each row from right table
-- ANSI SQL-92
SELECT ...
FROM t1 CROSS JOIN t2

-- The followoing is a to create all combinations of the two sets:
USE BikeStores

SELECT h.id, h.fullname
FROM hr.employees as h
--
--id	fullname
--1	John Doe
--2	Jane Doe
--3	Michael Scott
--4	Jack Sparrow

USE BikeStores

SELECT h.id, h.fullname
FROM hr.employees as h
CROSS JOIN hr.employees all_combinations

--
--id	fullname
--1	John Doe
--2	Jane Doe
--3	Michael Scott
--4	Jack Sparrow
--1	John Doe
--2	Jane Doe
--3	Michael Scott
--4	Jack Sparrow
--1	John Doe
--2	Jane Doe
--3	Michael Scott
--4	Jack Sparrow
--1	John Doe
--2	Jane Doe
--3	Michael Scott
--4	Jack Sparrow

-- Understanding Self Joins
-- return all employees
USE BikeStores
SELECT e.staff_id, e.first_name as emp_first_name, e.last_name emp_last_name
FROM sales.staffs e


--staff_id	emp_first_name	emp_last_name
--1	Fabiola	Jackson
--2	Mireya	Copeland
--3	Genna	Serrano
--4	Virgie	Wiggins
--5	Jannette	David
--6	Marcelene	Boyer
--7	Venita	Daniel
--8	Kali	Vargas
--9	Layla	Terrell
--10	Bernardine	Houston


-- Return all employees with ID of employees mananger whene a manager exists

USE BikeStores
SELECT e.staff_id, e.first_name as emp_first_name, e.last_name emp_last_name, e.manager_id

FROM sales.staffs e
JOIN sales.staffs m
ON e.staff_id = m.manager_id

--
--staff_id	emp_first_name	emp_last_name	manager_id
--1	Fabiola	Jackson	NULL
--2	Mireya	Copeland	1
--2	Mireya	Copeland	1
--1	Fabiola	Jackson	NULL
--5	Jannette	David	1
--5	Jannette	David	1
--1	Fabiola	Jackson	NULL
--7	Venita	Daniel	5
--7	Venita	Daniel	5

-- Return all employees with ID of manager (outer join) This will return NULL for the CEO
USE BikeStores
SELECT e.staff_id, e.first_name as emp_first_name, e.last_name emp_last_name, e.manager_id

FROM sales.staffs e
LEFT OUTER JOIN sales.staffs m
ON e.staff_id = m.manager_id

--staff_id	emp_first_name	emp_last_name	manager_id
--1	Fabiola	Jackson	NULL
--1	Fabiola	Jackson	NULL
--1	Fabiola	Jackson	NULL
--2	Mireya	Copeland	1
--2	Mireya	Copeland	1
--3	Genna	Serrano	2
--4	Virgie	Wiggins	2
--5	Jannette	David	1
--5	Jannette	David	1
--6	Marcelene	Boyer	5
--7	Venita	Daniel	5
--7	Venita	Daniel	5
--8	Kali	Vargas	1
--9	Layla	Terrell	7
--10	Bernardine	Houston	7




















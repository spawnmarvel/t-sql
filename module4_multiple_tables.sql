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

USE BikeStores

SELECT b.brand_id, b.brand_name, c.brand_id, c.product_name
FROM production.brands b
INNER JOIN production.products as c 
on b.brand_id = c.brand_id

USE BikeStores

SELECT c.customer_id, c.first_name, o.order_id
FROM sales.customers as c
INNER JOIN sales.orders as o
on c.customer_id = o.customer_id

-- the FROM clause will be processed before the SELECT clause and an alias of b
-- The Join designates the production.products as the other table as caluse
-- The result, A list of customer who have placed orders, not placed order then they are filtered out with the ON

-- Lesson 3
-- Querying with Outer Joins
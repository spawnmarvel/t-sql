-- Module 2: Introduction to T-SQL Querying
-- Categories of T-SQL Statements

-- Lesson 1
-- About T-SQL
-- Elements    Predicates and Operators
-- Predicators, ALL, ANY, BETWEEN, IN, LIKE, OR , SOME
-- Comparison Operators, =, >, <, >=, <=, 1=, !>, !<
-- Logical Operators, AND, OR, NOT
-- Arithmetic Operators, *,/, %, +, -
-- Concatination, +
/* Multiline comment
*/
-- Inline comment

-- Batch separators.
-- Batch set of cmd sent to SQL server
-- Uses GO keyword to separate
-- For simple query's GO will not be used, when you nned to create and manipulate objects, you might nned to separate.
-- 
DECLARE @order_id_get int;
SET @order_id_get = 2;

SELECT order_id, order_status, order_date
FROM BikeStores.sales.orders
WHERE order_id = @order_id_get;

-- Predicates, is filter, true or false, I wanto to see order from yeserday, WHERE clause
-- Number of uses Filter, in WHERE / HAVING
-- Providing conditional logic to CASE expressions
-- joining tables, in the ON filter
-- Defining subqueries, in EXISTS
-- Enforcing data integrity,
-- Control flow

-- Lesson 4, logical order

-- Element,		Expression,				Role
-- SELECT, 		select list,			Defines which columns to return
-- FROM, 		table sourcre,			Defines table to query
-- WHERE, 		search condition,		Filters returned data using a predicate
-- GROUP BY, 	group by list, 			Arrange rows by groups
-- HAVING, 		search condition, 		Filters group by predicate
-- ORDER BY,	order by list, 			sorts the result	 	




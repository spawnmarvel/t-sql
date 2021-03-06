-- Using sub querys
-- In a sub query the result of the inner query is returned to the outer query
-- Enhance your ability to create effective queries in T-SQL
-- Nested query's, inner query takes data and pass it to outer

-- Self contained sub query or Correlated
-- Self contained subq have no dependency on outer query
-- Correlated subq depend on values from outer query
-- Sub querys can be scalar, muliti-valued, or table-valued.

-- When to use a sub query, YOU KNOW IT!

-- Most complex Self contained sub query or Correlated:

-- Self contained:
SELECT SalesOrderID, ProductID, UnitPrice, OrderQty
FROM [AdventureWorks].[Sales].[SalesOrderDetail]
WHERE SalesOrderID = (
	SELECT MAX(SalesOrderID) AS LAST_ORDER
	FROM Sales.SalesOrderHeader)

-- Correlated
SELECT SalesOrderID, SalesPersonID, OrderDate
FROM Sales.SalesOrderHeader as o1
WHERE OrderDate = (
SELECT MAX(OrderDate)
FROM Sales.SalesOrderHeader AS o2
WHERE o2.SalesPersonID=o1.SalesPersonID)

-- Writing Scalar Subqueries
-- return a single value
-- can be used anywhere single value expression is used, SELECT, WHERE and so on
-- if inner query returns an empty set, result is converted to NULL
-- construction of outer query determins whether inner query must return a single value
-- Here only 2 levels, but up to 32 levels are supported

SELECT SalesOrderID, ProductID, UnitPrice, OrderQty
FROM [AdventureWorks].[Sales].[SalesOrderDetail]
WHERE SalesOrderID = (
	SELECT MAX(SalesOrderID) AS LAST_ORDER
	FROM Sales.SalesOrderHeader)

-- Writing Multi-Valued Subqueries
-- returns multiple values as a single columns set to outer q
-- used with IN predicate
-- if any value in the subq result matches IN predicate expression, then predicate retuns TRUE

SELECT customer_id, order_status
FROM sales.orders
WHERE customer_id IN (
	SELECT customer_id 
	from sales.customers 
	WHERE state = 'CA')

-- Working with Correlated Subqueries
-- Most complicated
-- Refer to elements of tables used in outer q
-- dependent on outer q, canot be exceuted seperately
-- harder to test than self contained subq
-- behaves as if inner quert is executed once per outer row
-- may return scalar value or multiple values

SELECT SalesOrderID, SalesPersonID, OrderDate
FROM Sales.SalesOrderHeader as o1
WHERE OrderDate = (
SELECT MAX(OrderDate)
FROM Sales.SalesOrderHeader AS o2
WHERE o2.SalesPersonID=o1.SalesPersonID)

-- Write inner q to accept input value from outer q
-- write outer q to accept appropriate retunr result (scalar / multi-value)
-- correlate q by passing value from outer to q to match argument in inner q

-- get the customer, last order and last date
SELECT customer_id, order_id, order_date
FROM [BikeStores].[sales].[orders] OUTER_ORDERS
WHERE order_date = 
	(SELECT MAX(order_date) 
	FROM sales.orders AS INNER_ORDERS
	WHERE INNER_ORDERS.customer_id= OUTER_ORDERS.customer_id)
ORDER BY customer_id

-- Using the EXISTS Predicate with Subqueries
-- When a sub1 is used with the keyword EXISTS, it functions as an existence test
-- true or false, no rows passed back to the outer q
-- EXISTS evaluates to TRUE or FALSE (not unknown)
-- if any are returned by subq, EXISTS = true
-- if no rows are returned by sub1, EXISTS = false

-- get all customers that do not have an order
SELECT customer_id, first_name
FROM sales.customers AS C
WHERE NOT EXISTS 
(SELECT * 
FROM sales.orders o
WHERE c.customer_id=o.customer_id )

-- get all customers that do have an order
SELECT customer_id, first_name
FROM sales.customers AS C
WHERE EXISTS 
(SELECT * 
FROM sales.orders o
WHERE c.customer_id=o.customer_id )

-- all customers that have person id
use AdventureWorks

SELECT CustomerID, PersonID
FROM Sales.Customer AS c
WHERE EXISTS (
SELECT * FROM Sales.SalesOrderHeader AS o
where o.CustomerID=c.CustomerID)
-- CustomerID, Person ID
-- 11000	13531
-- 11001	5454
-- 11002	11269

-- all customers that do not have person id
use AdventureWorks

SELECT CustomerID, PersonID
FROM Sales.Customer AS c
WHERE NOT EXISTS (
SELECT * FROM Sales.SalesOrderHeader AS o
where o.CustomerID=c.CustomerID)
ORDER BY CustomerID desc
-- 701	NULL
-- 700	NULL
-- 699	NULL
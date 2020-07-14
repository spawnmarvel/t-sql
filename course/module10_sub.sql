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



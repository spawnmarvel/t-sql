--Working with Aggregate Functions
-- Aggregate functions
-- Return a scalar value (with no column name)
-- Ignore NULL except in Count(*)
-- Can be used in SELECT, HAVING and ORDER BY
SELECT AVG(p.ListPrice) AS AVG_PRICE,
MIN(p.ListPrice) AS MIN_PRICE,
MAX(p.ListPrice) AS MAX_PRICE
FROM [AdventureWorks].[Production].[Product] p

-- Built-in Aggregate Functions
-- Common, Statistical, other
-- SUM, STDEV, CHECKSUM_AGG (IF SOMETHING HAS CHANGED)
-- MIN, STDEVP, GROUPING
-- MAX, VAR, GROUP_ID
-- AVG, VARP
-- COUNT
-- COUNT_BIG


-- amount of customer orders and unique customers
SELECT COUNT(s.CustomerID) AS ALL_CUSTOMER, COUNT(DISTINCT(s.CustomerID)) AS UNIQUE_CUSTOMER
FROM [AdventureWorks].[Sales].[SalesOrderHeader] AS s
-- select saleperson id and total sales per person and amount of unique customers for that person where year = 
SELECT COALESCE(s.SalesPersonID, 0),  COUNT(s.SalesOrderID) as TOTAL_SALES,  YEAR(s.OrderDate) as ORDER_YEAR,
COUNT(DISTINCT(s.CustomerID)) AS UNIQUE_CUSTOMERS
FROM [AdventureWorks].[Sales].[SalesOrderHeader] AS s
WHERE YEAR(s.OrderDate)= '2005'
GROUP BY s.SalesPersonID, YEAR(s.OrderDate)
ORDER BY TOTAL_SALES DESC
-- check unique customers for that sales person
SELECT COUNT(s.salesPersonID), COUNT(DISTINCT(s.CustomerID)) AS UNIQUE_CUSTOMERS
FROM Sales.SalesOrderHeader AS s
WHERE s.SalesPersonID = 279 and YEAR(s.OrderDate)= 2005;

-- Using Aggregate Functions with NULL
-- Most aggregate functions ignore null
-- COUNT(column) ignores null
-- COUNT(*) count all rows
-- NULL may produce incorrect results, such as use of AVG
-- Use ISNULL or COALESCE to replace NULLS before aggregating

SELECT *
FROM dbo.t1
-- c1	c2
-- 1	NULL
-- 2	10
-- 3	30
-- If you need to summarize all rows, whether NULL or not, consider replacing the NULLs with another value that can be used by your aggregate function.

SELECT 
SUM(c2) AS SUM_NON_NULLS,
COUNT(*) AS COUNT_ALL_ROWS,
COUNT(c2) AS COUNT_NON_NULLS,
AVG(c2) AS [AVG]
FROM [test].[dbo].[t1]

-- SUM_NON_NULLS	COUNT_ALL_ROWS	COUNT_NON_NULLS	AVG
-- 40	3	2	20

SELECT 
SUM(COALESCE(c2,0)) AS SUM_NON_NULLS,
COUNT(*) AS COUNT_ALL_ROWS,
COUNT(c2) AS COUNT_NON_NULLS,
AVG(c2) AS [AVG]
FROM [test].[dbo].[t1]

-- Using the GROUP BY Clause
-- Group aggregation for values
-- if only aggregate functions, then just one row, if group by then unique rows with meaning

-- 
SELECT SalesPersonID, COUNT(*) AS TOTAL_SALES
FROM [AdventureWorks].[Sales].[SalesOrderHeader]
GROUP BY SalesPersonID

-- Order of operation

-- 4 SELECT SalesPersonID, COUNT(*) AS TOTAL_SALES
-- 1 FROM [AdventureWorks].[Sales].[SalesOrderHeader]
-- 2 WHERE YEAR(OrderDate)= 2005
-- 3 GROUP BY SalesPersonID

-- FAIL WITH SUBTOTAL
SELECT SubTotal,  SalesPersonID, COUNT(*) AS TOTAL_SALES
FROM [AdventureWorks].[Sales].[SalesOrderHeader]
WHERE YEAR(OrderDate)= 2005
GROUP BY SalesPersonID
-- Msg 8120, Level 16, State 1, Line 2
-- Column 'AdventureWorks.Sales.SalesOrderHeader.SubTotal' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.

SELECT COUNT(*) AS TOTAL_SALES
FROM [AdventureWorks].[Sales].[SalesOrderHeader]
WHERE YEAR(OrderDate)= 2005
GROUP BY SalesPersonID


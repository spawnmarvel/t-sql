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
 

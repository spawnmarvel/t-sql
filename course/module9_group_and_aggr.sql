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

-- This is done under the hood:
-- the WHERE clause is processed followed by the GROUP BY. 
-- WHERE YEAR(OrderDate)= 2005
-- GROUP BY SalesPersonID

-- GROUP BY AND AGGEGREATE FUNCTIONS ARE USED TOGETHER
-- GRUOP BY CUSTOMER BUT WANT TO FIND AVG SALES PRICE.

-- get all customers and the sum of bought
SELECT c.CustomerID, SUM(s.UnitPrice) AS TOTAL_BOUGHT
FROM [AdventureWorks].[Sales].[SalesOrderHeader] c
INNER JOIN AdventureWorks.Sales.SalesOrderDetail s ON s.SalesOrderID=c.SalesOrderID
WHERE YEAR(OrderDate)= 2005
GROUP BY c.CustomerID
ORDER BY c.CustomerID
-- CustomerID	TOTAL_BOUGHT
-- 11000	3399.99
-- 11001	3374.99
-- 11002	3399.99

--get customer 11000 and what he bought
SELECT c.CustomerID, s.UnitPrice
FROM [AdventureWorks].[Sales].[SalesOrderHeader] c
INNER JOIN AdventureWorks.Sales.SalesOrderDetail s ON s.SalesOrderID=c.SalesOrderID
WHERE YEAR(OrderDate)= 2005
AND c.CustomerID =11000

-- CustomerID	UnitPrice
-- 11000	3399.99

-- Filtering Grouped Data Using the HAVING Clause
-- All the products that have AVG sale higher then?
--get customer data where customer has more then 60 orders
SELECT c.CustomerID, SUM(s.UnitPrice) AS TOTAL_BOUGHT, cu.PersonID, pp.Firstname, pp.LastName
FROM [AdventureWorks].[Sales].[SalesOrderHeader] c
INNER JOIN AdventureWorks.Sales.SalesOrderDetail s ON s.SalesOrderID=c.SalesOrderID
INNER JOIN AdventureWorks.Sales.Customer cu ON cu.CustomerID= c.CustomerID
INNER JOIN AdventureWorks.Person.Person pp ON pp.BusinessEntityID = cu.PersonID
WHERE YEAR(OrderDate)= 2005
GROUP BY c.CustomerID, cu.PersonID, pp.Firstname, pp.LastName
HAVING COUNT(*) > 60
ORDER BY c.CustomerID

--CustomerID	TOTAL_BOUGHT	PersonID	Firstname	LastName
-- 29614	27084.2058	591	Ryan	Calafato
-- 29703	29195.2354	789	Stefan	Delmarco
-- 29966	27873.3926	1355	Richard	Lum

-- Compare HAVING to WHERE
-- WHERE clause controls which rows are available to the next phase of the query.
-- HAVING clause controls which groups are available to the next phase of the query.

-- DEMO
-- having
SELECT 
s.CustomerID,-- customer
SUM(s.TotalDue) as TOTAL_SALES -- sold to customer
FROM [AdventureWorks].[Sales].[SalesOrderHeader] s
GROUP BY s.CustomerID
HAVING SUM(s.TotalDue)> 900000 -- sum greather then
ORDER BY TOTAL_SALES DESC

-- where
SELECT 
s.CustomerID,-- customer
SUM(s.TotalDue) as TOTAL_SALES -- sold to customer
FROM [AdventureWorks].[Sales].[SalesOrderHeader] s
WHERE s.TotalDue < 500000-- where a sell is less then
GROUP BY s.CustomerID 
HAVING SUM(s.TotalDue)> 900000 -- sum greather then
ORDER BY TOTAL_SALES DESC


--LAB
--Get all the years that a particular customer bought something from sales person id 278
SELECT o.CustomerID,o.SalesPersonID, CONCAT(FirstName,' ', pp.LastName) AS CUSTOMER_NAME, YEAR(o.OrderDate) as ORDER_YEAR
FROM AdventureWorks.Sales.SalesOrderHeader AS o
INNER JOIN AdventureWorks.Sales.Customer c ON c.CustomerID= o.CustomerID
INNER JOIN AdventureWorks.Person.Person pp ON pp.BusinessEntityID = c.PersonID
WHERE o.SalesPersonID = 278
AND pp.FirstName LIKE 'MAXWELL%'
GROUP BY o.CustomerID, o.SalesPersonID, pp.FirstName, pp.LastName,YEAR(O.OrderDate)

-- Write a SELECT Statement to Retrieve Groups of Product Categories Sold in a Specific Year and the customer id that bought them
SELECT ppc.ProductCategoryID, ppc.Name, sah.CustomerID --  pp.Name, sad.ProductID, psc.Name,

FROM AdventureWorks.Sales.SalesOrderHeader as sah
INNER JOIN AdventureWorks.Sales.SalesOrderDetail sad ON sad.SalesOrderID = sah.SalesOrderID
INNER JOIN AdventureWorks.Production.Product pp ON pp.ProductID = sad.ProductID
INNER JOIN AdventureWorks.Production.ProductSubcategory psc ON psc.ProductCategoryID = pp.ProductSubcategoryID
INNER JOIN AdventureWorks.Production.ProductCategory ppc ON ppc.ProductCategoryID = PSC.ProductCategoryID
WHERE sah.OrderDate > '20080101' and sah.OrderDate < '20080103'
GROUP BY ppc.ProductCategoryID, ppc.Name, sah.CustomerID

-- ProductCategoryID	Name	CustomerID
-- 1	Bikes	12041
-- 1	Bikes	13648
-- 1	Bikes	14420
-- 1	Bikes	14456
-- 1	Bikes	14580
-- 1	Bikes	14581
-- 1	Bikes	15684
-- 2	Components	11427
-- 2	Components	16422
-- 2	Components	17848

-- Exercise 2: Writing Queries That Use Aggregate Functions

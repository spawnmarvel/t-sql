-- Creating Simple Views

-- Views are saved queries created in a database
-- Views are defined with a single SELECT statment
-- ORDER BY is not premitted in a view definition without the use of TOP, OFFSET/FETCH or FOR XML
-- To sort the output, USE ORDER BY in the outer q
-- View creation supports additional options

-- For data analyse, if tables are not known
-- For security reasons
-- 
-- Start with select statment and then add header
-- ORDER BY is not permitted, the view is used in another select in a query or join with other views
-- 

USE BikeStores;
GO
CREATE SCHEMA hr;
GO
CREATE view hr.StaffPhoneList AS
SELECT staff_id, first_name, last_name, phone
FROM BikeStores.sales.staffs;
GO

-- select from view
SELECT first_name, last_name, phone
FROM hr.staffPhoneList


USE BikeStores;
GO
CREATE SCHEMA eco;
GO
CREATE VIEW eco.AllOrders AS
--get all customers and all orders with the date and productname
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, i.list_price, p.product_name, o.order_date
FROM [BikeStores].[sales].[customers] AS c
INNER JOIN sales.orders o ON o.customer_id=c.customer_id
INNER JOIN sales.order_items i ON i.order_id=o.order_id
INNER JOIN production.products p ON p.product_id=i.product_id

-- Using Inline TVFs, table view functions
-- A primary distinction between a view and an inline TVF is that the latter can accept input parameters and refer to them in the embedded SELECT statement.
-- TVF are named tabel expression with definitions stored in a database
-- TVf return virtual table to the calling quere
-- SQL server provides two types of TVF
-- Inline based on a single SELECT stament
-- Multi statment, which creates and loads a table variabel
-- TVF supports paramaters
-- think of them as parameterized views

CREATE FUNCTION eco.AllOrdersPerYear(@year_to_select INT)
RETURNS TABLE 
AS
RETURN
--get all customers and all orders with the date and productname
	SELECT c.customer_id, c.first_name, c.last_name, o.order_id, i.list_price, p.product_name, o.order_date
	FROM [BikeStores].[sales].[customers] AS c
	INNER JOIN sales.orders o ON o.customer_id=c.customer_id
	INNER JOIN sales.order_items i ON i.order_id=o.order_id
	INNER JOIN production.products p ON p.product_id=i.product_id
	WHERE YEAR(o.order_date)= @year_to_select

-- Calling Table view functions
SELECT customer_id, list_price, product_name, order_date
FROM eco.AllOrdersPerYear(2018) as PY--Per Year

CREATE FUNCTION eco.GetProductByPrice(@price_to_select INT)
RETURNS TABLE
AS
RETURN
SELECT order_id, item_id,product_id, quantity, list_price, discount
FROM [BikeStores].[sales].[order_items]
WHERE list_price > @price_to_select

--
SELECT * FROM eco.GetProductByPrice(200)
ORDER BY list_price

-- Derived table is another name for subquery - a select statement within another query. It's not persisted after the query finishes, it may not even be stored at all
-- A temp table is a real table that's stored in the TempDB database, column, indexes, constraints, etc. It persists until dropped or until the procedure that created it completes or the connection that creates it closes.

-- Writing Queries with Derived Tables
-- Views and TVF are valuable when you reusing them, module, sourcre of other views.
-- But sometimes need views for other complex queries
-- allow you to write T-SQL statements that are more modular
-- break down complex queries into more manageable parts
-- derived tables in your queries can also provide workarounds for some of the restrictions imposed by the logical order of query processing
-- such as the use of column aliases. 

-- Derived table must
-- have an alias
-- have names for all columns
-- have unique names for all columns
-- not use order by clause without TOP / OFFSETT7FETCH
-- not be referred to multiple times in the dame query

-- Derived tables may
-- use internal or external aliases fro clumns
-- refer to paramters and or variables
-- be nested within other derived tables

-- Using Aliases for Column Names in Derived Tables
SELECT YEAR(OrderDate) AS ORDER_YEAR, CustomerID
FROM Sales.SalesOrderHeader AS DERIVED_TABLE

--ORDER_YEAR	CustomerID
-- 2005	29825
-- 2005	29672
-- 2005	29734

SELECT ORDER_YEAR, COUNT(DISTINCT(CustomerID)) AS CUST_COUNT
FROM(
SELECT YEAR(OrderDate) AS ORDER_YEAR, CustomerID
FROM Sales.SalesOrderHeader) AS DERIVED_TABLE --ALIAS INLINE
GROUP BY ORDER_YEAR

-- ORDER_YEAR	CUST_COUNT
-- 2007	9864
-- 2008	11844
-- 2005	1216
-- 2006	3094


-- Passing Arguments to Derived Tables
-- Derived tables in SQL Server can accept arguments, function, stored procedure, T-SQL Batch
DECLARE @year_to_select INT = 2007;
SELECT ORDER_YEAR, COUNT(DISTINCT(CustomerID)) AS CUST_COUNT
FROM(
	SELECT YEAR(OrderDate) AS ORDER_YEAR, CustomerID
	FROM Sales.SalesOrderHeader
	WHERE YEAR(OrderDate)= @year_to_select --VARIABLE
    ) AS DERIVED_TABLE --ALIAS
GROUP BY ORDER_YEAR

-- Nesting and Reusing Derived Tables
-- querys on querys....and on and on, more complex data systems, multiple layers of derived tables
-- Find avg daily sales for the week
-- DERIVED TABLES MAY BE NESTED, THOUGH NOT RECOMMENDED.


-- Demonstration: Using Derived Tables
-- This will be the source
SELECT s.SalesOrderID, YEAR(o.OrderDate) AS OrderYear, MONTH(o.OrderDate) AS OrderMonth,SUM(s.UnitPrice * s.OrderQty)AS TotalOrder
FROM Sales.SalesOrderDetail as s
INNER JOIN Sales.SalesOrderHeader o ON o.SalesOrderID= s.SalesOrderID
GROUP BY  s.SalesOrderID, YEAR(o.OrderDate) , MONTH(o.OrderDate)
-- SalesOrderID, OrderYear, OrdrMonth, TotalOrder
-- 43659	2005	7	20565.6206
-- 43660	2005	7	1294.2529
-- 43661	2005	7	32726.4786
-- 43662	2005	7	28832.5289

SELECT *
FROM (
-- source begin
SELECT s.SalesOrderID, YEAR(o.OrderDate) AS OrderYear, MONTH(o.OrderDate) AS OrderMonth,SUM(s.UnitPrice * s.OrderQty)AS TotalOrder
FROM Sales.SalesOrderDetail as s
INNER JOIN Sales.SalesOrderHeader o ON o.SalesOrderID= s.SalesOrderID
GROUP BY  s.SalesOrderID, YEAR(o.OrderDate) , MONTH(o.OrderDate)
-- source end
) AS OT

-- Gives the same result, so it works

-- Now we can use the derived columns
SELECT OrderYear, OrderMonth, AVG(TotalOrder) AverageOrder -- from derived
FROM (
-- source begin
	SELECT s.SalesOrderID, YEAR(o.OrderDate) AS OrderYear, MONTH(o.OrderDate) AS OrderMonth,SUM(s.UnitPrice * s.OrderQty)AS TotalOrder
	FROM Sales.SalesOrderDetail as s
	INNER JOIN Sales.SalesOrderHeader o ON o.SalesOrderID= s.SalesOrderID
	GROUP BY  s.SalesOrderID, YEAR(o.OrderDate) , MONTH(o.OrderDate)
-- source end
) AS OT
GROUP BY OrderYear, OrderMonth

-- Lesson 4: Using CTEs, Comon table expressions
-- are named expressions defined in a query. Like subqueries and derived tables, 
-- provide a means to break down query problems into smaller, more modular units.
-- Views and derived table good concepts, but have some drawbacks
-- CTE are named table expressions
-- CTE uses less T-SQL writings
-- CTE are similar to derived tables in scope and naming requiremenets
-- Unlike derived tables, CTE support multiple definitions, multiple references and recursion
-- CTE is good, much easier to maintain and the same separations like the view and can reuse this,
-- cannot reuse derived table

-- To Create a CTE
-- Define the table expression in a WITH clause
-- Assign column aliases (inline or external)
-- Pass arguments if desired
-- Reference the CTE in the outer query

WITH CTE_year AS
(-- beg source
SELECT YEAR(OrderDate) AS OrderYear, CustomerID
FROM Sales.SalesOrderHeader
)-- end source
SELECT OrderYear, COUNT(DISTINCT(CustomerID)) AS Cust_Count
from CTE_year
GROUP BY OrderYear



-- DEMO get annual sales
WITH AnnualSales AS
( -- source
SELECT s.SalesOrderID, YEAR(o.OrderDate) AS OrderYear, MONTH(o.OrderDate) AS OrderMonth,SUM(s.UnitPrice * s.OrderQty)AS TotalSales
FROM Sales.SalesOrderDetail as s
INNER JOIN Sales.SalesOrderHeader o ON o.SalesOrderID= s.SalesOrderID
GROUP BY  s.SalesOrderID, YEAR(o.OrderDate) , MONTH(o.OrderDate)
)
SELECT
	c.OrderYear, c.OrderMonth, c.TotalSales AS CSales, p.TotalSales as PSales

FROM
	AnnualSales AS c INNER JOIN AnnualSales as p
	ON c.OrderMonth=p.OrderMonth AND c.OrderYear=P.OrderYear +1;

    

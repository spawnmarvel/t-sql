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



-- Lesson 1: Creating Windows with OVER

-- Windows extend T-SQL's set-based approach
-- Allow you to specify an order as part of a calc, without order of inp/output.
-- Allow partitioning / framing of rows to support functions.
-- Functions may simplyfy queries that need to find run totals, moving avg or hole's in data

-- 3 parts, for example sum() function, PARTION BY row, ORDER BY, ROWS BETWEEN UNBOUNDED PRECEDING(go to the beginning of this partitions/windows), UNBOUNDED FOLLOWING (end of partitions/window), CURRENT ROW(actual data)
-- Can help to simplify complex queuries and speed up performance

-- Windowing Components
-- Result set (OVER)
-- Window partition (PARTITION BY)
-- Frame (ROWS BETWEEN), what data am I looking at and boundarys, UP previous, CR current, UF following. Can add the calc's to the detail data

-- SalesOrderID	ProductID	OrderQty
-- Window beg
-- partion by order (first start)
    -- 43659	776	1 UP, Unbound predeceding
    -- 43659	777	3 CURRENT ROW
    -- 43659	778	1 UF, Unbound following
    -- 43659	771	1
    -- 43659	772	1
-- partion by order (first end)
    -- 43661	745	1
    -- 43661	743	1
    -- 43661	747	2
    -- 43661	712	4
-- Window end

SELECT SalesOrderID
      ,ProductID
	  ,OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) as Order_Total -- Here the frame is the total partition
FROM [AdventureWorks].[Sales].[SalesOrderDetail]
ORDER BY SalesOrderID

-- SalesOrderID	ProductID	OrderQty	Order_Total
-- 43659	776	1	26
-- 43659	777	3	26
-- 43659	778	1	26
-- 43659	771	1	26
-- 43659	772	1	26
-- 43661	745	1	38
-- 43661	743	1	38
-- 43661	747	2	38
-- 43661	712	4	38

-- Using OVER
-- Defines a window (gives the power)
-- If only OVER then the all row's
-- Multiple OVER can be used
-- OVER ([ PARTITION BY column])
--         ORDER BY, running or ranking function, top 5
--         ROWS or RANGE, entier partion or beginning to current row, or moving avg

-- Partitioning Windows
-- Limits a set of row, with the same value in partitioning
-- If non, it will window over the total row set

-- SalesOrderID	ProductID	OrderQty	Order_Total
-- 43659	776	1	26
-- 43659	777	3	26
-- 43659	778	1	26
-- 43659	771	1	26
-- 43659	772	1	26
-- 43659	773	2	26
-- 43659	774	1	26
-- 43659	714	3	26
-- 43659	716	1	26
-- 43659	709	6	26
-- 43659	712	2	26
-- 43659	711	4	26
-- 43660	762	1	2

-- Total OrderQty = 26 for SalesOrderID 43659
-- In order to do the same: create tabel expressions that calculates sum expression and join's into detail data

-- Ordering and Framing
-- Allows to set start, end within window partition
-- UNBOUNDED, go to all the way to direction PRECEDING or FOLLOWING (start or end)
-- CURRENT ROW, indicates start or end in partition
-- ROWS BETWEEN, define range of rows between 2 points.
-- Window ordering provides a contex to the frame
-- sort enables meaning to position
-- Without ordering "starte at 1 row" is has now order, i.e not useful.

-- Examples
-- If we change the old view and add the category name
USE BikeStores
GO
CREATE VIEW [eco].[AllOrderswithCategoryID] AS
--get all customers and all orders with the date and productname
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, i.list_price, p.product_name, o.order_date, ca.category_name, ca.category_id
FROM [BikeStores].[sales].[customers] AS c
INNER JOIN sales.orders o ON o.customer_id=c.customer_id
INNER JOIN sales.order_items i ON i.order_id=o.order_id
INNER JOIN production.products p ON p.product_id=i.product_id
INNER JOIN production.categories ca ON ca.category_id=p.product_id
GO

-- Result
-- customer_id	first_name	last_name	order_id	list_price	product_name	order_date	category_name category_id
-- 259	Johnathan	Velazquez	1	1799.99	Trek Remedy 29 Carbon Frameset - 2016	2016-01-01	Road bike 8
-- 259	Johnathan	Velazquez	1	2899.99	Trek Fuel EX 8 29 - 2016	2016-01-01	Cyclocross Bicycles 4
-- 523	Joshua	Robertson	3	999.99	Surly Wednesday Frameset - 2016	2016-01-02	Cruisers Bicycles 3

-- rank by price, 1 is the most expensive
SELECT TOP (1000) [customer_id]
      ,[first_name]
      ,[last_name]
      ,[order_id]
      ,[list_price]
      ,[product_name]
      ,[order_date]
      ,[category_name]
      ,[category_id]
	  ,  RANK() OVER(ORDER BY [list_price] DESC) AS PriceRank
  FROM [BikeStores].[eco].[AllOrderswithCategoryID]
  --ORDER BY category_name

-- customer_id	first_name	last_name	order_id	list_price	product_name	order_date	category_name PriceRank
-- 60	Neil	Mccall	9	3999.99	Trek Slash 8 27.5 - 2016	2016-01-05	Road Bikes	1
-- 541	Lanita	Burton	18	3999.99	Trek Slash 8 27.5 - 2016	2016-01-14	Road Bikes	1
-- 1280	Jackeline	Colon	26	3999.99	Trek Slash 8 27.5 - 2016	2016-01-18	Road Bikes	1
-- [...]

-- rank by price, 1 is the most expensive
-- partition by window category id
  SELECT TOP (1000) [customer_id]
      ,[first_name]
      ,[last_name]
      ,[order_id]
      ,[list_price]
      ,[product_name]
      ,[order_date]
      ,[category_name]
      ,[category_id]
	  ,  RANK() OVER(PARTITION BY [category_id] ORDER BY [list_price] DESC) AS PriceRank
  FROM [BikeStores].[eco].[AllOrderswithCategoryID]
  ORDER BY category_id


  WITH CP AS -- derived table
  (
  SELECT TOP (1000) [customer_id]
      ,[first_name]
      ,[last_name]
      ,[order_id]
      ,[list_price]
      ,[product_name]
      ,[order_date]
      ,[category_name]
      ,[category_id]
	  ,  RANK() OVER(PARTITION BY [category_id] ORDER BY [list_price] DESC) AS PriceRank
  FROM [BikeStores].[eco].[AllOrderswithCategoryID]
  
  )
  SELECT * FROM CP
  WHERE CP.PriceRank <= 500
  ORDER BY category_id
  
-- Lesson 2: Exploring Window Functions
-- Window function is used on window, set or row
-- Window function inc: aggregate, ranking, distribution, offset
-- Window function depends on the set in the OVER

-- Window Aggregate Functions
-- like group by, SUM, MIN, MAX
-- Applied to the window, not all data
-- Support partitioning, ordering and framing

-- select total orders per customer, this can only be done in window function, all aggregate can be used this way
SELECT s.customer_id,MONTH(s.order_date) AS order_month,s.order_date, i.quantity,
SUM(i.quantity) OVER(PARTITION BY s.customer_id) AS TotalPerCust
FROM [BikeStores].[sales].[order_items] i
INNER JOIN sales.orders s ON s.order_id=i.order_id

-- customer_id	order_month	order_date	quantity	TotalPerCust
-- 1	12	2016-12-09	2	17
-- 1	12	2016-12-09	2	17
-- 1	12	2016-12-09	1	17
-- 1	12	2016-12-09	2	17

-- The max TotalPerCust
WITH TotalDerivedT AS
(
SELECT s.customer_id,MONTH(s.order_date) AS order_month,s.order_date, i.quantity,
SUM(i.quantity) OVER(PARTITION BY s.customer_id) AS TotalPerCust
FROM [BikeStores].[sales].[order_items] i
INNER JOIN sales.orders s ON s.order_id=i.order_id
)
SELECT MAX(TotalDerivedT.TotalPerCust) max_orders
FROM TotalDerivedT
-- max_orders
-- 19

-- Ranking function only within a window order clause
-- RANK (Will have holes, 1,1,4), DENSE_RANK(No holes, 1,2,3), ROW_NUMBER(Unique seq row number, just gives number), NTILE (cool, all gets in groups, bucket1, 2 etc.)

-- Window Distribution Functions, statistic analysis on data, PERCENT_RANK, CUME_DIST
-- Inverse PERCENTILE_CONT, PERECENTILE_DISC

-- Window Offset Functions / Data analysis
-- Allow comparisons between rows without a self join, is cool
-- Good for analysis over time
-- Operate on positition to the current row, end or start
-- LAG (compare to previous year), LEAD(looking in another directions / window), FIRST_VALUE(first in current window), LAST_VALUE(last in curretn window)

-- Examples Lead
-- Current compared to next year

-- get staff id and total sales
SELECT st.staff_id, COUNT(sa.order_id) AS total_orders_by_emp, SUM(it.list_price*it.quantity) AS all_sale
FROM sales.staffs as st
INNER JOIN sales.orders sa ON sa.staff_id=st.staff_id
INNER JOIN sales.order_items it ON it.order_id=sa.order_id
GROUP BY st.staff_id
ORDER BY st.staff_id


SELECT employee, orderyear, totalsales as currsales
    LEAD(totalsales, 1,0) OVER (PARTITION BY employee)
        ORDER BY orderyear) AS nextsales
FROM SalesOrdersByEmployeeYear --THIS IS A VIEW
ORDER BY employee, orderyear

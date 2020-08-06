-- More learning from the course
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms365303%28v%3dsql.105%29

-- Built in functions
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms173454(v=sql.105)

--Choose db
use AdventureWorks;
GO
-- get columns
EXEC sp_columns SalesOrderDetail;

-- Aggregate Functions (Transact-SQL)
use AdventureWorks;
GO
SELECT 
AVG(UnitPrice) as res_avg, 
MIN(UnitPrice) res_min, 
MAX(UnitPrice) res_max,
COUNT(*) AS total_num,
SUM(UnitPrice) total_sum,
CHECKSUM_AGG(CAST(UnitPrice AS INT)) as num_of_changes, -- check if value is changed
STDEV(UnitPrice) as res_stdev
-- In statistics, the standard deviation is a measure of the amount of variation or dispersion of a set of values. 
-- A low standard deviation indicates that the values tend to be close to the mean (also called the expected value) of the set, 
-- while a high standard deviation indicates that the values are spread out over a wider range. 
FROM Sales.SalesOrderDetail;


-- Date and Time Functions
-- Mathematical Functions (Transact-SQL)
-- Security Functions (Transact-SQL)
-- String Functions (Transact-SQL)



-- GROUP BY
-- get all sales from salesperson and the total sum and tax
SELECT SalesPersonID, COUNT(*) AS sales_total, 
SUM(SubTotal) AS sales_money,
SUM(TaxAmt) AS total_tax
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
ORDER by sales_total desc
--
-- same as above but with year = 2008
SELECT SalesPersonID, COUNT(*) AS sales_total, 
SUM(SubTotal) AS sales_money,SUM(TaxAmt) AS total_tax
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)= 2008
GROUP BY SalesPersonID
ORDER by sales_total desc
--
-- The HAVING clause was added to SQL because the WHERE keyword could not be used with aggregate functions.
-- same as above but with more then 80 customers
SELECT SalesPersonID, COUNT(*) AS sales_total, 
SUM(SubTotal) AS sales_money,
SUM(TaxAmt) AS total_tax, 
COUNT(CustomerID) as total_customers
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)= 2008
GROUP BY SalesPersonID
HAVING COUNT(CustomerID) > 80 -- more than 80 customers
ORDER by sales_total desc
--
-- get total sale, total sale - rejected, rejected, the overall total and number of rejected items
SELECT 
SUM(UnitPrice*OrderQty) AS total_sale_sum,  
SUM(UnitPrice*(OrderQty-RejectedQty)) AS total_sales_minus_rejected_sum, 
SUM(UnitPrice*RejectedQty) AS total_rejected_sum,
SUM(UnitPrice*(OrderQty-RejectedQty)) + SUM(UnitPrice*RejectedQty) AS total_all, 
COUNT(RejectedQty) as total_num_of_rejected
FROM [AdventureWorks].[Purchasing].[PurchaseOrderDetail]
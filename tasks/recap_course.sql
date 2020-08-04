-- More learning from the course
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms365303%28v%3dsql.105%29

-- Built in functions
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms173454(v=sql.105)

--Choose db
use AdventureWorks;
GO
-- get columns
EXEC sp_columns SalesOrderDetail;

--aggregate functions
SELECT AVG(UnitPrice) as res_avg, MIN(UnitPrice) res_min, MAX(UnitPrice) res_max
FROM Sales.SalesOrderDetail;


-- more built in

-- GROUP BY
-- get all sales from salesperson and the total sum and tax
SELECT SalesPersonID, COUNT(*) AS sales_total, SUM(SubTotal) AS sales_money,SUM(TaxAmt) AS total_tax
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
ORDER by sales_total desc

-- get total sale, total sale - rejected, rejected, the overall total and number of rejected items
SELECT 
SUM(UnitPrice*OrderQty) AS total_sale_sum,  
SUM(UnitPrice*(OrderQty-RejectedQty)) AS total_sales_minus_rejected_sum, 
SUM(UnitPrice*RejectedQty) AS total_rejected_sum,
SUM(UnitPrice*(OrderQty-RejectedQty)) + SUM(UnitPrice*RejectedQty) AS total_all, 
COUNT(RejectedQty) as total_num_of_rejected
FROM [AdventureWorks].[Purchasing].[PurchaseOrderDetail]
-- Stored Procedures
-- Return results by executing stored procedures.
-- Pass parameters to procedures.
-- Create simple stored procedures that encapsulate a SELECT statement.
-- Construct and execute dynamic SQL with EXEC and sp_executesql.

use AdventureWorks2012
GO
EXEC uspGetEmployeeManagers @BusinessEntityID=100;

-- 0	100	Lolan	Song	/3/1/9/7/	Kok-Ho	Loh
-- 1	93	Kok-Ho	Loh	/3/1/9/	Peter	Krebs
-- 2	26	Peter	Krebs	/3/1/	James	Hamilton


-- Lesson 1: Querying Data with Stored Procedures
-- Examining Stored Procedures
-- Statments stored in db
-- Can return result, DML data, and do admin task, like system configuration and maintenance
-- Provide API to interface to db
-- Use, views, func and proc to return data


-- Executing Stored Procedures
-- If the procedure accepts NVARCHAR, pass in the Unicode character string format: N'string'. 



-- Lesson 2: Passing Parameters to Stored Procedures
-- Param are defined in header of procedure, data type, name, input etc
-- Param can be found in sys.parameters view
-- Parameters names, passed in proc with @

use AdventureWorks2012
GO
EXEC uspGetEmployeeManagers @BusinessEntityID=100; -- call proc with param


-- Working with OUTPUT Parameters
-- Allow to return values from stored procedure
-- Para marked for output in proc header and calling query


-- Lesson 3: Creating Simple Stored Procedures
-- Proc can be wrapper for all SELECT statments
-- As mentioned have input and output and return val
-- CREATE PROCEDURE schema_name.procedure_name
-- Modify with ALTER, thete is no need to recreaet or drop

CREATE SCHEMA customer;
GO
CREATE PROCEDURE customer.GetOrderInformation
AS
--Get all order information on customers
SELECT sod.[SalesOrderID]
      ,sod.[OrderQty]
      ,sod.[ProductID]
      ,sod.[SpecialOfferID]
      ,sod.[UnitPrice]
      ,sod.[UnitPriceDiscount]
      ,sod.[LineTotal]
	  ,soh.CustomerID
	  ,soh.OrderDate
FROM [AdventureWorks].[Sales].[SalesOrderDetail] AS sod
INNER JOIN sales.SalesOrderHeader AS soh ON soh.SalesOrderID=sod.SalesOrderID
ORDER BY sod.LineTotal desc
GO

-- Execute the procedure
EXEC customer.GetOrderInformation
GO
-- SalesOrderID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, CustomerID, OrderDate
-- 47378	3	787	1	647.994	0.00	1943.982000	30118	2006-09-01 00:00:00.000
-- 47378	2	716	1	28.8404	0.00	57.680800	30118	2006-09-01 00:00:00.000
-- 47378	2	861	1	22.794	0.00	45.588000	30118	2006-09-01 00:00:00.000
-- 47378	1	784	1	1229.4589	0.00	1229.458900	30118	2006-09-01 00:00:00.000

-- Stored procedure with paramters
CREATE PROCEDURE customer.GetOrderInformationByYear (@check_year AS INT)
AS
--Get all order information on customers by year
SELECT sod.[SalesOrderID]
      ,sod.[OrderQty]
      ,sod.[ProductID]
      ,sod.[SpecialOfferID]
      ,sod.[UnitPrice]
      ,sod.[UnitPriceDiscount]
      ,sod.[LineTotal]
	  ,soh.CustomerID
	  ,soh.OrderDate
FROM [AdventureWorks].[Sales].[SalesOrderDetail] AS sod
INNER JOIN sales.SalesOrderHeader AS soh ON soh.SalesOrderID=sod.SalesOrderID
WHERE YEAR(soh.OrderDate)= @check_year
ORDER BY sod.LineTotal desc
GO

-- Execute the procedure
EXEC customer.GetOrderInformationByYear @check_year=2008;
GO

-- 63291	17	780	3	1275.9945	0.05	20607.311175	29913	2008-02-01 00:00:00.000
-- 67297	16	783	3	1262.2445	0.05	19186.116400	29497	2008-04-01 00:00:00.000
-- 69437	16	782	3	1262.2445	0.05	19186.116400	29712	2008-05-01 00:00:00.000
-- 71783	25	976	4	850.495	0.10	19136.137500	29957	2008-06-01 00:00:00.000

-- Stored procedure with multiple paramters
CREATE PROCEDURE customer.GetOrderInformationByYearAndCustomerID (@check_year AS INT, @check_customer_id AS INT)
AS
--Get all order information on customers by year
SELECT sod.[SalesOrderID]
      ,sod.[OrderQty]
      ,sod.[ProductID]
      ,sod.[SpecialOfferID]
      ,sod.[UnitPrice]
      ,sod.[UnitPriceDiscount]
      ,sod.[LineTotal]
	  ,soh.CustomerID
	  ,soh.OrderDate
FROM [AdventureWorks].[Sales].[SalesOrderDetail] AS sod
INNER JOIN sales.SalesOrderHeader AS soh ON soh.SalesOrderID=sod.SalesOrderID
WHERE YEAR(soh.OrderDate)= @check_year
AND soh.CustomerID=@check_customer_id
ORDER BY sod.LineTotal desc

-- 71803	8	782	1	1376.994	0.00	11015.952000	30118	2008-06-01 00:00:00.000
-- 65221	4	783	1	1376.994	0.00	5507.976000	30118	2008-03-01 00:00:00.000
-- 65221	4	782	1	1376.994	0.00	5507.976000	30118	2008-03-01 00:00:00.000
-- 71803	4	783	1	1376.994	0.00	5507.976000	30118	2008-06-01 00:00:00.000

-- Lesson 4: Working with Dynamic SQL

-- SQL Server Built-in Function Types
-- T-SQL richs set of functions
-- Describe the difference between implicit and explicit conversions.
-- Describe when you will need to use explicit conversions.
-- Explicitly convert between data types using the CAST and CONVERT functions.
-- Convert strings to date and numbers with the PARSE, TRY_PARSE, and TRY_CONVERT functions.
-- And deal with NULL

-- 4 primary categories
-- Scalar, operates on a single value, retur single value
-- Grouped aggregates, take one or more values, return single summarize value
-- Window, operate on a window, set
-- Row set, return a virtual table, that can be used in a T-SQL statment

-- Scalar functions
-- function(input) = return a value, 

-- Aggregate functions,that operates on a set, or row of data
-- Summarize input rows, SUM, MIN, MAX, AVG etc.
-- Grouped aggregate functions operate on sets of rows defined in a GROUP BY clause and return a summarized result.

-- Window functions, allows to perform calculations against user defined.
-- ranking, offset, aggregate and distributed functions

-- Rowset functions and object that can be used like a table in a new statment
-- OPENDATASOURCRE, OPENQUERY, OPEN ROWSET, OPENXML

USE AdventureWorks2016
GO

-- scalar, calculate on each row
SELECT ABS(-1.0), ABS(0.98);
SELECT CAST(SYSDATETIME() AS DATE) AS d;
SELECT DB_NAME() as db;
SELECT sd.SalesOrderID,sd.OrderDate, YEAR(sd.OrderDate) order_year
FROM Sales.SalesOrderHeader sd;
-- aggregate, calculate on a set of rows
SELECT COUNT(*) AS num_of_orders
FROM Sales.SalesOrderHeader sd
WHERE ShipDate > '20130131' AND ShipDate < '20131231';

SELECT TOP(5) ProductID, SUM(ListPrice) as total_price
FROM Production.Product
WHERE ListPrice > 0
GROUP BY ProductID



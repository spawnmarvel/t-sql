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

-- Lesson 2
-- Implicit and Explicit Data Type Conversions
-- Data types must be converted during SQL Server operations.
-- May implicitily convert data types

SELECT '2'+ 2 -- 4
SELECT 'A'+ 2 -- Conversion failed when converting the varchar value 'A' to data type int.
-- FIX
SELECT 'A' + CAST(2 AS varchar)

-- cast
SELECT CAST(28 AS varchar)
SELECT CAST(3.284 AS int)
SELECT CAST(1 AS binary)
-- covnvert has a differnt order, with cast it is value as datatype
-- convert has also style, for dates, xml and so on, not do to much of this
SELECT CONVERT(char(20), CURRENT_TIMESTAMP)

-- Converting Strings with PARSE
-- can be extremely useful, cultural data, dates
-- Use cultural neutral, but if not, US date vs ENG date
-- Parse can specify cultural
SELECT PARSE('02/10/2020' AS datetime2 USING 'en-US') as us_result; -- 2020-02-10 00:00:00.0000000
SELECT PARSE('02/10/2020' AS datetime2 USING 'no') as no_result; -- 2020-10-02 00:00:00.0000000

-- Converting with TRY_PARSE and TRY_CONVERT
-- Problem with CAST, CONVERT, not always work
-- TRY_PARSE, TRY_CONVERT returns NULL if they fail, that is good!
SELECT TRY_PARSE('WILL FAIL' AS datetime2 USING 'en-US') as us_result; -- NULL

-- Writing Logical Test with Functions
SELECT ISNUMERIC('12') AS isnumeric_result; --if a string can be a valid numeric, returns 1 for valid
SELECT ISNUMERIC('qa') AS isnumeric_result; --if a string can be a valid numeric, returns 0 for not valid

-- Performing Conditional Tests with IIF
-- Looked a CAST earlier, IIF as a shorthand approach to writing a CASE statement with two possible return values
-- expression, value if true, value if unknown

SELECT p.ProductID, p.Name, p.ListPrice,
CASE WHEN p.ListPrice < 150 THEN 'CHEAP'
ELSE 'EXPENSIVE'
END price_test
      
FROM [AdventureWorks2016].[Production].[Product] p
WHERE p.ListPrice >80

-- IIF, to simplify lofic, IIF must be nested if many.
SELECT p.ProductID, p.Name, p.ListPrice,
IIF(p.ListPrice < 150,'CHEAP', 'EXPENSIVE')
FROM [AdventureWorks2016].[Production].[Product] p
WHERE p.ListPrice >80

SELECT  p.ProductID, p.Name, p.ListPrice,
CASE  
	WHEN p.ListPrice > 600 THEN 'Premimum'
	ELSE 'Budget'
END price_category,
IIF(p.ListPrice > 1000, 'Premimum2', 'Budget2') AS price_category_2
FROM [AdventureWorks2016].[Production].[Product] p
WHERE p.ListPrice >80
AND p.Color = 'RED'


-- CHOOSE, Selecting Items from a List with CHOOSE
-- Not sure where to use it, better to use join
-- Maybe if calculated columns

-- Lesson 4
-- Using Functions to Work with NULL
-- ISNULL is not standard; use COALESCE instead. COALESCE 
-- IS NULL

-- Using COALESCE to Return Non-NULL Values
-- Returns the first non-null value in a list
-- With only two arguments, COALESCE behaves like ISNULL
-- if all arguments are NULL, COALESCE returns NULL

SELECT [CustomerID]
	  ,COALESCE([PersonID], '0') -- replaces NULL with 0
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2016].[Sales].[Customer]

-- Last function
-- Using NULLIF to Return NULL If Values Match
-- Takes a value and converts it to NULL
-- Use case, aggregation, if table and columns that do not have a actual value
-- production list price, should never be zero, but if not know list price, then 0 value
-- NULLIF Takes two arguments, returns NULL of they both match, if they are not equal return first argument
-- gives value when using agggregation

SELECT [ProductID]
      ,[Name]
      ,[Color]
      ,[ListPrice]
      ,NULLIF([ListPrice], '0') AS NULL_COLUMN
  FROM [AdventureWorks2016].[Production].[Product]
  ORDER BY ListPrice desc

-- ProductID	Name	Color	ListPrice	NULL_COLUMN
-- 922	Road Tire Tube	NULL	3.99	3.99
-- 873	Patch Kit/8 Patches	NULL	2.29	2.29
-- 523	LL Spindle/Axle	NULL	0.00	NULL
-- 524	HL Spindle/Axle	NULL	0.00	NULL











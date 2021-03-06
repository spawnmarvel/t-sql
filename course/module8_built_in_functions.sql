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

-- Demonstration: Using Functions to Work with NULL
SELECT
      p.Name
      ,p.Size + ' ' + p.SizeUnitMeasureCode as Size,
      CAST(p.Weight as varchar) + ' ' + 
      p.WeightUnitMeasureCode as Weight
  FROM [AdventureWorks2016].[Production].[Product]

-- Name	Size	Weight
-- Adjustable Race	NULL	NULL
-- Bearing Ball	NULL	NULL
-- BB Ball Bearing	NULL	NULL

SELECT
      p.Name
      ,ISNULL(p.Size + ' ' + p.SizeUnitMeasureCode, 'NA') as Size,
      COALESCE(CAST(p.Weight as varchar) + ' ' + 
	  p.WeightUnitMeasureCode, 'NA') as Weight
  FROM [AdventureWorks2016].[Production].[Product] p

-- Name	Size	Weight
-- Cone-Shaped Race	NA	NA
-- Reflector	NA	NA
-- LL Mountain Rim	NA	435.00 G  
-- ML Mountain Rim	NA	450.00 G  


SELECT
      p.Name,
	  p.weight,
      COALESCE(CAST(p.Weight as varchar) + ' ' + 
	  p.WeightUnitMeasureCode, 'NA') as Weight
  FROM [AdventureWorks2016].[Production].[Product] p

-- Name	weight	Weight
-- Cone-Shaped Race	NULL	NA
-- Reflector	NULL	NA
-- LL Mountain Rim	435.00	435.00 G  
-- ML Mountain Rim	450.00	450.00 G  
-- HL Mountain Rim	400.00	400.00 G  


SELECT 
	p.FirstName +' ' + p.MiddleName + ' '+  p.LastName as full_name
  FROM [AdventureWorks2016].[Person].[Person] p

  -- Syed E Abbas
-- Catherine R. Abel
-- NULL
-- NULL
-- Kim B Abercrombie

SELECT 
	CONCAT(p.FirstName,' ' + p.MiddleName + ' '+  p.LastName) as full_name --REMOVES NULL
  FROM [AdventureWorks2016].[Person].[Person] p

-- Syed E Abbas
-- Catherine R. Abel
-- Kim
-- Kim
-- Kim B Abercrombie

-- Lab: Using Built-in Functions

-- Task 2: Write a SELECT Statement that Uses the CAST or CONVERT Function
SELECT 'The unit price for ' + p.Name + ' is ' + CAST(p.ListPrice as varchar) AS PRODUCT_INFO
FROM [AdventureWorks].[Production].[Product] p
WHERE p.ListPrice > 0

-- Task 3: Write a SELECT Statement to Filter Rows Based on Specific Date Information
--check what orders was sent fast, within 5 days and also print the purchase number and subsitute it, if it was missing
SELECT o.SalesOrderID, o.OrderDate, o.ShipDate, o.ShipDate, COALESCE(o.PurchaseOrderNumber , 'Missing PO') as NO_PURCHASE_ORDER
FROM [AdventureWorks].[Sales].[SalesOrderHeader] o
WHERE o.OrderDate >= PARSE('4/1/2007' AS DATETIME USING 'en-us') --input must be parsed
AND o.OrderDate <= PARSE('11/30/2007' AS DATETIME USING 'en-us') --input must be parsed
AND o.ShipDate > DATEADD(DAY, 5, o.OrderDate)-- adds 5 days to the order date

-- Task 4: Write a SELECT Statement to Convert the Phone Number Information to an Integer Value
-- remove all signs from the phone number, 1 (11) 500 555-0110-> 1 11 500 5550110, 163-555-0147-> 1635550147
SELECT pp.BusinessEntityID, REPLACE(REPLACE(REPLACE(pp.PhoneNumber, '-', ''), '(', ''), ')', '') AS PHONE_NR, pp.PhoneNumber, per.FirstName + per.LastName as FULL_NAME
FROM [AdventureWorks].[Person].[PersonPhone] pp
INNER JOIN Person.Person per ON per.BusinessEntityID=pp.BusinessEntityID

-- same as above but with convert to int, fails with (Conversion failed when converting the nvarchar value '1 11 500 5550110' to data type int.)
SELECT pp.BusinessEntityID, CONVERT(int, REPLACE(REPLACE(REPLACE(pp.PhoneNumber, '-', ''), '(', ''), ')', '')) AS PHONE_NR, pp.PhoneNumber, per.FirstName + per.LastName as FULL_NAME
FROM [AdventureWorks].[Person].[PersonPhone] pp
INNER JOIN Person.Person per ON per.BusinessEntityID=pp.BusinessEntityID

-- not all could be converted, then we use TRY_CONVERT, since the number can be bigger
SELECT pp.BusinessEntityID, TRY_CONVERT(int, REPLACE(REPLACE(REPLACE(pp.PhoneNumber, '-', ''), '(', ''), ')', '')) AS PHONE_NR, pp.PhoneNumber, per.FirstName + per.LastName as FULL_NAME
FROM [AdventureWorks].[Person].[PersonPhone] pp
INNER JOIN Person.Person per ON per.BusinessEntityID=pp.BusinessEntityID
-- BusinessEntityID	PHONE_NR	PhoneNumber	FULL_NAME
-- 285	NULL	926-555-0182	SyedAbbas
-- 293	NULL	747-555-0171	CatherineAbel
-- 295	NULL	334-555-0137	KimAbercrombie
-- 2170	NULL	919-555-0100	KimAbercrombie
-- 38	2085550114	208-555-0114	KimAbercrombie



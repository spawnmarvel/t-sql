-- Module 5: Sorting and Filtering Data

--Lesson 1:	Sorting Data
--Lesson 2:	Filtering Data with Predicates
--Lesson 3:	Filtering Data with TOP and OFFSET-FETCH
--Lesson 4:	Working with Unknown Values
--Lab:	Sorting and Filtering Data

-- ...you should add an ORDER BY clause to your SELECT statement

-- ORDER BY sorts rows in result fro presentation purpose
-- ORDER BY can refer to:
-- columns by name, alias or ordinal position (not recommended), columns not part of select list
-- Sort order ASC, DESC


-- Filtering Data in the WHERE Clause with Predicates
-- WHERE clause use predicate, must be expressed as logical conditions, only TRUE are accepted
-- Values of FALSE or UNKOWN filtered out
-- WHERE clause follows FROM, can 't see aliases declared in SELECT
-- Can be optimized by SQL server to use indexes
-- Data filtered server-side
-- Can reduce network traffic and client memory usage

-- Each column is independently for the other column
SELECT [customer_id]
      ,[first_name]
      ,[last_name]
      ,[city]
      ,[state]
      ,[zip_code]
  FROM [BikeStores].[sales].[customers]
  
  
 --
-- customer_id	first_name	last_name	city	state	zip_code
--1	Debra	Burks	Orchard Park	NY	14127
--2	Kasha	Todd	Campbell	CA	95008
--3	Tameka	Fisher	Redondo Beach	CA	90278
--4	Daryl	Spence	Uniondale	NY	11553

SELECT [customer_id]
      ,[first_name]
      ,[last_name]
      ,[city]
      ,[state]
      ,[zip_code]
  FROM [BikeStores].[sales].[customers]
  ORDER BY first_name
  
 --
 --customer_id	first_name	last_name	city	state	zip_code
--1174	Aaron	Knapp	Yonkers	NY	10701
--338	Abbey	Pugh	Forest Hills	NY	11375
--75	Abby	Gamble	Amityville	NY	11701
--1224	Abram	Copeland	Harlingen	TX	78552
--673	Adam	Henderson	Los Banos	CA	93635
--1085	Adam	Thornton	Central Islip	NY	11722


-- Lesson 2 Filtering Data with Predicates
-- WHERE clause syntax
WHERE <search_condition>
-- Typical
WHERE <column> <operator> <expression>
-- Example
SELECT contactname, country
FROM Sales.Customers
WHERE country = 'Spain'; 

-- WHERE orderdate > 'date'
-- WHERE orderdate >= 'date' AND orderdate < 'date'

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [order_id]
      ,[customer_id]
      ,[order_status]
      ,MONTH([order_date]) as order_month
	  ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  
  -- Predicates and operators 
  -- IN
  -- BETWEEN
  -- LIKE
  -- AND, OR NOT
  
-- TOP
-- Select TOP will have meaning if it is used with ORDER BY
-- Must use something that is unique.....not id, price (could be same price) etc

SELECT TOP (3) [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  ORDER BY shipped_date
  
 
 SELECT TOP (3)  WITH TIES 
	   [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  ORDER BY shipped_date
  
 SELECT TOP 5 PERCENT 
	   [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  ORDER BY shipped_date
  
 -- OFFSET-FETCH, extends TOP
 -- 20 records (TOP), OFFSET-FETCH = starting point
 
 OFFSET { integer_constant | offset_row_count_expression } { ROW | ROWS }
    [FETCH { FIRST | NEXT } {integer_constant | fetch_row_count_expression } { ROW | ROWS } ONLY]
	
	
 SELECT --TOP 3
	   [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  ORDER BY shipped_date
  OFFSET 0 ROWS
  FETCH NEXT 3 ROWS ONLY
 
 -- Logic behind paging data in chuncks
 
 SELECT --TOP 3
	   [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  ORDER BY shipped_date
  OFFSET 5 ROWS -- next 5 results with paging
  FETCH NEXT 3 ROWS ONLY


-- Lesson 4: Working with Unknown Values
-- Three-Valued Logic
-- TRUE or FALSE, but need to plan for NULL
-- Anything that has a NULL value will evaluate to UNKNOWN (-> FALSE)
-- HOW TO DEAL WITH NULL??

-- Differnt components of SQL Server handle null differently
-- Filters, ON, WHERE, HAVING filter out UNKNOWNS
-- CHECK constraints accepts UNKNOWNS
-- ORDER BY, DISTINCT trat NULL as equals

-- Testing for NULL
-- Use IS NULL or IS NOT NULL rather then = NULL or <> NULL

-- Returns false
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
  FROM [BikeStores].[sales].[staffs]
  WHERE manager_id = NULL


-- No rows returned
 
-- Returns TRUE

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
  FROM [BikeStores].[sales].[staffs]
  WHERE manager_id IS NULL
  
 
--first_name	last_name	email	phone	active	store_id	manager_id
--Fabiola	Jackson	fabiola.jackson@bikes.shop	(831) 555-5554	1	1	NULL


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [first_name]
      ,[last_name]
      ,[email]
      ,[phone]
      ,[active]
      ,[store_id]
      ,[manager_id]
  FROM [BikeStores].[sales].[staffs]
  WHERE manager_id IS NOT NULL
  
 --first_name	last_name	email	phone	active	store_id	manager_id
-- Mireya	Copeland	mireya.copeland@bikes.shop	(831) 555-5555	1	1	1
-- Genna	Serrano	genna.serrano@bikes.shop	(831) 555-5556	1	1	2
-- Virgie	Wiggins	virgie.wiggins@bikes.shop	(831) 555-5557	1	1	2
-- Jannette	David	jannette.david@bikes.shop	(516) 379-4444	1	2	1
-- Marcelene	Boyer	marcelene.boyer@bikes.shop	(516) 379-4445	1	2	5
-- Venita	Daniel	venita.daniel@bikes.shop	(516) 379-4446	1	2	5
-- Kali	Vargas	kali.vargas@bikes.shop	(972) 530-5555	1	3	1
-- Layla	Terrell	layla.terrell@bikes.shop	(972) 530-5556	1	3	7
-- Bernardine	Houston	bernardine.houston@bikes.shop	(972) 530-5557	1	3	7


 
  
  
 
 
 
  
  
 
 
 










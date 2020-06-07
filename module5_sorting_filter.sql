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







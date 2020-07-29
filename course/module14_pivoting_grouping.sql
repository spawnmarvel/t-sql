-- Pivoting and Grouping Sets
-- Advanced manipulation of data, PIVOT and UNPIVOT operators, change orientation of data from column to row-oriented, and back.
-- GROUPING SET subclause of GROUP BY for multiple groupings in one query, includes CUBE, ROLLUP subclause of GROUP BY to automate

-- What Is Pivoting
-- Rotating data row based to a column based
-- for example:
-- Category, Qty, Orderyear is rows based, but what if we want to view category and all years to the right?

-- Category, qty, Orderyear
-- Dairy products, 12, 2006
-- Grains/Cereals, 10, 2006
-- Dairy products, 12, 2006
-- [...]

-- Category, 2006, 2007, 2008
-- Dairy Products, 24, 12

-- Pivoting data in SQL Server rotates its display from a rows-based orientation to a columns-based orientation.

-- Elements of PIVOT
-- 1 Grouping which element gets a row (in the FROM input columns, PIVOT determine columns used for aggregation)
-- 2 Spreading, what will get a column, distinct values (comma-delimited list values for column headings, values must be in source data)
-- 3 Aggregation, SUM, MIN, MAX

-- Writing Queries with UNPIVOT
-- Rotating data from columns based to row based
-- Spread/split values from source row to one or more target row

-- Elements of unpivoting
-- Source columns
-- Name of assigned new val col
-- Name of assigned name col



-- Working with Grouping Sets
-- Subclause builds on GROUP BY
-- Multiple grouping can be in same query
-- Alternative to UNION ALL (with differnt GROUP BY)
-- To produce aggregates of multiple groupings in the same query

SELECT
      pro.Name, pro.ProductNumber, SUM(sa.OrderQty) AS  amount_sold
      
  FROM [AdventureWorks2012].[Production].[ProductSubcategory] cat
  INNER JOIN Production.Product pro ON pro.ProductSubcategoryID=cat.ProductSubcategoryID
  INNER JOIN Sales.SalesOrderDetail sa on sa.ProductID= pro.ProductID
  GROUP BY 
  GROUPING SETS((pro.Name), (pro.ProductNumber), ())

-- MANY NULLS
-- Name	ProductNumber	amount_sold
-- NULL	BB-7421	378
-- NULL	BB-9108	543
-- NULL	BC-M005	2025
-- [...]
-- Mountain-500 Silver, 48	NULL	457
-- LL Road Frame - Black, 52	NULL	1581
-- Water Bottle - 30 oz.	NULL	6815

-- CUBE and ROLLUP
-- Shortcut for defining grouping sets
-- CUBE will determine all possible combinations and output groupings

SELECT
      pro.Name, pro.ProductNumber, SUM(sa.OrderQty) AS  amount_sold
      
  FROM [AdventureWorks2012].[Production].[ProductSubcategory] cat
  INNER JOIN Production.Product pro ON pro.ProductSubcategoryID=cat.ProductSubcategoryID
  INNER JOIN Sales.SalesOrderDetail sa on sa.ProductID= pro.ProductID
  GROUP BY CUBE(pro.Name, pro.ProductNumber)

-- ROLL UP
-- Provides shorcut for defining grouping sets, 
-- Combinations assuming input col from hier

SELECT
      pro.Name, pro.ProductNumber, SUM(sa.OrderQty) AS  amount_sold
      
  FROM [AdventureWorks2012].[Production].[ProductSubcategory] cat
  INNER JOIN Production.Product pro ON pro.ProductSubcategoryID=cat.ProductSubcategoryID
  INNER JOIN Sales.SalesOrderDetail sa on sa.ProductID= pro.ProductID
  GROUP BY ROLLUP(pro.Name, pro.ProductNumber)




-- GROUPING_ID
-- Problem in identifying the source of each row
-- NULL could occure
-- Provids method for mark NULL as 1 or 0 to identify the grouping set to which a row belongs.

-- SQL Server will mark placeholder values with NULL if a row does not take part in a grouping set

SELECT
	  GROUPING_ID(pro.Name) as grpName,
	  GROUPING_ID(pro.ProductNumber) as grpNum,
      pro.Name, pro.ProductNumber, SUM(sa.OrderQty) AS  amount_sold
      
  FROM [AdventureWorks2012].[Production].[ProductSubcategory] cat
  INNER JOIN Production.Product pro ON pro.ProductSubcategoryID=cat.ProductSubcategoryID
  INNER JOIN Sales.SalesOrderDetail sa on sa.ProductID= pro.ProductID
  GROUP BY CUBE(pro.Name, pro.ProductNumber)
  ORDER BY pro.Name, pro.ProductNumber


-- grpName	grpNum	Name	ProductNumber	amount_sold
-- 1	1	NULL	NULL	274914
-- 1	0	NULL	BB-7421	378
-- 1	0	NULL	BB-9108	543
-- 1	0	NULL	BC-M005	2025
-- 1	0	NULL	BC-R205	1712
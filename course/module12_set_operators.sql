-- Lesson 1: Writing Queries with the UNION Operator
-- UNION, INTERSECTM EXCEPT operator
-- Write q to manupulate rows with APPLY, and combining them with
-- results of derived tabel/function

-- UNION operator
-- UNION and UNION all to add one set to another
-- 
-- Interactions between sets
-- Result of two q may be be manipulated further
-- Sets may be combined, compared, or operate against each other
-- Must have same num of comparable columns
-- ORDER BY, not allowed in input but can be used for result
-- Null is equal when comparing sets
-- SELECT Q1
-- SET OPERATOR
-- SELECT Q2
-- ORDER BY

-- UNION OPERATOR

  SELECT product_name,color
  FROM [test].[dbo].[ProductSource]
  
  SELECT product_name, color
  FROM [test].[dbo].[ProductTarget]

  -- both returns the same
  -- product_name	color
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown

SELECT product_name, color
FROM [test].[dbo].[ProductSource]
UNION
SELECT product_name, color
FROM dbo.ProductTarget

-- RETURNS the same result and duplicates is removed
-- product_name	color
-- bmw	black
-- fiat	blue
-- toyota	brown
-- volvo s90	red

-- remember that no sort order is guaranteed by set operators unless one is explicitly specified.
-- UNION combines all rows from each input set, and then filters out duplicates. 

-- UNION ALL
-- Returns a set with all rows from both input sets

SELECT product_name, color
FROM [test].[dbo].[ProductSource]
UNION ALL
SELECT product_name, color
FROM dbo.ProductTarget

-- product_name	color
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown
-- volvo s90	red
-- bmw	black
-- fiat	blue
-- toyota	brown

-- UNION ALL does not filter out duplicate rows. 


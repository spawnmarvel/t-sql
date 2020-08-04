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

--
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

-- Examining Stored Procedures
-- Statments stored in db

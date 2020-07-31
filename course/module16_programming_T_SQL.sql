-- Introducing T-SQL Batches
-- Collection of one or more statment for parsing, optimization and exe
-- Terminated with GO, within management studio, not with .Net programming
-- Boundaries for variabele scope
-- Some statments must be executed alone with the GO, CREATE FUNCTION, CREAET PROCEDURE, CREATE VIEW

-- Working with Batches
-- sql error for syntax, if wrong, the full batch will failed/rejected, but not the full script
-- Runtime fails, the batch could continue after fail, by default, if runtime on a line, the next may be excecuted
-- Good to include error handling, try and catch

-- Introducing T-SQL Variables
-- object references of valuesfor use later in batch
-- DECLARE word
-- Are always local to batch where they are declared and ends when batch ends
DECLARE @number_of_rows INT =12;

-- Working with Variables
DECLARE @number_of_rows INT =12;
-- Assign singel
DECLARE @i INT;
SET @i = 100;
-- Assign value using SELECT
-- the stament must return only one row


DECLARE @total INT = 0;
SELECT @total= COUNT(*) FROM [AdventureWorks].[Sales].[Customer]
SELECT @total
--
-- 19820

-- Working with Synonyms
-- is an alias/link to object stored
-- can point to tables, functions, procedure, views
-- if you take over a bunch of code, you can make a naming convention, a new one instead of make new sql statments
-- Reference for remote objects or alternative name, is if all were local
-- Use CREATE and DROP for manage


-- Demo
-- insert
INSERT INTO dbo.books (B_Name) VALUES('Lock, stock and rock');
INSERT INTO dbo.books (B_Name) VALUES('Sql server from A-Z');
GO

-- select
SELECT B_Name
FROM dbo.books;
GO
-- truncate
TRUNCATE TABLE dbo.books;
GO


-- vars for stored proc
USE AdventureWorks
DECLARE @check_y INT =2008;
DECLARE @check_c INT =30118;

EXEC [customer].[GetOrderInformationByYearAndCustomerID] @check_year = @check_y, @check_customer_id = @check_c;
go


-- assigning to variables
DECLARE @var AS INT =100;

DECLARE @var1 AS NVARCHAR(255);
SET @var1 = N'my string';
DECLARE @var2 AS NVARCHAR(255);
SELECT @var2 = Name FROM [AdventureWorks].[Sales].[Store] WHERE BusinessEntityID = 292;

SELECT @var AS v, @var1 AS v1, @var2 AS V2 
GO
--100	my string	Next-Door Bike Store

-- synonyms
-- 1 call proc
USE AdventureWorks

DECLARE @check_y INT =2008;
DECLARE @check_c INT =30118;

EXEC [customer].[GetOrderInformationByYearAndCustomerID] @check_year = @check_y, @check_customer_id = @check_c;
go

-- 2 switch db
USE tempdb
GO

-- 3 create synonym
CREATE SYNONYM dbo.tempOrder FOR Adventureworks.customer.GetOrderInformationByYearAndCustomerID;
EXEC dbo.tempOrder @check_year =2008, @check_customer_id = 30118;
go


--view synonyms
SELECT * FROM sys.synonyms
GO
-- drop
DROP SYNONYM tempOrder






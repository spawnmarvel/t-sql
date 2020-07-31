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
DECLARE @check_y INT =2008;
DECLARE @check_c INT =30118;

EXEC customer.GetOrderInformationByYearAndCustomerID @check_year = check_y,@check_customer_id = check_c;



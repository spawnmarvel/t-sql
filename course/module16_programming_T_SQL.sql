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

-- 2 switch db to temp
USE tempdb
GO

-- 3 create synonym
CREATE SYNONYM dbo.tempOrder FOR Adventureworks.customer.GetOrderInformationByYearAndCustomerID;
EXEC dbo.tempOrder @check_year =2008, @check_customer_id = 30118;
GO


--view synonyms
SELECT * FROM sys.synonyms
GO
-- drop
DROP SYNONYM tempOrder

-- Understanding T-SQL Control-of-Flow Language
-- Used in batches, proc and statments
-- Control of the flow
-- Includes:
-- IF..ELSE, BEGIN..END, WHILE RETURN, BREAK, CONTINUE, WAITFOR

-- IF
DECLARE @var AS NVARCHAR(255);
SELECT @var=  [Title] FROM [AdventureWorks].[Person].[Person]
IF @var IS NULL
	BEGIN
		PRINT 'IS NULL, NOT EXISTING';
	END




-- IF ELSE
DECLARE @var AS NVARCHAR(255);
SELECT @var=  [Title] FROM [AdventureWorks].[Person].[Person]
IF @var IS NULL
	BEGIN
		PRINT 'IS NULL, NOT EXISTING';
	END
ELSE
	PRINT 'NOT NULL';
GO

-- IF
IF EXISTS (SELECT Title FROM [AdventureWorks].[Person].[Person] WHERE Title like 'M%')
BEGIN
	PRINT 'There is a title that starts with M'
END

-- WHILE
DECLARE @max_price AS INT = 200;
WHILE @max_price > 100
	BEGIN
	    PRINT @max_price;
	    SET @max_price -=1
	END
-- 200
-- 199
-- 198

-- WHILE with data
DECLARE @place_id AS INT = 1;
DECLARE @territory_bonus as INT;
WHILE @place_id <= 10
	BEGIN
	    SELECT @territory_bonus = Bonus FROM [AdventureWorks].[Sales].[SalesPerson] WHERE TerritoryID=@place_id;
	    PRINT @territory_bonus;
	    PRINT @place_id;
	    SET @place_id +=1;
	END

-- 3900
-- 1
-- 4100
-- 2
-- 2500
-- 3

--
DECLARE @place_id AS INT = 1;
DECLARE @territory_bonus as INT;
WHILE @place_id <= 10
	BEGIN
		SELECT @territory_bonus = Bonus FROM [AdventureWorks].[Sales].[SalesPerson] WHERE TerritoryID=@place_id;
		--PRINT @territory_bonus
		IF @territory_bonus > 4000
			BEGIN
				PRINT 'Big bonus for territory ' + CAST(@place_id as varchar(255)) + CAST(@territory_bonus AS VARCHAR(30));
			END
	SET @place_id +=1;
	END


-- 
DECLARE

@i int = 8,

@result nvarchar(20);

IF @i < 5

SET @result = N'Less than 5'

ELSE IF @i <= 10

SET @result = N'Between 5 and 10'

ELSE if @i > 10

SET @result = N'More than 10'

ELSE

SET @result = N'Unknown';

SELECT @result AS result;
















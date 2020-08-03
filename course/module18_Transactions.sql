-- Defining Transactions
-- Transfer to different account in bank
-- One transaction - remove money from account
-- One transaction - add money to different account

-- Many operations as on atomic unit, either all succeed or all fail
-- Two ways
-- Autoatomic, indivudual stm, UPDATE, INSERT and DELETE (typically they are succsess or auto rolled back)
-- Explicit, The use of TCL cmd, begin, commit, roll back, TCL subset of T-SQL

-- The Need for Transactions: Issues with Batches
-- Code with no transaction
USE [test]
GO

BEGIN TRY
	INSERT INTO dbo.ProductSource (product_name,product_number,color)
		VALUES ('Candybar',11,'Light green');-- this will work
	INSERT INTO dbo.ProductTarget(product_number,color)
		VALUES (11,'light green')-- this will fail since a paramter(product_name) is missing that cannot be null
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS error_num, ERROR_MESSAGE() AS error_msg;
END CATCH

-- 
-- 515	Cannot insert the value NULL into column 'product_name', table 'test.dbo.ProductTarget'; column does not allow nulls. INSERT fails.
-- Here the first insert succeed's but the second failed, no logic for partial success

-- Transactions Extend Batches
-- cmd blocks of code that must fail or succeed together
-- can roll back or undo if not succeed


-- DATA BEFORE
SELECT * FROM [test].[dbo].[ProductSource]
-- product_id	product_name	product_number	color
-- 1	volvo s90	22	red
-- 2	bmw	23	black
-- 3	fiat	24	blue
-- 4	toyota	25	brown
-- 5	Candy	10	Green

-- Transaction that will fail
USE [test]
GO

BEGIN TRY
	BEGIN TRANSACTION
	    INSERT INTO dbo.ProductSource (product_name,product_number,color)
		    VALUES ('Lollipop',20,'blue');-- this will work
	    INSERT INTO dbo.ProductTarget(product_number,color)
		    VALUES (20,'blue')-- this will fail since a paramter (product_name) is missing that cannot be null, so the hole transation will be rolled back
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS error_num, ERROR_MESSAGE() AS error_msg;
	ROLLBACK TRANSACTION;
END CATCH
-- 515	Cannot insert the value NULL into column 'product_name', table 'test.dbo.ProductTarget'; column does not allow nulls. INSERT fails.

-- Transaction that will succeed
USE [test]
GO

BEGIN TRY
	BEGIN TRANSACTION -- BEGIN TRANSACTION, will hold locks even for reading

	    INSERT INTO dbo.ProductSource (product_name,product_number,color)
		    VALUES ('Lollipop',20,'blue');-- this will work
	    INSERT INTO dbo.ProductTarget(product_name, product_number,color)
		    VALUES ('Lollipop',20,'blue')-- this will work
	    COMMIT TRANSACTION -- ensure modifications and releases all resources 
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS error_num, ERROR_MESSAGE() AS error_msg;
	ROLLBACK TRANSACTION;
END CATCH

-- (1 row affected)
-- (1 row affected)


-- BEGIN TRANSACTION
-- Start point, last until COMMIT stm is issued, ROLLBACK or the connection broken

-- COMMIT TRANSACTION
-- ensures that all modifications are permanent
-- free up resources, locks, read and more

-- ROLLBACK TRANSACTION
-- undo all modifications
-- before rollback test state if you want, XACT_STATE

-- Using XACT_ABORT (not som important now)
-- For situations in which you are not using TRY/CATCH blocks
-- to roll back use ROLLBACK in handling of error or enable XACT_ABORT
-- XACT_ABORT automatic roll back of current, if runtime error
-- IF SET XACT_ABORT is ON, the full transaction is terminated, then rolled back (if not it is in the TRY block)
-- SET XACT_ABORT OFF is default
-- Session setting
-- Change with
SET XACT_ABORT ON;
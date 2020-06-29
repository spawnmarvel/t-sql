-- Lesson 1: Adding Data to Tables

USE [test]
GO

INSERT INTO [dbo].[students] (s_name,s_age)VALUES('Steven John', 30)
GO

-- multirow

USE [test]
GO

INSERT INTO [dbo].[students] (s_name,s_age)
	VALUES
	('Steven John', 30),
	('John Doe', 32),
	('Lisa Doe', 32);
GO





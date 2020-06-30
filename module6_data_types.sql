-- Lesson 1
-- Introducing SQL Server Data Types

-- Numeric Data Types
-- Data type, Range, Storage
-- tinyint, 0-255, 1
-- smallint, -32,768, 32,768, 2
-- int, -2,147,486,648, 2,147,486,648, 4
-- big int, +/- 9 quintillion, 8
-- bit, 1, 0 or NULL, 1
-- decimal/numeric -10(38), 10(38), 5-17
-- money, -922,337,203,685,477.5808 to -922,337,203,685,477.5808, 8
-- smallmoney, -214,748,3648 to -214,748,3648, 4



-- Why not use bigint for all tinyints , due to storage.
-- If status for product, 5 values, 1,2, 3, 4, 5 then use tinyint
-- If values exceed the change, must think about storage and types

-- Binary string data types allow a developer to store binary information, such as serialized files, images, byte streams, 
-- and other specialized data.
-- Binary String Data Types
-- Data type, Range, Storage(Bytes)
-- binary(n), 1 to 8000 bytes, n bytes


SELECT CAST(1234 AS BINARY(4)) as result

-- 0x000004D2

--

-- Other data types
-- xml, The advantage of the xml data type over storing XML in a character data type is that the xml data type allows XML nodes and attributes to be queried within a T-SQL query using XQuery expressions
-- uniqueidentifier, GUID, be generated within SQL Server by using the NEWID() 
SELECT NEWID() as guid_from_new_id
--1DD193F3-F303-4FFB-9616-34344E555E96

-- hierarchyid
-- rowversion
-- geometry
-- geography
-- sql_variant
-- table


-- Data Type Precedence
-- Determines whicg data type will be chosen when expression of different types are combined
-- Operations have to be with like data types
-- Convert = CAST
-- When combining or comparing two expressions with different data types, the one lower on this list will be converted to the type that is higher
-- Partial list ranked according to precedence
-- xml, datetime2, date, time, decimal, int, tinyint, nvarchar, char

DECLARE @my_tiny_int AS TINYINT =25
DECLARE @my_int AS INT = 9999;
SELECT @my_tiny_int;
SELECT @my_int;
SELECT @my_tiny_int + @my_int;

-- When are Data Types Converted?

-- Data type cenversion scenarios
-- When data is moved, compared to or combined with other data
-- During assignment of variable

-- Implicit conversion
-- When comparing data of one data type to another
-- Transparent to the user
-- WHERE <column of smallint type> = <value of int type>

-- Explicit conversion
-- Use CAST or CONVERT functions

-- CAST(unitprice AS INT)
--
-- Implicit conversion integer data types
DECLARE @my_tiny_int AS TINYINT =25
DECLARE @my_int AS INT = 9999;
SELECT @my_tiny_int + @my_int
-- Result
-- 10024
-- Implicit conversion integer and char
DECLARE @my_char AS char(5)='6';
DECLARE @my_int2 AS int = 1;
SELECT @my_char + @my_int2
-- Result
-- 7
-- SQL Server will automatically attempt to perform an implicit conversion from a lower-precedence data type to a higher-precedence data type. 
-- Failing
DECLARE @my_char AS char(5) = 'six';
DECLARE @my_int AS INT = 1;
SELECT @my_char + @my_int;

-- Msg 245, Level 16, State 1, Line 4
-- Conversion failed when converting the varchar value 'six  ' to data type int.

-- Completion time: 2020-06-28T20:14:46.6610969+02:00

-- Lesson 2 Character Data Types
-- SQL Server support two kinds of character data as fixed-width of variable-width data
-- ASCI, 1 byte pr character system
-- UNICODE, 2 bute pr character system
-- Single byte:
-- Char, varchar
-- one byte stored per character. only 256 possible characters, limits langauage support

-- Multi byte:
-- nchar, nvarchare
-- Multiple bytes stored per characters (usullay 2 bytes , but sometimes 4)
-- data type, fixed width, variable with, single byte charactes, multi byte characters
-- char,yes,no,yes,no
-- nchhar, yes, no, no, yes
-- varchar, no, yes, yes, no
-- nvarchar, no, yes, no, yes

-- Varchar and nvarchar data types support the storeage of very long strings, with max
-- CHAR(n)--1-8000 characters, storage n bytes, padded
-- NCHAR(n)--1-4000 characters, storage 2*n bytes, padded
-- VARCHAR(n)--1-8000 characters, storage actual length + 2 bytes
-- NVARCHAR(n)--1-4000 characters, storage actual length + 2 bytes
-- VARCHAR(max) -- up to 2 GB, storage actual length + 2 bytes
-- NVARCHAR(max) -- up to 2 GB, storage actual length + 2 bytes

-- Single-byte character, marked 'SQL server'
-- Multi-byte character, marked prefix N, N'SQL Server'

-- Collation
-- Is a collection of properties for character data
-- Character set, sort order, case sensitivity, accent sensitivity
-- When quering, collation is important for comparison
-- Is the database case-sensitive?

USE BikeStores
SELECT staff_id, last_name
FROM sales.staffs
WHERE last_name COLLATE Latin1_General_CS_AS = 'David';
-- ADD COLLATE caluse to control collation comparison


-- This has been set, and in most cases we do not care about this.


-- String Concatenation
USE BikeStores
SELECT staff_id, CONCAT(first_name,' , ' + last_name) as full_name
FROM sales.staffs
WHERE staff_id <3
-- staff_id	full_name
-- 1	Fabiola , Jackson
-- 2	Mireya , Copeland
-- if first name or last was null, CONCAT converts NULL to empty string, better then use +

-- The LIKE Predicate
-- % (Percent), LIKE N'Sand%'
-- _ (Underscore), LIKE N'_a%'
-- [<List of characters>], LIKE N'[DEF]%', 
-- [<Character> - <character>], LIKE N'[DEF]%' 
-- ESCAPE

-- return all f
SELECT staff_id,CONCAT(first_name, '; ' + last_name) as full_name
FROM [BikeStores].[sales].[staffs]
WHERE first_name like 'F%';
-- staff_id	full_name
-- 1	Fabiola; Jackson

-- return second char is i
SELECT staff_id,CONCAT(first_name, '; ' + last_name) as full_name
FROM [BikeStores].[sales].[staffs]
WHERE first_name like '_I%';
-- staff_id	full_name
-- 2	Mireya; Copeland
-- 4	Virgie; Wiggins
-- retunr any strings that starts with f, i or b
SELECT staff_id,CONCAT(first_name, '; ' + last_name) as full_name
FROM [BikeStores].[sales].[staffs]
WHERE first_name like '[FIB]%';
-- staff_id	full_name
-- 1	Fabiola; Jackson
-- 10	Bernardine; Houston

-- Examples:
-- Default collation is case insensitive
SELECT  customer_id,first_name, last_name
FROM [BikeStores].[sales].[customers]
WHERE last_name   = 'Burks' -- = 'burks' works either way

SELECT  customer_id,first_name, last_name
FROM [BikeStores].[sales].[customers]
WHERE last_name COLLATE Latin1_GENERAL_CS_AS  = 'Burks'--works, but = 'burks' does not work

-- CONCAT and +
SELECT  customer_id, first_name + ' ' + last_name as name_
FROM [BikeStores].[sales].[customers]

SELECT  customer_id, CONCAT(first_name, ' ', last_name)as name_
FROM [BikeStores].[sales].[customers]

-- FORMAT—allows you to format an input value to a character string based on a .NET format string, with an optional culture parameter. 
DECLARE @m money = 120.595
SELECT @m AS unformatted_value,
FORMAT(@m, 'C', 'zh-cn') AS zh_cn_currency,
FORMAT(@m, 'C', 'en-us') AS en_us_currency,
FORMAT(@m, 'C', 'de-de') AS de_de_currency;
-- unformatted_value	zh_cn_currency	en_us_currency	de_de_currency
-- 120.595	¥120.60	$120.60	120,60 €

-- SUBSTRING
SELECT SUBSTRING('This is not a company',14, 8) as result;
-- company

-- LEN, rm whitespace
SELECT LEN('This is not a company     ') as result;
-- 21
--DATALENGTH, num of bytes
SELECT DATALENGTH('This is not a company     ') as result;
-- 26

-- CHARINDEX
SELECT CHARINDEX('not','This is not a company') as result;
-- 9

-- REPLACE
SELECT REPLACE('This is not a company', 'not', 'good') as result;
-- This is good a company

SELECT UPPER('This is not a company') as result;
-- THIS IS NOT A COMPANY
SELECT LOWER('This is not a company') as result;

SELECT LEFT('Microsoft SQL Server',9) AS left_example,
RIGHT('Microsoft SQL Server',6) AS right_example;
-- left_example	right_example
-- Microsoft	Server

SELECT first_name
FROM sales.customers
WHERE state like 'C%'

SELECT first_name
FROM sales.customers
WHERE state like N'C%'


-- The "N" prefix stands for National Language in the SQL-92 standard, and is used for representing 
-- unicode characters. Any time you pass Unicode data to SQL Server you must prefix the 
-- Unicode string with N . It is used when the type is from NVARCHAR , NCHAR or NTEXT

-- Lesson 3
-- Working with Date and Time Data
-- Data type, Storage bytes, Date Range (Gregorian Calender), Accuracy, Recommended Entry Format
-- datetime, 8, jan 1 1753 to dec 31 9999, round .000,003 or .007, YYYYMMDD hh:mm:ss[.mmm]
-- smalldatetime, 4,jan 1 1900 to june 6 2079, 1 min, YYYYMMDD hh:mm:ss[.mmm]
-- datetime2, 6-8,jan 1 0001 to dec 31 9999, 100 nanoseconds, YYYYMMDD hh:mm:ss[.nnnnnnn]
-- date, 3,jan 1 0001 to dec 31 9999, 1 day, YYYY-MM-DD
-- time, 3-5, na time only, 100 nanoseconds, hh:mm:ss[.nnnnnnn]
-- datetimeoffset,8-10, 6-8,jan 1 0001 to dec 31 9999, 100 nanoseconds, YYYY-MM-DDThh:mm:ss[.nnnnnnn][+|-][hh:mm], offset = timezone

-- Store date and time together, use datetime2 due to more accuracy


-- Entering Date and Time Data Types Using Strings
-- Best practice
-- Use character strings to express date and time values
-- Use language-neutral formats
-- ISO format, it is universal
-- Not use localtion or cultural format

SELECT [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  WHERE  order_date > '20161231'-- 4 year, 2 month, 2 day, universal like this, standard string
-- ca use time here also

SELECT GETDATE()
-- 2020-06-29 20:12:55.280

-- Working Separately with Date and Time
-- If only date is specified
DECLARE @DateOnly AS datetime2 = '20201212';-- this will be time 00:00:00, since no time is given
SELECT @DateOnly as RESULT;
-- 2020-12-12 00:00:00.0000000

-- If only time is specified
DECLARE @time AS time = '12:34:15';-- this will be time JAN 01 1900, since no date is given
SELECT CAST(@time as datetime2) as RESULT;
-- 1900-01-01 12:34:15.0000000

-- Querying Date and Time Values
-- A bit more warning, be careful

SELECT [order_status]
      ,[order_date]
      ,[required_date]
      ,[shipped_date]
      ,[store_id]
      ,[staff_id]
  FROM [BikeStores].[sales].[orders]
  WHERE order_date = '20070825' -- This will time 00:00:00
-- When querying date and time data types, you might need to consider both the date and time portions of the data to return the results you expect. 

-- Date and Time Functions

-- SELECT GETDATE() AS gt; -- 2020-06-29 20:27:10.180
-- SELECT CURRENT_TIMESTAMP as ct; -- 2020-06-29 20:27:10.180
-- SELECT GETUTCDATE() as gud; -- 2020-06-29 18:27:10.180
-- SELECT SYSDATETIME() as sdt; -- 2020-06-29 20:27:10.1808310
-- SELECT SYSUTCDATETIME() as sudt; -- 2020-06-29 18:27:10.1808310
-- SELECT SYSDATETIMEOFFSET() as sudto; -- 2020-06-29 20:27:10.1808310 +02:00
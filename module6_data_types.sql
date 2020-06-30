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

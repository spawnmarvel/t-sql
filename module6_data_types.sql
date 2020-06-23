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


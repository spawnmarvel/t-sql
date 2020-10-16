# t-sql
Querying Data with Transact-SQL

[docs.microsoft.com] https://docs.microsoft.com/nb-no/sql/?view=sql-server-ver15

[T-SQL] https://www.tsql.info/

[ANSI SQL-92] https://en.wikipedia.org/wiki/SQL-92

[Markdown Github] https://guides.github.com/features/mastering-markdown/

[Supported Culture Codes] https://docs.microsoft.com/en-us/bingmaps/rest-services/common-parameters-and-types/supported-culture-codes

[In order to allow access to SQL Server instance, we have to enable TCP/IP protocol which is not enabled by default] https://www.sqlshack.com/how-to-connect-to-a-remote-sql-server/

### Tips
* Show line numbers. Tools-> Options->Text Editor->Transact-SQL->General
* Show map mode. Tools-> Options->Text Editor->Transact-SQL->Scroll Bars

### Code
##### The bikestores database
[data bikestore] https://www.sqlservertutorial.net/load-sample-database/



#### Schema 
A SQL database contains multiple objects such as tables, views, stored procedures, functions, indexes, triggers. We define SQL Schema as a logical collection of database objects. A user owns that owns the schema is known as schema owner. It is a useful mechanism to segregate database objects for different applications, access rights, managing security administration of databases. We do not have any restrictions on the number of objects in a schema.
\
* We can quickly transfer ownership of a SQL schema to another user
* We can share a schema among multiple users
* It allows you to move database objects among the schemas
* We get more control over database objects access and security


If we do not define any default schema for a user, SQL Server assumes dbo as the default schema. We can verify the default schema for a user using the following system function: 
If no schema is specified, it automatically uses dbo schema for the table because the current user default schema is dbo

``` sql
--SELECT SCHEMA_NAME();
--USE test -- can create schema in spesific database
--go

CREATE TABLE cars( --is stored in dbo
 ID   INT IDENTITY(1, 1), 
 Name VARCHAR(20)
);
go

CREATE SCHEMA factory;
go
CREATE TABLE [factory].[cars] -- is stored in factory
(ID   INT IDENTITY(1, 1), 
 Name VARCHAR(20)
);

-- NEWID() and UNIQUEIDENTIFIER
USE test
GO
CREATE TABLE books2( --is stored in dbo
 B_ID INT IDENTITY(1,1) PRIMARY KEY,
 B_GUID UNIQUEIDENTIFIER NOT NULL  DEFAULT NEWID(),
 B_Name VARCHAR(20)
);
go

INSERT INTO books2 (B_Name) VALUES
('Moby Dick'),
('1000 days')

SELECT * FROM books2
````
##### A SQL schema is a useful database concept. It helps us to create a logical grouping of objects such as tables, stored procedures, and functions. 

##### IDENTITY
##### IDENTITY [ (seed , increment) ]  
Seed, Is the value that is used for the very first row loaded into the table.\
increment, Is the incremental value that is added to the identity value of the previous row that was loaded.
##### Create (first tables):
``` sql
-- create schemas
CREATE SCHEMA production;
go

-- create tables
CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);
CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);
CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);
```
##### Insert (first tables):
``` sql
use BikeStores;

SET IDENTITY_INSERT production.brands ON;  -- whenever you want to manually insert a value for your identity column

INSERT INTO production.brands(brand_id,brand_name) VALUES(1,'Electra')
INSERT INTO production.brands(brand_id,brand_name) VALUES(2,'Haro')
INSERT INTO production.brands(brand_id,brand_name) VALUES(3,'Heller')
-- and more [...]

SET IDENTITY_INSERT production.brands OFF;  -- and turn it off again

-- or like this 
INSERT INTO production.brands(brand_name) VALUES('Air')
INSERT INTO production.brands(brand_name) VALUES('Gas')
-- and more [...]

SET IDENTITY_INSERT production.categories OFF;  
```
#### Data type
varchar: Variable-length, non-Unicode character data. The database collation determines which code page the data is stored using.\
nvarchar: Variable-length Unicode character data. Dependent on the database collation for comparisons.
##### Case
``` sql
use BikeStores;
SELECT p.category_id, p.product_name,
	CASE
		WHEN p.category_id = 1 THEN 'Beverages'
		WHEN p.category_id = 2 THEN 'Condiments'
		WHEN p.category_id = 3 THEN 'Confections'
		WHEN p.category_id = 4 THEN 'Dairy Products'
		WHEN p.category_id = 5 THEN 'Grains/Cereals'
		WHEN p.category_id = 6 THEN 'Meat/Poultry'
		WHEN p.category_id = 7 THEN 'Produce'
		WHEN p.category_id = 8 THEN 'Seafood'
		ELSE 'Other'
	END AS categoryname,

	CASE
		WHEN p.category_id IN (1, 7, 8) THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign

FROM production.products AS p;

-- 
SELECT 
	CASE WHEN br.brand_name = 'Electra' THEN 'Electra main'
	ELSE br.brand_name
	END AS friendly_name,

	CASE WHEN br.brand_id < 4 THEN 'Newest'
	ELSE 'Old'
	END AS category_simple,

	br.brand_id, brand_name

FROM [Bikestores].[production].[brands] br
```
##### Join

Consider the following tables:
``` sql


USE test;
GO
CREATE TABLE students(
	s_id int IDENTITY(1,1) PRIMARY KEY,
	s_name varchar(100) NOT NULL,
    s_age tinyint NOT NULL
	);
GO
CREATE TABLE fee(
	f_id int IDENTITY(1,1) PRIMARY KEY,
	s_id int NOT NULL,
	f_course varchar(30) NULL,
	f_paid int NULL
	);

GO

ALTER TABLE fee ADD FOREIGN KEY(s_id)
REFERENCES students (s_id)
```
##### Data students
* s_id	s_name	s_age
* 1	Jim Town	30
* 2	Tim Door	29
* 3	Lisa Fresh	28
* 4	Ida Back	28

##### Data fee
* f_id	s_id	f_course	f_paid
* 1	1	IT	200
* 2	3	IT	200

##### INNER JOIN

``` sql
SELECT st.s_id
      ,st.s_name
      ,st.s_age
	  ,fe.f_course
	  ,fe.f_paid
  FROM students AS st
  INNER JOIN fee AS fe ON st.s_id = fe.s_id
```
Data, We can tell the students who have paid their fee (returns rows from two tables when a match is found)
* s_id	s_name	s_age	s_id	f_course	f_paid
* 1	Jim Town	30	1	IT	200
* 3	Lisa Fresh	28	3	IT	200
 

##### LEFT JOIN

``` sql
SELECT st.s_id
      ,st.s_name
      ,st.s_age
	  ,fe.f_course
	  ,fe.f_paid
  FROM students AS st
  LEFT JOIN fee AS fe ON st.s_id = fe.s_id
  --WHERE fe.f_paid IS NOT NULL
```

Data, This type of join will return all rows from the left-hand table plus records in the right-hand table with matching values
returns all rows from the left table, even if there are no matches with the right table

* s_id	s_name	s_age	f_course	f_paid
* 1	Jim Town	30	1	IT	200
* 2	Tim Door	29	NULL	NULL	NULL
* 3	Lisa Fresh	28	3	IT	200
* 4	Ida Back	28	NULL	NULL	NULL



##### RIGHT JOIN

``` sql
SELECT st.s_id
      ,st.s_name
      ,st.s_age
	  ,fe.f_course
	  ,fe.f_paid
  FROM students AS st
  RIGHT JOIN fee AS fe ON st.s_id = fe.s_id
  --WHERE fe.f_paid IS NOT NULL
```

Data,This type of join returns all rows from the right-hand table and only those with matching values in the left-hand table
returns all rows from the right table, even if there are no matches with the left table
* s_id	s_name	s_age	f_course	f_paid
* 1	Jim Town	30	1	IT	200
* 3	Lisa Fresh	28	3	IT	200



##### FULL JOIN

``` sql
SELECT st.s_id
      ,st.s_name
      ,st.s_age
	  ,fe.f_course
	  ,fe.f_paid
  FROM students AS st
  FULL JOIN fee AS fe ON st.s_id = fe.s_id
  --WHERE fe.f_paid IS NOT NULL
```
Data,This type of join returns all rows from both tables with NULL values where the JOIN condition is not true
returns all records when there is a match in left (table1) or right (table2) table records

* s_id	s_name	s_age	s_id	f_course	f_paid
* 1	Jim Town	30	1	IT	200
* 2	Tim Door	29	NULL	NULL	NULL
* 3	Lisa Fresh	28	3	IT	200
* 4	Ida Back	28	NULL	NULL	NULL


##### View
``` sql
use BikeStores;
GO
CREATE VIEW ProductAndBrands
AS
SELECT pr.[product_id]
      ,pr.[product_name]
	  ,br.brand_name
	  ,pr.[brand_id]
	  ,pr.[category_id]
	  ,ca.category_name
      ,pr.[model_year]
      ,pr.[list_price]
  FROM [BikeStores].[production].[products] pr
  INNER JOIN production.categories ca ON ca.category_id=pr.category_id
  INNER JOIN production.brands br on br.brand_id=pr.brand_id
-- Alter it
USE BikeStores;
GO
ALTER VIEW ProductAndBrands
AS
SELECT pr.[product_id]
      ,pr.[product_name]
	  ,br.brand_name
	  ,ca.category_name
      ,pr.[model_year]
      ,pr.[list_price]
	  -- rm some columns
  FROM [BikeStores].[production].[products] pr
  INNER JOIN production.categories ca ON ca.category_id=pr.category_id
  INNER JOIN production.brands br on br.brand_id=pr.brand_id
```

##### Procedure
``` sql
use BikeStores;
GO
CREATE PROCEDURE ProductAndBrandInfo
AS
SELECT pr.[product_id]
      ,pr.[product_name]
	  ,br.brand_name
	  ,pr.[brand_id]
	  ,pr.[category_id]
	  ,ca.category_name
      ,pr.[model_year]
      ,pr.[list_price]
  FROM [BikeStores].[production].[products] pr
  INNER JOIN production.categories ca ON ca.category_id=pr.category_id
  INNER JOIN production.brands br on br.brand_id=pr.brand_id
--
EXEC dbo.ProductAndBrandInfo
--
use BikeStores;
GO
CREATE PROCEDURE ProductAndBrandInfoYear (@check_year AS INT) -- with param
AS
SELECT pr.[product_id]
      ,pr.[product_name]
	  ,br.brand_name
	  ,pr.[brand_id]
	  ,pr.[category_id]
	  ,ca.category_name
      ,pr.[model_year]
      ,pr.[list_price]
  FROM [BikeStores].[production].[products] pr
  INNER JOIN production.categories ca ON ca.category_id=pr.category_id
  INNER JOIN production.brands br on br.brand_id=pr.brand_id
  WHERE pr.model_year= @check_year -- param
--
EXEC dbo.ProductAndBrandInfoYear @check_year=2017;

--Alter it
use BikeStores;
GO
ALTER PROCEDURE ProductAndBrandInfoYear (@check_year AS SMALLINT, @list_price_greather_than as DECIMAL) -- with 2 param
AS
SELECT pr.[product_id]
      ,pr.[product_name]
	  ,br.brand_name
	  ,pr.[brand_id]
	  ,pr.[category_id]
	  ,ca.category_name
      ,pr.[model_year]
      ,pr.[list_price]
  FROM [BikeStores].[production].[products] pr
  INNER JOIN production.categories ca ON ca.category_id=pr.category_id
  INNER JOIN production.brands br on br.brand_id=pr.brand_id
  WHERE pr.model_year= @check_year -- param
  AND pr.list_price > @list_price_greather_than -- param
  ORDER BY pr.list_price DESC
--
EXEC dbo.ProductAndBrandInfoYear @check_year=2016, @list_price_greather_than=1000;
```

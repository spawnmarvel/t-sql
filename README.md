# t-sql
Querying Data with Transact-SQL

[docs.microsoft.com] https://docs.microsoft.com/nb-no/sql/?view=sql-server-ver15

[ANSI SQL-92] https://en.wikipedia.org/wiki/SQL-92

[Markdown Github] https://guides.github.com/features/mastering-markdown/

## Tips
* Show line numbers. Tools-> Options->Text Editor->Transact-SQL->General
* Show map mode. Tools-> Options->Text Editor->Transact-SQL->Scroll Bars

### Code
#### The bikestores database
[data bikestore] https://www.sqlservertutorial.net/load-sample-database/

#### Create (first tables):
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
#### Insert (first tables):
``` sql
use BikeStores;

SET IDENTITY_INSERT production.brands ON;  

INSERT INTO production.brands(brand_id,brand_name) VALUES(1,'Electra')
INSERT INTO production.brands(brand_id,brand_name) VALUES(2,'Haro')
INSERT INTO production.brands(brand_id,brand_name) VALUES(3,'Heller')
-- and more [...]

SET IDENTITY_INSERT production.brands OFF;  

SET IDENTITY_INSERT production.categories ON;  
INSERT INTO production.categories(category_id,category_name) VALUES(1,'Children Bicycles')
INSERT INTO production.categories(category_id,category_name) VALUES(2,'Comfort Bicycles')
-- and more [...]

SET IDENTITY_INSERT production.categories OFF;  
```
#### Case
``` sql
-- CASE
SELECT p.categoryid, p.productname,
	CASE
		WHEN p.categoryid = 1 THEN 'Beverages'
		WHEN p.categoryid = 2 THEN 'Condiments'
		WHEN p.categoryid = 3 THEN 'Confections'
		WHEN p.categoryid = 4 THEN 'Dairy Products'
		WHEN p.categoryid = 5 THEN 'Grains/Cereals'
		WHEN p.categoryid = 6 THEN 'Meat/Poultry'
		WHEN p.categoryid = 7 THEN 'Produce'
		WHEN p.categoryid = 8 THEN 'Seafood'
		ELSE 'Other'
	END AS categoryname,

	CASE
		WHEN p.categoryid IN (1, 7, 8) THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign

FROM Production.Products AS p;
```
#### Join

#### Consider the following tables:
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
#### DATA Students
* s_id	s_name	s_age
* 1	Jim Town	30
* 2	Tim Door	29
* 3	Lisa Fresh	28
* 4	Ida Back	28

#### DATA fee
* f_id	s_id	f_course	f_paid
* 1	1	IT	200
* 2	3	IT	200

#### INNER JOIN

``` sql
SELECT st.s_id
      ,st.s_name
      ,st.s_age
	  ,fe.f_course
	  ,fe.f_paid
  FROM students AS st
  INNER JOIN fee AS fe ON st.s_id = fe.s_id
```
#### Data, We can tell the students who have paid their fee

* s_id	s_name	s_age	f_course	f_paid
* 1	Jim Town	30	IT	200
* 3	Lisa Fresh	28	IT	200

#### LEFT JOIN

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

#### Data, This type of join will return all rows from the left-hand table plus records in the right-hand table with matching values

* s_id	s_name	s_age	f_course	f_paid
* 1	Jim Town	30	IT	200
* 2	Tim Door	29	NULL	NULL
* 3	Lisa Fresh	28	IT	200
* 4	Ida Back	28	NULL	NULL


#### RIGHT JOIN

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

#### Data,This type of join returns all rows from the right-hand table and only those with matching values in the left-hand table

* s_id	s_name	s_age	f_course	f_paid
* 1	Jim Town	30	IT	200
* 3	Lisa Fresh	28	IT	200






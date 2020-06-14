# t-sql
OD20761C - Querying Data with Transact-SQL

[OD20761C] https://www.bouvet.no/kurs/kategorier/microsoft/sql-server/20761-querying-data-with-transact-sql-copy

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
```
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
```
SELECT...[..],
	CASE
		WHEN p.categoryid IN (1, 7, 8) THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign
FROM Production.Products AS p;
```

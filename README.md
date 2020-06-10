# t-sql
OD20761C - Querying Data with Transact-SQL

https://www.bouvet.no/kurs/kategorier/microsoft/sql-server/20761-querying-data-with-transact-sql-copy

# 
[docs.microsoft.com] https://docs.microsoft.com/nb-no/sql/?view=sql-server-ver15

[ANSI SQL-92] https://en.wikipedia.org/wiki/SQL-92


## Tips
* Show line numbers. Tools-> Options->Text Editor->Transact-SQL->General
* Show map mode. Tools-> Options->Text Editor->Transact-SQL->Scroll Bars


[Markdown Github] https://guides.github.com/features/mastering-markdown/



### Code


-- Case
USE BikeStores

SELECT p.product_name, p.list_price, p.model_year,
	CASE p.model_year
		WHEN 2017 THEN 'Old product'
		WHEN 2018 THEN 'New product'
		ELSE 'Return product'
	END AS year_description,

	CASE 
		WHEN p.list_price < 100 THEN 'Sale'
		WHEN p.list_price > 300 THEN 'Expensive'
		ELSE 'Standard'
	END AS price_description
FROM production.products p
ORDER BY 2

SELECT c.contactname as Name, c.companyname as [Company Name]
FROM Sales.Customres as c


-- Case
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

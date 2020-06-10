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

```
SELECT...[..],
	CASE
		WHEN p.categoryid IN (1, 7, 8) THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign
FROM Production.Products AS p;
```

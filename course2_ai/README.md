# AI tutorial using the BikeStores database

Use AI to learn more

## Azure Free sql

* Create SQL server
* Init with sample db adventureworks
* Created alert rule when only 10000 vCore seconds of compute left.

Try Azure SQL Database at no cost with our free tier offer. Each Azure subscription allows you to create up to 10 General Purpose databases.

For each database, you receive a monthly allowance of 100,000 vCore seconds of compute, 32 GB of data storage, and 32 GB of backup storage, free for the lifetime of your subscription.

https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer?view=azuresql

![Az db](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/sql_free.jpg)

You can view how much you have left using the free amount metric

![Az db free](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/sql_free_amount.jpg)



## BikeStore (localhost)

GOTO and load db files after creating a db called BikeStores https://www.sqlservertutorial.net/getting-started/load-sample-database/

## AI tutorial modified

# BikeStores Sample Database Tutorial (SQL Server)

---

## Introduction

The **BikeStores** sample database is a great tool for practicing SQL queries and learning database concepts. It simulates a simple bike retailer environment with realistic data.

---

## Getting Started

### Requirements

- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (2016 or later recommended)
- [SQL Server Management Studio (SSMS)](https://aka.ms/ssms) or Azure Data Studio

SSMS MSSQL16.SQLEXPRESS

![SQL icon](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/sql_icon.jpg)

Location of files

![SQL files](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/sql_files.jpg)

Services

![SQL services](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/sql_services.jpg)

### Download BikeStores Scripts

1. https://www.sqlservertutorial.net/getting-started/load-sample-database/


### Create Database and Tables

1. Open **SSMS** and connect to your SQL Server instance.
2. Open BikeStores Sample Database - create objects.sql (or the script you downloaded).3. Execute the script (F5 or click "Execute").

### Insert Sample Data

1.  BikeStores Sample Database - load data.sql Execute the script to insert sample data.

![BikeStores data](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/bikestore_data.jpg)
---

## Exploring the Database

SQL Server Sample Database https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/

### Schema Overview

BikeStores contains two main schemas:
- **sales** (orders, customers, stores, staffs)
- **production** (products, brands, categories, stocks)

In BikeStores, schemas like sales and production help keep the database organized, secure, and easy to use. When creating, querying, or managing tables, always specify the schema for clarity.


![BikeStores Schema](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/bikestore_schema.jpg)





## Data Manipulation

SELECT

```sql
use BikeStores
select first_name, last_name
from sales.customers;

use BikeStores
select *
from sales.customers

use BikeStores
select *
from sales.customers
where city = 'New York'

use BikeStores
select first_name, last_name
from sales.customers
where city = 'New York'
order by first_name

-- the following statement returns all the cities of customers located in California and the number of customers in each city.
use BikeStores
select city, count(*)
from sales.customers
where state = 'CA'
group by city
order by city

-- the following statement uses the HAVING clause to return the city in California, which has more than ten customers:
use BikeStores
select city, count(*)
from sales.customers
where state = 'CA'
group by city
HAVING COUNT(*) > 10
order by city
```

ORDER BY

```sql

```

OFFSET FETCH

SELECT TOP

SELECT DISTINCT

WHERE

NULL

AND

OR

IN

BETWEEN

LIKE

Column & Table Aliases

Joins

INNER JOIN

LEFT JOIN

RIGHT JOIN

FULL OUTER JOIN

Self Join

CROSS JOIN

![Joins](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/joins.jpg)

CROSS APPLY

GROUP BY

HAVING

GROUPING SETS

CUBE

ROLLUP

Subquery

Correlated Subquery

EXISTS

ANY

ALL

UNION

INTERSECT

EXCEPT

Common Table Expression (CTE)

Recursive CTE

INSERT

INSERT Multiple Rows

INSERT INTO SELECT

UPDATE

UPDATE JOIN

DELETE

MERGE

PIVOT

Transaction

https://www.sqlservertutorial.net/sql-server-basics/sql-server-select/

## Data Definition

## Data Types

## Expressions


## Azure AdventureWorks sample databases next up 

Lets try to impprt/restore the Lightweight AdventureWorksLT2022.bak, save it in C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\AdventureWorksLT2022.bak

Restore to SQL Server

![adventureworks restore](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/adventureworks_restore.jpg)

https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms



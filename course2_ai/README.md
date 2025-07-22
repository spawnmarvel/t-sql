# AI tutorial using the BikeStores database

## BikeStore

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

BikeStores contains three main schemas:
- **sales** (orders, customers, stores, staffs)
- **production** (products, brands, categories, stocks)
- **person** (staff and related info)

### Main Schemas in BikeStores

| Schema      | Description                                       | Example Tables            |
|-------------|---------------------------------------------------|---------------------------|
| **sales**   | Sales operations (orders, customers, stores)      | sales.orders, sales.customers, sales.stores, sales.staffs || **production** | Product and inventory details                  | production.products, production.categories, production.brands, production.stocks || **person**  | Staff personal information                        | person.staffs           |

In BikeStores, schemas like sales, production, and person help keep the database organized, secure, and easy to use. When creating, querying, or managing tables, always specify the schema for clarity.


![BikeStores Schema](https://github.com/spawnmarvel/t-sql/blob/master/course2_ai/images/bikestore_schema.jpg)





## Data Manipulation

SELECT
ORDER BY
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


## AI Tutorial next up

For sql server do you know the bikestore database? BikeStores Sample Database - create objects.sql 

He knows it.

Great, can you make an updated tutorial on how to use it, from basic to intermediate. Make it like a github file markup, so I can copy and paste.

- **Backup your database** before experimenting with updates or deletes.
- Use TOP (N) to limit results.- Use ORDER BY to sort outputs.- Try using **Views** or **Stored Procedures** for more advanced practice.

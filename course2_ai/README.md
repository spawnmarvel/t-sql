# AI tutorial using the BikeStores database

## BikeStore

GOTO and load db files after creating a db called BikeStores https://www.sqlservertutorial.net/getting-started/load-sample-database/

## AI tutorial modified

# BikeStores Sample Database Tutorial (SQL Server)

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
   - [Requirements](#requirements)
   - [Download BikeStores Scripts](#download-bikestores-scripts)
   - [Create Database and Tables](#create-database-and-tables)
   - [Insert Sample Data](#insert-sample-data)
3. [Exploring the Database](#exploring-the-database)
   - [Schema Overview](#schema-overview)
   - [Viewing Tables](#viewing-tables)
4. [Basic SQL Queries](#basic-sql-queries)
5. [Intermediate SQL Queries](#intermediate-sql-queries)
6. [Extra Tips](#extra-tips)
7. [References](#references)

---

## Introduction

The **BikeStores** sample database is a great tool for practicing SQL queries and learning database concepts. It simulates a simple bike retailer environment with realistic data.

---

## Getting Started

### Requirements

- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (2016 or later recommended)
- [SQL Server Management Studio (SSMS)](https://aka.ms/ssms) or Azure Data Studio

### Download BikeStores Scripts

1. Go to the [BikeStores GitHub repo](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/bikestores) or use these direct links:
    - [BikeStores Sample Database - create objects.sql](https://github.com/microsoft/sql-server-samples/blob/master/samples/databases/bikestores/insta llation-scripts/bikestores-schema.sql)
    - [BikeStores Sample Database - insert data.sql](https://github.com/microsoft/sql-server-samples/blob/master/samples/databases/bikestores/installation-scripts/bikestores-data.sql)

2. Download both SQL scripts and save them locally.

### Create Database and Tables

1. Open **SSMS** and connect to your SQL Server instance.
2. Open bikestores-schema.sql (or the script you downloaded).3. Execute the script (F5 or click "Execute").

### Insert Sample Data

1. Open bikestores-data.sql.2. Execute the script to insert sample data.

---

## Exploring the Database

### Schema Overview

BikeStores contains three main schemas:
- **sales** (orders, customers, stores, staffs)
- **production** (products, brands, categories, stocks)
- **person** (staff and related info)

![BikeStores Schema](https://github.com/microsoft/sql-server-samples/raw/master/samples/databases/bikestores/bikestores-schema.png)

### Viewing Tables

To see all tables in the database:

```sql

USE BikeStores;
GO

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


```

## Basic SQL Queries

### 1. View all customers

```sql

SELECT * FROM sales.customers;

```

### 2. Get all products and their categories

```sql
SELECT 
    p.product_id, p.product_name, 
    c.category_name
FROM production.products AS p
JOIN production.categories AS c
  ON p.category_id = c.category_id;

```

### 3. List all stores

```sql
SELECT * FROM sales.stores;

```

### 4. Check stock for each product

```sql
SELECT 
    s.store_id, 
    s.product_id, 
    p.product_name, 
    s.quantity
FROM production.stocks AS s
JOIN production.products AS p
  ON s.product_id = p.product_id;

```
---

## Intermediate SQL Queries

### 1. Find top 5 customers by total orders

```sql
SELECT TOP 5
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
JOIN sales.orders AS o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

```

### 2. Get total sales by store

```sql
SELECT 
    s.store_id,
    st.store_name,
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_sales
FROM sales.orders AS o
JOIN sales.order_items AS oi
  ON o.order_id = oi.order_id
JOIN sales.stores AS st
  ON o.store_id = st.store_id
GROUP BY s.store_id, st.store_name
ORDER BY total_sales DESC;

```

### 3. Display products not in stock at any store

```sql

SELECT 
    p.product_id, 
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s
  ON p.product_id = s.product_id
WHERE s.quantity IS NULL OR s.quantity = 0;

```

### 4. List employees and their managers

```sql
SELECT
    s.staff_id,
    s.first_name + ' ' + s.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs s
LEFT JOIN sales.staffs m
  ON s.manager_id = m.staff_id;

```
---

## Extra Tips

- **Backup your database** before experimenting with updates or deletes.
- Use TOP (N) to limit results.- Use ORDER BY to sort outputs.- Try using **Views** or **Stored Procedures** for more advanced practice.

---

## References

- [BikeStores GitHub Repository](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/bikestores)
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/?view=sql-server-ver16)
- [SQL Server Sample Databases](https://github.com/microsoft/sql-server-samples)

## Create views TBD

## Create Stored Procedures TBD
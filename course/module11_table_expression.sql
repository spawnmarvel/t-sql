-- Creating Simple Views

-- Views are saved queries created in a database
-- Views are defined with a single SELECT statment
-- ORDER BY is not premitted in a view definition without the use of TOP, OFFSET/FETCH or FOR XML
-- To sort the output, USE ORDER BY in the outer q
-- View creation supports additional options

-- For data analyse, if tables are not known
-- For security reasons
-- 
-- Start with select statment and then add header
-- ORDER BY is not permitted, the view is used in another select in a query or join with other views
-- 

USE BikeStores;
GO
CREATE SCHEMA hr;
GO
CREATE view hr.StaffPhoneList AS
SELECT staff_id, first_name, last_name, phone
FROM BikeStores.sales.staffs;
GO

-- select from view
SELECT first_name, last_name, phone
FROM hr.staffPhoneList


USE BikeStores;
GO
CREATE SCHEMA eco;
GO
CREATE VIEW eco.AllOrders AS
--get all customers and all orders with the date and productname
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, i.list_price, p.product_name, o.order_date
FROM [BikeStores].[sales].[customers] AS c
INNER JOIN sales.orders o ON o.customer_id=c.customer_id
INNER JOIN sales.order_items i ON i.order_id=o.order_id
INNER JOIN production.products p ON p.product_id=i.product_id


-- ============================================================
-- Purpose of the Script:
-- This SQL script performs exploratory data analysis on the 
-- sales fact table. It calculates key business metrics such as 
-- total sales, total quantity sold, average selling price, 
-- number of orders, distinct products, and customer counts. 
-- It also consolidates these KPIs into a single result set 
-- for easier reporting and dashboard creation.
-- ============================================================


-- Retrieve all records from the sales fact table to get a 
-- complete view of the raw transactional data.
SELECT * 
FROM gold.fact_sales;


-- Calculate the total sales revenue generated from all transactions.
SELECT 
	SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales;


-- Calculate the total number of items (quantity) sold.
SELECT 
	SUM(quantity) AS Total_Items
FROM gold.fact_sales;


-- Calculate the average selling price of products across all transactions.
SELECT 
	AVG(price) AS Avg_Selling_Price
FROM gold.fact_sales;


-- Count the total number of orders and the number of unique (distinct) orders
-- to identify duplicates or multiple entries per order.
SELECT 
	COUNT(order_number) AS Total_Orders,
	COUNT(DISTINCT order_number) AS Distinct_Total_Orders
FROM gold.fact_sales;


-- Count the total number of unique products sold.
SELECT 
	COUNT(DISTINCT product_key) AS Total_Products
FROM gold.fact_sales;


-- Count the total number of unique customers in the sales data.
SELECT 
	COUNT(DISTINCT customer_key) AS Total_Customers
FROM gold.fact_sales;


-- Count the number of unique customers who have placed at least one order
-- (excluding records with NULL order numbers).
SELECT
	COUNT(DISTINCT customer_key) AS Total_Customers_Orders
FROM gold.fact_sales
WHERE order_number IS NOT NULL;


-- Combine multiple key performance indicators (KPIs) into a single result set
-- using UNION ALL for easier reporting and dashboard visualization.
SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Distinct Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_key) FROM gold.fact_sales
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_key) FROM gold.fact_sales
UNION ALL
SELECT 'Total Customers Order', COUNT(DISTINCT customer_key) FROM gold.fact_sales WHERE order_number IS NOT NULL;
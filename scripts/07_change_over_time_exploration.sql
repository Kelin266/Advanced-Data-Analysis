-- ============================================================
-- Purpose of the Script:
-- This SQL script performs time-based exploratory analysis on
-- the sales fact table. It examines overall transactional data
-- and generates aggregated insights such as yearly and monthly
-- sales performance, customer activity, and quantity sold.
-- These insights help in understanding trends over time and
-- are useful for reporting and dashboard creation.
-- ============================================================


-- Retrieve all records from the sales fact table to explore
-- the raw transactional data and understand its structure.
SELECT * 
FROM gold.fact_sales;


-- Aggregate sales data on a yearly basis to analyze overall
-- performance trends such as total sales, total customers,
-- and total quantity sold for each year.
SELECT 
	YEAR(order_date) AS Order_Year,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) AS Total_Customers,
	SUM(quantity) AS Total_Quantity
FROM gold.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


-- Aggregate sales data on a monthly basis within each year
-- to analyze detailed trends. This includes total sales,
-- customer count, and quantity sold for each month, along
-- with both numeric and name representation of months for
-- better readability and proper chronological sorting.
SELECT 
	YEAR(order_date) AS Order_Year,
	MONTH(order_date) AS Order_Month,
	DATENAME(MONTH,order_date) AS Order_Month_Name,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) AS Total_Customers,
	SUM(quantity) AS Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date),
	MONTH(order_date),
	DATENAME(MONTH,order_date)
ORDER BY 
	YEAR(order_date),
	MONTH(order_date);
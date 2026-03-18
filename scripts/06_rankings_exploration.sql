-- ============================================================
-- Purpose of the Script:
-- This SQL script performs exploratory analysis on customer,
-- product, and sales data to identify top and bottom performers.
-- It retrieves raw data from dimension and fact tables, and
-- analyzes highest and lowest revenue-generating products,
-- subcategories, and customers using aggregation and ranking.
-- ============================================================


-- Retrieve all records from the customer dimension table
-- to explore customer-related data.
SELECT * FROM gold.dim_customers;


-- Retrieve all records from the product dimension table
-- to explore product-related data.
SELECT * FROM gold.dim_products;


-- Retrieve all records from the sales fact table
-- to explore transactional sales data.
SELECT * FROM gold.fact_sales;


-- Retrieve the top 5 products generating the highest revenue
-- by aggregating sales data and sorting in descending order.
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS Total_revenue
FROM gold.dim_products AS p
RIGHT JOIN gold.fact_sales AS f
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue DESC;


-- Retrieve the bottom 5 products generating the lowest revenue
-- by aggregating sales data and sorting in ascending order.
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS Total_revenue
FROM gold.dim_products AS p
RIGHT JOIN gold.fact_sales AS f
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue ASC;


-- Retrieve the top 5 subcategories generating the highest revenue
-- to understand best-performing product segments.
SELECT TOP 5
	p.subcategory,
	SUM(f.sales_amount) AS Total_revenue
FROM gold.dim_products AS p
RIGHT JOIN gold.fact_sales AS f
ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY Total_Revenue DESC;


-- Retrieve the bottom 5 subcategories generating the lowest revenue
-- to identify underperforming product segments.
SELECT TOP 5
	p.subcategory,
	SUM(f.sales_amount) AS Total_revenue
FROM gold.dim_products AS p
RIGHT JOIN gold.fact_sales AS f
ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY Total_Revenue ASC;


-- Retrieve the top 5 customers based on total revenue contribution
-- using ROW_NUMBER() for ranking in descending order.
SELECT 
	Name,
	Total_Revenue
FROM(
	SELECT 
		CONCAT(dc.first_name,' ',dc.last_name) AS Name,
		SUM(f.sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS Rank_Customers
	FROM gold.dim_customers AS dc
	RIGHT JOIN gold.fact_sales as f
	ON f.customer_key = dc.customer_key
	GROUP BY CONCAT(dc.first_name,' ',dc.last_name)
) t
WHERE Rank_Customers <= 5;


-- Retrieve the bottom 3 customers based on total revenue contribution
-- using ROW_NUMBER() for ranking in ascending order.
SELECT 
	Name,
	Total_Revenue
FROM(
	SELECT 
		CONCAT(dc.first_name,' ',dc.last_name) AS Name,
		SUM(f.sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) ASC) AS Rank_Customers
	FROM gold.dim_customers AS dc
	RIGHT JOIN gold.fact_sales as f
	ON f.customer_key = dc.customer_key
	GROUP BY CONCAT(dc.first_name,' ',dc.last_name)
) t
WHERE Rank_Customers <= 3;

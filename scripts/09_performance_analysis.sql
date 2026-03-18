-- ============================================================
-- Purpose of the Script:
-- This SQL script performs advanced analytical exploration on
-- sales data. It first reviews raw transactional data and then
-- calculates yearly product-level sales. It further analyzes
-- product performance by comparing current sales with average
-- sales and previous year sales using window functions. The
-- script helps identify trends such as growth, decline, and
-- performance relative to average benchmarks.
-- ============================================================


-- Retrieve all records from the sales fact table to explore
-- the raw transactional dataset and understand its structure.
SELECT * 
FROM gold.fact_sales;


-- This query calculates yearly sales for each product and performs
-- advanced analysis including:
-- - Average sales per product across years
-- - Difference from average sales and classification (Above/Below)
-- - Previous year sales using LAG function
-- - Year-over-year difference and trend (Increasing/Decreasing/Stagnant)
WITH yearly_product_sales AS(
	SELECT
		YEAR(f.order_date) AS Order_Year,
		p.product_name,
		SUM(f.sales_amount) AS Current_Sales
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY 
		YEAR(f.order_date),
		p.product_name
)

SELECT 
	Order_Year,
	product_name,
	Current_Sales,

	-- Calculate average sales of each product across all years
	AVG(Current_Sales) OVER(PARTITION BY product_name) AS Average_Product_Sales,

	-- Calculate difference between current sales and average sales
	Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) AS Average_Difference,

	-- Classify whether current sales are above, below, or equal to average
	CASE 
		WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
		WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
		ELSE 'Average'
	END AS Average_Change,

	-- Retrieve previous year's sales for each product
	LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS Prev_Year_Sales,

	-- Calculate difference between current and previous year sales
	Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS Prev_Year_Difference,

	-- Classify year-over-year trend for each product
	CASE 
		WHEN Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) > 0 THEN 'Increasing'
		WHEN Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decreasing'
		ELSE 'Stagnant'
	END AS Prev_Year_Change

FROM yearly_product_sales
ORDER BY product_name, Order_Year;
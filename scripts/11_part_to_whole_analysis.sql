-- ============================================================
-- Purpose of the Script:
-- This SQL script performs category-level sales analysis to
-- understand the contribution of each product category to the
-- overall revenue. It calculates total sales per category,
-- overall net sales, and the percentage contribution of each
-- category using window functions. This helps identify top-
-- performing categories and their impact on total business revenue.
-- ============================================================


-- This query aggregates total sales for each product category
-- and then calculates overall net sales and percentage contribution
-- of each category using window functions for comparative analysis.
WITH category_sales AS(
	SELECT
		p.category,
		SUM(f.sales_amount) AS Total_Sales
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
	GROUP BY p.category
)

SELECT 
	category,
	Total_Sales,

	-- Calculate total sales across all categories (net sales)
	SUM(Total_Sales) OVER() AS Net_Sales,

	-- Calculate percentage contribution of each category to total sales
	ROUND((CAST(Total_Sales AS FLOAT) / SUM(Total_Sales) OVER()) * 100, 4) AS Percentage_Contribution

FROM category_sales
ORDER BY Total_Sales DESC;
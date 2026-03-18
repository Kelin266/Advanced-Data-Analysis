-- ============================================================
-- Purpose of the Script:
-- This SQL script performs segmentation analysis on products
-- and customers. It categorizes products into different cost
-- ranges to understand product distribution, and segments
-- customers based on their spending behavior and duration of
-- engagement. This helps in identifying product pricing tiers
-- and classifying customers into groups such as VIP, Regular,
-- and New for business insights and decision-making.
-- ============================================================


-- This query segments products into different cost ranges and
-- counts the number of products in each segment to analyze
-- product distribution across pricing tiers.
WITH product_segments AS (
	SELECT 
		product_name,
		cost,
		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS Cost_Range
	FROM gold.dim_products
)

SELECT 
	Cost_Range,
	COUNT(product_name) AS Number_of_Products
FROM product_segments
GROUP BY Cost_Range
ORDER BY COUNT(product_name);


-- This query segments customers based on their total spending
-- and duration of engagement (in months). It classifies customers
-- into categories such as VIP, Regular, and New, and counts the
-- number of customers in each segment for behavioral analysis.
WITH customer_segment AS(
	SELECT 
		CONCAT(dc.last_name,' ',dc.first_name) AS Name,
		SUM(f.sales_amount) AS Total_Spending,
		MIN(order_date) AS Oldest_Order_Date,
		MAX(order_date) AS Latest_Order_Date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Spending_Duration
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS dc
	ON dc.customer_key = f.customer_key
	GROUP BY CONCAT(dc.last_name,' ',dc.first_name)
)

SELECT
	CASE 
		WHEN Spending_Duration >= 12 AND Total_Spending > 5000 THEN 'VIP Customer'
		WHEN Spending_Duration >= 12 AND Total_Spending <= 5000 THEN 'Regular Customer'
		ELSE 'New Customer'
	END AS Customer_Grading,
	COUNT(Name) AS Total_Customers
FROM customer_segment
GROUP BY 
	CASE 
		WHEN Spending_Duration >= 12 AND Total_Spending > 5000 THEN 'VIP Customer'
		WHEN Spending_Duration >= 12 AND Total_Spending <= 5000 THEN 'Regular Customer'
		ELSE 'New Customer'
	END;
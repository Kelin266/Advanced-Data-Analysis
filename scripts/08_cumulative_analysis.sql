-- ============================================================
-- Purpose of the Script:
-- This SQL script performs time-series analysis on monthly sales
-- data. It calculates total monthly revenue and average price,
-- and then applies window functions to compute cumulative revenue
-- and moving average price over time. This helps in understanding
-- sales trends, growth patterns, and pricing behavior across months.
-- ============================================================


-- Aggregate sales data at a monthly level and compute advanced
-- time-based metrics such as cumulative total revenue and moving
-- average price using window functions for trend analysis.
SELECT 
	Order_Month,
	Total_Revenue,
	SUM(Total_Revenue) OVER(ORDER BY Order_Month) AS Cumultaive_Total,
	AVG(Average_Price) OVER(ORDER BY Order_Month) AS Moving_Average_Price
FROM(
	SELECT 
		DATETRUNC(MONTH, order_date) AS Order_Month,
		SUM(sales_amount) AS Total_Revenue,
		AVG(price) AS Average_Price
	FROM gold.fact_sales
	WHERE DATETRUNC(MONTH, order_date) IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
) t;
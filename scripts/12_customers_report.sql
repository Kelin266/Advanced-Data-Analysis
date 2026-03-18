/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
	DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
	c.birthdate,
	DATEDIFF(YEAR,c.birthdate,GETDATE()) AS Age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE f.order_date IS NOT NULL
)
, customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
	SELECT 
		customer_key,
		customer_number,
		Customer_Name,
		Age,
		COUNT(DISTINCT order_number) AS Total_Orders,
		SUM(sales_amount) AS Total_Sales,
		SUM(quantity) AS Total_Quantity,
		COUNT(DISTINCT product_key) AS Total_Products,
		MAX(order_date) AS Last_Order_Date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Spending_Duration
	FROM base_query
	GROUP BY 
		customer_key,
		customer_number,
		Customer_Name,
		Age
)
SELECT 
	customer_key,
	customer_number,
	Customer_Name,
	Age,
	CASE 
		 WHEN age < 20 THEN 'Under 20'
		 WHEN age between 20 and 29 THEN '20-29'
		 WHEN age between 30 and 39 THEN '30-39'
		 WHEN age between 40 and 49 THEN '40-49'
		 ELSE '50 and above'
	END AS Age_Group,
	CASE 
		WHEN Spending_Duration >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN Spending_Duration >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS Customer_Segment,
	Total_Orders,
	Total_Sales,
	Total_Quantity,
	Total_Products,
	Last_Order_Date,
	DATEDIFF(MONTH,Last_Order_Date,GETDATE()) AS Recency,
	CONCAT(Spending_Duration,' Months') AS Spending_Duration,
-- Compuate average order value (AVO)
	Total_Sales/Total_Orders AS Average_Order_Value,
-- Compuate average monthly spend
	CASE 
		WHEN Spending_Duration=0 THEN Total_Sales
		ELSE Total_Sales/Spending_Duration
	END AS Average_Monthly_Spend
FROM customer_aggregation
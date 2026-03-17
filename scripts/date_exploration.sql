-- ============================================================
-- Purpose of the Script:
-- This SQL script performs exploratory analysis on the dataset
-- to understand time-related characteristics of the data. 
-- It determines the overall time span of sales transactions 
-- and analyzes the age distribution of customers by identifying 
-- the oldest and youngest customers in the customer dimension.
-- ============================================================


-- This query analyzes the sales fact table to determine the 
-- earliest and latest order dates and calculates the total 
-- number of years covered by the sales data.
SELECT
	MIN(order_date) FirstOrder,
	MAX(order_date) LastOrder,
	DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) OrderRangeYears
FROM gold.fact_sales;


-- This query analyzes the customer dimension table to identify 
-- the oldest and youngest customers based on birthdate and 
-- calculates their approximate ages using the current date.
SELECT 
	MIN(birthdate) OldestCustomer,
	DATEDIFF(YEAR,MIN(birthdate),GETDATE()) EldestAge,
	MAX(birthdate) YoungestCustomer,
	DATEDIFF(YEAR,MAX(birthdate),GETDATE()) YoungestAge
FROM gold.dim_customers;
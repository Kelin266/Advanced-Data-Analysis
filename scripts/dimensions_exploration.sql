/* 

Dimensions Exploration 

*/

-- This query retrieves the list of unique countries from the customer dimension table.
-- It helps in understanding the geographic distribution of customers in the dataset.
SELECT
DISTINCT country
FROM gold.dim_customers;


-- This query retrieves unique combinations of product category, subcategory, and product name
-- from the product dimension table. It helps explore the product hierarchy and understand
-- how products are organized within categories and subcategories.
SELECT
DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;


-- This query retrieves all unique product lines from the product dimension table.
-- It helps identify the different product lines available in the dataset for analysis.
SELECT
DISTINCT product_line
FROM gold.dim_products;
/* 
This SQL script is made to explore database.
*/

-- This query retrieves a list of all tables available in the current database.
-- It helps in exploring the database structure and identifying all tables present.
SELECT * 
FROM INFORMATION_SCHEMA.TABLES;


-- This query retrieves detailed information about all columns from every table in the database.
-- It shows column names, data types, table names, and other column-related metadata.
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS;

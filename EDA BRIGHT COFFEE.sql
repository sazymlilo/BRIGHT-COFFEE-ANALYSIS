-- Databricks notebook source
--------------------------------------------checking full table

SELECT * FROM `workspace`.`default`.`bright_coffee_shop`;

----------------------------------------checking row/duplicates, number of row= number of unique tran_id = no duplicates
SELECT COUNT(*) AS num_rows,
       COUNT(DISTINCT transaction_id) AS user_id
FROM `workspace`.`default`.`bright_coffee_shop`;

--------------------------------------------checking NULLs in some of the columns of the dataset
SELECT COUNT(*) AS null_count
FROM `workspace`.`default`.`bright_coffee_shop`
WHERE transaction_id IS NULL OR transaction_date IS NULL OR transaction_time IS NULL OR transaction_qty IS NULL OR store_id IS NULL OR store_location IS NULL OR product_id IS NULL OR unit_price IS NULL OR product_category IS NULL OR product_type IS NULL OR product_detail IS NULL;

---------------------------------------------------------------------------calculating total_revenue

select sum(transaction_qty* unit_price) AS total_revenue from `workspace`.`default`.`bright_coffee_shop`;

SELECT SUM(transaction_qty * TRY_CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS Total_Revenue
FROM `workspace`.`default`.`bright_coffee_shop`;


-------------------------------------------------------------------------------------calculating min,max and average price
select MIN(unit_price) AS lowest_price,
      MAX(unit_price) AS highest_price,
      AVG(unit_price) AS avg_price
      FROM `workspace`.`default`.`bright_coffee_shop`;

select AVG (transaction_qty * unit_price) AS average_sale,
       MIN (transaction_qty * unit_price) AS lowest_sale,
       MAX (transaction_qty * unit_price) AS highest_sale
FROM `workspace`.`default`.`bright_coffee_shop`;

-------------------------------------------------------------------------------------calculating avg transaction quantity
SELECT AVG(transaction_qty) AS AVG_transactions
FROM `workspace`.`default`.`bright_coffee_shop`;

-----------------------------------------------------------------------------------------------------calculating total revenue per store
SELECT DISTINCT store_location,
    ROUND(SUM(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.') AS DOUBLE)),2) AS Total_Revenue
FROM `workspace`.`default`.`bright_coffee_shop`
GROUP BY store_location
ORDER BY Total_Revenue;


SELECT store_location,
       SUM(transaction_qty * unit_price) AS total_revenue
FROM `workspace`.`default`.`bright_coffee_shop`
GROUP BY store_location
ORDER BY total_revenue;

SELECT
DAYNAME(transaction_date) AS day_name,
HOUR(transaction_time) AS transaction_hour,
DAYOFWEEK(transaction_date) AS day_of_week,
MONTHNAME(transaction_date) AS month_name,
DATE_FORMAT(transaction_time, 'HH:mm:ss') AS formatted_time,
YEAR(transaction_date) AS year

FROM `workspace`.`default`.`bright_coffee_shop`;
---------------------------------------------------------------------------------------------------  

SELECT CASE
WHEN HOUR(transaction_time) BETWEEN 0 AND 2 THEN '00:00 - 02:59.wee hours'
WHEN HOUR(transaction_time) BETWEEN 3 AND 5 THEN '03:00 - 05:59.dawn hours'
WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00 - 08:59.early_morning'
WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00 - 11:59.morning'
WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00 - 14:59.afternoon'
WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00 - 17:59.late_afternoon'
WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00 - 20:59.evening'
WHEN HOUR(transaction_time) BETWEEN 21 AND 23 THEN '21:00 - 23:59.night'
END AS time_of_day
FROM `workspace`.`default`.`bright_coffee_shop`;


SELECT
(transaction_qty* unit_price) AS sales,
    CASE
        WHEN sales >= 5.00 THEN 'High Sale'
        WHEN sales >= 3.00 THEN 'Medium Sale'
        ELSE 'Low Sale'
    END AS sales_category
FROM `workspace`.`default`.`bright_coffee_shop`;


SELECT
CASE
        WHEN DAYOFWEEK(transaction_date) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
        END AS Day_Classification
FROM `workspace`.`default`.`bright_coffee_shop`;


SELECT
CASE
    WHEN DAYNAME(transaction_date) IN ('Saturday', 'Sunday')
    THEN 'Weekend'
    ELSE 'Weekday'
END AS Day_Classification
FROM `workspace`.`default`.`bright_coffee_shop`;

SELECT
     transaction_time,
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
        END AS time_of_day
FROM `workspace`.`default`.`bright_coffee_shop`;


with CTE AS (
    SELECT 

transaction_qty,
store_id,
store_location,
product_id,
unit_price,
product_category,
product_type,
product_detail, 
transaction_id,
transaction_date, 
transaction_time,
sum(transaction_qty* unit_price) AS total_revenue,
DAYNAME(transaction_date) AS day_name,
HOUR(transaction_time) AS transaction_hour,
DAYOFWEEK(transaction_date) AS day_of_week,
MONTHNAME(transaction_date) AS month_name,
DATE_FORMAT(transaction_time, 'HH:mm:ss') AS formatted_time,
YEAR(transaction_date) AS year,

CASE
WHEN HOUR(transaction_time) BETWEEN 0 AND 2 THEN '00:00 - 02:59.wee hours'
WHEN HOUR(transaction_time) BETWEEN 3 AND 5 THEN '03:00 - 05:59.dawn hours'
WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00 - 08:59.early_morning'
WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00 - 11:59.morning'
WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00 - 14:59.afternoon'
WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00 - 17:59.late_afternoon'
WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00 - 20:59.evening'
WHEN HOUR(transaction_time) BETWEEN 21 AND 23 THEN '21:00 - 23:59.night'
END AS time_of_day,

transaction_qty* unit_price AS sales,


   CASE
        WHEN (transaction_qty * unit_price) >= 5.00 THEN 'High Sale'
        WHEN (transaction_qty * unit_price) >= 3.00 THEN 'Medium Sale'
        ELSE 'Low Sale'
    END AS sales_category,

CASE
        WHEN DAYOFWEEK(transaction_date) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
        END AS Day_Classification



        FROM `workspace`.`default`.`bright_coffee_shop`
      GROUP BY ALL  

)


-- BIG CLEANED DATA QUERY
SELECT 
transaction_id,
transaction_date, 
transaction_time,
day_name,
transaction_hour,
day_of_week,
month_name,
formatted_time,
time_of_day,
transaction_qty,
store_id,
store_location,
product_id,
unit_price,
product_category,
product_type,
product_detail, 
sales_category,
day_classification,
transaction_qty* unit_price AS sales,
SUM (transaction_qty* unit_price) AS total_revenue
FROM CTE
GROUP BY ALL;
       

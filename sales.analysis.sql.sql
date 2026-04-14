-- SQL RETAIL SALES ANALYSIS
CREATE DATABASE SQL_PROJECT_1;
USE SQL_PROJECT_1;
-- database setup
CREATE TABLE RETAIL_SALES(
   transactions_id INT PRIMARY KEY,
   sale_date DATE,
   sale_time TIME,
   customer_id INT,
   gender VARCHAR(10),
   age INT,
   category VARCHAR(20),
   quantiy INT,
   price_per_unit FLOAT,
   cogs FLOAT,
   total_sale FLOAT
);
-- data cleaning
-- Check for nulls
SELECT * FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Remove incomplete records
DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
   
-- Data Analysis and Business Key Problems & ANSWERS
-- My Analysis & Findings

-- Q1. Sales on a specific date
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Clothing transactions with quantity > 10 in Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
   
-- Q3. Total sales and orders per category
SELECT category,
       SUM(total_sale)  AS net_sales,
       COUNT(*)         AS total_orders
FROM retail_sales
GROUP BY category;   

-- Q4. Average customer age for Beauty purchases
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. High-value transactions (total_sale > 1000)
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Transaction count by gender and category
SELECT category,
       gender,
       COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7. Best-selling month per year (by average sale)
SELECT year, month, avg_sale
FROM (
    SELECT
        YEAR(sale_date)              AS year,
        MONTH(sale_date)             AS month,
        ROUND(AVG(total_sale), 2)    AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        )                            AS rnk
    FROM retail_sales
    GROUP BY 1, 2
) ranked
WHERE rnk = 1;

-- Q8. Top 5 customers by total spend
SELECT customer_id,
       SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q9. Unique customers per category
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10. Orders by time-of-day shift
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12              THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
   
   
   
   
   
   
   
   

-- SQL RETAIL SALES ANALYSIS
CREATE DATABASE SQL_PROJECT_1;
USE SQL_PROJECT_1;
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
SELECT *FROM RETAIL_SALES;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS total_sale FROM RETAIL_SALES;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALE FROM RETAIL_SALES;

-- Data Analysis and Business Key Problems & ANSWERS

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

   SELECT *FROM RETAIL_SALES 
   WHERE sale_date = '2022-11-05';
   
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

   SELECT *FROM RETAIL_SALES 
   WHERE category = 'clothing' or quantiy >10 ;
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

   SELECT CATEGORY, SUM(TOTAL_SALE) AS NET_SALES, COUNT(*) AS TOTAL_ORDERS
   FROM RETAIL_SALES
   GROUP BY 1;
   
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

   SELECT ROUND(AVG(AGE),2) FROM RETAIL_SALES 
   WHERE CATEGORY = 'BEAUTY';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

   SELECT *FROM RETAIL_SALES 
   WHERE TOTAL_SALE > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

   SELECT CATEGORY,GENDER, COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS FROM RETAIL_SALES 
   GROUP BY 1,2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

   SELECT 
   YEAR(SALE_DATE),
   MONTH(SALE_DATE),
   ROUND(AVG(TOTAL_SALE),2)
   FROM RETAIL_SALES
   GROUP BY 1, 2
   ORDER BY 1, 2;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

   SELECT customer_id, sum(total_sale) as total_sale
   FROM RETAIL_SALES 
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 5;
   
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

   SELECT 
   CATEGORY, COUNT( DISTINCT CUSTOMER_ID)
   FROM RETAIL_SALES 
   GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

   WITH HOURLY_SALE AS(
   SELECT * ,
   CASE 
   WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
   WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
   ELSE 'EVENING'
   END AS SHIFT
   FROM RETAIL_SALES )
   SELECT 
   SHIFT, COUNT(*) AS TOTAL_ORDERS
   FROM HOURLY_SALE
   GROUP BY SHIFT;
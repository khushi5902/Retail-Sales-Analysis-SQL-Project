# Retail Sales Analysis — SQL Project

##  Project Overview

A complete end-to-end SQL analysis of retail sales data — covering database design, data cleaning, exploratory data analysis (EDA), and business-driven querying. Built to demonstrate core data analyst skills using **MySQL**.

**Dataset:** 2000 transactional records spanning 2 years (2022–2023), 3 product categories, and 155 unique customers.

---

##  Objectives

- Design and populate a relational database from scratch
- Clean raw data by handling NULL and missing values
- Perform EDA to understand dataset structure and distribution
- Answer 10 real-world business questions using SQL

---

##  Skills & Concepts Used

| Concept | Applied In |
|---|---|
| Database & table creation | Schema setup |
| Data cleaning (NULL removal) | Data quality checks |
| Aggregations (`SUM`, `AVG`, `COUNT`) | Category & customer analysis |
| `GROUP BY` / `ORDER BY` | Ranking and segmentation |
| Window functions (`RANK OVER PARTITION BY`) | Best month per year |
| CTEs (`WITH` clause) | Shift-based analysis |
| Subqueries | Monthly sales ranking |
| Date/time functions (`EXTRACT`, `YEAR`, `MONTH`) | Time-series queries |
| Conditional logic (`CASE WHEN`) | Shift classification |

---

##  Database Schema

```sql
CREATE DATABASE sql_project_1;

CREATE TABLE retail_sales (
    transactions_id  INT PRIMARY KEY,
    sale_date        DATE,
    sale_time        TIME,
    customer_id      INT,
    gender           VARCHAR(10),
    age              INT,
    category         VARCHAR(20),
    quantity         INT,
    price_per_unit   FLOAT,
    cogs             FLOAT,
    total_sale       FLOAT
);
```

---

##  Data Cleaning

```sql
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
```

---

##  Business Questions & SQL Solutions

### Q1. Sales on a specific date
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2. Clothing transactions with quantity > 10 in Nov-2022
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
```

### Q3. Total sales and orders per category
```sql
SELECT category,
       SUM(total_sale)  AS net_sales,
       COUNT(*)         AS total_orders
FROM retail_sales
GROUP BY category;
```

### Q4. Average customer age for Beauty purchases
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5. High-value transactions (total_sale > 1000)
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### Q6. Transaction count by gender and category
```sql
SELECT category,
       gender,
       COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

### Q7. Best-selling month per year (by average sale)
```sql
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
```

### Q8. Top 5 customers by total spend
```sql
SELECT customer_id,
       SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

### Q9. Unique customers per category
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### Q10. Orders by time-of-day shift
```sql
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
```

---

##  Key Findings

- **Top category by revenue:** Electronics generated the highest net sales, followed by Clothing and Beauty
- **Peak sales period:** Identified the best-performing month in each year using window functions
- **Customer concentration:** Top 5 customers contribute disproportionately to total revenue — a signal for loyalty programs
- **Time-of-day distribution:** Afternoon shift sees the highest order volume, useful for staffing decisions
- **Gender split by category:** Meaningful differences in purchasing behavior across genders in specific categories

---


## How to Run

1. Clone the repository
```bash
git clone https://github.com/khushi5902/Retail-Sales-Analysis-SQL-Project.git
```

2. Open MySQL Workbench (or any MySQL client)

3. Run `retail_sales_analysis.sql` — it handles database creation, table setup, and all queries

4. Import the CSV dataset into the `retail_sales` table

---

## Author

**Khushi** — Aspiring Data Analyst  


# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

-- 1. Reterive all columns of sales made of 22-11-05 -- 
 ```sql
 select sum(total_sale) from retail_sales
 where sale_date = '2022-11-05';
 ```
 
 -- 2. Reterive all transcations where the category is clothing and the quantity sold is more than 10 from the month of November-2022 -- 
 ```sql
 select * from retail_sales
 where category = 'Clothing' and quantiy >= 4 and month(sale_date) = 11 and year(sale_date) = 2022;
 ```
 
  -- 3. Write a Sql Query to calculate total sales 
  ```sql
select category,  sum(total_sale) as net_sales, count(*) total_order from retail_sales
group by category;
```

 -- 4. Find the average age of the customers who purchased form the 'Beauty' Category
```sql
select floor(avg(age)) as average_age from retail_sales
where category = 'Beauty';
```

-- 5. Retrive all the transcation where the total_sales > 1000 
```sql
select * from retail_sales
where total_sale > 1000;
```

-- 6. Find the total number of transcation ('Transcation-Id') made by each gender in each category
```sql
select Gender , Category, count(transactions_id) from retail_sales
group by gender, category
order by category;
```

-- 7. Calculate the average sale of each month. Find out the best selling month in each year

```sql
WITH MonthlyAvg AS (
    SELECT 
        MONTH(sale_date) AS Months,
        YEAR(sale_date) AS Years,
        FLOOR(AVG(total_sale)) AS AvgMonthlySale
    FROM retail_sales
    GROUP BY MONTH(sale_date), YEAR(sale_date)
)
SELECT *,
       RANK() OVER (PARTITION BY Years ORDER BY AvgMonthlySale DESC) AS MonthRank
FROM MonthlyAvg;
```


--  showing just the highest avg monthly sales records
```sql
SELECT *
FROM (
    SELECT 
        MONTH(sale_date) AS Months,
        YEAR(sale_date) AS Years,
        FLOOR(AVG(total_sale)) AS AvgMonthlySale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY FLOOR(AVG(total_sale)) DESC) AS MonthRank
    FROM retail_sales
    GROUP BY MONTH(sale_date), YEAR(sale_date)
) AS RankedStats
WHERE MonthRank = 1;
```

-- 8. Find the top 5 customers based on the total sale
```sql
select * from retail_sales;

select customer_id, sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;
```

-- 9. Find the number of unique customer to who purchased item from each category
```sql
select category, count(DISTINCT customer_id) 
from retail_sales
group by category;
```
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

```sql
with 
Hourly_sale as(
select *, 
case when hour(sale_time) <= 12 then 'Morning'
	 when hour(sale_time) between 12 and 17 then 'Afternon'
     else 'Evening'
	end as shift
from retail_sales )
select shift, count(*) as Total_orders
from Hourly_sale
group by shift;
```
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Pratham Kaushik

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


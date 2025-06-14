Create database P_1_Sales_Analysis;
create table Retail_Sales(
             transactions_id Int,
             sale_date Date,
             sale_time Time,
             customer_id Int,	
             gender	varchar(15),
             age Int,
             category varchar(15),	
             quantiy Int,
             price_per_unit	float,
             cogs float,
             total_sale float
             ) ;

Select * from retail_sales;


-- How many sales we have -- 

select count(*) from retail_sales;


-- How many customers we have -- 
select count(distinct customer_id) from retail_sales;

-- How many categories we have -- 
select count(distinct category) from retail_sales;



-- Data Analysis / Business Key problem answers. -- 
 -- 1. Reterive all columns of sales made of 22-11-05 -- 
 
 select sum(total_sale) from retail_sales
 where sale_date = '2022-11-05';
 
 
 -- 2. Reterive all transcations where the category is clothing and the quantity sold is more than 10 from the month of November-2022 -- 
 
 select * from retail_sales
 where category = 'Clothing' and quantiy >= 4 and month(sale_date) = 11 and year(sale_date) = 2022;
 
 
  -- 3. Write a Sql Query to calculate total sales 
  
select category,  sum(total_sale) as net_sales, count(*) total_order from retail_sales
group by category;


 -- 4. Find the average age of the customers who purchased form the 'Beauty' Category

select floor(avg(age)) as average_age from retail_sales
where category = 'Beauty';


-- 5. Retrive all the transcation where the total_sales > 1000 

select * from retail_sales
where total_sale > 1000;


-- 6. Find the total number of transcation ('Transcation-Id') made by each gender in each category

select Gender , Category, count(transactions_id) from retail_sales
group by gender, category
order by category;


-- 7. Calculate the average sale of each month. Find out the best selling month in each year


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



--  showing just the highest avg monthly sales records

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


-- 8. Find the top 5 customers based on the total sale

select * from retail_sales;

select customer_id, sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;


-- 9. Find the number of unique customer to who purchased item from each category

select category, count(DISTINCT customer_id) 
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


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


-- *End Of Project____
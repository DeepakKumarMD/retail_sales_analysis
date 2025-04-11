-- Database: retail_sales_db

-- DROP DATABASE IF EXISTS retail_sales_db;

CREATE DATABASE retail_sales_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


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

select * from retail_sales;

select count(*) from retail_sales;

-- DATA CLEANING
-- checking null in a column

select * FROM  retail_sales where transactions_id IS NULL;

select * FROM  retail_sales where sale_date IS NULL;

select * FROM  retail_sales 
	where
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or 
	gender IS NULL
	or
	category IS NULL
	or
	quantity IS NULL
	or
	price_per_unit IS NULL
	or 
	cogs IS NULL
	or 
	total_sale IS NULL;

-- removing NULL value rows

delete from retail_sales 
	where
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or 
	gender IS NULL
	or
	category IS NULL
	or
	quantity IS NULL
	or
	price_per_unit IS NULL
	or 
	cogs IS NULL
	or 
	total_sale IS NULL;




-- DATA EXPLORATION

-- how many sales we have (Total number of sales)
select count(*) as total_sale from retail_sales;

-- how many unique customers we have 
select count(distinct(customer_id)) as no_of_customers from  retail_sales;

-- category list
select distinct category from retail_sales;




-- DATA ANALYTICS & KEY PROBLEM SOLUTIONS 

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05**

select * from retail_sales
	where sale_date='2022-11-05';


-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

select * from retail_sales
	where category='Clothing' and quantity >= 4 and to_char(sale_date,'yyyy-mm') = '2022-11';



-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.

select category ,sum(total_sale) , count(*) as total_orders
	from retail_sales
		group by category;


--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. ROUND( avg(age) ,2) 

select  avg(age)  
	from retail_sales
		where category='Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) as total_transactions
	from retail_sales 
		group by gender , category ;
	

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from retail_sales;


select * from 
(
	select
		EXTRACT (year from sale_date) as year,
		EXTRACT (month from sale_date) as month,
		avg(total_sale)  as avg_sale,
		RANK() over(partition by EXTRACT (year from sale_date) order by avg(total_sale) desc )
	from retail_sales
		group by year , month
		--order by 1, 3 DESC;
) as t1
	where rank=1;
-- 3 ( 3rd column ) desc (highest value to lowest)	



-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 	desc (top) asc (last)

select customer_id , sum(total_sale) as total_sale
	from retail_sales
		group by customer_id 
		order by total_sale desc
			limit 5;
	
--9.  **Write a SQL query to find the number of unique customers who purchased items from each category.**

select * from retail_sales;

select count(distinct(customer_id)) as unique_customers , category
	from retail_sales
	group by  category;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:


select extract (hour from current_time);

-- here we used CTE using WITH keyword
with hourly_sale
AS
(select *,
	case
		when  EXTRACT (HOUR from sale_time) < 12 then 'Morning'
		when  EXTRACT (HOUR from sale_time) BETWEEN 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift	
	from retail_sales
)
select shift, count(*) as total_orders
    from hourly_sale group by shift;
										
	
	


	




	
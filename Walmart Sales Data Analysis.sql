SELECT * FROM salesdatawalmart.sales;
-- -- -------------------------Feature_Engineering------------------------------------
-- - --time_of_day
SELECT time,
(CASE 
WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon" 
ELSE "Evening" END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
set time_of_day = (CASE 
WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon" 
ELSE "Evening" END);

-- ------------day_name
SELECT date,dayname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
set day_name = dayname(date);

-- -------------------month_name
SELECT date,monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
set month_name = monthname(date);

-- ----------------------------GENERIC Q-----------------------------------
-- -how many unique cities does data have?
select distinct city
from sales;

-- ---in which city is each branch?
select distinct branch
from sales;
select distinct city,branch
from sales;

-- --------------------PRODUCT----------------------------------------
-- -How many unique product lines does the data have?
select count(distinct (product_line)) 
from sales;
-- ----What is the most common payment method?
select payment_method,count(payment_method) as count_payment_method
from sales
group by payment_method
order by count(payment_method) desc ;

-- ------What is the most selling product line?
select product_line,count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- -----What is the total revenue by month?
select month_name,sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- ----What month had the largest COGS?
select sum(cogs) as cogs,month_name
from sales
group by month_name
order by cogs desc;

-- ---What product line had the largest revenue?
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- --What is the city with the largest revenue?
select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

-- ----What product line had the largest VAT?
select product_line, avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- --Which branch sold more products than average product sold?
select branch, sum(quamtity) as qty
from sales 
group by branch
having sum(quamtity)>(select avg(quamtity) as avg_qty from sales)
order by qty desc; 

-- --What is the most common product line by gender?
select distinct(count(gender)) as cnt, product_line,gender
from sales
group by gender, product_line
order by cnt desc;

-- --What is the average rating of each product line?
select round(avg(rating),2) as avg_rating, product_line
from sales
group by product_line
order by avg_rating desc;

-- -------------------SALES-----------------------
--  ---Number of sales made in each time of the day per weekday
select count(*) as total_sales, time_of_day, day_name
from sales
where day_name="Monday"
group by time_of_day
order by total_sales desc;

-- --Which of the customer types brings the most revenue?
select customer_type, round(sum(total),2) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- --Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,round(avg(VAT),2) as avg_vat
from sales
group by city
order by avg_vat desc;

-- --Which customer type pays the most in VAT?
select customer_type,round(avg(VAT),2) as avg_vat
from sales
group by customer_type
order by avg_vat desc;

-- -----------------------Customer---------------------------------
-- --How many unique customer types does the data have?
select count(distinct(customer_type)) as cnt_customer_types
from sales;

-- ---How many unique payment methods does the data have?
select count(distinct(payment_method)) as payment_method
from sales;

-- ---What is the most common customer type?
select distinct(customer_type) as customer_types
from sales
order by customer_type desc
limit 1;

-- --Which customer type buys the most quantity?
select customer_type, round(sum(quamtity),2) as total_quamtity_bought
from sales
group by customer_type
order by total_quamtity_bought desc;

-- --What is the gender of most of the customers?
select gender,count(*) as cnt_gender
from sales
group by gender			
order by cnt_gender desc;

-- --What is the gender distribution per branch?
select gender,count(*) as cnt_gender,branch
from sales
group by gender, branch		
order by branch;

-- --Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- --Which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) as avg_rating, branch
from sales
group by time_of_day,branch
order by avg_rating desc;

-- --Which day fo the week has the best avg ratings?
select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- --Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as avg_rating, branch
from sales
group by day_name, branch
order by avg_rating desc;

-- -------------------------------END---------------------------------
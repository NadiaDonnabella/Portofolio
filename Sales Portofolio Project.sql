-- Annual Performance Metrics
select year, 
count(distinct order_id) as total_transaction, 
sum(quantity) as total_prod_sold,
sum(sales) as total_sales
from sales_dataset
group by 1
order by 1;

-- States with Highest and Lowest Sales
select state, sum(sales) as total_sales
from sales_dataset
group by 1
order by 2 desc
limit 3;

select state, sum(sales) as total_sales
from sales_dataset
group by 1
order by 2
limit 3;

-- Top 5 best and worst seller
select product_category, product, sum(quantity) as total_prod_sold
from sales_dataset
group by 1, 2
order by 3 desc
limit 5;

select product_category, product, sum(quantity) as total_prod_sold
from sales_dataset
group by 1, 2
order by 3
limit 5;

-- Most Frequently Employed Shipping Mode
select ship_mode, count(distinct order_id) as total
from sales_dataset
group by 1
order by 2 desc;

-- Customer Count per Segment
select segment, count(distinct customer_id) as total_customer
from sales_dataset
group by 1
order by 2;

-- Loyal Customers Based on Transaction History and Purchasing Trends
select customer_name, state, count(distinct order_id) as total_transaction, sum(sales) as total_purchase
from sales_dataset
group by 1, 2
order by 3 desc, 4 desc
limit 3;
-- create database customer_behaviour;
use customer_behaviour;


SELECT 
    *
FROM
    customers;


SELECT DISTINCT
    (shipping_type)
FROM
    customers;

-- Total revenue based on gender
SELECT 
    gender, SUM(`purchase_amount_(usd)`)
FROM
    customers
GROUP BY gender;
 

-- Which customers used a discount but still spent more than the average purchase amount? 

SELECT 
    customer_id, `purchase_amount_(usd)`
FROM
    customers
WHERE
    discount_applied = 'Yes'
        AND `purchase_amount_(usd)` >= (SELECT 
            AVG(`purchase_amount_(usd)`)
        FROM
            customers
        WHERE
            discount_applied = 'Yes')
ORDER BY `purchase_amount_(usd)` DESC
LIMIT 10;


SELECT 
    AVG(`purchase_amount_(usd)`)
FROM
    customers;



-- top 5 products with highest average review rating

SELECT 
    item_purchased, ROUND(AVG(review_rating), 2) AS avg_rating
FROM
    customers
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- compare the average purchase amount betwen standard and express shipping.

SELECT 
    shipping_type,
    ROUND(AVG(`purchase_amount_(usd)`), 2) AS avg_price
FROM
    customers
WHERE
    shipping_type IN ('Express' , 'Standard')
GROUP BY shipping_type
ORDER BY AVG(`purchase_amount_(usd)`) DESC;

-- subscribed customer spend more? compare average spend and total revenue between subscriber and non-sub

SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customer,
    ROUND(AVG(`purchase_amount_(usd)`), 2) AS avg_spend,
    SUM(`purchase_amount_(usd)`) AS total_rev
FROM
    customers
GROUP BY subscription_status
ORDER BY total_rev DESC;

-- which 5 products have the highest percentage of purchases with discount applied

SELECT 
    item_purchased,
    ROUND(SUM(CASE
                WHEN discount_applied = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS discount_rate
FROM
    customers
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


-- segment customer into new, returning and loyal based on their total number of previous purhase, and show the count of each segment.

with customer_type as (
select customer_id,previous_purchases, 
case 
	when previous_purchases = 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal' end as customer_segment 
from customers)

select customer_segment, count(*) from customer_type
group by customer_segment;

SELECT 
    customer_segment, COUNT(*)
FROM
    (SELECT 
        customer_id,
            previous_purchases,
            CASE
                WHEN previous_purchases = 1 THEN 'New'
                WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
                ELSE 'Loyal'
            END AS customer_segment
    FROM
        customers) t
GROUP BY customer_segment;

-- what are the top 3 most purchsed products within each category?

select category,item_purchased,purchase_count from 
( select category, item_purchased, count(*) as purchase_count, row_number() over ( partition by category order by count(*) desc) as split 
from customers 
group by category,item_purchased)t
where split <=3
order by category, purchase_count desc;


-- Are customer who are repeat buyers (more than 5 previous purchases) also likely to subscribe?


SELECT 
    repeat_subscriber, COUNT(*) AS total_subscriber
FROM
    (SELECT 
        subscription_status,
            previous_purchases,
            CASE
                WHEN
                    subscription_status = 'Yes'
                        AND previous_purchases > 5
                THEN
                    'Repeat_Sub_Count'
                WHEN subscription_status = 'No' THEN 'Non Subscriber'
                ELSE 'New'
            END AS repeat_subscriber
    FROM
        customers) t
GROUP BY repeat_subscriber
ORDER BY total_subscriber DESC;


-- what is the revenue contribution of each age group?

SELECT 
    age_group, SUM(`purchase_amount_(usd)`) AS Revenue
FROM
    customers
GROUP BY age_group
ORDER BY Revenue DESC;

-- round(sum(case when discount_applied = 'Yes' then 1 else 0 ) /count(*)*100,2)

SELECT 
    location,
    ROUND(AVG(purchase_frequency_days), 0) AS avg_purchase_days,
    COUNT(*) AS num_customer
FROM
    customers
GROUP BY location
ORDER BY avg_purchase_days ASC
LIMIT 5;
 
 -- which season have highest sales
 
SELECT 
    season, SUM(`purchase_amount_(usd)`) AS total_sales
FROM
    customers
GROUP BY season
ORDER BY total_sales DESC;


-- From fall season which item purchased highest

SELECT DISTINCT
    (season)
FROM
    customers;

-- all the item repective categories

-- SELECT season, category,item_purchased , sum(`purchase_amount_(usd)`) as total_sales, 
-- round(sum(`purchase_amount_(usd)`)*100/sum(sum(`purchase_amount_(usd)`)) over(),0) Percent_of_total FROM customers
-- where season = 'Fall'
-- group by category,season,item_purchased
-- order by category asc, total_sales desc;

-- Agg category sales and percentage

select season, category,sum(`purchase_amount_(usd)`) as total_sales, 
round(sum(`purchase_amount_(usd)`)*100/sum(sum(`purchase_amount_(usd)`)) over(),0) Percent_of_total FROM customers
where season = 'Fall'
group by category,season
order by category asc, total_sales desc;

select season,category, item_purchased,total_sales,percent_of_total from(
SELECT season, category,item_purchased , sum(`purchase_amount_(usd)`) as total_sales, 
round(sum(`purchase_amount_(usd)`)*100/sum(sum(`purchase_amount_(usd)`)) over(),0) percent_of_total,
dense_rank() over ( partition by category order by sum(`purchase_amount_(usd)`) desc) as split 
FROM customers
where season = 'Fall'
group by category,season,item_purchased
)t
where split <= 3
order by category asc, total_sales desc;
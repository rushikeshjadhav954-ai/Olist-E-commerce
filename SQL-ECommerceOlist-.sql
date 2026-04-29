create database olist_1;
use olist_1;
      -- KPI 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
SELECT 
CASE 
    WHEN DAYOFWEEK(purchase_datetime) IN (1,7)
    THEN 'Weekend'
    ELSE 'Weekday'
END AS Day_Type,
COUNT(o.order_id) AS Total_Orders,
SUM(p.payment_value) AS Total_Payment,
AVG(p.payment_value) AS Avg_Payment
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY Day_Type;
          
          
          -- KPI 2 Number of Orders with review score 5 and payment type as credit card.
SELECT 
r.review_score,
COUNT(DISTINCT r.order_id) AS total_orders
FROM olist_order_reviews_dataset r
JOIN olist_order_payments_dataset p
ON r.order_id = p.order_id
WHERE r.review_score = 5
AND p.payment_type = 'credit_card'
group by r.review_score;

          -- KPI 3 Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
p.product_category_name,
AVG(DATEDIFF(
STR_TO_DATE(o.order_delivered_customer_date,'%d-%m-%Y %H:%i'),
STR_TO_DATE(o.order_purchase_timestamp,'%d-%m-%Y %H:%i')
)) AS Avg_Delivery_Days
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
WHERE p.product_category_name = 'pet_shop'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY p.product_category_name;
          
-- KPI 4 Average price and payment values from customers of sao paulo city
select
round(avg(i.price)) AS avg_price,
round(avg(p.payment_value)) AS avg_payment
from olist_customers_dataset c
join olist_orders_dataset o 
on c.customer_id = o.customer_id
join olist_order_items_dataset i 
on o.order_id = i.order_id
join olist_order_payments_dataset p 
on o.order_id = p.order_id
where c.customer_city = 'sao paulo';
         
         -- 5 KPI Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select 
r.review_score,
round(avg(
datediff(
str_to_date(o.order_delivered_customer_date,'%d-%m-%Y %H:%i'),
str_to_date(o.order_purchase_timestamp,'%d-%m-%Y %H:%i')
)),0) as avg_shipping_days
from olist_orders_dataset o
join olist_order_reviews_dataset r
on o.order_id = r.order_id
where o.order_delivered_customer_date is not null
and o.order_purchase_timestamp is not null
group by r.review_score
order by r.review_score;





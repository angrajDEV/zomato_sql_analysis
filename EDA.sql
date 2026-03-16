select * from customers
where 
customer_name is null
or
reg_date is null;


select * from restaurants
where 
restaurant_name is null
or 
city is null
or
opening_hour is null;


select * from orders
where 
order_item is null
or 
order_date is null
or 
order_time is null
or 
order_status is null
or 
total_amount is null;


select * from riders
where
rider_name is null
or
sign_up is null;


SET SQL_SAFE_UPDATES = 0;

DELETE FROM deliveries
WHERE 
delivery_status IS NULL
OR 
delivery_time IS NULL
OR 
rider_id IS NULL;

----------------------------------------------------------------------------------------
-----------------------------      EDA      --------------------------------------------
----------------------------------------------------------------------------------------

--     1 write a query to find top 5 most frequently ordered dishes by a customer called 'priya mehta' in last 1 year . 

select o.order_item ,
count(*) as total_order from orders as o 
join
customers as c 
on c.customer_id = o.customer_id 
where c.customer_name = 'aarav sharma'
and year(o.order_date) = 2023
group by o.order_item
order by total_order desc
limit 5
;


--------------------------------------------------------------------------------------------------------
--   2 identify the time slots during which the most orders are placed , based on 2-hour interval
--------------------------------------------------------------------------------------------------------


select 
case 
	WHEN HOUR(o.order_time) BETWEEN 0 AND 2 THEN 'p1 (12AM - 2AM)'
	WHEN HOUR(o.order_time) BETWEEN 2 AND 4 THEN 'p2 (2AM - 4AM)'
	WHEN HOUR(o.order_time) BETWEEN 4 AND 6 THEN 'p3 (4AM - 6AM)'
	WHEN HOUR(o.order_time) BETWEEN 6 AND 8 THEN 'p4 (6AM - 8AM)'
	WHEN HOUR(o.order_time) BETWEEN 8 AND 10 THEN 'p5 (8AM - 10AM)'
	WHEN HOUR(o.order_time) BETWEEN 10 AND 12 THEN 'p6 (10AM - 12PM)'
	WHEN HOUR(o.order_time) BETWEEN 12 AND 14 THEN 'p7 (12PM - 14PM)'
	WHEN HOUR(o.order_time) BETWEEN 14 AND 16 THEN 'p8 (14PM - 16PM)'
	WHEN HOUR(o.order_time) BETWEEN 16 AND 18 THEN 'p9 (16PM - 18PM)'
	WHEN HOUR(o.order_time) BETWEEN 18 AND 20 THEN 'p10 (18PM - 20PM)'
	WHEN HOUR(o.order_time) BETWEEN 20 AND 22 THEN 'p11 (20PM - 22PM)'
	WHEN HOUR(o.order_time) BETWEEN 22 AND 24 THEN 'p12 (22PM - 24AM)'
end as hourly_parts,
count(*) as total_orders 
from orders as o
group by hourly_parts
order by total_orders desc;



---------------------------------------------------------------------------------------------------------
-- 		3. find the average value per customer who placed more than 10 order
---------------------------------------------------------------------------------------------------------

select c.customer_name,
count(*) ,
avg(o.total_amount)
from customers as c
join orders as o 
on c.customer_id = o.customer_id
group by c.customer_name
having count(order_id) > 10;

------------------------------------------------------------------------------------------------------------------------
-- 		4. list the customer who have spent more than 5k in total on food orders
------------------------------------------------------------------------------------------------------------------------

select 
c.customer_name,
sum(o.total_amount) as spent_on_food
from customers as c
join orders as o 
on c.customer_id = o.customer_id
group by c.customer_name
having sum(o.total_amount) > 5000;


-----------------------------------------------------------------------------------------------------
--		5. write a query to find orders that were placed but not deelivered
-----------------------------------------------------------------------------------------------------

select
r.restaurant_name ,
r.city,
o.order_status,
count(o.order_status) as cancelled_orders
from
orders as o
join
restaurants as r 
on 
o.restaurant_id = r.restaurant_id
group by r.restaurant_name,
r.city,o.order_status
having o.order_status = 'Cancelled';


select count(*) from orders where order_status = 'cancelled';
-----------------------------------------------------------------------------------------------------
--		6. rankk restaurants by their total revanue from the last year 
-----------------------------------------------------------------------------------------------------

select 
r.restaurant_name,
r.city,
sum(o.total_amount) as total_revanue,
rank() over (partition by r.city order by sum(o.total_amount) desc) as city_rank,
count(*) 
from restaurants as r
join 
orders as o 
on
r.restaurant_id = o.restaurant_id
group by r.restaurant_name,r.city
order by r.city , city_rank;


-------------------------------------------------------------------------------------------------------
--       7. the most popular dish in each city based on the number of orders
-------------------------------------------------------------------------------------------------------

select 
r.city,
o.order_item,
count(o.order_item) as dish_demand
from restaurants as r
join 
orders as o 
on r.restaurant_id = o.restaurant_id
group by r.city,o.order_item
order by dish_demand desc;


-------------------------------------------------------------------------------------------------------------
--      9. calculate and compare the order cancellation rate for each restaurant between this year and previous year
-------------------------------------------------------------------------------------------------------------

SELECT 
    r.restaurant_name,
    
    -- Current Year
    COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) AND o.order_status = 'Cancelled' THEN 1 END) AS cancelled_current_year,
    COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) THEN 1 END) AS total_current_year,
    ROUND(
        COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) AND o.order_status = 'Cancelled' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) THEN 1 END), 0), 2
    ) AS cancellation_rate_current_year,

    -- Previous Year
    COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) - 1 AND o.order_status = 'Cancelled' THEN 1 END) AS cancelled_prev_year,
    COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) - 1 THEN 1 END) AS total_prev_year,
    ROUND(
        COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) - 1 AND o.order_status = 'Cancelled' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN YEAR(o.order_date) = YEAR(CURDATE()) - 1 THEN 1 END), 0), 2
    ) AS cancellation_rate_prev_year

FROM orders AS o
JOIN restaurants AS r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY cancellation_rate_current_year DESC;














               -- Basic:
               
-- 1) Retrieve the total number of orders placed.
select count(order_id) as Total_orders from orders;

-- 2)Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(pz.price * od.quantity), 2) AS Revenue
FROM order_details AS od
JOIN pizzas AS pz ON pz.pizza_id = od.pizza_id;

-- 3) Identify the highest-priced pizza.
select pt.name, pz.price from pizza_types as pt
join pizzas as pz 
on pz.pizza_type_id = pt.pizza_type_id
where pz.price = (select max(price) from pizzas);

-- 4) Identify the most common pizza size ordered.
select quantity, count(order_details_id)
from order_details group by quantity;

-- 5) List the top 5 most ordered pizza types along with their quantities.
select pizza_types.pizza_type_id, sum(order_details.quantity) as qty from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.pizza_type_id
order by qty desc limit 5;


                           -- Intermediate:

-- 1) Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category;

-- 2) Determine the distribution of orders by hour of the day.(no. of order per hr.)
SELECT hour(order_time) as hour,count(order_id) as Orders FROM orders
group by hour(order_time) order by orders desc;

-- 3) Join relevant tables to find the category-wise distribution of pizzas.
select count(name),category from pizza_types
group by category;

-- 4) Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) as Avg_Qty_per_Day from  
(select  orders.order_date, sum(order_details.quantity) as quantity from orders
join order_details on order_details.order_id = orders.order_id
group by orders.order_date) as od_qty;

-- 5) Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, ROUND(SUM(order_details.quantity*pizzas.price),0) as REVENUE
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by REVENUE desc LIMIT 3;


                                   -- Advanced:


-- 1) Calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category ,
round((sum(order_details.quantity*pizzas.price)/ (select sum(order_details.quantity*pizzas.price) as total_revenue
from order_details join pizzas on pizzas.pizza_id = order_details.pizza_id)) *100, 2) as REVENUE
 FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by REVENUE desc;

-- 2) Analyze the cumulative revenue generated over time.
select order_date, 
round(sum(revenue) over(order by order_date),2) as Cummulative_revenue from
(select orders.order_date,  round(sum(order_details.quantity*pizzas.price),2) as revenue 
from order_details 
join pizzas 
on pizzas.pizza_id = order_details.pizza_id
join orders 
on orders.order_id = order_details.order_id
group by orders.order_date) as revenuez;

-- 3) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue, category from
(SELECT category, name, revenue,
rank() over(partition by category order by revenue desc) as Rnk from
(select pizza_types.category, 
pizza_types.name,
round(sum(order_details.quantity*pizzas.price),0) as REVENUE
from pizza_types join pizzas 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) AS a) as b
where Rnk > 3;


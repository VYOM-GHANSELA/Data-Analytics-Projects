# 1) All films with PG-13 films with rental rate of 2.99 or lower
SELECT title, rating, rental_rate FROM film
where rental_rate <=2.99 and rating = "PG-13";


# 2)All films that have deleted scenes
select title, special_features from film
where special_features like "%deleted scenes%";


# 3) All active customers
select customer_id, concat(first_name," " ,last_name) as Customers_Name, active from customer
where active = 1;


# 4)Names of customers who rented a movie on 26th July 2005-- 
select customer.customer_id, concat(customer.first_name," " ,customer.last_name) as Customers_Name, 
rental.rental_date
from customer join rental 
on rental.customer_id = customer.customer_id
where date(rental.rental_date) = '2005-07-26';


# 5) Distinct names of customers who rented a movie on 26th July 2005
select  distinct(concat(customer.first_name," " ,customer.last_name)) as Customers_Name, 
rental.rental_date
from customer join rental 
on rental.customer_id = customer.customer_id
where date(rental.rental_date) = '2005-07-26';


# 6) How many rentals we do on each day?
select count(*), date(rental_date) from rental
group by date(rental_date)
order by count(*) desc;


# 7) All Sci-fi films in our catalogue
select film.title, film.film_id, category.name from film
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.category_id = 14;


# 8) Customers and how many movies they rented from us so far?
SELECT customer.customer_id, 
concat(customer.first_name, ' ', customer.last_name) as customerz ,
count(rental.rental_id)
FROM sakila.customer join rental on rental.customer_id = customer.customer_id
group by customer.customer_id
order by count(rental.rental_id) desc;


# 9) Which movies should we discontinue from our catalogue (less than 5 lifetime rentals)
SELECT f.film_id, f.title, COUNT(r.rental_id) AS time_rented
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING time_rented < 5
ORDER BY time_rented ASC;


 # 10) Which movies are not returned yet
select f.film_id, f.title from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
where return_date is null
order by f.title; 

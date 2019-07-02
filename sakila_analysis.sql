USE sakila;

-- First and last name of all actors
SELECT first_name, last_name
FROM actor;

-- First and last name of all actors
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- ID number, first name, last name of Joe
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- First name and last name of last names that contain 'GEN'
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- First name and last name of last names that contain 'LI'
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

-- Country id and country of Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- Adding a column to the actor table
ALTER TABLE actor
ADD COLUMN description BLOB;

-- Deleting the description column of actor table
ALTER TABLE actor
DROP description;

-- Displaying the actor table
SELECT * FROM actor;

-- Count all the last names and display the count 
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- All last names that are common in more than one actor
SELECT last_name, COUNT(*) AS actor_cnt
FROM actor
GROUP BY last_name
HAVING actor_cnt > 1;

-- Replace first name as HARPO 
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Replace first name as GROUCHO
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

SHOW CREATE TABLE actor;
-- CREATE TABLE `actor` (
--   `actor_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `first_name` varchar(45) NOT NULL,
--   `last_name` varchar(45) NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--    PRIMARY KEY (`actor_id`),
--    KEY `idx_actor_last_name` (`last_name`)
--    ) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8;

-- Display first name, last name, and address by joining 2 tables
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;

-- Display first name and last name of each staff member and how much each rung up
-- In the month of August
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_rung_up
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '%2005-08-%'
GROUP BY s.staff_id;

-- Display film and how many actors appeared in each film
SELECT f.title, COUNT(fa.actor_id) AS actor_cnt
FROM film f INNER JOIN film_actor fa on f.film_id = fa.film_id
GROUP BY f.title;

-- Number of copies in the inventory of Hunchback Impossible
SELECT f.title, COUNT(f.title) AS film_cnt
FROM film f INNER JOIN inventory i on f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- Total paid by each customer
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c INNER JOIN payment p ON (c.customer_id = p.customer_id)
GROUP BY c.customer_id
ORDER BY last_name; 

-- Films in English that start with a K or Q
SELECT f.title
FROM film f
WHERE f.title LIKE 'K%' OR f.title LIKE 'Q%'
AND language_id IN (
	SELECT language_id
    FROM language
    WHERE name = 'English'
);

-- Name of actors in the film Alone Trip
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
	)
);

-- Name and emails of customers in Canada
SELECT first_name, last_name, email, country
FROM customer
INNER JOIN address 
ON address.address_id = customer.address_id
INNER JOIN city 
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Canada';

-- Display all family films
SELECT title, category.name
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- Most frequently rented movies
SELECT title, COUNT(title) AS inventory_cnt
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY inventory_cnt desc;

-- The amount (in dollars) each store brought in 
SELECT store.store_id, SUM(amount) AS total_business
FROM payment
INNER JOIN staff
ON payment.staff_id = staff.staff_id
INNER JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- Display store ID, city, and country
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

-- Create a view with top film categories in revenue 
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(amount) AS gross_revenue
FROM payment
INNER JOIN rental
ON payment.rental_id = rental.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY gross_revenue desc
LIMIT 5;

-- Display the view 
SELECT * FROM top_five_genres;

-- Delete the view
DROP VIEW top_five_genres;


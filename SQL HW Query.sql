--Call DB
USE sakila;

-- Exercise 1a.
SELECT first_name, last_name FROM ACTOR;

-- Exercise 1b.
SELECT upper(concat(first_name, ' ', last_name )) as full_name FROM ACTOR;

-- Exercise 2a. 
SELECT actor_id, first_name, last_name FROM ACTOR WHERE first_name = 'Joe';

-- Exercise 2b. 
SELECT * FROM ACTOR WHERE last_name LIKE '%gen%';

-- Exercise 2c.
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- Exercise 2d. 
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- Exercise 3a.
ALTER TABLE actor ADD COLUMN description BLOB;

-- Exercise 3b. 
ALTER TABLE actor DROP COLUMN description;

-- Exercise 4a. 
SELECT last_name, COUNT(last_name) AS 'count' FROM actor GROUP BY last_name;

-- Exercise 4b. 
SELECT last_name, COUNT(last_name) AS 'count_' FROM actor GROUP BY last_name HAVING count_ > 1;

-- Exercise 4c. 
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Exercise 4d. 
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';

--  Exercise 5a. 
SHOW CREATE TABLE address;
SELECT * FROM address;

-- Exercise 6a. 
SELECT s.first_name, s.last_name, a.address FROM staff AS s INNER JOIN address AS a
ON s.address_id = a.address_id;

-- Exercise 6b. 
SELECT s.first_name, s.last_name, SUM(p.amount) FROM staff AS s LEFT JOIN payment AS p
ON s.staff_id = p.staff_id
WHERE YEAR(p.payment_date) = '2005' AND MONTH(p.payment_date) = '8'
GROUP BY s.staff_id;


-- Exercise 6c. 
SELECT f.title, COUNT(fa.film_id) AS 'actor_count' FROM film AS f INNER JOIN film_actor AS fa
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. 
SELECT f.title, COUNT(i.film_id) AS inventory FROM film AS f JOIN inventory AS i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- Exercise 6e.
SELECT c.last_name, c.first_name, SUM(p.amount) AS 'total_paid' FROM customer AS c INNER JOIN payment as p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- Exercise 7a. 
SELECT count(title) FROM film WHERE title LIKE 'k%' OR title LIKE 'q%'
	AND language_id IN (SELECT language_id  FROM language WHERE language_id = 'English');

-- Exercise 7b. 
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id IN 
	(SELECT actor_id FROM film_actor WHERE film_id IN
		(SELECT film_id FROM film WHERE title = 'Alone Trip'));


-- Exercise 7c. 
SELECT cu.first_name, cu.last_name, cu.email, country.country FROM customer AS cu
	JOIN address ON cu.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
	WHERE country.country = 'Canada';

-- Exercise 7d. 
SELECT title FROM film 
	JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
	WHERE category.name = 'Family';

-- Exercise 7e.
SELECT film.title, COUNT(rental.rental_id) AS 'rental_count' FROM rental
	JOIN inventory AS i ON rental.inventory_id = i.inventory_id
	JOIN film ON film.film_id = i.film_id
	GROUP BY film.film_id
	ORDER BY rental_count DESC;

-- Exercise 7f. 
SELECT store.store_id, SUM(amount) as total FROM store 
	INNER JOIN staff ON store.store_id = staff.store_id
	INNER JOIN payment AS p ON p.staff_id = staff.staff_id
	GROUP BY store.store_id
	ORDER BY total;

-- Exercise 7g. 
SELECT s.store_id, city, country FROM store AS s
	INNER JOIN customer AS cu ON s.store_id = cu.store_id
	INNER JOIN staff st ON s.store_id = st.store_id
	INNER JOIN address AS a ON cu.address_id = a.address_id
	INNER JOIN city AS ci ON a.city_id = ci.city_id
	INNER JOIN country AS coun ON ci.country_id = coun.country_id;

-- Exercise 7h. 
SELECT c.name as "Genre", SUM(p.amount) as Total FROM category AS c 
	INNER JOIN film_category AS fc ON c.category_id = fc.category_id
	INNER JOIN film AS f ON fc.film_id = f.film_id
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
	INNER JOIN payment AS p ON r.rental_id = p.rental_id
	GROUP BY c.name
	ORDER BY Total DESC
	LIMIT 5;


-- Exercise 8a.
CREATE VIEW top_five_genres AS
	SELECT name, SUM(p.amount) as Total FROM category c
	INNER JOIN film_category fc ON fc.category_id = c.category_id
	INNER JOIN inventory i ON i.film_id = fc.film_id
	INNER JOIN rental r ON r.inventory_id = i.inventory_id
	INNER JOIN payment p ON r.rental_id = p.rental_id
	GROUP BY name;
-- Exercise 8b. 
SELECT * FROM top_five_genres;

-- Exercise 8c. 
DROP VIEW top_five_genres;

-- ==========================================
-- MOVIE ANALYTICS SQL PROJECT
-- Comprehensive SQL Queries on Movie Dataset
-- ==========================================

-- 1. Retrieve all movie records
SELECT * FROM movies;

-- 2. Filter movies by industry
SELECT * FROM movies WHERE industry = 'bollywood';
SELECT * FROM movies WHERE industry = 'hollywood';

-- 3. Search movies by keywords in title
SELECT * FROM movies WHERE title LIKE '%thor%';
SELECT * FROM movies WHERE title LIKE '%america%';

-- 4. Find movies with missing studio data
SELECT * FROM movies WHERE studio = '';

-- 5. Order movies by release year (latest first)
SELECT title, release_year FROM movies ORDER BY release_year DESC;

-- 6. Movies released in specific years
SELECT * FROM movies WHERE release_year IN (2019, 2020, 2022);

-- 7. Movies released after 2020 with IMDb rating > 8
SELECT * FROM movies WHERE release_year > 2020 AND imdb_rating > 8;

-- 8. Movies with NULL IMDb rating
SELECT * FROM movies WHERE imdb_rating IS NULL;

-- 9. Count of Bollywood movies
SELECT COUNT(*) FROM movies WHERE industry LIKE 'bollywood';

-- 10. Maximum and minimum IMDb ratings
SELECT MAX(imdb_rating) AS max_rating, MIN(imdb_rating) AS min_rating FROM movies;

-- 11. Average IMDb rating for a specific studio
SELECT ROUND(AVG(imdb_rating), 2) AS avg_rating 
FROM movies WHERE studio = 'Hombale Films';

-- 12. Movie count by studio (sorted)
SELECT studio, COUNT(*) AS cnt 
FROM movies 
GROUP BY studio 
ORDER BY cnt DESC;

-- 13. Number of movies by industry with average rating
SELECT industry, COUNT(industry) AS cnt, ROUND(AVG(imdb_rating), 2) AS avg_rating 
FROM movies 
GROUP BY industry;

-- 14. Profit percentage calculation for each movie
SELECT m.title, f.budget, f.revenue, 
ROUND(((f.revenue - f.budget) / f.budget) * 100, 0) AS profit_percentage
FROM movies m
JOIN financials f ON m.movie_id = f.movie_id;

-- 15. Revenue in INR (if currency is USD)
SELECT *, 
       IF(currency = 'usd', revenue * 86, revenue) AS revenue_inr 
FROM financials;

-- 16. Revenue normalization to millions based on units
SELECT *, 
       CASE 
           WHEN unit = 'billions' THEN revenue * 1000 
           WHEN unit = 'thousands' THEN revenue / 1000 
           ELSE revenue 
       END AS revenue_mln 
FROM financials;

-- 17. Inner join: movies with financials
SELECT m.movie_id, m.title, f.budget, f.revenue, f.currency, f.unit
FROM movies m
INNER JOIN financials f ON m.movie_id = f.movie_id;

-- 18. Left join: all movies including those without financials
SELECT m.movie_id, m.title, f.budget, f.revenue, f.currency, f.unit
FROM movies m
LEFT JOIN financials f ON m.movie_id = f.movie_id;

-- 19. Right join: all financials including those without movie details
SELECT f.movie_id, m.title, f.budget, f.revenue, f.currency, f.unit
FROM movies m
RIGHT JOIN financials f ON m.movie_id = f.movie_id;

-- 20. Profit (normalized to millions) with unit adjustment
SELECT m.movie_id, m.title, f.budget, f.revenue, f.currency, f.unit, 
       CASE 
           WHEN unit = 'thousands' THEN ROUND((revenue - budget) / 1000, 0)
           WHEN unit = 'billions' THEN ROUND((revenue - budget) * 1000, 0)
           ELSE ROUND((revenue - budget), 0)
       END AS profit_mln
FROM movies m
JOIN financials f ON m.movie_id = f.movie_id
ORDER BY profit_mln DESC;

-- 21. List of actors per movie
SELECT m.title, GROUP_CONCAT(a.name SEPARATOR ' | ') AS actors
FROM movies m
JOIN movie_actor ma ON m.movie_id = ma.movie_id
JOIN actors a ON a.actor_id = ma.actor_id
GROUP BY m.movie_id;

-- 22. Movies in Hindi sorted by revenue (in millions)
SELECT m.title, f.revenue, f.currency, f.unit,
       CASE 
           WHEN unit = 'Thousands' THEN ROUND(revenue / 1000, 1) 
           WHEN unit = 'billions' THEN ROUND(revenue * 1000, 1) 
           ELSE ROUND(revenue, 1) 
       END AS revenue_mln 
FROM movies m 
JOIN financials f ON f.movie_id = m.movie_id 
JOIN languages l ON l.language_id = m.language_id 
WHERE l.name = 'hindi' 
ORDER BY revenue_mln DESC;

-- 23. Movies with the highest and lowest IMDb rating
SELECT * FROM movies WHERE imdb_rating = (SELECT MAX(imdb_rating) FROM movies);
SELECT * FROM movies WHERE imdb_rating = (SELECT MIN(imdb_rating) FROM movies);

-- 24. Movies with IMDb rating above average
SELECT * FROM movies 
WHERE imdb_rating > (SELECT AVG(imdb_rating) FROM movies);

-- 25. Movies released in earliest and latest years
SELECT title FROM movies 
WHERE release_year = (SELECT MAX(release_year) FROM movies) 
   OR release_year = (SELECT MIN(release_year) FROM movies);

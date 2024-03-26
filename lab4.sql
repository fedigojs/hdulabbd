--1
SELECT COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1;
--2
SELECT COUNT(*)
FROM Lab1
WHERE price_currency IS NOT NULL;
--3
SELECT novelty, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY novelty;
--4
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year
ORDER BY year;
--5
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
WHERE price_currency NOT BETWEEN 10 AND 20
GROUP BY year
ORDER BY year;
--6
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*) AS total_books
FROM Lab1
GROUP BY year
ORDER BY total_books DESC;
--7
SELECT COUNT(*) AS total_codes, COUNT(DISTINCT code) AS unique_codes
FROM Lab1;
--8
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
GROUP BY first_letter;
--9
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%'
GROUP BY first_letter;
--10
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%' AND EXTRACT(YEAR FROM eventDate) > 2000
GROUP BY first_letter;
--11
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%' AND EXTRACT(YEAR FROM eventDate) > 2000
GROUP BY first_letter
ORDER BY first_letter DESC;
--12
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year, month
ORDER BY year, month;
--13
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
WHERE eventDate IS NOT NULL
GROUP BY year, month
ORDER BY year, month;
--14
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year, month
ORDER BY year DESC, month ASC;
--15
SELECT novelty, SUM(price_currency) AS total_price_usd, SUM(price_currency)*30 AS total_price_uah, SUM(price_currency)/0.9 AS total_price_eur, SUM(price_currency)*70 AS total_price_rub
FROM Lab1
GROUP BY novelty;
--16
SELECT novelty, ROUND(SUM(price_currency)) AS rounded_total_price_usd, ROUND(SUM(price_currency)*30) AS rounded_total_price_uah, ROUND(SUM(price_currency)/0.9) AS rounded_total_price_eur, ROUND(SUM(price_currency)*70) AS rounded_total_price_rub
FROM Lab1
GROUP BY novelty;
--17
SELECT publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY publisher;
--18
SELECT theme, publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY theme, publisher;
--19
SELECT category, theme, publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY category, theme, publisher;
--20
SELECT publisher, ROUND(AVG(price_currency/pages), 2) AS avg_price_per_page
FROM Lab1
GROUP BY publisher
HAVING ROUND(AVG(price_currency/pages), 2) > 0.10;




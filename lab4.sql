--1 Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну
SELECT COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1;

--2 Вивести загальну кількість всіх книг без урахування книг з непроставленою ціною
SELECT COUNT(*)
FROM Lab1
WHERE price_currency IS NOT NULL;

--3 Вивести статистику (див. 1) для книг новинка / не новинка
SELECT novelty, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY novelty;

----МЕДИАНА
WITH OrderedPrices AS (
    SELECT price_currency,
           ROW_NUMBER() OVER (ORDER BY price_currency) AS RowAsc,
           ROW_NUMBER() OVER (ORDER BY price_currency DESC) AS RowDesc
    FROM Books
    WHERE price_currency IS NOT NULL
)
SELECT AVG(price_currency) AS Median
FROM OrderedPrices
WHERE RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1);


--4 Вивести статистику (див. 1) для книг за кожним роком видання
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year
ORDER BY year;

--5 Змінити п.4, виключивши з статистики книги з ціною від 10 до 20
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
WHERE price_currency NOT BETWEEN 10 AND 20
GROUP BY year
ORDER BY year;

--6 Змінити п.4. Відсортувати статистику по спадаючій кількості.
SELECT EXTRACT(YEAR FROM eventDate) AS year, COUNT(*) AS total_books
FROM Lab1
GROUP BY year
ORDER BY total_books DESC;

--7 Вивести загальну кількість кодів книг і кодів книг що не повторюються
SELECT COUNT(*) AS total_codes, COUNT(DISTINCT code) AS unique_codes
FROM Lab1;

--8 Вивести статистику: загальна кількість і вартість книг по першій букві її назви
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
GROUP BY first_letter;

--9 Змінити п. 8, виключивши з статистики назви що починаються з англ. букви або з цифри.
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%'
GROUP BY first_letter;

--10 Змінити п. 9 так щоб до складу статистики потрапили дані з роками більшими за 2000.
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%' AND EXTRACT(YEAR FROM eventDate) > 2000 --NOT SIMILAR TO '[A-Za-z0-9\u0410-\u044F]%' -все и кирилица и латиница Unicode

GROUP BY first_letter;

--11 Змінити п. 10. Відсортувати статистику по спадаючій перших букв назви.
SELECT LEFT(title, 1) AS first_letter, COUNT(*), SUM(price_currency)
FROM Lab1
WHERE LEFT(title, 1) NOT SIMILAR TO '[A-Za-z0-9]%' AND EXTRACT(YEAR FROM eventDate) > 2000
GROUP BY first_letter
ORDER BY first_letter DESC;

--12 Вивести статистику (див. 1) по кожному місяцю кожного року.
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year, month
ORDER BY year, month;

--13 Змінити п. 12 так щоб до складу статистики не увійшли дані з незаповненими датами.
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
WHERE eventDate IS NOT NULL
GROUP BY year, month
ORDER BY year, month;

--14 Змінити п. 12. Фільтр по спадаючій року і зростанню місяця.
SELECT EXTRACT(YEAR FROM eventDate) AS year, EXTRACT(MONTH FROM eventDate) AS month, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY year, month
ORDER BY year DESC, month ASC;

--15 Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро . Колонкам запиту дати назви за змістом
SELECT novelty, SUM(price_currency) AS total_price_usd, SUM(price_currency)*30 AS total_price_uah, SUM(price_currency)/0.9 AS total_price_eur, SUM(price_currency)*70 AS total_price_rub
FROM Lab1
GROUP BY novelty;

--16 Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / ) Ціна.
SELECT novelty, ROUND(SUM(price_currency)) AS rounded_total_price_usd, ROUND(SUM(price_currency)*30) AS rounded_total_price_uah, ROUND(SUM(price_currency)/0.9) AS rounded_total_price_eur, ROUND(SUM(price_currency)*70) AS rounded_total_price_rub
FROM Lab1
GROUP BY novelty;

--17 Вивести статистику (див. 1) по видавництвах.
SELECT publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY publisher;

--18 Вивести статистику (див. 1) за темами і видавництвами. Фільтр по видавництвам.
SELECT theme, publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY theme, publisher;

--19 Вивести статистику (див. 1) за категоріями, темами і видавництвами. Фільтр по видавництвам, темах, категоріям.
SELECT category, theme, publisher, COUNT(*), SUM(price_currency), AVG(price_currency), MIN(price_currency), MAX(price_currency)
FROM Lab1
GROUP BY category, theme, publisher;

--20 Вивести список видавництв, у яких округлена до цілого ціна однієї сторінки більше 10 копійок.
SELECT publisher, ROUND(AVG(price_currency/pages), 2) AS avg_price_per_page
FROM Lab1
GROUP BY publisher
HAVING ROUND(AVG(price_currency/pages), 2) > 0.10;







--1
SELECT 
    recordNumber, 
    code,
    novelty, 
    title, 
    price_currency, 
    pages 
FROM 
    lab1;
--2
SELECT * FROM lab1;
--3
SELECT 
    code, 
    title, 
    novelty, 
    pages, 
    price_currency, 
    recordNumber 
FROM 
    lab1;
--4
SELECT * FROM lab1 LIMIT 10;
--5
SELECT * FROM Lab1
LIMIT (SELECT ROUND(COUNT(*) * 0.1) FROM Lab1);
--6
SELECT DISTINCT code FROM Lab1 ORDER BY code;
--7
SELECT * FROM  Lab1 WHERE novelty = TRUE;
--8
SELECT * FROM Lab1 
WHERE price_currency BETWEEN 20 AND 30;
--9
SELECT * FROM Lab1
WHERE price_currency < 20 
OR price_currency > 30
ORDER BY price_currency;
--10
SELECT * FROM Lab1
WHERE pages BETWEEN 300 AND 400 
AND
price_currency < 20 
OR price_currency > 30
ORDER BY price_currency;
--11
SELECT * FROM Lab1
WHERE strftime('%Y' , eventDate) = '2000'
AND (strftime('%m' , eventDate) = '12' OR strftime('%m' , eventDate) = '01' OR strftime('%m' , eventDate) = '02');
--12
SELECT * FROM Lab1
WHERE 
	code = '5110' OR
	code = '5141' OR
	code = '4985' OR
	code = '4241';
--13
SELECT * FROM Lab1
WHERE strftime('%Y', eventDate) BETWEEN '1999' AND '2005';
--14
SELECT * FROM Lab1
WHERE title >= 'А' AND title < 'Л'
ORDER BY title;
--15
SELECT * FROM Lab1
WHERE title LIKE 'А%' 
  AND strftime('%Y', eventDate) = '2000'
  AND price_currency < 20;
--16
SELECT * FROM Lab1
WHERE title LIKE 'А%' AND title LIKE '%e' 
  AND strftime('%Y', eventDate) = '2000'
  AND strftime('%m', eventDate) BETWEEN '01' AND '06'; -- нет свопадений
--17
SELECT * FROM Lab1
WHERE title LIKE '%Microsoft%'
AND title NOT LIKE '%Windows%'
ORDER BY title; -- нет свопадений 
--18
SELECT * FROM Lab1
WHERE title LIKE '%0%'
   OR title LIKE '%1%'
   OR title LIKE '%2%'
   OR title LIKE '%3%'
   OR title LIKE '%4%'
   OR title LIKE '%5%'
   OR title LIKE '%6%'
   OR title LIKE '%7%'
   OR title LIKE '%8%'
   OR title LIKE '%9%'
ORDER BY title;
-- или
SELECT * FROM Lab1
WHERE title REGEXP '[0-9]';
--19
SELECT * FROM Lab1
WHERE title REGEXP '[0-9].*[0-9].*[0-9]'; -- регулярные выражения
--20
SELECT * FROM Lab1
WHERE title REGEXP '[0-9].*[0-9].*[0-9].*[0-9].*[0-9]'
AND NOT title REGEXP '[0-9].*[0-9].*[0-9].*[0-9].*[0-9].*[0-9]';




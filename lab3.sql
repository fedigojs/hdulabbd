CREATE TABLE IF NOT EXISTS Lab1 (
    recordNumber SERIAL PRIMARY KEY,
    code INTEGER,
    novelty BOOLEAN DEFAULT FALSE,
    title TEXT CHECK(length(title) <= 200) NOT NULL,
    price_currency DECIMAL(10, 2),
    publisher TEXT CHECK(length(publisher) <= 200),
    pages INTEGER NOT NULL,
    size TEXT,
    eventDate DATE,
    circulation INTEGER DEFAULT 5000,
    theme TEXT CHECK(length(theme) <= 100) NOT NULL,
    category TEXT CHECK(length(category) <= 100) NOT NULL
);

INSERT INTO Lab1 (recordNumber, code, novelty, title, price_currency, publisher, pages, size, eventDate, circulation, theme, category) VALUES 
(2, 5110, FALSE, 'Апаратні засоби мультимедіа. Відеосистема РС', '15.51', 'Видавнича група BHV', '400', '70х100/16', '2000-07-24', 5000, 'Використання ПК в ціломy', 'Підручники'),
(8, 4985, FALSE, 'Засоби самостійної модернізації та ремонт ПК за 24 години, 2-ге вид.', '18.90', 'Вільямс', 288, '70x100/16', '2000-07-07', 5000, 'Використання ПК в цілому', 'Підручники'),
(9, 5141, FALSE, 'Структури даних та алгоритми', '37.80', 'Вільямс', 384, '70x100/16', '2000-09-29', 5000, 'Використання ПК в цілому', 'Підручники'),
(20, 5127, FALSE, 'Автоматизація інженерно-графічних робіт', '11.58', 'Видавнича група BHV', 256, '70x100/16', '2000-06-15', 5000, 'Використання ПК в цілому', 'Підручники'),
(31, 5110, FALSE, 'Апаратні засоби мультимедіа. Відеосистема PC', '15.51', 'Видавнича група BHV', 400, '70x100/16', '2000-07-24', 5000, 'Апаратні засоби ПК', 'Підручники'),
(46, 5199, FALSE, 'Залізо IBM 2001', '30.07', 'МікроАрт', 368, '70x100/16', '2000-12-02', 5000, 'Апаратні засоби ПК', 'Підручники'),
(50, 3851, FALSE, 'Захист інформації та безпека комп''ютерних систем', '26.00', 'DiaSoft', 480, '84x108/16', NULL, 5000, 'Захист і безпека ПК', 'Підручники'),
(58, 3932, FALSE, 'Як перетворити персональний комп''ютер на віртуальний комплекс', '7.65', 'ДМК', 144, '60x88/16', '1999-06-09', 5000, 'Інші книги', 'Підручники'),
(59, 4713, FALSE, 'Plug-ins. Додаткові програми для музичних програм', '11.41', 'ДМК', 144, '70x100/16', '2000-02-22', 5000, 'Інші книги', 'Підручники'),
(175, 5217, FALSE, 'Windows ME. Найновіша версія програм', '16.57', 'Тріумф', 320, '70x100/16', '2000-08-25', 5000, 'Операційні системи', 'Windows 2000'),
(176, 4829, FALSE, 'Windows 2000 Professional крок за кроком 3 CD', '27.25', 'Еком', 320, '70x100/16', '2000-04-28', 5000, 'Операційні системи', 'Windows 2000'),
(188, 5170, FALSE, 'Linux версії', '24.43', 'ДМК', 346, '70x100/16', '2000-09-29', 5000, 'Операційні системи', 'Linux'),
(191, 860, FALSE, 'Операційна система UNIX', '3.50', 'Видавнича група BHV', 395, '84x100/16', '1997-05-05', 5000, 'Операційні системи', 'Unix'),
(203, 44, FALSE, 'Відповіді на актуальні запитання щодо OS/2 Warp', '5.00', 'DiaSoft', 352, '60x84/16', '1996-03-20', 5000, 'Операційні системи', 'Інші операційні системи'),
(206, 5176, FALSE, 'Windows Me. Супутник користувача', '12.79', 'Видавнича група BHV', 306, '70x100/16', '2000-10-10', 5000, 'Операційні системи', 'Інші операційні системи'),
(209, 5462, FALSE, 'Мова програмування C++. Лекції та практи', '29.00', 'DiaSoft', 656, '84x108/16', '2000-12-12', 5000, 'Програмування', 'C&C++'),
(210, 4982, FALSE, 'Мова програмування C. Лекції та практи', '29.00', 'DiaSoft', 432, '84x108/16', '2000-07-12', 5000, 'Програмування', 'C&C++'),
(220, 4687, FALSE, 'Ефективне використання C++. 50 рекомендацій щодо покращення ваших програм та проектів', '17.60', 'ДМК', 240, '70x100/16', '2000-02-03', 5000, 'Програмування', 'C&C++'),
(222, 235, FALSE, 'Інформаційні системи і структури даних', NULL, 'Києво-Могилянська академія', 288, '60x90/16', NULL, 400, 'Використання ПК в цілому', 'Інші книги'),
(225, 8746, TRUE, 'Бази даних в інформаційних системах', NULL, 'Університет ''Україна''', 418, '60x84/16', '2018-07-25', 100, 'Програмування', 'SQL'),
(226, 2154, TRUE, 'Сервер на основі операційної системи FreeBSD 6.1', '0', 'Університет ''Україна''', 216, '60x84/16', '2015-03-11', 500, 'Програмування', 'Інші операційні системи'),
(245, 2662, FALSE, 'Організація баз даних та знань', '0', 'Вінниця: ВДТУ', 208, '60x90/16', '2001-10-10', 1000, 'Програмування', 'SQL'),
(247, 5641, TRUE, 'Організація баз даних та знань', '0', 'Видавнича група BHV', 384, '70x100/16', '2021-12-15', 5000, 'Програмування', 'SQL');


--POSTGRESQL
--1
SELECT * FROM Lab1 WHERE price_currency IS NULL OR price_currency = 0;

--2
SELECT * FROM Lab1 WHERE price_currency IS NOT NULL AND circulation IS NULL;

--3
SELECT * FROM Lab1 WHERE eventDate IS NULL;

--4
SELECT * FROM Lab1 WHERE eventDate >= current_date - INTERVAL '1 year';

--5
SELECT * FROM Lab1 WHERE novelty = TRUE ORDER BY price_currency ASC;

--6
SELECT * FROM Lab1 WHERE pages BETWEEN 300 AND 400 ORDER BY title DESC;

--7
SELECT * FROM Lab1 WHERE price_currency BETWEEN 20 AND 40 ORDER BY eventDate DESC;

--8
SELECT * FROM Lab1 ORDER BY title ASC, price_currency DESC;

--9
SELECT * FROM Lab1 WHERE (price_currency / pages) < 0.1;

--10
SELECT length(title), upper(left(title, 20)) FROM Lab1;

--11
SELECT lower(left(title, 10)) || '...' || lower(right(title, 10)) FROM Lab1;

--12
SELECT title, eventDate, EXTRACT(day FROM eventDate), EXTRACT(month FROM eventDate), EXTRACT(year FROM eventDate) FROM Lab1;

--13
SELECT title, eventDate, TO_CHAR(eventDate, 'DD / MM / YYYY') FROM Lab1;

--14
SELECT 
    code, 
	title,
    price_currency AS price_usd, 
    price_currency * 38 AS price_uah, 
    ROUND(price_currency / 0.92, 2) AS price_eur
FROM Lab1;

--15
SELECT 
	code, 
	price_currency, 
	TRUNC(price_currency * 38) AS price_ua, 
	ROUND(price_currency * 38) AS prise_ua 
FROM Lab1;

--16
INSERT INTO Lab1 (code, novelty, title, price_currency, publisher, pages, size, eventDate, circulation, theme, category)
VALUES (556677, TRUE, 'Жил Был Пес', 40, 'Херсон Компани', 400, '70x100/16', '2024-03-26', 5000, 'Фантазии', 'Фантастика');

--17
INSERT INTO Lab1 (title, pages, theme, category)
VALUES ('Тролли у Оли', 23, 'Тема', 'Категория');

--18
DELETE FROM Lab1 WHERE eventDate < '1990-01-01';

--19
UPDATE Lab1 SET eventDate = current_date WHERE eventDate IS NULL;

--20
UPDATE Lab1 SET novelty = TRUE WHERE eventDate > '2005-12-31';


-- Active: 1713084570414@@127.0.0.1@5432@hdu
--1 -- неявный метод соединения устарел
SELECT b.Title, b.Price_Currency, p.PublisherName
FROM Books b, Publishers p
WHERE b.PublisherID = p.PublisherID;
--современный способ соединения ЯВНЫЙ метод  LEFT JOIN, RIGHT JOIN, FULL JOIN
SELECT b.Title, b.Price_Currency, p.PublisherName
FROM Books b
JOIN Publishers p ON b.PublisherID = p.PublisherID;

--2
SELECT b.Title, c.CategoryDescription
FROM Books b
INNER JOIN Categories c ON b.CategoryID = c.CategoryID; 

--3
SELECT b.Title, b.Price_Currency, p.PublisherName, b.Size
FROM Books b
INNER JOIN Publishers p ON b.PublisherID = p.PublisherID;

--4
SELECT th.ThemeDescription, c.CategoryDescription, b.Title, p.PublisherName
FROM Books b
INNER JOIN Themes th ON b.ThemeID = th.ThemeID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
INNER JOIN Publishers p ON b.PublisherID = p.PublisherID;

--5
SELECT b.Title
FROM Books b
INNER JOIN Publishers p ON b.PublisherID = p.PublisherID
WHERE p.PublisherName = 'BHV' AND b.EventDate > '2000-01-01';

--6
SELECT c.CategoryDescription, SUM(b.Pages) AS TotalPages
FROM Books b
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
GROUP BY c.CategoryDescription
ORDER BY TotalPages DESC;

--7
SELECT AVG(b.Price_Currency) AS AvgPrice
FROM Books b
INNER JOIN Themes th ON b.ThemeID = th.ThemeID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE th.ThemeDescription = 'Использование ПК' AND c.CategoryDescription = 'Linux';

--8
SELECT
    b.*,
    p.PublisherName,
    th.ThemeDescription,
    c.CategoryDescription
FROM
    Books b,
    Publishers p,
    Themes th,
    Categories c
WHERE
    b.PublisherID = p.PublisherID AND
    b.ThemeID = th.ThemeID AND
    b.CategoryID = c.CategoryID;

--9

SELECT
    b.*,
    p.PublisherName,
    th.ThemeDescription,
    c.CategoryDescription
FROM
    Books b
INNER JOIN Publishers p ON b.PublisherID = p.PublisherID
INNER JOIN Themes th ON b.ThemeID = th.ThemeID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;

--10

SELECT
    b.*,
    p.PublisherName,
    th.ThemeDescription,
    c.CategoryDescription
FROM
    Books b
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Themes th ON b.ThemeID = th.ThemeID
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID;

--11
SELECT a.Title AS Book1, b.Title AS Book2
FROM Books a
JOIN Books b ON a.Pages = b.Pages AND a.BookID < b.BookID;

--12
SELECT
    b1.Title AS Book1,
    b1.bookid AS BOOK_ID1,
    b2.Title AS Book2,
    b2.bookid AS BOOK_ID2,
    b3.Title AS Book3,
    b3.bookid AS BOOK_ID3,
    b1.Price_Currency
FROM
    Books b1
INNER JOIN Books b2 ON b1.Price_Currency = b2.Price_Currency AND b1.BookID < b2.BookID
INNER JOIN Books b3 ON b1.Price_Currency = b3.Price_Currency AND b2.BookID < b3.BookID
ORDER BY
    b1.Price_Currency, b1.Title;

--13
SELECT Title FROM Books
WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryDescription = 'C ++');

--14

SELECT b.Title
FROM Books b
WHERE b.PublisherID IN (
    SELECT p.PublisherID FROM Publishers p WHERE p.PublisherName = 'BHV'
) AND b.EventDate > '2000-01-01';

--15
SELECT DISTINCT p.PublisherName
FROM Publishers p
WHERE EXISTS (
    SELECT 1 FROM Books b WHERE b.PublisherID = p.PublisherID AND b.Pages > 400
);

--16
SELECT c.CategoryDescription
FROM Categories c
WHERE (
    SELECT COUNT(*) FROM Books b WHERE b.CategoryID = c.CategoryID
) > 3;

--17
SELECT b.Title
FROM Books b
WHERE EXISTS (
    SELECT 1
    FROM Publishers p
    WHERE p.PublisherID = b.PublisherID AND p.PublisherName = 'BHV'
);

--18
SELECT b.Title
FROM Books b
WHERE NOT EXISTS (
    SELECT 1
    FROM Publishers p
    WHERE p.PublisherID = b.PublisherID AND p.PublisherName = 'BHV'
);


--19
SELECT ThemeDescription AS Description
FROM Themes
UNION
SELECT CategoryDescription
FROM Categories
ORDER BY Description;

--20
SELECT DISTINCT split_part(Title, ' ', 1) AS FirstWord
FROM Books
UNION
SELECT split_part(CategoryDescription, ' ', 1)
FROM Categories
ORDER BY FirstWord DESC;


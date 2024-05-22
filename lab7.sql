--1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат
CREATE OR REPLACE PROCEDURE GetBookDetails()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT b.Title, b.Price_Currency, p.PublisherName, s.SizeDescriptions
    FROM Books b
    JOIN Publishers p ON b.PublisherID = p.PublisherID
    JOIN Sizes s ON b.SizeID = s.SizeID;
END;
$$;
-- CALL 

--2. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям
CREATE OR REPLACE PROCEDURE GetBooksByThemeAndCategory(theme_filter TEXT, category_filter TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT t.ThemeDescription, c.CategoryDescription, b.Title, p.PublisherName
    FROM Books b
    JOIN Themes t ON b.ThemeID = t.ThemeID
    JOIN Categories c ON b.CategoryID = c.CategoryID
    JOIN Publishers p ON b.PublisherID = p.PublisherID
    WHERE t.ThemeDescription = theme_filter AND c.CategoryDescription = category_filter;
END;
$$;

--3. Вивести книги видавництва 'BHV', видані після 2000 р
CREATE OR REPLACE PROCEDURE GetBooksByPublisherAfterYear(publisher_name TEXT, year INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT * 
    FROM Books b
    JOIN Publishers p ON b.PublisherID = p.PublisherID
    WHERE p.PublisherName = publisher_name AND b.EventDate > to_date('01-01-' || year, 'DD-MM-YYYY');
END;
$$;

--4. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій / зростанню кількості сторінок.
CREATE OR REPLACE PROCEDURE GetPagesCountByCategory(ordering TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    EXECUTE format('
        SELECT c.CategoryDescription, SUM(b.Pages) AS TotalPages
        FROM Books b
        JOIN Categories c ON b.CategoryID = c.CategoryID
        GROUP BY c.CategoryDescription
        ORDER BY TotalPages %s', ordering);
END;
$$;

--5. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
CREATE OR REPLACE PROCEDURE GetAveragePriceByThemeAndCategory(theme_filter TEXT, category_filter TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT AVG(b.Price_Currency) AS AveragePrice
    FROM Books b
    JOIN Themes t ON b.ThemeID = t.ThemeID
    JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE t.ThemeDescription = theme_filter AND c.CategoryDescription = category_filter;
END;
$$;

--6. Вивести всі дані універсального відношення.
CREATE OR REPLACE PROCEDURE GetUniversalView()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT * FROM UniversalView;
END;
$$;

--7. Вивести пари книг, що мають однакову кількість сторінок.
CREATE OR REPLACE PROCEDURE GetBooksPairsWithSamePages()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT a.Title AS Book1, b.Title AS Book2, a.Pages
    FROM Books a, Books b
    WHERE a.BookID < b.BookID AND a.Pages = b.Pages;
END;
$$;

--8. Вивести тріади книг, що мають однакову ціну.
CREATE OR REPLACE PROCEDURE GetBooksTriadsWithSamePrice()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT a.Title AS Book1, b.Title AS Book2, c.Title AS Book3, a.Price_Currency
    FROM Books a, Books b, Books c
    WHERE a.BookID < b.BookID AND b.BookID < c.BookID AND a.Price_Currency = b.Price_Currency AND b.Price_Currency = c.Price_Currency;
END;
$$;

--9. Вивести всі книги категорії 'C++'.
CREATE OR REPLACE PROCEDURE GetBooksByCategory(category_filter TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT *
    FROM Books b
    JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE c.CategoryDescription = category_filter;
END;
$$;

--10. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
CREATE OR REPLACE PROCEDURE GetPublishersByBookSize(min_pages INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT p.PublisherName
    FROM Books b
    JOIN Publishers p ON b.PublisherID = p.PublisherID
    WHERE b.Pages > min_pages;
END;
$$;

--11. Вивести список категорій за якими більше 3-х книг.
CREATE OR REPLACE PROCEDURE GetCategoriesWithMoreThanThreeBooks()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT c.CategoryDescription, COUNT(b.BookID) AS BookCount
    FROM Books b
    JOIN Categories c ON b.CategoryID = c.CategoryID
    GROUP BY c.CategoryDescription
    HAVING COUNT(b.BookID) > 3;
END;
$$;

--12. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
CREATE OR REPLACE PROCEDURE GetBooksIfAnyByPublisher(publisher_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Books b JOIN Publishers p ON b.PublisherID = p.PublisherID WHERE p.PublisherName = publisher_name) THEN
        SELECT *
        FROM Books b
        JOIN Publishers p ON b.PublisherID = p.PublisherID
        WHERE p.PublisherName = publisher_name;
    END IF;
END;
$$;

--13. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
CREATE OR REPLACE PROCEDURE GetBooksIfNoneByPublisher(publisher_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Books b JOIN Publishers p ON b.PublisherID = p.PublisherID WHERE p.PublisherName = publisher_name) THEN
        SELECT *
        FROM Books;
    END IF;
END;
$$;

--14. Вивести відсортоване загальний список назв тем і категорій.
CREATE OR REPLACE PROCEDURE GetSortedThemesAndCategories()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT t.ThemeDescription AS Description
    FROM Themes t
    UNION
    SELECT c.CategoryDescription AS Description
    FROM Categories c
    ORDER BY Description;
END;
$$;

--15. Вивести відсортований в зворотному порядку загальний список перших слів назв книг і категорій що не повторюються.
CREATE OR REPLACE PROCEDURE GetUniqueFirstWordsSortedDesc()
LANGUAGE plpgsql
AS $$
BEGIN
    WITH FirstWords AS (
        SELECT split_part(b.Title, ' ', 1) AS FirstWord
        FROM Books b
        UNION
        SELECT split_part(c.CategoryDescription, ' ', 1) AS FirstWord
        FROM Categories c
    )
    SELECT DISTINCT FirstWord
    FROM FirstWords
    ORDER BY FirstWord DESC;
END;
$$;

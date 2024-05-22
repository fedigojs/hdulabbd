-- 1. Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.
CREATE OR REPLACE FUNCTION get_total_book_cost(year INTEGER)
RETURNS DECIMAL AS $$
DECLARE
    total_cost DECIMAL;
BEGIN
    SELECT SUM(Price_Currency) INTO total_cost
    FROM Books
    WHERE EXTRACT(YEAR FROM EventDate) = year;
    
    RETURN COALESCE(total_cost, 0);
END;
$$ LANGUAGE plpgsql;

-- 2. Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році.
CREATE OR REPLACE FUNCTION get_books_by_year(year INTEGER)
RETURNS TABLE (
    BookID INTEGER,
    Code INTEGER,
    Novelty BOOLEAN,
    Title TEXT,
    Price_Currency DECIMAL,
    Pages INTEGER,
    EventDate DATE,
    Circulation INTEGER,
    ThemeID INTEGER,
    CategoryID INTEGER,
    PublisherID INTEGER,
    SizeID INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM Books
    WHERE EXTRACT(YEAR FROM EventDate) = year;
END;
$$ LANGUAGE plpgsql;

-- 3. Розробити і перевірити функцію типу multi-statement
-- a. приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ‘;’;
-- b. виділяти з цього рядка назву видавництва;
-- c. формувати нумерований список назв видавництв.

CREATE OR REPLACE FUNCTION parse_publishers_list(publishers TEXT)
RETURNS TABLE (
    publisher_id SERIAL,
    publisher_name TEXT
) AS $$
DECLARE
    publisher TEXT;
    counter INT := 1;
BEGIN
    FOR publisher IN SELECT unnest(string_to_array(publishers, ';')) LOOP
        RETURN QUERY SELECT counter, publisher;
        counter := counter + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 4. Виконати набір операцій по роботі з SQL курсором
-- а. оголосити курсор;
-- b. використовувати змінну для оголошення курсору;
-- c. відкрити курсор;
-- d. переприсвоїти курсор іншої змінної;
-- e. виконати вибірку даних з курсору;
-- f. закрити курсор;
-- g. звільнити курсор.

-- Розробити курсор для виводу списка книг виданих у визначеному році.
DO $$
DECLARE
    cursor_year CURSOR FOR
        SELECT Title, EventDate
        FROM Books
        WHERE EXTRACT(YEAR FROM EventDate) = 2023;
    book_record RECORD;
    cursor_alias REFCURSOR;
BEGIN
    -- Відкрити курсор
    OPEN cursor_year;
    
    -- Переприсвоїти курсор іншої змінної
    cursor_alias := cursor_year;
    
    -- Виконати вибірку даних з курсору
    LOOP
        FETCH cursor_alias INTO book_record;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Title: %, EventDate: %', book_record.Title, book_record.EventDate;
    END LOOP;
    
    -- Закрити курсор
    CLOSE cursor_alias;
END $$ LANGUAGE plpgsql;

-- 1. Кількість тем може бути в діапазоні від 5 до 10.
CREATE OR REPLACE FUNCTION check_themes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Themes) < 5 THEN
        RAISE EXCEPTION 'Має бути принаймні 5 тем.';
    ELSIF (SELECT COUNT(*) FROM Themes) > 10 THEN
        RAISE EXCEPTION 'Кількість тем не може перевищувати 10.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_themes_count
AFTER INSERT OR DELETE ON Themes
FOR EACH STATEMENT EXECUTE FUNCTION check_themes_count();

-- 2. Новинкою може бути тільки книга видана в поточному році.
CREATE OR REPLACE FUNCTION check_book_novelty()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Novelty AND EXTRACT(YEAR FROM NEW.EventDate) <> EXTRACT(YEAR FROM CURRENT_DATE) THEN
        RAISE EXCEPTION 'Новинкою може бути тільки книга видана в поточному році.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_book_novelty
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_book_novelty();

-- 3. Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
CREATE OR REPLACE FUNCTION check_book_price()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Pages <= 100 AND NEW.Price_Currency > 10 THEN
        RAISE EXCEPTION 'Книга з кількістю сторінок до 100 не може коштувати більше 10 $.';
    ELSIF NEW.Pages <= 200 AND NEW.Price_Currency > 20 THEN
        RAISE EXCEPTION 'Книга з кількістю сторінок до 200 не може коштувати більше 20 $.';
    ELSIF NEW.Pages <= 300 AND NEW.Price_Currency > 30 THEN
        RAISE EXCEPTION 'Книга з кількістю сторінок до 300 не може коштувати більше 30 $.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_book_price
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_book_price();

-- 4. Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво "Diasoft" - 10000.
CREATE OR REPLACE FUNCTION check_publisher_circulation()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT PublisherName FROM Publishers WHERE PublisherID = NEW.PublisherID) = 'BHV' AND NEW.Circulation < 5000 THEN
        RAISE EXCEPTION 'Видавництво "BHV" не випускає книги накладом меншим 5000.';
    ELSIF (SELECT PublisherName FROM Publishers WHERE PublisherID = NEW.PublisherID) = 'Diasoft' AND NEW.Circulation < 10000 THEN
        RAISE EXCEPTION 'Видавництво "Diasoft" не випускає книги накладом меншим 10000.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_publisher_circulation
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_publisher_circulation();

-- 5. Книги з однаковим кодом повинні мати однакові дані.
CREATE OR REPLACE FUNCTION check_book_code()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Books
        WHERE Code = NEW.Code AND 
              (Title <> NEW.Title OR 
               Price_Currency <> NEW.Price_Currency OR 
               Pages <> NEW.Pages OR 
               EventDate <> NEW.EventDate OR 
               Circulation <> NEW.Circulation OR 
               ThemeID <> NEW.ThemeID OR 
               CategoryID <> NEW.CategoryID OR 
               PublisherID <> NEW.PublisherID OR 
               SizeID <> NEW.SizeID OR 
               Novelty <> NEW.Novelty)
    ) THEN
        RAISE EXCEPTION 'Книги з однаковим кодом повинні мати однакові дані.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_book_code
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_book_code();

-- 6. При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.
CREATE OR REPLACE FUNCTION log_delete_books()
RETURNS TRIGGER AS $$
BEGIN
    IF current_user <> 'dbo' THEN
        RAISE EXCEPTION 'Тільки користувач "dbo" може видаляти записи.';
    END IF;
    RAISE NOTICE 'Видалено рядків: 1';
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_delete_books
BEFORE DELETE ON Books
FOR EACH ROW EXECUTE FUNCTION log_delete_books();

-- 7. Користувач "dbo" не має права змінювати ціну книги.
CREATE OR REPLACE FUNCTION prevent_dbo_price_update()
RETURNS TRIGGER AS $$
BEGIN
    IF current_user = 'dbo' AND NEW.Price_Currency <> OLD.Price_Currency THEN
        RAISE EXCEPTION 'Користувач "dbo" не має права змінювати ціну книги.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_dbo_price_update
BEFORE UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION prevent_dbo_price_update();

-- 8. Видавництва ДМК і Еком підручники не видають.
CREATE OR REPLACE FUNCTION check_publisher_restrictions()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT PublisherName FROM Publishers WHERE PublisherID = NEW.PublisherID) IN ('ДМК', 'Еком') THEN
        RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_publisher_restrictions
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_publisher_restrictions();

-- 9. Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
CREATE OR REPLACE FUNCTION check_publisher_novelty_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Novelty AND
       (SELECT COUNT(*)
        FROM Books
        WHERE PublisherID = NEW.PublisherID AND
              EXTRACT(YEAR FROM EventDate) = EXTRACT(YEAR FROM CURRENT_DATE) AND
              EXTRACT(MONTH FROM EventDate) = EXTRACT(MONTH FROM CURRENT_DATE) AND
              Novelty) >= 10 THEN
        RAISE EXCEPTION 'Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_publisher_novelty_limit
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_publisher_novelty_limit();

-- 10. Видавництво BHV не випускає книги формату 60х88 / 16.
CREATE OR REPLACE FUNCTION check_bhv_size_restriction()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT PublisherName FROM Publishers WHERE PublisherID = NEW.PublisherID) = 'BHV' AND
       (SELECT SizeDescriptions FROM Sizes WHERE SizeID = NEW.SizeID) = '60х88 / 16' THEN
        RAISE EXCEPTION 'Видавництво BHV не випускає книги формату 60х88 / 16.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_bhv_size_restriction
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_bhv_size_restriction();

-- 1. Створити користувальницький тип даних для зберігання оцінки учня на основі стандартного типу smallint з можливістю використання порожніх значень.
CREATE TYPE student_grade AS (
    grade smallint
);

-- 2. Створити об'єкт-замовчування (default) зі значенням 3.
CREATE OR REPLACE FUNCTION default_grade()
RETURNS student_grade AS $$
BEGIN
    RETURN (3)::student_grade;
END;
$$ LANGUAGE plpgsql;

-- 3. Зв'язати об'єкт-замовчування з призначеним для користувача типом даних для оцінки.
ALTER TABLE student_grades
ALTER COLUMN grade SET DEFAULT default_grade();

-- 4. Отримати інформацію про призначений для користувача тип даних.
SELECT typname, typnamespace, typowner, typlen, typbyval, typtype, typcategory
FROM pg_type
WHERE typname = 'student_grade';

-- 5. Створити об'єкт-правило (rule): a >= 1 і a <= 5 і зв'язати його з призначеним для користувача типом даних для оцінки.
CREATE OR REPLACE FUNCTION check_grade()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.grade < 1 OR NEW.grade > 5 THEN
        RAISE EXCEPTION 'Оцінка повинна бути в діапазоні від 1 до 5';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_grade
BEFORE INSERT OR UPDATE ON student_grades
FOR EACH ROW EXECUTE FUNCTION check_grade();

-- 6. Створити таблицю "Успішність студента", використовуючи новий тип даних. У таблиці повинні бути оцінки студента з кількох предметів.
CREATE TABLE student_grades (
    student_id SERIAL PRIMARY KEY,
    subject_name TEXT NOT NULL,
    grade student_grade DEFAULT default_grade() NOT NULL
);

-- 7. Скасувати всі прив'язки і видалити з бази даних тип даних користувача, замовчування і правило.

-- Спочатку необхідно видалити тригер
DROP TRIGGER trg_check_grade ON student_grades;

-- Потім видалити функцію тригера
DROP FUNCTION check_grade();

-- Далі видалити функцію замовчування
DROP FUNCTION default_grade();

-- І нарешті, видалити тип даних
DROP TYPE student_grade;

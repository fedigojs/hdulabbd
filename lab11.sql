
1. Опис предметної області
a) Користувачі та їх вимоги
- Адміністратори системи: управління користувачами, налаштування системи, моніторинг роботи системи.
- Менеджери з продажу: управління каталогом автозапчастин, обробка замовлень клієнтів, облік наявності товарів на складі.
- Клієнти: пошук і замовлення автозапчастин, відстеження стану замовлень, історія покупок.

b) Документи, що циркулюють у предметній області
- Товари: інформація про автозапчастини, включаючи назву, артикул, категорію, виробника, ціну, кількість на складі.
- Замовлення: інформація про замовлення, включаючи клієнта, список замовлених товарів, кількість, вартість, дата замовлення, статус замовлення.
- Клієнти: інформація про клієнтів, включаючи контактні дані та історію покупок.

c) Правила формування документів
- Реєстрація товарів: кожна нова автозапчастина повинна бути занесена в систему з унікальним артикулом.
- Оформлення замовлення: замовлення можуть бути оформлені тільки зареєстрованими клієнтами, кожне замовлення повинно мати унікальний номер.
- Оновлення наявності: кількість товарів на складі повинна оновлюватися після кожного продажу.

d) Обмеження на інформацію
- Унікальність артикулів: кожна автозапчастина повинна мати унікальний артикул.
- Актуальність даних: інформація про товари та замовлення повинна бути точною та актуальною.
- Конфіденційність даних: доступ до деяких даних (наприклад, даних клієнтів) повинен бути обмежений.

2. Формування словника БД
- Товари (Products): product_id, name, article, category, manufacturer, price, stock_quantity
- Клієнти (Customers): customer_id, name, email, phone, address
- Замовлення (Orders): order_id, customer_id, order_date, status, total_amount
- Замовлені товари (OrderItems): order_item_id, order_id, product_id, quantity, price

3. Визначення сутностей та їх атрибутів
Товари (Products)
- product_id (PK)
- name
- article (UNIQUE)
- category
- manufacturer
- price
- stock_quantity

Клієнти (Customers)
- customer_id (PK)
- name
- email (UNIQUE)
- phone
- address

Замовлення (Orders)
- order_id (PK)
- customer_id (FK)
- order_date
- status
- total_amount

Замовлені товари (OrderItems)
- order_item_id (PK)
- order_id (FK)
- product_id (FK)
- quantity
- price

4. Визначення зв'язків між сутностями
-Товар може бути замовлений у кількох замовленнях**: Зв'язок "один-до-багатьох" між Products і OrderItems.
- Клієнт може зробити кілька замовлень: Зв'язок "один-до-багатьох" між Customers і Orders.
- Замовлення може містити кілька товарів**: Зв'язок "один-до-багатьох" між Orders і OrderItems.

5. Побудова таблиць опису та зв’язків

-- Створення таблиці Товари (Products)
-- Створення таблиці Товари (Products)
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    article VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(100),
    manufacturer VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Створення таблиці Клієнти (Customers)
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT
);

-- Створення таблиці Замовлення (Orders)
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Створення таблиці Замовлені товари (OrderItems)
CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

6. МІГРАЦІІ ТОВАРІВ

INSERT INTO Products (name, article, category, manufacturer, price, stock_quantity) VALUES
('Акумулятор Varta Blue Dynamic 12V 60Ah', 'A001', 'Акумулятори', 'Varta', 85.00, 50),
('Масляний фільтр Mann W 75/3', 'B002', 'Фільтри', 'Mann', 6.50, 200),
('Повітряний фільтр Bosch 1 457 433 551', 'C003', 'Фільтри', 'Bosch', 10.00, 150),
('Гальмівні колодки TRW GDB1550', 'D004', 'Гальма', 'TRW', 25.00, 100),
('Свічка запалювання NGK BKR6EQUP', 'E005', 'Свічки', 'NGK', 12.00, 300),
('Фара передня Hella 1EL 008 350-021', 'F006', 'Освітлення', 'Hella', 120.00, 20),
('Лампа H7 Osram Night Breaker Laser', 'G007', 'Освітлення', 'Osram', 18.00, 200),
('Амортизатор передній Bilstein B4', 'H008', 'Амортизатори', 'Bilstein', 75.00, 40),
('Ремінь ГРМ Gates 5462XS', 'I009', 'Ремені', 'Gates', 35.00, 100),
('Термостат Wahler 4255.92D', 'J010', 'Охолодження', 'Wahler', 28.00, 60),
('Паливний фільтр Knecht KL 228', 'K011', 'Фільтри', 'Knecht', 12.00, 150),
('Кришка розширювального бачка Febi 02219', 'L012', 'Охолодження', 'Febi', 7.00, 100),
('Антифриз G12+ Ravenol 5L', 'M013', 'Рідини', 'Ravenol', 25.00, 80),
('Датчик температури охолоджуючої рідини Facet 7.3075', 'N014', 'Датчики', 'Facet', 15.00, 60),
('Стартер Bosch 0 001 108 103', 'O015', 'Електрика', 'Bosch', 180.00, 10),
('Прокладка ГБЦ Victor Reinz 61-34050-00', 'P016', 'Прокладки', 'Victor Reinz', 35.00, 70),
('Гальмівний диск ATE 24.0122-0158.1', 'Q017', 'Гальма', 'ATE', 50.00, 80),
('Радіатор охолодження Nissens 60768A', 'R018', 'Охолодження', 'Nissens', 150.00, 15),
('Паливний насос Bosch 0 580 314 069', 'S019', 'Паливна система', 'Bosch', 120.00, 25),
('Гальмівний шланг TRW PHD195', 'T020', 'Гальма', 'TRW', 12.00, 200),
('Рульова тяга Lemforder 26046 02', 'U021', 'Рульове управління', 'Lemforder', 28.00, 50),
('Насос ГУР ZF 7691 955 134', 'V022', 'Гідравліка', 'ZF', 200.00, 10),
('Піввісь передня SKF VKJC 4874', 'W023', 'Привід', 'SKF', 85.00, 20),
('Датчик положення колінвалу Bosch 0 261 210 170', 'X024', 'Датчики', 'Bosch', 45.00, 40),
('Фільтр салону Mann CUK 2736', 'Y025', 'Фільтри', 'Mann', 20.00, 100),
('Насос омивача VDO 246-083-001-001Z', 'Z026', 'Очищення скла', 'VDO', 15.00, 50),
('Комплект зчеплення Luk 623 3125 33', 'AA027', 'Зчеплення', 'Luk', 220.00, 30),
('Генератор Bosch 0 986 038 950', 'AB028', 'Електрика', 'Bosch', 300.00, 10),
('Масляний насос Febi 104359', 'AC029', 'Масляна система', 'Febi', 90.00, 25),
('Турбокомпресор Garrett 765155-5006S', 'AD030', 'Турбонаддув', 'Garrett', 600.00, 5),
('Поршень Kolbenschmidt 40246600', 'AE031', 'Двигун', 'Kolbenschmidt', 50.00, 100),
('Ремінь генератора Contitech 6PK1200', 'AF032', 'Ремені', 'Contitech', 20.00, 150),
('Прокладка впускного колектора Elring 437.440', 'AG033', 'Прокладки', 'Elring', 10.00, 80),
('Датчик рівня масла Hella 6PR 009 622-211', 'AH034', 'Датчики', 'Hella', 35.00, 40),
('Водяний насос SKF VKPC 88617', 'AI035', 'Охолодження', 'SKF', 60.00, 60),
('Гальмівна рідина ATE Typ 200 1L', 'AJ036', 'Рідини', 'ATE', 12.00, 100),
('Підшипник ступиці FAG 713 6495 00', 'AK037', 'Ходова частина', 'FAG', 45.00, 40),
('Амортизатор задній Sachs 311 230', 'AL038', 'Амортизатори', 'Sachs', 70.00, 30),
('Прокладка випускного колектора Reinz 71-28657-00', 'AM039', 'Прокладки', 'Reinz', 15.00, 80),
('Датчик кисню Denso DOX-0109', 'AN040', 'Датчики', 'Denso', 60.00, 30),
('Шків колінвалу Corteco 80001481', 'AO041', 'Двигун', 'Corteco', 80.00, 20),
('Дросельна заслінка Pierburg 7.14393.20.0', 'AP042', 'Двигун', 'Pierburg', 150.00, 15),
('Патрубок охолодження Gates 3896', 'AQ043', 'Охолодження', 'Gates', 25.00, 50),
('Рульовий наконечник Lemforder 26707 02', 'AR044', 'Рульове управління', 'Lemforder', 30.00, 50),
('Ремкомплект супорта Frenkit 238015', 'AS045', 'Гальма', 'Frenkit', 20.00, 40),
('Розширювальний бачок Febi 02219', 'AT046', 'Охолодження', 'Febi', 25.00, 30),
('Клапан EGR Pierburg 7.24809.23.0', 'AU047', 'Вихлопна система', 'Pierburg', 200.00, 10),
('Датчик тиску масла Hella 6ZL 008 280-001', 'AV048', 'Датчики', 'Hella', 15.00, 60),
('Втулка стабілізатора Febi 02187', 'AW049', 'Ходова частина', 'Febi', 10.00, 100),
('Датчик швидкості Magneti Marelli 064848003010', 'AX050', 'Датчики', 'Magneti Marelli', 20.00, 50);


--  Функциія віртуального замовлення 
CREATE OR REPLACE FUNCTION register_and_create_order(
    customer_name VARCHAR,
    customer_email VARCHAR,
    customer_phone VARCHAR,
    customer_address TEXT,
    product_list JSON
) RETURNS INTEGER AS $$
DECLARE
    new_customer_id INTEGER;
    new_order_id INTEGER;
    item JSON;
BEGIN
    -- Регистрация нового клиента
    INSERT INTO Customers (name, email, phone, address)
    VALUES (customer_name, customer_email, customer_phone, customer_address)
    RETURNING customer_id INTO new_customer_id;
    
    -- Создание нового заказа для зарегистрированного клиента
    INSERT INTO Orders (customer_id, order_date, status, total_amount)
    VALUES (new_customer_id, CURRENT_DATE, 'Pending', 0)
    RETURNING order_id INTO new_order_id;
    
    -- Добавление товаров к заказу
    FOR item IN SELECT * FROM json_array_elements(product_list) LOOP
        INSERT INTO OrderItems (order_id, product_id, quantity, price)
        VALUES (
            new_order_id,
            (item ->> 'product_id')::INTEGER,
            (item ->> 'quantity')::INTEGER,
            (SELECT price FROM Products WHERE product_id = (item ->> 'product_id')::INTEGER)
        );
        
        -- Обновление общей суммы заказа
        UPDATE Orders
        SET total_amount = total_amount + (
            (SELECT price FROM Products WHERE product_id = (item ->> 'product_id')::INTEGER) * (item ->> 'quantity')::INTEGER
        )
        WHERE order_id = new_order_id;
    END LOOP;
    
    RETURN new_order_id;
END;
$$ LANGUAGE plpgsql;

-- як визвати функцію 
SELECT register_and_create_order(
    'Іван Іванов', 
    'ivanov@example.com', 
    '1234567890', 
    'Київ, вул. Шевченка, 1',
    '[{"product_id": 1, "quantity": 2}, {"product_id": 3, "quantity": 1}]'::JSON
);

-- відображення деталей завмовлення ʼ
CREATE OR REPLACE FUNCTION get_order_details(order_id INTEGER)
RETURNS TABLE (
    customer_name VARCHAR,
    customer_email VARCHAR,
    customer_phone VARCHAR,
    customer_address TEXT,
    order_date DATE,
    order_status VARCHAR,
    product_name VARCHAR,
    product_quantity INTEGER,
    product_price DECIMAL,
    total_amount DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.name AS customer_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        c.address AS customer_address,
        o.order_date,
        o.status AS order_status,
        p.name AS product_name,
        oi.quantity AS product_quantity,
        oi.price AS product_price,
        o.total_amount
    FROM
        Orders o
        JOIN Customers c ON o.customer_id = c.customer_id
        JOIN OrderItems oi ON o.order_id = oi.order_id
        JOIN Products p ON oi.product_id = p.product_id
    WHERE
        o.order_id = get_order_details.order_id;
END;
$$ LANGUAGE plpgsql;



-- як візвавти функцію 
SELECT * FROM get_order_details(1);

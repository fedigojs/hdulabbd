-- Active: 1713084570414@@127.0.0.1@5432@hdu



CREATE TABLE IF NOT EXISTS Publishers (
    PublisherID SERIAL PRIMARY KEY,
    PublisherName TEXT CHECK(length(PublisherName) <= 200) NOT NULL
);

CREATE TABLE IF NOT EXISTS Themes (
    ThemeID SERIAL PRIMARY KEY,
    ThemeDescription TEXT CHECK(length(ThemeDescription) <= 100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Categories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryDescription TEXT CHECK(length(CategoryDescription) <= 100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Sizes (
    SizeID SERIAL PRIMARY KEY,
    SizeDescriptions TEXT CHECK(length(SizeDescriptions) <= 100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Books (
    BookID SERIAL PRIMARY KEY,
    Code INTEGER,
    Novelty BOOLEAN DEFAULT FALSE,
    Title TEXT CHECK(length(Title) <= 200) NOT NULL,
    Price_Currency DECIMAL(10, 2),
    Pages INTEGER NOT NULL,
    EventDate DATE,
    Circulation INTEGER DEFAULT 5000,
    ThemeID INTEGER,
    CategoryID INTEGER,
    PublisherID INTEGER,
    SizeID INTEGER,
    FOREIGN KEY (ThemeID) REFERENCES Themes(ThemeID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID),
    FOREIGN KEY (SizeID) REFERENCES Sizes(SizeID)
);

-- Міграція даних
INSERT INTO Publishers (PublisherName)
SELECT DISTINCT publisher FROM Lab1
WHERE publisher IS NOT NULL;

INSERT INTO Themes (ThemeDescription)
SELECT DISTINCT theme FROM Lab1
WHERE theme IS NOT NULL;

INSERT INTO Categories (CategoryDescription)
SELECT DISTINCT category FROM Lab1
WHERE category IS NOT NULL;
INSERT INTO Sizes (SizeDescriptions)
SELECT DISTINCT size FROM Lab1
WHERE size IS NOT NULL;

INSERT INTO Books (Code, Novelty, Title, Price_Currency, Pages, EventDate, Circulation, ThemeID, CategoryID, PublisherID, SizeID)
SELECT 
    Lab1.code, 
    Lab1.novelty, 
    Lab1.title, 
    Lab1.price_currency, 
    Lab1.pages,
    Lab1.eventDate, 
    Lab1.circulation,
    Themes.ThemeID,
    Categories.CategoryID,
    Publishers.PublisherID,
    Sizes.SizeID
FROM 
    Lab1
LEFT JOIN 
    Publishers ON Lab1.publisher = Publishers.PublisherName
LEFT JOIN 
    Themes ON Lab1.theme = Themes.ThemeDescription
LEFT JOIN 
    Categories ON Lab1.category = Categories.CategoryDescription
LEFT JOIN 
    Sizes ON Lab1.size = Sizes.SizeDescriptions;

-- Створення універсального представлення
CREATE VIEW UniversalView AS
SELECT
    b.BookID,
    b.Title,
    b.Pages,
    b.SizeId,
    b.EventDate,
    b.Circulation,
    b.Price_Currency,
    p.PublisherName,
    t.ThemeDescription,
    c.CategoryDescription,
    s.SizeDescriptions,
    b.Novelty
FROM
    Books b
        LEFT JOIN
    Publishers p ON b.PublisherID = p.PublisherID
        LEFT JOIN
    Themes t ON b.ThemeID = t.ThemeID
        LEFT JOIN
    Categories c ON b.CategoryID = c.CategoryID
    LEFT JOIN
    Sizes s ON b.SizeID = s.SizeID;


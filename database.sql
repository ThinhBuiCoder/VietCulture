-- Tạo database TravlerDB
CREATE DATABASE TravlerDB;
GO

USE TravlerDB;
GO

-- Bảng Users (chính)
CREATE TABLE Users (
    userId INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(100) NOT NULL,
    fullName NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    dateOfBirth DATE,
    gender NVARCHAR(10),
    avatar NVARCHAR(255),
    bio NVARCHAR(500),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isActive BIT NOT NULL DEFAULT 1,
    userType NVARCHAR(20) NOT NULL CHECK (userType IN ('TRAVELER', 'LOCAL_HOST', 'SUPPLIER', 'ADMIN'))
);
GO

-- Bảng Travelers mở rộng
CREATE TABLE Travelers (
    userId INT PRIMARY KEY,
    preferences NVARCHAR(MAX),
    totalBookings INT NOT NULL DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- Bảng LocalHosts mở rộng
CREATE TABLE LocalHosts (
    userId INT PRIMARY KEY,
    skills NVARCHAR(500),
    region NVARCHAR(50),
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalExperiences INT NOT NULL DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- Bảng Suppliers mở rộng
CREATE TABLE Suppliers (
    userId INT PRIMARY KEY,
    businessName NVARCHAR(100) NOT NULL,
    businessType NVARCHAR(50),
    businessAddress NVARCHAR(255),
    businessDescription NVARCHAR(500),
    taxId NVARCHAR(50),
    totalRevenue FLOAT NOT NULL DEFAULT 0,
    averageRating FLOAT NOT NULL DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- Bảng Admins mở rộng
CREATE TABLE Admins (
    userId INT PRIMARY KEY,
    role NVARCHAR(50) NOT NULL,
    permissions NVARCHAR(MAX),
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- Bảng Regions
CREATE TABLE Regions (
    regionId INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) UNIQUE NOT NULL,
    vietnameseName NVARCHAR(50),
    description NVARCHAR(500),
    imageUrl NVARCHAR(255),
    climate NVARCHAR(255),
    culture NVARCHAR(500)
);
GO

-- Bảng Cities
CREATE TABLE Cities (
    cityId INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    vietnameseName NVARCHAR(100),
    regionId INT NOT NULL,
    description NVARCHAR(500),
    imageUrl NVARCHAR(255),
    attractions NVARCHAR(MAX),
    FOREIGN KEY (regionId) REFERENCES Regions(regionId)
);
GO

-- Bảng Categories
CREATE TABLE Categories (
    categoryId INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(255),
    iconUrl NVARCHAR(255)
);
GO

-- Bảng Experiences
CREATE TABLE Experiences (
    experienceId INT PRIMARY KEY IDENTITY(1,1),
    hostId INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    location NVARCHAR(255) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    region NVARCHAR(50) NOT NULL,
    type NVARCHAR(50) NOT NULL,
    price FLOAT NOT NULL,
    maxGroupSize INT NOT NULL,
    duration TIME NOT NULL,
    difficulty NVARCHAR(20) CHECK (difficulty IN ('EASY', 'MODERATE', 'CHALLENGING')),
    language NVARCHAR(50),
    includedItems NVARCHAR(MAX),
    requirements NVARCHAR(MAX),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isActive BIT NOT NULL DEFAULT 1,
    images NVARCHAR(MAX),
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalBookings INT NOT NULL DEFAULT 0,
    FOREIGN KEY (hostId) REFERENCES Users(userId)
);
GO

-- Bảng Experience_Categories (many-to-many)
CREATE TABLE Experience_Categories (
    experienceId INT NOT NULL,
    categoryId INT NOT NULL,
    PRIMARY KEY (experienceId, categoryId),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId) ON DELETE CASCADE,
    FOREIGN KEY (categoryId) REFERENCES Categories(categoryId) ON DELETE CASCADE
);
GO

-- Bảng Bookings
CREATE TABLE Bookings (
    bookingId INT PRIMARY KEY IDENTITY(1,1),
    experienceId INT NOT NULL,
    travelerId INT NOT NULL,
    bookingDate DATE NOT NULL,
    bookingTime TIME NOT NULL,
    numberOfPeople INT NOT NULL,
    totalPrice FLOAT NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    specialRequests NVARCHAR(500),
    contactInfo NVARCHAR(255),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (travelerId) REFERENCES Users(userId)
);
GO

-- Bảng Reviews
CREATE TABLE Reviews (
    reviewId INT PRIMARY KEY IDENTITY(1,1),
    experienceId INT NOT NULL,
    travelerId INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(500),
    photos NVARCHAR(MAX),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isVisible BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (travelerId) REFERENCES Users(userId)
);
GO

-- Bảng Transactions (Supplier rút tiền & lịch sử giao dịch)
CREATE TABLE Transactions (
    transactionId INT PRIMARY KEY IDENTITY(1,1),
    supplierId INT NOT NULL,
    transactionDate DATE NOT NULL DEFAULT GETDATE(),
    amount FLOAT NOT NULL,
    transactionType NVARCHAR(20) CHECK (transactionType IN ('WITHDRAWAL', 'DEPOSIT')),
    status NVARCHAR(20) CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED')),
    FOREIGN KEY (supplierId) REFERENCES Users(userId)
);
GO

-- Bảng Complaints (Khiếu nại)
CREATE TABLE Complaints (
    complaintId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    relatedBookingId INT NULL,
    complaintText NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')) DEFAULT 'OPEN',
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    resolvedAt DATE NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (relatedBookingId) REFERENCES Bookings(bookingId)
);
GO


-- Chèn dữ liệu mặc định Regions
INSERT INTO Regions (name, vietnameseName, description, imageUrl, climate, culture)
VALUES 
    ('North', N'Bắc', N'Northern Vietnam includes Hanoi, Ha Long Bay, and mountainous regions', 'north.jpg', N'Subtropical climate with four seasons', N'Rich historical culture, Chinese influence'),
    ('Central', N'Trung', N'Central Vietnam includes Hue, Da Nang, and Hoi An', 'central.jpg', N'Hot and dry summers, rainy winters', N'Former imperial capital, unique cuisine'),
    ('South', N'Nam', N'Southern Vietnam includes Ho Chi Minh City and Mekong Delta', 'south.jpg', N'Tropical, hot and humid year-round', N'Dynamic, commercial, Western influences');
GO

-- Chèn Cities
INSERT INTO Cities (name, vietnameseName, regionId, description, imageUrl, attractions)
VALUES
    ('Hanoi', N'Hà Nội', 1, N'Capital city with rich history', 'hanoi.jpg', N'Hoan Kiem Lake, Old Quarter'),
    ('Hue', N'Huế', 2, N'Ancient capital of Vietnam', 'hue.jpg', N'Imperial Citadel, Perfume River'),
    ('Ho Chi Minh City', N'Thành phố Hồ Chí Minh', 3, N'Vietnam''s largest city', 'hcmc.jpg', N'Ben Thanh Market, Notre-Dame Cathedral');
GO

-- Chèn Categories
INSERT INTO Categories (name, description, iconUrl)
VALUES
    ('Food', 'Culinary experiences including cooking classes and food tours', 'food_icon.png'),
    ('Culture', 'Cultural experiences like traditional art and village visits', 'culture_icon.png'),
    ('Adventure', 'Active experiences like hiking, biking, water sports', 'adventure_icon.png'),
    ('Nature', 'Nature-focused experiences like bird watching and botanical tours', 'nature_icon.png'),
    ('History', 'Historical tours and visits to significant sites', 'history_icon.png'),
    ('Craft', 'Hands-on craft workshops and artisan visits', 'craft_icon.png');
GO


-- Chèn Admin user với biến để lấy userId
DECLARE @adminUserId INT;

INSERT INTO Users (email, password, fullName, phone, gender, userType)
VALUES ('admin@travler.com', '123456', 'System Admin', '0123456789', 'Male', 'ADMIN');

SET @adminUserId = SCOPE_IDENTITY();

INSERT INTO Admins (userId, role, permissions)
VALUES (@adminUserId, 'SUPER_ADMIN', '{"all": true}');
GO

-- Chèn Travelers sample
INSERT INTO Users (email, password, fullName, phone, dateOfBirth, gender, userType, bio)
VALUES
    ('john@example.com', '123456', 'John Smith', '0901234567', '1985-05-15', 'Male', 'TRAVELER', 'I love traveling and exploring new cultures'),
    ('jane@example.com', '123456', 'Jane Doe', '0909876543', '1990-07-20', 'Female', 'TRAVELER', 'Adventure seeker and foodie');
GO

INSERT INTO Travelers (userId, preferences, totalBookings)
VALUES
    ((SELECT userId FROM Users WHERE email='john@example.com'), '{"likes":["Food","Culture","Nature"]}', 10),
    ((SELECT userId FROM Users WHERE email='jane@example.com'), '{"likes":["Adventure","History"]}', 5);
GO

-- Chèn LocalHost sample
INSERT INTO Users (email, password, fullName, phone, userType)
VALUES ('host1@example.com', '123456', 'Nguyen Van A', '0987654321', 'LOCAL_HOST');
GO

INSERT INTO LocalHosts (userId, skills, region, averageRating, totalExperiences)
VALUES ((SELECT userId FROM Users WHERE email='host1@example.com'), 'Cooking, Storytelling', 'North', 4.8, 12);
GO

-- Chèn Supplier sample
INSERT INTO Users (email, password, fullName, phone, userType)
VALUES ('supplier1@example.com', '123456', 'Supplier One', '0912345678', 'SUPPLIER');
GO

INSERT INTO Suppliers (userId, businessName, businessType, businessAddress, businessDescription, taxId, totalRevenue, averageRating)
VALUES ((SELECT userId FROM Users WHERE email='supplier1@example.com'), 'Supplier Co.', 'Food & Beverage', '123 Supplier St, HCMC', 'Provides fresh ingredients', 'TAX123456', 1000000, 4.5);
GO

-- Chèn Experiences sample
INSERT INTO Experiences (hostId, title, description, location, city, region, type, price, maxGroupSize, duration, difficulty, language, includedItems, requirements, images)
VALUES
    ((SELECT userId FROM Users WHERE email='host1@example.com'),
    'Hanoi Street Food Tour',
    'Explore Hanoi''s best street food with a local guide.',
    'Hanoi Old Quarter',
    'Hanoi',
    'North',
    'Food',
    30,
    10,
    '02:00:00',
    'EASY',
    'English, Vietnamese',
    'Food tastings included',
    'Comfortable shoes',
    'hanoi_food_tour1.jpg,hanoi_food_tour2.jpg');
GO

-- Gán category cho experience
INSERT INTO Experience_Categories (experienceId, categoryId)
VALUES
    ((SELECT experienceId FROM Experiences WHERE title='Hanoi Street Food Tour'),
    (SELECT categoryId FROM Categories WHERE name='Food'));
GO

-- Chèn Booking sample
INSERT INTO Bookings (experienceId, travelerId, bookingDate, bookingTime, numberOfPeople, totalPrice, status, specialRequests, contactInfo)
VALUES
(
    (SELECT experienceId FROM Experiences WHERE title='Hanoi Street Food Tour'),
    (SELECT userId FROM Users WHERE email='john@example.com'),
    '2025-06-01',
    '10:00:00',
    2,
    60,
    'CONFIRMED',
    'Please accommodate vegetarian options',
    'john@example.com, 0901234567'
);
GO

-- Chèn Review sample
INSERT INTO Reviews (experienceId, travelerId, rating, comment, photos)
VALUES
(
    (SELECT experienceId FROM Experiences WHERE title='Hanoi Street Food Tour'),
    (SELECT userId FROM Users WHERE email='john@example.com'),
    5,
    'Amazing experience! The guide was very knowledgeable.',
    'review1_photo1.jpg,review1_photo2.jpg'
);
GO

-- Chèn Transaction sample
INSERT INTO Transactions (supplierId, amount, transactionType, status)
VALUES
(
    (SELECT userId FROM Users WHERE email='supplier1@example.com'),
    500,
    'WITHDRAWAL',
    'COMPLETED'
);
GO

-- Chèn Complaint sample
INSERT INTO Complaints (userId, relatedBookingId, complaintText)
VALUES
(
    (SELECT userId FROM Users WHERE email='john@example.com'),
    (SELECT bookingId FROM Bookings WHERE travelerId=(SELECT userId FROM Users WHERE email='john@example.com')),
    'The cooking class started late and was shorter than expected.'
);
GO



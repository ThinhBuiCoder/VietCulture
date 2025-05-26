-- Tạo database
CREATE DATABASE TravelerDB;
GO

USE TravelerDB;
GO

-- Bảng Users (gộp Travelers, Hosts, Admins)
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
    role NVARCHAR(50) NOT NULL CHECK (role IN ('TRAVELER', 'HOST', 'ADMIN')), -- Thay userType bằng role
    preferences NVARCHAR(MAX), -- Từ bảng Travelers
    businessName NVARCHAR(100), -- Từ bảng Hosts
    businessType NVARCHAR(50), -- Từ bảng Hosts
    businessAddress NVARCHAR(255), -- Từ bảng Hosts
    businessDescription NVARCHAR(500), -- Từ bảng Hosts
    taxId NVARCHAR(50), -- Từ bảng Hosts
    skills NVARCHAR(500), -- Từ bảng Hosts
    region NVARCHAR(50), -- Từ bảng Hosts
    averageRating FLOAT NOT NULL DEFAULT 0, -- Từ bảng Hosts
    totalExperiences INT NOT NULL DEFAULT 0, -- Từ bảng Hosts
    totalRevenue FLOAT NOT NULL DEFAULT 0, -- Từ bảng Hosts
    totalBookings INT NOT NULL DEFAULT 0, -- Từ bảng Travelers
    permissions NVARCHAR(MAX), -- Từ bảng Admins
    emailVerified BIT NOT NULL DEFAULT 0, -- Từ yêu cầu trước
    verificationToken NVARCHAR(255), -- Từ yêu cầu trước
    tokenExpiry DATETIME -- Từ yêu cầu trước
);
GO

-- Tạo bảng EmailVerification
CREATE TABLE EmailVerification (
    verificationId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    email NVARCHAR(100) NOT NULL,
    verificationToken NVARCHAR(255) NOT NULL,
    tokenExpiry DATETIME NOT NULL,
    isUsed BIT NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    verifiedAt DATETIME NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- Index để tìm kiếm nhanh token
CREATE INDEX IX_EmailVerification_Token ON EmailVerification(verificationToken);
CREATE INDEX IX_Users_VerificationToken ON Users(verificationToken);
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
    cityId INT NOT NULL,
    type NVARCHAR(50) NOT NULL,
    price FLOAT NOT NULL,
    maxGroupSize INT NOT NULL,
    duration TIME NOT NULL,
    difficulty NVARCHAR(20) CHECK (difficulty IN ('EASY', 'MODERATE', 'CHALLENGING')),
    language NVARCHAR(50),
    includedItems NVARCHAR(MAX),
    requirements NVARCHAR(MAX),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isActive BIT NOT NULL DEFAULT 0,
    images NVARCHAR(MAX),
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalBookings INT NOT NULL DEFAULT 0,
    FOREIGN KEY (hostId) REFERENCES Users(userId),
    FOREIGN KEY (cityId) REFERENCES Cities(cityId)
);
GO

-- Bảng Experience_Categories
CREATE TABLE Experience_Categories (
    experienceId INT NOT NULL,
    categoryId INT NOT NULL,
    PRIMARY KEY (experienceId, categoryId),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId) ON DELETE CASCADE,
    FOREIGN KEY (categoryId) REFERENCES Categories(categoryId) ON DELETE CASCADE
);
GO

-- Bảng Accommodations
CREATE TABLE Accommodations (
    accommodationId INT PRIMARY KEY IDENTITY(1,1),
    hostId INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    cityId INT NOT NULL,
    address NVARCHAR(255) NOT NULL,
    type NVARCHAR(50) CHECK (type IN ('Homestay', 'Hotel', 'Resort', 'Guesthouse')),
    numberOfRooms INT,
    amenities NVARCHAR(MAX),
    pricePerNight FLOAT NOT NULL,
    images NVARCHAR(MAX),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isActive BIT NOT NULL DEFAULT 0,
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalBookings INT NOT NULL DEFAULT 0,
    FOREIGN KEY (hostId) REFERENCES Users(userId),
    FOREIGN KEY (cityId) REFERENCES Cities(cityId)
);
GO

-- Bảng Bookings
CREATE TABLE Bookings (
    bookingId INT PRIMARY KEY IDENTITY(1,1),
    experienceId INT NULL,
    accommodationId INT NULL,
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
    FOREIGN KEY (accommodationId) REFERENCES Accommodations(accommodationId),
    FOREIGN KEY (travelerId) REFERENCES Users(userId),
    CHECK (experienceId IS NOT NULL OR accommodationId IS NOT NULL)
);
GO

-- Bảng Reviews
CREATE TABLE Reviews (
    reviewId INT PRIMARY KEY IDENTITY(1,1),
    experienceId INT NULL,
    accommodationId INT NULL,
    travelerId INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(500),
    photos NVARCHAR(MAX),
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isVisible BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (accommodationId) REFERENCES Accommodations(accommodationId),
    FOREIGN KEY (travelerId) REFERENCES Users(userId),
    CHECK (experienceId IS NOT NULL OR accommodationId IS NOT NULL)
);
GO

-- Bảng Transactions
CREATE TABLE Transactions (
    transactionId INT PRIMARY KEY IDENTITY(1,1),
    hostId INT NOT NULL,
    transactionDate DATE NOT NULL DEFAULT GETDATE(),
    amount FLOAT NOT NULL,
    transactionType NVARCHAR(20) CHECK (transactionType IN ('WITHDRAWAL', 'DEPOSIT')),
    status NVARCHAR(20) CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED')),
    FOREIGN KEY (hostId) REFERENCES Users(userId)
);
GO

-- Bảng Complaints
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

-- Chèn dữ liệu mẫu

-- Chèn Regions
INSERT INTO Regions (name, vietnameseName, description, imageUrl, climate, culture) VALUES
('North', N'Miền Bắc', N'Khu vực phía Bắc Việt Nam bao gồm Hà Nội, Hải Phòng, Sapa, Hạ Long, Ninh Bình', 'north.jpg', N'Khí hậu cận nhiệt đới với bốn mùa', N'Văn hóa đậm chất lịch sử, ảnh hưởng Trung Hoa'),
('Central', N'Miền Trung', N'Khu vực miền Trung gồm Đà Nẵng, Huế, Hội An, Nha Trang, Quy Nhơn', 'central.jpg', N'Nóng, khô vào mùa hè và mưa vào mùa đông', N'Ẩm thực độc đáo, di tích lịch sử'),
('South', N'Miền Nam', N'Khu vực phía Nam như TP.HCM, Vũng Tàu, Cần Thơ, Phú Quốc, Đà Lạt, Bến Tre', 'south.jpg', N'Nhiệt đới, nóng ẩm quanh năm', N'Hiện đại, năng động, pha trộn văn hóa phương Tây');
GO

-- Chèn Cities
INSERT INTO Cities (name, vietnameseName, regionId, description, imageUrl, attractions) VALUES
('Hanoi', N'Hà Nội', 1, N'Thủ đô nghìn năm văn hiến', 'hanoi.jpg', N'Hồ Gươm, Phố cổ'),
('Haiphong', N'Hải Phòng', 1, N'Cảng biển lớn phía Bắc', 'haiphong.jpg', N'Cát Bà, Đồ Sơn'),
('Sapa', N'Sa Pa', 1, N'Thành phố sương mù trên núi cao', 'sapa.jpg', N'Fansipan, bản Cát Cát'),
('Ha Long', N'Hạ Long', 1, N'Thành phố biển với vịnh nổi tiếng', 'halong.jpg', N'Vịnh Hạ Long, đảo Tuần Châu'),
('Ninh Binh', N'Ninh Bình', 1, N'Cố đô và cảnh quan thiên nhiên', 'ninhbinh.jpg', N'Tam Cốc, Tràng An'),
('Da Nang', N'Đà Nẵng', 2, N'Thành phố biển sôi động', 'danang.jpg', N'Bà Nà Hills, cầu Rồng'),
('Hue', N'Huế', 2, N'Kinh đô cổ với di tích cố đô', 'hue.jpg', N'Đại nội, chùa Thiên Mụ'),
('Hoi An', N'Hội An', 2, N'Phố cổ với kiến trúc độc đáo', 'hoian.jpg', N'Phố cổ, Lễ hội ánh sáng'),
('Nha Trang', N'Nha Trang', 2, N'Thành phố biển nổi tiếng', 'nhatrang.jpg', N'Biển, Vinpearl'),
('Quy Nhon', N'Quy Nhơn', 2, N'Thành phố biển hoang sơ', 'quynhon.jpg', N'Biển, Eo Gió'),
('Ho Chi Minh City', N'TP.HCM', 3, N'Thành phố lớn nhất Việt Nam', 'hcmc.jpg', N'Chợ Bến Thành, Dinh Độc Lập'),
('Vung Tau', N'Vũng Tàu', 3, N'Thành phố biển miền Nam', 'vungtau.jpg', N'Bãi Sau, tượng Chúa Kitô'),
('Can Tho', N'Cần Thơ', 3, N'Thành phố miền Tây sông nước', 'cantho.jpg', N'Chợ nổi Cái Răng, Làng du lịch Mỹ Khánh'),
('Phu Quoc', N'Phú Quốc', 3, N'Đảo ngọc nổi tiếng', 'phuquoc.jpg', N'Bãi Sao, Vinpearl Land'),
('Da Lat', N'Đà Lạt', 3, N'Thành phố ngàn hoa', 'dalat.jpg', N'Hồ Xuân Hương, Thung Lũng Tình Yêu'),
('Ben Tre', N'Bến Tre', 3, N'Vùng đất dừa miền Tây', 'bentre.jpg', N'Miệt vườn dừa, sông nước');
GO

-- Chèn Categories
INSERT INTO Categories (name, description, iconUrl) VALUES
('Food', 'Ẩm thực & tour nấu ăn', 'food.png'),
('Culture', 'Văn hóa & lễ hội', 'culture.png'),
('Adventure', 'Phiêu lưu & thể thao', 'adventure.png'),
('History', 'Lịch sử & di tích', 'history.png');
GO

-- Chèn Admin
INSERT INTO Users (email, password, fullName, phone, gender, role, permissions, emailVerified) VALUES
('admin@travel.com', 'kien2004', N'Admin', '0123456789', N'Nam', 'ADMIN', '{"all": true}', 1);
GO

-- Chèn Travelers
INSERT INTO Users (email, password, fullName, dateOfBirth, gender, role, preferences, emailVerified) VALUES
('tr1@example.com', '123456', N'Nguyễn A', '1990-01-01', N'Nam', 'TRAVELER', '{"likes": ["Food", "Adventure"]}', 1),
('tr2@example.com', '123456', N'Lê B', '1985-05-05', N'Nữ', 'TRAVELER', '{"likes": ["Culture", "History"]}', 1);
GO

-- Chèn Hosts
INSERT INTO Users (email, password, fullName, gender, role, businessName, businessType, businessAddress, businessDescription, taxId, skills, region, averageRating, totalExperiences, totalRevenue, emailVerified) VALUES
('host1@example.com', '123456', N'Nguyễn Host', N'Nữ', 'HOST', N'Nguyễn Homestay', N'Homestay', N'123 Đường Láng, Hà Nội', N'Homestay ấm cúng gần hồ Tây', 'TAX123456', N'Giao tiếp, tổ chức tour', N'North', 4.8, 12, 5000000, 1),
('host2@example.com', '123456', N'Trần Host', N'Nam', 'HOST', N'Trần Travel', N'Travel Agency', N'456 Hai Bà Trưng, Đà Nẵng', N'Công ty du lịch chuyên tour miền Trung', 'TAX654321', N'Tổ chức tour, hướng dẫn viên', N'Central', 4.7, 20, 12000000, 1);
GO

-- Chèn Experiences
INSERT INTO Experiences (hostId, title, description, location, cityId, type, price, maxGroupSize, duration, difficulty, language, includedItems, requirements, images, isActive) VALUES
(
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    N'Tour đạp xe quanh Hà Nội',
    N'Tour đạp xe khám phá phố cổ và hồ Tây',
    N'Phố cổ Hà Nội',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'Adventure',
    50,
    8,
    '03:00:00',
    'MODERATE',
    N'Vietnamese, English',
    N'Xe đạp, Nước uống',
    N'Mang giày thể thao',
    N'bike1.jpg,bike2.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='host2@example.com'),
    N'Tour ẩm thực Đà Nẵng',
    N'Khám phá ẩm thực địa phương Đà Nẵng',
    N'Chợ Cồn',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'Food',
    70,
    10,
    '04:00:00',
    'EASY',
    N'Vietnamese, English',
    N'Ăn uống thoải mái',
    N'Không yêu cầu',
    N'food1.jpg,food2.jpg',
    1
);
GO

-- Chèn Accommodations
INSERT INTO Accommodations (hostId, name, description, cityId, address, type, numberOfRooms, amenities, pricePerNight, images, isActive) VALUES
(
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    N'Homestay Hoa Mai',
    N'Không gian ấm cúng, gần hồ Tây',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'456 Đường Láng, Hà Nội',
    'Homestay',
    6,
    N'Wifi, Bãi đỗ xe, Bữa sáng miễn phí',
    400000,
    N'homestay1.jpg,homestay2.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='host2@example.com'),
    N'Khách sạn Mặt Trời',
    N'Khách sạn 3 sao trung tâm Đà Nẵng',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'789 Trần Phú, Đà Nẵng',
    'Hotel',
    30,
    N'Hồ bơi, Wifi, Phòng gym',
    1200000,
    N'hotel1.jpg,hotel2.jpg',
    1
);
GO

-- Chèn Bookings
INSERT INTO Bookings (experienceId, travelerId, bookingDate, bookingTime, numberOfPeople, totalPrice, status, contactInfo) VALUES
(
    (SELECT experienceId FROM Experiences WHERE title = N'Tour đạp xe quanh Hà Nội'),
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    '2025-06-01',
    '08:00:00',
    2,
    100,
    'CONFIRMED',
    N'0123456789'
),
(
    NULL,
    (SELECT userId FROM Users WHERE email='tr2@example.com'),
    '2025-06-10',
    '14:00:00',
    3,
    1200000,
    'PENDING',
    N'0987654321'
);
GO

-- Chèn Reviews
INSERT INTO Reviews (experienceId, travelerId, rating, comment) VALUES
(
    (SELECT experienceId FROM Experiences WHERE title = N'Tour đạp xe quanh Hà Nội'),
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    5,
    N'Trải nghiệm tuyệt vời, hướng dẫn viên thân thiện!'
);
GO

INSERT INTO Reviews (accommodationId, travelerId, rating, comment) VALUES
(
    (SELECT accommodationId FROM Accommodations WHERE name = N'Homestay Hoa Mai'),
    (SELECT userId FROM Users WHERE email='tr2@example.com'),
    4,
    N'Không gian rất thoải mái, sẽ quay lại!'
);
GO
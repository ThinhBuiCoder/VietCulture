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
-- Thêm các bảng cho hệ thống chat vào database hiện có

-- Bảng ChatRooms - Quản lý phòng chat giữa user và host
CREATE TABLE ChatRooms (
    chatRoomId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,              -- User tham gia chat
    hostId INT NOT NULL,              -- Host tham gia chat
    experienceId INT NULL,            -- Experience liên quan (optional)
    accommodationId INT NULL,         -- Accommodation liên quan (optional)
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'CLOSED', 'BLOCKED')),
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    lastMessageAt DATETIME NULL,      -- Thời gian tin nhắn cuối cùng
    lastMessage NVARCHAR(MAX) NULL,   -- Nội dung tin nhắn cuối cùng
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (hostId) REFERENCES Users(userId),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (accommodationId) REFERENCES Accommodations(accommodationId),
    -- Đảm bảo chỉ có 1 chat room giữa user-host cho mỗi experience/accommodation
    CONSTRAINT UQ_ChatRoom_User_Host_Experience UNIQUE (userId, hostId, experienceId),
    CONSTRAINT UQ_ChatRoom_User_Host_Accommodation UNIQUE (userId, hostId, accommodationId)
);
GO

-- Bảng ChatMessages - Lưu trữ tin nhắn
CREATE TABLE ChatMessages (
    messageId INT PRIMARY KEY IDENTITY(1,1),
    chatRoomId INT NOT NULL,
    senderId INT NOT NULL,            -- Người gửi tin nhắn
    receiverId INT NOT NULL,          -- Người nhận tin nhắn
    messageContent NVARCHAR(MAX) NOT NULL,
    messageType NVARCHAR(20) NOT NULL DEFAULT 'TEXT' CHECK (messageType IN ('TEXT', 'IMAGE', 'FILE', 'SYSTEM')),
    attachmentUrl NVARCHAR(255) NULL, -- URL file đính kèm nếu có
    isRead BIT NOT NULL DEFAULT 0,    -- Đã đọc chưa
    isDeleted BIT NOT NULL DEFAULT 0, -- Đã xóa chưa
    editedAt DATETIME NULL,           -- Thời gian chỉnh sửa
    sentAt DATETIME NOT NULL DEFAULT GETDATE(),
    readAt DATETIME NULL,             -- Thời gian đã đọc
    FOREIGN KEY (chatRoomId) REFERENCES ChatRooms(chatRoomId) ON DELETE CASCADE,
    FOREIGN KEY (senderId) REFERENCES Users(userId),
    FOREIGN KEY (receiverId) REFERENCES Users(userId)
);
GO

-- Bảng ChatParticipants - Quản lý thành viên trong chat room (mở rộng cho group chat sau này)
CREATE TABLE ChatParticipants (
    participantId INT PRIMARY KEY IDENTITY(1,1),
    chatRoomId INT NOT NULL,
    userId INT NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'MEMBER' CHECK (role IN ('MEMBER', 'ADMIN')),
    joinedAt DATETIME NOT NULL DEFAULT GETDATE(),
    leftAt DATETIME NULL,
    lastSeenAt DATETIME NULL,         -- Lần cuối online trong chat này
    notificationEnabled BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (chatRoomId) REFERENCES ChatRooms(chatRoomId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    CONSTRAINT UQ_ChatParticipant_Room_User UNIQUE (chatRoomId, userId)
);
GO

-- Tạo indexes để tối ưu hiệu suất
CREATE INDEX IX_ChatRooms_UserId ON ChatRooms(userId);
CREATE INDEX IX_ChatRooms_HostId ON ChatRooms(hostId);
CREATE INDEX IX_ChatRooms_LastMessageAt ON ChatRooms(lastMessageAt DESC);

CREATE INDEX IX_ChatMessages_ChatRoomId ON ChatMessages(chatRoomId);
CREATE INDEX IX_ChatMessages_SenderId ON ChatMessages(senderId);
CREATE INDEX IX_ChatMessages_SentAt ON ChatMessages(sentAt DESC);
CREATE INDEX IX_ChatMessages_IsRead ON ChatMessages(isRead);

CREATE INDEX IX_ChatParticipants_ChatRoomId ON ChatParticipants(chatRoomId);
CREATE INDEX IX_ChatParticipants_UserId ON ChatParticipants(userId);
GO

-- Trigger để cập nhật lastMessage và lastMessageAt khi có tin nhắn mới
CREATE TRIGGER TR_UpdateChatRoom_LastMessage
ON ChatMessages
AFTER INSERT
AS
BEGIN
    UPDATE cr
    SET lastMessage = CASE 
        WHEN i.messageType = 'TEXT' THEN i.messageContent
        WHEN i.messageType = 'IMAGE' THEN N'[Hình ảnh]'
        WHEN i.messageType = 'FILE' THEN N'[File đính kèm]'
        ELSE N'[Tin nhắn hệ thống]'
    END,
    lastMessageAt = i.sentAt
    FROM ChatRooms cr
    INNER JOIN inserted i ON cr.chatRoomId = i.chatRoomId
    WHERE cr.chatRoomId = i.chatRoomId
END
GO

-- Thêm dữ liệu mẫu

-- Tạo chat room giữa traveler và host
INSERT INTO ChatRooms (userId, hostId, experienceId, status) VALUES
(
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    (SELECT experienceId FROM Experiences WHERE title = N'Tour đạp xe quanh Hà Nội'),
    'ACTIVE'
);

DECLARE @chatRoomId INT = SCOPE_IDENTITY();

-- Thêm participants
INSERT INTO ChatParticipants (chatRoomId, userId) VALUES
(@chatRoomId, (SELECT userId FROM Users WHERE email='tr1@example.com')),
(@chatRoomId, (SELECT userId FROM Users WHERE email='host1@example.com'));

-- Thêm tin nhắn mẫu
INSERT INTO ChatMessages (chatRoomId, senderId, receiverId, messageContent) VALUES
(
    @chatRoomId,
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    N'Xin chào! Tôi quan tâm đến tour đạp xe của bạn.'
),
(
    @chatRoomId,
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    N'Chào bạn! Cảm ơn bạn đã quan tâm. Tour rất thú vị, bạn có câu hỏi gì không?'
),
(
    @chatRoomId,
    (SELECT userId FROM Users WHERE email='tr1@example.com'),
    (SELECT userId FROM Users WHERE email='host1@example.com'),
    N'Tour có phù hợp với người mới bắt đầu không ạ?'
);
GO
USE TravelerDB;
GO
CREATE TABLE Favorites (
    favoriteId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    experienceId INT NULL,
    accommodationId INT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (accommodationId) REFERENCES Accommodations(accommodationId),
    CHECK (experienceId IS NOT NULL OR accommodationId IS NOT NULL),
    CHECK (NOT (experienceId IS NOT NULL AND accommodationId IS NOT NULL)) -- Chỉ cho phép 1 trong 2
);

-- Tạo indexes
CREATE INDEX IX_Favorites_UserId ON Favorites(userId);
CREATE INDEX IX_Favorites_CreatedAt ON Favorites(createdAt DESC);

-- Tạo UNIQUE CONSTRAINTS ĐÚNG CÁCH với filtered indexes
-- Chỉ áp dụng unique khi giá trị không NULL
CREATE UNIQUE NONCLUSTERED INDEX UQ_Favorites_User_Experience 
ON Favorites (userId, experienceId) 
WHERE experienceId IS NOT NULL;

CREATE UNIQUE NONCLUSTERED INDEX UQ_Favorites_User_Accommodation 
ON Favorites (userId, accommodationId) 
WHERE accommodationId IS NOT NULL;

-- Kiểm tra schema
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Favorites'
ORDER BY ORDINAL_POSITION;

-- Kiểm tra indexes
SELECT 
    i.name as index_name,
    i.type_desc,
    i.is_unique,
    c.name as column_name
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Favorites')
ORDER BY i.name, ic.index_column_id;
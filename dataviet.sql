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
    role NVARCHAR(50) NOT NULL CHECK (role IN ('TRAVELER', 'HOST', 'ADMIN')),
    preferences NVARCHAR(MAX),
    businessName NVARCHAR(100),
    businessType NVARCHAR(50),
    businessAddress NVARCHAR(255),
    businessDescription NVARCHAR(500),
    taxId NVARCHAR(50),
    skills NVARCHAR(500),
    region NVARCHAR(50),
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalExperiences INT NOT NULL DEFAULT 0,
    totalRevenue FLOAT NOT NULL DEFAULT 0,
    totalBookings INT NOT NULL DEFAULT 0,
    permissions NVARCHAR(MAX),
    emailVerified BIT NOT NULL DEFAULT 0,
    verificationToken NVARCHAR(255),
    tokenExpiry DATETIME,
    payosClientId NVARCHAR(255) NULL,
    payosApiKey NVARCHAR(255) NULL, 
    payosChecksumKey NVARCHAR(255) NULL
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
    description NVARCHAR(MAX) NULL,
    location NVARCHAR(255) NOT NULL,
    cityId INT NOT NULL,
    type NVARCHAR(50) NOT NULL,
    price FLOAT NOT NULL,
    maxGroupSize INT NOT NULL,
    duration TIME(7) NOT NULL,
    difficulty NVARCHAR(20) NULL CHECK (difficulty IN ('EASY', 'MODERATE', 'CHALLENGING')),
    language NVARCHAR(50) NULL,
    includedItems NVARCHAR(MAX) NULL,
    requirements NVARCHAR(MAX) NULL,
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    isActive BIT NOT NULL DEFAULT 1,
    images NVARCHAR(MAX) NULL,
    averageRating FLOAT NOT NULL DEFAULT 0,
    totalBookings INT NOT NULL DEFAULT 0,
    FOREIGN KEY (hostId) REFERENCES Users(userId),
    FOREIGN KEY (cityId) REFERENCES Cities(cityId)
);
GO
ALTER TABLE Experiences
ADD promotion_percent INT DEFAULT 0,
    promotion_start DATETIME,
    promotion_end DATETIME;

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
ALTER TABLE Accommodations
ADD promotion_percent INT DEFAULT 0,
    promotion_start DATETIME,
    promotion_end DATETIME;

-- Thêm cột maxOccupancy vào bảng Accommodations
ALTER TABLE Accommodations 
ADD maxOccupancy INT NOT NULL DEFAULT 2;
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

-- Bảng ChatRooms
CREATE TABLE ChatRooms (
    chatRoomId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    hostId INT NOT NULL,
    experienceId INT NULL,
    accommodationId INT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'CLOSED', 'BLOCKED')),
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    lastMessageAt DATETIME NULL,
    lastMessage NVARCHAR(MAX) NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (hostId) REFERENCES Users(userId),
    FOREIGN KEY (experienceId) REFERENCES Experiences(experienceId),
    FOREIGN KEY (accommodationId) REFERENCES Accommodations(accommodationId)
);
GO

-- Bảng ChatMessages
CREATE TABLE ChatMessages (
    messageId INT PRIMARY KEY IDENTITY(1,1),
    chatRoomId INT NOT NULL,
    senderId INT NOT NULL,
    receiverId INT NOT NULL,
    messageContent NVARCHAR(MAX) NOT NULL,
    messageType NVARCHAR(20) NOT NULL DEFAULT 'TEXT' CHECK (messageType IN ('TEXT', 'IMAGE', 'FILE', 'SYSTEM')),
    attachmentUrl NVARCHAR(255) NULL,
    isRead BIT NOT NULL DEFAULT 0,
    isDeleted BIT NOT NULL DEFAULT 0,
    editedAt DATETIME NULL,
    sentAt DATETIME NOT NULL DEFAULT GETDATE(),
    readAt DATETIME NULL,
    FOREIGN KEY (chatRoomId) REFERENCES ChatRooms(chatRoomId) ON DELETE CASCADE,
    FOREIGN KEY (senderId) REFERENCES Users(userId),
    FOREIGN KEY (receiverId) REFERENCES Users(userId)
);
GO

-- Bảng ChatParticipants
CREATE TABLE ChatParticipants (
    participantId INT PRIMARY KEY IDENTITY(1,1),
    chatRoomId INT NOT NULL,
    userId INT NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'MEMBER' CHECK (role IN ('MEMBER', 'ADMIN')),
    joinedAt DATETIME NOT NULL DEFAULT GETDATE(),
    leftAt DATETIME NULL,
    lastSeenAt DATETIME NULL,
    notificationEnabled BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (chatRoomId) REFERENCES ChatRooms(chatRoomId) ON DELETE CASCADE,
    FOREIGN KEY (userId) REFERENCES Users(userId)
);
GO

-- Bảng Favorites
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
    CHECK (NOT (experienceId IS NOT NULL AND accommodationId IS NOT NULL))
);
GO

-- Tạo các indexes
CREATE INDEX IX_ChatRooms_UserId ON ChatRooms(userId);
CREATE INDEX IX_ChatRooms_HostId ON ChatRooms(hostId);
CREATE INDEX IX_ChatRooms_LastMessageAt ON ChatRooms(lastMessageAt DESC);

CREATE INDEX IX_ChatMessages_ChatRoomId ON ChatMessages(chatRoomId);
CREATE INDEX IX_ChatMessages_SenderId ON ChatMessages(senderId);
CREATE INDEX IX_ChatMessages_SentAt ON ChatMessages(sentAt DESC);
CREATE INDEX IX_ChatMessages_IsRead ON ChatMessages(isRead);

CREATE INDEX IX_ChatParticipants_ChatRoomId ON ChatParticipants(chatRoomId);
CREATE INDEX IX_ChatParticipants_UserId ON ChatParticipants(userId);

CREATE INDEX IX_Favorites_UserId ON Favorites(userId);
CREATE INDEX IX_Favorites_CreatedAt ON Favorites(createdAt DESC);

-- Tạo unique constraints cho ChatRooms
CREATE UNIQUE NONCLUSTERED INDEX UQ_ChatRoom_User_Host_Experience 
ON ChatRooms (userId, hostId, experienceId) 
WHERE experienceId IS NOT NULL;

CREATE UNIQUE NONCLUSTERED INDEX UQ_ChatRoom_User_Host_Accommodation 
ON ChatRooms (userId, hostId, accommodationId) 
WHERE accommodationId IS NOT NULL;

-- Tạo unique constraints cho ChatParticipants
CREATE UNIQUE NONCLUSTERED INDEX UQ_ChatParticipant_Room_User 
ON ChatParticipants (chatRoomId, userId);

-- Tạo unique constraints cho Favorites
CREATE UNIQUE NONCLUSTERED INDEX UQ_Favorites_User_Experience 
ON Favorites (userId, experienceId) 
WHERE experienceId IS NOT NULL;

CREATE UNIQUE NONCLUSTERED INDEX UQ_Favorites_User_Accommodation 
ON Favorites (userId, accommodationId) 
WHERE accommodationId IS NOT NULL;
GO

-- Trigger để cập nhật lastMessage và lastMessageAt
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

-- Chèn tất cả 70 users với tên thật như ban đầu
INSERT INTO Users (email, password, fullName, phone, dateOfBirth, gender, role, emailVerified) VALUES
('user1@example.com', '123456', N'Vũ Hữu Mai', '0912345678', '1985-01-15', N'Nam', 'HOST', 1),
('user2@example.com', '123456', N'Hoàng Thanh Kiên', '0923456789', '1990-02-20', N'Nam', 'HOST', 1),
('user3@example.com', '123456', N'Huỳnh Tấn Việt', '0934567890', '1988-03-25', N'Nam', 'HOST', 1),
('user4@example.com', '123456', N'Hoàng Thanh Nam', '0945678901', '1987-04-30', N'Nam', 'HOST', 1),
('user5@example.com', '123456', N'Phạm Gia Hà', '0956789012', '1992-05-05', N'Nữ', 'HOST', 1),
('user6@example.com', '123456', N'Phan Văn Phúc', '0967890123', '1986-06-10', N'Nam', 'HOST', 1),
('user7@example.com', '123456', N'Vũ Thị Hà', '0978901234', '1991-07-15', N'Nữ', 'HOST', 1),
('user8@example.com', '123456', N'Huỳnh Ngọc Hùng', '0989012345', '1984-08-20', N'Nam', 'HOST', 1),
('user9@example.com', '123456', N'Phan Ngọc Hùng', '0990123456', '1989-09-25', N'Nam', 'HOST', 1),
('user10@example.com', '123456', N'Phạm Văn Kiên', '0901234567', '1993-10-30', N'Nam', 'HOST', 1),
('user11@example.com', '123456', N'Đặng Ngọc Sơn', '0912345670', '1985-11-05', N'Nam', 'HOST', 1),
('user12@example.com', '123456', N'Huỳnh Trọng Kiên', '0923456781', '1990-12-10', N'Nam', 'HOST', 1),
('user13@example.com', '123456', N'Huỳnh Hữu Hùng', '0934567892', '1988-01-15', N'Nam', 'HOST', 1),
('user14@example.com', '123456', N'Bùi Hữu Lam', '0945678903', '1987-02-20', N'Nam', 'HOST', 1),
('user15@example.com', '123456', N'Huỳnh Gia Hạnh', '0956789014', '1992-03-25', N'Nữ', 'HOST', 1),
('user16@example.com', '123456', N'Phạm Trọng Châu', '0967890125', '1986-04-30', N'Nam', 'HOST', 1),
('user17@example.com', '123456', N'Nguyễn Hữu Trang', '0978901236', '1991-05-05', N'Nữ', 'HOST', 1),
('user18@example.com', '123456', N'Phạm Thị Hùng', '0989012347', '1984-06-10', N'Nữ', 'HOST', 1),
('user19@example.com', '123456', N'Vũ Trọng Lam', '0990123458', '1989-07-15', N'Nam', 'HOST', 1),
('user20@example.com', '123456', N'Phan Đức Châu', '0901234569', '1993-08-20', N'Nam', 'HOST', 1),
('user21@example.com', '123456', N'Hoàng Hữu Lam', '0912345671', '1985-09-25', N'Nam', 'HOST', 1),
('user22@example.com', '123456', N'Vũ Đức Hùng', '0923456782', '1990-10-30', N'Nam', 'HOST', 1),
('user23@example.com', '123456', N'Đặng Đức Nam', '0934567893', '1988-11-05', N'Nam', 'HOST', 1),
('user24@example.com', '123456', N'Bùi Thanh Quân', '0945678904', '1987-12-10', N'Nam', 'HOST', 1),
('user25@example.com', '123456', N'Trần Đức Bình', '0956789015', '1992-01-15', N'Nam', 'HOST', 1),
('user26@example.com', '123456', N'Phạm Trọng Châu', '0967890126', '1986-02-20', N'Nam', 'HOST', 1),
('user27@example.com', '123456', N'Phạm Gia Hạnh', '0978901237', '1991-03-25', N'Nữ', 'HOST', 1),
('user28@example.com', '123456', N'Lê Trọng Dương', '0989012348', '1984-04-30', N'Nam', 'HOST', 1),
('user29@example.com', '123456', N'Bùi Thị Yến', '0990123459', '1989-05-05', N'Nữ', 'HOST', 1),
('user30@example.com', '123456', N'Nguyễn Thị Lam', '0901234560', '1993-06-10', N'Nữ', 'HOST', 1),
-- Travelers (user31-55)
('user31@example.com', '123456', N'Nguyễn Thị Hùng', '0912345672', '1985-07-15', N'Nữ', 'TRAVELER', 1),
('user32@example.com', '123456', N'Phạm Gia Hạnh', '0923456783', '1990-08-20', N'Nữ', 'TRAVELER', 1),
('user33@example.com', '123456', N'Hoàng Gia Trang', '0934567894', '1988-09-25', N'Nữ', 'TRAVELER', 1),
('user34@example.com', '123456', N'Bùi Gia Sơn', '0945678905', '1987-10-30', N'Nam', 'TRAVELER', 1),
('user35@example.com', '123456', N'Phạm Hữu Mai', '0956789016', '1992-11-05', N'Nữ', 'TRAVELER', 1),
('user36@example.com', '123456', N'Lê Ngọc Trang', '0967890127', '1986-12-10', N'Nữ', 'TRAVELER', 1),
('user37@example.com', '123456', N'Huỳnh Văn Kiên', '0978901238', '1991-01-15', N'Nam', 'TRAVELER', 1),
('user38@example.com', '123456', N'Nguyễn Đức Trang', '0989012349', '1984-02-20', N'Nữ', 'TRAVELER', 1),
('user39@example.com', '123456', N'Đặng Văn Sơn', '0990123450', '1989-03-25', N'Nam', 'TRAVELER', 1),
('user40@example.com', '123456', N'Đặng Ngọc Yến', '0901234561', '1993-04-30', N'Nữ', 'TRAVELER', 1),
('user41@example.com', '123456', N'Phạm Trọng Dương', '0912345673', '1985-05-05', N'Nam', 'TRAVELER', 1),
('user42@example.com', '123456', N'Lê Hữu An', '0923456784', '1990-06-10', N'Nam', 'TRAVELER', 1),
('user43@example.com', '123456', N'Hoàng Gia Hạnh', '0934567895', '1988-07-15', N'Nữ', 'TRAVELER', 1),
('user44@example.com', '123456', N'Phan Gia Nam', '0945678906', '1987-08-20', N'Nam', 'TRAVELER', 1),
('user45@example.com', '123456', N'Trần Thị Phúc', '0956789017', '1992-09-25', N'Nữ', 'TRAVELER', 1),
('user46@example.com', '123456', N'Đặng Thị Bình', '0967890128', '1986-10-30', N'Nữ', 'TRAVELER', 1),
('user47@example.com', '123456', N'Nguyễn Minh Kiên', '0978901239', '1991-11-05', N'Nam', 'TRAVELER', 1),
('user48@example.com', '123456', N'Đặng Trọng Hà', '0989012340', '1984-12-10', N'Nam', 'TRAVELER', 1),
('user49@example.com', '123456', N'Phan Thị Lam', '0990123451', '1989-01-15', N'Nữ', 'TRAVELER', 1),
('user50@example.com', '123456', N'Phạm Văn Việt', '0901234562', '1993-02-20', N'Nam', 'TRAVELER', 1),
('user51@example.com', '123456', N'Phan Thanh Sơn', '0912345674', '1985-03-25', N'Nam', 'TRAVELER', 1),
('user52@example.com', '123456', N'Phạm Thanh Mai', '0923456785', '1990-04-30', N'Nữ', 'TRAVELER', 1),
('user53@example.com', '123456', N'Vũ Thị Quân', '0934567896', '1988-05-05', N'Nữ', 'TRAVELER', 1),
('user54@example.com', '123456', N'Huỳnh Thanh Việt', '0945678907', '1987-06-10', N'Nam', 'TRAVELER', 1),
('user55@example.com', '123456', N'Huỳnh Đức Sơn', '0956789018', '1992-07-15', N'Nam', 'TRAVELER', 1),
-- Hosts (user56-70)
('user56@example.com', '123456', N'Hoàng Đức Trang', '0967890129', '1986-08-20', N'Nữ', 'HOST', 1),
('user57@example.com', '123456', N'Hoàng Tấn Hùng', '0978901230', '1991-09-25', N'Nam', 'HOST', 1),
('user58@example.com', '123456', N'Đặng Hữu Nam', '0989012341', '1984-10-30', N'Nam', 'HOST', 1),
('user59@example.com', '123456', N'Trần Thanh Kiên', '0990123452', '1989-11-05', N'Nam', 'HOST', 1),
('user60@example.com', '123456', N'Hoàng Đức Việt', '0901234563', '1993-12-10', N'Nam', 'HOST', 1),
('user61@example.com', '123456', N'Lê Gia Phúc', '0912345675', '1985-01-15', N'Nam', 'HOST', 1),
('user62@example.com', '123456', N'Trần Hữu Dương', '0923456786', '1990-02-20', N'Nam', 'HOST', 1),
('user63@example.com', '123456', N'Phạm Thị Lam', '0934567897', '1988-03-25', N'Nữ', 'HOST', 1),
('user64@example.com', '123456', N'Đặng Đức Sơn', '0945678908', '1987-04-30', N'Nam', 'HOST', 1),
('user65@example.com', '123456', N'Vũ Minh Châu', '0956789019', '1992-05-05', N'Nam', 'HOST', 1),
('user66@example.com', '123456', N'Trần Trọng Lam', '0967890120', '1986-06-10', N'Nam', 'HOST', 1),
('user67@example.com', '123456', N'Bùi Thị Kiên', '0978901231', '1991-07-15', N'Nữ', 'HOST', 1),
('user68@example.com', '123456', N'Lê Minh Hà', '0989012342', '1984-08-20', N'Nữ', 'HOST', 1),
('user69@example.com', '123456', N'Lê Ngọc Sơn', '0990123453', '1989-09-25', N'Nam', 'HOST', 1),
('user70@example.com', '123456', N'Đặng Đức An', '0901234564', '1993-10-30', N'Nam', 'HOST', 1);
GO

-- Chèn tất cả Experiences với dữ liệu gốc
INSERT INTO Experiences (hostId, title, description, location, cityId, type, price, maxGroupSize, duration, difficulty, language, includedItems, requirements, images, isActive) VALUES
(4, N'Thưởng thức Bún Chả Cá Đà Nẵng', N'Nước dùng ninh từ xương cá ngọt thanh...', N'319 Hùng Vương, Hải Châu, Đà Nẵng', 6, N'Food', 120000, 10, '01:30:00', 'EASY', 'Vietnamese', N'1 tô bún chả cá + nước uống', N'Không dị ứng cá', N'bun-cha-ca.jpg', 1),
(4, N'Tháp Bà Ponagar', N'Quần thể kiến trúc tôn giáo cổ xưa của người Chăm, gồm bốn tháp chính và một số tháp nhỏ, được xây dựng từ thế kỷ VIII đến XIII để thờ nữ thần Ponagar.', N'Đường Hai Tháng Tư, Vĩnh Phước, TP. Nha Trang', 9, N'Culture', 50000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', N'thap-ba-ponagar-nha-trang-5.jpg', 1),
(4, N'VinWonders Nha Trang', N'Công viên giải trí đa dạng với nhiều khu vực vui chơi như công viên nước, khu vui chơi ngoài trời, thủy cung, khu ẩm thực... phù hợp cho mọi lứa tuổi.', N'Đảo Hòn Tre, Vĩnh Nguyên, TP. Nha Trang', 9, N'Adventure', 50000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', N'vinwonders-nha-trang-4.jpg', 1),
(5, N'Tắm bùn khoáng', N'Trải nghiệm thư giãn, tốt cho sức khỏe tại các khu tắm bùn nổi tiếng như Tháp Bà, Trăm Trứng và I-Resort.', N' Trung tâm Tháp Bà – 15 Ngọc Sơn, Ngọc Hiệp, TP. Nha Trang Khu du lịch Trăm Trứng – Đại lộ Nguyễn Tất Thành, Phước Đồng, TP. Nha Trang I-Resort – Tổ 19, thôn Xuân Ngọc, Vĩnh Ngọc, TP. Nha Trang', 9, N'Adventure', 50000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', N'tam-bun-nha-trang.jpg', 1),
(4, N'Trải nghiệm lịch sử Văn Miếu tại Hà Nội', N'Tham quan lịch sử Văn Miếu Quốc Tử Giám', N'58 Quốc Tử Giám, Đống Đa', 1, N'History', 70000, 8, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'vanmieu.jpg', 1),
(4, N'Tour ẩm thực tại Hà Nội', N'Bún chả Hà Nội là món ăn truyền thống gồm ba thành phần chính: bún tươi, chả nướng và nước chấm. Chả được làm từ thịt lợn thái mỏng hoặc xay, tẩm ướp gia vị rồi nướng trên than hoa, tạo hương thơm đặc trưng. Nước chấm pha từ nước mắm, giấm, đường, tỏi, ớt, kèm theo đu đủ xanh hoặc cà rốt thái mỏng, tạo vị chua ngọt hài hòa. Món ăn thường được dùng kèm với rau sống như xà lách, tía tô, húng lủi, kinh giới.', N'24 Lê Văn Hưu, Hai Bà Trưng', 1, N'Food', 70000, 12, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'buncha.jpg', 1),
(5, N'Trải nghiệm ẩm thực đường phố Bánh đa cua  tại Hải Phòng ', N'Món ăn mang đậm hương vị miền biển với sợi bánh đa đỏ dẻo dai, nước dùng ninh từ cua đồng, topping đầy đủ gồm chả lá lốt, giò, tôm, rau muống chần. Vị ngọt thanh, béo ngậy và mùi thơm đặc trưng là điểm nhấn khó quên.', N'Bánh đa cua bà Cụ – 179 Cầu Đất, Ngô Quyền - Bánh đa cua Lạch Tray – 48 Lạch Tray, Ngô Quyền', 2, N'Culture', 70000, 10, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'banhdacua.jpg', 1),
(4, N'Trải nghiệm phiêu lưu biển Đồ Sơn Hải Phòng', N'Đồ Sơn sở hữu những bãi cát dài, nước biển mát lạnh và các hoạt động thú vị như moto nước, kéo dù bay, cắm trại ven biển. Du khách có thể kết hợp nghỉ dưỡng và tham quan biệt thự Bảo Đại – một di tích lịch sử nổi bật.', N'Khu du lịch Đồ Sơn, Đồ Sơn, cách trung tâm TP khoảng 20km', 2, N'Adventure', 100000, 8, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'biendoson.jpg', 1),
(5, N'Chèo kayak khám phá vịnh Hạ Long', N'Chèo kayak là cách tuyệt vời để khám phá các hang động, hòn đảo và làng chài trên vịnh Hạ Long. Du khách có thể tự mình điều khiển kayak, len lỏi qua các hang động như Hang Luồn, Hang Sáng – Tối, tận hưởng vẻ đẹp thiên nhiên kỳ vĩ. ', N'Vịnh Hạ Long, Quảng Ninh', 4, N'Adventure', 70000, 12, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'cheokayak.jpg', 1),
(4, N'Trải nghiệm món bún bề bề Hạ Long', N'Bún bề bề là món ăn đặc trưng với bề bề (tôm tít) tươi ngon, nước dùng ngọt thanh từ xương và hải sản, ăn kèm rau sống và chả mực, tạo nên hương vị đậm đà khó quên. ', N'36 Đoàn Thị Điểm, P. Bạch Đằng, TP. Hạ Long', 4, N'Food', 70000, 8, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'bunbebe.jpeg', 1),
(5, N'Trải nghiệm ẩm thực cơm cháy Ninh Bình', N'Cơm cháy Ninh Bình được làm từ gạo ngon, chiên giòn và ăn kèm với nước sốt đặc biệt từ thịt dê hoặc thịt bò, tạo nên món ăn hấp dẫn, giòn rụm và đậm đà hương vị. ', N'Nhà hàng Thăng Long – Tràng An, xã Trường Yên, huyện Hoa Lư, tỉnh Ninh Bình', 5, N'History', 150000, 8, '02:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'4159_com_chay_ninh_binh.jpg', 1),
(4, N'Chùa Bái Đính', N'Chùa Bái Đính là quần thể chùa lớn nhất Việt Nam, nổi bật với kiến trúc hoành tráng và nhiều kỷ lục như tượng Phật bằng đồng lớn nhất châu Á, hành lang La Hán dài nhất. Đây là điểm đến tâm linh thu hút đông đảo du khách.', N'Xã Gia Sinh, huyện Gia Viễn, tỉnh Ninh Bình', 5, N'History', 100000, 8, '03:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'Chua-Bai-Dinh-1.jpg', 1),
(5, N'Ngồi thuyền rồng nghe ca Huế trên sông Hương', N'Thưởng thức ca Huế – dòng nhạc truyền thống cung đình và dân gian – khi thuyền rồng trôi nhẹ trên sông Hương về đêm. Một trải nghiệm nhẹ nhàng và lãng mạn.', N'Bến thuyền Tòa Khâm – Lê Lợi, TP Huế', 7, N'Culture', 70000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'nghecahue.jpg', 1),
(4, N'Ăn bún bò Huế chính gốc', N': Món ăn đặc trưng nổi tiếng khắp cả nước, nước lèo ngọt xương, thơm sả, vị cay nồng đặc trưng. Thường ăn kèm giò heo, chả cua, huyết, rau sống.', N'Bún bò Mệ Kéo – 20 Bạch Đằng, Phường Phú Cát, TP Huế (quán hơn 70 năm, giữ đúng vị Huế xưa)', 7, N'Food', 70000, 8, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'bun-bo-hue.jpg', 1),
(5, N'Trải nghiệm Bún chả cá Đà Nẵng', N'Nước dùng được ninh từ xương cá, có vị ngọt thanh đặc trưng, ăn kèm với chả cá chiên và hấp, thêm rau sống, bắp cải muối, ớt tỏi.', N'Bún chả cá Bà Lữ – 319 Hùng Vương, Hải Châu', 6, N'Food', 150000, 12, '03:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'bun-cha-ca-da-nang-2.jpg', 1),
(4, N'Lặn biển khám phá san hô tại bán đảo Sơn Trà', N'Bán đảo Sơn Trà là nơi lý tưởng để lặn biển, khám phá hệ sinh thái dưới nước với các rạn san hô đầy màu sắc. Các địa danh như Hòn Sụp, Bãi Rạng và Bãi Bụt là điểm đến phổ biến cho hoạt động này. ', N'Bán đảo Sơn Trà, Đà Nẵng', 6, N'Adventure', 150000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'lan-ngam-san-ho-ban-dao-son-tra-hava-travel-3.jpg', 1),
(5, N'Trượt thác Hòa Phú Thành', N' Trượt thác Hòa Phú Thành là hoạt động mạo hiểm hấp dẫn, nơi du khách ngồi trên thuyền phao và vượt qua các thác ghềnh tự nhiên. Ngoài ra, khu du lịch còn có các hoạt động như zipline, tắm suối và cắm trại giữa thiên nhiên hoang sơ. ', N'Xã Hòa Phú, huyện Hòa Vang, Đà Nẵng', 6, N'Adventure', 150000, 10, '01:30:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'truothac.jpg', 1),
(4, N'Thánh địa Mỹ Sơn – Kinh đô tinh của Champa cổ', N'Thánh địa Mỹ Sơn là quần thể vương miện Hindu giáo cổ xưa nhất Đông Nam Á, từng là trung tâm tín ngưỡng và văn hóa của vương quốc Champa. Được xây dựng từ thế kỷ 4 đến 13, nơi đây sở hữu hàng tháp tháp Chăm sóc với kỹ thuật xây dựng bí ẩn, kiến trúc chạm khắc tinh thần và không khí linh thiêng cổ kính. Được UNESCO công nhận là Di sản Văn hóa Thế giới năm 1999.', N'Xã Duy Phú, huyện Duy Xuyên, Quảng Nam', 8, N'History', 120000, 12, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'my-son.jpg', 1),
(5, N'Nem nướng Nha Trang', N'Món ăn đặc sản nổi tiếng, gồm nem nướng thơm lừng, bánh tráng chiên giòn, rau sống và nước sốt đặc biệt. Khi ăn, cuốn tất cả lại và chấm với nước sốt, tạo nên hương vị hòa quyện độc đáo.', N'16A Lãn Ông, TP. Nha Trang', 9, N'Food', 150000, 10, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'nem_nuong.jpg', 1),
(4, N'Bún sứa Nha Trang', N'Món bún với sứa tươi giòn, nước lèo trong vắt nấu từ cá tươi, ăn kèm rau sống và gia vị, tạo nên hương vị thanh mát, đặc trưng của biển.', N'Quán bún sứa Dốc Lếch – Ngã tư Yersin – Bà Triệu, TP. Nha Trang', 9, N'Food', 100000, 8, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'bunsua.jpg', 1),
(5, N'Tháp Đôi (Tháp Hưng Thạnh)', N'Công trình kiến trúc Chăm Pa độc đáo với hai tháp nằm cạnh nhau, mang đậm dấu ấn văn hóa Chăm', N'Đường Trần Hưng Đạo, TP. Quy Nhơn.', 10, N'Culture', 70000, 12, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'thapdoi.jpg', 1),
(4, N'Nem Nướng Cái Răng', N'Nếu Phan Rang có nem nướng nổi tiếng, thì Cái Răng (Cần Thơ) cũng tự hào với món nem nướng mang hương vị rất riêng. Nem được làm từ thịt heo xay nhuyễn, ướp gia vị vừa ăn, sau đó nặn thành từng xiên rồi nướng trên bếp than hồng cho thơm phức. Khi ăn, người ta cuốn nem với bánh hỏi hoặc bánh tráng mỏng, rau sống, chuối chát, dưa leo...', N'Nem nướng Thanh Vân - 17 Lê Lợi, phường Cái Khế, quận Ninh Kiều, TP. Cần Thơ', 13, N'Food', 120000, 12, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'nemnuongcairang2.jpg', 1),
(5, N'Bánh Xèo Củ Hủ Dừa', N'Bánh xèo ở miền Tây nói chung vốn đã nổi tiếng với kích thước "khổng lồ" và vỏ bánh vàng giòn. Nhưng ở Cần Thơ, người ta còn sáng tạo khi dùng củ hủ dừa – phần non và ngọt nhất trong thân cây dừa – làm nhân bánh. Khi kết hợp với tôm đất, thịt heo thái mỏng và giá đỗ, tạo nên một món ăn vừa giòn, vừa béo, lại thơm ngọt tự nhiên từ củ hủ dừa.', N'Bánh xèo 7 Tới - 45 Hoàng Quốc Việt, P. An Bình, Q. Ninh Kiều, TP. Cần Thơ', 13, N'Food', 100000, 8, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'BanhXeoHuCot2.jpg', 1),
(4, N'Ăn trải nghiệm Bánh ướt lòng gà', N'Khác với bánh ướt ở miền Nam ăn kèm chả, bánh ướt ở Đà Lạt lại kết hợp với lòng gà, thịt gà xé và nước mắm chua ngọt đặc trưng. Vị dẻo của bánh, mềm của thịt gà và dai giòn của lòng gà tạo nên hương vị độc đáo.', N'Quán Long: 202 Phan Đình Phùng, P.2', 15, N'Food', 70000, 12, '01:30:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'BanhUotLongGa1.jpg', 1),
(5, N'Trải nghiệm ẩm thực và làm bánh khọt Vũng Tàu', N'Bánh khọt là món ăn đặc trưng của Vũng Tàu, được làm từ bột gạo, nhân tôm tươi, chiên giòn và ăn kèm với rau sống và nước mắm chua ngọt. Điểm đặc biệt của bánh khọt Vũng Tàu là lớp bột dày, giòn rụm bên ngoài và mềm bên trong, tạo nên hương vị độc đáo.', N'Địa chỉ: 14 Hoàng Hoa Thám, Phường 3, TP. Vũng Tàu', 12, N'Food', 50000, 8, '03:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'Banhkhot1.jpg', 1),
(4, N'Nếm thử hương vị lẩu cá đuối', N'Lẩu cá đuối là món ăn đặc sản của Vũng Tàu, với nước dùng chua cay, cá đuối mềm không xương, thường ăn kèm bún và rau sống. Cá đuối được chế biến kỹ lưỡng để không bị tanh, tạo nên hương vị đậm đà.', N'Địa chỉ: 37 Nguyễn Trường Tộ, Phường 3, TP. Vũng Tàu', 12, N'Food', 70000, 10, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'laucaduoi2.jpg', 1),
(5, N'Tham quan một vòng Chợ Nổi Cái Răng', N'Đây là chợ nổi lớn nhất và nổi tiếng nhất ở Cần Thơ, đặc trưng cho văn hóa sông nước miền Tây. Du khách có thể thuê thuyền dạo quanh sông, xem người dân buôn bán trên thuyền, thưởng thức các món ăn đặc sản và trái cây tươi ngay trên thuyền. Buổi sáng sớm là thời điểm chợ hoạt động sôi nổi nhất.', N'Phường Cái Răng, Quận Cái Răng, TP. Cần Thơ', 13, N'Adventure', 150000, 10, '01:30:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'ChoNoiCaiRang2.jpg', 1),
(4, N'Checkin tại vườn cò Bằng Lăng', N'Khu vườn cò rộng hàng chục hécta nằm ở vùng ngoại ô Cần Thơ, nổi tiếng với đàn cò trắng bay rợp trời vào mùa. Bạn có thể đi thuyền nhỏ len lỏi qua các kênh rạch, ngắm cảnh thiên nhiên hoang sơ và ghi lại những khoảnh khắc độc đáo của chim cò.', N'Ấp Bằng Lăng, Xã Mỹ Khánh, Huyện Phong Điền, TP. Cần Thơ', 13, N'Culture', 70000, 8, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'VuonCoBangLang2.jpg', 1),
(5, N'Thưởng Thức hương vị lẩu bò Ba Toa', N'Lẩu bò kiểu Đà Lạt dùng thịt bò nhiều gân, nạm mềm, gầu béo nhẹ. Nước lẩu đậm vị, ăn kèm mì gói, đậu hũ, rau tươi Đà Lạt. Không khí lạnh khiến món này cực kỳ hấp dẫn.', N'Lẩu bò Ba Toa – Nhà Gỗ: 1/29 Hoàng Diệu - Lẩu bò Quán Gỗ cũ: 2/2 Hoàng Diệu', 15, N'Food', 120000, 10, '03:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'LauBoBaToa1.jpg', 1),
(4, N'Thử sức Canyoning – Vượt thác Datanla', N'Canyoning là bộ môn thể thao mạo hiểm kết hợp: leo dây vượt thác, trượt nước tự nhiên, nhảy tự do từ vách đá xuống hồ sâu, và bơi trong suối. Có huấn luyện viên chuyên nghiệp hướng dẫn, đảm bảo an toàn. Thích hợp với những ai muốn thử thách bản thân và đam mê cảm giác mạnh.', N'Khu du lịch thác Datanla, Quốc lộ 20, phường 3, TP. Đà Lạt', 15, N'Adventure', 70000, 12, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'canyoning2.jpg', 1),
(5, N'Di tích lịch sử Đồng Khởi Bến Tre', N'Sự kiện Đồng Khởi diễn ra vào tháng 1 năm 1960 tại Bến Tre là bước ngoặt quan trọng trong cuộc kháng chiến chống Mỹ cứu nước. Đây là phong trào cách mạng lớn, đánh dấu sự chuyển biến từ thế giữ gìn lực lượng sang thế tiến công mạnh mẽ của nhân dân miền Nam. Di tích Đồng Khởi hiện có nhiều công trình tưởng niệm, bảo tàng trưng bày hiện vật, hình ảnh, tư liệu quý giá về phong trào cách mạng và cuộc sống chiến đấu của nhân dân Bến Tre.', N'Số 116, Đường Nguyễn Huệ, Phường Phú Khương, Thành phố Bến Tre, tỉnh Bến Tre.', 16, N'History', 70000, 8, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'Ditichdongkhoibentre1.jpg', 1),
(4, N'Thăm quan lịch sử Bến Tre : Nhà cổ Huỳnh Thủy Lê ', N'Nhà cổ Huỳnh Thủy Lê là một ngôi nhà xây dựng vào cuối thế kỷ 19, mang kiến trúc kết hợp giữa phong cách phương Tây và truyền thống Nam Bộ. Đây là ngôi nhà của ông Huỳnh Thủy Lê – một doanh nhân giàu có người Hoa, nổi tiếng qua câu chuyện tình lãng mạn với nữ văn sĩ Pháp Marguerite Duras, tác giả cuốn tiểu thuyết "Người tình" (L''Amant). Ngôi nhà được bảo tồn gần như nguyên vẹn, với những chi tiết nội thất, cửa sổ, mái ngói rất độc đáo, là minh chứng sống cho lịch sử giao thoa văn hóa giữa Việt Nam và Pháp trong thời kỳ thuộc địa.', N'255 Nguyễn Đình Chiểu, Phường 1, Thành phố Bến Tre, tỉnh Bến Tre.', 16, N'History', 150000, 12, '03:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'nhacohuynhthuyle2.jpg', 1),
(4, N'Trải nghiệm phở Lý Quốc Sư', N'Nổi tiếng với nước dùng đậm đà và thịt bò thái mỏng, phục vụ nhiều loại phở như tái, chín, nạm, gầu.', N'10 Lý Quốc Sư, Hoàn Kiếm', 1, N'History', 150000, 8, '01:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'pholyquocsudonghoi.jpg', 1),
(5, N'Thử sức làm bánh xèo ngay tại trung tâm thủ đô Hà Nội', N'Lớp vỏ bánh vàng ruộm giòn tan, bên trong là nhân tôm thịt, giá đỗ và đậu xanh thơm phức. Bánh xèo được cuốn với rau sống và chấm nước mắm chua ngọt – là món ăn gói trọn hương vị đồng quê giữa lòng phố thị.', N'125 Đội Cấn, Ba Đình', 1, N'Food', 70000, 12, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'quan-banh-xeo-nem-lui-tap-nap-thuc-khach-o-pho-doi-can-ivivu-1.jpg', 1),
(4, N'Khám phá ẩm thực Hải Phòng : Chả Mực', N'Chả mực Hạ Long được làm từ mực tươi, giã tay, tạo nên miếng chả giòn dai, thơm ngon. Món ăn thường được dùng kèm với xôi trắng hoặc bánh cuốn, là lựa chọn không thể bỏ qua khi đến Hạ Long', N'Chả mực Quang Phong – Lô C112A, khu phố cổ, TP. Hạ Long - Chả mực Hạ Long Minh Phúc – 101 Trần Hưng Đạo, TP. Hạ Long', 2, N'Food', 70000, 10, '00:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'cha-muc-ha-long-02.jpg', 1),
(6, N'Trekking đảo Cát Bà – Chinh phục thiên nhiên hoang sơ', N'Hành trình trekking xuyên rừng quốc gia Cát Bà mang lại cảm giác phiêu lưu đầy hấp dẫn. Du khách có thể khám phá rừng Kim Giao, đỉnh Ngự Lâm, hang Quân Y và vịnh Lan Hạ – nơi được ví như "Hạ Long thu nhỏ".', N'Cổng Vườn Quốc gia Cát Bà – xã Trân Châu, huyện Cát Hải', 2, N'Adventure', 100000, 8, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'catba.jpg', 1),
(4, N'Tham quan làng chài Cửa Vạn – Trải nghiệm cuộc sống ngư dân', N'Làng chài Cửa Vạn là một trong những làng chài cổ nhất Việt Nam, nơi du khách có thể tìm hiểu về cuộc sống của ngư dân, tham gia chèo thuyền, đánh cá và thưởng thức hải sản tươi sống', N'Làng chài Cửa Vạn, vịnh Hạ Long', 4, N'Adventure', 70000, 12, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'cuavan.jpg', 1),
(6, N'Trải nghiệm đặc sản Hạ Long : Gà đồi Tiên Yên', N'Gà đồi Tiên Yên được nuôi thả tự nhiên, thịt săn chắc, da vàng óng. Món ăn thường được chế biến thành gà hấp, gà nướng hoặc lẩu gà, mang đến hương vị đặc trưng của vùng núi Quảng Ninh.', N'Nhà hàng Cỏ Xanh 3 – 16 Khu 4B, P. Hùng Thắng, TP. Hạ Long', 4, N'Food', 70000, 8, '01:30:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'ga-doi-tien-yen-1.jpg', 1),
(5, N'Thưởng thức ẩm thực truyền thống Ninh Bình : Gỏi cá nhệch', N'Gỏi cá nhệch là món ăn truyền thống của vùng Kim Sơn, được chế biến từ cá nhệch tươi sống, trộn với thính gạo rang và các loại gia vị, ăn kèm với rau sống và nước chấm đặc trưng, mang đến hương vị lạ miệng và hấp dẫn. ', N'Nhà hàng Tam Gia Trang – Số 12, đường Tràng An 2, phường Tân Thành, TP. Ninh Bình', 5, N'Food', 150000, 8, '02:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'goi_ca_nhech_ninh_binh_3.jpg', 1),
(56, N' Trải nghiệm Lịch sử tại Ninh Bình: Cố đô Hoa Lư', N'Cố đô Hoa Lư là kinh đô đầu tiên của Việt Nam dưới triều đại Đinh và Tiền Lê. Khu di tích bao gồm đền thờ vua Đinh Tiên Hoàng và vua Lê Đại Hành, cùng nhiều công trình kiến trúc cổ kính, phản ánh lịch sử và văn hóa của dân tộc. ', N'Xã Trường Yên, huyện Hoa Lư, tỉnh Ninh Bình', 5, N'History', 100000, 8, '03:00:00', 'MODERATE', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'hoalu.jpg', 1),
(4, N'Tham quan và học làm nón lá, hương trầm', N'Trải nghiệm văn hóa truyền thống bằng việc tự tay làm nón lá, cuốn hương dưới sự hướng dẫn của nghệ nhân địa phương', N'Làng nón Tây Hồ – Phú Mộng, Kim Long, TP Huế', 7, N'Culture', 70000, 10, '02:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'lamnonhue.jpg', 1),
(6, N'Thưởng thức cơm hến tại cồn Hến', N'Món ăn dân dã nổi tiếng gồm cơm nguội trộn với hến xào, tóp mỡ, rau sống, mắm ruốc và nước hến. Rẻ – lạ – ngon – đậm chất Huế.', N'17 Hàn Mặc Tử, Vĩ Dạ, TP Huế', 7, N'Food', 70000, 8, '01:30:00', 'CHALLENGING', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'comhen.jpg', 1),
(4, N'Thử sức làm thủ công kẹo dừa Bến Tre', N'Bến Tre được xem là "thủ phủ" của dừa miền Tây với hàng triệu cây dừa xanh ngát. Từ đó, kẹo dừa ra đời như một món quà truyền thống độc đáo, gắn bó với văn hóa người dân địa phương từ nhiều thập kỷ. Kẹo dừa được làm từ nước cốt dừa, đường, bột nếp và sữa tươi, sau đó kéo thành những sợi dài, mềm dẻo và có mùi thơm béo đặc trưng. Kẹo dừa thường có nhiều vị như dừa truyền thống, dừa sữa, dừa cacao, hoặc kèm hạt điều, mè rang tạo thêm hương vị hấp dẫn. Kẹo dừa không chỉ ngon mà còn là biểu tượng của Bến Tre, rất được ưa chuộng làm quà biếu trong và ngoài nước. Bạn có thể đến tận nơi để xem quy trình làm kẹo truyền thống, tìm hiểu cách người thợ lành nghề kéo kẹo thành những sợi mịn màng, dẻo dai.', N'3A Nguyễn Đình Chiểu, TP Bến Tre', 16, N'Adventure', 150000, 12, '03:00:00', 'EASY', 'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', N'KeoDua2.jpg', 1);
GO

-- Chèn toàn bộ Accommodations với maxOccupancy
INSERT INTO Accommodations (hostId, name, description, cityId, address, type, numberOfRooms, maxOccupancy, amenities, pricePerNight, images, isActive) VALUES
(1, N'Căn hộ Lam Home Seaview', N'Căn hộ sang trọng với tầm nhìn toàn cảnh vịnh Hạ Long', 4, N'123 Đường Bãi Cháy, Hạ Long, Quảng Ninh', 'Homestay', 2, 4, N'Wifi, Điều hòa, Ban công, Tầm nhìn biển, TV thông minh', 1500000, N'lam.jpg', 1),
(2, N'Homestay Lily Hạ Long - Phòng 203', N'Phòng nghỉ ấm cúng gần bãi biển, lý tưởng cho cặp đôi', 4, N'456 Đường Hạ Long, Hạ Long, Quảng Ninh', 'Homestay', 1, 2, N'Wifi, Điều hòa, Tủ lạnh, Bếp nhỏ', 700000, N'lily.jpg', 1),
(56, N'Phòng gia đình nhìn ra biển bởi Ahana Homestay HL', N'Phòng rộng rãi cho gia đình, gần vịnh Hạ Long', 4, N'789 Đường Tuần Châu, Hạ Long, Quảng Ninh', 'Homestay', 3, 6, N'Wifi, Điều hòa, Ban công, Bữa sáng miễn phí', 1800000, N'ahana.jpg', 1),
(4, N'Studio Ocean Blue bên bờ biển Giường Chill & Super King', N'Studio hiện đại với giường cỡ lớn, view biển tuyệt đẹp', 4, N'101 Đường Bãi Cháy, Hạ Long, Quảng Ninh', 'Homestay', 1, 2, N'Wifi, Điều hòa, Ban công, TV, Tầm nhìn biển', 1200000, N'ocean.jpg', 1),
(5, N'Hanoi Park House 2.1 - Ban công - Khu phố cổ', N'Nhà nghỉ phong cách hiện đại, gần phố cổ Hà Nội', 1, N'123 Phố Hàng Bạc, Hoàn Kiếm, Hà Nội', 'Homestay', 2, 4, N'Wifi, Điều hòa, Ban công, Bếp chung', 900000, N'a1.jpg', 1),
(6, N'Homestay Đống Đa, Việt Nam', N'Ngôi nhà riêng biệt, lý tưởng cho nhóm bạn hoặc gia đình', 1, N'456 Đường Láng, Đống Đa, Hà Nội', 'Homestay', 4, 8, N'Wifi, Điều hòa, Máy giặt, Bếp đầy đủ, Bãi đỗ xe', 2200000, N'b1.jpg', 1),
(7, N'Tuyệt đẹp Lakeview-Balcony&Projector-Brand mới', N'Căn hộ mới với view hồ Tây, có máy chiếu giải trí', 1, N'789 Đường Tây Hồ, Tây Hồ, Hà Nội', 'Homestay', 2, 4, N'Wifi, Điều hòa, Máy chiếu, Ban công, Tầm nhìn hồ', 1600000, N'c1.jpg', 1),
(8, N'Vista 9 Skyline Suite A Poetic Gaze Over Hanoi', N'Căn hộ cao cấp với tầm nhìn toàn cảnh Hà Nội', 1, N'101 Phố Hàng Đào, Hoàn Kiếm, Hà Nội', 'Hotel', 3, 9, N'Wifi, Điều hòa, Minibar, Tầm nhìn thành phố, Phòng gym', 2500000, N'd1.jpg', 1),
(9, N'$Bigsale - căn hộ cao cấp tại HP - Diamond Crown', N'Căn hộ sang trọng tại khu Diamond Crown Hải Phòng', 2, N'123 Đường Lê Lợi, Ngô Quyền, Hải Phòng', 'Hotel', 2, 6, N'Wifi, Hồ bơi, Phòng gym, Bữa sáng miễn phí', 1400000, N'e.jpg', 1),
(10, N'Căn hộ tại HaiPhong Center - 2 phòng ngủ, 2 phòng tắm', N'Căn hộ tiện nghi tại trung tâm Hải Phòng, gần cảng', 2, N'456 Đường Cát Dài, Lê Chân, Hải Phòng', 'Homestay', 2, 4, N'Wifi, Điều hòa, Bếp, Máy giặt', 1100000, N'f.jpg', 1),
(11, N'Homestay Nhà Ann - Phòng Haru', N'Phòng nghỉ phong cách Nhật Bản, gần trung tâm', 2, N'789 Đường Đà Nẵng, Hải An, Hải Phòng', 'Homestay', 1, 2, N'Wifi, Điều hòa, Tủ lạnh, Bữa sáng nhẹ', 750000, N'g.jpg', 1),
(12, N'Nhà Bim', N'Nhà nghỉ đơn giản, gần cảng, phù hợp cho khách du lịch tiết kiệm', 2, N'101 Đường Lạch Tray, Ngô Quyền, Hải Phòng', 'Guesthouse', 3, 6, N'Wifi, Điều hòa, Bãi đỗ xe, Quạt', 600000, N'h.jpg', 1),
(13, N'Bungalow đôi có bồn tắm Lotus Field Homestay', N'Bungalow lãng mạn với bồn tắm riêng, gần Tam Cốc', 5, N'123 Đường Tam Cốc, Hoa Lư, Ninh Bình', 'Homestay', 1, 2, N'Wifi, Điều hòa, Bồn tắm, Vườn, Xe đạp miễn phí', 1000000, N'n.jpg', 1),
(14, N'Homestay Amy House yên bình 1 phòng', N'Phòng nghỉ yên tĩnh, gần khu du lịch Tràng An', 5, N'456 Đường Tràng An, Ninh Bình', 'Homestay', 1, 2, N'Wifi, Điều hòa, Vườn, Bữa sáng địa phương', 650000, N'j.jpg', 1),
(15, N'The Wooden Gate Ninh Bình - Jasmine Flower King', N'Phòng nghỉ sang trọng với phong cách thiên nhiên', 5, N'789 Đường Tam Cốc, Hoa Lư, Ninh Bình', 'Homestay', 2, 4, N'Wifi, Điều hòa, Tầm nhìn núi, Xe đạp miễn phí', 1300000, N's.jpg', 1),
(16, N'The Wooden Gate Ninh Bình - Tropical Bunk Suite', N'Phòng nghỉ độc đáo với giường tầng, gần Tràng An', 5, N'101 Đường Tràng An, Ninh Bình', 'Homestay', 2, 4, N'Wifi, Điều hòa, Ban công, Tầm nhìn đồng lúa', 950000, N'aaaaa.jpg', 1),
(17, N'Coconut Room - Nhà Mơ Homestay Bến Tre', N'Phòng nghỉ mộc mạc giữa vườn dừa, trải nghiệm miền Tây', 16, N'123 Đường Miệt Vườn, Mỏ Cày Nam, Bến Tre', 'Homestay', 1, 2, N'Wifi, Quạt, Xe đạp miễn phí, Vườn dừa, Bữa sáng địa phương', 600000, N'oo.jpg', 1),
(18, N'Comfy 1 Riverside Mekong Bến Tre homestay', N'Homestay ấm cúng bên sông Mekong, gần chợ nổi', 16, N'456 Đường Sông Cái, Châu Thành, Bến Tre', 'Homestay', 1, 2, N'Wifi, Điều hòa, Thuyền chèo, Bữa sáng nhẹ', 650000, N'ax.jpg', 1),
(19, N'Haven Nest retreat ( Grasshopper-châu chấu)', N'Phòng nghỉ độc đáo lấy cảm hứng từ thiên nhiên, gần sông', 16, N'789 Đường Phú Lễ, Ba Tri, Bến Tre', 'Homestay', 2, 4, N'Wifi, Điều hòa, Vườn, Tầm nhìn sông', 800000, N'kkk.jpg', 1),
(20, N'Haven Nest Retreat (Grey Featherback - Cá Mè Dinh)', N'Phòng nghỉ sang trọng với phong cách miền Tây, gần vườn dừa', 16, N'101 Đường Mỏ Cày, Bến Tre', 'Homestay', 2, 4, N'Wifi, Điều hòa, Thuyền chèo, Vườn dừa', 850000, N'aq.jpg', 1),
(21, N'Chậm Garden - Cảm nhận cuộc sống thiên nhiên', N'Homestay yên bình gần chợ nổi Cái Răng, hòa mình vào thiên nhiên', 13, N'123 Đường Cái Răng, Ninh Kiều, Cần Thơ', 'Homestay', 2, 4, N'Wifi, Quạt, Xe đạp miễn phí, Vườn, Bữa sáng địa phương', 700000, N'sa.jpg', 1),
(22, N'Midmost Casa - Superior Studio', N'Studio hiện đại, nằm ngay trung tâm Cần Thơ', 13, N'456 Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ', 'Homestay', 1, 2, N'Wifi, Điều hòa, Bếp nhỏ, TV thông minh', 900000, N'sd.jpg', 1),
(23, N'Miha Villa 1 - Nhà tại Cần Thơ', N'Ngôi nhà riêng biệt, lý tưởng cho gia đình hoặc nhóm bạn', 13, N'789 Đường 30/4, Ninh Kiều, Cần Thơ', 'Homestay', 3, 6, N'Wifi, Điều hòa, Bếp đầy đủ, Máy giặt, Bãi đỗ xe', 1500000, N'sw.jpg', 1),
(24, N'pipo house - nắng đẹp, 1br', N'Phòng nghỉ đầy nắng, gần trung tâm Cần Thơ', 13, N'101 Đường Lê Lợi, Ninh Kiều, Cần Thơ', 'Guesthouse', 1, 2, N'Wifi, Điều hòa, Ban công, Bữa sáng nhẹ', 750000, N'se.jpg', 1),
(25, N'Căn Family nguyên căn 2 phòng ngủ- Lavita home', N'Căn hộ gia đình tiện nghi, gần trung tâm Đà Lạt', 15, N'123 Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt', 'Homestay', 2, 4, N'Wifi, Sưởi, Bếp, Ban công, Tầm nhìn đồi thông', 1200000, N'sr.jpg', 1),
(26, N'Mối Tình Đầu Homestay Bus Room', N'Phòng nghỉ độc đáo thiết kế như xe buýt, gần hồ Xuân Hương', 15, N'456 Đường Hồ Xuân Hương, Phường 9, Đà Lạt', 'Homestay', 1, 2, N'Wifi, Sưởi, Tủ lạnh, Vườn hoa', 850000, N'st.jpg', 1),
(27, N'South Of The border - Phia Nam Biên Gioi', N'Homestay phong cách vintage, gần Thung Lũng Tình Yêu', 15, N'789 Đường Trại Mát, Phường 11, Đà Lạt', 'Homestay', 2, 4, N'Wifi, Sưởi, Ban công, Lò sưởi', 1000000, N'sy.jpg', 1),
(28, N'Summery - Nhà của Eiji', N'Ngôi nhà phong cách Nhật Bản, không gian ấm cúng ở Đà Lạt', 15, N'101 Đường Lê Hồng Phong, Phường 4, Đà Lạt', 'Homestay', 2, 4, N'Wifi, Sưởi, Vườn, Bữa sáng kiểu Nhật', 1100000, N'su.jpg', 1),
(29, N'Casa CoCore TimeOut khu phố thú vị nhất Sài Gòn', N'Căn hộ cao cấp ở trung tâm Quận 1, gần phố đi bộ Nguyễn Huệ', 11, N'123 Đường Lê Lợi, Quận 1, TP.HCM', 'Hotel', 2, 6, N'Wifi, Điều hòa, Hồ bơi, Phòng gym, Minibar', 2000000, N'ds.jpg', 1),
(30, N'ĐaKao Vibe Retro Studio GB in Center by Circadian', N'Studio phong cách retro ở khu Đa Kao sầm uất', 11, N'456 Đường Đinh Tiên Hoàng, Quận 1, TP.HCM', 'Homestay', 1, 2, N'Wifi, Điều hòa, Bếp nhỏ, TV thông minh', 950000, N'da.jpg', 1),
(1, N'Huế Studio gần đường Bùi Viện Em''s Home 5', N'Studio sôi động gần khu phố Tây Bùi Viện', 11, N'789 Đường Bùi Viện, Quận 1, TP.HCM', 'Homestay', 1, 2, N'Wifi, Điều hòa, Ban công, Tủ lạnh', 900000, N'df.jpg', 1),
(2, N'Mây 3 - Studio đầy đủ tiện nghi', N'Studio hiện đại gần chợ Bến Thành, tiện nghi đầy đủ', 11, N'101 Đường Lê Thị Riêng, Quận 1, TP.HCM', 'Guesthouse', 1, 2, N'Wifi, Điều hòa, Bếp, TV thông minh', 850000, N'dg.jpg', 1),
(56, N'Bigphil Home - Một ngôi nhà Santorini ấm cúng có bếp', N'Homestay phong cách Santorini, gần bãi biển Vũng Tàu', 12, N'123 Đường Bãi Sau, TP. Vũng Tàu', 'Homestay', 2, 4, N'Wifi, Điều hòa, Bếp, Ban công, Tầm nhìn biển', 1200000, N'ca.jpg', 1),
(4, N'Căn hộ ven biển CSJ Tower có tầm nhìn tuyệt đẹp [22 Lagom]', N'Căn hộ cao cấp với view biển tại CSJ Tower', 12, N'456 Đường Thùy Vân, TP. Vũng Tàu', 'Hotel', 2, 6, N'Wifi, Điều hòa, Hồ bơi, Phòng gym, Tầm nhìn biển', 1800000, N'cs.jpg', 1),
(5, N'Leo House - Tòa nhà The Song (Angia)', N'Căn hộ sang trọng trong tòa The Song, gần bãi biển', 12, N'789 Đường Lê Hồng Phong, TP. Vũng Tàu', 'Hotel', 3, 9, N'Wifi, Điều hòa, Hồ bơi, Minibar, Bãi đỗ xe', 2000000, N'cd.jpg', 1),
(6, N'Nhà Lily - Phòng Xanh, 1 phòng ngủ & phòng tắm riêng', N'Phòng nghỉ màu xanh, gần bãi biển Vũng Tàu', 12, N'101 Đường Hạ Long, TP. Vũng Tàu', 'Homestay', 1, 2, N'Wifi, Điều hòa, Ban công, Tầm nhìn biển, Bữa sáng nhẹ', 900000, N'cf.jpg', 1),
(7, N'Family Home Villa Bà Nà Hill Sun World', N'Biệt thự gia đình gần khu du lịch Bà Nà Hills', 6, N'123 Đường Bà Nà, Đà Nẵng', 'Resort', 8, 32, N'Wifi, Hồ bơi, Bãi đỗ xe, Bữa sáng miễn phí', 2500000, N'qa.jpg', 1),
(8, N'Jhome-2BR-Fully Furnished', N'Căn hộ 2 phòng ngủ đầy đủ tiện nghi gần trung tâm', 6, N'45 Nguyễn Văn Linh, Đà Nẵng', 'Homestay', 2, 4, N'Wifi, Máy giặt, Ban công', 800000, N'qw.jpg', 1),
(9, N'May Home RoomWasherBalcony5 phút đến Bãi biển Mỹ Khê', N'Phòng nghỉ tiện nghi cách bãi biển Mỹ Khê 5 phút', 6, N'78 Võ Nguyên Giáp, Đà Nẵng', 'Homestay', 3, 6, N'Wifi, Máy giặt, Ban công, Điều hòa', 600000, N'qs.jpg', 1),
(10, N'Mon Fiori Homestay x Moana Modern Apartment', N'Căn hộ hiện đại phong cách Mon Fiori gần biển', 6, N'12 An Thượng, Đà Nẵng', 'Homestay', 4, 8, N'Wifi, Bếp, Ban công, TV', 900000, N'qf.jpg', 1),
(11, N'1107ss Deluxe Ocean View miễn phí đón 1 chiều', N'Căn hộ sang trọng với tầm nhìn biển, miễn phí đưa đón', 6, N'56 Võ Nguyên Giáp, Đà Nẵng', 'Hotel', 5, 15, N'Wifi, Hồ bơi, Đưa đón sân bay', 1500000, N'we.jpg', 1),
(12, N'Căn HỘ Poetic Riverside Attic ở Hội An - Chợ đêm', N'Căn hộ thơ mộng gần chợ đêm Hội An', 8, N'23 Nguyễn Hoàng, Hội An', 'Homestay', 2, 4, N'Wifi, Điều hòa, Xe đạp miễn phí', 700000, N'wa.jpg', 1),
(13, N'Chilling Hoi An APT-BTW An An Bàng Beach+Ancient Town', N'Căn hộ thư giãn giữa bãi biển An Bàng và phố cổ', 8, N'45 Cửa Đại, Hội An', 'Homestay', 3, 6, N'Wifi, Bếp, Ban công, Xe đạp', 850000, N'wd.jpg', 1),
(14, N'Zen House-WoodenHouse Japan Style gần Trung tâm', N'Nhà gỗ phong cách Nhật Bản gần trung tâm Hội An', 8, N'67 Trần Nhân Tông, Hội An', 'Homestay', 2, 4, N'Wifi, Điều hòa, Vườn nhỏ', 750000, N'wz.jpg', 1),
(15, N'Limdim Here - Phòng ''ici'' cho 2 khách', N'Phòng nghỉ ấm cúng cho 2 người tại Huế', 7, N'12 Lê Lợi, Huế', 'Guesthouse', 1, 2, N'Wifi, Điều hòa, Bữa sáng', 500000, N'za.jpg', 1),
(16, N'NguyễnHouse# StudioRoomtại Trung tâm thành phố Huế', N'Phòng studio hiện đại tại trung tâm Huế', 7, N'34 Nguyễn Trãi, Huế', 'Homestay', 1, 2, N'Wifi, Bếp, Điều hòa', 550000, N'xz.jpg', 1),
(17, N'Nhà Ngau - phòng ''Métro'' cho 2 khách', N'Phòng phong cách Métro độc đáo tại Huế', 7, N'56 Phạm Ngũ Lão, Huế', 'Guesthouse', 1, 2, N'Wifi, Điều hòa, Bữa sáng miễn phí', 520000, N'xc.jpg', 1),
(18, N'Phòng tại khách sạn boutique tại Hue, Việt Nam', N'Phòng boutique sang trọng tại trung tâm Huế', 7, N'78 Hùng Vương, Huế', 'Hotel', 4, 12, N'Wifi, Hồ bơi, Bữa sáng, Spa', 1200000, N'xv.jpg', 1),
(19, N'Coral House -3 BR- FULL HOUSE - 700 m ra bãi biển', N'Nhà 3 phòng ngủ gần bãi biển Nha Trang', 9, N'23 Trần Phú, Nha Trang', 'Homestay', 3, 6, N'Wifi, Bếp, Ban công, Điều hòa', 1000000, N'xq.jpg', 1),
(20, N'Serenity RiverView 2 giường, phía trên SeaView Charm', N'Căn hộ 2 giường với tầm nhìn sông và biển', 9, N'45 Nguyễn Thị Minh Khai, Nha Trang', 'Homestay', 2, 4, N'Wifi, Ban công, Điều hòa', 900000, N'xe.jpg', 1),
(21, N'The Hiden House( 5 phút đến trung tâm bãi biển)', N'Nhà nghỉ gần trung tâm và bãi biển Nha Trang', 9, N'67 Lê Đại Hành, Nha Trang', 'Homestay', 3, 6, N'Wifi, Bếp, Điều hòa, Xe đạp', 800000, N'vc.jpg', 1),
(22, N'White Oceanus Cozy 2BR 36Fl SeaviewApt-4km toCenter', N'Căn hộ tầng 36 với tầm nhìn biển tuyệt đẹp', 9, N'12 Hùng Vương, Nha Trang', 'Homestay', 2, 4, N'Wifi, Hồ bơi, Ban công, Điều hòa', 1100000, N'ba.jpg', 1),
(23, N'Căn hộ biển Altara Residence', N'Căn hộ cao cấp gần bãi biển Quy Nhơn', 10, N'34 Nguyễn Huệ, Quy Nhơn', 'Homestay', 3, 6, N'Wifi, Hồ bơi, Bãi đỗ xe, Điều hòa', 950000, N'fa.jpg', 1),
(24, N'Pimira Homestay', N'Homestay ấm cúng tại trung tâm Quy Nhơn', 10, N'56 Lê Lợi, Quy Nhơn', 'Homestay', 2, 4, N'Wifi, Điều hòa, Bếp', 650000, N'fs.jpg', 1),
(25, N'Seaview 2BR 3 giường,ban công, trung tâm thành phố Stay by TYE', N'Căn hộ 2 phòng ngủ với ban công nhìn biển', 10, N'78 Trần Hưng Đạo, Quy Nhơn', 'Homestay', 2, 4, N'Wifi, Ban công, Điều hòa, Bếp', 850000, N'fd.jpg', 1),
(26, N'Song Suoi homestay _ căn phòng cạnh biển 1', N'Phòng nghỉ gần biển Quy Nhơn, phong cách tự nhiên', 10, N'23 Nguyễn Tất Thành, Quy Nhơn', 'Homestay', 1, 2, N'Wifi, Điều hòa, Gần biển', 600000, N'fz.jpg', 1);
GO

-- Chèn Reviews
INSERT INTO Reviews (accommodationId, travelerId, rating, comment, createdAt) VALUES
(1, 35, 4, N'Chỗ ở sạch sẽ, view biển đẹp!', GETDATE()),
(2, 36, 5, N'Chủ nhà thân thiện, rất đáng tiền.', GETDATE()),
(3, 37, 3, N'Phòng ổn, nhưng wifi hơi yếu.', GETDATE()),
(4, 38, 4, N'View biển tuyệt vời, phòng thoải mái.', GETDATE()),
(5, 39, 5, N'Vị trí gần phố cổ, rất tiện lợi.', GETDATE());
GO

-- Chèn Bookings
INSERT INTO Bookings (experienceId, travelerId, bookingDate, bookingTime, numberOfPeople, totalPrice, status, contactInfo) VALUES
(1, 35, '2025-06-01', '08:00:00', 2, 240000, 'CONFIRMED', '0123456789'),
(2, 36, '2025-06-02', '09:00:00', 4, 200000, 'PENDING', '0987654321'),
(3, 37, '2025-06-03', '10:00:00', 6, 300000, 'CONFIRMED', '0111222333');

INSERT INTO Bookings (accommodationId, travelerId, bookingDate, bookingTime, numberOfPeople, totalPrice, status, contactInfo) VALUES
(1, 38, '2025-06-10', '14:00:00', 2, 1500000, 'CONFIRMED', '0444555666'),
(2, 39, '2025-06-11', '15:00:00', 2, 700000, 'PENDING', '0777888999');
GO

-- Chèn Reviews cho Experiences
INSERT INTO Reviews (experienceId, travelerId, rating, comment) VALUES
(1, 35, 5, N'Trải nghiệm tuyệt vời, bún chả cá rất ngon!'),
(2, 36, 4, N'Tháp Bà rất đẹp, hướng dẫn viên nhiệt tình'),
(3, 37, 5, N'VinWonders vui lắm, phù hợp cho cả gia đình');
GO

-- Tạo chat room và messages mẫu
DECLARE @chatRoomId INT;

INSERT INTO ChatRooms (userId, hostId, experienceId, status) VALUES
(35, 4, 1, 'ACTIVE');

SET @chatRoomId = SCOPE_IDENTITY();

INSERT INTO ChatParticipants (chatRoomId, userId) VALUES
(@chatRoomId, 35),
(@chatRoomId, 4);

INSERT INTO ChatMessages (chatRoomId, senderId, receiverId, messageContent) VALUES
(@chatRoomId, 35, 4, N'Xin chào! Tôi quan tâm đến trải nghiệm bún chả cá của bạn.'),
(@chatRoomId, 4, 35, N'Chào bạn! Cảm ơn bạn đã quan tâm. Món này rất đặc trưng Đà Nẵng, bạn có câu hỏi gì không?'),
(@chatRoomId, 35, 4, N'Có phù hợp với người ăn chay không ạ?'),
(@chatRoomId, 4, 35, N'Món này có cá nên không phù hợp với người ăn chay. Nhưng tôi có thể giới thiệu các món chay khác.');
GO

-- Tạo chat room cho accommodation
INSERT INTO ChatRooms (userId, hostId, accommodationId, status) VALUES
(36, 1, 1, 'ACTIVE');

SET @chatRoomId = SCOPE_IDENTITY();

INSERT INTO ChatParticipants (chatRoomId, userId) VALUES
(@chatRoomId, 36),
(@chatRoomId, 1);

INSERT INTO ChatMessages (chatRoomId, senderId, receiverId, messageContent) VALUES
(@chatRoomId, 36, 1, N'Căn hộ có view biển như trong hình không ạ?'),
(@chatRoomId, 1, 36, N'Dạ có ạ, căn hộ nhìn ra toàn cảnh vịnh Hạ Long rất đẹp.');
GO

-- Chèn Favorites
INSERT INTO Favorites (userId, experienceId) VALUES
(35, 1),
(35, 2),
(36, 3),
(37, 1),
(38, 4),
(39, 5);

INSERT INTO Favorites (userId, accommodationId) VALUES
(35, 1),
(36, 2),
(37, 3),
(38, 4),
(39, 5);
GO

PRINT 'Database TravelerDB với toàn bộ dữ liệu gốc đã được tạo thành công!';
GO
USE TravelerDB;
GO

-- ===== THÊM TRƯỜNG MỚI CHO ADMIN APPROVAL - SCRIPT ĐÃ SỬA =====

-- 1. Thêm trường adminApprovalStatus cho bảng Experiences
ALTER TABLE Experiences 
ADD adminApprovalStatus NVARCHAR(20) NOT NULL DEFAULT 'PENDING' 
    CHECK (adminApprovalStatus IN ('PENDING', 'APPROVED', 'REJECTED'));
GO

-- 2. Thêm trường adminApprovalStatus cho bảng Accommodations
ALTER TABLE Accommodations
ADD adminApprovalStatus NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
    CHECK (adminApprovalStatus IN ('PENDING', 'APPROVED', 'REJECTED'));
GO



-- 3. Thêm các trường bổ sung cho admin - EXPERIENCES (từng cột một)
ALTER TABLE Experiences 
ADD adminApprovedBy INT NULL;
GO

ALTER TABLE Experiences 
ADD adminApprovedAt DATETIME NULL;
GO

ALTER TABLE Experiences 
ADD adminRejectReason NVARCHAR(500) NULL;
GO

ALTER TABLE Experiences 
ADD adminNotes NVARCHAR(MAX) NULL;
GO

-- 4. Thêm các trường bổ sung cho admin - ACCOMMODATIONS (từng cột một)
ALTER TABLE Accommodations
ADD adminApprovedBy INT NULL;
GO

ALTER TABLE Accommodations
ADD adminApprovedAt DATETIME NULL;
GO

ALTER TABLE Accommodations
ADD adminRejectReason NVARCHAR(500) NULL;
GO

ALTER TABLE Accommodations
ADD adminNotes NVARCHAR(MAX) NULL;
GO

-- 5. Thêm foreign key cho adminApprovedBy
ALTER TABLE Experiences
ADD CONSTRAINT FK_Experience_AdminApprovedBy 
FOREIGN KEY (adminApprovedBy) REFERENCES Users(userId);
GO

ALTER TABLE Accommodations  
ADD CONSTRAINT FK_Accommodation_AdminApprovedBy
FOREIGN KEY (adminApprovedBy) REFERENCES Users(userId);
GO

-- 6. Cập nhật dữ liệu hiện có
-- Những record có isActive = 1 được coi là đã approved
UPDATE Experiences 
SET adminApprovalStatus = 'APPROVED',
    adminApprovedAt = createdAt
WHERE isActive = 1;
GO

UPDATE Accommodations
SET adminApprovalStatus = 'APPROVED', 
    adminApprovedAt = createdAt
WHERE isActive = 1;
GO

-- Những record có isActive = 0 vẫn pending
UPDATE Experiences 
SET adminApprovalStatus = 'PENDING'
WHERE isActive = 0;
GO

UPDATE Accommodations
SET adminApprovalStatus = 'PENDING'
WHERE isActive = 0;
GO

-- 7. Thêm indexes để tăng hiệu suất
CREATE INDEX IX_Experiences_AdminApprovalStatus ON Experiences(adminApprovalStatus);
GO

CREATE INDEX IX_Accommodations_AdminApprovalStatus ON Accommodations(adminApprovalStatus);
GO

-- 8. Tạo view để dễ truy vấn
CREATE VIEW PublicExperiences AS
SELECT e.*, c.vietnameseName as cityName, u.fullName as hostName
FROM Experiences e
LEFT JOIN Cities c ON e.cityId = c.cityId  
LEFT JOIN Users u ON e.hostId = u.userId
WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1;
GO

CREATE VIEW PublicAccommodations AS  
SELECT a.*, c.vietnameseName as cityName, u.fullName as hostName
FROM Accommodations a
LEFT JOIN Cities c ON a.cityId = c.cityId
LEFT JOIN Users u ON a.hostId = u.userId  
WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1;
GO

-- 9. Kiểm tra kết quả
SELECT 
    'Experiences' as TableName,
    adminApprovalStatus,
    COUNT(*) as Count
FROM Experiences 
GROUP BY adminApprovalStatus

UNION ALL

SELECT 
    'Accommodations' as TableName,
    adminApprovalStatus,
    COUNT(*) as Count
FROM Accommodations 
GROUP BY adminApprovalStatus
ORDER BY TableName, adminApprovalStatus;
GO

PRINT 'Đã cập nhật thành công database với trường adminApprovalStatus!';
PRINT 'Logic mới:';
PRINT '- adminApprovalStatus: PENDING (chờ duyệt) | APPROVED (đã duyệt) | REJECTED (từ chối)';
PRINT '- isActive: 1 (host hiện) | 0 (host ẩn)';
PRINT '- Hiển thị công khai khi: adminApprovalStatus = APPROVED AND isActive = 1';
GO
USE dataviet;

-- Check if lockReason column already exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'lockReason')
BEGIN
    ALTER TABLE Users 
    ADD lockReason NVARCHAR(500) NULL;
    
    PRINT 'lockReason column added successfully to Users table';
END
ELSE
BEGIN
    PRINT 'lockReason column already exists in Users table';
END;

-- Update existing locked users with a default reason (optional)
UPDATE Users 
SET lockReason = 'Tài khoản bị khóa bởi admin (lý do không xác định)'
WHERE isActive = 0 AND lockReason IS NULL;

PRINT 'lockReason column setup completed';
USE TravelerDB;
GO
CREATE TABLE Reports (
    reportId INT IDENTITY(1,1) PRIMARY KEY,
    contentType NVARCHAR(50),
    contentId INT,
    reporterId INT,
    reason NVARCHAR(255),
    description NVARCHAR(1000),
    createdAt DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'PENDING',

    -- Thêm trạng thái duyệt của admin
    adminApprovalStatus NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (adminApprovalStatus IN ('PENDING', 'APPROVED', 'REJECTED')),

    -- Người admin duyệt
    adminApprovedBy INT NULL,

    -- Thời điểm duyệt
    adminApprovedAt DATETIME NULL,

    -- Lý do từ chối
    adminRejectReason NVARCHAR(500) NULL,

    -- Ghi chú nội bộ của admin
    adminNotes NVARCHAR(MAX) NULL
);

-- Thêm khóa ngoại đến bảng Users (giả sử Users đã tồn tại với userId là khóa chính)
ALTER TABLE Reports
ADD CONSTRAINT FK_Reports_AdminApprovedBy FOREIGN KEY (adminApprovedBy) REFERENCES Users(userId);

-- Thêm khóa ngoại cho reporterId nếu cần (tuỳ hệ thống bạn có hỗ trợ liên kết reporter không)
-- ALTER TABLE Reports
-- ADD CONSTRAINT FK_Reports_Reporter FOREIGN KEY (reporterId) REFERENCES Users(userId);

-- Truy vấn dữ liệu: join với bảng Users để lấy tên người báo cáo
SELECT 
    r.*, 
    u.fullName AS reporterName
FROM Reports r
LEFT JOIN Users u ON r.reporterId = u.userId;
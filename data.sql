-- Tạo database
CREATE DATABASE TravelerDB_b;
GO

USE TravelerDB_b;
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Experiences](
	[experienceId] [int] IDENTITY(1,1) NOT NULL,
	[hostId] [int] NOT NULL,
	[title] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[location] [nvarchar](255) NOT NULL,
	[cityId] [int] NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[price] [float] NOT NULL,
	[maxGroupSize] [int] NOT NULL,
	[duration] [time](7) NOT NULL,
	[difficulty] [nvarchar](20) NULL,
	[language] [nvarchar](50) NULL,
	[includedItems] [nvarchar](max) NULL,
	[requirements] [nvarchar](max) NULL,
	[createdAt] [date] NOT NULL,
	[isActive] [bit] NOT NULL,
	[images] [nvarchar](max) NULL,
	[averageRating] [float] NOT NULL,
	[totalBookings] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[experienceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Experiences] ON 
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (1, 4, N'Tour đạp xe quanh Hà Nội', N'Tour đạp xe khám phá phố cổ và hồ Tây', N'Phố cổ Hà Nội', 1, N'Adventure', 50, 8, CAST(N'03:00:00' AS Time), N'MODERATE', N'Vietnamese, English', N'Xe đạp, Nước uống', N'Mang giày thể thao', CAST(N'2025-05-27' AS Date), 1, N'bike1.jpg,bike2.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (2, 5, N'Tour ẩm thực Đà Nẵng', N'Khám phá ẩm thực địa phương Đà Nẵng', N'Chợ Cồn', 6, N'Food', 70, 10, CAST(N'04:00:00' AS Time), N'EASY', N'Vietnamese, English', N'Ăn uống thoải mái', N'Không yêu cầu', CAST(N'2025-05-27' AS Date), 1, N'food1.jpg,food2.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (3, 4, N'Thưởng thức Bún Chả Cá Đà Nẵng', N'Nước dùng ninh từ xương cá ngọt thanh...', N'319 Hùng Vương, Hải Châu, Đà Nẵng', 6, N'Food', 120000, 10, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'1 tô bún chả cá + nước uống', N'Không dị ứng cá', CAST(N'2025-05-31' AS Date), 1, N'bun-cha-ca.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (9, 4, N'Tháp Bà Ponagar', N'Quần thể kiến trúc tôn giáo cổ xưa của người Chăm, gồm bốn tháp chính và một số tháp nhỏ, được xây dựng từ thế kỷ VIII đến XIII để thờ nữ thần Ponagar.', N'Đường Hai Tháng Tư, Vĩnh Phước, TP. Nha Trang', 9, N'Culture', 50000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', CAST(N'2025-05-31' AS Date), 1, N'thap-ba-ponagar-nha-trang-5.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (10, 4, N'VinWonders Nha Trang', N'Công viên giải trí đa dạng với nhiều khu vực vui chơi như công viên nước, khu vui chơi ngoài trời, thủy cung, khu ẩm thực... phù hợp cho mọi lứa tuổi.', N'Đảo Hòn Tre, Vĩnh Nguyên, TP. Nha Trang', 9, N'Adventure', 50000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', CAST(N'2025-05-31' AS Date), 1, N'vinwonders-nha-trang-4.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (11, 5, N'Tắm bùn khoáng', N'Trải nghiệm thư giãn, tốt cho sức khỏe tại các khu tắm bùn nổi tiếng như Tháp Bà, Trăm Trứng và I-Resort.', N' Trung tâm Tháp Bà – 15 Ngọc Sơn, Ngọc Hiệp, TP. Nha Trang Khu du lịch Trăm Trứng – Đại lộ Nguyễn Tất Thành, Phước Đồng, TP. Nha Trang I-Resort – Tổ 19, thôn Xuân Ngọc, Vĩnh Ngọc, TP. Nha Trang', 9, N'Adventure', 50000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn viên, Vé vào cửa', N'Không yêu cầu', CAST(N'2025-05-31' AS Date), 1, N'tam-bun-nha-trang.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (12, 4, N'Trải nghiệm lịch sử Văn Miếu tại Hà Nội', N'Tham quan lịch sử Văn Miếu Quốc Tử Giám', N'58 Quốc Tử Giám, Đống Đa', 1, N'History', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'vanmieu.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (13, 4, N'Tour ẩm thực tại Hà Nội', N'Bún chả Hà Nội là món ăn truyền thống gồm ba thành phần chính: bún tươi, chả nướng và nước chấm. Chả được làm từ thịt lợn thái mỏng hoặc xay, tẩm ướp gia vị rồi nướng trên than hoa, tạo hương thơm đặc trưng. Nước chấm pha từ nước mắm, giấm, đường, tỏi, ớt, kèm theo đu đủ xanh hoặc cà rốt thái mỏng, tạo vị chua ngọt hài hòa. Món ăn thường được dùng kèm với rau sống như xà lách, tía tô, húng lủi, kinh giới.', N'24 Lê Văn Hưu, Hai Bà Trưng', 1, N'Food', 70000, 12, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'buncha.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (14, 5, N'Trải nghiệm ẩm thực đường phố Bánh đa cua  tại Hải Phòng ', N'Món ăn mang đậm hương vị miền biển với sợi bánh đa đỏ dẻo dai, nước dùng ninh từ cua đồng, topping đầy đủ gồm chả lá lốt, giò, tôm, rau muống chần. Vị ngọt thanh, béo ngậy và mùi thơm đặc trưng là điểm nhấn khó quên.', N'o	Bánh đa cua bà Cụ – 179 Cầu Đất, Ngô Quyền
o	Bánh đa cua Lạch Tray – 48 Lạch Tray, Ngô Quyền
', 2, N'Culture', 70000, 10, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'banhdacua.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (15, 4, N'Trải nghiệm phiêu lưu biển Đồ Sơn Hải Phòng', N'Đồ Sơn sở hữu những bãi cát dài, nước biển mát lạnh và các hoạt động thú vị như moto nước, kéo dù bay, cắm trại ven biển. Du khách có thể kết hợp nghỉ dưỡng và tham quan biệt thự Bảo Đại – một di tích lịch sử nổi bật.', N'o	Khu du lịch Đồ Sơn, Đồ Sơn, cách trung tâm TP khoảng 20km', 2, N'Adventure', 100000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'biendoson.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (18, 5, N'Chèo kayak khám phá vịnh Hạ Long', N'Chèo kayak là cách tuyệt vời để khám phá các hang động, hòn đảo và làng chài trên vịnh Hạ Long. Du khách có thể tự mình điều khiển kayak, len lỏi qua các hang động như Hang Luồn, Hang Sáng – Tối, tận hưởng vẻ đẹp thiên nhiên kỳ vĩ. ', N'Vịnh Hạ Long, Quảng Ninh', 4, N'Adventure', 70000, 12, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'cheokayak.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (19, 4, N'Trải nghiệm món bún bề bề Hạ Long', N'Bún bề bề là món ăn đặc trưng với bề bề (tôm tít) tươi ngon, nước dùng ngọt thanh từ xương và hải sản, ăn kèm rau sống và chả mực, tạo nên hương vị đậm đà khó quên. ', N'36 Đoàn Thị Điểm, P. Bạch Đằng, TP. Hạ Long', 4, N'Food', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'bunbebe.jpeg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (20, 5, N'Trải nghiệm ẩm thực cơm cháy Ninh Bình', N'Cơm cháy Ninh Bình được làm từ gạo ngon, chiên giòn và ăn kèm với nước sốt đặc biệt từ thịt dê hoặc thịt bò, tạo nên món ăn hấp dẫn, giòn rụm và đậm đà hương vị. ', N'Nhà hàng Thăng Long – Tràng An, xã Trường Yên, huyện Hoa Lư, tỉnh Ninh Bình', 5, N'History', 150000, 8, CAST(N'02:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'4159_com_chay_ninh_binh.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (21, 4, N'Chùa Bái Đính', N'Chùa Bái Đính là quần thể chùa lớn nhất Việt Nam, nổi bật với kiến trúc hoành tráng và nhiều kỷ lục như tượng Phật bằng đồng lớn nhất châu Á, hành lang La Hán dài nhất. Đây là điểm đến tâm linh thu hút đông đảo du khách.', N'Xã Gia Sinh, huyện Gia Viễn, tỉnh Ninh Bình', 5, N'History', 100000, 8, CAST(N'03:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'Chua-Bai-Dinh-1.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (24, 5, N'Ngồi thuyền rồng nghe ca Huế trên sông Hương', N'Thưởng thức ca Huế – dòng nhạc truyền thống cung đình và dân gian – khi thuyền rồng trôi nhẹ trên sông Hương về đêm. Một trải nghiệm nhẹ nhàng và lãng mạn.', N'o	Bến thuyền Tòa Khâm – Lê Lợi, TP Huế', 7, N'Culture', 70000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'nghecahue.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (25, 4, N'Ăn bún bò Huế chính gốc', N': Món ăn đặc trưng nổi tiếng khắp cả nước, nước lèo ngọt xương, thơm sả, vị cay nồng đặc trưng. Thường ăn kèm giò heo, chả cua, huyết, rau sống.', N'o	Bún bò Mệ Kéo – 20 Bạch Đằng, Phường Phú Cát, TP Huế (quán hơn 70 năm, giữ đúng vị Huế xưa)', 7, N'Food', 70000, 8, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'bun-bo-hue.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (26, 5, N'Trải nghiệm Bún chả cá Đà Nẵng', N'Nước dùng được ninh từ xương cá, có vị ngọt thanh đặc trưng, ăn kèm với chả cá chiên và hấp, thêm rau sống, bắp cải muối, ớt tỏi.', N'Nước dùng được ninh từ xương cá, có vị ngọt thanh đặc trưng, ăn kèm với chả cá chiên và hấp, thêm rau sống, bắp cải muối, ớt tỏi.
•	Địa chỉ gợi ý:
o	Bún chả cá Bà Lữ – 319 Hùng Vương, Hải Châu
', 6, N'Food', 150000, 12, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'bun-cha-ca-da-nang-2.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (27, 4, N'Lặn biển khám phá san hô tại bán đảo Sơn Trà', N'Bán đảo Sơn Trà là nơi lý tưởng để lặn biển, khám phá hệ sinh thái dưới nước với các rạn san hô đầy màu sắc. Các địa danh như Hòn Sụp, Bãi Rạng và Bãi Bụt là điểm đến phổ biến cho hoạt động này. ', N'Bán đảo Sơn Trà, Đà Nẵng', 6, N'Adventure', 150000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'lan-ngam-san-ho-ban-dao-son-tra-hava-travel-3.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (28, 5, N'Trượt thác Hòa Phú Thành', N' Trượt thác Hòa Phú Thành là hoạt động mạo hiểm hấp dẫn, nơi du khách ngồi trên thuyền phao và vượt qua các thác ghềnh tự nhiên. Ngoài ra, khu du lịch còn có các hoạt động như zipline, tắm suối và cắm trại giữa thiên nhiên hoang sơ. ', N'Xã Hòa Phú, huyện Hòa Vang, Đà Nẵng', 6, N'Adventure', 150000, 10, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'truothac.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (29, 4, N'Thánh địa Mỹ Sơn – Kinh đô tinh của Champa cổ', N'Thánh địa Mỹ Sơn là quần thể vương miện Hindu giáo cổ xưa nhất Đông Nam Á, từng là trung tâm tín ngưỡng và văn hóa của vương quốc Champa. Được xây dựng từ thế kỷ 4 đến 13, nơi đây sở hữu hàng tháp tháp Chăm sóc với kỹ thuật xây dựng bí ẩn, kiến trúc chạm khắc tinh thần và không khí linh thiêng cổ kính. Được UNESCO công nhận là Di sản Văn hóa Thế giới năm 1999.', N'Xã Duy Phú, huyện Duy Xuyên, Quảng Nam', 8, N'History', 120000, 12, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'my-son.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (30, 5, N'Nem nướng Nha Trang', N'Món ăn đặc sản nổi tiếng, gồm nem nướng thơm lừng, bánh tráng chiên giòn, rau sống và nước sốt đặc biệt. Khi ăn, cuốn tất cả lại và chấm với nước sốt, tạo nên hương vị hòa quyện độc đáo.', N'16A Lãn Ông, TP. Nha Trang', 9, N'Food', 150000, 10, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'nem_nuong.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (31, 4, N'Bún sứa Nha Trang', N'Món bún với sứa tươi giòn, nước lèo trong vắt nấu từ cá tươi, ăn kèm rau sống và gia vị, tạo nên hương vị thanh mát, đặc trưng của biển.', N'o	Quán bún sứa Dốc Lếch – Ngã tư Yersin – Bà Triệu, TP. Nha Trang', 9, N'Food', 100000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'bunsua.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (34, 5, N'Tháp Đôi (Tháp Hưng Thạnh)', N'Công trình kiến trúc Chăm Pa độc đáo với hai tháp nằm cạnh nhau, mang đậm dấu ấn văn hóa Chăm', N'Đường Trần Hưng Đạo, TP. Quy Nhơn.', 10, N'Food', 70000, 12, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'thapdoi.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (35, 4, N'Khám phá văn hóa địa phương tại Quy Nhơn', N'Hoạt động thú vị tại Quy Nhơn giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Quy Nhơn', 10, N'Food', 120000, 12, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (36, 5, N'Khám phá văn hóa địa phương tại TP.HCM', N'Hoạt động thú vị tại TP.HCM giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm TP.HCM', 11, N'Culture', 100000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (37, 4, N'Trải nghiệm ẩm thực đường phố tại TP.HCM', N'Hoạt động thú vị tại TP.HCM giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm TP.HCM', 11, N'Culture', 70000, 12, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (38, 5, N'Trải nghiệm ẩm thực đường phố tại Vũng Tàu', N'Hoạt động thú vị tại Vũng Tàu giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Vũng Tàu', 12, N'Adventure', 50000, 8, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (39, 4, N'Tour xe đạp khám phá thành phố tại Vũng Tàu', N'Hoạt động thú vị tại Vũng Tàu giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Vũng Tàu', 12, N'Adventure', 70000, 10, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (40, 5, N'Tour xe đạp khám phá thành phố tại Cần Thơ', N'Hoạt động thú vị tại Cần Thơ giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Cần Thơ', 13, N'Food', 150000, 10, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (41, 4, N'Tham quan di tích lịch sử tại Cần Thơ', N'Hoạt động thú vị tại Cần Thơ giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Cần Thơ', 13, N'Food', 70000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (42, 5, N'Tham quan di tích lịch sử tại Đà Lạt', N'Hoạt động thú vị tại Đà Lạt giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Đà Lạt', 15, N'History', 120000, 10, CAST(N'03:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (43, 4, N'Lớp học nấu ăn truyền thống tại Đà Lạt', N'Hoạt động thú vị tại Đà Lạt giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Đà Lạt', 15, N'History', 70000, 12, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (44, 5, N'Lớp học nấu ăn truyền thống tại Bến Tre', N'Hoạt động thú vị tại Bến Tre giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Bến Tre', 16, N'History', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (45, 4, N'Leo núi và ngắm cảnh tại Bến Tre', N'Hoạt động thú vị tại Bến Tre giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Bến Tre', 16, N'History', 150000, 12, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-05-31' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (48, 1, N'Khám phá văn hóa địa phương tại Hà Nội', N'Hoạt động thú vị tại Hà Nội giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Hà Nội', 1, N'History', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (49, 1, N'Trải nghiệm ẩm thực đường phố tại Hà Nội', N'Hoạt động thú vị tại Hà Nội giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Hà Nội', 1, N'History', 70000, 12, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (50, 1, N'Trải nghiệm ẩm thực đường phố tại Hải Phòng', N'Hoạt động thú vị tại Hải Phòng giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm Hải Phòng', 2, N'Culture', 70000, 10, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (51, 1, N'Tour xe đạp khám phá thành phố tại Hải Phòng', N'Hoạt động thú vị tại Hải Phòng giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm Hải Phòng', 2, N'Culture', 100000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (54, 1, N'Tham quan di tích lịch sử tại Hạ Long', N'Hoạt động thú vị tại Hạ Long giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Hạ Long', 4, N'Food', 70000, 12, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (55, 1, N'Lớp học nấu ăn truyền thống tại Hạ Long', N'Hoạt động thú vị tại Hạ Long giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Hạ Long', 4, N'Food', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (56, 1, N'Lớp học nấu ăn truyền thống tại Ninh Bình', N'Hoạt động thú vị tại Ninh Bình giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Ninh Bình', 5, N'History', 150000, 8, CAST(N'02:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (57, 1, N'Leo núi và ngắm cảnh tại Ninh Bình', N'Hoạt động thú vị tại Ninh Bình giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Ninh Bình', 5, N'History', 100000, 8, CAST(N'03:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (60, 1, N'Khám phá văn hóa địa phương tại Huế', N'Hoạt động thú vị tại Huế giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm Huế', 7, N'Culture', 70000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (61, 1, N'Trải nghiệm ẩm thực đường phố tại Huế', N'Hoạt động thú vị tại Huế giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm Huế', 7, N'Culture', 70000, 8, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (62, 1, N'Trải nghiệm ẩm thực đường phố tại Đà Nẵng', N'Hoạt động thú vị tại Đà Nẵng giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Đà Nẵng', 6, N'Food', 150000, 12, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (63, 1, N'Tour xe đạp khám phá thành phố tại Đà Nẵng', N'Hoạt động thú vị tại Đà Nẵng giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Đà Nẵng', 6, N'Food', 150000, 10, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (64, 1, N'Tour xe đạp khám phá thành phố tại Hội An', N'Hoạt động thú vị tại Hội An giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Hội An', 8, N'History', 150000, 10, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (65, 1, N'Tham quan di tích lịch sử tại Hội An', N'Hoạt động thú vị tại Hội An giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Hội An', 8, N'History', 120000, 12, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (66, 1, N'Tham quan di tích lịch sử tại Nha Trang', N'Hoạt động thú vị tại Nha Trang giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Nha Trang', 9, N'Adventure', 150000, 10, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (67, 1, N'Lớp học nấu ăn truyền thống tại Nha Trang', N'Hoạt động thú vị tại Nha Trang giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Nha Trang', 9, N'Adventure', 100000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (70, 1, N'Leo núi và ngắm cảnh tại Quy Nhơn', N'Hoạt động thú vị tại Quy Nhơn giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Quy Nhơn', 10, N'Food', 70000, 12, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (71, 1, N'Khám phá văn hóa địa phương tại Quy Nhơn', N'Hoạt động thú vị tại Quy Nhơn giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Quy Nhơn', 10, N'Food', 120000, 12, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (72, 1, N'Khám phá văn hóa địa phương tại TP.HCM', N'Hoạt động thú vị tại TP.HCM giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm TP.HCM', 11, N'Culture', 100000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (73, 1, N'Trải nghiệm ẩm thực đường phố tại TP.HCM', N'Hoạt động thú vị tại TP.HCM giúp bạn hiểu thêm về culture và văn hóa bản địa.', N'Trung tâm TP.HCM', 11, N'Culture', 70000, 12, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (74, 1, N'Trải nghiệm ẩm thực đường phố tại Vũng Tàu', N'Hoạt động thú vị tại Vũng Tàu giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Vũng Tàu', 12, N'Adventure', 50000, 8, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (75, 1, N'Tour xe đạp khám phá thành phố tại Vũng Tàu', N'Hoạt động thú vị tại Vũng Tàu giúp bạn hiểu thêm về adventure và văn hóa bản địa.', N'Trung tâm Vũng Tàu', 12, N'Adventure', 70000, 10, CAST(N'01:30:00' AS Time), N'CHALLENGING', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (76, 1, N'Tour xe đạp khám phá thành phố tại Cần Thơ', N'Hoạt động thú vị tại Cần Thơ giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Cần Thơ', 13, N'Food', 150000, 10, CAST(N'01:30:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (77, 1, N'Tham quan di tích lịch sử tại Cần Thơ', N'Hoạt động thú vị tại Cần Thơ giúp bạn hiểu thêm về food và văn hóa bản địa.', N'Trung tâm Cần Thơ', 13, N'Food', 70000, 8, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (78, 1, N'Tham quan di tích lịch sử tại Đà Lạt', N'Hoạt động thú vị tại Đà Lạt giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Đà Lạt', 15, N'History', 120000, 10, CAST(N'03:00:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (79, 1, N'Lớp học nấu ăn truyền thống tại Đà Lạt', N'Hoạt động thú vị tại Đà Lạt giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Đà Lạt', 15, N'History', 70000, 12, CAST(N'02:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (80, 1, N'Lớp học nấu ăn truyền thống tại Bến Tre', N'Hoạt động thú vị tại Bến Tre giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Bến Tre', 16, N'History', 70000, 8, CAST(N'01:30:00' AS Time), N'MODERATE', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
INSERT [dbo].[Experiences] ([experienceId], [hostId], [title], [description], [location], [cityId], [type], [price], [maxGroupSize], [duration], [difficulty], [language], [includedItems], [requirements], [createdAt], [isActive], [images], [averageRating], [totalBookings]) VALUES (81, 1, N'Leo núi và ngắm cảnh tại Bến Tre', N'Hoạt động thú vị tại Bến Tre giúp bạn hiểu thêm về history và văn hóa bản địa.', N'Trung tâm Bến Tre', 16, N'History', 150000, 12, CAST(N'03:00:00' AS Time), N'EASY', N'Vietnamese', N'Hướng dẫn, Nước uống', N'Sức khỏe tốt', CAST(N'2025-06-02' AS Date), 1, N'default.jpg', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[Experiences] OFF
GO
ALTER TABLE [dbo].[Experiences] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[Experiences] ADD  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[Experiences] ADD  DEFAULT ((0)) FOR [averageRating]
GO
ALTER TABLE [dbo].[Experiences] ADD  DEFAULT ((0)) FOR [totalBookings]
GO
ALTER TABLE [dbo].[Experiences]  WITH CHECK ADD FOREIGN KEY([cityId])
REFERENCES [dbo].[Cities] ([cityId])
GO
ALTER TABLE [dbo].[Experiences]  WITH CHECK ADD FOREIGN KEY([hostId])
REFERENCES [dbo].[Users] ([userId])
GO
ALTER TABLE [dbo].[Experiences]  WITH CHECK ADD CHECK  (([difficulty]='CHALLENGING' OR [difficulty]='MODERATE' OR [difficulty]='EASY'))
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

-- Hosts và Travelers (từ user1 đến user70)

-- Chèn Hosts
DECLARE @i INT = 1;
WHILE @i <= 70
BEGIN
    DECLARE @email NVARCHAR(100) = 'user' + CAST(@i AS NVARCHAR(10)) + '@example.com';
    DECLARE @fullName NVARCHAR(100);
    DECLARE @phone NVARCHAR(20) = '09' + RIGHT('00000000' + CAST(ROUND(RAND() * 99999999, 0) AS NVARCHAR(8)), 8);
    DECLARE @dateOfBirth DATE = DATEADD(DAY, -ROUND(RAND() * 10000, 0), '2005-01-01');
    DECLARE @gender NVARCHAR(10) = CASE WHEN RAND() > 0.5 THEN N'Nam' ELSE N'Nữ' END;
    DECLARE @role NVARCHAR(50) = CASE 
        WHEN @i BETWEEN 31 AND 55 THEN 'TRAVELER' 
        ELSE 'HOST' 
    END;

    SET @fullName = CASE @i
        WHEN 1 THEN N'Vũ Hữu Mai'
        WHEN 2 THEN N'Hoàng Thanh Kiên'
        WHEN 3 THEN N'Huỳnh Tấn Việt'
        WHEN 4 THEN N'Hoàng Thanh Nam'
        WHEN 5 THEN N'Phạm Gia Hà'
        WHEN 6 THEN N'Phan Văn Phúc'
        WHEN 7 THEN N'Vũ Thị Hà'
        WHEN 8 THEN N'Huỳnh Ngọc Hùng'
        WHEN 9 THEN N'Phan Ngọc Hùng'
        WHEN 10 THEN N'Phạm Văn Kiên'
        WHEN 11 THEN N'Đặng Ngọc Sơn'
        WHEN 12 THEN N'Huỳnh Trọng Kiên'
        WHEN 13 THEN N'Huỳnh Hữu Hùng'
        WHEN 14 THEN N'Bùi Hữu Lam'
        WHEN 15 THEN N'Huỳnh Gia Hạnh'
        WHEN 16 THEN N'Phạm Trọng Châu'
        WHEN 17 THEN N'Nguyễn Hữu Trang'
        WHEN 18 THEN N'Phạm Thị Hùng'
        WHEN 19 THEN N'Vũ Trọng Lam'
        WHEN 20 THEN N'Phan Đức Châu'
        WHEN 21 THEN N'Hoàng Hữu Lam'
        WHEN 22 THEN N'Vũ Đức Hùng'
        WHEN 23 THEN N'Đặng Đức Nam'
        WHEN 24 THEN N'Bùi Thanh Quân'
        WHEN 25 THEN N'Trần Đức Bình'
        WHEN 26 THEN N'Phạm Trọng Châu'
        WHEN 27 THEN N'Phạm Gia Hạnh'
        WHEN 28 THEN N'Lê Trọng Dương'
        WHEN 29 THEN N'Bùi Thị Yến'
        WHEN 30 THEN N'Nguyễn Thị Lam'
        WHEN 31 THEN N'Nguyễn Thị Hùng'
        WHEN 32 THEN N'Phạm Gia Hạnh'
        WHEN 33 THEN N'Hoàng Gia Trang'
        WHEN 34 THEN N'Bùi Gia Sơn'
        WHEN 35 THEN N'Phạm Hữu Mai'
        WHEN 36 THEN N'Lê Ngọc Trang'
        WHEN 37 THEN N'Huỳnh Văn Kiên'
        WHEN 38 THEN N'Nguyễn Đức Trang'
        WHEN 39 THEN N'Đặng Văn Sơn'
        WHEN 40 THEN N'Đặng Ngọc Yến'
        WHEN 41 THEN N'Phạm Trọng Dương'
        WHEN 42 THEN N'Lê Hữu An'
        WHEN 43 THEN N'Hoàng Gia Hạnh'
        WHEN 44 THEN N'Phan Gia Nam'
        WHEN 45 THEN N'Trần Thị Phúc'
        WHEN 46 THEN N'Đặng Thị Bình'
        WHEN 47 THEN N'Nguyễn Minh Kiên'
        WHEN 48 THEN N'Đặng Trọng Hà'
        WHEN 49 THEN N'Phan Thị Lam'
        WHEN 50 THEN N'Phạm Văn Việt'
        WHEN 51 THEN N'Phan Thanh Sơn'
        WHEN 52 THEN N'Phạm Thanh Mai'
        WHEN 53 THEN N'Vũ Thị Quân'
        WHEN 54 THEN N'Huỳnh Thanh Việt'
        WHEN 55 THEN N'Huỳnh Đức Sơn'
        WHEN 56 THEN N'Hoàng Đức Trang'
        WHEN 57 THEN N'Hoàng Tấn Hùng'
        WHEN 58 THEN N'Đặng Hữu Nam'
        WHEN 59 THEN N'Trần Thanh Kiên'
        WHEN 60 THEN N'Hoàng Đức Việt'
        WHEN 61 THEN N'Lê Gia Phúc'
        WHEN 62 THEN N'Trần Hữu Dương'
        WHEN 63 THEN N'Phạm Thị Lam'
        WHEN 64 THEN N'Đặng Đức Sơn'
        WHEN 65 THEN N'Vũ Minh Châu'
        WHEN 66 THEN N'Trần Trọng Lam'
        WHEN 67 THEN N'Bùi Thị Kiên'
        WHEN 68 THEN N'Lê Minh Hà'
        WHEN 69 THEN N'Lê Ngọc Sơn'
        WHEN 70 THEN N'Đặng Đức An'
    END;

    INSERT INTO Users (
        email, password, fullName, phone, dateOfBirth, gender,
        avatar, bio, createdAt, isActive, role, emailVerified, verificationToken, tokenExpiry
    ) VALUES (
        @email, '123456', @fullName, @phone, @dateOfBirth, @gender,
        NULL, NULL, GETDATE(), 1, @role, 1, NULL, NULL
    );

    SET @i = @i + 1;
END;
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
    (SELECT userId FROM Users WHERE email='user1@example.com'),
    N'Căn hộ Lam Home Seaview',
    N'Căn hộ sang trọng với tầm nhìn toàn cảnh vịnh Hạ Long',
    (SELECT cityId FROM Cities WHERE name='Ha Long'),
    N'123 Đường Bãi Cháy, Hạ Long, Quảng Ninh',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Ban công, Tầm nhìn biển, TV thông minh',
    1500000,
    N'lam.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user2@example.com'),
    N'Homestay Lily Hạ Long - Phòng 203',
    N'Phòng nghỉ ấm cúng gần bãi biển, lý tưởng cho cặp đôi',
    (SELECT cityId FROM Cities WHERE name='Ha Long'),
    N'456 Đường Hạ Long, Hạ Long, Quảng Ninh',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Tủ lạnh, Bếp nhỏ',
    700000,
    N'lily.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user3@example.com'),
    N'Phòng gia đình nhìn ra biển bởi Ahana Homestay HL',
    N'Phòng rộng rãi cho gia đình, gần vịnh Hạ Long',
    (SELECT cityId FROM Cities WHERE name='Ha Long'),
    N'789 Đường Tuần Châu, Hạ Long, Quảng Ninh',
    'Homestay',
    3,
    N'Wifi, Điều hòa, Ban công, Bữa sáng miễn phí',
    1800000,
    N'ahana.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user4@example.com'),
    N'Studio Ocean Blue bên bờ biển Giường Chill & Super King',
    N'Studio hiện đại với giường cỡ lớn, view biển tuyệt đẹp',
    (SELECT cityId FROM Cities WHERE name='Ha Long'),
    N'101 Đường Bãi Cháy, Hạ Long, Quảng Ninh',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Ban công, TV, Tầm nhìn biển',
    1200000,
    N'ocean.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user5@example.com'),
    N'Hanoi Park House 2.1 - Ban công - Khu phố cổ',
    N'Nhà nghỉ phong cách hiện đại, gần phố cổ Hà Nội',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'123 Phố Hàng Bạc, Hoàn Kiếm, Hà Nội',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Ban công, Bếp chung',
    900000,
    N'a1.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user6@example.com'),
    N'Toàn bộ nhà tại Đống Đa, Việt Nam',
    N'Ngôi nhà riêng biệt, lý tưởng cho nhóm bạn hoặc gia đình',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'456 Đường Láng, Đống Đa, Hà Nội',
    'Homestay',
    4,
    N'Wifi, Điều hòa, Máy giặt, Bếp đầy đủ, Bãi đỗ xe',
    2200000,
    N'b1.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user7@example.com'),
    N'Tuyệt đẹp Lakeview-Balcony&Projector-Brand mới',
    N'Căn hộ mới với view hồ Tây, có máy chiếu giải trí',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'789 Đường Tây Hồ, Tây Hồ, Hà Nội',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Máy chiếu, Ban công, Tầm nhìn hồ',
    1600000,
    N'c1.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user8@example.com'),
    N'Vista 9 Skyline Suite A Poetic Gaze Over Hanoi',
    N'Căn hộ cao cấp với tầm nhìn toàn cảnh Hà Nội',
    (SELECT cityId FROM Cities WHERE name='Hanoi'),
    N'101 Phố Hàng Đào, Hoàn Kiếm, Hà Nội',
    'Hotel',
    3,
    N'Wifi, Điều hòa, Minibar, Tầm nhìn thành phố, Phòng gym',
    2500000,
    N'd1.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user9@example.com'),
    N'$Bigsale - căn hộ cao cấp tại HP - Diamond Crown',
    N'Căn hộ sang trọng tại khu Diamond Crown Hải Phòng',
    (SELECT cityId FROM Cities WHERE name='Haiphong'),
    N'123 Đường Lê Lợi, Ngô Quyền, Hải Phòng',
    'Hotel',
    2,
    N'Wifi, Hồ bơi, Phòng gym, Bữa sáng miễn phí',
    1400000,
    N'e.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user10@example.com'),
    N'Căn hộ tại HaiPhong Center - 2 phòng ngủ, 2 phòng tắm',
    N'Căn hộ tiện nghi tại trung tâm Hải Phòng, gần cảng',
    (SELECT cityId FROM Cities WHERE name='Haiphong'),
    N'456 Đường Cát Dài, Lê Chân, Hải Phòng',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Bếp, Máy giặt',
    1100000,
    N'f.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user11@example.com'),
    N'Homestay Nhà Ann - Phòng Haru',
    N'Phòng nghỉ phong cách Nhật Bản, gần trung tâm',
    (SELECT cityId FROM Cities WHERE name='Haiphong'),
    N'789 Đường Đà Nẵng, Hải An, Hải Phòng',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Tủ lạnh, Bữa sáng nhẹ',
    750000,
    N'g.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user12@example.com'),
    N'Nhà Bim',
    N'Nhà nghỉ đơn giản, gần cảng, phù hợp cho khách du lịch tiết kiệm',
    (SELECT cityId FROM Cities WHERE name='Haiphong'),
    N'101 Đường Lạch Tray, Ngô Quyền, Hải Phòng',
    'Guesthouse',
    3,
    N'Wifi, Điều hòa, Bãi đỗ xe, Quạt',
    600000,
    N'h.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user13@example.com'),
    N'Bungalow đôi có bồn tắm Lotus Field Homestay',
    N'Bungalow lãng mạn với bồn tắm riêng, gần Tam Cốc',
    (SELECT cityId FROM Cities WHERE name='Ninh Binh'),
    N'123 Đường Tam Cốc, Hoa Lư, Ninh Bình',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Bồn tắm, Vườn, Xe đạp miễn phí',
    1000000,
    N'n.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user14@example.com'),
    N'Homestay Amy House yên bình 1 phòng',
    N'Phòng nghỉ yên tĩnh, gần khu du lịch Tràng An',
    (SELECT cityId FROM Cities WHERE name='Ninh Binh'),
    N'456 Đường Tràng An, Ninh Bình',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Vườn, Bữa sáng địa phương',
    650000,
    N'j.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user15@example.com'),
    N'The Wooden Gate Ninh Bình - Jasmine Flower King',
    N'Phòng nghỉ sang trọng với phong cách thiên nhiên',
    (SELECT cityId FROM Cities WHERE name='Ninh Binh'),
    N'789 Đường Tam Cốc, Hoa Lư, Ninh Bình',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Tầm nhìn núi, Xe đạp miễn phí',
    1300000,
    N's.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user16@example.com'),
    N'The Wooden Gate Ninh Bình - Tropical Bunk Suite',
    N'Phòng nghỉ độc đáo với giường tầng, gần Tràng An',
    (SELECT cityId FROM Cities WHERE name='Ninh Binh'),
    N'101 Đường Tràng An, Ninh Bình',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Ban công, Tầm nhìn đồng lúa',
    950000,
    N'aaaaa.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user17@example.com'),
    N'Coconut Room - Nhà Mơ Homestay Bến Tre',
    N'Phòng nghỉ mộc mạc giữa vườn dừa, trải nghiệm miền Tây',
    (SELECT cityId FROM Cities WHERE name='Ben Tre'),
    N'123 Đường Miệt Vườn, Mỏ Cày Nam, Bến Tre',
    'Homestay',
    1,
    N'Wifi, Quạt, Xe đạp miễn phí, Vườn dừa, Bữa sáng địa phương',
    600000,
    N'oo.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user18@example.com'),
    N'Comfy 1 Riverside Mekong Bến Tre homestay',
    N'Homestay ấm cúng bên sông Mekong, gần chợ nổi',
    (SELECT cityId FROM Cities WHERE name='Ben Tre'),
    N'456 Đường Sông Cái, Châu Thành, Bến Tre',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Thuyền chèo, Bữa sáng nhẹ',
    650000,
    N'ax.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user19@example.com'),
    N'Haven Nest retreat ( Grasshopper-châu chấu)',
    N'Phòng nghỉ độc đáo lấy cảm hứng từ thiên nhiên, gần sông',
    (SELECT cityId FROM Cities WHERE name='Ben Tre'),
    N'789 Đường Phú Lễ, Ba Tri, Bến Tre',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Vườn, Tầm nhìn sông',
    800000,
    N'kkk.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user20@example.com'),
    N'Haven Nest Retreat (Grey Featherback - Cá Mè Dinh)',
    N'Phòng nghỉ sang trọng với phong cách miền Tây, gần vườn dừa',
    (SELECT cityId FROM Cities WHERE name='Ben Tre'),
    N'101 Đường Mỏ Cày, Bến Tre',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Thuyền chèo, Vườn dừa',
    850000,
    N'aq.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user21@example.com'),
    N'Chậm Garden - Cảm nhận cuộc sống thiên nhiên',
    N'Homestay yên bình gần chợ nổi Cái Răng, hòa mình vào thiên nhiên',
    (SELECT cityId FROM Cities WHERE name='Can Tho'),
    N'123 Đường Cái Răng, Ninh Kiều, Cần Thơ',
    'Homestay',
    2,
    N'Wifi, Quạt, Xe đạp miễn phí, Vườn, Bữa sáng địa phương',
    700000,
    N'sa.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user22@example.com'),
    N'Midmost Casa - Superior Studio',
    N'Studio hiện đại, nằm ngay trung tâm Cần Thơ',
    (SELECT cityId FROM Cities WHERE name='Can Tho'),
    N'456 Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Bếp nhỏ, TV thông minh',
    900000,
    N'sd.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user23@example.com'),
    N'Miha Villa 1 - Nhà tại Cần Thơ',
    N'Ngôi nhà riêng biệt, lý tưởng cho gia đình hoặc nhóm bạn',
    (SELECT cityId FROM Cities WHERE name='Can Tho'),
    N'789 Đường 30/4, Ninh Kiều, Cần Thơ',
    'Homestay',
    3,
    N'Wifi, Điều hòa, Bếp đầy đủ, Máy giặt, Bãi đỗ xe',
    1500000,
    N'sw.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user24@example.com'),
    N'pipo house - nắng đẹp, 1br',
    N'Phòng nghỉ đầy nắng, gần trung tâm Cần Thơ',
    (SELECT cityId FROM Cities WHERE name='Can Tho'),
    N'101 Đường Lê Lợi, Ninh Kiều, Cần Thơ',
    'Guesthouse',
    1,
    N'Wifi, Điều hòa, Ban công, Bữa sáng nhẹ',
    750000,
    N'se.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user25@example.com'),
    N'Căn Family nguyên căn 2 phòng ngủ- Lavita home',
    N'Căn hộ gia đình tiện nghi, gần trung tâm Đà Lạt',
    (SELECT cityId FROM Cities WHERE name='Da Lat'),
    N'123 Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt',
    'Homestay',
    2,
    N'Wifi, Sưởi, Bếp, Ban công, Tầm nhìn đồi thông',
    1200000,
    N'sr.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user26@example.com'),
    N'Mối Tình Đầu Homestay Bus Room',
    N'Phòng nghỉ độc đáo thiết kế như xe buýt, gần hồ Xuân Hương',
    (SELECT cityId FROM Cities WHERE name='Da Lat'),
    N'456 Đường Hồ Xuân Hương, Phường 9, Đà Lạt',
    'Homestay',
    1,
    N'Wifi, Sưởi, Tủ lạnh, Vườn hoa',
    850000,
    N'st.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user27@example.com'),
    N'South Of The border - Phia Nam Biên Gioi',
    N'Homestay phong cách vintage, gần Thung Lũng Tình Yêu',
    (SELECT cityId FROM Cities WHERE name='Da Lat'),
    N'789 Đường Trại Mát, Phường 11, Đà Lạt',
    'Homestay',
    2,
    N'Wifi, Sưởi, Ban công, Lò sưởi',
    1000000,
    N'sy.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user28@example.com'),
    N'Summery - Nhà của Eiji',
    N'Ngôi nhà phong cách Nhật Bản, không gian ấm cúng ở Đà Lạt',
    (SELECT cityId FROM Cities WHERE name='Da Lat'),
    N'101 Đường Lê Hồng Phong, Phường 4, Đà Lạt',
    'Homestay',
    2,
    N'Wifi, Sưởi, Vườn, Bữa sáng kiểu Nhật',
    1100000,
    N'su.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user29@example.com'),
    N'Casa CoCore TimeOut khu phố thú vị nhất Sài Gòn',
    N'Căn hộ cao cấp ở trung tâm Quận 1, gần phố đi bộ Nguyễn Huệ',
    (SELECT cityId FROM Cities WHERE name='Ho Chi Minh City'),
    N'123 Đường Lê Lợi, Quận 1, TP.HCM',
    'Hotel',
    2,
    N'Wifi, Điều hòa, Hồ bơi, Phòng gym, Minibar',
    2000000,
    N'ds.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user30@example.com'),
    N'ĐaKao Vibe Retro Studio GB in Center by Circadian',
    N'Studio phong cách retro ở khu Đa Kao sầm uất',
    (SELECT cityId FROM Cities WHERE name='Ho Chi Minh City'),
    N'456 Đường Đinh Tiên Hoàng, Quận 1, TP.HCM',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Bếp nhỏ, TV thông minh',
    950000,
    N'da.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user1@example.com'),
    N'Huế Studio gần đường Bùi Viện Em''s Home 5',
    N'Studio sôi động gần khu phố Tây Bùi Viện',
    (SELECT cityId FROM Cities WHERE name='Ho Chi Minh City'),
    N'789 Đường Bùi Viện, Quận 1, TP.HCM',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Ban công, Tủ lạnh',
    900000,
    N'df.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user2@example.com'),
    N'Mây 3 - Studio đầy đủ tiện nghi',
    N'Studio hiện đại gần chợ Bến Thành, tiện nghi đầy đủ',
    (SELECT cityId FROM Cities WHERE name='Ho Chi Minh City'),
    N'101 Đường Lê Thị Riêng, Quận 1, TP.HCM',
    'Guesthouse',
    1,
    N'Wifi, Điều hòa, Bếp, TV thông minh',
    850000,
    N'dg.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user3@example.com'),
    N'Bigphil Home - Một ngôi nhà Santorini ấm cúng có bếp',
    N'Homestay phong cách Santorini, gần bãi biển Vũng Tàu',
    (SELECT cityId FROM Cities WHERE name='Vung Tau'),
    N'123 Đường Bãi Sau, TP. Vũng Tàu',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Bếp, Ban công, Tầm nhìn biển',
    1200000,
    N'ca.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user4@example.com'),
    N'Căn hộ ven biển CSJ Tower có tầm nhìn tuyệt đẹp [22 Lagom]',
    N'Căn hộ cao cấp với view biển tại CSJ Tower',
    (SELECT cityId FROM Cities WHERE name='Vung Tau'),
    N'456 Đường Thùy Vân, TP. Vũng Tàu',
    'Hotel',
    2,
    N'Wifi, Điều hòa, Hồ bơi, Phòng gym, Tầm nhìn biển',
    1800000,
    N'cs.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user5@example.com'),
    N'Leo House - Tòa nhà The Song (Angia)',
    N'Căn hộ sang trọng trong tòa The Song, gần bãi biển',
    (SELECT cityId FROM Cities WHERE name='Vung Tau'),
    N'789 Đường Lê Hồng Phong, TP. Vũng Tàu',
    'Hotel',
    3,
    N'Wifi, Điều hòa, Hồ bơi, Minibar, Bãi đỗ xe',
    2000000,
    N'cd.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user6@example.com'),
    N'Nhà Lily - Phòng Xanh, 1 phòng ngủ & phòng tắm riêng',
    N'Phòng nghỉ màu xanh, gần bãi biển Vũng Tàu',
    (SELECT cityId FROM Cities WHERE name='Vung Tau'),
    N'101 Đường Hạ Long, TP. Vũng Tàu',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Ban công, Tầm nhìn biển, Bữa sáng nhẹ',
    900000,
    N'cf.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user7@example.com'),
    N'Family Home Villa Bà Nà Hill Sun World',
    N'Biệt thự gia đình gần khu du lịch Bà Nà Hills',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'123 Đường Bà Nà, Đà Nẵng',
    'Resort',
    8,
    N'Wifi, Hồ bơi, Bãi đỗ xe, Bữa sáng miễn phí',
    2500000,
    N'qa.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user8@example.com'),
    N'Jhome-2BR-Fully Furnished',
    N'Căn hộ 2 phòng ngủ đầy đủ tiện nghi gần trung tâm',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'45 Nguyễn Văn Linh, Đà Nẵng',
    'Homestay',
    2,
    N'Wifi, Máy giặt, Ban công',
    800000,
    N'qw.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user9@example.com'),
    N'May Home RoomWasherBalcony5 phút đến Bãi biển Mỹ Khê',
    N'Phòng nghỉ tiện nghi cách bãi biển Mỹ Khê 5 phút',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'78 Võ Nguyên Giáp, Đà Nẵng',
    'Homestay',
    3,
    N'Wifi, Máy giặt, Ban công, Điều hòa',
    600000,
    N'qs.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user10@example.com'),
    N'Mon Fiori Homestay x Moana Modern Apartment',
    N'Căn hộ hiện đại phong cách Mon Fiori gần biển',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'12 An Thượng, Đà Nẵng',
    'Homestay',
    4,
    N'Wifi, Bếp, Ban công, TV',
    900000,
    N'qf.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user11@example.com'),
    N'1107ss Deluxe Ocean Viewmiễn phí đón 1 chiều',
    N'Căn hộ sang trọng với tầm nhìn biển, miễn phí đưa đón',
    (SELECT cityId FROM Cities WHERE name='Da Nang'),
    N'56 Võ Nguyên Giáp, Đà Nẵng',
    'Hotel',
    5,
    N'Wifi, Hồ bơi, Đưa đón sân bay',
    1500000,
    N'we.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user12@example.com'),
    N'Căn HỘ Poetic Riverside Attic ở Hội An - Chợ đêm',
    N'Căn hộ thơ mộng gần chợ đêm Hội An',
    (SELECT cityId FROM Cities WHERE name='Hoi An'),
    N'23 Nguyễn Hoàng, Hội An',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Xe đạp miễn phí',
    700000,
    N'wa.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user13@example.com'),
    N'Chilling Hoi An APT-BTW An An Bàng Beach+Ancient Town',
    N'Căn hộ thư giãn giữa bãi biển An Bàng và phố cổ',
    (SELECT cityId FROM Cities WHERE name='Hoi An'),
    N'45 Cửa Đại, Hội An',
    'Homestay',
    3,
    N'Wifi, Bếp, Ban công, Xe đạp',
    850000,
    N'wd.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user14@example.com'),
    N'Zen House-WoodenHouse Japan Style gần Trung tâm',
    N'Nhà gỗ phong cách Nhật Bản gần trung tâm Hội An',
    (SELECT cityId FROM Cities WHERE name='Hoi An'),
    N'67 Trần Nhân Tông, Hội An',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Vườn nhỏ',
    750000,
    N'wz.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user15@example.com'),
    N'Limdim Here - Phòng ''ici'' cho 2 khách',
    N'Phòng nghỉ ấm cúng cho 2 người tại Huế',
    (SELECT cityId FROM Cities WHERE name='Hue'),
    N'12 Lê Lợi, Huế',
    'Guesthouse',
    1,
    N'Wifi, Điều hòa, Bữa sáng',
    500000,
    N'za.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user16@example.com'),
    N'NguyễnHouse# StudioRoomtại Trung tâm thành phố Huế',
    N'Phòng studio hiện đại tại trung tâm Huế',
    (SELECT cityId FROM Cities WHERE name='Hue'),
    N'34 Nguyễn Trãi, Huế',
    'Homestay',
    1,
    N'Wifi, Bếp, Điều hòa',
    550000,
    N'xz.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user17@example.com'),
    N'Nhà Ngau - phòng ''Métro'' cho 2 khách',
    N'Phòng phong cách Métro độc đáo tại Huế',
    (SELECT cityId FROM Cities WHERE name='Hue'),
    N'56 Phạm Ngũ Lão, Huế',
    'Guesthouse',
    1,
    N'Wifi, Điều hòa, Bữa sáng miễn phí',
    520000,
    N'xc.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user18@example.com'),
    N'Phòng tại khách sạn boutique tại Hue, Việt Nam',
    N'Phòng boutique sang trọng tại trung tâm Huế',
    (SELECT cityId FROM Cities WHERE name='Hue'),
    N'78 Hùng Vương, Huế',
    'Hotel',
    4,
    N'Wifi, Hồ bơi, Bữa sáng, Spa',
    1200000,
    N'xv.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user19@example.com'),
    N'Coral House -3 BR- FULL HOUSE - 700 m ra bãi biển',
    N'Nhà 3 phòng ngủ gần bãi biển Nha Trang',
    (SELECT cityId FROM Cities WHERE name='Nha Trang'),
    N'23 Trần Phú, Nha Trang',
    'Homestay',
    3,
    N'Wifi, Bếp, Ban công, Điều hòa',
    1000000,
    N'xq.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user20@example.com'),
    N'Serenity RiverView 2 giường, phía trên SeaView Charm',
    N'Căn hộ 2 giường với tầm nhìn sông và biển',
    (SELECT cityId FROM Cities WHERE name='Nha Trang'),
    N'45 Nguyễn Thị Minh Khai, Nha Trang',
    'Homestay',
    2,
    N'Wifi, Ban công, Điều hòa',
    900000,
    N'xe.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user21@example.com'),
    N'The Hiden House( 5 phút đến trung tâm bãi biển)',
    N'Nhà nghỉ gần trung tâm và bãi biển Nha Trang',
    (SELECT cityId FROM Cities WHERE name='Nha Trang'),
    N'67 Lê Đại Hành, Nha Trang',
    'Homestay',
    3,
    N'Wifi, Bếp, Điều hòa, Xe đạp',
    800000,
    N'vc.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user22@example.com'),
    N'White Oceanus Cozy 2BR 36Fl SeaviewApt-4km toCenter',
    N'Căn hộ tầng 36 với tầm nhìn biển tuyệt đẹp',
    (SELECT cityId FROM Cities WHERE name='Nha Trang'),
    N'12 Hùng Vương, Nha Trang',
    'Homestay',
    2,
    N'Wifi, Hồ bơi, Ban công, Điều hòa',
    1100000,
    N'ba.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user23@example.com'),
    N'Căn hộ biển Altara Residence',
    N'Căn hộ cao cấp gần bãi biển Quy Nhơn',
    (SELECT cityId FROM Cities WHERE name='Quy Nhon'),
    N'34 Nguyễn Huệ, Quy Nhơn',
    'Homestay',
    3,
    N'Wifi, Hồ bơi, Bãi đỗ xe, Điều hòa',
    950000,
    N'fa.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user24@example.com'),
    N'Pimira Homestay',
    N'Homestay ấm cúng tại trung tâm Quy Nhơn',
    (SELECT cityId FROM Cities WHERE name='Quy Nhon'),
    N'56 Lê Lợi, Quy Nhơn',
    'Homestay',
    2,
    N'Wifi, Điều hòa, Bếp',
    650000,
    N'fs.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user25@example.com'),
    N'Seaview 2BR 3 giường,ban công, trung tâm thành phố Stay by TYE',
    N'Căn hộ 2 phòng ngủ với ban công nhìn biển',
    (SELECT cityId FROM Cities WHERE name='Quy Nhon'),
    N'78 Trần Hưng Đạo, Quy Nhơn',
    'Homestay',
    2,
    N'Wifi, Ban công, Điều hòa, Bếp',
    850000,
    N'fd.jpg',
    1
),
(
    (SELECT userId FROM Users WHERE email='user26@example.com'),
    N'Song Suoi homestay _ căn phòng cạnh biển 1',
    N'Phòng nghỉ gần biển Quy Nhơn, phong cách tự nhiên',
    (SELECT cityId FROM Cities WHERE name='Quy Nhon'),
    N'23 Nguyễn Tất Thành, Quy Nhơn',
    'Homestay',
    1,
    N'Wifi, Điều hòa, Gần biển',
    600000,
    N'fz.jpg',
    1
);
GO

-- Chèn Reviews (dữ liệu mẫu để tránh lỗi CHECK constraint)
INSERT INTO Reviews (accommodationId, travelerId, rating, comment, createdAt) VALUES
(
    1,
    (SELECT userId FROM Users WHERE email='user31@example.com'),
    4,
    N'Chỗ ở sạch sẽ, view biển đẹp!',
    GETDATE()
),
(
    2,
    (SELECT userId FROM Users WHERE email='user32@example.com'),
    5,
    N'Chủ nhà thân thiện, rất đáng tiền.',
    GETDATE()
),
(
    3,
    (SELECT userId FROM Users WHERE email='user33@example.com'),
    3,
    N'Phòng ổn, nhưng wifi hơi yếu.',
    GETDATE()
),
(
    4,
    (SELECT userId FROM Users WHERE email='user34@example.com'),
    4,
    N'View biển tuyệt vời, phòng thoải mái.',
    GETDATE()
),
(
    5,
    (SELECT userId FROM Users WHERE email='user35@example.com'),
    5,
    N'Vị trí gần phố cổ, rất tiện lợi.',
    GETDATE()
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
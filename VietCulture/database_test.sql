-- Database Test Script for VietCulture
-- Kiểm tra và tạo dữ liệu test

USE TravelerDB;
GO

-- 1. Kiểm tra bảng Experiences
PRINT '=== CHECKING EXPERIENCES TABLE ===';
IF OBJECT_ID('Experiences', 'U') IS NOT NULL
BEGIN
    PRINT '✅ Experiences table exists';
    
    -- Kiểm tra cấu trúc bảng
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Experiences'
    ORDER BY ORDINAL_POSITION;
    
    -- Kiểm tra dữ liệu
    SELECT COUNT(*) as TotalExperiences FROM Experiences;
    SELECT COUNT(*) as PendingExperiences FROM Experiences WHERE isActive = 0;
    SELECT COUNT(*) as ApprovedExperiences FROM Experiences WHERE isActive = 1;
    
    -- Hiển thị 5 experiences gần nhất
    SELECT TOP 5 
        experienceId, 
        title, 
        isActive, 
        createdAt,
        hostId
    FROM Experiences 
    ORDER BY createdAt DESC;
END
ELSE
BEGIN
    PRINT '❌ Experiences table does not exist';
END

-- 2. Kiểm tra bảng Users
PRINT '=== CHECKING USERS TABLE ===';
IF OBJECT_ID('Users', 'U') IS NOT NULL
BEGIN
    PRINT '✅ Users table exists';
    
    -- Kiểm tra admin users
    SELECT userId, email, fullName, role 
    FROM Users 
    WHERE role = 'ADMIN';
    
    -- Đếm users theo role
    SELECT role, COUNT(*) as Count
    FROM Users 
    GROUP BY role;
END
ELSE
BEGIN
    PRINT '❌ Users table does not exist';
END

-- 3. Tạo dữ liệu test nếu cần
PRINT '=== CREATING TEST DATA ===';

-- Tạo admin user nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Users WHERE role = 'ADMIN')
BEGIN
    INSERT INTO Users (email, password, fullName, role, isActive, createdAt)
    VALUES ('admin@vietculture.com', 'admin123', 'Admin User', 'ADMIN', 1, GETDATE());
    PRINT '✅ Created admin user';
END

-- Tạo host user nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Users WHERE role = 'HOST')
BEGIN
    INSERT INTO Users (email, password, fullName, role, isActive, createdAt)
    VALUES ('host@vietculture.com', 'host123', 'Test Host', 'HOST', 1, GETDATE());
    PRINT '✅ Created host user';
END

-- Tạo test experience nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Experiences WHERE title = 'Test Experience')
BEGIN
    DECLARE @hostId INT = (SELECT TOP 1 userId FROM Users WHERE role = 'HOST');
    
    IF @hostId IS NOT NULL
    BEGIN
        INSERT INTO Experiences (
            hostId, title, description, location, cityId, type,
            price, maxGroupSize, duration, difficulty, language,
            includedItems, requirements, images, isActive, createdAt
        )
        VALUES (
            @hostId, 'Test Experience', 'This is a test experience', 'Test Location', 1, 'Adventure',
            100.0, 5, '02:00:00', 'EASY', 'Vietnamese,English',
            'Equipment,Guide', 'No special requirements', 'test1.jpg,test2.jpg', 0, GETDATE()
        );
        PRINT '✅ Created test experience (pending approval)';
    END
    ELSE
    BEGIN
        PRINT '❌ No host user found to create test experience';
    END
END

-- 4. Kiểm tra kết quả cuối cùng
PRINT '=== FINAL CHECK ===';
SELECT 'Total Experiences' as Metric, COUNT(*) as Count FROM Experiences
UNION ALL
SELECT 'Pending Experiences', COUNT(*) FROM Experiences WHERE isActive = 0
UNION ALL
SELECT 'Approved Experiences', COUNT(*) FROM Experiences WHERE isActive = 1
UNION ALL
SELECT 'Total Users', COUNT(*) FROM Users
UNION ALL
SELECT 'Admin Users', COUNT(*) FROM Users WHERE role = 'ADMIN'
UNION ALL
SELECT 'Host Users', COUNT(*) FROM Users WHERE role = 'HOST';

PRINT '=== TEST COMPLETED ==='; 
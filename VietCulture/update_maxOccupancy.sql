-- Script cập nhật maxOccupancy cho các record cũ trong bảng Accommodations
-- Chạy script này nếu có record cũ chưa có giá trị maxOccupancy

USE TravelerDB;
GO

-- Kiểm tra xem có record nào có maxOccupancy = NULL không
SELECT accommodationId, name, maxOccupancy 
FROM Accommodations 
WHERE maxOccupancy IS NULL;

-- Cập nhật maxOccupancy = 2 cho các record cũ (nếu có)
UPDATE Accommodations 
SET maxOccupancy = 2 
WHERE maxOccupancy IS NULL;

-- Kiểm tra kết quả
SELECT accommodationId, name, maxOccupancy, numberOfRooms
FROM Accommodations 
ORDER BY accommodationId;

-- Thống kê
SELECT 
    COUNT(*) as total_accommodations,
    AVG(CAST(maxOccupancy AS FLOAT)) as avg_max_occupancy,
    MIN(maxOccupancy) as min_max_occupancy,
    MAX(maxOccupancy) as max_max_occupancy
FROM Accommodations; 
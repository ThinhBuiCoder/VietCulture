-- Kiểm tra bảng Reports
USE TravelerDB;

-- Kiểm tra bảng có tồn tại không
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'Reports';

-- Kiểm tra cấu trúc bảng
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Reports'
ORDER BY ORDINAL_POSITION;

-- Kiểm tra dữ liệu hiện tại
SELECT TOP 10 * FROM Reports ORDER BY reportId DESC;

-- Đếm số bản ghi
SELECT COUNT(*) as TotalReports FROM Reports;

-- Test insert một bản ghi
INSERT INTO Reports (contentType, contentId, reporterId, reason, description, createdAt, status) 
VALUES ('test', 1, 1, 'test reason', 'test description', GETDATE(), 'PENDING');

-- Kiểm tra lại sau khi insert
SELECT TOP 5 * FROM Reports ORDER BY reportId DESC; 
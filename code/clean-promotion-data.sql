-- ===================================
-- SCRIPT XÓA DỮ LIỆU KHUYẾN MÃI CŨ
-- ===================================

USE TravelerDB;
GO

-- Bước 1: Reset tất cả dữ liệu promotion trong bảng Accommodations
UPDATE Accommodations 
SET promotion_percent = 0,
    promotion_start = NULL,
    promotion_end = NULL
WHERE promotion_percent > 0 OR promotion_start IS NOT NULL OR promotion_end IS NOT NULL;

PRINT 'Đã reset ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' bản ghi promotion trong bảng Accommodations';

-- Bước 2: Reset tất cả dữ liệu promotion trong bảng Experiences  
UPDATE Experiences 
SET promotion_percent = 0,
    promotion_start = NULL,
    promotion_end = NULL
WHERE promotion_percent > 0 OR promotion_start IS NOT NULL OR promotion_end IS NOT NULL;

PRINT 'Đã reset ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' bản ghi promotion trong bảng Experiences';

-- Bước 3: Tạo thống kê sau khi cleanup
SELECT 'Accommodations' as TableName, 
       COUNT(*) as TotalRecords,
       SUM(CASE WHEN promotion_percent > 0 THEN 1 ELSE 0 END) as ActivePromotions
FROM Accommodations
UNION ALL
SELECT 'Experiences' as TableName, 
       COUNT(*) as TotalRecords,
       SUM(CASE WHEN promotion_percent > 0 THEN 1 ELSE 0 END) as ActivePromotions
FROM Experiences;

PRINT '===================================';
PRINT 'HOÀN THÀNH CLEANUP PROMOTION DATA';
PRINT '==================================='; 
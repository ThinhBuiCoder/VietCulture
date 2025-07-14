-- Cập nhật bảng Complaints để thêm các trường cần thiết cho admin
USE TravelerDB;
GO

-- Thêm các cột mới vào bảng Complaints
ALTER TABLE Complaints ADD resolution NVARCHAR(MAX) NULL;
ALTER TABLE Complaints ADD assignedAdminId INT NULL;
ALTER TABLE Complaints ADD updatedAt DATETIME NULL;

-- Thêm foreign key cho assignedAdminId
ALTER TABLE Complaints ADD CONSTRAINT FK_Complaints_AssignedAdmin 
FOREIGN KEY (assignedAdminId) REFERENCES Users(userId);

-- Thêm index cho các trường thường query
CREATE INDEX IX_Complaints_Status ON Complaints(status);
CREATE INDEX IX_Complaints_CreatedAt ON Complaints(createdAt DESC);
CREATE INDEX IX_Complaints_AssignedAdminId ON Complaints(assignedAdminId);
CREATE INDEX IX_Complaints_UserId ON Complaints(userId);

-- Cập nhật dữ liệu mẫu cho complaints
INSERT INTO Complaints (userId, relatedBookingId, complaintText, status, createdAt, resolution, assignedAdminId) VALUES
(2, 1, N'Tôi đã đặt tour khám phá Sapa nhưng host không liên lạc được. Đã gọi điện và gửi tin nhắn nhiều lần nhưng không có phản hồi. Rất thất vọng với dịch vụ này.', 'OPEN', GETDATE(), NULL, NULL),
(3, 2, N'Chất lượng dịch vụ không như quảng cáo. Phòng ốc bẩn, thiết bị cũ kỹ. Không xứng đáng với số tiền đã trả.', 'IN_PROGRESS', DATEADD(day, -2, GETDATE()), N'Đang liên hệ với host để giải quyết vấn đề', 1),
(4, 3, N'Host hủy tour đột ngột chỉ 1 ngày trước khi đi mà không có lý do chính đáng. Điều này làm ảnh hưởng đến kế hoạch du lịch của tôi.', 'RESOLVED', DATEADD(day, -5, GETDATE()), N'Đã hoàn tiền 100% và bồi thường thêm 20% giá trị tour', 1),
(5, 4, N'Thông tin tour không chính xác. Thời gian và địa điểm khác với mô tả ban đầu. Cảm thấy bị lừa dối.', 'CLOSED', DATEADD(day, -10, GETDATE()), N'Đã giải quyết bằng cách điều chỉnh lịch trình và bồi thường', 1),
(6, 5, N'Khẩn cấp: Tôi đang ở trong tình huống nguy hiểm tại địa điểm tour. Cần hỗ trợ ngay lập tức!', 'OPEN', GETDATE(), NULL, NULL),
(7, 6, N'Dịch vụ ăn uống kém chất lượng, đồ ăn không đảm bảo vệ sinh. Có người trong đoàn bị đau bụng.', 'IN_PROGRESS', DATEADD(day, -1, GETDATE()), N'Đang điều tra và liên hệ với nhà hàng', 1),
(8, 7, N'Phương tiện di chuyển không an toàn, xe cũ và không có đai an toàn. Lo ngại về sự an toàn của khách hàng.', 'OPEN', DATEADD(day, -3, GETDATE()), NULL, NULL),
(9, 8, N'Host có thái độ không tốt, cư xử thiếu chuyên nghiệp và không tôn trọng khách hàng.', 'RESOLVED', DATEADD(day, -7, GETDATE()), N'Đã khiển trách host và yêu cầu cải thiện thái độ phục vụ', 1),
(10, 9, N'Thông tin liên lạc của host không chính xác, khó khăn trong việc liên lạc để xác nhận booking.', 'CLOSED', DATEADD(day, -15, GETDATE()), N'Đã cập nhật thông tin liên lạc và bồi thường cho khách hàng', 1),
(11, 10, N'Địa điểm tour không đẹp như trong ảnh, cảnh quan bị thay đổi do thi công. Cảm thấy bị lừa dối.', 'OPEN', DATEADD(day, -4, GETDATE()), NULL, NULL);

GO

-- Tạo view để dễ dàng query complaints với thông tin đầy đủ
CREATE VIEW ComplaintDetails AS
SELECT 
    c.complaintId,
    c.userId,
    c.relatedBookingId,
    c.complaintText,
    c.status,
    c.resolution,
    c.createdAt,
    c.resolvedAt,
    c.assignedAdminId,
    c.updatedAt,
    u.fullName as userName,
    u.email as userEmail,
    u.phone as userPhone,
    b.bookingDate,
    b.totalAmount,
    e.title as experienceTitle,
    a.name as accommodationName,
    admin.fullName as assignedAdminName,
    admin.email as assignedAdminEmail
FROM Complaints c
LEFT JOIN Users u ON c.userId = u.userId
LEFT JOIN Bookings b ON c.relatedBookingId = b.bookingId
LEFT JOIN Experiences e ON b.experienceId = e.experienceId
LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
LEFT JOIN Users admin ON c.assignedAdminId = admin.userId;

GO

-- Tạo stored procedure để lấy thống kê complaints
CREATE PROCEDURE GetComplaintStatistics
AS
BEGIN
    SELECT 
        status,
        COUNT(*) as count,
        CASE 
            WHEN status = 'OPEN' THEN 'Chờ xử lý'
            WHEN status = 'IN_PROGRESS' THEN 'Đang xử lý'
            WHEN status = 'RESOLVED' THEN 'Đã giải quyết'
            WHEN status = 'CLOSED' THEN 'Đã đóng'
            ELSE status
        END as displayStatus
    FROM Complaints 
    GROUP BY status
    ORDER BY 
        CASE status
            WHEN 'OPEN' THEN 1
            WHEN 'IN_PROGRESS' THEN 2
            WHEN 'RESOLVED' THEN 3
            WHEN 'CLOSED' THEN 4
            ELSE 5
        END;
END

GO

-- Tạo stored procedure để cập nhật complaint status
CREATE PROCEDURE UpdateComplaintStatus
    @complaintId INT,
    @status NVARCHAR(20),
    @resolution NVARCHAR(MAX) = NULL,
    @assignedAdminId INT = NULL
AS
BEGIN
    UPDATE Complaints 
    SET 
        status = @status,
        resolution = @resolution,
        resolvedAt = CASE WHEN @status IN ('RESOLVED', 'CLOSED') THEN GETDATE() ELSE resolvedAt END,
        assignedAdminId = @assignedAdminId,
        updatedAt = GETDATE()
    WHERE complaintId = @complaintId;
    
    SELECT @@ROWCOUNT as affectedRows;
END

GO

PRINT 'Đã cập nhật bảng Complaints thành công!'; 
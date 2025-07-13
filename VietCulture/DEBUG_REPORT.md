# Hướng dẫn Debug Report System

## Bước 1: Kiểm tra Database Connection

1. **Truy cập trang test database:**
   ```
   http://localhost:8080/VietCulture/view/jsp/db-test.jsp
   ```

2. **Kiểm tra kết quả:**
   - Database Connection phải là SUCCESS
   - Nếu FAILED, kiểm tra SQL Server có đang chạy không
   - Kiểm tra thông tin kết nối trong DBUtils.java

## Bước 2: Kiểm tra ReportDAO

1. **Truy cập trang debug:**
   ```
   http://localhost:8080/VietCulture/view/jsp/debug-report.jsp
   ```

2. **Thực hiện từng test:**
   - Step 1: Database Connection
   - Step 2: ReportDAO Test
   - Step 3: Manual Insert Test
   - Step 4: Session Test
   - Step 5: Form Test

## Bước 3: Kiểm tra SQL Server

1. **Chạy script SQL:**
   ```sql
   USE TravelerDB;
   
   -- Kiểm tra bảng Reports
   SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reports';
   
   -- Kiểm tra cấu trúc
   SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_NAME = 'Reports';
   
   -- Kiểm tra dữ liệu
   SELECT TOP 10 * FROM Reports ORDER BY reportId DESC;
   ```

## Bước 4: Test Report từ Experience Detail

1. **Đăng nhập vào hệ thống**
2. **Truy cập trang chi tiết trải nghiệm**
3. **Bấm nút "Báo cáo"**
4. **Điền form và gửi**
5. **Kiểm tra log server**

## Bước 5: Kiểm tra Log Server

Khi gửi báo cáo, phải thấy các log sau:
```
=== REPORT SERVLET STARTED ===
=== REPORT DAO STARTED ===
Database connection: SUCCESS
=== REPORT INSERTED SUCCESSFULLY ===
```

## Các lỗi thường gặp:

### 1. Database Connection Failed
- **Nguyên nhân:** SQL Server không chạy
- **Giải pháp:** Khởi động SQL Server

### 2. Table Reports not found
- **Nguyên nhân:** Bảng chưa được tạo
- **Giải pháp:** Chạy script tạo bảng

### 3. User not authenticated
- **Nguyên nhân:** Chưa đăng nhập
- **Giải pháp:** Đăng nhập trước khi báo cáo

### 4. Missing parameters
- **Nguyên nhân:** Form không gửi đủ dữ liệu
- **Giải pháp:** Kiểm tra JavaScript

## Script tạo bảng Reports (nếu cần):

```sql
USE TravelerDB;

CREATE TABLE Reports (
    reportId INT IDENTITY(1,1) PRIMARY KEY,
    contentType VARCHAR(50) NOT NULL,
    contentId INT NOT NULL,
    reporterId INT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    description TEXT,
    createdAt DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'PENDING'
);
```

## Kiểm tra cuối cùng:

Sau khi hoàn thành tất cả test, truy cập:
```
http://localhost:8080/VietCulture/view/jsp/test-report.jsp
```

Nếu tất cả test đều SUCCESS, hệ thống báo cáo đã hoạt động. 
# Hệ thống Quản lý Khiếu nại - Admin VietCulture

## Tổng quan

Hệ thống quản lý khiếu nại cho phép admin xử lý các khiếu nại từ khách hàng một cách hiệu quả và có tổ chức. Hệ thống bao gồm các tính năng:

- Xem danh sách khiếu nại với bộ lọc theo trạng thái
- Xem chi tiết khiếu nại
- Cập nhật trạng thái khiếu nại
- Phân công admin xử lý
- Thống kê khiếu nại theo trạng thái
- Tìm kiếm khiếu nại

## Cấu trúc Database

### Bảng Complaints

```sql
CREATE TABLE Complaints (
    complaintId INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    relatedBookingId INT NULL,
    complaintText NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')) DEFAULT 'OPEN',
    resolution NVARCHAR(MAX) NULL,
    createdAt DATE NOT NULL DEFAULT GETDATE(),
    resolvedAt DATE NULL,
    assignedAdminId INT NULL,
    updatedAt DATETIME NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (relatedBookingId) REFERENCES Bookings(bookingId),
    FOREIGN KEY (assignedAdminId) REFERENCES Users(userId)
);
```

### Trạng thái khiếu nại

- **OPEN**: Chờ xử lý
- **IN_PROGRESS**: Đang xử lý
- **RESOLVED**: Đã giải quyết
- **CLOSED**: Đã đóng

## Các file chính

### 1. Model
- `src/java/model/Complaint.java` - Model đại diện cho khiếu nại

### 2. DAO
- `src/java/dao/ComplaintDAO.java` - Data Access Object cho khiếu nại

### 3. Controller
- `src/java/controller/AdminComplaintServlet.java` - Servlet xử lý quản lý khiếu nại

### 4. View
- `web/view/jsp/admin/complaints/complaint-list.jsp` - Trang danh sách khiếu nại
- `web/view/jsp/admin/complaints/complaint-detail.jsp` - Trang chi tiết khiếu nại

## Cách sử dụng

### 1. Truy cập hệ thống

Đăng nhập với tài khoản admin và truy cập:
```
http://localhost:8080/VietCulture/admin/complaints
```

### 2. Xem danh sách khiếu nại

Trang danh sách hiển thị:
- Thống kê theo trạng thái
- Bộ lọc theo trạng thái
- Tìm kiếm theo tên khách hàng hoặc nội dung
- Danh sách khiếu nại với thông tin cơ bản

### 3. Xem chi tiết khiếu nại

Click vào nút "Chi tiết" hoặc truy cập:
```
http://localhost:8080/VietCulture/admin/complaints/{complaintId}
```

Trang chi tiết hiển thị:
- Thông tin đầy đủ về khiếu nại
- Lịch sử xử lý
- Thông tin khách hàng
- Thông tin booking (nếu có)
- Các hành động có thể thực hiện

### 4. Các hành động có thể thực hiện

#### Nhận xử lý khiếu nại
- Chỉ áp dụng cho khiếu nại có trạng thái "OPEN"
- Chuyển trạng thái thành "IN_PROGRESS"
- Gán admin hiện tại làm người xử lý

#### Giải quyết khiếu nại
- Chỉ áp dụng cho khiếu nại có trạng thái "IN_PROGRESS"
- Yêu cầu nhập giải pháp
- Chuyển trạng thái thành "RESOLVED"

#### Đóng khiếu nại
- Áp dụng cho khiếu nại chưa đóng
- Chuyển trạng thái thành "CLOSED"

#### Xóa khiếu nại
- Xóa vĩnh viễn khiếu nại khỏi hệ thống
- Hành động không thể hoàn tác

## Tính năng đặc biệt

### 1. Phân loại ưu tiên
Hệ thống tự động phân loại ưu tiên dựa trên từ khóa trong nội dung:
- **Cao**: Chứa từ "khẩn cấp", "urgent", "gấp"
- **Trung bình**: Chứa từ "quan trọng", "important"
- **Thấp**: Các trường hợp còn lại

### 2. Tự động làm mới
- Khiếu nại khẩn cấp sẽ tự động làm mới trang mỗi 30 giây
- Hiển thị badge nhấp nháy cho khiếu nại khẩn cấp

### 3. Thống kê real-time
- Hiển thị số lượng khiếu nại theo từng trạng thái
- Cập nhật badge số lượng khiếu nại mới trên sidebar

## API Endpoints

### GET /admin/complaints
- Hiển thị danh sách khiếu nại
- Parameters: `status`, `search`

### GET /admin/complaints/{id}
- Hiển thị chi tiết khiếu nại

### POST /admin/complaints
- Xử lý các hành động
- Parameters: `action`, `complaintId`, `status`, `resolution`

### GET /admin/complaints?action=api&apiAction=statistics
- Trả về thống kê khiếu nại theo trạng thái

### GET /admin/complaints?action=api&apiAction=count
- Trả về số lượng khiếu nại mới

## Cài đặt và triển khai

### 1. Cập nhật database
Chạy script SQL trong file `update_complaints_table.sql` để cập nhật bảng Complaints.

### 2. Build project
```bash
ant build
```

### 3. Deploy
```bash
ant deploy
```

## Lưu ý bảo mật

1. Chỉ admin mới có quyền truy cập hệ thống khiếu nại
2. Tất cả các request đều được kiểm tra quyền truy cập
3. Log đầy đủ các hành động của admin
4. Dữ liệu nhạy cảm được mã hóa

## Troubleshooting

### Lỗi thường gặp

1. **Không hiển thị khiếu nại**
   - Kiểm tra kết nối database
   - Kiểm tra quyền truy cập bảng Complaints

2. **Không thể cập nhật trạng thái**
   - Kiểm tra quyền admin
   - Kiểm tra ID khiếu nại có tồn tại

3. **Lỗi JSON response**
   - Kiểm tra encoding UTF-8
   - Kiểm tra format JSON

### Log files
- Kiểm tra log trong `logs/` directory
- Log level: SEVERE cho lỗi database, WARNING cho lỗi validation

## Tương lai

Các tính năng có thể phát triển thêm:
- Email notification cho khách hàng
- Template giải pháp
- Báo cáo chi tiết
- Tích hợp với hệ thống chat
- Mobile app cho admin 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        h2 {
            color: #e74c3c;
            margin-bottom: 20px;
        }
        .order-details {
            background-color: #fadbd8;
            padding: 20px;
            border-radius: 8px;
            margin: 30px 0;
            text-align: left;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-retry {
            background-color: #e74c3c;
        }
        .btn-retry:hover {
            background-color: #c0392b;
        }
        .reasons {
            background-color: #fff3cd;
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-icon">❌</div>
        <h2>Thanh toán không thành công</h2>
        <p style="font-size: 18px; color: #2c3e50;">
            Rất tiếc, quá trình thanh toán của bạn đã bị hủy hoặc gặp lỗi.
        </p>

        <% 
            String bookingId = request.getParameter("bookingId");
            if (bookingId != null) {
        %>
        <div class="order-details">
            <h3>📋 Thông tin đơn hàng</h3>
            <p><strong>Mã đơn hàng:</strong> #<%= bookingId %></p>
            <p><strong>Trạng thái:</strong> <span style="color: #e74c3c;">Chưa thanh toán</span></p>
            <p><strong>Thời gian:</strong> <%= new java.util.Date() %></p>
        </div>
        <% } %>

        <div class="reasons">
            <h3>🤔 Nguyên nhân có thể:</h3>
            <ul>
                <li>Bạn đã hủy giao dịch</li>
                <li>Thông tin thẻ không chính xác</li>
                <li>Tài khoản không đủ số dư</li>
                <li>Lỗi kết nối mạng</li>
                <li>Phiên thanh toán đã hết hạn</li>
            </ul>
        </div>

        <div style="margin-top: 30px;">
            <a href="BookingServlet" class="btn btn-retry">🔄 Thử lại</a>
            <a href="BookingServlet" class="btn">🏠 Về trang chủ</a>
            <a href="tel:1900xxxx" class="btn">📞 Gọi hỗ trợ</a>
        </div>

        <div style="margin-top: 30px; padding: 20px; background-color: #e8f4fd; border-radius: 8px;">
            <h3>📞 Cần hỗ trợ?</h3>
            <p>Liên hệ với chúng tôi:</p>
            <ul style="text-align: left;">
                <li><strong>Hotline:</strong> 1900-xxxx</li>
                <li><strong>Email:</strong> support@example.com</li>
                <li><strong>Giờ làm việc:</strong> 8:00 - 22:00 hàng ngày</li>
            </ul>
        </div>
    </div>
</body>
</html>
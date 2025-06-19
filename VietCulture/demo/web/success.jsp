<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công</title>
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
        .success-icon {
            font-size: 80px;
            color: #27ae60;
            margin-bottom: 20px;
        }
        h2 {
            color: #27ae60;
            margin-bottom: 20px;
        }
        .order-details {
            background-color: #d5f4e6;
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
        .next-steps {
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
        <div class="success-icon">✅</div>
        <h2>Thanh toán thành công!</h2>
        <p style="font-size: 18px; color: #2c3e50;">
            Cảm ơn bạn đã đặt tour. Đơn hàng của bạn đã được xác nhận và đang được xử lý.
        </p>

        <% 
            String bookingId = request.getParameter("bookingId");
            if (bookingId != null) {
        %>
        <div class="order-details">
            <h3>📋 Thông tin đơn hàng</h3>
            <p><strong>Mã đơn hàng:</strong> #<%= bookingId %></p>
            <p><strong>Trạng thái:</strong> <span style="color: #27ae60;">Đã thanh toán</span></p>
            <p><strong>Thời gian:</strong> <%= new java.util.Date() %></p>
        </div>
        <% } %>

        <div class="next-steps">
            <h3>🎯 Các bước tiếp theo:</h3>
            <ol>
                <li>Chúng tôi sẽ gửi email xác nhận đến địa chỉ của bạn trong 5-10 phút</li>
                <li>Nhân viên sẽ liên hệ với bạn trong vòng 24h để xác nhận lịch trình</li>
                <li>Vui lòng mang theo CCCD và email xác nhận khi tham gia tour</li>
                <li>Nếu có thắc mắc, liên hệ hotline: <strong>1900-xxxx</strong></li>
            </ol>
        </div>

        <div style="margin-top: 30px;">
            <a href="BookingServlet" class="btn">🏠 Về trang chủ</a>
            <a href="mailto:support@example.com" class="btn">📧 Liên hệ hỗ trợ</a>
        </div>
    </div>
</body>
</html>
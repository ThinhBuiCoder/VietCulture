<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán đơn hàng</title>
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
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                text-align: center;
            }
            h2 {
                color: #2c3e50;
                margin-bottom: 30px;
            }
            .order-info {
                background-color: #ecf0f1;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                text-align: left;
            }
            .order-info h3 {
                margin-top: 0;
                color: #34495e;
            }
            .order-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding-bottom: 5px;
                border-bottom: 1px solid #bdc3c7;
            }
            .order-row:last-child {
                border-bottom: none;
                font-weight: bold;
                font-size: 18px;
                color: #e74c3c;
            }
            .payment-options {
                margin: 30px 0;
            }
            .payment-btn {
                display: inline-block;
                padding: 15px 30px;
                background-color: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: bold;
                margin: 10px;
                transition: background-color 0.3s;
            }
            .payment-btn:hover {
                background-color: #2980b9;
            }
            .qr-section {
                margin: 30px 0;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 8px;
            }
            .qr-code {
                margin: 20px 0;
            }
            .note {
                background-color: #fff3cd;
                border: 1px solid #ffeaa7;
                padding: 15px;
                border-radius: 5px;
                margin-top: 20px;
                text-align: left;
            }
            .status-check {
                margin-top: 30px;
                padding: 15px;
                background-color: #d4edda;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>💳 Thanh toán đơn hàng</h2>

            <div class="order-info">
                <h3>📋 Thông tin đơn hàng</h3>
                <div class="order-row">
                    <span>Mã đơn hàng:</span>
                    <span><strong>#${bookingID}</strong></span>
                </div>
                <div class="order-row">
                    <span>Khách hàng:</span>
                    <span>${customerName}</span>
                </div>
                <div class="order-row">
                    <span>Tour:</span>
                    <span>${tourName}</span>
                </div>
                <div class="order-row">
                    <span>Tổng tiền:</span>
                    <span>${amount} VND</span>
                </div>
            </div>

            <div class="payment-options">
                <h3>🚀 Chọn phương thức thanh toán:</h3>
                <a href="${paymentUrl}" target="_blank" class="payment-btn">
                    💻 Thanh toán trực tuyến
                </a>
            </div>

            <div class="qr-section">
                <h3>📱 Hoặc quét mã QR:</h3>
                <div class="qr-code">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?data=${paymentUrl}&size=200x200" 
                         alt="QR code thanh toán" 
                         style="border: 2px solid #ddd; border-radius: 8px;" />
                </div>
                <p>Sử dụng ứng dụng ngân hàng hoặc ví điện tử để quét mã QR</p>
            </div>

            <div class="note">
                <h4>📝 Lưu ý quan trọng:</h4>
                <ul>
                    <li>Sau khi thanh toán thành công, hệ thống sẽ tự động cập nhật trạng thái đơn hàng</li>
                    <li>Bạn sẽ được chuyển hướng đến trang xác nhận</li>
                    <li>Nếu có vấn đề, vui lòng liên hệ hotline: <strong>1900-xxxx</strong></li>
                    <li>Thời gian thanh toán: trong vòng 15 phút</li>
                </ul>
            </div>

            <div class="status-check">
                <p><strong>✅ Đang chờ thanh toán...</strong></p>
                <p>Trang này sẽ tự động cập nhật khi thanh toán hoàn tất</p>
            </div>
        </div>

        <script>
            // Auto refresh để check trạng thái thanh toán (tùy chọn)
            setTimeout(function () {
                // Có thể thêm AJAX call để check status
                console.log('Checking payment status...');
            }, 5000);
        </script>
    </body>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán đơn hàng</title>
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
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h2 {
            color: #2c3e50;
            margin-bottom: 30px;
        }
        .order-info {
            background-color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: left;
        }
        .order-info h3 {
            margin-top: 0;
            color: #34495e;
        }
        .order-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid #bdc3c7;
        }
        .order-row:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 18px;
            color: #e74c3c;
        }
        .payment-options {
            margin: 30px 0;
        }
        .payment-btn {
            display: inline-block;
            padding: 15px 30px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            margin: 10px;
            transition: background-color 0.3s;
        }
        .payment-btn:hover {
            background-color: #2980b9;
        }
        .qr-section {
            margin: 30px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .qr-code {
            margin: 20px 0;
        }
        .note {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            text-align: left;
        }
        .status-check {
            margin-top: 30px;
            padding: 15px;
            background-color: #d4edda;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>💳 Thanh toán đơn hàng</h2>

        <div class="order-info">
            <h3>📋 Thông tin đơn hàng</h3>
            <div class="order-row">
                <span>Mã đơn hàng:</span>
                <span><strong>#${bookingID}</strong></span>
            </div>
            <div class="order-row">
                <span>Khách hàng:</span>
                <span>${customerName}</span>
            </div>
            <div class="order-row">
                <span>Tour:</span>
                <span>${tourName}</span>
            </div>
            <div class="order-row">
                <span>Tổng tiền:</span>
                <span>${amount} VND</span>
            </div>
        </div>

        <div class="payment-options">
            <h3>🚀 Chọn phương thức thanh toán:</h3>
            <a href="${paymentUrl}" target="_blank" class="payment-btn">
                💻 Thanh toán trực tuyến
            </a>
        </div>

        <div class="qr-section">
            <h3>📱 Hoặc quét mã QR:</h3>
            <div class="qr-code">
                <img src="https://api.qrserver.com/v1/create-qr-code/?data=${paymentUrl}&size=200x200" 
                     alt="QR code thanh toán" 
                     style="border: 2px solid #ddd; border-radius: 8px;" />
            </div>
            <p>Sử dụng ứng dụng ngân hàng hoặc ví điện tử để quét mã QR</p>
        </div>

        <div class="note">
            <h4>📝 Lưu ý quan trọng:</h4>
            <ul>
                <li>Sau khi thanh toán thành công, hệ thống sẽ tự động cập nhật trạng thái đơn hàng</li>
                <li>Bạn sẽ được chuyển hướng đến trang xác nhận</li>
                <li>Nếu có vấn đề, vui lòng liên hệ hotline: <strong>1900-xxxx</strong></li>
                <li>Thời gian thanh toán: trong vòng 15 phút</li>
            </ul>
        </div>

        <div class="status-check">
            <p><strong>✅ Đang chờ thanh toán...</strong></p>
            <p>Trang này sẽ tự động cập nhật khi thanh toán hoàn tất</p>
        </div>
    </div>

    <script>
        // Auto refresh để check trạng thái thanh toán (tùy chọn)
        setTimeout(function() {
            // Có thể thêm AJAX call để check status
            console.log('Checking payment status...');
        }, 5000);
    </script>
</body>
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán PayOS | VietCulture</title>
    <meta name="description" content="Thanh toán an toàn và bảo mật với PayOS - VietCulture">
    
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --payos-color: #0166FF;
            --success-color: #4BB543;
            --warning-color: #FFC107;
            --danger-color: #DC3545;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-payos: linear-gradient(135deg, #0166FF, #2B7DFF);
            --gradient-bg: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: var(--dark-color);
            background: var(--gradient-bg);
            min-height: 100vh;
            padding-top: 80px;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
        }

        /* Navigation */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.3rem;
            color: white;
            text-decoration: none;
            transition: var(--transition);
        }

        .navbar-brand:hover {
            color: white;
            transform: translateY(-1px);
        }

        .navbar-brand img {
            height: 50px;
            width: auto;
            margin-right: 12px;
            border-radius: 8px;
        }

        /* Payment Header */
        .payment-header {
            background: var(--light-color);
            padding: 40px 0;
            margin-bottom: 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .payment-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-payos);
        }

        .payment-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .payment-subtitle {
            color: #6c757d;
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 25px;
        }

        /* Main Content */
        .main-content {
            padding: 40px 0;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 40px;
            align-items: start;
        }

        /* Payment Card */
        .payment-card {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow-md);
            margin-bottom: 30px;
            border: 1px solid rgba(0,0,0,0.05);
            transition: var(--transition);
        }

        .payment-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(0,0,0,0.1);
        }

        .section-title i {
            color: var(--payos-color);
            font-size: 1.3rem;
        }

        /* PayOS Branding */
        .payos-branding {
            text-align: center;
            margin-bottom: 30px;
            padding: 25px;
            background: var(--gradient-payos);
            border-radius: 15px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .payos-branding h3 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }

        .payos-subtitle {
            margin: 8px 0 0 0;
            opacity: 0.9;
            font-size: 0.95rem;
            position: relative;
            z-index: 1;
        }

        /* QR Code Section */
        .qr-section {
            text-align: center;
            padding: 30px;
            background: var(--light-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            margin: 25px 0;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .qr-header {
            margin-bottom: 25px;
        }

        .qr-header h5 {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 8px;
        }

        .qr-header p {
            color: #6c757d;
            margin: 0;
            font-size: 0.9rem;
        }

        .qr-container {
            width: 220px;
            height: 220px;
            margin: 0 auto 25px;
            border: 3px solid var(--payos-color);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

        .qr-container img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            padding: 10px;
        }

        .qr-placeholder {
            color: #6c757d;
            font-size: 0.9rem;
            text-align: center;
            padding: 20px;
        }

        .qr-error {
            color: var(--danger-color);
            font-size: 0.9rem;
            text-align: center;
            padding: 20px;
        }

        .qr-error i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }

        /* Payment Status */
        .payment-status {
            text-align: center;
            padding: 25px;
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.3);
            border-radius: 12px;
            margin: 25px 0;
            transition: var(--transition);
        }

        .payment-status.checking {
            background: rgba(1, 102, 255, 0.1);
            border-color: rgba(1, 102, 255, 0.3);
        }

        .payment-status.success {
            background: rgba(75, 181, 67, 0.1);
            border-color: var(--success-color);
        }

        .payment-status.failed {
            background: rgba(220, 53, 69, 0.1);
            border-color: rgba(220, 53, 69, 0.3);
        }

        .status-icon {
            width: 70px;
            height: 70px;
            background: var(--warning-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.8rem;
            position: relative;
            transition: var(--transition);
        }

        .status-icon.checking {
            background: var(--payos-color);
            animation: pulse 2s infinite;
        }

        .status-icon.success {
            background: var(--success-color);
        }

        .status-icon.failed {
            background: var(--danger-color);
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.05); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }

        .status-text {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .countdown {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--warning-color);
            margin: 10px 0;
            font-family: 'Courier New', Courier, monospace;
        }

        .countdown.expired {
            color: var(--danger-color);
        }

        /* Booking Summary */
        .booking-summary {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-md);
            margin-bottom: 25px;
            border: 1px solid rgba(0,0,0,0.05);
            position: sticky;
            top: 100px;
        }

        .summary-header {
            text-align: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(0,0,0,0.1);
        }

        .summary-header h5 {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 5px;
        }

        .booking-id {
            background: var(--gradient-primary);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 0.95rem;
            padding: 8px 0;
        }

        .summary-row .label {
            color: #6c757d;
            font-weight: 500;
        }

        .summary-row .value {
            font-weight: 600;
            text-align: right;
            color: var(--dark-color);
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
            font-size: 1.2rem;
            color: var(--dark-color);
            border-top: 2px solid rgba(0,0,0,0.1);
            padding-top: 15px;
            margin-top: 15px;
            background: rgba(255, 56, 92, 0.05);
            padding: 15px;
            border-radius: 8px;
            margin: 15px -10px 0 -10px;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            border-radius: 12px;
            padding: 14px 24px;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            position: relative;
            overflow: hidden;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            color: white;
        }

        .btn-payos {
            background: var(--gradient-payos);
            color: white;
            box-shadow: 0 4px 15px rgba(1, 102, 255, 0.3);
        }

        .btn-payos:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(1, 102, 255, 0.4);
            color: white;
        }

        .btn-outline-secondary {
            color: var(--dark-color);
            border: 2px solid rgba(0,0,0,0.2);
            background: transparent;
        }

        .btn-outline-secondary:hover {
            background: var(--dark-color);
            color: white;
            border-color: var(--dark-color);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Alerts */
        .alert {
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-warning {
            background-color: rgba(255, 193, 7, 0.1);
            border-color: rgba(255, 193, 7, 0.3);
            color: #856404;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            border-color: rgba(220, 53, 69, 0.3);
            color: #721c24;
        }

        .alert-success {
            background-color: rgba(75, 181, 67, 0.1);
            border-color: rgba(75, 181, 67, 0.3);
            color: #155724;
        }

        .alert-info {
            background-color: rgba(1, 102, 255, 0.1);
            border-color: rgba(1, 102, 255, 0.3);
            color: #004085;
        }

        /* Loading Spinner */
        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid var(--payos-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .content-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .booking-summary {
                position: relative;
                top: auto;
            }
        }

        @media (max-width: 768px) {
            body {
                padding-top: 70px;
            }
            
            .payment-title {
                font-size: 2rem;
            }

            .payment-card {
                padding: 20px;
                margin-bottom: 20px;
            }

            .qr-container {
                width: 180px;
                height: 180px;
            }

            .action-buttons {
                gap: 10px;
            }
            
            .btn {
                padding: 12px 20px;
                font-size: 0.9rem;
            }
        }

        /* Animation for smooth transitions */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
        </div>
    </nav>

    <!-- Payment Header -->
    <div class="payment-header">
        <div class="container">
            <h1 class="payment-title">Thanh toán an toàn với PayOS</h1>
            <p class="payment-subtitle">
                Hoàn tất thanh toán để xác nhận đặt chỗ của bạn. Hệ thống sẽ tự động xác minh thanh toán.
            </p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container main-content">
        <!-- Error Messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger fade-in">
                <i class="ri-error-warning-line"></i>
                <div>
                    <c:choose>
                        <c:when test="${param.error == 'payment_processing_error'}">
                            <strong>Lỗi xử lý thanh toán!</strong> Có lỗi xảy ra trong quá trình xử lý thanh toán. Vui lòng thử lại hoặc liên hệ hỗ trợ.
                        </c:when>
                        <c:when test="${param.error == 'invalid_payment'}">
                            <strong>Thanh toán không hợp lệ!</strong> Thông tin thanh toán không hợp lệ. Vui lòng kiểm tra lại.
                        </c:when>
                        <c:when test="${param.error == 'payment_not_completed'}">
                            <strong>Thanh toán chưa hoàn tất!</strong> Chúng tôi chưa nhận được xác nhận thanh toán. Vui lòng kiểm tra lại.
                        </c:when>
                        <c:when test="${param.error == 'verification_failed'}">
                            <strong>Lỗi xác minh!</strong> Không thể xác minh trạng thái thanh toán. Vui lòng liên hệ hỗ trợ.
                        </c:when>
                        <c:otherwise>
                            <strong>Có lỗi xảy ra!</strong> Vui lòng thử lại sau hoặc liên hệ hỗ trợ.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <div class="content-grid">
            <!-- Payment Methods Section -->
            <div>
                <!-- PayOS Branding -->
                <div class="payment-card fade-in">
                    <div class="payos-branding">
                        <h3>PayOS</h3>
                        <p class="payos-subtitle">Giải pháp thanh toán hiện đại và an toàn</p>
                    </div>
                    
                    <h3 class="section-title">
                        <i class="ri-bank-card-line"></i>
                        Quét mã QR để thanh toán
                    </h3>

                    <div class="alert alert-info">
                        <i class="ri-information-line"></i>
                        <div>
                            <strong>Hướng dẫn:</strong> Sử dụng ứng dụng MoMo, ZaloPay, Internet Banking hoặc ví điện tử để quét mã QR bên dưới.
                        </div>
                    </div>
                </div>

                <!-- QR Code Section -->
                <div class="qr-section fade-in">
                    <div class="qr-header">
                        <h5>Mã QR PayOS</h5>
                        <p>Quét mã để hoàn tất thanh toán</p>
                    </div>
                    
                    <div class="qr-container" id="qrContainer">
                        <c:choose>
                            <c:when test="${not empty paymentResponse.qrCode}">
                                <img src="${paymentResponse.qrCode}" alt="PayOS QR Code" id="qrCodeImage">
                            </c:when>
                            <c:otherwise>
                                <div class="qr-error">
                                    <i class="ri-error-warning-line"></i>
                                    <p>Không thể tải mã QR từ PayOS</p>
                                    <button onclick="location.reload()" class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="ri-refresh-line me-1"></i>Thử lại
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div style="background: rgba(1, 102, 255, 0.05); border: 1px solid rgba(1, 102, 255, 0.2); border-radius: 12px; padding: 20px; margin-top: 20px;">
                        <h6 style="color: var(--payos-color); margin-bottom: 15px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                            <i class="ri-information-line"></i>
                            Hướng dẫn thanh toán
                        </h6>
                        
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px; font-size: 0.9rem; text-align: left;">
                            <div style="min-width: 28px; height: 28px; background: var(--payos-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; flex-shrink: 0;">1</div>
                            <span>Mở ứng dụng MoMo, ZaloPay, Internet Banking hoặc ví điện tử</span>
                        </div>
                        
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px; font-size: 0.9rem; text-align: left;">
                            <div style="min-width: 28px; height: 28px; background: var(--payos-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; flex-shrink: 0;">2</div>
                            <span>Chọn chức năng "Quét mã QR" trong ứng dụng</span>
                        </div>
                        
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px; font-size: 0.9rem; text-align: left;">
                            <div style="min-width: 28px; height: 28px; background: var(--payos-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; flex-shrink: 0;">3</div>
                            <span>Quét mã QR hiển thị ở trên</span>
                        </div>
                        
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px; font-size: 0.9rem; text-align: left;">
                            <div style="min-width: 28px; height: 28px; background: var(--payos-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; flex-shrink: 0;">4</div>
                            <span>Kiểm tra thông tin và xác nhận thanh toán</span>
                        </div>
                        
                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 0; font-size: 0.9rem; text-align: left;">
                            <div style="min-width: 28px; height: 28px; background: var(--payos-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; flex-shrink: 0;">5</div>
                            <span>Hệ thống sẽ tự động xác minh và hoàn tất đặt chỗ</span>
                        </div>
                    </div>
                </div>

                <!-- Payment Status -->
                <div class="payment-status" id="paymentStatus">
                    <div class="status-icon" id="statusIcon">
                        <i class="ri-time-line" id="statusIconText"></i>
                    </div>
                    <div class="status-text" id="statusText">Đang chờ thanh toán</div>
                    <div class="countdown" id="countdown">14:59</div>
                    <small class="text-muted">Mã QR sẽ hết hạn sau thời gian trên</small>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-outline-secondary" onclick="goBack()">
                        <i class="ri-arrow-left-line me-2"></i>Quay Lại
                    </button>
                    
                    <button type="button" class="btn btn-payos" id="checkPaymentBtn" onclick="checkPaymentStatus()">
                        <i class="ri-refresh-line me-2"></i>Kiểm Tra Thanh Toán
                    </button>
                    
                    <form id="verifyPaymentForm" action="${pageContext.request.contextPath}/booking" method="post" style="display: none;">
                        <input type="hidden" name="action" value="verify-payment">
                        <button type="submit" class="btn btn-primary" id="verifyBtn">
                            <i class="ri-check-double-line me-2"></i>Xác Nhận Hoàn Tất
                        </button>
                    </form>

                    <!-- Debug Link (Remove in production) -->
                    <a href="${pageContext.request.contextPath}/test-payos" class="btn btn-outline-secondary" style="font-size: 0.8rem;">
                        <i class="ri-bug-line me-2"></i>Debug PayOS
                    </a>
                </div>
            </div>

            <!-- Booking Summary Sidebar -->
            <div>
                <!-- Booking Summary -->
                <div class="booking-summary fade-in">
                    <div class="summary-header">
                        <h5>Thông tin đặt chỗ</h5>
                        <div class="booking-id">#${booking.bookingId}</div>
                    </div>

                    <div class="summary-row">
                        <span class="label">Dịch vụ:</span>
                        <span class="value">
                            <c:choose>
                                <c:when test="${bookingType == 'experience'}">
                                    ${fn:substring(experience.title, 0, 25)}<c:if test="${fn:length(experience.title) > 25}">...</c:if>
                                </c:when>
                                <c:otherwise>
                                    Dịch vụ lưu trú
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span class="label">Ngày:</span>
                        <span class="value">
                            <fmt:formatDate value="${formData.bookingDate}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>

                    <div class="summary-row">
                        <span class="label">Thời gian:</span>
                        <span class="value">${formData.timeSlotDisplayName}</span>
                    </div>

                    <div class="summary-row">
                        <span class="label">Số người:</span>
                        <span class="value">${formData.numberOfPeople} người</span>
                    </div>

                    <div class="summary-row">
                        <span class="label">Giá cơ bản:</span>
                        <span class="value">
                            <fmt:formatNumber value="${formData.totalPrice - (formData.totalPrice * 0.05)}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                        </span>
                    </div>

                    <div class="summary-row">
                        <span class="label">Phí dịch vụ (5%):</span>
                        <span class="value">
                            <fmt:formatNumber value="${formData.totalPrice * 0.05}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                        </span>
                    </div>

                    <div class="summary-total">
                        <span>Tổng thanh toán:</span>
                        <span>
                            <fmt:formatNumber value="${formData.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script>
        // Configuration
        const CONFIG = {
            ORDER_CODE: ${paymentResponse.orderCode || 0},
            CHECK_INTERVAL: 10000, // 10 seconds
            COUNTDOWN_DURATION: 15 * 60, // 15 minutes
            AUTO_VERIFY_DELAY: 2000 // 2 seconds after payment detected
        };

        // State management
        let paymentCheckInterval;
        let countdownInterval;
        let timeLeft = CONFIG.COUNTDOWN_DURATION;
        let isPaymentCompleted = false;

        // DOM elements
        const elements = {
            qrContainer: document.getElementById('qrContainer'),
            paymentStatus: document.getElementById('paymentStatus'),
            statusIcon: document.getElementById('statusIcon'),
            statusIconText: document.getElementById('statusIconText'),
            statusText: document.getElementById('statusText'),
            countdown: document.getElementById('countdown'),
            checkPaymentBtn: document.getElementById('checkPaymentBtn'),
            verifyPaymentForm: document.getElementById('verifyPaymentForm'),
            verifyBtn: document.getElementById('verifyBtn')
        };

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            initializeCountdown();
            startPaymentMonitoring();
            validateQRCode();
        });

        // Validate QR Code
        function validateQRCode() {
            const qrImage = document.getElementById('qrCodeImage');
            if (qrImage) {
                const qrSrc = qrImage.src;
                if (qrSrc.includes('MOCK') || qrSrc.includes('mock')) {
                    showAlert('warning', '⚠️ Đang sử dụng QR Code giả mạo (Mock Mode). Vui lòng tắt Mock Mode để có QR thật.');
                } else if (qrSrc.startsWith('data:image/') || qrSrc.startsWith('http')) {
                    console.log('✅ Real PayOS QR Code detected');
                } else {
                    showAlert('error', '❌ QR Code không hợp lệ');
                }
            }
        }

        // Initialize countdown timer
        function initializeCountdown() {
            countdownInterval = setInterval(() => {
                updateCountdown();
            }, 1000);
        }

        // Update countdown display
        function updateCountdown() {
            if (timeLeft <= 0) {
                clearInterval(countdownInterval);
                handlePaymentExpired();
                return;
            }

            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            
            elements.countdown.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft <= 300) { // 5 minutes
                elements.countdown.style.color = 'var(--danger-color)';
                elements.countdown.classList.add('expired');
            }
            
            timeLeft--;
        }

        // Handle payment expiration
        function handlePaymentExpired() {
            elements.countdown.textContent = 'Hết hạn';
            elements.countdown.classList.add('expired');
            
            updatePaymentStatus('expired', 'Thanh toán đã hết hạn', 'ri-time-line');
            
            stopPaymentMonitoring();
            elements.checkPaymentBtn.disabled = true;
            elements.checkPaymentBtn.innerHTML = '<i class="ri-time-line me-2"></i>Đã Hết Hạn';
            
            showAlert('warning', 'Phiên thanh toán đã hết hạn. Vui lòng tạo đơn hàng mới.');
        }

        // Start automatic payment monitoring
        function startPaymentMonitoring() {
            setTimeout(() => {
                checkPaymentStatus(true);
            }, 5000);

            paymentCheckInterval = setInterval(() => {
                checkPaymentStatus(true);
            }, CONFIG.CHECK_INTERVAL);
        }

        // Stop payment monitoring
        function stopPaymentMonitoring() {
            if (paymentCheckInterval) {
                clearInterval(paymentCheckInterval);
                paymentCheckInterval = null;
            }
        }

        // Check payment status
        async function checkPaymentStatus(isAutoCheck = false) {
            if (isPaymentCompleted || CONFIG.ORDER_CODE === 0) return;

            const btn = elements.checkPaymentBtn;
            const originalText = btn.innerHTML;
            
            if (!isAutoCheck) {
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang kiểm tra...';
                btn.disabled = true;
            }

            try {
                const response = await fetch('${pageContext.request.contextPath}/api/payment/status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        orderCode: CONFIG.ORDER_CODE
                    })
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const data = await response.json();
                
                if (data.success) {
                    handlePaymentStatusResponse(data.data);
                } else {
                    throw new Error(data.message || 'Unknown error');
                }
            } catch (error) {
                console.error('Payment status check failed:', error);
                if (!isAutoCheck) {
                    showAlert('warning', 'Không thể kiểm tra trạng thái thanh toán. Vui lòng thử lại sau.');
                }
            } finally {
                if (!isAutoCheck) {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }
            }
        }

        // Handle payment status response
        function handlePaymentStatusResponse(data) {
            if (data.status === 'PAID' || data.status === 'COMPLETED') {
                handlePaymentSuccess();
            } else if (data.status === 'CANCELLED') {
                handlePaymentCancelled();
            } else if (data.status === 'EXPIRED') {
                handlePaymentExpired();
            } else {
                updatePaymentStatus('checking', 'Đang xử lý thanh toán...', 'ri-time-line');
            }
        }

        // Handle successful payment
        function handlePaymentSuccess() {
            if (isPaymentCompleted) return;
            
            isPaymentCompleted = true;
            stopPaymentMonitoring();
            clearInterval(countdownInterval);

            updatePaymentStatus('success', 'Thanh toán thành công!', 'ri-check-double-line');
            
            elements.verifyPaymentForm.style.display = 'block';
            elements.checkPaymentBtn.style.display = 'none';
            
            showAlert('success', 'Thanh toán thành công! Đang tự động xác minh...');
            
            setTimeout(() => {
                if (elements.verifyBtn && !elements.verifyBtn.disabled) {
                    elements.verifyBtn.click();
                }
            }, CONFIG.AUTO_VERIFY_DELAY);
        }

        // Handle cancelled payment
        function handlePaymentCancelled() {
            updatePaymentStatus('failed', 'Thanh toán đã bị hủy', 'ri-close-circle-line');
            showAlert('warning', 'Thanh toán đã bị hủy. Bạn có thể thử thanh toán lại.');
        }

        // Update payment status display
        function updatePaymentStatus(type, text, icon) {
            elements.paymentStatus.className = `payment-status ${type}`;
            elements.statusIcon.className = `status-icon ${type}`;
            elements.statusIconText.className = icon;
            elements.statusText.textContent = text;
        }

        // Show alert
        function showAlert(type, message) {
            const alertContainer = document.createElement('div');
            alertContainer.className = `alert alert-${type} fade-in`;
            alertContainer.innerHTML = `
                <i class="ri-information-line"></i>
                <div>${message}</div>
            `;
            document.querySelector('.main-content').insertBefore(alertContainer, document.querySelector('.content-grid'));
            
            setTimeout(() => {
                alertContainer.style.opacity = '0';
                setTimeout(() => alertContainer.remove(), 300);
            }, 5000);
        }

        // Go back function
        function goBack() {
            if (confirm('Bạn có chắc muốn quay lại? Quá trình thanh toán sẽ bị hủy.')) {
                let redirectUrl = '${pageContext.request.contextPath}/booking/confirm';
                <c:if test="${not empty formData.experienceId}">
                    redirectUrl += '?experienceId=${formData.experienceId}';
                </c:if>
                <c:if test="${not empty formData.accommodationId}">
                    redirectUrl += '?accommodationId=${formData.accommodationId}';
                </c:if>
                window.location.href = redirectUrl;
            }
        }

        // Form submission handling
        if (elements.verifyPaymentForm) {
            elements.verifyPaymentForm.addEventListener('submit', function(e) {
                const btn = elements.verifyBtn;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
                btn.disabled = true;
                
                stopPaymentMonitoring();
                clearInterval(countdownInterval);
            });
        }

        // Prevent accidental page refresh
        window.addEventListener('beforeunload', function(e) {
            if (!isPaymentCompleted && timeLeft > 0) {
                e.preventDefault();
                e.returnValue = 'Bạn có chắc muốn rời khỏi trang này? Quá trình thanh toán có thể bị gián đoạn.';
            }
        });

        // Handle visibility change
        document.addEventListener('visibilitychange', function() {
            if (!document.hidden && !isPaymentCompleted) {
                setTimeout(() => {
                    checkPaymentStatus(true);
                }, 1000);
            }
        });

        // Auto-scroll to top on load
        window.addEventListener('load', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });

        // Error handling
        window.addEventListener('error', function(e) {
            console.error('JavaScript error:', e.error);
            showAlert('danger', 'Có lỗi xảy ra. Vui lòng tải lại trang.');
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'r' && !isPaymentCompleted) {
                e.preventDefault();
                checkPaymentStatus();
            }
            
            if (e.key === 'Escape') {
                goBack();
            }
        });

        // QR Code error handling
        document.addEventListener('DOMContentLoaded', function() {
            const qrImage = document.getElementById('qrCodeImage');
            if (qrImage) {
                qrImage.addEventListener('error', function() {
                    const container = this.parentElement;
                    container.innerHTML = `
                        <div class="qr-error">
                            <i class="ri-error-warning-line"></i>
                            <p>Không thể tải mã QR</p>
                            <button onclick="location.reload()" class="btn btn-sm btn-outline-primary mt-2">
                                <i class="ri-refresh-line me-1"></i>Thử lại
                            </button>
                        </div>
                    `;
                });

                qrImage.addEventListener('load', function() {
                    console.log('✅ QR Code loaded successfully');
                });
            }
        });

        // Debug information (remove in production)
        console.log('PayOS Payment Page Initialized');
        console.log('Order Code:', CONFIG.ORDER_CODE);
        console.log('QR Code Available:', ${not empty paymentResponse.qrCode});
        <c:if test="${not empty paymentResponse.qrCode}">
            console.log('QR Code Type:', '${paymentResponse.qrCode}'.startsWith('data:image/') ? 'Base64' : 'URL');
        </c:if>
    </script>
</body>
</html>
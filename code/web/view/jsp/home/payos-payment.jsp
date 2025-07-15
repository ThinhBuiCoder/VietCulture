<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán PayOS | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #FF385C;
                --secondary-color: #83C5BE;
                --accent-color: #F8F9FA;
                --dark-color: #2F4858;
                --light-color: #FFFFFF;
                --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
                --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
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
                background-color: var(--accent-color);
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
            }

            .navbar-brand img {
                height: 50px !important;
                width: auto !important;
                margin-right: 12px !important;
            }

            /* Main Content */
            .main-content {
                min-height: 100vh;
                padding: 40px 0;
            }

            .payment-header {
                background: var(--light-color);
                padding: 40px 0;
                margin-bottom: 40px;
                text-align: center;
                border-bottom: 1px solid rgba(0,0,0,0.1);
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
                margin: 0 auto;
            }

            /* Service Type Badge */
            .service-type-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                margin-bottom: 20px;
            }

            .service-type-badge.experience {
                background: rgba(255, 56, 92, 0.1);
                color: var(--primary-color);
                border: 1px solid rgba(255, 56, 92, 0.3);
            }

            .service-type-badge.accommodation {
                background: rgba(131, 197, 190, 0.1);
                color: var(--secondary-color);
                border: 1px solid rgba(131, 197, 190, 0.3);
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 40px;
            }

            /* Payment Card */
            .payment-card {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                margin-bottom: 30px;
            }

            .section-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 20px;
                color: var(--dark-color);
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 15px;
                border-bottom: 2px solid rgba(0,0,0,0.1);
            }

            .section-title i {
                color: var(--primary-color);
                font-size: 1.2rem;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid rgba(0,0,0,0.05);
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 500;
                color: #6c757d;
            }

            .detail-value {
                font-weight: 600;
                color: var(--dark-color);
            }

            /* Service Info Display */
            .service-display {
                background: rgba(131, 197, 190, 0.1);
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                border-left: 4px solid var(--secondary-color);
            }

            .service-display.experience {
                background: rgba(255, 56, 92, 0.1);
                border-left-color: var(--primary-color);
            }

            .service-display h4 {
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .service-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                font-size: 0.9rem;
                color: #6c757d;
            }

            .service-meta-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            /* Payment Options */
            .payment-options {
                margin: 30px 0;
            }

            .payment-btn {
                display: inline-block;
                padding: 15px 30px;
                background: var(--gradient-primary);
                color: white;
                text-decoration: none;
                border-radius: 10px;
                font-size: 18px;
                font-weight: bold;
                margin: 10px;
                transition: var(--transition);
                border: none;
                cursor: pointer;
                width: 100%;
                text-align: center;
            }

            .payment-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
                color: white;
                text-decoration: none;
            }

            /* QR Code Section */
            .qr-section {
                margin: 30px 0;
                padding: 25px;
                background: var(--light-color);
                border-radius: var(--border-radius);
                text-align: center;
                box-shadow: var(--shadow-sm);
            }

            .qr-code {
                margin: 20px 0;
                padding: 20px;
                background: white;
                border-radius: 15px;
                display: inline-block;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .qr-code img {
                border-radius: 10px;
                border: 2px solid #e0e0e0;
            }

            /* Status Check */
            .status-check {
                background: rgba(131, 197, 190, 0.1);
                border: 1px solid var(--secondary-color);
                border-radius: 10px;
                padding: 20px;
                margin-top: 30px;
                text-align: center;
            }

            .status-check h4 {
                color: var(--secondary-color);
                margin-bottom: 10px;
            }

            .loading-spinner {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(131, 197, 190, 0.3);
                border-radius: 50%;
                border-top-color: var(--secondary-color);
                animation: spin 1s ease-in-out infinite;
                margin-right: 10px;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Order Summary */
            .order-summary {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                border: 2px solid var(--primary-color);
            }

            .summary-title {
                text-align: center;
                margin-bottom: 20px;
                color: var(--dark-color);
            }

            /* Important Notes */
            .important-notes {
                background: rgba(255, 193, 7, 0.1);
                border: 1px solid rgba(255, 193, 7, 0.3);
                border-radius: 10px;
                padding: 20px;
                margin: 20px 0;
            }

            .important-notes h4 {
                color: #856404;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .note-item {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                margin-bottom: 10px;
                font-size: 0.9rem;
            }

            .note-item i {
                color: #ffc107;
                margin-top: 2px;
            }

            /* Support Info */
            .support-info {
                background: rgba(75, 181, 67, 0.1);
                border-radius: 10px;
                padding: 20px;
                margin-top: 20px;
            }

            .support-info h5 {
                color: #4bb543;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .contact-item {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
                font-size: 0.9rem;
                color: #4bb543;
            }

            /* Payment Methods */
            .payment-methods {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
                gap: 15px;
                margin: 20px 0;
            }

            .payment-method-card {
                background: white;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                padding: 15px;
                text-align: center;
                transition: var(--transition);
            }

            .payment-method-card:hover {
                border-color: var(--primary-color);
                transform: translateY(-2px);
            }

            .payment-method-icon {
                font-size: 2rem;
                margin-bottom: 8px;
                color: var(--primary-color);
            }

            .payment-method-name {
                font-size: 0.8rem;
                font-weight: 600;
                color: var(--dark-color);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .payment-title {
                    font-size: 2rem;
                }
            }

            @media (max-width: 768px) {
                .payment-title {
                    font-size: 1.7rem;
                }

                .payment-card,
                .order-summary {
                    padding: 20px;
                }

                .payment-methods {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            /* Auto-refresh indicator */
            .refresh-indicator {
                position: fixed;
                top: 100px;
                right: 20px;
                background: var(--secondary-color);
                color: white;
                padding: 10px 15px;
                border-radius: 25px;
                font-size: 0.8rem;
                z-index: 1000;
                display: flex;
                align-items: center;
                gap: 8px;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="custom-navbar">
            <div class="container">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                    <span>VIETCULTURE</span>
                </a>
            </div>
        </nav>

        <!-- Header -->
        <div class="payment-header">
            <div class="container">
                <h1 class="payment-title">Thanh toán đơn hàng</h1>
                <p class="payment-subtitle">
                    Hoàn tất thanh toán để xác nhận đặt chỗ của bạn
                </p>
            </div>
        </div>

        <!-- Auto-refresh indicator -->
        <div class="refresh-indicator">
            <div class="loading-spinner"></div>
            <span>Đang kiểm tra thanh toán...</span>
        </div>

        <!-- Main Content -->
        <div class="container main-content">
            <div class="content-grid">
                <!-- Payment Information -->
                <div>
                    <!-- Order Information -->
                    <div class="payment-card">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin đơn hàng
                        </h3>

                        <!-- Service Type Badge -->
                        <c:choose>
                            <c:when test="${serviceType == 'experience'}">
                                <div class="service-type-badge experience">
                                    <i class="ri-compass-3-line"></i>
                                    <span>Trải nghiệm</span>
                                </div>
                            </c:when>
                            <c:when test="${serviceType == 'accommodation'}">
                                <div class="service-type-badge accommodation">
                                    <i class="ri-hotel-line"></i>
                                    <span>Lưu trú</span>
                                </div>
                            </c:when>
                        </c:choose>

                        <!-- Service Display -->
                        <div class="service-display ${serviceType}">
                            <h4>${serviceName}</h4>
                            <div class="service-meta">
                                <c:choose>
                                    <c:when test="${serviceType == 'experience'}">
                                        <div class="service-meta-item">
                                            <i class="ri-calendar-line"></i>
                                            <span>Trải nghiệm du lịch</span>
                                        </div>
                                        <div class="service-meta-item">
                                            <i class="ri-group-line"></i>
                                            <span>Hoạt động nhóm</span>
                                        </div>
                                    </c:when>
                                    <c:when test="${serviceType == 'accommodation'}">
                                        <div class="service-meta-item">
                                            <i class="ri-hotel-bed-line"></i>
                                            <span>Chỗ lưu trú</span>
                                        </div>
                                        <div class="service-meta-item">
                                            <i class="ri-time-line"></i>
                                            <span>Theo đêm</span>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Mã đơn hàng:</span>
                            <span class="detail-value"><strong>#${bookingID}</strong></span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Khách hàng:</span>
                            <span class="detail-value">${customerName}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Dịch vụ:</span>
                            <span class="detail-value">${serviceName}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Tổng tiền:</span>
                            <span class="detail-value">
                                <fmt:formatNumber value="${amount}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                            </span>
                        </div>
                    </div>

                    <!-- Payment Options -->
                    <div class="payment-card">
                        <h3 class="section-title">
                            <i class="ri-bank-card-line"></i>
                            Chọn phương thức thanh toán
                        </h3>

                        <div class="payment-options">
                            <a href="${paymentUrl}" target="_blank" class="payment-btn">
                                <i class="ri-external-link-line me-2"></i>
                                Thanh toán trực tuyến PayOS
                            </a>
                        </div>

                        <!-- Supported Payment Methods -->
                        <div class="payment-methods">
                            <div class="payment-method-card">
                                <div class="payment-method-icon">
                                    <i class="ri-smartphone-line"></i>
                                </div>
                                <div class="payment-method-name">MoMo</div>
                            </div>
                            <div class="payment-method-card">
                                <div class="payment-method-icon">
                                    <i class="ri-wallet-line"></i>
                                </div>
                                <div class="payment-method-name">ZaloPay</div>
                            </div>
                            <div class="payment-method-card">
                                <div class="payment-method-icon">
                                    <i class="ri-bank-card-line"></i>
                                </div>
                                <div class="payment-method-name">Thẻ tín dụng</div>
                            </div>
                            <div class="payment-method-card">
                                <div class="payment-method-icon">
                                    <i class="ri-bank-line"></i>
                                </div>
                                <div class="payment-method-name">Ngân hàng</div>
                            </div>
                        </div>
                    </div>

                    <!-- Important Notes -->
                    <div class="important-notes">
                        <h4>
                            <i class="ri-alert-line"></i>
                            Lưu ý quan trọng
                        </h4>

                        <div class="note-item">
                            <i class="ri-time-line"></i>
                            <span>Thời gian thanh toán: trong vòng 15 phút</span>
                        </div>

                        <div class="note-item">
                            <i class="ri-refresh-line"></i>
                            <span>Trang này sẽ tự động cập nhật khi thanh toán hoàn tất</span>
                        </div>

                        <div class="note-item">
                            <i class="ri-shield-check-line"></i>
                            <span>Thanh toán được bảo mật bởi PayOS</span>
                        </div>

                        <div class="note-item">
                            <i class="ri-mail-send-line"></i>
                            <span>Email xác nhận sẽ được gửi sau khi thanh toán thành công</span>
                        </div>

                        <c:if test="${serviceType == 'experience'}">
                            <div class="note-item">
                                <i class="ri-map-pin-line"></i>
                                <span>Thông tin địa điểm sẽ được gửi sau khi xác nhận</span>
                            </div>
                        </c:if>

                        <c:if test="${serviceType == 'accommodation'}">
                            <div class="note-item">
                                <i class="ri-key-line"></i>
                                <span>Thông tin check-in sẽ được gửi sau khi xác nhận</span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Status Check -->
                    <div class="status-check">
                        <h4>
                            <div class="loading-spinner"></div>
                            Đang chờ thanh toán...
                        </h4>
                        <p>
                            <c:choose>
                                <c:when test="${serviceType == 'experience'}">
                                    Vui lòng hoàn tất thanh toán để xác nhận đặt chỗ trải nghiệm
                                </c:when>
                                <c:when test="${serviceType == 'accommodation'}">
                                    Vui lòng hoàn tất thanh toán để xác nhận đặt phòng
                                </c:when>
                                <c:otherwise>
                                    Vui lòng hoàn tất thanh toán để xác nhận đặt chỗ
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- Order Summary Sidebar -->
                <div>
                    <!-- Order Summary -->
                    <div class="order-summary">
                        <h4 class="summary-title">
                            <i class="ri-receipt-line me-2"></i>
                            Tóm tắt đơn hàng
                        </h4>

                        <div class="detail-row">
                            <span class="detail-label">Mã đơn hàng:</span>
                            <span class="detail-value">#${bookingID}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Dịch vụ:</span>
                            <span class="detail-value">${serviceName}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Khách hàng:</span>
                            <span class="detail-value">${customerName}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Loại:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${serviceType == 'experience'}">
                                        <i class="ri-compass-3-line me-1"></i>Trải nghiệm
                                    </c:when>
                                    <c:when test="${serviceType == 'accommodation'}">
                                        <i class="ri-hotel-line me-1"></i>Lưu trú
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ri-service-line me-1"></i>Dịch vụ
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value">
                                <span style="color: #ffc107; font-weight: bold;">
                                    <i class="ri-time-line me-1"></i>Chờ thanh toán
                                </span>
                            </span>
                        </div>

                        <div class="detail-row" style="border-top: 2px solid rgba(0,0,0,0.1); padding-top: 15px; margin-top: 15px;">
                            <span class="detail-label" style="font-size: 1.1rem; font-weight: bold;">Tổng tiền:</span>
                            <span class="detail-value" style="font-size: 1.2rem; color: var(--primary-color); font-weight: bold;">
                                <fmt:formatNumber value="${amount}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                            </span>
                        </div>
                    </div>

                    <!-- Support Information -->
                    <div class="support-info">
                        <h5>
                            <i class="ri-customer-service-2-line"></i>
                            Cần hỗ trợ?
                        </h5>

                        <div class="contact-item">
                            <i class="ri-phone-line"></i>
                            <span>Hotline: 1900 1234</span>
                        </div>

                        <div class="contact-item">
                            <i class="ri-mail-line"></i>
                            <span>support@vietculture.vn</span>
                        </div>

                        <div class="contact-item">
                            <i class="ri-time-line"></i>
                            <span>Hỗ trợ 24/7</span>
                        </div>

                        <div class="contact-item">
                            <i class="ri-chat-3-line"></i>
                            <span>Chat trực tuyến</span>
                        </div>
                    </div>

                    <!-- Security Badge -->
                    <div class="mt-3 p-3 bg-light rounded text-center">
                        <h6 class="mb-2">
                            <i class="ri-shield-check-line text-success me-2"></i>
                            Bảo mật & An toàn
                        </h6>
                        <small class="text-muted">
                            Thanh toán được mã hóa SSL 256-bit<br>
                            Được bảo vệ bởi PayOS
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto refresh để check trạng thái thanh toán
            let checkInterval;
            let checkCount = 0;
            const maxChecks = 60; // Check tối đa 60 lần (15 phút)

            function startPaymentStatusCheck() {
                checkInterval = setInterval(checkPaymentStatus, 15000); // Check mỗi 15 giây
            }

            function checkPaymentStatus() {
                checkCount++;

                // Sau 60 lần check (15 phút), dừng lại
                if (checkCount >= maxChecks) {
                    clearInterval(checkInterval);
                    showTimeoutMessage();
                    return;
                }

                // Gọi API check status (có thể implement sau)
                fetch('${pageContext.request.contextPath}/api/payment-status?bookingId=${bookingID}', {
                            method: 'GET',
                            headers: {
                                'Content-Type': 'application/json',
                            }
                        })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.status === 'CONFIRMED') {
                                        // Thanh toán thành công
                                        clearInterval(checkInterval);
                                        showSuccessMessage();
                                        setTimeout(() => {
                                            window.location.href = '${pageContext.request.contextPath}/booking/success?bookingId=${bookingID}';
                                                                    }, 2000);
                                                                } else if (data.status === 'CANCELLED') {
                                                                    // Thanh toán thất bại
                                                                    clearInterval(checkInterval);
                                                                    showFailedMessage();
                                                                    setTimeout(() => {
                                                                        window.location.href = '${pageContext.request.contextPath}/booking/fail?bookingId=${bookingID}';
                                                                                                }, 3000);
                                                                                            }
                                                                                        })
                                                                                        .catch(error => {
                                                                                            console.log('Checking payment status...', error);
                                                                                            // Không hiển thị lỗi, tiếp tục check
                                                                                        });
                                                                            }

                                                                            function showSuccessMessage() {
                                                                                const statusCheck = document.querySelector('.status-check');
                                                                                statusCheck.innerHTML = `
                    <h4 style="color: #4BB543;">
                        <i class="ri-check-line me-2"></i>
                        Thanh toán thành công!
                    </h4>
                    <p>Đang chuyển hướng đến trang xác nhận...</p>
                `;
                                                                                statusCheck.style.background = 'rgba(75, 181, 67, 0.1)';
                                                                                statusCheck.style.borderColor = '#4BB543';

                                                                                // Update refresh indicator
                                                                                const refreshIndicator = document.querySelector('.refresh-indicator');
                                                                                refreshIndicator.innerHTML = `
                    <i class="ri-check-line"></i>
                    <span>Thanh toán thành công!</span>
                `;
                                                                                refreshIndicator.style.background = '#4BB543';
                                                                            }

                                                                            function showFailedMessage() {
                                                                                const statusCheck = document.querySelector('.status-check');
                                                                                statusCheck.innerHTML = `
                    <h4 style="color: #FF385C;">
                        <i class="ri-close-line me-2"></i>
                        Thanh toán thất bại!
                    </h4>
                    <p>Đang chuyển hướng đến trang thông báo...</p>
                `;
                                                                                statusCheck.style.background = 'rgba(255, 56, 92, 0.1)';
                                                                                statusCheck.style.borderColor = '#FF385C';

                                                                                // Update refresh indicator
                                                                                const refreshIndicator = document.querySelector('.refresh-indicator');
                                                                                refreshIndicator.innerHTML = `
                    <i class="ri-close-line"></i>
                    <span>Thanh toán thất bại!</span>
                `;
                                                                                refreshIndicator.style.background = '#FF385C';
                                                                            }

                                                                            function showTimeoutMessage() {
                                                                                const statusCheck = document.querySelector('.status-check');
                                                                                statusCheck.innerHTML = `
                    <h4 style="color: #ffc107;">
                        <i class="ri-time-line me-2"></i>
                        Hết thời gian chờ
                    </h4>
                    <p>Vui lòng thử lại hoặc liên hệ hỗ trợ nếu bạn đã thanh toán</p>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/booking" class="btn btn-primary btn-sm me-2">
                            <i class="ri-refresh-line me-1"></i>Đặt lại
                        </a>
                        <a href="tel:1900-1234" class="btn btn-outline-secondary btn-sm">
                            <i class="ri-phone-line me-1"></i>Gọi hỗ trợ
                        </a>
                    </div>
                `;
                                                                                statusCheck.style.background = 'rgba(255, 193, 7, 0.1)';
                                                                                statusCheck.style.borderColor = '#ffc107';

                                                                                // Update refresh indicator
                                                                                const refreshIndicator = document.querySelector('.refresh-indicator');
                                                                                refreshIndicator.innerHTML = `
                    <i class="ri-time-line"></i>
                    <span>Hết thời gian chờ</span>
                `;
                                                                                refreshIndicator.style.background = '#ffc107';
                                                                            }

                                                                            // Bắt đầu check khi trang load
                                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                                // Bắt đầu check sau 5 giây
                                                                                setTimeout(startPaymentStatusCheck, 5000);

                                                                                // Handle payment button click
                                                                                const paymentBtn = document.querySelector('.payment-btn');
                                                                                if (paymentBtn) {
                                                                                    paymentBtn.addEventListener('click', function () {
                                                                                        // Bắt đầu check ngay khi user click thanh toán
                                                                                        if (!checkInterval) {
                                                                                            setTimeout(startPaymentStatusCheck, 10000); // Check sau 10 giây
                                                                                        }
                                                                                    });
                                                                                }
                                                                            });

                                                                            // Handle page visibility change
                                                                            document.addEventListener('visibilitychange', function () {
                                                                                if (document.hidden) {
                                                                                    // Trang bị ẩn, có thể giảm tần suất check
                                                                                    if (checkInterval) {
                                                                                        clearInterval(checkInterval);
                                                                                        checkInterval = setInterval(checkPaymentStatus, 30000); // Check mỗi 30 giây
                                                                                    }
                                                                                } else {
                                                                                    // Trang được hiển thị lại, tăng tần suất check
                                                                                    if (checkInterval) {
                                                                                        clearInterval(checkInterval);
                                                                                        checkInterval = setInterval(checkPaymentStatus, 15000); // Check mỗi 15 giây
                                                                                    }
                                                                                }
                                                                            });

                                                                            // Handle window focus
                                                                            window.addEventListener('focus', function () {
                                                                                // Khi user quay lại trang, check ngay lập tức
                                                                                if (checkCount < maxChecks) {
                                                                                    checkPaymentStatus();
                                                                                }
                                                                            });

                                                                            // Show countdown timer
                                                                            function updateCountdown() {
                                                                                const timeLeft = Math.max(0, (maxChecks - checkCount) * 15);
                                                                                const minutes = Math.floor(timeLeft / 60);
                                                                                const seconds = timeLeft % 60;

                                                                                const countdownElement = document.querySelector('.countdown-timer');
                                                                                if (countdownElement && timeLeft > 0) {
                                                                                    countdownElement.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                                                                                            }
                                                                                        }

                                                                                        // Update countdown every second
                                                                                        setInterval(updateCountdown, 1000);
        </script>
    </body>
</html>
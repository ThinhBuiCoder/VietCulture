<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán Thất Bại | VietCulture</title>
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
                --error-color: #e74c3c;
                --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
                --gradient-error: linear-gradient(135deg, #e74c3c, #c0392b);
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
                background: linear-gradient(135deg, #f8f9fa 0%, #ffe6ea 100%);
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
            }

            .navbar-brand img {
                height: 50px !important;
                width: auto !important;
                margin-right: 12px !important;
            }

            /* Error Header */
            .error-header {
                text-align: center;
                padding: 60px 0;
                background: var(--light-color);
                margin-bottom: 40px;
                position: relative;
                overflow: hidden;
            }

            .error-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="%23e74c3c" opacity="0.1"><animate attributeName="opacity" values="0.1;0.3;0.1" dur="2s" repeatCount="indefinite"/></circle><circle cx="80" cy="30" r="3" fill="%23FF385C" opacity="0.1"><animate attributeName="opacity" values="0.1;0.4;0.1" dur="3s" repeatCount="indefinite"/></circle></svg>') repeat;
                pointer-events: none;
            }

            .error-icon {
                width: 120px;
                height: 120px;
                background: var(--gradient-error);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                box-shadow: 0 10px 30px rgba(231, 76, 60, 0.3);
                position: relative;
                z-index: 1;
            }

            .error-icon i {
                font-size: 3rem;
                color: white;
            }

            .error-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 15px;
                color: var(--error-color);
                position: relative;
                z-index: 1;
            }

            .error-subtitle {
                font-size: 1.2rem;
                color: #6c757d;
                max-width: 600px;
                margin: 0 auto;
                position: relative;
                z-index: 1;
            }

            .booking-number {
                display: inline-block;
                background: var(--gradient-error);
                color: white;
                padding: 10px 20px;
                border-radius: 25px;
                font-weight: 700;
                margin-top: 20px;
                font-size: 1.1rem;
                position: relative;
                z-index: 1;
            }

            /* Main Content */
            .main-content {
                padding: 40px 0 80px;
            }

            .content-grid {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 40px;
            }

            /* Error Details Card */
            .error-details {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                margin-bottom: 30px;
                border: 2px solid rgba(231, 76, 60, 0.2);
            }

            .section-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 25px;
                color: var(--dark-color);
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 15px;
                border-bottom: 2px solid rgba(0,0,0,0.1);
            }

            .section-title i {
                color: var(--error-color);
                font-size: 1.2rem;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
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
                text-align: right;
            }

            .status-badge {
                background: var(--gradient-error);
                color: white;
                padding: 6px 16px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            /* Possible Reasons */
            .reasons-card {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                margin-bottom: 30px;
            }

            .reason-item {
                display: flex;
                align-items: flex-start;
                gap: 15px;
                margin-bottom: 15px;
                padding: 15px;
                background: rgba(231, 76, 60, 0.05);
                border-radius: 10px;
                border-left: 4px solid var(--error-color);
            }

            .reason-item:last-child {
                margin-bottom: 0;
            }

            .reason-icon {
                min-width: 30px;
                height: 30px;
                background: var(--error-color);
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.9rem;
            }

            .reason-content {
                flex: 1;
            }

            .reason-content h6 {
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .reason-content p {
                margin: 0;
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Action Buttons */
            .action-buttons {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                border-radius: 10px;
                padding: 12px 24px;
                font-weight: 600;
                transition: var(--transition);
                border: none;
                text-decoration: none;
                text-align: center;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
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

            .btn-danger {
                background: var(--gradient-error);
                color: white;
                box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
            }

            .btn-danger:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(231, 76, 60, 0.4);
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
            }

            /* Support Info */
            .support-info {
                background: linear-gradient(135deg, #3498db, #2980b9);
                color: white;
                border-radius: var(--border-radius);
                padding: 25px;
                text-align: center;
            }

            .support-info h5 {
                margin-bottom: 15px;
                color: white;
            }

            .contact-item {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin-bottom: 10px;
                font-size: 0.95rem;
            }

            .contact-item:last-child {
                margin-bottom: 0;
            }

            .contact-item i {
                font-size: 1.1rem;
            }

            /* Tips Section */
            .tips-section {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                margin-top: 20px;
            }

            .tip-item {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                margin-bottom: 15px;
                padding: 10px;
                background: rgba(52, 152, 219, 0.05);
                border-radius: 8px;
            }

            .tip-item:last-child {
                margin-bottom: 0;
            }

            .tip-icon {
                color: #3498db;
                font-size: 1.2rem;
                margin-top: 2px;
            }

            .tip-text {
                flex: 1;
                font-size: 0.9rem;
                color: var(--dark-color);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
            }

            @media (max-width: 768px) {
                .error-title {
                    font-size: 2rem;
                }

                .error-icon {
                    width: 100px;
                    height: 100px;
                }

                .error-icon i {
                    font-size: 2.5rem;
                }

                .error-details,
                .reasons-card,
                .tips-section {
                    padding: 20px;
                }

                .action-buttons {
                    grid-template-columns: 1fr;
                }
            }

            /* Animations */
            .fade-in {
                animation: fadeIn 1s ease-in;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Shake animation for error elements */
            .shake {
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-5px);
                }
                75% {
                    transform: translateX(5px);
                }
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

        <!-- Error Header -->
        <div class="error-header">
            <div class="container">
                <div class="error-icon fade-in shake">
                    <i class="ri-close-line"></i>
                </div>

                <h1 class="error-title fade-in">
                    Thanh toán không thành công
                </h1>

                <p class="error-subtitle fade-in">
                    Rất tiếc, quá trình thanh toán của bạn đã bị hủy hoặc gặp sự cố.
                </p>

                <c:if test="${not empty param.bookingId}">
                    <div class="booking-number fade-in">
                        <i class="ri-bookmark-line me-2"></i>
                        Mã đơn hàng: #${param.bookingId}
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container main-content">
            <div class="content-grid">
                <!-- Error Details -->
                <div class="fade-in">
                    <!-- Order Information -->
                    <div class="error-details">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin đơn hàng
                        </h3>

                        <c:if test="${not empty param.bookingId}">
                            <div class="detail-row">
                                <span class="detail-label">Mã đơn hàng:</span>
                                <span class="detail-value">#${param.bookingId}</span>
                            </div>
                        </c:if>

                        <div class="detail-row">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value">
                                <span class="status-badge">
                                    <i class="ri-close-line"></i>
                                    Chưa thanh toán
                                </span>
                            </span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Thời gian:</span>
                            <span class="detail-value">
                                <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm" />
                            </span>
                        </div>
                    </div>

                    <!-- Possible Reasons -->
                    <div class="reasons-card">
                        <h3 class="section-title">
                            <i class="ri-question-line"></i>
                            Nguyên nhân có thể
                        </h3>

                        <div class="reason-item">
                            <div class="reason-icon">
                                <i class="ri-close-circle-line"></i>
                            </div>
                            <div class="reason-content">
                                <h6>Hủy giao dịch</h6>
                                <p>Bạn đã chọn hủy giao dịch trong quá trình thanh toán</p>
                            </div>
                        </div>

                        <div class="reason-item">
                            <div class="reason-icon">
                                <i class="ri-bank-card-line"></i>
                            </div>
                            <div class="reason-content">
                                <h6>Thông tin thẻ không chính xác</h6>
                                <p>Số thẻ, ngày hết hạn hoặc CVV không đúng</p>
                            </div>
                        </div>

                        <div class="reason-item">
                            <div class="reason-icon">
                                <i class="ri-wallet-line"></i>
                            </div>
                            <div class="reason-content">
                                <h6>Tài khoản không đủ số dư</h6>
                                <p>Số dư trong tài khoản/thẻ không đủ để thực hiện giao dịch</p>
                            </div>
                        </div>

                        <div class="reason-item">
                            <div class="reason-icon">
                                <i class="ri-wifi-off-line"></i>
                            </div>
                            <div class="reason-content">
                                <h6>Lỗi kết nối mạng</h6>
                                <p>Kết nối internet không ổn định trong quá trình thanh toán</p>
                            </div>
                        </div>

                        <div class="reason-item">
                            <div class="reason-icon">
                                <i class="ri-time-line"></i>
                            </div>
                            <div class="reason-content">
                                <h6>Phiên thanh toán hết hạn</h6>
                                <p>Quá thời gian cho phép để hoàn tất thanh toán</p>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/booking/confirm" class="btn btn-danger">
                            <i class="ri-refresh-line"></i>
                            Thử Lại Thanh Toán
                        </a>

                        <a href="${pageContext.request.contextPath}/booking" class="btn btn-primary">
                            <i class="ri-arrow-left-line"></i>
                            Đặt Chỗ Mới
                        </a>

                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                            <i class="ri-home-line"></i>
                            Về Trang Chủ
                        </a>
                    </div>

                    <!-- Additional Action -->
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/booking/history" class="btn btn-outline-primary">
                            <i class="ri-calendar-check-line me-2"></i>
                            Xem Lịch Sử Đặt Chỗ
                        </a>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="fade-in">
                    <!-- Support Information -->
                    <div class="support-info">
                        <h5>
                            <i class="ri-customer-service-2-line me-2"></i>
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

                    <!-- Tips Section -->
                    <div class="tips-section">
                        <h6 class="mb-3">
                            <i class="ri-lightbulb-line me-2"></i>
                            Mẹo để thanh toán thành công
                        </h6>

                        <div class="tip-item">
                            <i class="ri-check-line tip-icon"></i>
                            <div class="tip-text">
                                Kiểm tra kết nối internet ổn định trước khi thanh toán
                            </div>
                        </div>

                        <div class="tip-item">
                            <i class="ri-check-line tip-icon"></i>
                            <div class="tip-text">
                                Đảm bảo thông tin thẻ/tài khoản chính xác
                            </div>
                        </div>

                        <div class="tip-item">
                            <i class="ri-check-line tip-icon"></i>
                            <div class="tip-text">
                                Kiểm tra số dư tài khoản đủ để thanh toán
                            </div>
                        </div>

                        <div class="tip-item">
                            <i class="ri-check-line tip-icon"></i>
                            <div class="tip-text">
                                Không đóng trình duyệt trong quá trình thanh toán
                            </div>
                        </div>

                        <div class="tip-item">
                            <i class="ri-check-line tip-icon"></i>
                            <div class="tip-text">
                                Liên hệ ngân hàng nếu thẻ bị khóa giao dịch online
                            </div>
                        </div>
                    </div>

                    <!-- Alternative Payment -->
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-3">
                            <i class="ri-money-dollar-circle-line me-2"></i>
                            Phương thức khác
                        </h6>
                        <p class="small text-muted mb-3">
                            Bạn có thể chọn thanh toán tiền mặt khi tham gia tour
                        </p>
                        <a href="${pageContext.request.contextPath}/booking/confirm?payment=cash" 
                           class="btn btn-outline-primary btn-sm w-100">
                            <i class="ri-hand-coin-line me-2"></i>
                            Chọn Thanh Toán Tiền Mặt
                        </a>
                    </div>

                    <!-- Security Note -->
                    <div class="mt-3 p-3 bg-warning bg-opacity-10 rounded">
                        <h6 class="text-warning mb-2">
                            <i class="ri-shield-check-line me-2"></i>
                            Bảo mật thanh toán
                        </h6>
                        <small class="text-muted">
                            Tất cả giao dịch được bảo mật bằng SSL 256-bit và 
                            được xử lý qua hệ thống PayOS an toàn.
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto-scroll to top and show animations
            window.addEventListener('load', function () {
                window.scrollTo(0, 0);

                // Trigger fade-in animations
                setTimeout(() => {
                    document.querySelectorAll('.fade-in').forEach((element, index) => {
                        setTimeout(() => {
                            element.style.opacity = '1';
                            element.style.transform = 'translateY(0)';
                        }, index * 200);
                    });
                }, 500);
            });

            // Initialize fade-in elements
            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('.fade-in').forEach(element => {
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(20px)';
                    element.style.transition = 'all 0.6s ease-out';
                });

                // Add click tracking for retry buttons
                document.querySelectorAll('.btn').forEach(button => {
                    button.addEventListener('click', function (e) {
                        // Log button click for analytics
                        console.log('Button clicked:', this.textContent.trim());

                        // Add loading state for retry button
                        if (this.textContent.includes('Thử Lại')) {
                            this.innerHTML = '<i class="ri-loader-4-line me-2"></i>Đang xử lý...';
                            this.style.pointerEvents = 'none';
                        }
                    });
                });

                // Show helpful message after 5 seconds
                setTimeout(() => {
                    showHelpfulTip();
                }, 5000);
            });

            function showHelpfulTip() {
                // Create a subtle notification
                const tip = document.createElement('div');
                tip.style.cssText = `
                    position: fixed;
                    bottom: 20px;
                    right: 20px;
                    background: #3498db;
                    color: white;
                    padding: 15px 20px;
                    border-radius: 10px;
                    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                    z-index: 1000;
                    max-width: 300px;
                    font-size: 0.9rem;
                    transform: translateX(100%);
                    transition: transform 0.3s ease;
                `;

                tip.innerHTML = `
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="ri-information-line" style="font-size: 1.2rem;"></i>
                        <div>
                            <strong>Cần hỗ trợ?</strong><br>
                            <small>Liên hệ hotline 1900 1234 để được hỗ trợ ngay</small>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" 
                                style="background: none; border: none; color: white; font-size: 1.2rem; cursor: pointer;">
                            ×
                        </button>
                    </div>
                `;

                document.body.appendChild(tip);

                // Animate in
                setTimeout(() => {
                    tip.style.transform = 'translateX(0)';
                }, 100);

                // Auto remove after 10 seconds
                setTimeout(() => {
                    if (tip.parentElement) {
                        tip.style.transform = 'translateX(100%)';
                        setTimeout(() => {
                            if (tip.parentElement) {
                                tip.remove();
                            }
                        }, 300);
                    }
                }, 10000);
            }

            // Handle browser back button
            window.addEventListener('popstate', function (e) {
                // Redirect to booking page if user tries to go back
                window.location.href = '${pageContext.request.contextPath}/booking';
            });
        </script>
    </body>
</html>
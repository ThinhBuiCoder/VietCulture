<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán MoMo | VietCulture</title>
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
            --momo-color: #D82D8B;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-momo: linear-gradient(135deg, #D82D8B, #E91E63);
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
            background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
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

        /* Payment Header */
        .payment-header {
            text-align: center;
            padding: 40px 0;
            background: var(--light-color);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .payment-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="%23D82D8B" opacity="0.1"><animate attributeName="opacity" values="0.1;0.3;0.1" dur="2s" repeatCount="indefinite"/></circle><circle cx="80" cy="30" r="3" fill="%2383C5BE" opacity="0.1"><animate attributeName="opacity" values="0.1;0.4;0.1" dur="3s" repeatCount="indefinite"/></circle></svg>') repeat;
            pointer-events: none;
        }

        .momo-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient-momo);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 25px rgba(216, 45, 139, 0.3);
            position: relative;
            z-index: 1;
        }

        .momo-icon i {
            font-size: 2rem;
            color: white;
        }

        .payment-title {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 10px;
            color: var(--dark-color);
            position: relative;
            z-index: 1;
        }

        .payment-subtitle {
            font-size: 1.1rem;
            color: #6c757d;
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

        /* QR Code Section */
        .qr-section {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--shadow-md);
            text-align: center;
            border: 3px solid var(--momo-color);
        }

        .qr-code-container {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin: 30px 0;
            border: 2px dashed var(--momo-color);
        }

        .qr-code {
            width: 280px;
            height: 280px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAAEsCAYAAAB5fY51AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEgAACxIB0t1+/AAAABx0RVh0U29mdHdhcmUAQWRvYmUgRmlyZXdvcmtzIENTNui8sowAAAAWdEVYdENyZWF0aW9uIFRpbWUAMDYvMDUvMjAyNcGrLjYAAAc6SURBVHic7Z1BTBNbFIafe');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .payment-info {
            background: var(--gradient-momo);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 30px 0;
        }

        .payment-info h4 {
            margin-bottom: 15px;
            color: white;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .info-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .instructions {
            background: rgba(216, 45, 139, 0.1);
            border-left: 4px solid var(--momo-color);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: left;
        }

        .instruction-step {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 12px;
        }

        .instruction-step:last-child {
            margin-bottom: 0;
        }

        .step-number {
            min-width: 28px;
            height: 28px;
            background: var(--momo-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .step-text {
            color: var(--dark-color);
            font-weight: 500;
        }

        /* Action Buttons */
        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
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

        .btn-success {
            background: linear-gradient(135deg, #28a745, #4bb543);
            color: white;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.4);
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

        /* Sidebar */
        .booking-summary {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
            height: fit-content;
        }

        .summary-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--dark-color);
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(0,0,0,0.1);
        }

        .service-image {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .service-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-color);
            border-top: 2px solid rgba(0,0,0,0.1);
            padding-top: 15px;
            margin-top: 15px;
        }

        /* Contact Support */
        .contact-support {
            background: linear-gradient(135deg, #10466C, #83C5BE);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            text-align: center;
        }

        .contact-support h5 {
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

        /* Responsive */
        @media (max-width: 992px) {
            .content-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .payment-title {
                font-size: 1.7rem;
            }
            
            .qr-section {
                padding: 25px;
            }
            
            .qr-code {
                width: 240px;
                height: 240px;
            }
        }

        /* Loading Animation */
        .btn-loading {
            position: relative;
        }

        .btn-loading:disabled {
            opacity: 0.8;
        }

        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .alert-warning {
            background-color: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.3);
            color: #856404;
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
            <div class="momo-icon">
                <i class="ri-smartphone-line"></i>
            </div>
            
            <h1 class="payment-title">Thanh Toán MoMo</h1>
            <p class="payment-subtitle">
                Quét mã QR để thanh toán nhanh chóng và an toàn
            </p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container main-content">
        <!-- Error Messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-warning">
                <i class="ri-error-warning-line me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'payment_processing_error'}">
                        Có lỗi xảy ra trong quá trình xử lý thanh toán. Vui lòng thử lại.
                    </c:when>
                    <c:otherwise>
                        Có lỗi xảy ra. Vui lòng thử lại sau.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="content-grid">
            <!-- QR Payment Section -->
            <div>
                <div class="qr-section">
                    <h3 class="text-center mb-4">
                        <i class="ri-qr-code-line me-2" style="color: var(--momo-color);"></i>
                        Quét mã QR để thanh toán
                    </h3>
                    
                    <!-- QR Code -->
                    <div class="qr-code-container">
                        <div class="qr-code">
                            <!-- QR Code của bạn sẽ được hiển thị ở đây -->
                            <div style="width: 100%; height: 100%; background: #f0f0f0; display: flex; align-items: center; justify-content: center; border-radius: 10px;">
                                <div style="text-align: center; color: #666;">
                                    <i class="ri-qr-code-line" style="font-size: 3rem; margin-bottom: 10px; display: block;"></i>
                                    <strong>MÃ QR MOMO</strong><br>
                                    <small>BÙI MẠNH THỊNH<br>*******220</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Info -->
                    <div class="payment-info">
                        <h4>
                            <i class="ri-information-line me-2"></i>
                            Thông tin chuyển khoản
                        </h4>
                        <div class="info-row">
                            <span>Tên dịch vụ:</span>
                            <span>
                                <c:choose>
                                    <c:when test="${bookingType == 'experience'}">
                                        ${experience.title}
                                    </c:when>
                                    <c:otherwise>
                                        Dịch vụ VietCulture
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span>Số người:</span>
                            <span>${formData.numberOfPeople} người</span>
                        </div>
                        <div class="info-row">
                            <span>Ngày tham gia:</span>
                            <span>${formData.formattedBookingDate}</span>
                        </div>
                        <div class="info-row">
                            <span>Thời gian:</span>
                            <span>${formData.timeSlotDisplayName}</span>
                        </div>
                        <div class="info-row">
                            <span>Tổng tiền cần chuyển:</span>
                            <span><fmt:formatNumber value="${formData.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ</span>
                        </div>
                    </div>
                    
                    <!-- Instructions -->
                    <div class="instructions">
                        <h5 class="mb-3">
                            <i class="ri-information-line me-2"></i>
                            Hướng dẫn thanh toán
                        </h5>
                        
                        <div class="instruction-step">
                            <div class="step-number">1</div>
                            <div class="step-text">
                                Mở ứng dụng MoMo trên điện thoại của bạn
                            </div>
                        </div>
                        
                        <div class="instruction-step">
                            <div class="step-number">2</div>
                            <div class="step-text">
                                Chọn "Quét QR" và quét mã QR phía trên
                            </div>
                        </div>
                        
                        <div class="instruction-step">
                            <div class="step-number">3</div>
                            <div class="step-text">
                                Nhập số tiền: <strong><fmt:formatNumber value="${formData.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ</strong>
                            </div>
                        </div>
                        
                        <div class="instruction-step">
                            <div class="step-number">4</div>
                            <div class="step-text">
                                Thêm ghi chú: <strong>"VietCulture - Booking #${booking.bookingId}"</strong>
                            </div>
                        </div>
                        
                        <div class="instruction-step">
                            <div class="step-number">5</div>
                            <div class="step-text">
                                Xác nhận chuyển khoản và sau đó nhấn "Hoàn tất thanh toán" bên dưới
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <form action="${pageContext.request.contextPath}/booking" method="post" id="paymentForm">
                        <input type="hidden" name="action" value="complete-payment">
                        
                        <div class="action-buttons">
                            <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                                <i class="ri-arrow-left-line me-2"></i>Quay Lại
                            </button>
                            
                            <button type="submit" class="btn btn-success" id="completeBtn">
                                <span class="btn-text">
                                    <i class="ri-check-line me-2"></i>Hoàn Tất Thanh Toán
                                </span>
                                <span class="btn-loading d-none">
                                    <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                </span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Sidebar -->
            <div>
                <!-- Booking Summary -->
                <div class="booking-summary">
                    <h4 class="summary-title">
                        <i class="ri-bookmark-line me-2"></i>
                        Tóm tắt đặt chỗ
                    </h4>
                    
                    <c:if test="${bookingType == 'experience'}">
                        <c:choose>
                            <c:when test="${not empty experience.images}">
                                <c:set var="firstImage" value="${fn:split(experience.images, ',')[0]}" />
                                <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(firstImage)}" 
                                     alt="${experience.title}" class="service-image"
                                     onerror="this.src='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                     alt="${experience.title}" class="service-image">
                            </c:otherwise>
                        </c:choose>
                        
                        <h5 class="service-title">${experience.title}</h5>
                    </c:if>
                    
                    <div class="summary-item">
                        <span>Mã đặt chỗ:</span>
                        <span>#${booking.bookingId}</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Ngày:</span>
                        <span>${formData.formattedBookingDate}</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Thời gian:</span>
                        <span>${formData.timeSlotDisplayName}</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Số người:</span>
                        <span>${formData.numberOfPeople} người</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Giá cơ bản:</span>
                        <span><fmt:formatNumber value="${formData.totalPrice / 1.05}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Phí dịch vụ (5%):</span>
                        <span><fmt:formatNumber value="${formData.totalPrice * 0.05 / 1.05}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ</span>
                    </div>
                    
                    <div class="summary-total">
                        <span>Tổng cộng:</span>
                        <span><fmt:formatNumber value="${formData.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ</span>
                    </div>
                </div>

                <!-- Contact Support -->
                <div class="contact-support">
                    <h5>
                        <i class="ri-customer-service-2-line me-2"></i>Cần hỗ trợ?
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
                </div>

                <!-- Security Note -->
                <div class="mt-4 p-3 bg-light rounded">
                    <h6 class="mb-3">
                        <i class="ri-shield-check-line me-2"></i>Bảo mật thanh toán
                    </h6>
                    <ul class="list-unstyled mb-0 small">
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Thanh toán qua MoMo được bảo mật
                        </li>
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Thông tin cá nhân được bảo vệ
                        </li>
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Hỗ trợ hoàn tiền nếu có sự cố
                        </li>
                        <li>
                            <i class="ri-check-line text-success me-2"></i>
                            Xác nhận booking ngay sau thanh toán
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form submission
        const paymentForm = document.getElementById('paymentForm');
        const completeBtn = document.getElementById('completeBtn');

        paymentForm.addEventListener('submit', function(e) {
            // Confirm payment completion
            if (!confirm('Bạn đã chuyển khoản thành công qua MoMo chưa?\n\nVui lòng chỉ nhấn "OK" nếu bạn đã hoàn tất việc chuyển khoản.')) {
                e.preventDefault();
                return;
            }
            
            // Show loading state
            showLoadingState();
        });

        function showLoadingState() {
            const btnText = completeBtn.querySelector('.btn-text');
            const btnLoading = completeBtn.querySelector('.btn-loading');
            
            btnText.classList.add('d-none');
            btnLoading.classList.remove('d-none');
            completeBtn.disabled = true;
        }

        // Auto-scroll to top on page load
        window.addEventListener('load', function() {
            window.scrollTo(0, 0);
        });

        // Copy booking ID to clipboard
        function copyBookingId() {
            const bookingId = '${booking.bookingId}';
            if (navigator.clipboard) {
                navigator.clipboard.writeText('VietCulture - Booking #' + bookingId).then(() => {
                    alert('Đã sao chép mã đặt chỗ!');
                });
            } else {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = 'VietCulture - Booking #' + bookingId;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                alert('Đã sao chép mã đặt chỗ!');
            }
        }

        // Add click event to booking ID for easy copying
        document.addEventListener('DOMContentLoaded', function() {
            const bookingIdElements = document.querySelectorAll('.summary-item span:contains("#${booking.bookingId}")');
            bookingIdElements.forEach(element => {
                if (element.textContent.includes('#${booking.bookingId}')) {
                    element.style.cursor = 'pointer';
                    element.title = 'Nhấp để sao chép';
                    element.addEventListener('click', copyBookingId);
                }
            });
        });
    </script>
</body>
</html>
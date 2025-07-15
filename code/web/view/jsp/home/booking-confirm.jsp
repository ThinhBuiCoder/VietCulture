<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác Nhận Đặt Chỗ | VietCulture</title>
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

            /* Navigation Styles */
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

            /* Breadcrumb */
            .breadcrumb-container {
                background-color: var(--light-color);
                padding: 15px 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .breadcrumb {
                background: none;
                margin: 0;
                padding: 0;
            }

            .breadcrumb-item {
                color: #6c757d;
            }

            .breadcrumb-item.active {
                color: var(--dark-color);
                font-weight: 600;
            }

            .breadcrumb-item a {
                color: var(--primary-color);
                text-decoration: none;
                transition: var(--transition);
            }

            .breadcrumb-item a:hover {
                color: var(--dark-color);
            }

            /* Main Content */
            .main-content {
                min-height: 100vh;
                padding: 40px 0;
            }

            .confirm-header {
                background: var(--light-color);
                padding: 40px 0;
                margin-bottom: 40px;
                text-align: center;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .confirm-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 15px;
                color: var(--dark-color);
            }

            .confirm-subtitle {
                color: #6c757d;
                font-size: 1.1rem;
                max-width: 600px;
                margin: 0 auto;
            }

            /* Progress Steps */
            .progress-steps {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 30px 0;
                gap: 40px;
            }

            .step {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 20px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 0.9rem;
            }

            .step.completed {
                background: rgba(75, 181, 67, 0.1);
                color: #4bb543;
            }

            .step.active {
                background: rgba(255, 56, 92, 0.1);
                color: var(--primary-color);
            }

            .step.pending {
                background: rgba(108, 117, 125, 0.1);
                color: #6c757d;
            }

            .step i {
                font-size: 1.1rem;
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 40px;
            }

            /* Confirmation Details */
            .confirm-card {
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

            /* Service Info */
            .service-info {
                display: flex;
                gap: 20px;
                padding: 20px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 15px;
                margin-bottom: 20px;
            }

            .service-info.experience {
                background: rgba(255, 56, 92, 0.1);
                border-left: 4px solid var(--primary-color);
            }

            .service-info.accommodation {
                background: rgba(131, 197, 190, 0.1);
                border-left: 4px solid var(--secondary-color);
            }

            .service-image {
                width: 100px;
                height: 80px;
                object-fit: cover;
                border-radius: 10px;
                flex-shrink: 0;
            }

            .service-details h4 {
                font-size: 1.1rem;
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .service-details p {
                margin: 0;
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Service Type Badge */
            .service-type-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 5px 12px;
                border-radius: 15px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                margin-bottom: 10px;
            }

            .service-type-badge.experience {
                background: rgba(255, 56, 92, 0.1);
                color: var(--primary-color);
            }

            .service-type-badge.accommodation {
                background: rgba(131, 197, 190, 0.1);
                color: var(--secondary-color);
            }

            /* Price Summary */
            .price-summary {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                border: 2px solid var(--primary-color);
            }

            .price-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                font-size: 0.95rem;
            }

            .price-total {
                display: flex;
                justify-content: space-between;
                font-weight: 700;
                font-size: 1.2rem;
                color: var(--dark-color);
                border-top: 2px solid rgba(0,0,0,0.1);
                padding-top: 15px;
                margin-top: 15px;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                border-radius: 10px;
                padding: 12px 24px;
                font-weight: 600;
                transition: var(--transition);
                border: none;
                flex: 1;
            }

            .btn-primary {
                background: var(--gradient-primary);
                color: white;
                box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            }

            .btn-success {
                background: linear-gradient(135deg, #28a745, #4bb543);
                color: white;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(40, 167, 69, 0.4);
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

            /* Payment Methods */
            .payment-methods {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin: 20px 0;
            }

            .payment-method {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 15px;
                border: 2px solid rgba(0,0,0,0.1);
                border-radius: 10px;
                cursor: pointer;
                transition: var(--transition);
            }

            .payment-method:hover {
                border-color: var(--primary-color);
                background: rgba(255, 56, 92, 0.05);
            }

            .payment-method.selected {
                border-color: var(--primary-color);
                background: rgba(255, 56, 92, 0.1);
            }

            .payment-method input[type="radio"] {
                margin: 0;
            }

            .payment-icon {
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                color: var(--primary-color);
            }

            /* Terms */
            .terms-section {
                background: rgba(255, 193, 7, 0.1);
                border: 1px solid rgba(255, 193, 7, 0.3);
                border-radius: 10px;
                padding: 20px;
                margin: 20px 0;
            }

            .terms-checkbox {
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }

            .terms-checkbox input[type="checkbox"] {
                margin-top: 3px;
            }

            .terms-text {
                font-size: 0.9rem;
                color: var(--dark-color);
            }

            .terms-text a {
                color: var(--primary-color);
                text-decoration: none;
            }

            .terms-text a:hover {
                text-decoration: underline;
            }

            /* Security Info */
            .security-info {
                background: rgba(75, 181, 67, 0.1);
                border-radius: 10px;
                padding: 15px;
                margin-top: 20px;
            }

            .security-info h6 {
                color: #4bb543;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .security-features {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 8px;
            }

            .security-feature {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 0.85rem;
                color: #4bb543;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .confirm-title {
                    font-size: 2rem;
                }

                .progress-steps {
                    gap: 20px;
                }

                .step {
                    padding: 8px 15px;
                    font-size: 0.8rem;
                }
            }

            @media (max-width: 768px) {
                .confirm-title {
                    font-size: 1.7rem;
                }

                .confirm-card,
                .price-summary {
                    padding: 20px;
                }

                .service-info {
                    flex-direction: column;
                    text-align: center;
                }

                .service-image {
                    width: 100%;
                    height: 150px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .payment-methods {
                    grid-template-columns: 1fr;
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

            /* Alert Styles */
            .alert {
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .alert-danger {
                background-color: rgba(220, 53, 69, 0.1);
                border: 1px solid rgba(220, 53, 69, 0.3);
                color: #721c24;
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

        <!-- Breadcrumb -->
        <div class="breadcrumb-container">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="ri-home-line me-1"></i>Trang Chủ
                            </a>
                        </li>
                        <c:choose>
                            <c:when test="${bookingType == 'experience'}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/experiences">Trải Nghiệm</a>
                                </li>
                                <c:if test="${not empty experience}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/experiences/${experience.experienceId}">${experience.title}</a>
                                    </li>
                                </c:if>
                            </c:when>
                            <c:when test="${bookingType == 'accommodation'}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/accommodations">Lưu Trú</a>
                                </li>
                                <c:if test="${not empty accommodation}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/accommodations/${accommodation.accommodationId}">${accommodation.name}</a>
                                    </li>
                                </c:if>
                            </c:when>
                        </c:choose>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/booking">Đặt Chỗ</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Xác Nhận</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Header -->
        <div class="confirm-header">
            <div class="container">
                <h1 class="confirm-title">Xác nhận đặt chỗ</h1>
                <p class="confirm-subtitle">
                    Vui lòng kiểm tra lại thông tin đặt chỗ và hoàn tất thanh toán để xác nhận
                </p>

                <!-- Progress Steps -->
                <div class="progress-steps">
                    <div class="step completed">
                        <i class="ri-check-line"></i>
                        <span>Điền thông tin</span>
                    </div>
                    <div class="step active">
                        <i class="ri-bank-card-line"></i>
                        <span>Xác nhận & Thanh toán</span>
                    </div>
                    <div class="step pending">
                        <i class="ri-check-double-line"></i>
                        <span>Hoàn tất</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container main-content">
            <!-- Error Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="ri-error-warning-line me-2"></i>
                    ${errorMessage}
                </div>
            </c:if>

            <div class="content-grid">
                <!-- Confirmation Details -->
                <div>
                    <!-- Service Information -->
                    <div class="confirm-card">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin dịch vụ
                        </h3>

                        <!-- Service Type Badge -->
                        <c:choose>
                            <c:when test="${bookingType == 'experience'}">
                                <div class="service-type-badge experience">
                                    <i class="ri-compass-3-line"></i>
                                    <span>Trải nghiệm</span>
                                </div>
                            </c:when>
                            <c:when test="${bookingType == 'accommodation'}">
                                <div class="service-type-badge accommodation">
                                    <i class="ri-hotel-line"></i>
                                    <span>Lưu trú</span>
                                </div>
                            </c:when>
                        </c:choose>

                        <!-- Experience Service Info -->
                        <c:if test="${bookingType == 'experience' and not empty experience}">
                            <div class="service-info experience">
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

                                <div class="service-details">
                                    <h4>${experience.title}</h4>
                                    <p><i class="ri-map-pin-line me-1"></i> ${experience.location}</p>
                                    <p><i class="ri-user-star-line me-1"></i> Hướng dẫn viên ${experience.hostName}</p>
                                    <p><i class="ri-group-line me-1"></i> Tối đa ${experience.maxGroupSize} người</p>
                                </div>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Ngày tham gia:</span>
                                <span class="detail-value">${formData.formattedBookingDate}</span>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Thời gian:</span>
                                <span class="detail-value">${formData.timeSlotDisplayName}</span>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Số người tham gia:</span>
                                <span class="detail-value">${formData.numberOfPeople} người</span>
                            </div>
                        </c:if>

                        <!-- Accommodation Service Info -->
                        <c:if test="${bookingType == 'accommodation' and not empty accommodation}">
                            <div class="service-info accommodation">
                                <c:choose>
                                    <c:when test="${not empty accommodation.images}">
                                        <c:set var="firstImage" value="${fn:split(accommodation.images, ',')[0]}" />
                                        <img src="${pageContext.request.contextPath}/images/accommodations/${fn:trim(firstImage)}"
                                             alt="${accommodation.name}" class="service-image"
                                             onerror="this.src='https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80"
                                             alt="${accommodation.name}" class="service-image">
                                    </c:otherwise>
                                </c:choose>

                                <div class="service-details">
                                    <h4>${accommodation.name}</h4>
                                    <p><i class="ri-map-pin-line me-1"></i> ${accommodation.address}</p>
                                    <p><i class="ri-hotel-line me-1"></i> ${accommodation.type}</p>
                                    <p><i class="ri-door-line me-1"></i> ${accommodation.numberOfRooms} phòng có sẵn</p>
                                </div>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Ngày nhận phòng:</span>
                                <span class="detail-value">${formData.formattedCheckInDate}</span>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Ngày trả phòng:</span>
                                <span class="detail-value">${formData.formattedCheckOutDate}</span>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Số đêm:</span>
                                <span class="detail-value">${formData.numberOfNights} đêm</span>
                            </div>

                            <!-- NEW: Display Room Quantity -->
                            <div class="detail-row">
                                <span class="detail-label">Số phòng:</span>
                                <span class="detail-value">${formData.roomQuantity} phòng</span>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Số khách:</span>
                                <span class="detail-value">${formData.numberOfPeople} khách</span>
                            </div>
                        </c:if>

                        <!-- Common Special Requests -->
                        <c:if test="${not empty formData.specialRequests}">
                            <div class="detail-row">
                                <span class="detail-label">Yêu cầu đặc biệt:</span>
                                <span class="detail-value">${formData.specialRequests}</span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Contact Information -->
                    <div class="confirm-card">
                        <h3 class="section-title">
                            <i class="ri-user-line"></i>
                            Thông tin liên hệ
                        </h3>

                        <div class="detail-row">
                            <span class="detail-label">Họ và tên:</span>
                            <span class="detail-value">${formData.contactName}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Email:</span>
                            <span class="detail-value">${formData.contactEmail}</span>
                        </div>

                        <div class="detail-row">
                            <span class="detail-label">Số điện thoại:</span>
                            <span class="detail-value">${formData.contactPhone}</span>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="confirm-card">
                        <h3 class="section-title">
                            <i class="ri-bank-card-line"></i>
                            Phương thức thanh toán
                        </h3>

                        <div class="payment-methods">
                            <label class="payment-method selected">
                                <input type="radio" name="paymentMethod" value="cash" checked>
                                <div class="payment-icon">
                                    <i class="ri-money-dollar-circle-line"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">Thanh toán tiền mặt</div>
                                    <small class="text-muted">
                                        <c:choose>
                                            <c:when test="${bookingType == 'experience'}">
                                                Thanh toán trực tiếp tại địa điểm trải nghiệm
                                            </c:when>
                                            <c:when test="${bookingType == 'accommodation'}">
                                                Thanh toán trực tiếp khi nhận phòng
                                            </c:when>
                                            <c:otherwise>
                                                Thanh toán trực tiếp tại địa điểm
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                            </label>

                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="online">
                                <div class="payment-icon">
                                    <i class="ri-bank-card-line"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">Thanh toán online</div>
                                    <small class="text-muted">PayOS: Momo, ZaloPay, thẻ tín dụng</small>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="terms-section">
                        <div class="terms-checkbox">
                            <input type="checkbox" id="agreeTerms" required>
                            <label for="agreeTerms" class="terms-text">
                                Tôi đồng ý với <a href="${pageContext.request.contextPath}/terms" target="_blank">Điều khoản sử dụng</a> và
                                <a href="${pageContext.request.contextPath}/privacy" target="_blank">Chính sách bảo mật</a> của VietCulture.
                                Tôi hiểu rằng việc đặt chỗ này sẽ được xác nhận sau khi thanh toán thành công.
                            </label>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <form id="confirmForm" action="${pageContext.request.contextPath}/booking" method="post">
                        <input type="hidden" name="action" id="formAction" value="confirm">
                        <!-- Hidden field để xác định service type -->
                        <input type="hidden" name="serviceType" value="${bookingType}">

                        <div class="action-buttons">
                            <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                                <i class="ri-arrow-left-line me-2"></i>Quay Lại
                            </button>

                            <button type="button" class="btn btn-success" id="cashPaymentBtn">
                                <span class="btn-text">
                                    <i class="ri-money-dollar-circle-line me-2"></i>Xác Nhận Tiền Mặt
                                </span>
                                <span class="btn-loading d-none">
                                    <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                </span>
                            </button>

                            <button type="button" class="btn btn-primary" id="onlinePaymentBtn">
                                <span class="btn-text">
                                    <i class="ri-bank-card-line me-2"></i>Thanh Toán PayOS
                                </span>
                                <span class="btn-loading d-none">
                                    <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                </span>
                            </button>
                        </div>

                        <!-- Additional Action -->
                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/booking/history" class="btn btn-outline-primary">
                                <i class="ri-calendar-check-line me-2"></i>
                                Xem Lịch Sử Đặt Chỗ
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Price Summary Sidebar -->
                <div>
                    <div class="price-summary">
                        <h4 class="text-center mb-4">
                            <i class="ri-calculator-line me-2"></i>Tóm tắt giá
                        </h4>

                        <!-- Experience Pricing -->
                        <c:if test="${bookingType == 'experience'}">
                            <div class="price-row">
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty experience}">
                                            <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ × ${formData.numberOfPeople} người
                                        </c:when>
                                        <c:otherwise>
                                            Giá cơ bản × ${formData.numberOfPeople} người
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <span>
                                    <fmt:formatNumber value="${formData.totalPrice - (formData.totalPrice * 0.05)}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                </span>
                            </div>
                        </c:if>

                        <!-- Accommodation Pricing -->
                        <c:if test="${bookingType == 'accommodation'}">
                            <div class="price-row">
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty accommodation}">
                                            <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ × ${formData.numberOfNights} đêm × ${formData.roomQuantity} phòng
                                        </c:when>
                                        <c:otherwise>
                                            Giá phòng × ${formData.numberOfNights} đêm × ${formData.roomQuantity} phòng
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <span>
                                    <fmt:formatNumber value="${formData.totalPrice - (formData.totalPrice * 0.05)}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                </span>
                            </div>
                        </c:if>
                        <div class="price-row">
                            <span>Phí dịch vụ (5%)</span>
                            <span>
                                <fmt:formatNumber value="${formData.totalPrice * 0.05}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                            </span>
                        </div>

                        <div class="price-total">
                            <span>Tổng cộng</span>
                            <span>
                                <fmt:formatNumber value="${formData.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                            </span>
                        </div>
                    </div>

                    <!-- Security Information -->
                    <div class="security-info">
                        <h6>
                            <i class="ri-shield-check-line"></i>
                            Đặt chỗ an toàn & bảo mật
                        </h6>

                        <div class="security-features">
                            <div class="security-feature">
                                <i class="ri-check-line"></i>
                                <span>Bảo mật SSL</span>
                            </div>
                            <div class="security-feature">
                                <i class="ri-check-line"></i>
                                <span>Hủy miễn phí</span>
                            </div>
                            <div class="security-feature">
                                <i class="ri-check-line"></i>
                                <span>Hỗ trợ 24/7</span>
                            </div>
                            <div class="security-feature">
                                <i class="ri-check-line"></i>
                                <span>Xác minh host</span>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Support -->
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-3">
                            <i class="ri-customer-service-2-line me-2"></i>Cần hỗ trợ?
                        </h6>
                        <div class="d-grid gap-2">
                            <a href="tel:1900-1234" class="btn btn-outline-primary btn-sm">
                                <i class="ri-phone-line me-2"></i>Hotline: 1900 1234
                            </a>
                            <a href="mailto:support@vietculture.vn" class="btn btn-outline-primary btn-sm">
                                <i class="ri-mail-line me-2"></i>Email hỗ trợ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                // Payment method selection
                                const paymentMethods = document.querySelectorAll('.payment-method');
                                const paymentRadios = document.querySelectorAll('input[name="paymentMethod"]');
                                const cashPaymentBtn = document.getElementById('cashPaymentBtn');
                                const onlinePaymentBtn = document.getElementById('onlinePaymentBtn');

                                paymentMethods.forEach((method, index) => {
                                    method.addEventListener('click', function () {
                                        // Remove selected class from all methods
                                        paymentMethods.forEach(m => m.classList.remove('selected'));

                                        // Add selected class to clicked method
                                        this.classList.add('selected');

                                        // Check the radio button
                                        paymentRadios[index].checked = true;

                                        // Update button visibility
                                        updateButtonVisibility();
                                    });
                                });

                                function updateButtonVisibility() {
                                    const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                                    if (selectedMethod === 'cash') {
                                        cashPaymentBtn.style.display = 'block';
                                        onlinePaymentBtn.style.display = 'none';
                                    } else {
                                        cashPaymentBtn.style.display = 'none';
                                        onlinePaymentBtn.style.display = 'block';
                                    }
                                }

                                // Form submission functions
                                const confirmForm = document.getElementById('confirmForm');
                                const agreeTerms = document.getElementById('agreeTerms');

                                function validateForm() {
                                    if (!agreeTerms.checked) {
                                        alert('Vui lòng đồng ý với điều khoản sử dụng để tiếp tục.');
                                        return false;
                                    }
                                    return true;
                                }

                                function setFormAction(action) {
                                    // Validate form first
                                    if (!validateForm()) {
                                        return;
                                    }

                                    const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                                    // Validate payment method matches action
                                    if (action === 'payment' && selectedMethod !== 'online') {
                                        alert('Vui lòng chọn phương thức thanh toán online.');
                                        return;
                                    }
                                    if (action === 'confirm' && selectedMethod !== 'cash') {
                                        alert('Vui lòng chọn phương thức thanh toán tiền mặt.');
                                        return;
                                    }

                                    // Set the correct action
                                    if (action === 'payment') {
                                        document.getElementById('formAction').value = 'payos-payment';
                                    } else {
                                        document.getElementById('formAction').value = 'confirm';
                                    }

                                    // Show loading state
                                    showLoadingState(action === 'confirm' ? 'cashPaymentBtn' : 'onlinePaymentBtn');

                                    // Submit the form
                                    confirmForm.submit();
                                }

                                function showLoadingState(buttonId) {
                                    const btn = document.getElementById(buttonId);
                                    const btnText = btn.querySelector('.btn-text');
                                    const btnLoading = btn.querySelector('.btn-loading');

                                    btnText.classList.add('d-none');
                                    btnLoading.classList.remove('d-none');
                                    btn.disabled = true;
                                }

                                // Add click event listeners to buttons
                                document.addEventListener('DOMContentLoaded', function () {
                                    updateButtonVisibility();

                                    // Cash payment button
                                    cashPaymentBtn.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        setFormAction('confirm');
                                    });

                                    // Online payment button - Updated for PayOS
                                    onlinePaymentBtn.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        setFormAction('payment');
                                    });
                                });

                                // Auto-scroll to top on page load
                                window.addEventListener('load', function () {
                                    window.scrollTo(0, 0);
                                });
        </script>
    </body>
</html>
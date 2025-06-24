<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Chỗ | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <style>
            .toast-container {
                position: fixed;
                bottom: 20px;
                right: 20px;
                z-index: 9999;
            }

            .toast {
                background-color: var(--dark-color);
                color: white;
                padding: 15px 25px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
                transform: translateX(100%);
                opacity: 0;
                transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                min-width: 300px;
                max-width: 500px;
                word-wrap: break-word;
                z-index: 10000;
            }

            .toast.show {
                transform: translateX(0);
                opacity: 1;
            }

            .toast.error {
                background-color: #dc3545;
                border-left: 4px solid #FF385C;
            }

            .toast.success {
                background-color: var(--dark-color);
                border-left: 4px solid #4BB543;
            }

            .toast.info {
                background-color: #17a2b8;
                border-left: 4px solid #3498db;
            }

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

            .btn {
                border-radius: 30px;
                padding: 12px 24px;
                font-weight: 500;
                transition: var(--transition);
            }

            .btn-primary {
                background: var(--gradient-primary);
                border: none;
                color: white;
                box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            }

            .btn-outline-primary {
                color: var(--primary-color);
                border: 2px solid var(--primary-color);
                background: transparent;
                transition: var(--transition);
            }

            .btn-outline-primary:hover {
                background: var(--primary-color);
                color: white;
                transform: translateY(-3px);
            }

            /* Modern Navbar */
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
                transition: var(--transition);
            }

            .custom-navbar.scrolled {
                padding: 10px 0;
                background-color: #10466C;
                box-shadow: var(--shadow-md);
            }

            .custom-navbar .container {
                display: flex;
                justify-content: space-between;
                align-items: center;
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
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
                object-fit: contain !important;
                display: inline-block !important;
            }

            .nav-center {
                display: flex;
                align-items: center;
                gap: 40px;
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
            }

            .nav-center-item {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
                font-weight: 500;
                transition: var(--transition);
            }

            .nav-center-item:hover {
                color: white;
            }

            .nav-center-item.active {
                color: var(--primary-color);
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 24px;
            }

            .nav-right a {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
            }

            .nav-right a:hover {
                color: var(--primary-color);
                background-color: rgba(255, 56, 92, 0.08);
            }

            .dropdown-menu-custom {
                position: absolute;
                top: 100%;
                right: 0;
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                width: 250px;
                padding: 15px;
                display: none;
                z-index: 1000;
                margin-top: 10px;
                opacity: 0;
                transform: translateY(10px);
                transition: var(--transition);
                border: 1px solid rgba(0,0,0,0.1);
            }

            .dropdown-menu-custom.show {
                display: block;
                opacity: 1;
                transform: translateY(0);
                color: #10466C;
            }

            .dropdown-menu-custom a {
                display: flex;
                align-items: center;
                padding: 12px 15px;
                text-decoration: none;
                color: #10466C;
                transition: var(--transition);
                border-radius: 10px;
                margin-bottom: 5px;
            }

            .dropdown-menu-custom a:hover {
                background-color: rgba(16, 70, 108, 0.05);
                color: #10466C;
                transform: translateX(3px);
            }

            .dropdown-menu-custom a i {
                margin-right: 12px;
                font-size: 18px;
                color: #10466C;
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

            .booking-header {
                background: var(--light-color);
                padding: 30px 0;
                margin-bottom: 40px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .booking-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .booking-subtitle {
                color: #6c757d;
                font-size: 1.1rem;
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
                position: absolute;
                top: 100px;
                right: 20px;
                z-index: 1000;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .service-type-badge.experience {
                background: var(--gradient-primary);
                color: white;
            }

            .service-type-badge.accommodation {
                background: var(--gradient-secondary);
                color: white;
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 40px;
            }

            /* Booking Form */
            .booking-form-card {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                height: fit-content;
            }

            .form-section {
                margin-bottom: 30px;
                padding-bottom: 25px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .form-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 20px;
                color: var(--dark-color);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .section-title i {
                color: var(--primary-color);
                font-size: 1.2rem;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
                display: block;
            }

            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid rgba(0,0,0,0.1);
                border-radius: 10px;
                font-size: 1rem;
                transition: var(--transition);
                background: white;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .form-select {
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 16px;
                padding-right: 40px;
            }

            .form-text {
                font-size: 0.875rem;
                color: #6c757d;
                margin-top: 5px;
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

            /* Service Summary */
            .service-summary {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                margin-bottom: 30px;
            }

            .service-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
            }

            .service-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 10px;
                color: var(--dark-color);
            }

            .service-details {
                display: flex;
                flex-direction: column;
                gap: 8px;
                margin-bottom: 15px;
            }

            .service-detail {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.9rem;
                color: #6c757d;
            }

            .service-detail i {
                color: var(--primary-color);
                font-size: 1rem;
            }

            .price-display {
                background: rgba(255, 56, 92, 0.1);
                padding: 15px;
                border-radius: 10px;
                text-align: center;
            }

            .price-display.accommodation {
                background: rgba(131, 197, 190, 0.1);
            }

            .price-amount {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 5px;
            }

            .price-amount.accommodation {
                color: var(--secondary-color);
            }

            .price-unit {
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Booking Summary */
            .booking-summary {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                border: 2px solid var(--primary-color);
            }

            .booking-summary.accommodation {
                border-color: var(--secondary-color);
            }

            .summary-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 20px;
                color: var(--dark-color);
                text-align: center;
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
                border-top: 1px solid rgba(0,0,0,0.2);
                padding-top: 15px;
                margin-top: 15px;
            }

            /* Error Messages */
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

            /* Footer */
            .footer {
                background-color: var(--dark-color);
                color: var(--light-color);
                padding: 80px 0 40px;
                position: relative;
                margin-top: 80px;
            }

            .footer::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100px;
                background: linear-gradient(to bottom, var(--accent-color), transparent);
                opacity: 0.1;
            }

            .footer h5 {
                font-size: 1.3rem;
                margin-bottom: 25px;
                position: relative;
                display: inline-block;
            }

            .footer h5::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                width: 40px;
                height: 3px;
                background: var(--gradient-primary);
                border-radius: 3px;
            }

            .footer p {
                color: rgba(255,255,255,0.7);
                margin-bottom: 15px;
            }

            .footer a {
                color: var(--secondary-color);
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
                margin-bottom: 10px;
            }

            .footer a:hover {
                color: var(--primary-color);
                transform: translateX(3px);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .booking-title {
                    font-size: 2rem;
                }

                .nav-center {
                    position: relative;
                    left: 0;
                    transform: none;
                    margin-top: 20px;
                    justify-content: center;
                }

                .custom-navbar .container {
                    flex-direction: column;
                }

                .service-type-badge {
                    position: relative;
                    top: auto;
                    right: auto;
                    margin-bottom: 20px;
                }
            }

            @media (max-width: 768px) {
                .booking-title {
                    font-size: 1.7rem;
                }

                .booking-form-card,
                .service-summary,
                .booking-summary {
                    padding: 20px;
                }

                .custom-navbar {
                    padding: 10px 0;
                }
            }

            /* Loading State */
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

            /* Animation */
            .fade-up {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.8s ease-out;
            }

            .fade-up.active {
                opacity: 1;
                transform: translateY(0);
            }

            /* Prefilled Form Highlight */
            .form-control.prefilled {
                background-color: rgba(131, 197, 190, 0.1);
                border-color: var(--secondary-color);
            }

            .prefilled-notice {
                background: rgba(131, 197, 190, 0.1);
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border-left: 4px solid var(--secondary-color);
            }

            .prefilled-notice i {
                color: var(--secondary-color);
                margin-right: 8px;
            }
        </style>
    </head>
    <body>
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

        <!-- Navigation -->
        <nav class="custom-navbar">
            <div class="container">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                    <span>VIETCULTURE</span>
                </a>

                <div class="nav-center">
                    <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                        Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item ${bookingType == 'experience' ? 'active' : ''}">
                        Trải Nghiệm
                    </a>
                    <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item ${bookingType == 'accommodation' ? 'active' : ''}">
                        Lưu Trú
                    </a>
                </div>

                <div class="nav-right">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                                    <i class="ri-user-line" style="color: white;"></i> 
                                    ${sessionScope.user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                                <i class="ri-dashboard-line"></i> Quản Trị
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:if test="${sessionScope.user.role == 'HOST'}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/dashboard">
                                                <i class="ri-dashboard-line"></i> Quản Lý Host
                                            </a>
                                        </li>
                                    </c:if>

                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="color: #10466C;">
                                            <i class="ri-user-settings-line" style="color: #10466C;"></i> Hồ Sơ
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color: #10466C;">
                                            <i class="ri-logout-circle-r-line" style="color: #10466C;"></i> Đăng Xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="#become-host" class="me-3">Trở thành host</a>
                            <i class="ri-global-line globe-icon me-3"></i>
                            <div class="menu-icon">
                                <i class="ri-menu-line"></i>
                                <div class="dropdown-menu-custom">
                                    <a href="#help-center">
                                        <i class="ri-question-line" style="color: #10466C;"></i>Trung tâm Trợ giúp
                                    </a>
                                    <a href="#contact">
                                        <i class="ri-contacts-line" style="color: #10466C;"></i>Liên Hệ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                        <i class="ri-login-circle-line" style="color: #10466C;"></i> Đăng Nhập
                                    </a>
                                    <a href="${pageContext.request.contextPath}/register">
                                        <i class="ri-user-add-line" style="color: #10466C;"></i>Đăng Ký
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
                        <li class="breadcrumb-item active" aria-current="page">Đặt Chỗ</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Header -->
        <div class="booking-header">
            <div class="container">
                <h1 class="booking-title">Đặt chỗ của bạn</h1>
                <p class="booking-subtitle">
                    <c:choose>
                        <c:when test="${bookingType == 'experience'}">
                            Hoàn tất thông tin để đặt trải nghiệm "${experience.title}"
                        </c:when>
                        <c:when test="${bookingType == 'accommodation'}">
                            Hoàn tất thông tin để đặt chỗ lưu trú "${accommodation.name}"
                        </c:when>
                        <c:otherwise>
                            Hoàn tất thông tin để đặt chỗ
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container main-content">
            <div class="content-grid fade-up">
                <!-- Booking Form -->
                <div class="booking-form-card">
                    <!-- Prefilled Data Notice -->
                    <c:if test="${not empty param.checkIn or not empty param.checkOut or not empty param.guests or not empty param.bookingDate or not empty param.participants or not empty param.timeSlot}">
                        <div class="prefilled-notice">
                            <i class="ri-information-line"></i>
                            <strong>Thông tin được điền sẵn:</strong> Chúng tôi đã điền sẵn một số thông tin từ lựa chọn trước đó của bạn. Bạn có thể chỉnh sửa nếu cần.
                        </div>
                    </c:if>

                    <!-- Error Messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <i class="ri-error-warning-line me-2"></i>
                            ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm">
                        <!-- Hidden Fields -->
                        <c:if test="${bookingType == 'experience'}">
                            <input type="hidden" name="experienceId" value="${experience.experienceId}">
                        </c:if>
                        <c:if test="${bookingType == 'accommodation'}">
                            <input type="hidden" name="accommodationId" value="${accommodation.accommodationId}">
                        </c:if>

                        <!-- Booking Details Section - Dynamic based on booking type -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <c:choose>
                                    <c:when test="${bookingType == 'experience'}">
                                        <i class="ri-calendar-line"></i>
                                        Chi tiết đặt trải nghiệm
                                    </c:when>
                                    <c:when test="${bookingType == 'accommodation'}">
                                        <i class="ri-hotel-line"></i>
                                        Chi tiết đặt phòng
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ri-calendar-line"></i>
                                        Chi tiết đặt chỗ
                                    </c:otherwise>
                                </c:choose>
                            </h3>

                            <!-- Experience Form Fields -->
                            <c:if test="${bookingType == 'experience'}">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="bookingDate" class="form-label">
                                                Ngày tham gia <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control ${not empty param.bookingDate or not empty formData.bookingDateStr ? 'prefilled' : ''}" 
                                                   id="bookingDate" 
                                                   name="bookingDate" 
                                                   value="${not empty param.bookingDate ? param.bookingDate : (not empty formData ? formData.bookingDateStr : '')}" 
                                                   required>
                                            <div class="form-text">Chọn ngày bạn muốn tham gia</div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="timeSlot" class="form-label">
                                                Khung giờ <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-control form-select ${not empty param.timeSlot or not empty formData.timeSlot ? 'prefilled' : ''}" 
                                                    id="timeSlot" 
                                                    name="timeSlot" 
                                                    required>
                                                <option value="">Chọn khung giờ</option>
                                                <option value="morning" ${param.timeSlot == 'morning' or (not empty formData and formData.timeSlot == 'morning') ? 'selected' : ''}>
                                                    Buổi sáng (9:00 - 12:00)
                                                </option>
                                                <option value="afternoon" ${param.timeSlot == 'afternoon' or (not empty formData and formData.timeSlot == 'afternoon') ? 'selected' : ''}>
                                                    Buổi chiều (14:00 - 17:00)
                                                </option>
                                                <option value="evening" ${param.timeSlot == 'evening' or (not empty formData and formData.timeSlot == 'evening') ? 'selected' : ''}>
                                                    Buổi tối (18:00 - 21:00)
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="participants" class="form-label">
                                        Số người tham gia <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-control form-select ${not empty param.participants or not empty formData.participantsStr ? 'prefilled' : ''}" 
                                            id="participants" 
                                            name="participants" 
                                            required>
                                        <option value="">Chọn số người</option>
                                        <c:forEach begin="1" end="${not empty experience ? experience.maxGroupSize : 10}" var="i">
                                            <option value="${i}" ${param.participants == i or (not empty formData and formData.participantsStr == i) ? 'selected' : ''}>
                                                ${i} người
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </c:if>

                            <!-- Accommodation Form Fields -->
                            <c:if test="${bookingType == 'accommodation'}">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="checkIn" class="form-label">
                                                Ngày nhận phòng <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control ${not empty param.checkIn or not empty formData.checkInDateStr ? 'prefilled' : ''}" 
                                                   id="checkIn" 
                                                   name="checkIn" 
                                                   value="${not empty param.checkIn ? param.checkIn : (not empty formData ? formData.checkInDateStr : '')}" 
                                                   required>
                                            <div class="form-text">Chọn ngày nhận phòng (14:00)</div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="checkOut" class="form-label">
                                                Ngày trả phòng <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control ${not empty param.checkOut or not empty formData.checkOutDateStr ? 'prefilled' : ''}" 
                                                   id="checkOut" 
                                                   name="checkOut" 
                                                   value="${not empty param.checkOut ? param.checkOut : (not empty formData ? formData.checkOutDateStr : '')}" 
                                                   required>
                                            <div class="form-text">Chọn ngày trả phòng (12:00)</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="guests" class="form-label">
                                                Số khách <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-control form-select ${not empty param.guests or not empty formData.guestsStr ? 'prefilled' : ''}" 
                                                    id="guests" 
                                                    name="guests" 
                                                    required>
                                                <option value="">Chọn số khách</option>
                                                <c:forEach begin="1" end="20" var="i">
                                                    <option value="${i}" ${param.guests == i or (not empty formData and formData.guestsStr == i) ? 'selected' : ''}>
                                                        ${i} khách
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="roomType" class="form-label">
                                                Loại phòng (tùy chọn)
                                            </label>
                                            <select class="form-control form-select ${not empty param.roomType or not empty formData.roomType ? 'prefilled' : ''}" 
                                                    id="roomType" 
                                                    name="roomType">
                                                <option value="">Chọn loại phòng</option>
                                                <option value="standard" ${param.roomType == 'standard' or (not empty formData and formData.roomType == 'standard') ? 'selected' : ''}>
                                                    Phòng tiêu chuẩn
                                                </option>
                                                <option value="deluxe" ${param.roomType == 'deluxe' or (not empty formData and formData.roomType == 'deluxe') ? 'selected' : ''}>
                                                    Phòng cao cấp
                                                </option>
                                                <option value="suite" ${param.roomType == 'suite' or (not empty formData and formData.roomType == 'suite') ? 'selected' : ''}>
                                                    Phòng suite
                                                </option>
                                            </select>
                                            <div class="form-text">Chọn loại phòng theo sở thích</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Contact Information Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="ri-user-line"></i>
                                Thông tin liên hệ
                            </h3>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="contactName" class="form-label">
                                            Họ và tên <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="contactName" name="contactName" 
                                               value="${not empty formData && not empty formData.contactName ? formData.contactName : (not empty sessionScope.user ? sessionScope.user.fullName : '')}" 
                                               required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="contactEmail" class="form-label">
                                            Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="contactEmail" name="contactEmail" 
                                               value="${not empty formData && not empty formData.contactEmail ? formData.contactEmail : (not empty sessionScope.user ? sessionScope.user.email : '')}" 
                                               required>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="contactPhone" class="form-label">
                                    Số điện thoại <span class="text-danger">*</span>
                                </label>
                                <input type="tel" class="form-control" id="contactPhone" name="contactPhone" 
                                       value="${not empty formData && not empty formData.contactPhone ? formData.contactPhone : ''}" 
                                       placeholder="0123 456 789" required>
                            </div>
                        </div>

                        <!-- Special Requests Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="ri-message-3-line"></i>
                                Yêu cầu đặc biệt
                            </h3>

                            <div class="form-group">
                                <label for="specialRequests" class="form-label">Ghi chú (tùy chọn)</label>
                                <textarea class="form-control" id="specialRequests" name="specialRequests" 
                                          rows="3" placeholder="Chia sẻ bất kỳ yêu cầu đặc biệt nào...">${not empty formData && not empty formData.specialRequests ? formData.specialRequests : ''}</textarea>
                                <div class="form-text">
                                    <c:choose>
                                        <c:when test="${bookingType == 'experience'}">
                                            Ví dụ: dị ứng thực phẩm, yêu cầu hỗ trợ di chuyển, ngôn ngữ ưa thích...
                                        </c:when>
                                        <c:when test="${bookingType == 'accommodation'}">
                                            Ví dụ: giường đôi/đơn, tầng cao, view biển, đón/tiễn sân bay...
                                        </c:when>
                                        <c:otherwise>
                                            Ví dụ: yêu cầu đặc biệt về ăn uống, di chuyển...
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                                <i class="ri-arrow-left-line me-2"></i>Quay Lại
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <span class="btn-text">
                                    <i class="ri-arrow-right-line me-2"></i>Tiếp Tục
                                </span>
                                <span class="btn-loading d-none">
                                    <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                </span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Sidebar -->
                <div>
                    <!-- Service Summary -->
                    <div class="service-summary">
                        <!-- Experience Summary -->
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

                            <h4 class="service-title">${experience.title}</h4>

                            <div class="service-details">
                                <div class="service-detail">
                                    <i class="ri-map-pin-line"></i>
                                    <span>${experience.location}</span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-group-line"></i>
                                    <span>Tối đa ${experience.maxGroupSize} người</span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-time-line"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty experience.duration}">
                                                <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                            </c:when>
                                            <c:otherwise>
                                                Cả ngày
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-user-star-line"></i>
                                    <span>Hướng dẫn viên ${experience.hostName}</span>
                                </div>
                            </div>

                            <div class="price-display">
                                <div class="price-amount">
                                    <c:choose>
                                        <c:when test="${experience.price == 0}">
                                            Miễn phí
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="price-unit">mỗi người</div>
                            </div>
                        </c:if>

                        <!-- Accommodation Summary -->
                        <c:if test="${bookingType == 'accommodation'}">
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

                            <h4 class="service-title">${accommodation.name}</h4>

                            <div class="service-details">
                                <div class="service-detail">
                                    <i class="ri-map-pin-line"></i>
                                    <span>${accommodation.address}</span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-hotel-line"></i>
                                    <span>${accommodation.typeText}</span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-door-line"></i>
                                    <span>${accommodation.numberOfRooms} phòng</span>
                                </div>
                                <div class="service-detail">
                                    <i class="ri-user-star-line"></i>
                                    <span>Chủ nhà ${accommodation.hostName}</span>
                                </div>
                            </div>

                            <div class="price-display accommodation">
                                <div class="price-amount accommodation">
                                    <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                </div>
                                <div class="price-unit">mỗi đêm</div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Booking Summary -->
                    <div class="booking-summary ${bookingType == 'accommodation' ? 'accommodation' : ''}" id="bookingSummary" style="display: none;">
                        <h4 class="summary-title">Tóm tắt đặt chỗ</h4>

                        <!-- Experience Summary Items -->
                        <c:if test="${bookingType == 'experience'}">
                            <div class="summary-item">
                                <span>Ngày:</span>
                                <span id="summaryDate">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Thời gian:</span>
                                <span id="summaryTime">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Số người:</span>
                                <span id="summaryParticipants">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Giá × <span id="participantCount">0</span> người:</span>
                                <span id="basePrice">0 VNĐ</span>
                            </div>
                        </c:if>

                        <!-- Accommodation Summary Items -->
                        <c:if test="${bookingType == 'accommodation'}">
                            <div class="summary-item">
                                <span>Nhận phòng:</span>
                                <span id="summaryCheckIn">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Trả phòng:</span>
                                <span id="summaryCheckOut">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Số đêm:</span>
                                <span id="summaryNights">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Số khách:</span>
                                <span id="summaryGuests">-</span>
                            </div>

                            <div class="summary-item">
                                <span>Giá × <span id="nightCount">0</span> đêm:</span>
                                <span id="basePrice">0 VNĐ</span>
                            </div>
                        </c:if>

                        <!-- Common Summary Items -->
                        <div class="summary-item">
                            <span>Phí dịch vụ (5%):</span>
                            <span id="serviceFee">0 VNĐ</span>
                        </div>

                        <div class="summary-total">
                            <span>Tổng cộng:</span>
                            <span id="totalPrice">0 VNĐ</span>
                        </div>
                    </div>

                    <!-- Safety Info -->
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-3">
                            <i class="ri-shield-check-line me-2"></i>Cam kết an toàn
                        </h6>
                        <ul class="list-unstyled mb-0 small">
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Thanh toán được bảo mật
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                <c:choose>
                                    <c:when test="${bookingType == 'experience'}">
                                        Hướng dẫn viên đã xác minh
                                    </c:when>
                                    <c:when test="${bookingType == 'accommodation'}">
                                        Chủ nhà đã xác minh
                                    </c:when>
                                    <c:otherwise>
                                        Host đã xác minh
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Hỗ trợ khách hàng 24/7
                            </li>
                            <li>
                                <i class="ri-check-line text-success me-2"></i>
                                Chính sách hủy linh hoạt
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <h5>Về Chúng Tôi</h5>
                        <p>Kết nối du khách với những trải nghiệm văn hóa độc đáo và nơi lưu trú ấm cúng trên khắp Việt Nam. Chúng tôi mang đến những giá trị bền vững và góp phần phát triển du lịch cộng đồng.</p>
                        <div class="social-icons">
                            <a href="#"><i class="ri-facebook-fill"></i></a>
                            <a href="#"><i class="ri-instagram-fill"></i></a>
                            <a href="#"><i class="ri-twitter-fill"></i></a>
                            <a href="#"><i class="ri-youtube-fill"></i></a>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <h5>Liên Kết Nhanh</h5>
                        <ul class="list-unstyled">
                            <li><a href="${pageContext.request.contextPath}/"><i class="ri-arrow-right-s-line"></i> Trang Chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/experiences"><i class="ri-arrow-right-s-line"></i> Trải Nghiệm</a></li>
                            <li><a href="${pageContext.request.contextPath}/accommodations"><i class="ri-arrow-right-s-line"></i> Lưu Trú</a></li>
                            <li><a href="#regions"><i class="ri-arrow-right-s-line"></i> Vùng Miền</a></li>
                            <li><a href="#become-host"><i class="ri-arrow-right-s-line"></i> Trở Thành Host</a></li>
                        </ul>
                    </div>
                    <div class="col-md-2 mb-4">
                        <h5>Hỗ Trợ</h5>
                        <ul class="list-unstyled">
                            <li><a href="#"><i class="ri-question-line"></i> Trung tâm hỗ trợ</a></li>
                            <li><a href="#"><i class="ri-money-dollar-circle-line"></i> Chính sách giá</a></li>
                            <li><a href="#"><i class="ri-file-list-line"></i> Điều khoản</a></li>
                            <li><a href="#"><i class="ri-shield-check-line"></i> Bảo mật</a></li>
                        </ul>
                    </div>
                    <div class="col-md-3 mb-4">
                        <h5>Liên Hệ</h5>
                        <p><i class="ri-map-pin-line me-2"></i> 123 Đường ABC, Quận XYZ, Hà Nội</p>
                        <p><i class="ri-mail-line me-2"></i> info@vietculture.vn</p>
                        <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                        <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                    </div>
                </div>
                <div class="copyright">
                    <p>© 2025 VietCulture. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </footer>

        <!-- Toast Notification Container -->
        <div class="toast-container"></div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Enhanced booking form with proper service type detection
            document.addEventListener('DOMContentLoaded', function () {
                // Initialize all components
                initializeDropdownMenu();
                initializeNavbarScroll();
                initializeFormComponents();
                initializeAutoFill();
                initializeFormValidation();
                initializeTooltips();

                // Initial setup
                setTimeout(() => {
                    animateOnScroll();
                    updateSummary();
                    showPrefilledIndicator();
                }, 100);
            });

            // =============================================================================
            // DROPDOWN MENU & NAVBAR FUNCTIONALITY
            // =============================================================================

            function initializeDropdownMenu() {
                const menuIcon = document.querySelector('.menu-icon');
                const dropdownMenu = document.querySelector('.dropdown-menu-custom');

                if (menuIcon && dropdownMenu) {
                    menuIcon.addEventListener('click', function (e) {
                        e.stopPropagation();
                        dropdownMenu.classList.toggle('show');
                    });

                    document.addEventListener('click', function () {
                        dropdownMenu.classList.remove('show');
                    });

                    dropdownMenu.addEventListener('click', function (e) {
                        e.stopPropagation();
                    });
                }
            }

            function initializeNavbarScroll() {
                window.addEventListener('scroll', function () {
                    const navbar = document.querySelector('.custom-navbar');
                    if (navbar) {
                        if (window.scrollY > 50) {
                            navbar.classList.add('scrolled');
                        } else {
                            navbar.classList.remove('scrolled');
                        }
                    }
                    animateOnScroll();
                });
            }

            // =============================================================================
            // ANIMATION FUNCTIONALITY
            // =============================================================================

            function animateOnScroll() {
                const fadeElements = document.querySelectorAll('.fade-up');

                fadeElements.forEach(element => {
                    const elementTop = element.getBoundingClientRect().top;
                    const elementVisible = 150;

                    if (elementTop < window.innerHeight - elementVisible) {
                        element.classList.add('active');
                    }
                });
            }

            // =============================================================================
            // SERVICE TYPE DETECTION
            // =============================================================================

            function detectServiceType() {
                // Check server-side bookingType first
                const bookingTypeBadge = document.querySelector('.service-type-badge');
                if (bookingTypeBadge) {
                    if (bookingTypeBadge.classList.contains('experience')) {
                        return 'experience';
                    } else if (bookingTypeBadge.classList.contains('accommodation')) {
                        return 'accommodation';
                    }
                }

                // Check if form fields exist
                const experienceFields = document.querySelector('#bookingDate, #timeSlot, #participants');
                const accommodationFields = document.querySelector('#checkIn, #checkOut, #guests');

                if (accommodationFields) {
                    return 'accommodation';
                } else if (experienceFields) {
                    return 'experience';
                }

                // Check hidden inputs
                const experienceId = document.querySelector('input[name="experienceId"]');
                const accommodationId = document.querySelector('input[name="accommodationId"]');

                if (experienceId && experienceId.value) {
                    return 'experience';
                } else if (accommodationId && accommodationId.value) {
                    return 'accommodation';
                }

                return 'experience'; // default fallback
            }

            // =============================================================================
            // FORM INITIALIZATION
            // =============================================================================

            function initializeFormComponents() {
                const serviceType = detectServiceType();
                console.log('Detected service type:', serviceType);

                // Get price based on service type
                const pricePerUnit = getPriceForServiceType(serviceType);

                // Cache form elements
                const formElements = getFormElements(serviceType);

                // Set minimum dates
                setMinimumDates(formElements);

                // Add event listeners based on service type
                if (serviceType === 'experience') {
                    initializeExperienceForm(formElements);
                } else if (serviceType === 'accommodation') {
                    initializeAccommodationForm(formElements);
                }

                // Common event listeners
                addCommonEventListeners(formElements);

                // Store elements globally for other functions
                window.formElements = formElements;
                window.pricePerUnit = pricePerUnit;
                window.serviceType = serviceType;
            }

            function getFormElements(serviceType) {
                const common = {
                    bookingForm: document.getElementById('bookingForm'),
                    submitBtn: document.getElementById('submitBtn'),
                    bookingSummary: document.getElementById('bookingSummary')
                };

                if (serviceType === 'experience') {
                    return {
                        ...common,
                        bookingDateInput: document.getElementById('bookingDate'),
                        timeSlotSelect: document.getElementById('timeSlot'),
                        participantsSelect: document.getElementById('participants')
                    };
                } else if (serviceType === 'accommodation') {
                    return {
                        ...common,
                        checkInInput: document.getElementById('checkIn'),
                        checkOutInput: document.getElementById('checkOut'),
                        guestsSelect: document.getElementById('guests'),
                        roomTypeSelect: document.getElementById('roomType')
                    };
                }

                return common;
            }

            function getPriceForServiceType(serviceType) {
                // Try to get price from service summary price display
                const priceAmount = document.querySelector('.price-amount');
                if (priceAmount) {
                    const priceText = priceAmount.textContent.replace(/[^\d]/g, '');
                    if (priceText) {
                        return parseInt(priceText);
                    }
                }

                // Fallback default prices
                return serviceType === 'accommodation' ? 700000 : 70000;
            }

            function setMinimumDates(elements) {
                const today = new Date().toISOString().split('T')[0];

                if (elements.bookingDateInput) {
                    elements.bookingDateInput.min = today;
                }

                if (elements.checkInInput) {
                    elements.checkInInput.min = today;
                }
            }

            function addCommonEventListeners(elements) {
                // Update summary when form changes
                const summaryTriggers = Object.values(elements).filter(el => 
                    el && (el.tagName === 'INPUT' || el.tagName === 'SELECT')
                );

                summaryTriggers.forEach(element => {
                    element.addEventListener('change', updateSummary);
                    element.addEventListener('input', updateSummary);
                });
            }

            // =============================================================================
            // SERVICE-SPECIFIC INITIALIZATION
            // =============================================================================

            function initializeExperienceForm(elements) {
                if (elements.timeSlotSelect) {
                    elements.timeSlotSelect.addEventListener('change', function () {
                        if (this.value) {
                            showToast('Đã chọn khung giờ: ' + getTimeSlotDisplayName(this.value), 'info');
                        }
                    });
                }

                if (elements.bookingDateInput) {
                    elements.bookingDateInput.addEventListener('change', function () {
                        validateExperienceDate(this.value);
                    });
                }
            }

            function initializeAccommodationForm(elements) {
                if (elements.checkInInput && elements.checkOutInput) {
                    elements.checkInInput.addEventListener('change', function () {
                        // Update checkout minimum date
                        const checkInDate = new Date(this.value);
                        checkInDate.setDate(checkInDate.getDate() + 1);
                        elements.checkOutInput.min = checkInDate.toISOString().split('T')[0];

                        // Auto-set checkout date if not set
                        if (!elements.checkOutInput.value && this.value) {
                            elements.checkOutInput.value = checkInDate.toISOString().split('T')[0];
                            elements.checkOutInput.classList.add('auto-filled');
                            showToast('Tự động đặt ngày trả phòng: ' + elements.checkOutInput.value, 'info');
                        }
                    });

                    elements.checkOutInput.addEventListener('change', function () {
                        validateAccommodationDates(elements.checkInInput.value, this.value);
                    });
                }
            }

            // =============================================================================
            // AUTO-FILL FUNCTIONALITY
            // =============================================================================

            function initializeAutoFill() {
                autoFillFormFromURL();
                autoFillFromLocalStorage();
                setupFormDataSaving();
            }

            function autoFillFormFromURL() {
                const urlParams = new URLSearchParams(window.location.search);

                // Experience parameters
                const dateParam = urlParams.get('date') || urlParams.get('bookingDate');
                const participantsParam = urlParams.get('participants');
                const timeSlotParam = urlParams.get('timeSlot');

                // Accommodation parameters
                const checkInParam = urlParams.get('checkIn');
                const checkOutParam = urlParams.get('checkOut');
                const guestsParam = urlParams.get('guests');

                // Fill fields
                fillField('bookingDate', dateParam);
                fillField('participants', participantsParam);
                fillField('timeSlot', timeSlotParam);
                fillField('checkIn', checkInParam);
                fillField('checkOut', checkOutParam);
                fillField('guests', guestsParam);
            }

            function fillField(fieldId, value) {
                if (!value) return;

                const field = document.getElementById(fieldId);
                if (field && !field.value) {
                    field.value = value;
                    field.classList.add('prefilled');
                }
            }

            function autoFillFromLocalStorage() {
                try {
                    const savedData = JSON.parse(localStorage.getItem('vietculture_booking_draft') || '{}');

                    if (savedData.timestamp) {
                        // Check if data is recent (within 1 hour)
                        const dataAge = Date.now() - savedData.timestamp;
                        if (dataAge > 3600000) { // 1 hour
                            localStorage.removeItem('vietculture_booking_draft');
                            return;
                        }

                        // Fill form fields
                        Object.keys(savedData).forEach(key => {
                            if (key === 'timestamp') return;

                            const element = document.getElementById(key) || document.querySelector(`[name="${key}"]`);
                            if (element && !element.classList.contains('prefilled')) {
                                element.value = savedData[key];
                                element.classList.add('from-storage');
                            }
                        });

                        console.log('Auto-filled from localStorage:', savedData);
                    }
                } catch (e) {
                    console.log('Error loading from localStorage:', e);
                    localStorage.removeItem('vietculture_booking_draft');
                }
            }

            function setupFormDataSaving() {
                const form = document.getElementById('bookingForm');
                if (!form) return;

                const inputs = form.querySelectorAll('input, select, textarea');

                inputs.forEach(input => {
                    input.addEventListener('change', saveFormDataToStorage);
                    input.addEventListener('blur', saveFormDataToStorage);
                });
            }

            function saveFormDataToStorage() {
                try {
                    const form = document.getElementById('bookingForm');
                    if (!form) return;

                    const formData = new FormData(form);
                    const data = { timestamp: Date.now() };

                    for (let [key, value] of formData.entries()) {
                        if (value && value.trim() !== '') {
                            data[key] = value;
                        }
                    }

                    localStorage.setItem('vietculture_booking_draft', JSON.stringify(data));
                } catch (e) {
                    console.log('Error saving to localStorage:', e);
                }
            }

            // =============================================================================
            // SUMMARY UPDATE FUNCTIONALITY
            // =============================================================================

            function updateSummary() {
                const serviceType = window.serviceType || detectServiceType();
                const elements = window.formElements;
                const bookingSummary = document.getElementById('bookingSummary');

                if (!bookingSummary) return;

                if (serviceType === 'experience') {
                    updateExperienceSummary(elements, bookingSummary);
                } else if (serviceType === 'accommodation') {
                    updateAccommodationSummary(elements, bookingSummary);
                }
            }

            function updateExperienceSummary(elements, bookingSummary) {
                const date = elements.bookingDateInput?.value;
                const timeSlot = elements.timeSlotSelect?.value;
                const participants = parseInt(elements.participantsSelect?.value) || 0;
                const pricePerPerson = window.pricePerUnit || 70000;

                if (date && timeSlot && participants && pricePerPerson > 0) {
                    bookingSummary.style.display = 'block';

                    // Update date
                    const dateObj = new Date(date);
                    const formattedDate = dateObj.toLocaleDateString('vi-VN', {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                    });

                    updateElement('summaryDate', formattedDate);
                    updateElement('summaryTime', getTimeSlotDisplayName(timeSlot));
                    updateElement('summaryParticipants', participants + ' người');
                    updateElement('participantCount', participants);

                    // Calculate prices
                    updatePriceCalculation(participants, pricePerPerson);
                } else {
                    bookingSummary.style.display = 'none';
                }
            }

            function updateAccommodationSummary(elements, bookingSummary) {
                const checkIn = elements.checkInInput?.value;
                const checkOut = elements.checkOutInput?.value;
                const guests = parseInt(elements.guestsSelect?.value) || 0;
                const pricePerNight = window.pricePerUnit || 700000;

                if (checkIn && checkOut && guests && pricePerNight > 0) {
                    const checkInDate = new Date(checkIn);
                    const checkOutDate = new Date(checkOut);
                    const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));

                    if (nights > 0) {
                        bookingSummary.style.display = 'block';

                        // Update dates and info
                        updateElement('summaryCheckIn', checkInDate.toLocaleDateString('vi-VN'));
                        updateElement('summaryCheckOut', checkOutDate.toLocaleDateString('vi-VN'));
                        updateElement('summaryNights', nights + ' đêm');
                        updateElement('summaryGuests', guests + ' khách');
                        updateElement('nightCount', nights);

                        // Calculate prices
                        updatePriceCalculation(nights, pricePerNight);
                    }
                } else {
                    bookingSummary.style.display = 'none';
                }
            }

            function updatePriceCalculation(quantity, unitPrice) {
                const basePrice = quantity * unitPrice;
                const serviceFee = Math.round(basePrice * 0.05);
                const totalPrice = basePrice + serviceFee;

                updateElement('basePrice', formatCurrency(basePrice));
                updateElement('serviceFee', formatCurrency(serviceFee));
                updateElement('totalPrice', formatCurrency(totalPrice));
            }

            function updateElement(id, value) {
                const element = document.getElementById(id);
                if (element) {
                    element.textContent = value;
                }
            }

            // =============================================================================
            // VALIDATION FUNCTIONALITY
            // =============================================================================

            function initializeFormValidation() {
                const bookingForm = document.getElementById('bookingForm');
                if (!bookingForm) return;

                bookingForm.addEventListener('submit', function (e) {
                    e.preventDefault();

                    // Validate form
                    if (!validateForm()) {
                        return;
                    }

                    // Add service type to form data
                    const serviceType = detectServiceType();
                    if (!this.querySelector('input[name="serviceType"]')) {
                        const serviceTypeInput = document.createElement('input');
                        serviceTypeInput.type = 'hidden';
                        serviceTypeInput.name = 'serviceType';
                        serviceTypeInput.value = serviceType;
                        this.appendChild(serviceTypeInput);
                    }

                    // Show loading state
                    showLoadingState();

                    // Clear localStorage on successful submission
                    localStorage.removeItem('vietculture_booking_draft');

                    // Submit form
                    setTimeout(() => {
                        this.submit();
                    }, 500);
                });
            }

            function validateForm() {
                const serviceType = window.serviceType || detectServiceType();

                if (serviceType === 'experience') {
                    return validateExperienceForm();
                } else if (serviceType === 'accommodation') {
                    return validateAccommodationForm();
                }

                return validateCommonFields();
            }

            function validateExperienceForm() {
                const elements = window.formElements;
                const date = elements.bookingDateInput?.value;
                const timeSlot = elements.timeSlotSelect?.value;
                const participants = elements.participantsSelect?.value;

                if (!date || !timeSlot || !participants) {
                    showToast('Vui lòng điền đầy đủ thông tin về trải nghiệm.', 'error');
                    return false;
                }

                if (!validateExperienceDate(date)) {
                    return false;
                }

                return validateCommonFields();
            }

            function validateAccommodationForm() {
                const elements = window.formElements;
                const checkIn = elements.checkInInput?.value;
                const checkOut = elements.checkOutInput?.value;
                const guests = elements.guestsSelect?.value;

                if (!checkIn || !checkOut || !guests) {
                    showToast('Vui lòng điền đầy đủ thông tin về lưu trú.', 'error');
                    return false;
                }

                if (!validateAccommodationDates(checkIn, checkOut)) {
                    return false;
                }

                return validateCommonFields();
            }

            function validateCommonFields() {
                const contactName = document.getElementById('contactName')?.value;
                const contactEmail = document.getElementById('contactEmail')?.value;
                const contactPhone = document.getElementById('contactPhone')?.value;

                if (!contactName || !contactEmail || !contactPhone) {
                    showToast('Vui lòng điền đầy đủ thông tin liên hệ.', 'error');
                    return false;
                }

                // Validate email
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(contactEmail)) {
                    showToast('Địa chỉ email không hợp lệ.', 'error');
                    return false;
                }

                // Validate phone
                const phoneRegex = /^0\d{9}$/;
                if (!phoneRegex.test(contactPhone.replace(/\s/g, ''))) {
                    showToast('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 chữ số, bắt đầu bằng 0).', 'error');
                    return false;
                }

                return true;
            }

            function validateExperienceDate(dateStr) {
                if (!dateStr) return false;

                const selectedDate = new Date(dateStr);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (selectedDate < today) {
                    showToast('Ngày tham gia không thể là ngày trong quá khứ!', 'error');
                    return false;
                }

                // Check if date is too far in the future (optional)
                const maxDate = new Date();
                maxDate.setMonth(maxDate.getMonth() + 6);

                if (selectedDate > maxDate) {
                    showToast('Chỉ có thể đặt trước tối đa 6 tháng!', 'error');
                    return false;
                }

                return true;
            }

            function validateAccommodationDates(checkInStr, checkOutStr) {
                if (!checkInStr || !checkOutStr) return false;

                const checkInDate = new Date(checkInStr);
                const checkOutDate = new Date(checkOutStr);

                if (checkOutDate <= checkInDate) {
                    showToast('Ngày trả phòng phải sau ngày nhận phòng!', 'error');
                    return false;
                }

                // Calculate nights
                const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
                if (nights > 30) {
                    showToast('Chỉ có thể đặt tối đa 30 đêm!', 'error');
                    return false;
                }

                return true;
            }

            // =============================================================================
            // UTILITY FUNCTIONS
            // =============================================================================

            function getTimeSlotDisplayName(timeSlot) {
                const timeSlotNames = {
                    'morning': 'Buổi sáng (9:00 - 12:00)',
                    'afternoon': 'Buổi chiều (14:00 - 17:00)',
                    'evening': 'Buổi tối (18:00 - 21:00)'
                };
                return timeSlotNames[timeSlot] || timeSlot;
            }

            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
            }

            function showLoadingState() {
                const submitBtn = document.getElementById('submitBtn');
                if (!submitBtn) return;

                const btnText = submitBtn.querySelector('.btn-text');
                const btnLoading = submitBtn.querySelector('.btn-loading');

                if (btnText && btnLoading) {
                    btnText.classList.add('d-none');
                    btnLoading.classList.remove('d-none');
                }

                submitBtn.disabled = true;
            }

            function showToast(message, type = 'success') {
                const toastContainer = document.querySelector('.toast-container');
                if (!toastContainer) {
                    console.error('Toast container not found');
                    return;
                }

                const toast = document.createElement('div');
                toast.className = 'toast';

                let icon, iconColor;
                switch (type) {
                    case 'error':
                        icon = 'ri-error-warning-line';
                        iconColor = '#FF385C';
                        break;
                    case 'info':
                        icon = 'ri-information-line';
                        iconColor = '#3498db';
                        break;
                    default:
                        icon = 'ri-check-line';
                        iconColor = '#4BB543';
                }

                toast.innerHTML = `
                    <i class="${icon}" style="color: ${iconColor}; font-size: 1.2rem; margin-right: 10px;"></i>
                    <span>${message}</span>
                `;

                // Add toast to container
                toastContainer.appendChild(toast);

                // Force reflow
                toast.offsetHeight;

                // Show toast
                setTimeout(() => {
                    toast.classList.add('show');
                }, 10);

                // Hide and remove toast
                const duration = type === 'error' ? 4000 : 3000;
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => {
                        if (toastContainer.contains(toast)) {
                            toastContainer.removeChild(toast);
                        }
                    }, 500);
                }, duration);
            }

            function showPrefilledIndicator() {
                const prefilledFields = document.querySelectorAll('.prefilled');
                if (prefilledFields.length > 0) {
                    setTimeout(() => {
                        showToast(`Đã điền sẵn ${prefilledFields.length} trường từ lựa chọn trước đó`, 'info');
                    }, 1000);
                }
            }

            function initializeTooltips() {
                // Initialize Bootstrap tooltips if available
                if (typeof bootstrap !== 'undefined') {
                    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                    tooltipTriggerList.map(function (tooltipTriggerEl) {
                        return new bootstrap.Tooltip(tooltipTriggerEl);
                    });
                }
            }

            console.log('Enhanced booking form script loaded successfully');
        </script>
    </body>
</html>
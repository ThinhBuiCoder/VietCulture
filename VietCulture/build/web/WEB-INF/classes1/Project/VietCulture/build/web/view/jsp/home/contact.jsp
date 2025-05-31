<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên Hệ - VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <style>
            /* Sử dụng CSS từ home.jsp */
            .dropdown-item {
                color: #10466C;
            }

            .dropdown-item i {
                color: #10466C;
            }
            
            .navbar-brand img {
                height: 50px !important;
                width: auto !important;
                margin-right: 12px !important;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
                object-fit: contain !important;
                display: inline-block !important;
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

            .nav-right .globe-icon {
                font-size: 20px;
                cursor: pointer;
                transition: var(--transition);
            }

            .nav-right .globe-icon:hover {
                color: var(--primary-color);
                transform: rotate(15deg);
            }

            .nav-right .menu-icon {
                border: 1px solid rgba(255,255,255,0.2);
                padding: 8px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: var(--transition);
                box-shadow: var(--shadow-sm);
                position: relative;
                background-color: rgba(255,255,255,0.1);
                color: white;
            }

            .nav-right .menu-icon:hover {
                background: rgba(255,255,255,0.2);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .nav-right .menu-icon i {
                color: white;
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

            /* Contact Specific Styles */
            .contact-hero {
                background: linear-gradient(rgba(16, 70, 108, 0.8), rgba(131, 197, 190, 0.8)),
                    url('https://images.unsplash.com/photo-1423666639041-f56000c27a9a?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80') no-repeat center/cover;
                color: var(--light-color);
                padding: 100px 0;
                text-align: center;
                margin-bottom: 50px;
            }

            .contact-hero h1 {
                font-size: 3.5rem;
                margin-bottom: 20px;
                font-weight: 800;
                text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            }

            .contact-hero p {
                font-size: 1.3rem;
                max-width: 600px;
                margin: 0 auto;
                text-shadow: 0 1px 5px rgba(0,0,0,0.2);
            }

            .contact-info-card {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 40px;
                box-shadow: var(--shadow-md);
                transition: var(--transition);
                height: 100%;
            }

            .contact-info-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
            }

            .contact-icon {
                width: 80px;
                height: 80px;
                background: var(--gradient-primary);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                color: white;
                font-size: 2rem;
            }

            .contact-form {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 40px;
                box-shadow: var(--shadow-md);
                transition: var(--transition);
            }

            .contact-form:hover {
                box-shadow: var(--shadow-lg);
            }

            .form-control {
                border-radius: 10px;
                padding: 15px;
                border: 2px solid rgba(0,0,0,0.1);
                transition: var(--transition);
                font-size: 1rem;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .form-label {
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 8px;
            }

            /* Google Map Styles */
            .map-section {
                padding: 80px 0;
                background-color: var(--light-color);
            }

            .map-container {
                position: relative;
                background: white;
                border-radius: var(--border-radius);
                overflow: hidden;
                box-shadow: var(--shadow-lg);
                margin-bottom: 50px;
            }

            .map-iframe {
                width: 100%;
                height: 450px;
                border: none;
                border-radius: var(--border-radius);
            }

            .map-overlay {
                position: absolute;
                top: 20px;
                left: 20px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                max-width: 300px;
            }

            .map-overlay h5 {
                color: var(--dark-color);
                margin-bottom: 10px;
                font-weight: 700;
            }

            .map-overlay p {
                color: #6c757d;
                margin-bottom: 5px;
                font-size: 0.9rem;
            }

            .office-hours {
                background: var(--accent-color);
                border-radius: var(--border-radius);
                padding: 30px;
                margin-top: 30px;
            }

            .office-hours h4 {
                color: var(--dark-color);
                margin-bottom: 20px;
                text-align: center;
            }

            .hours-list {
                list-style: none;
                padding: 0;
            }

            .hours-list li {
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .hours-list li:last-child {
                border-bottom: none;
            }

            /* Footer styles từ home.jsp */
            .footer {
                background-color: var(--dark-color);
                color: var(--light-color);
                padding: 80px 0 40px;
                position: relative;
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

            .footer .list-unstyled li {
                margin-bottom: 15px;
            }

            .footer .social-icons {
                display: flex;
                gap: 15px;
                margin-top: 20px;
            }

            .footer .social-icons a {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background-color: rgba(255,255,255,0.1);
                border-radius: 50%;
                transition: var(--transition);
            }

            .footer .social-icons a:hover {
                background-color: var(--primary-color);
                transform: translateY(-5px);
            }

            .footer .social-icons i {
                font-size: 1.2rem;
            }

            .footer .copyright {
                text-align: center;
                padding-top: 40px;
                margin-top: 40px;
                border-top: 1px solid rgba(255,255,255,0.1);
                color: rgba(255,255,255,0.5);
                font-size: 0.9rem;
            }

            /* Success Message */
            .success-card {
                border-left: 4px solid #28a745;
                animation: fadeInUp 0.6s ease-out;
            }

            .success-icon {
                width: 40px;
                height: 40px;
                background: #28a745;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2em;
            }

            @keyframes fadeInUp {
                from {
                    transform: translateY(30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            /* Responsive */
            @media (max-width: 768px) {
                .contact-hero h1 {
                    font-size: 2.5rem;
                }

                .contact-hero p {
                    font-size: 1.1rem;
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

                .nav-right {
                    margin-top: 15px;
                }

                .map-overlay {
                    position: relative;
                    top: 0;
                    left: 0;
                    margin-top: 20px;
                    max-width: none;
                }
            }
        </style>
    </head>
    <body>
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.contactMessage}">
            <div class="container mt-3">
                <div class="card border-0 shadow-sm success-card">
                    <div class="card-body d-flex align-items-center">
                        <div class="success-icon me-3">
                            <i class="ri-check-circle-fill"></i>
                        </div>
                        <div class="flex-grow-1">
                            <h6 class="mb-1 text-success">Gửi tin nhắn thành công!</h6>
                            <p class="mb-0 text-muted">${sessionScope.contactMessage}</p>
                        </div>
                        <button type="button" class="btn-close" onclick="this.closest('.card').style.display = 'none'"></button>
                    </div>
                </div>
            </div>
            <c:remove var="contactMessage" scope="session"/>
        </c:if>

        <!-- Navigation (tái sử dụng từ home.jsp) -->
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
                    <a href="/Travel/experiences" class="nav-center-item">
                        Trải Nghiệm
                    </a>
                    <a href="/Travel/accommodations" class="nav-center-item">
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
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/dashboard" style="color: #10466C; font-weight: 600;">
                                                <i class="ri-dashboard-line"></i> Quản Lý Host
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/experiences/create" style="color: #10466C; font-weight: 600;">
                                                <i class="ri-add-circle-line"></i> Tạo Trải Nghiệm
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/experiences/manage" style="color: #10466C; font-weight: 600;">
                                                <i class="ri-settings-4-line"></i> Quản Lý Trải Nghiệm
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
                                    <a href="${pageContext.request.contextPath}/contact" class="active">
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

        <!-- Contact Hero Section -->
        <section class="contact-hero">
            <div class="container">
                <h1 class="animate__animated animate__fadeInUp">Liên Hệ Với Chúng Tôi</h1>
                <p class="animate__animated animate__fadeInUp animate__delay-1s">
                    Chúng tôi luôn sẵn sàng hỗ trợ bạn trong hành trình khám phá Việt Nam
                </p>
            </div>
        </section>

        <!-- Contact Information -->
        <section class="py-5">
            <div class="container">
                <div class="row g-4 mb-5">
                    <div class="col-md-4">
                        <div class="contact-info-card text-center">
                            <div class="contact-icon">
                                <i class="ri-map-pin-line"></i>
                            </div>
                            <h4>Địa Chỉ</h4>
                            <p>Khu đô thị FPT City<br>
                            Ngũ Hành Sơn, Đà Nẵng<br>
                            550000, Việt Nam</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="contact-info-card text-center">
                            <div class="contact-icon">
                                <i class="ri-phone-line"></i>
                            </div>
                            <h4>Điện Thoại</h4>
                            <p>Hotline: <strong>1900 1234</strong><br>
                            Di động: <strong>0123 456 789</strong><br>
                            Fax: (0236) 3731 234</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="contact-info-card text-center">
                            <div class="contact-icon">
                                <i class="ri-mail-line"></i>
                            </div>
                            <h4>Email</h4>
                            <p>Chung: <strong>f5@vietculture.vn</strong><br>
                            Hỗ trợ: <strong>support@vietculture.vn</strong><br>
                            Kinh doanh: <strong>business@vietculture.vn</strong></p>
                        </div>
                    </div>
                </div>

                <!-- Contact Form -->
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="contact-form">
                            <h3 class="text-center mb-4">Gửi Tin Nhắn Cho Chúng Tôi</h3>
                            <form action="${pageContext.request.contextPath}/contact" method="POST">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="fullName" class="form-label">Họ và Tên *</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email *</label>
                                        <input type="email" class="form-control" id="email" name="email" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Số Điện Thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="subject" class="form-label">Chủ Đề *</label>
                                        <select class="form-control" id="subject" name="subject" required>
                                            <option value="">Chọn chủ đề</option>
                                            <option value="general">Thông tin chung</option>
                                            <option value="booking">Đặt chỗ/Trải nghiệm</option>
                                            <option value="host">Trở thành Host</option>
                                            <option value="technical">Hỗ trợ kỹ thuật</option>
                                            <option value="complaint">Khiếu nại</option>
                                            <option value="partnership">Hợp tác kinh doanh</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label for="message" class="form-label">Tin Nhắn *</label>
                                        <textarea class="form-control" id="message" name="message" rows="6" required 
                                                placeholder="Vui lòng mô tả chi tiết yêu cầu của bạn..."></textarea>
                                    </div>
                                    <div class="col-12">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required>
                                            <label class="form-check-label" for="agreeTerms">
                                                Tôi đồng ý với <a href="#" class="text-primary">Điều khoản sử dụng</a> và <a href="#" class="text-primary">Chính sách bảo mật</a>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-12 text-center">
                                        <button type="submit" class="btn btn-primary btn-lg px-5">
                                            <i class="ri-send-plane-line me-2"></i>Gửi Tin Nhắn
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Google Map Section -->
        <section class="map-section">
            <div class="container">
                <h2 class="text-center mb-5">Tìm Chúng Tôi Trên Bản Đồ</h2>
                
                <div class="map-container">
                    <iframe class="map-iframe" 
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.856168121187!2d108.25831631533315!3d15.968885088969625!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142116949840599%3A0x365b35580f52e8d5!2sFPT%20University%20Danang!5e0!3m2!1sen!2s!4v1635789123456!5m2!1sen!2s"
                            allowfullscreen="" 
                            loading="lazy" 
                            referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                    
                    <div class="map-overlay">
                        <h5><i class="ri-map-pin-fill text-primary me-2"></i>VietCulture Office</h5>
                        <p><i class="ri-building-line me-2"></i>Đại học FPT Đà Nẵng</p>
                        <p><i class="ri-road-map-line me-2"></i>Khu đô thị FPT City</p>
                        <p><i class="ri-map-2-line me-2"></i>Ngũ Hành Sơn, Đà Nẵng</p>
                        <p><i class="ri-phone-line me-2"></i>0123 456 789</p>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-8 mx-auto">
                        <div class="office-hours">
                            <h4><i class="ri-time-line me-2"></i>Giờ Làm Việc</h4>
                            <ul class="hours-list">
                                <li>
                                    <span><strong>Thứ Hai - Thứ Sáu</strong></span>
                                    <span>8:00 AM - 6:00 PM</span>
                                </li>
                                <li>
                                    <span><strong>Thứ Bảy</strong></span>
                                    <span>9:00 AM - 5:00 PM</span>
                                </li>
                                <li>
                                    <span><strong>Chủ Nhật</strong></span>
                                    <span>10:00 AM - 4:00 PM</span>
                                </li>
                                <li>
                                    <span><strong>Ngày Lễ</strong></span>
                                    <span>Liên hệ trước</span>
                                </li>
                            </ul>
                            <div class="text-center mt-3">
                                <small class="text-muted">
                                    <i class="ri-information-line me-1"></i>
                                    Hỗ trợ khẩn cấp 24/7 qua hotline: 1900 1234
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="py-5 bg-light">
            <div class="container">
                <h2 class="text-center mb-5">Câu Hỏi Thường Gặp</h2>
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="accordion" id="faqAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                                        <i class="ri-question-line me-2"></i>Làm thế nào để đặt trải nghiệm trên VietCulture?
                                    </button>
                                </h2>
                                <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Bạn có thể dễ dàng đặt trải nghiệm bằng cách: 1) Tìm kiếm trải nghiệm phù hợp, 2) Chọn ngày và số người, 3) Thực hiện thanh toán, 4) Nhận xác nhận qua email.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                                        <i class="ri-question-line me-2"></i>Chính sách hủy đặt chỗ như thế nào?
                                    </button>
                                </h2>
                                <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Chính sách hủy phụ thuộc vào từng host và loại trải nghiệm. Thông thường: Hủy trước 24h được hoàn 100%, hủy trước 12h được hoàn 50%, hủy trong vòng 12h không được hoàn tiền.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                                        <i class="ri-question-line me-2"></i>Làm thế nào để trở thành host trên VietCulture?
                                    </button>
                                </h2>
                                <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Để trở thành host, bạn cần: 1) Đăng ký tài khoản, 2) Cung cấp thông tin cá nhân và xác minh, 3) Tạo profile trải nghiệm/lưu trú, 4) Chờ phê duyệt từ team VietCulture.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">
                                        <i class="ri-question-line me-2"></i>VietCulture có hỗ trợ khách nước ngoài không?
                                    </button>
                                </h2>
                                <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Có, chúng tôi hỗ trợ khách du lịch quốc tế với dịch vụ đa ngôn ngữ (Tiếng Anh, Tiếng Hàn, Tiếng Nhật) và các phương thức thanh toán quốc tế.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer (tái sử dụng từ home.jsp) -->
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
                            <li><a href="#experiences"><i class="ri-arrow-right-s-line"></i> Trải Nghiệm</a></li>
                            <li><a href="#accommodations"><i class="ri-arrow-right-s-line"></i> Lưu Trú</a></li>
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
                        <p><i class="ri-map-pin-line me-2"></i> Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam </p>
                        <p><i class="ri-mail-line me-2"></i> f5@vietculture.vn</p>
                        <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                        <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                    </div>
                </div>
                <div class="copyright">
                    <p>© 2025 VietCulture. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </footer>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Dropdown menu functionality
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

            // Navbar scroll effect
            window.addEventListener('scroll', function () {
                const navbar = document.querySelector('.custom-navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Form validation and submission
            document.querySelector('form').addEventListener('submit', function(e) {
                const name = document.getElementById('fullName').value.trim();
                const email = document.getElementById('email').value.trim();
                const subject = document.getElementById('subject').value;
                const message = document.getElementById('message').value.trim();
                const agreeTerms = document.getElementById('agreeTerms').checked;

                if (!name || !email || !subject || !message || !agreeTerms) {
                    e.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin và đồng ý với điều khoản sử dụng.');
                    return;
                }

                // Email validation
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ email hợp lệ.');
                    return;
                }

                // Phone validation (if provided)
                const phone = document.getElementById('phone').value.trim();
                if (phone) {
                    const phoneRegex = /^[0-9+\-\s()]{10,15}$/;
                    if (!phoneRegex.test(phone)) {
                        e.preventDefault();
                        alert('Vui lòng nhập số điện thoại hợp lệ.');
                        return;
                    }
                }
            });

            // Smooth scrolling for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href').substring(1);
                    if (targetId === '') return;

                    const targetElement = document.getElementById(targetId);
                    if (targetElement) {
                        window.scrollTo({
                            top: targetElement.offsetTop - 100,
                            behavior: 'smooth'
                        });
                    }
                });
            });

            // Auto-hide success message after 5 seconds
            const successCard = document.querySelector('.success-card');
            if (successCard) {
                setTimeout(() => {
                    successCard.style.display = 'none';
                }, 5000);
            }

            // Add loading state to form submission
            document.querySelector('form button[type="submit"]').addEventListener('click', function() {
                const btn = this;
                const originalText = btn.innerHTML;
                
                setTimeout(() => {
                    btn.innerHTML = '<i class="ri-loader-4-line me-2"></i>Đang gửi...';
                    btn.disabled = true;
                    
                    setTimeout(() => {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    }, 2000);
                }, 100);
            });

            // Initialize page animations
            document.addEventListener('DOMContentLoaded', function() {
                // Animate contact cards on scroll
                const observerOptions = {
                    threshold: 0.1,
                    rootMargin: '0px 0px -50px 0px'
                };

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }
                    });
                }, observerOptions);

                document.querySelectorAll('.contact-info-card, .contact-form').forEach(el => {
                    el.style.opacity = '0';
                    el.style.transform = 'translateY(30px)';
                    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    observer.observe(el);
                });
            });
        </script>
    </body>
</html>
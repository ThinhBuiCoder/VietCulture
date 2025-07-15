<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Dịch Vụ - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
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

        /* Navbar Styles (copied from home) */
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
            position: relative;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.3rem;
            color: white;
            text-decoration: none;
            flex-shrink: 0;
        }

        .nav-center {
            display: flex;
            align-items: center;
            gap: 40px;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            flex-shrink: 0;
        }

        .nav-center-item {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: var(--transition);
            white-space: nowrap;
        }

        .nav-center-item:hover,
        .nav-center-item.active {
            color: var(--primary-color);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-shrink: 0;
            margin-left: auto;
        }

        .navbar-brand img {
            height: 50px !important;
            width: auto !important;
            margin-right: 12px !important;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
            object-fit: contain !important;
            display: inline-block !important;
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

        .dropdown-item {
            color: #10466C !important;
        }

        .dropdown-item i {
            color: #10466C !important;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(rgba(0,109,119,0.8), rgba(131,197,190,0.8)),
                url('https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2340&q=80') no-repeat center/cover;
            color: var(--light-color);
            padding: 120px 0 80px;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to top, var(--accent-color), transparent);
        }

        .hero-section h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            font-weight: 800;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }

        .hero-section p {
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto 30px;
            text-shadow: 0 1px 5px rgba(0,0,0,0.2);
        }

        /* Service Choice Cards */
        .service-choice-section {
            padding: 50px 0;
            background-color: var(--light-color);
        }

        .choice-card {
            background-color: var(--light-color);
            border-radius: var(--border-radius);
            padding: 40px 30px;
            text-align: center;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            cursor: pointer;
            height: 100%;
            border: 3px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .choice-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .choice-card:hover::before {
            left: 100%;
        }

        .choice-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-color);
        }

        .choice-card.experience-card:hover {
            border-color: var(--primary-color);
        }

        .choice-card.accommodation-card:hover {
            border-color: var(--secondary-color);
        }

        .choice-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            transition: var(--transition);
        }

        .experience-card .choice-icon {
            background: var(--gradient-primary);
        }

        .accommodation-card .choice-icon {
            background: var(--gradient-secondary);
        }

        .choice-card:hover .choice-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .choice-card h3 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .choice-card p {
            color: #6c757d;
            margin-bottom: 25px;
            font-size: 1rem;
        }

        .choice-features {
            list-style: none;
            padding: 0;
            margin-bottom: 30px;
        }

        .choice-features li {
            padding: 8px 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .choice-features li i {
            color: var(--primary-color);
            margin-right: 8px;
            font-size: 1rem;
        }

        .accommodation-card .choice-features li i {
            color: var(--secondary-color);
        }

        .choice-card.disabled {
            opacity: 0.6;
            cursor: not-allowed;
            pointer-events: none;
        }

        .choice-card.disabled .btn {
            background-color: #6c757d !important;
            cursor: not-allowed;
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 20px;
            margin-bottom: 30px;
        }

        .alert-info {
            background-color: rgba(13, 202, 240, 0.1);
            color: #055160;
            border-left: 4px solid #0dcaf0;
        }

        .alert-success {
            background-color: rgba(40, 167, 69, 0.1);
            color: #0f5132;
            border-left: 4px solid #28a745;
        }

        .alert h5 {
            margin-bottom: 10px;
            font-weight: 600;
        }

        .alert .btn {
            font-size: 0.9rem;
            padding: 8px 20px;
        }

        .btn {
            border-radius: 30px;
            padding: 12px 24px;
            font-weight: 500;
            transition: var(--transition);
            border: none;
        }

        .btn-experience {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .btn-experience:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            color: white;
        }

        .btn-accommodation {
            background: var(--gradient-secondary);
            color: white;
            box-shadow: 0 4px 15px rgba(131, 197, 190, 0.3);
        }

        .btn-accommodation:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(131, 197, 190, 0.4);
            color: white;
        }

        /* Benefits Section */
        .benefits-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        .benefit-card {
            background-color: var(--light-color);
            border-radius: var(--border-radius);
            padding: 30px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            height: 100%;
        }

        .benefit-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .benefit-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .benefit-card h5 {
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .benefit-card p {
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Stats Section */
        .stats-section {
            padding: 60px 0;
            background-color: var(--dark-color);
            color: var(--light-color);
        }

        .stat-item {
            text-align: center;
            padding: 20px;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
            font-family: 'Playfair Display', serif;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Footer */
        .footer {
            background-color: var(--dark-color);
            color: var(--light-color);
            padding: 50px 0 30px;
        }

        .footer h5 {
            font-size: 1.2rem;
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
        }

        .footer h5::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 30px;
            height: 2px;
            background: var(--gradient-primary);
            border-radius: 2px;
        }

        .footer p, .footer a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }

        .footer a:hover {
            color: var(--primary-color);
            transform: translateX(3px);
        }

        .footer .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.5);
            font-size: 0.9rem;
        }

        /* Animations */
        .fade-up {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease-out;
        }

        .fade-up.active {
            opacity: 1;
            transform: translateY(0);
        }

        .stagger-item {
            opacity: 1;
            transform: translateY(0);
            transition: all 0.5s ease-out;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .hero-section h1 {
                font-size: 2.8rem;
            }

            .nav-center {
                position: static;
                transform: none;
                margin-top: 20px;
                justify-content: center;
                order: 3;
                width: 100%;
            }

            .nav-right {
                order: 2;
                margin-top: 0;
            }

            .custom-navbar .container {
                flex-direction: column;
                align-items: stretch;
            }

            .navbar-brand {
                order: 1;
                justify-content: center;
                margin-bottom: 10px;
            }
        }

        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.2rem;
            }

            .choice-card {
                margin-bottom: 30px;
            }

            .custom-navbar {
                padding: 10px 0;
            }

            .nav-right {
                margin-top: 15px;
                justify-content: center;
                order: 3;
            }

            .nav-center {
                order: 2;
                margin-top: 15px;
                gap: 20px;
            }

            .nav-center-item {
                font-size: 0.9rem;
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
                                <%-- Role-based dashboard access --%>
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
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_service" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-add-circle-line"></i> Tạo Dịch Vụ
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/host/experiences/manage" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-settings-4-line"></i> Quản Dịch Vụ
                                        </a>
                                    </li>
                                </c:if>

                                <%-- Common profile options --%>
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
                        <%-- Not logged in state --%>
                        <a href="#become-host" class="me-3">Trở thành host</a>
                        <i class="ri-global-line globe-icon me-3"></i>
                        <div class="menu-icon">
                            <i class="ri-menu-line"></i>
                            <div class="dropdown-menu-custom">
                                <a href="#help-center">
                                    <i class="ri-question-line" style="color: #10466C;"></i>Trung tâm Trợ giúp
                                </a>
                                <a href="${pageContext.request.contextPath}/contact">
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

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <c:choose>
                <c:when test="${not empty sessionScope.user && sessionScope.user.role == 'HOST'}">
                    <h1 class="animate__animated animate__fadeInUp">Tạo Dịch Vụ Du Lịch Của Bạn</h1>
                    <p class="animate__animated animate__fadeInUp animate__delay-1s">
                        Chia sẻ trải nghiệm độc đáo hoặc cho thuê nơi ở tuyệt vời với du khách từ khắp nơi trên thế giới
                    </p>
                    
                    <!-- Upgrade Success Message -->
                    <c:if test="${upgradeSuccess}">
                        <div class="alert alert-success animate__animated animate__fadeInUp animate__delay-2s" style="max-width: 600px; margin: 20px auto;">
                            <i class="ri-check-circle-fill me-2"></i>
                            ${successMessage}
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <h1 class="animate__animated animate__fadeInUp">Truy Cập Bị Hạn Chế</h1>
                    <p class="animate__animated animate__fadeInUp animate__delay-1s">
                        Trang này chỉ dành cho các Host. Vui lòng trở thành Host để tạo dịch vụ du lịch.
                    </p>
                    <div class="d-flex justify-content-center gap-3 animate__animated animate__fadeInUp animate__delay-2s">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/host/upgrade" class="btn btn-primary">
                                    <i class="ri-vip-crown-line me-2"></i>Trở Thành Host
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                    <i class="ri-login-circle-line me-2"></i>Đăng Nhập
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                            <i class="ri-home-line me-2"></i>Về Trang Chủ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Service Choice Section - Only for HOST -->
    <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'HOST'}">
        <section class="service-choice-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <h2 class="text-center mb-5 fade-up">Chọn Loại Dịch Vụ Bạn Muốn Tạo</h2>
                        
                        <!-- Thông báo về tính năng khuyến mãi mới -->
                        <div class="alert alert-info mb-4 fade-up">
                            <h5><i class="ri-gift-line me-2"></i> Tính Năng Mới: Khuyến Mãi</h5>
                            <p>Giờ đây bạn có thể thêm khuyến mãi cho dịch vụ của mình! Tính năng này cho phép bạn cài đặt phần trăm giảm giá và thời hạn khuyến mãi khi tạo hoặc chỉnh sửa dịch vụ.</p>
                            <p class="mb-0"><strong>Lưu ý:</strong> Khuyến mãi sẽ được hiển thị cho khách hàng và giá sẽ được tính tự động trong quá trình đặt chỗ.</p>
                        </div>
                        
                        <div class="row">
                            <!-- Experience Card -->
                            <div class="col-md-6 mb-4 stagger-item">
                                <div class="choice-card experience-card" onclick="selectService('experience')">
                                    <div class="choice-icon">
                                        <i class="ri-compass-3-line"></i>
                                    </div>
                                    <h3>Trải Nghiệm</h3>
                                    <p>Chia sẻ những hoạt động, tour du lịch, và trải nghiệm văn hóa độc đáo của bạn</p>
                                    
                                    <ul class="choice-features">
                                        <li><i class="ri-check-line"></i> Tour ẩm thực địa phương</li>
                                        <li><i class="ri-check-line"></i> Hoạt động văn hóa truyền thống</li>
                                        <li><i class="ri-check-line"></i> Khám phá thiên nhiên</li>
                                        <li><i class="ri-check-line"></i> Workshop & học tập</li>
                                        <li><i class="ri-check-line"></i> Phiêu lưu & thể thao</li>
                                    </ul>
                                    
                                    <button class="btn btn-experience">
                                        <i class="ri-add-circle-line me-2"></i>Tạo Trải Nghiệm
                                    </button>
                                </div>
                            </div>

                            <!-- Accommodation Card -->
                            <div class="col-md-6 mb-4 stagger-item">
                                <div class="choice-card accommodation-card" onclick="selectService('accommodation')">
                                    <div class="choice-icon">
                                        <i class="ri-home-heart-line"></i>
                                    </div>
                                    <h3>Lưu Trú</h3>
                                    <p>Cho thuê nhà, phòng, hoặc không gian lưu trú độc đáo cho du khách</p>
                                    
                                    <ul class="choice-features">
                                        <li><i class="ri-check-line"></i> Homestay gia đình</li>
                                        <li><i class="ri-check-line"></i> Phòng riêng tư</li>
                                        <li><i class="ri-check-line"></i> Nhà nguyên căn</li>
                                        <li><i class="ri-check-line"></i> Biệt thự & resort</li>
                                        <li><i class="ri-check-line"></i> Chỗ ở độc đáo</li>
                                    </ul>
                                    
                                    <button class="btn btn-accommodation">
                                        <i class="ri-add-circle-line me-2"></i>Tạo Lưu Trú
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

    <!-- Benefits Section -->
    <section class="benefits-section">
        <div class="container">
            <h2 class="text-center mb-5 fade-up">Lợi Ích Khi Trở Thành Host</h2>
            
            <div class="row fade-up">
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="ri-money-dollar-circle-line"></i>
                        </div>
                        <h5>Thu Nhập Bổ Sung</h5>
                        <p>Kiếm thêm thu nhập từ việc chia sẻ trải nghiệm hoặc cho thuê nơi ở của bạn với du khách.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="ri-global-line"></i>
                        </div>
                        <h5>Kết Nối Quốc Tế</h5>
                        <p>Gặp gỡ và kết nối với du khách từ khắp nơi trên thế giới, mở rộng mạng lưới quan hệ.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="ri-heart-line"></i>
                        </div>
                        <h5>Chia Sẻ Văn Hóa</h5>
                        <p>Giới thiệu văn hóa Việt Nam và tạo ra những kỷ niệm đáng nhớ cho du khách.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6">
                    <div class="stat-item fade-up">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Host Đang Hoạt Động</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item fade-up">
                        <div class="stat-number">5000+</div>
                        <div class="stat-label">Trải Nghiệm Đã Tạo</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item fade-up">
                        <div class="stat-number">50K+</div>
                        <div class="stat-label">Khách Hàng Hài Lòng</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-item fade-up">
                        <div class="stat-number">4.8★</div>
                        <div class="stat-label">Đánh Giá Trung Bình</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5>Về VietCulture</h5>
                    <p>Kết nối du khách với những trải nghiệm văn hóa độc đáo và nơi lưu trú ấm cúng trên khắp Việt Nam.</p>
                </div>
                <div class="col-md-4 mb-4">
                    <h5>Liên Kết Nhanh</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
                        <li><a href="/Travel/experiences">Trải Nghiệm</a></li>
                        <li><a href="/Travel/accommodations">Lưu Trú</a></li>
                        <li><a href="#">Hỗ Trợ</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h5>Liên Hệ</h5>
                    <p><i class="ri-map-pin-line me-2"></i> FPT City, Ngũ Hành Sơn, Đà Nẵng</p>
                    <p><i class="ri-mail-line me-2"></i> support@vietculture.vn</p>
                    <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
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
        // Dropdown menu
        const menuIcon = document.querySelector('.menu-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

        if (menuIcon && dropdownMenu) {
            // Toggle dropdown on click
            menuIcon.addEventListener('click', function (e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function () {
                dropdownMenu.classList.remove('show');
            });

            // Prevent dropdown from closing when clicking inside
            dropdownMenu.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        // Navbar scroll effect (with proper scrolled class handling)
        window.addEventListener('scroll', function () {
            const navbar = document.querySelector('.custom-navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }

            animateOnScroll();
        });

        // Add scrolled class style
        const style = document.createElement('style');
        style.textContent = `
            .custom-navbar.scrolled {
                padding: 10px 0;
                background-color: #10466C;
                box-shadow: var(--shadow-md);
            }
        `;
        document.head.appendChild(style);

        // Function to handle service selection (only for HOST)
        function selectService(type) {
            // Check if user is HOST
            const userRole = '${sessionScope.user.role}';
            
            if (userRole !== 'HOST') {
                alert('Chỉ có Host mới được phép tạo dịch vụ.');
                return;
            }
            
            if (type === 'experience') {
                window.location.href = '${pageContext.request.contextPath}/Travel/create_experience';
            } else if (type === 'accommodation') {
                window.location.href = '${pageContext.request.contextPath}/Travel/create_accommodation';
            }
        }

        // Animate elements when they come into view
        function animateOnScroll() {
            const fadeElements = document.querySelectorAll('.fade-up');

            fadeElements.forEach(element => {
                const elementTop = element.getBoundingClientRect().top;
                const elementVisible = 150;

                if (elementTop < window.innerHeight - elementVisible) {
                    element.classList.add('active');

                    // Stagger child elements if any
                    const staggerItems = element.querySelectorAll('.stagger-item');
                    staggerItems.forEach((item, index) => {
                        setTimeout(() => {
                            item.style.opacity = 1;
                            item.style.transform = 'translateY(0)';
                        }, 150 * index);
                    });
                }
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

            animateOnScroll();
        });

        // Initialize animations on page load
        document.addEventListener('DOMContentLoaded', function () {
            // Add js-enabled class to body
            document.body.classList.add('js-enabled');

            // Force display all cards to ensure they're visible
            setTimeout(function () {
                document.querySelectorAll('.stagger-item').forEach(item => {
                    item.style.opacity = 1;
                    item.style.transform = 'translateY(0)';
                });
            }, 500);

            // Initial animation check
            animateOnScroll();

            // Initialize staggered items
            const staggerItems = document.querySelectorAll('.stagger-item');
            staggerItems.forEach((item, index) => {
                item.style.transitionDelay = `${index * 0.1}s`;
            });

            // Smooth scroll for nav links
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

            // Add hover effects to choice cards
            const choiceCards = document.querySelectorAll('.choice-card');
            choiceCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px) scale(1.02)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Add click animations
            choiceCards.forEach(card => {
                card.addEventListener('click', function() {
                    this.style.transform = 'translateY(-5px) scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = 'translateY(-10px) scale(1.02)';
                    }, 150);
                });
            });

            // Counter animation for stats
            const observerOptions = {
                threshold: 0.7
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const statsSection = entry.target;
                        const statNumbers = statsSection.querySelectorAll('.stat-number');
                        
                        statNumbers.forEach(stat => {
                            const finalNumber = stat.textContent;
                            let currentNumber = 0;
                            const increment = parseInt(finalNumber) / 100;
                            
                            const updateNumber = () => {
                                if (currentNumber < parseInt(finalNumber)) {
                                    currentNumber += increment;
                                    if (finalNumber.includes('K')) {
                                        stat.textContent = Math.floor(currentNumber / 1000) + 'K+';
                                    } else if (finalNumber.includes('★')) {
                                        stat.textContent = (currentNumber / 1000).toFixed(1) + '★';
                                    } else {
                                        stat.textContent = Math.floor(currentNumber) + '+';
                                    }
                                    requestAnimationFrame(updateNumber);
                                } else {
                                    stat.textContent = finalNumber;
                                }
                            };
                            
                            updateNumber();
                        });
                        
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            const statsSection = document.querySelector('.stats-section');
            if (statsSection) {
                observer.observe(statsSection);
            }
        });

        // Add keyboard navigation for accessibility
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                const focusedElement = document.activeElement;
                if (focusedElement.classList.contains('choice-card')) {
                    e.preventDefault();
                    focusedElement.click();
                }
            }
        });

        // Make choice cards focusable for accessibility
        document.querySelectorAll('.choice-card').forEach(card => {
            card.setAttribute('tabindex', '0');
            card.setAttribute('role', 'button');
            card.setAttribute('aria-label', card.querySelector('h3').textContent + ' - Nhấn Enter để chọn');
        });
    </script>
</body>
</html>
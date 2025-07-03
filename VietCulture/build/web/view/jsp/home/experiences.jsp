<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trải Nghiệm Du Lịch | VietCulture</title>
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
            }

            .toast.show {
                transform: translateX(0);
                opacity: 1;
            }

            .toast i {
                font-size: 1.2rem;
                color: #4BB543;
            }

            .btn-copy {
                background-color: transparent;
                border: none;
                cursor: pointer;
                color: #6c757d;
                transition: var(--transition);
                padding: 5px 10px;
                border-radius: 5px;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .btn-copy:hover {
                color: var(--dark-color);
                background-color: rgba(0,0,0,0.05);
            }

            .btn-copy i {
                font-size: 1rem;
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

            /* Hero Section */
            .hero-section {
                background: linear-gradient(rgba(0,109,119,0.8), rgba(131,197,190,0.8)),
                    url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80') no-repeat center/cover;
                color: var(--light-color);
                padding: 100px 0;
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
                text-shadow: 0 2px 10px rgba(0,0,0,0.2);
            }

            .hero-section p {
                font-size: 1.2rem;
                max-width: 700px;
                margin: 0 auto 30px;
                text-shadow: 0 1px 5px rgba(0,0,0,0.2);
            }

            /* Search Container */
            .search-container {
                background: rgba(255,255,255,0.95);
                backdrop-filter: blur(10px);
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-lg);
                padding: 30px;
                max-width: 1000px;
                margin: -80px auto 50px;
                border: 1px solid rgba(255,255,255,0.2);
                transition: var(--transition);
                position: relative;
                z-index: 10;
            }

            .search-container:hover {
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                transform: translateY(-5px);
            }

            .search-form {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                align-items: end;
            }

            .search-form .form-group {
                display: flex;
                flex-direction: column;
            }

            .search-form label {
                margin-bottom: 8px;
                color: var(--dark-color);
                font-weight: 600;
                font-size: 0.9rem;
            }

            .search-form .form-control {
                border-radius: 10px;
                padding: 12px;
                border: 1px solid rgba(0,0,0,0.1);
                transition: var(--transition);
                background-color: rgba(255,255,255,0.8);
            }

            .search-form .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .search-form .input-group {
                display: flex;
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid rgba(0,0,0,0.1);
                background-color: rgba(255,255,255,0.8);
            }

            .search-form .input-group .btn {
                border-radius: 0;
                padding: 0 15px;
                font-size: 1.2rem;
                background-color: transparent;
                color: var(--dark-color);
                border: none;
                transition: var(--transition);
            }

            .search-form .input-group .btn:hover {
                background-color: rgba(0,0,0,0.05);
            }

            .search-form .input-group input {
                border: none;
                text-align: center;
                font-weight: 600;
                background-color: transparent;
            }

            .search-form .btn-primary {
                background: var(--gradient-primary);
                border: none;
                padding: 15px;
                font-weight: 600;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: var(--transition);
                height: fit-content;
            }

            .search-form .btn-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(255, 56, 92, 0.25);
            }

            /* Filters Section */
            .filters-section {
                padding: 30px 0;
                background-color: var(--light-color);
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .filter-item {
                background-color: var(--accent-color);
                border-radius: 25px;
                padding: 8px 20px;
                border: 2px solid transparent;
                cursor: pointer;
                transition: var(--transition);
                text-decoration: none;
                color: var(--dark-color);
                display: inline-block;
                margin: 5px;
            }

            .filter-item:hover {
                border-color: var(--primary-color);
                background-color: rgba(255, 56, 92, 0.1);
                color: var(--primary-color);
                text-decoration: none;
            }

            .filter-item.active {
                background: var(--gradient-primary);
                color: white;
                border-color: var(--primary-color);
            }

            /* Cards Grid */
            .cards-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 30px;
                margin-top: 30px;
            }

            /* Experience Card */
            .card-item {
                background-color: var(--light-color);
                border-radius: var(--border-radius);
                overflow: hidden;
                transition: var(--transition);
                box-shadow: var(--shadow-md);
                position: relative;
                height: auto;
                min-height: 450px;
                display: flex;
                flex-direction: column;
            }

            .card-item:hover {
                transform: translateY(-10px);
                box-shadow: var(--shadow-lg);
            }

            .card-image {
                height: 250px;
                position: relative;
                overflow: hidden;
            }

            .card-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: var(--transition);
            }

            .card-item:hover .card-image img {
                transform: scale(1.1);
            }

            .card-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: var(--gradient-primary);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(255, 56, 92, 0.3);
            }

            .difficulty-badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background: var(--gradient-secondary);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(0, 109, 119, 0.3);
            }

            .card-content {
                padding: 25px;
                text-align: left;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .card-item h5 {
                color: var(--dark-color);
                margin-bottom: 10px;
                font-weight: 700;
                font-size: 1.25rem;
            }

            .location {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                color: #6c757d;
                font-size: 0.9rem;
            }

            .location i {
                margin-right: 5px;
                color: var(--primary-color);
            }

            .card-item p {
                color: #6c757d;
                margin-bottom: 20px;
                font-size: 0.9rem;
                flex-grow: 1;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                font-size: 0.85rem;
                color: #6c757d;
            }

            .info-row i {
                margin-right: 5px;
                font-size: 1rem;
            }

            .card-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: auto;
            }

            .price {
                font-weight: 700;
                color: var(--primary-color);
                font-size: 1.1rem;
            }

            .rating {
                display: flex;
                align-items: center;
                font-weight: 600;
                color: var(--dark-color);
            }

            .rating i {
                color: #FFD700;
                margin-right: 5px;
            }

            .host-info {
                display: flex;
                align-items: center;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid rgba(0,0,0,0.1);
            }

            .host-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
                border: 2px solid var(--secondary-color);
            }

            .host-name {
                font-weight: 600;
                font-size: 0.9rem;
            }

            .card-action {
                margin-top: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-item .btn-outline-primary {
                padding: 8px 16px;
                font-size: 0.9rem;
            }

            /* Pagination */
            .pagination-container {
                display: flex;
                justify-content: center;
                margin-top: 50px;
            }

            .pagination .page-link {
                border-radius: 8px;
                margin: 0 5px;
                border: 1px solid rgba(0,0,0,0.1);
                color: var(--dark-color);
                transition: var(--transition);
            }

            .pagination .page-link:hover {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                color: white;
            }

            .pagination .page-item.active .page-link {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
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
                .search-form {
                    grid-template-columns: repeat(2, 1fr);
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

                .cards-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 768px) {
                .search-form {
                    grid-template-columns: 1fr;
                }

                .cards-grid {
                    grid-template-columns: 1fr;
                }

                .hero-section h1 {
                    font-size: 2.5rem;
                }

                .custom-navbar {
                    padding: 10px 0;
                }
            }

            /* Loading Animation */
            .loading {
                text-align: center;
                padding: 50px;
            }

            .spinner {
                width: 40px;
                height: 40px;
                border: 4px solid #f3f3f3;
                border-top: 4px solid var(--primary-color);
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin: 0 auto 20px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* No results */
            .no-results {
                text-align: center;
                padding: 80px 20px;
                color: #6c757d;
            }

            .no-results i {
                font-size: 4rem;
                color: var(--secondary-color);
                margin-bottom: 20px;
            }

            .fade-up {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.8s ease-out;
            }

            .fade-up.active {
                opacity: 1;
                transform: translateY(0);
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
                    <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item active">
                        Trải Nghiệm
                    </a>
                    <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item">
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

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <h1 class="animate__animated animate__fadeInUp">Khám Phá Trải Nghiệm Độc Đáo</h1>
                <p class="animate__animated animate__fadeInUp animate__delay-1s">Tham gia những hoạt động thú vị cùng người dân địa phương và khám phá văn hóa Việt Nam</p>
            </div>
        </section>

        <!-- Search Container -->
        <div class="container">
            <div class="search-container">
                <form class="search-form" method="GET" action="${pageContext.request.contextPath}/experiences">
                    <div class="form-group">
                        <label for="categorySelect">Danh Mục</label>
                        <select class="form-control" name="category" id="categorySelect">
                            <option value="">Tất Cả Danh Mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" ${param.category == category.categoryId ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${category.name == 'Food'}">Ẩm Thực</c:when>
                                        <c:when test="${category.name == 'Culture'}">Văn Hóa</c:when>
                                        <c:when test="${category.name == 'Adventure'}">Phiêu Lưu</c:when>
                                        <c:when test="${category.name == 'History'}">Lịch Sử</c:when>
                                        <c:otherwise>${category.name}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="regionSelect">Vùng Miền</label>
                        <select class="form-control" name="region" id="regionSelect">
                            <option value="">Chọn Vùng Miền</option>
                            <c:forEach var="region" items="${regions}">
                                <option value="${region.regionId}" ${param.region == region.regionId ? 'selected' : ''}>
                                    ${region.vietnameseName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="citySelect">Thành Phố</label>
                        <select class="form-control" name="city" id="citySelect" ${empty param.region ? 'disabled' : ''}>
                            <option value="">Chọn Thành Phố</option>
                            <c:if test="${not empty param.region}">
                                <c:forEach var="region" items="${regions}">
                                    <c:if test="${region.regionId == param.region}">
                                        <c:forEach var="city" items="${region.cities}">
                                            <option value="${city.cityId}" ${param.city == city.cityId ? 'selected' : ''}>
                                                ${city.vietnameseName}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="ri-search-line"></i> Tìm Kiếm
                    </button>
                </form>
            </div>
        </div>

        <!-- Filters Section -->
        <section class="filters-section">
            <div class="container">
                <div class="d-flex flex-wrap justify-content-center">
                    <a href="${pageContext.request.contextPath}/experiences" class="filter-item ${empty param.filter ? 'active' : ''}">
                        <i class="ri-apps-line me-2"></i>Tất Cả
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences?filter=popular" class="filter-item ${param.filter == 'popular' ? 'active' : ''}">
                        <i class="ri-fire-line me-2"></i>Phổ Biến
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences?filter=newest" class="filter-item ${param.filter == 'newest' ? 'active' : ''}">
                        <i class="ri-time-line me-2"></i>Mới Nhất
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences?filter=top-rated" class="filter-item ${param.filter == 'top-rated' ? 'active' : ''}">
                        <i class="ri-star-line me-2"></i>Đánh Giá Cao
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences?filter=low-price" class="filter-item ${param.filter == 'low-price' ? 'active' : ''}">
                        <i class="ri-money-dollar-circle-line me-2"></i>Giá Tốt
                    </a>
                </div>
            </div>
        </section>

        <!-- Main Content -->
        <div class="container">
            <!-- Results Count -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fade-up">
                    <c:choose>
                        <c:when test="${not empty experiences}">
                            ${fn:length(experiences)} trải nghiệm được tìm thấy
                        </c:when>
                        <c:otherwise>
                            Khám phá trải nghiệm
                        </c:otherwise>
                    </c:choose>
                </h3>

                <div class="d-flex gap-2">
                    <select class="form-select" style="width: auto;" onchange="sortExperiences(this.value)">
                        <option value="">Sắp xếp theo</option>
                        <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                        <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                        <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá cao nhất</option>
                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                    </select>
                </div>
            </div>

            <!-- Experiences Grid -->
            <div id="experiencesContainer">
                <c:choose>
                    <c:when test="${not empty experiences}">
                        <div class="cards-grid fade-up">
                            <c:forEach var="experience" items="${experiences}">
                                <div class="card-item">
                                    <div class="card-image">
                                        <c:choose>
                                            <c:when test="${not empty experience.firstImage}">
                                                <img src="${pageContext.request.contextPath}/images/experiences/${experience.firstImage}" 
                                                     alt="${experience.title}"
                                                     onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\\'no-image-placeholder\\'>❌ Không tải được ảnh</div>';">
                                            </c:when>
                                            <c:when test="${not empty experience.images}">
                                                <c:set var="imageList" value="${fn:split(experience.images, ',')}" />
                                                <c:if test="${fn:length(imageList) > 0}">
                                                    <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(imageList[0])}" 
                                                         alt="${experience.title}"
                                                         onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\\'no-image-placeholder\\'>❌ Không tải được ảnh</div>';">
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-image-placeholder">
                                                    <i class="ri-image-line"></i>
                                                    <span>Không có ảnh</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="card-content">
                                        <h5>${experience.title}</h5>

                                        <div class="location">
                                            <i class="ri-map-pin-line"></i>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${not empty experience.cityName}">
                                                        ${experience.cityName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${experience.location}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <p>
                                            <c:choose>
                                                <c:when test="${fn:length(experience.description) > 100}">
                                                    ${fn:substring(experience.description, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${experience.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>

                                        <div class="info-row">
                                            <span><i class="ri-time-line"></i> 
                                                <c:choose>
                                                    <c:when test="${not empty experience.duration}">
                                                        <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Cả ngày
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span><i class="ri-group-line"></i> Tối đa ${experience.maxGroupSize} người</span>
                                        </div>

                                        <c:if test="${not empty experience.includedItems}">
                                            <div class="info-row">
                                                <span><i class="ri-check-line"></i> 
                                                    <c:set var="itemList" value="${fn:split(experience.includedItems, ',')}" />
                                                    <c:choose>
                                                        <c:when test="${fn:length(itemList) > 2}">
                                                            ${fn:trim(itemList[0])}, ${fn:trim(itemList[1])}...
                                                        </c:when>
                                                        <c:when test="${fn:length(itemList) == 2}">
                                                            ${fn:trim(itemList[0])}, ${fn:trim(itemList[1])}
                                                        </c:when>
                                                        <c:when test="${fn:length(itemList) == 1}">
                                                            ${fn:trim(itemList[0])}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${fn:length(experience.includedItems) > 50}">
                                                                    ${fn:substring(experience.includedItems, 0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${experience.includedItems}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </c:if>

                                        <div class="card-footer">
                                            <div class="price">
                                                <c:choose>
                                                    <c:when test="${experience.price == 0}">
                                                        Miễn phí
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ <small>/người</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <c:if test="${experience.averageRating > 0}">
                                                <div class="rating">
                                                    <i class="ri-star-fill"></i>
                                                    <span><fmt:formatNumber value="${experience.averageRating}" maxFractionDigits="1" /></span>
                                                    <small>(${experience.totalBookings} đánh giá)</small>
                                                </div>
                                            </c:if>
                                        </div>

                                        <c:if test="${not empty experience.hostName}">
                                            <div class="host-info">
                                                <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" alt="Host" class="host-avatar">
                                                <div>
                                                    <div class="host-name">Host: ${experience.hostName}</div>
                                                    <small class="text-muted">Trải nghiệm địa phương</small>
                                                </div>
                                            </div>
                                        </c:if>

                                        <div class="card-action">
                                            <a href="${pageContext.request.contextPath}/experiences/${experience.experienceId}" class="btn btn-outline-primary">
                                                <i class="ri-eye-line me-2"></i>Xem Chi Tiết
                                            </a>
                                            <button class="btn-copy" onclick="copyExperience('${experience.title}')">
                                                <i class="ri-share-line"></i>
                                                <span>Chia sẻ</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- No results message -->
                        <div class="no-results">
                            <i class="ri-search-line"></i>
                            <h4>Không tìm thấy trải nghiệm nào</h4>
                            <p>Hãy thử tìm kiếm với từ khóa khác hoặc bỏ bớt bộ lọc</p>
                            <a href="${pageContext.request.contextPath}/experiences" class="btn btn-primary">
                                <i class="ri-refresh-line me-2"></i>Xem Tất Cả Trải Nghiệm
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${not empty experiences and totalPages > 1}">
                <nav class="pagination-container">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&${queryString}">
                                    <i class="ri-arrow-left-s-line"></i>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="page">
                            <li class="page-item ${page == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${page}&${queryString}">${page}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&${queryString}">
                                    <i class="ri-arrow-right-s-line"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
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
                        <p><i class="ri-map-pin-line me-2"></i>  Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam</p>
                        <p><i class="ri-mail-line me-2"></i>  f5@vietculture.vn</p>
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

                                                    animateOnScroll();
                                                });

                                                // Animate elements when they come into view
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

                                                // Cities data from backend
                                                const citiesData = {};
            <c:forEach var="region" items="${regions}">
                                                citiesData['${region.regionId}'] = [
                <c:forEach var="city" items="${region.cities}" varStatus="status">
                                                {id: '${city.cityId}', name: '${city.name}', vietnameseName: '${city.vietnameseName}'}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                                                ];
            </c:forEach>

                                                // Handle region selection
                                                document.getElementById('regionSelect').addEventListener('change', function () {
                                                    const citySelect = document.getElementById('citySelect');
                                                    const selectedRegionId = this.value;

                                                    citySelect.innerHTML = '<option value="">Chọn Thành Phố</option>';

                                                    if (citiesData[selectedRegionId]) {
                                                        citySelect.disabled = false;
                                                        citiesData[selectedRegionId].forEach(city => {
                                                            const option = document.createElement('option');
                                                            option.value = city.id;
                                                            option.textContent = city.vietnameseName;
                                                            citySelect.appendChild(option);
                                                        });
                                                    } else {
                                                        citySelect.disabled = true;
                                                    }
                                                });

                                                // Sort experiences function
                                                function sortExperiences(sortValue) {
                                                    if (sortValue) {
                                                        const url = new URL(window.location);
                                                        url.searchParams.set('sort', sortValue);
                                                        window.location = url;
                                                    }
                                                }

                                                // Copy experience function
                                                function copyExperience(experienceName) {
                                                    const url = window.location.href;
                                                    const shareText = `Khám phá "${experienceName}" tại VietCulture: ${url}`;

                                                    if (navigator.share) {
                                                        navigator.share({
                                                            title: experienceName,
                                                            text: `Khám phá "${experienceName}" tại VietCulture`,
                                                            url: url
                                                        }).catch(err => console.log('Error sharing:', err));
                                                    } else if (navigator.clipboard) {
                                                        navigator.clipboard.writeText(shareText)
                                                                .then(() => {
                                                                    showToast(`Đã sao chép link "${experienceName}"`, 'success');
                                                                })
                                                                .catch(err => {
                                                                    showToast('Không thể sao chép: ' + err, 'error');
                                                                });
                                                    }
                                                }

                                                // Show toast notification
                                                function showToast(message, type = 'success') {
                                                    const toastContainer = document.querySelector('.toast-container');

                                                    const toast = document.createElement('div');
                                                    toast.className = 'toast';

                                                    let icon = '<i class="ri-check-line"></i>';
                                                    if (type === 'error') {
                                                        icon = '<i class="ri-error-warning-line" style="color: #FF385C;"></i>';
                                                    } else if (type === 'info') {
                                                        icon = '<i class="ri-information-line" style="color: #3498db;"></i>';
                                                    }

                                                    toast.innerHTML = `${icon}<span>${message}</span>`;
                                                    toastContainer.appendChild(toast);

                                                    setTimeout(() => toast.classList.add('show'), 10);

                                                    setTimeout(() => {
                                                        toast.classList.remove('show');
                                                        setTimeout(() => {
                                                            if (toastContainer.contains(toast)) {
                                                                toastContainer.removeChild(toast);
                                                            }
                                                        }, 500);
                                                    }, 3000);
                                                }

                                                // Initialize page
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    // Initial animation check
                                                    animateOnScroll();

                                                    // Smooth scroll for filter links
                                                    document.querySelectorAll('.filter-item').forEach(filter => {
                                                        filter.addEventListener('click', function (e) {
                                                            if (this.getAttribute('href').startsWith('#')) {
                                                                e.preventDefault();
                                                            }
                                                        });
                                                    });

                                                    // Auto-focus search if coming from search
                                                    const urlParams = new URLSearchParams(window.location.search);
                                                    if (urlParams.has('category') || urlParams.has('region') || urlParams.has('city')) {
                                                        document.querySelector('.search-container').scrollIntoView({
                                                            behavior: 'smooth',
                                                            block: 'center'
                                                        });
                                                    }
                                                });

                                                // Add JSTL functions support
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        </script>

        <!-- Toast notification styles -->

    </body>
</html>
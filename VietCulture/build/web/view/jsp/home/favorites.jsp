<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Yêu Thích | VietCulture</title>
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

        /* Navbar Styles */
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
            padding: 8px 16px;
            border-radius: 8px;
        }

        .nav-center-item:hover {
            color: white;
            background-color: rgba(255,255,255,0.1);
        }

        .nav-center-item.active {
            color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.1);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            transition: var(--transition);
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

        /* Page Header */
        .page-header {
            background: var(--gradient-primary);
            color: white;
            padding: 60px 0 40px;
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="hearts" patternUnits="userSpaceOnUse" width="20" height="20"><path d="M10,6 C6,2 2,6 10,14 C18,6 14,2 10,6 Z" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23hearts)"/></svg>') repeat;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% { transform: translateX(0) translateY(0); }
            100% { transform: translateX(-20px) translateY(-20px); }
        }

        .page-header .container {
            position: relative;
            z-index: 2;
        }

        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 15px;
            font-weight: 800;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .page-header p {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Error/Success Messages */
        .alert-custom {
            border-radius: var(--border-radius);
            padding: 20px;
            margin-bottom: 30px;
            border: none;
            box-shadow: var(--shadow-sm);
        }

        .alert-error {
            background: linear-gradient(135deg, #fee, #fdd);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-info {
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }

        /* Stats Section */
        .stats-section {
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 40px 30px;
            text-align: center;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .stat-card i {
            font-size: 3.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: block;
        }

        .stat-card h3 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: var(--dark-color);
            font-weight: 800;
        }

        .stat-card p {
            color: #6c757d;
            margin: 0;
            font-weight: 500;
        }

        /* Filter Tabs */
        .filter-tabs {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 35px;
            box-shadow: var(--shadow-sm);
        }

        .filter-tab {
            background: transparent;
            border: 2px solid rgba(0,0,0,0.1);
            border-radius: 30px;
            padding: 12px 24px;
            margin-right: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: var(--transition);
            color: var(--dark-color);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        .filter-tab:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.2);
        }

        .filter-tab.active {
            background: var(--gradient-primary);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }

        .filter-tab i {
            font-size: 1.1rem;
        }

        /* Favorites Grid */
        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 35px;
            margin-bottom: 50px;
        }

        /* Favorite Card */
        .favorite-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            position: relative;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .favorite-card:hover {
            transform: translateY(-12px);
            box-shadow: var(--shadow-lg);
        }

        .card-image {
            height: 280px;
            position: relative;
            overflow: hidden;
        }

        .card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .favorite-card:hover .card-image img {
            transform: scale(1.1);
        }

        .remove-favorite-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.95);
            border: none;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            color: var(--primary-color);
            font-size: 1.3rem;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            z-index: 10;
        }

        .remove-favorite-btn:hover {
            background: var(--primary-color);
            color: white;
            transform: scale(1.1) rotate(-10deg);
        }

        .remove-favorite-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .card-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: var(--gradient-primary);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(255, 56, 92, 0.3);
        }

        .card-content {
            padding: 30px;
        }

        .card-content h5 {
            color: var(--dark-color);
            margin-bottom: 15px;
            font-weight: 700;
            font-size: 1.4rem;
            line-height: 1.3;
        }

        .location {
            display: flex;
            align-items: center;
            margin-bottom: 18px;
            color: #6c757d;
            font-size: 0.95rem;
        }

        .location i {
            margin-right: 8px;
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .card-content p {
            color: #6c757d;
            margin-bottom: 25px;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid rgba(0,0,0,0.1);
        }

        .price {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.2rem;
        }

        .btn-view {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: var(--transition);
        }

        .btn-view:hover {
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 100px 30px;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--secondary-color);
            margin-bottom: 30px;
            opacity: 0.7;
        }

        .empty-state h3 {
            margin-bottom: 20px;
            color: var(--dark-color);
            font-size: 1.8rem;
        }

        .empty-state p {
            margin-bottom: 40px;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .btn-primary {
            background: var(--gradient-primary);
            border: none;
            color: white;
            padding: 15px 30px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary:hover {
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 56, 92, 0.4);
        }

        /* Loading States */
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Toast Notifications - Enhanced */
        .toast-container {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 9999;
        }

        .toast {
            background: var(--dark-color);
            color: white;
            padding: 18px 25px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 15px;
            transform: translateX(120%);
            opacity: 0;
            transition: all 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            min-width: 300px;
            max-width: 500px;
        }

        .toast.show {
            transform: translateX(0);
            opacity: 1;
        }

        .toast i {
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .toast.success i {
            color: #4BB543;
        }

        .toast.error i {
            color: #FF385C;
        }

        .toast.info i {
            color: #17a2b8;
        }

        .toast .btn-close {
            margin-left: auto;
            flex-shrink: 0;
        }

        .toast span {
            flex-grow: 1;
            word-break: break-word;
        }

        /* No Image Placeholder */
        .no-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            color: #6c757d;
            font-size: 0.9rem;
        }

        .no-image-placeholder i {
            font-size: 3.5rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .favorites-grid {
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            }
        }

        @media (max-width: 992px) {
            .favorites-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 25px;
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
                gap: 15px;
            }

            .page-header h1 {
                font-size: 2.5rem;
            }
        }

        @media (max-width: 768px) {
            body {
                padding-top: 120px;
            }

            .favorites-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }

            .page-header {
                padding: 40px 0 30px;
            }
            
            .custom-navbar {
                padding: 15px 0;
            }

            .stat-card {
                padding: 30px 20px;
            }

            .stat-card h3 {
                font-size: 2rem;
            }

            .filter-tab {
                padding: 10px 18px;
                margin-right: 10px;
            }

            .card-content {
                padding: 25px;
            }

            .toast {
                min-width: 280px;
                margin-right: 15px;
            }
        }

        @media (max-width: 480px) {
            .page-header h1 {
                font-size: 1.8rem;
            }

            .stat-card i {
                font-size: 2.8rem;
            }

            .stat-card h3 {
                font-size: 1.8rem;
            }

            .filter-tabs {
                padding: 20px 15px;
            }

            .card-content h5 {
                font-size: 1.2rem;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }

        .slide-up {
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
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
                    <i class="ri-home-line me-1"></i>Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item">
                    <i class="ri-compass-discover-line me-1"></i>Trải Nghiệm
                </a>
                <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item">
                    <i class="ri-home-heart-line me-1"></i>Lưu Trú
                </a>
                <a href="${pageContext.request.contextPath}/favorites" class="nav-center-item active">
                    <i class="ri-heart-fill me-1"></i>Yêu Thích
                </a>
            </div>

            <div class="nav-right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                                <i class="ri-user-line me-2" style="color: white;"></i> 
                                ${fn:escapeXml(sessionScope.user.fullName)}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-custom">
                                <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/favorites">
                                            <i class="ri-heart-line"></i> Yêu Thích
                                        </a>
                                    </li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="ri-user-settings-line"></i> Hồ Sơ
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="ri-logout-circle-r-line"></i> Đăng Xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="nav-center-item">
                            <i class="ri-login-circle-line me-1"></i>Đăng Nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="nav-center-item">
                            <i class="ri-user-add-line me-1"></i>Đăng Ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <h1 class="fade-in"><i class="ri-heart-fill me-3"></i>Danh Sách Yêu Thích</h1>
            <p class="fade-in">Những trải nghiệm và chỗ lưu trú bạn đã lưu để khám phá sau này</p>
        </div>
    </section>

    <div class="container">
        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert-custom alert-error slide-up">
                <i class="ri-error-warning-line me-2"></i>
                <strong>Lỗi:</strong> ${fn:escapeXml(error)}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert-custom alert-success slide-up">
                <i class="ri-check-line me-2"></i>
                <strong>Thành công:</strong> ${fn:escapeXml(success)}
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="stats-section slide-up">
            <div class="row">
                <div class="col-lg-4 col-md-4 mb-4">
                    <div class="stat-card">
                        <i class="ri-heart-fill"></i>
                        <h3 id="totalCount">
                            <c:choose>
                                <c:when test="${not empty experienceCount and not empty accommodationCount}">
                                    ${experienceCount + accommodationCount}
                                </c:when>
                                <c:when test="${not empty allFavorites}">
                                    ${fn:length(allFavorites)}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p>Tổng Yêu Thích</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 mb-4">
                    <div class="stat-card">
                        <i class="ri-compass-discover-line"></i>
                        <h3 id="experienceCount">${experienceCount != null ? experienceCount : 0}</h3>
                        <p>Trải Nghiệm</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 mb-4">
                    <div class="stat-card">
                        <i class="ri-home-heart-line"></i>
                        <h3 id="accommodationCount">${accommodationCount != null ? accommodationCount : 0}</h3>
                        <p>Chỗ Lưu Trú</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs slide-up">
            <a href="#" class="filter-tab active" data-filter="all">
                <i class="ri-apps-line"></i>
                <span>Tất Cả (<span id="allCount">${fn:length(allFavorites)}</span>)</span>
            </a>
            <a href="#" class="filter-tab" data-filter="experience">
                <i class="ri-compass-discover-line"></i>
                <span>Trải Nghiệm (<span id="expCount">${experienceCount != null ? experienceCount : 0}</span>)</span>
            </a>
            <a href="#" class="filter-tab" data-filter="accommodation">
                <i class="ri-home-heart-line"></i>
                <span>Chỗ Lưu Trú (<span id="accCount">${accommodationCount != null ? accommodationCount : 0}</span>)</span>
            </a>
        </div>

        <!-- Favorites Content -->
        <div id="favoritesContent" class="slide-up">
            <c:choose>
                <c:when test="${not empty allFavorites}">
                    <div class="favorites-grid" id="favoritesGrid">
                        <c:forEach var="favorite" items="${allFavorites}" varStatus="status">
                            <div class="favorite-card fade-in" data-type="${favorite.type}" data-favorite-id="${favorite.favoriteId}" style="animation-delay: ${status.index * 0.1}s">
                                <div class="card-image">
                                    <button class="remove-favorite-btn" onclick="removeFavorite(${favorite.favoriteId}, this)" title="Xóa khỏi yêu thích">
                                        <i class="ri-close-line"></i>
                                    </button>
                                    
                                    <c:choose>
                                        <c:when test="${favorite.type == 'experience' && not empty favorite.experience}">
                                            <div class="card-badge">
                                                <i class="ri-compass-discover-line me-1"></i>Trải Nghiệm
                                            </div>
                                            <c:choose>
                                                <c:when test="${not empty favorite.experience.images}">
                                                    <c:set var="imageList" value="${fn:split(favorite.experience.images, ',')}" />
                                                    <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(imageList[0])}" 
                                                         alt="${fn:escapeXml(favorite.experience.title)}"
                                                         onerror="handleImageError(this);"
                                                         loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-image-placeholder">
                                                        <i class="ri-image-line"></i>
                                                        <span>Không có ảnh</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${favorite.type == 'accommodation' && not empty favorite.accommodation}">
                                            <div class="card-badge">
                                                <i class="ri-home-heart-line me-1"></i>Chỗ Lưu Trú
                                            </div>
                                            <c:choose>
                                                <c:when test="${not empty favorite.accommodation.images}">
                                                    <c:set var="imageList" value="${fn:split(favorite.accommodation.images, ',')}" />
                                                    <img src="${pageContext.request.contextPath}/images/accommodations/${fn:trim(imageList[0])}" 
                                                         alt="${fn:escapeXml(favorite.accommodation.name)}"
                                                         onerror="handleImageError(this);"
                                                         loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-image-placeholder">
                                                        <i class="ri-image-line"></i>
                                                        <span>Không có ảnh</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-image-placeholder">
                                                <i class="ri-error-warning-line"></i>
                                                <span>Dữ liệu không hợp lệ</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="card-content">
                                    <c:choose>
                                        <c:when test="${favorite.type == 'experience' && not empty favorite.experience}">
                                            <h5 title="${fn:escapeXml(favorite.experience.title)}">
                                                <c:choose>
                                                    <c:when test="${fn:length(favorite.experience.title) > 50}">
                                                        ${fn:escapeXml(fn:substring(favorite.experience.title, 0, 50))}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:escapeXml(favorite.experience.title)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h5>
                                            <div class="location">
                                                <i class="ri-map-pin-line"></i>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${not empty favorite.experience.location}">
                                                            ${fn:escapeXml(favorite.experience.location)}
                                                        </c:when>
                                                        <c:when test="${not empty favorite.experience.cityName}">
                                                            ${fn:escapeXml(favorite.experience.cityName)}
                                                        </c:when>
                                                        <c:otherwise>Chưa có thông tin vị trí</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <p>
                                                <c:choose>
                                                    <c:when test="${not empty favorite.experience.description}">
                                                        <c:choose>
                                                            <c:when test="${fn:length(favorite.experience.description) > 120}">
                                                                ${fn:escapeXml(fn:substring(favorite.experience.description, 0, 120))}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:escapeXml(favorite.experience.description)}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>Không có mô tả</c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="card-footer">
                                                <div class="price">
                                                    <c:choose>
                                                        <c:when test="${favorite.experience.price == 0}">
                                                            <i class="ri-gift-line me-1"></i>Miễn phí
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${favorite.experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/experiences/${favorite.experience.experienceId}" class="btn-view">
                                                    <i class="ri-eye-line me-1"></i>Xem Chi Tiết
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:when test="${favorite.type == 'accommodation' && not empty favorite.accommodation}">
                                            <h5 title="${fn:escapeXml(favorite.accommodation.name)}">
                                                <c:choose>
                                                    <c:when test="${fn:length(favorite.accommodation.name) > 50}">
                                                        ${fn:escapeXml(fn:substring(favorite.accommodation.name, 0, 50))}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:escapeXml(favorite.accommodation.name)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h5>
                                            <div class="location">
                                                <i class="ri-map-pin-line"></i>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${not empty favorite.accommodation.location}">
                                                            ${fn:escapeXml(favorite.accommodation.location)}
                                                        </c:when>
                                                        <c:when test="${not empty favorite.accommodation.address}">
                                                            ${fn:escapeXml(favorite.accommodation.address)}
                                                        </c:when>
                                                        <c:when test="${not empty favorite.accommodation.cityName}">
                                                            ${fn:escapeXml(favorite.accommodation.cityName)}
                                                        </c:when>
                                                        <c:otherwise>Chưa có thông tin địa chỉ</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <p>
                                                <c:choose>
                                                    <c:when test="${not empty favorite.accommodation.description}">
                                                        <c:choose>
                                                            <c:when test="${fn:length(favorite.accommodation.description) > 120}">
                                                                ${fn:escapeXml(fn:substring(favorite.accommodation.description, 0, 120))}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:escapeXml(favorite.accommodation.description)}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>Không có mô tả</c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="card-footer">
                                                <div class="price">
                                                    <fmt:formatNumber value="${favorite.accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ/đêm
                                                </div>
                                                <a href="${pageContext.request.contextPath}/accommodations/${favorite.accommodation.accommodationId}" class="btn-view">
                                                    <i class="ri-eye-line me-1"></i>Xem Chi Tiết
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <h5>Mục đã bị xóa</h5>
                                            <div class="location">
                                                <i class="ri-error-warning-line"></i>
                                                <span>Dữ liệu không còn tồn tại</span>
                                            </div>
                                            <p>Mục yêu thích này không còn tồn tại trong hệ thống. Vui lòng xóa khỏi danh sách yêu thích.</p>
                                            <div class="card-footer">
                                                <div class="price" style="color: #dc3545;">
                                                    <i class="ri-delete-bin-line me-1"></i>Đã xóa
                                                </div>
                                                <button class="btn-view" style="background: #dc3545;" onclick="removeFavorite(${favorite.favoriteId}, this)">
                                                    <i class="ri-delete-bin-line me-1"></i>Xóa khỏi danh sách
                                                </button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="empty-state">
                        <i class="ri-heart-line"></i>
                        <h3>Chưa có mục yêu thích nào</h3>
                        <p>Hãy khám phá và lưu những trải nghiệm và chỗ lưu trú yêu thích của bạn để dễ dàng tìm lại sau này. Bắt đầu hành trình khám phá ngay hôm nay!</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/experiences" class="btn btn-primary me-3">
                                <i class="ri-compass-discover-line"></i>Khám Phá Trải Nghiệm
                            </a>
                            <a href="${pageContext.request.contextPath}/accommodations" class="btn btn-primary">
                                <i class="ri-home-heart-line"></i>Tìm Chỗ Lưu Trú
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Quick Actions -->
        <c:if test="${not empty allFavorites}">
            <div class="text-center mb-5">
                <button class="btn btn-outline-danger" onclick="clearAllFavorites()" id="clearAllBtn">
                    <i class="ri-delete-bin-line me-2"></i>Xóa Tất Cả Yêu Thích
                </button>
            </div>
        </c:if>
    </div>

    <!-- Toast Notification Container -->
    <div class="toast-container"></div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Global variables
        const contextPath = '${pageContext.request.contextPath}';
        let isProcessing = false;

        // Handle image error with better placeholder
        function handleImageError(img) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'no-image-placeholder';
            errorDiv.innerHTML = `
                <i class="ri-image-line"></i>
                <span>Không tải được ảnh</span>
            `;
            img.parentNode.replaceChild(errorDiv, img);
        }

        // Enhanced filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const filterTabs = document.querySelectorAll('.filter-tab');
            const favoriteCards = document.querySelectorAll('.favorite-card');

            filterTabs.forEach(tab => {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    if (isProcessing) return;
                    
                    // Remove active class from all tabs
                    filterTabs.forEach(t => t.classList.remove('active'));
                    // Add active class to clicked tab
                    this.classList.add('active');

                    const filter = this.getAttribute('data-filter');
                    filterCards(filter);
                });
            });

            // Initialize tooltips if Bootstrap is available
            if (typeof bootstrap !== 'undefined') {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
        });

        function filterCards(filter) {
            const favoriteCards = document.querySelectorAll('.favorite-card');
            
            favoriteCards.forEach((card, index) => {
                const cardType = card.getAttribute('data-type');
                
                if (filter === 'all' || filter === cardType) {
                    card.style.display = 'block';
                    card.style.animation = `fadeIn 0.5s ease-in ${index * 0.05}s both`;
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Enhanced remove favorite function
        function removeFavorite(favoriteId, button) {
            console.log('Removing favorite with ID:', favoriteId);
            
            if (isProcessing || button.disabled) {
                return;
            }
            
            // Confirm action
            if (!confirm('Bạn có chắc chắn muốn xóa mục này khỏi danh sách yêu thích?')) {
                return;
            }
            
            isProcessing = true;
            
            // Add loading state
            button.disabled = true;
            const originalContent = button.innerHTML;
            button.innerHTML = '<div class="loading-spinner"></div>';
            
            // Find the card element
            const card = button.closest('.favorite-card');
            
            fetch(contextPath + '/favorites/remove', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    favoriteId: favoriteId
                })
            })
            .then(response => {
                if (!response.ok) {
                    if (response.status === 401) {
                        showToast('Vui lòng đăng nhập lại', 'error');
                        setTimeout(() => {
                            window.location.href = contextPath + '/login';
                        }, 2000);
                        return Promise.reject('Unauthorized');
                    }
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Remove favorite response:', data);
                
                if (data && data.success) {
                    // Animate card removal
                    card.style.transition = 'all 0.6s ease-out';
                    card.style.transform = 'scale(0.8) translateY(-20px)';
                    card.style.opacity = '0';
                    
                    setTimeout(() => {
                        card.remove();
                        updateStats();
                        checkEmptyState();
                        
                        // Show success message
                        const message = data.message || 'Đã xóa khỏi danh sách yêu thích';
                        console.log('Showing toast with message:', message);
                        showToast(message, 'success');
                    }, 600);
                } else {
                    // Restore button state
                    button.disabled = false;
                    button.innerHTML = originalContent;
                    
                    const errorMessage = data.message || 'Có lỗi xảy ra khi xóa yêu thích';
                    console.log('Showing error toast with message:', errorMessage);
                    showToast(errorMessage, 'error');
                }
            })
            .catch(error => {
                console.error('Error removing favorite:', error);
                if (error !== 'Unauthorized') {
                    // Restore button state
                    button.disabled = false;
                    button.innerHTML = originalContent;
                    
                    const errorMessage = 'Không thể kết nối đến máy chủ. Vui lòng thử lại.';
                    console.log('Showing error toast with message:', errorMessage);
                    showToast(errorMessage, 'error');
                }
            })
            .finally(() => {
                isProcessing = false;
            });
        }

        // Clear all favorites function
        function clearAllFavorites() {
            if (isProcessing) return;
            
            const remainingCards = document.querySelectorAll('.favorite-card');
            if (remainingCards.length === 0) {
                showToast('Không có mục yêu thích nào để xóa', 'info');
                return;
            }
            
            if (!confirm(`Bạn có chắc chắn muốn xóa tất cả ${remainingCards.length} mục yêu thích? Hành động này không thể hoàn tác.`)) {
                return;
            }
            
            isProcessing = true;
            const clearBtn = document.getElementById('clearAllBtn');
            const originalContent = clearBtn.innerHTML;
            clearBtn.innerHTML = '<div class="loading-spinner"></div> Đang xóa...';
            clearBtn.disabled = true;
            
            fetch(contextPath + '/favorites/clear', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data && data.success) {
                    // Animate all cards removal
                    remainingCards.forEach((card, index) => {
                        setTimeout(() => {
                            card.style.transition = 'all 0.6s ease-out';
                            card.style.transform = 'scale(0.8) translateY(-20px)';
                            card.style.opacity = '0';
                            
                            setTimeout(() => {
                                card.remove();
                                if (index === remainingCards.length - 1) {
                                    updateStats();
                                    checkEmptyState();
                                }
                            }, 600);
                        }, index * 100);
                    });
                    
                    showToast('Đã xóa tất cả mục yêu thích', 'success');
                } else {
                    showToast(data.message || 'Có lỗi xảy ra khi xóa', 'error');
                }
            })
            .catch(error => {
                console.error('Error clearing favorites:', error);
                showToast('Không thể kết nối đến máy chủ. Vui lòng thử lại.', 'error');
            })
            .finally(() => {
                clearBtn.innerHTML = originalContent;
                clearBtn.disabled = false;
                isProcessing = false;
            });
        }

        // Update statistics after removing items
        function updateStats() {
            const remainingCards = document.querySelectorAll('.favorite-card');
            const experienceCards = document.querySelectorAll('.favorite-card[data-type="experience"]');
            const accommodationCards = document.querySelectorAll('.favorite-card[data-type="accommodation"]');
            
            const total = remainingCards.length;
            const expCount = experienceCards.length;
            const accCount = accommodationCards.length;
            
            // Update stat cards
            document.getElementById('totalCount').textContent = total;
            document.getElementById('experienceCount').textContent = expCount;
            document.getElementById('accommodationCount').textContent = accCount;
            
            // Update filter tabs counts
            document.getElementById('allCount').textContent = total;
            document.getElementById('expCount').textContent = expCount;
            document.getElementById('accCount').textContent = accCount;
            
            // Hide clear all button if no items left
            const clearBtn = document.getElementById('clearAllBtn');
            if (clearBtn && total === 0) {
                clearBtn.style.display = 'none';
            }
        }

        // Check if we need to show empty state
        function checkEmptyState() {
            const remainingCards = document.querySelectorAll('.favorite-card');
            
            if (remainingCards.length === 0) {
                const favoritesContent = document.getElementById('favoritesContent');
                favoritesContent.innerHTML = `
                    <div class="empty-state fade-in">
                        <i class="ri-heart-line"></i>
                        <h3>Chưa có mục yêu thích nào</h3>
                        <p>Hãy khám phá và lưu những trải nghiệm và chỗ lưu trú yêu thích của bạn để dễ dàng tìm lại sau này. Bắt đầu hành trình khám phá ngay hôm nay!</p>
                        <div>
                            <a href="${contextPath}/experiences" class="btn btn-primary me-3">
                                <i class="ri-compass-discover-line"></i>Khám Phá Trải Nghiệm
                            </a>
                            <a href="${contextPath}/accommodations" class="btn btn-primary">
                                <i class="ri-home-heart-line"></i>Tìm Chỗ Lưu Trú
                            </a>
                        </div>
                    </div>
                `;
            }
        }

        // Enhanced toast notification system
        function showToast(message, type = 'success') {
            const toastContainer = document.querySelector('.toast-container');
            
            const toast = document.createElement('div');
            toast.className = 'toast ' + type;
            
            // Create icon element
            const iconElement = document.createElement('i');
            if (type === 'error') {
                iconElement.className = 'ri-error-warning-line';
            } else if (type === 'info') {
                iconElement.className = 'ri-information-line';
            } else if (type === 'warning') {
                iconElement.className = 'ri-alert-line';
            } else {
                iconElement.className = 'ri-check-line';
            }
            
            // Create message span
            const messageSpan = document.createElement('span');
            messageSpan.textContent = message;
            
            // Create close button
            const closeButton = document.createElement('button');
            closeButton.type = 'button';
            closeButton.className = 'btn-close';
            closeButton.style.cssText = 'background: none; border: none; color: white; margin-left: auto; opacity: 0.7; cursor: pointer; padding: 0 5px;';
            closeButton.innerHTML = '<i class="ri-close-line"></i>';
            closeButton.onclick = function() { closeToast(this); };
            
            // Append elements to toast
            toast.appendChild(iconElement);
            toast.appendChild(messageSpan);
            toast.appendChild(closeButton);
            
            toastContainer.appendChild(toast);
            
            setTimeout(() => toast.classList.add('show'), 100);
            
            // Auto close after 5 seconds
            setTimeout(() => {
                if (toast.querySelector('.btn-close')) {
                    closeToast(toast.querySelector('.btn-close'));
                }
            }, 5000);
        }

        function closeToast(button) {
            const toast = button.closest('.toast');
            toast.classList.remove('show');
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 600);
        }

        // Add scroll animations
        function addScrollAnimations() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            }, {
                threshold: 0.1
            });

            document.querySelectorAll('.favorite-card').forEach(card => {
                observer.observe(card);
            });
        }

        // Initialize scroll animations on page load
        document.addEventListener('DOMContentLoaded', addScrollAnimations);

        // Handle back/forward browser navigation
        window.addEventListener('popstate', function(event) {
            location.reload();
        });

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl + A to select all filter
            if (e.ctrlKey && e.key === 'a') {
                e.preventDefault();
                document.querySelector('.filter-tab[data-filter="all"]').click();
            }
            // Ctrl + E for experiences filter
            if (e.ctrlKey && e.key === 'e') {
                e.preventDefault();
                document.querySelector('.filter-tab[data-filter="experience"]').click();
            }
            // Ctrl + H for accommodations filter
            if (e.ctrlKey && e.key === 'h') {
                e.preventDefault();
                document.querySelector('.filter-tab[data-filter="accommodation"]').click();
            }
        });

        // Performance optimization: Lazy loading for images
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src || img.src;
                        img.classList.remove('lazy');
                        imageObserver.unobserve(img);
                    }
                });
            });

            document.querySelectorAll('img[loading="lazy"]').forEach(img => {
                imageObserver.observe(img);
            });
        }

        // Debug function for troubleshooting
        function debugFavorites() {
            console.log('=== Favorites Debug Info ===');
            console.log('Total cards:', document.querySelectorAll('.favorite-card').length);
            console.log('Experience cards:', document.querySelectorAll('.favorite-card[data-type="experience"]').length);
            console.log('Accommodation cards:', document.querySelectorAll('.favorite-card[data-type="accommodation"]').length);
            console.log('Context path:', contextPath);
            console.log('Processing state:', isProcessing);
            
            // Test toast function
            console.log('Testing toast...');
            showToast('Test message - this is a test toast', 'success');
        }

        // Test toast function
        function testToast() {
            showToast('Đây là tin nhắn thử nghiệm', 'success');
            setTimeout(() => showToast('Tin nhắn lỗi thử nghiệm', 'error'), 1000);
            setTimeout(() => showToast('Tin nhắn thông tin thử nghiệm', 'info'), 2000);
        }

        // Make debug functions available globally
        window.debugFavorites = debugFavorites;
        window.testToast = testToast;
    </script>
</body>
</html>
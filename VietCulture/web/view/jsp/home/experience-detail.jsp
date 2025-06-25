<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${experience.title} | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
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

            /* Header Section */
            .detail-header {
                background-color: var(--light-color);
                padding: 30px 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .experience-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 15px;
                color: var(--dark-color);
            }

            .experience-subtitle {
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
                margin-bottom: 20px;
                color: #6c757d;
            }

            .subtitle-item {
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
            }

            .subtitle-item i {
                color: var(--primary-color);
            }

            .category-badge {
                background: var(--gradient-secondary);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }

            .difficulty-badge {
                background: var(--gradient-primary);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .action-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border: 1px solid rgba(0,0,0,0.2);
                border-radius: 25px;
                background: white;
                text-decoration: none;
                color: var(--dark-color);
                transition: var(--transition);
                font-size: 0.9rem;
            }

            .action-btn:hover {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
                transform: translateY(-2px);
            }

            /* Image Gallery */
            .image-gallery {
                margin: 30px 0;
            }

            .swiper {
                width: 100%;
                height: 500px;
                border-radius: var(--border-radius);
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .swiper-slide img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .swiper-button-next,
            .swiper-button-prev {
                background: rgba(255,255,255,0.9);
                width: 40px;
                height: 40px;
                border-radius: 50%;
                margin: 0 15px;
            }

            .swiper-button-next:after,
            .swiper-button-prev:after {
                color: var(--dark-color);
                font-size: 16px;
                font-weight: bold;
            }

            .swiper-pagination-bullet {
                background: var(--primary-color);
                opacity: 0.5;
            }

            .swiper-pagination-bullet-active {
                opacity: 1;
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                margin: 40px 0;
            }

            .main-content {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
            }

            .sidebar {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                height: fit-content;
                position: sticky;
                top: 120px;
            }

            /* Content Sections */
            .content-section {
                margin-bottom: 40px;
                padding-bottom: 30px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .content-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.5rem;
                font-weight: 700;
                margin-bottom: 20px;
                color: var(--dark-color);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .section-title i {
                color: var(--primary-color);
                font-size: 1.3rem;
            }

            /* Host Info */
            .host-info-card {
                display: flex;
                align-items: center;
                gap: 20px;
                padding: 20px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 15px;
                margin-bottom: 20px;
            }

            .host-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 3px solid var(--secondary-color);
            }

            .host-details h4 {
                font-size: 1.2rem;
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .host-stats {
                display: flex;
                gap: 15px;
                margin-top: 10px;
            }

            .host-stat {
                font-size: 0.85rem;
                color: #6c757d;
            }

            /* Info Cards */
            .info-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .info-card {
                background: rgba(255, 56, 92, 0.05);
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                transition: var(--transition);
                border: 1px solid rgba(255, 56, 92, 0.1);
            }

            .info-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-md);
            }

            .info-card i {
                font-size: 2rem;
                color: var(--primary-color);
                margin-bottom: 10px;
            }

            .info-card h5 {
                font-size: 1.1rem;
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .info-card p {
                color: #6c757d;
                margin: 0;
                font-size: 0.9rem;
            }

            /* Included Items */
            .included-items {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .included-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 10px;
                transition: var(--transition);
            }

            .included-item:hover {
                background: rgba(131, 197, 190, 0.2);
                transform: translateX(5px);
            }

            .included-item i {
                color: var(--secondary-color);
                font-size: 1.1rem;
            }

            /* Booking Card */
            .booking-card {
                border: 2px solid var(--primary-color);
                border-radius: var(--border-radius);
                padding: 25px;
                background: var(--light-color);
                box-shadow: var(--shadow-lg);
            }

            .price-display {
                text-align: center;
                margin-bottom: 25px;
            }

            .price-amount {
                font-size: 2rem;
                font-weight: 800;
                color: var(--primary-color);
                margin-bottom: 5px;
            }

            .price-unit {
                color: #6c757d;
                font-size: 0.9rem;
            }

            .booking-form .form-group {
                margin-bottom: 20px;
            }

            .booking-form label {
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
            }

            .booking-form .form-control {
                border-radius: 10px;
                padding: 12px;
                border: 2px solid rgba(0,0,0,0.1);
                transition: var(--transition);
            }

            .booking-form .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .booking-summary {
                background: rgba(131, 197, 190, 0.1);
                padding: 15px;
                border-radius: 10px;
                margin: 20px 0;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                font-size: 0.9rem;
            }

            .summary-total {
                font-weight: 700;
                font-size: 1.1rem;
                color: var(--dark-color);
                border-top: 1px solid rgba(0,0,0,0.2);
                padding-top: 10px;
                margin-top: 10px;
            }

            /* Schedule Section */
            .schedule-item {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
                padding: 15px;
                background: rgba(0,0,0,0.02);
                border-radius: 10px;
                transition: var(--transition);
            }

            .schedule-item:hover {
                background: rgba(0,0,0,0.05);
            }

            .schedule-time {
                min-width: 80px;
                font-weight: 600;
                color: var(--primary-color);
                font-size: 0.9rem;
            }

            .schedule-content h6 {
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .schedule-content p {
                margin: 0;
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Reviews Section */
            .rating-overview {
                display: grid;
                grid-template-columns: auto 1fr;
                gap: 30px;
                margin-bottom: 30px;
            }

            .rating-score {
                text-align: center;
            }

            .rating-number {
                font-size: 3rem;
                font-weight: 800;
                color: var(--primary-color);
                margin-bottom: 10px;
            }

            .rating-stars {
                color: #FFD700;
                font-size: 1.2rem;
                margin-bottom: 5px;
            }

            .rating-breakdown {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .rating-bar {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .rating-bar-label {
                min-width: 60px;
                font-size: 0.9rem;
                color: #6c757d;
            }

            .progress {
                height: 8px;
                background: rgba(0,0,0,0.1);
                border-radius: 10px;
                overflow: hidden;
            }

            .progress-bar {
                background: var(--gradient-primary);
            }

            .review-item {
                background: rgba(0,0,0,0.02);
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 20px;
                transition: var(--transition);
            }

            .review-item:hover {
                background: rgba(0,0,0,0.05);
            }

            .review-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
            }

            .reviewer-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid var(--secondary-color);
            }

            .reviewer-info h6 {
                margin: 0;
                font-weight: 600;
                color: var(--dark-color);
            }

            .review-date {
                font-size: 0.8rem;
                color: #6c757d;
            }

            .review-rating {
                color: #FFD700;
                margin-left: auto;
            }

            /* Location Map */
            .map-container {
                height: 300px;
                background: rgba(131, 197, 190, 0.2);
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #6c757d;
                border: 2px dashed var(--secondary-color);
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

                .sidebar {
                    position: relative;
                    top: 0;
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

                .info-cards {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 768px) {
                .experience-title {
                    font-size: 1.8rem;
                }

                .experience-subtitle {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .action-buttons {
                    justify-content: center;
                }

                .rating-overview {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .info-cards {
                    grid-template-columns: 1fr;
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

            .fade-up {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.8s ease-out;
            }

            .fade-up.active {
                opacity: 1;
                transform: translateY(0);
            }

            /* No image placeholder */
            .no-image-placeholder {
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background: rgba(131, 197, 190, 0.1);
                color: #6c757d;
            }

            .no-image-placeholder i {
                font-size: 3rem;
                margin-bottom: 10px;
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
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/experiences">Trải Nghiệm</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            ${experience.title}
                        </li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Header Section -->
        <section class="detail-header">
            <div class="container">
                <div class="fade-up">
                    <h1 class="experience-title">${experience.title}</h1>

                    <div class="experience-subtitle">
                        <div class="subtitle-item">
                            <i class="ri-star-fill"></i>
                            <c:choose>
                                <c:when test="${experience.averageRating > 0}">
                                    <span><fmt:formatNumber value="${experience.averageRating}" maxFractionDigits="1" /></span>
                                    <span>(${experience.totalBookings} đánh giá)</span>
                                </c:when>
                                <c:otherwise>
                                    <span>Chưa có đánh giá</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="subtitle-item">
                            <i class="ri-map-pin-line"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty experience.cityName}">
                                        ${experience.cityName}, ${experience.location}
                                    </c:when>
                                    <c:otherwise>
                                        ${experience.location}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <c:if test="${not empty experience.categoryName}">
                            <span class="category-badge">
                                <c:choose>
                                    <c:when test="${experience.categoryName == 'Food'}">Ẩm Thực</c:when>
                                    <c:when test="${experience.categoryName == 'Culture'}">Văn Hóa</c:when>
                                    <c:when test="${experience.categoryName == 'Adventure'}">Phiêu Lưu</c:when>
                                    <c:when test="${experience.categoryName == 'History'}">Lịch Sử</c:when>
                                    <c:otherwise>${experience.categoryName}</c:otherwise>
                                </c:choose>
                            </span>
                        </c:if>

                        <c:if test="${not empty experience.difficulty}">
                            <span class="difficulty-badge">
                                <c:choose>
                                    <c:when test="${experience.difficulty == 'Easy'}">Dễ</c:when>
                                    <c:when test="${experience.difficulty == 'Medium'}">Trung Bình</c:when>
                                    <c:when test="${experience.difficulty == 'Hard'}">Khó</c:when>
                                    <c:otherwise>${experience.difficulty}</c:otherwise>
                                </c:choose>
                            </span>
                        </c:if>
                    </div>

                    <div class="action-buttons">
                        <a href="#" class="action-btn" onclick="shareExperience()">
                            <i class="ri-share-line"></i>
                            <span>Chia sẻ</span>
                        </a>
                        <a href="#" class="action-btn" onclick="saveExperience()">
                            <i class="ri-heart-line"></i>
                            <span>Lưu</span>
                        </a>
                        <a href="#reviews" class="action-btn">
                            <i class="ri-chat-3-line"></i>
                            <span>Đánh giá</span>
                        </a>
                        <a href="#schedule" class="action-btn">
                            <i class="ri-calendar-line"></i>
                            <span>Lịch trình</span>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Image Gallery -->
        <div class="container">
            <div class="image-gallery fade-up">
                <div class="swiper experience-swiper">
                    <div class="swiper-wrapper">
                        <c:choose>
                            <c:when test="${not empty experience.images}">
                                <c:set var="imageList" value="${fn:split(experience.images, ',')}" />
                                <c:forEach var="image" items="${imageList}">
                                    <div class="swiper-slide">
                                        <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(image)}" 
                                             alt="${experience.title}" 
                                             onerror="this.src='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1552832230-c0197047daf1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="content-grid fade-up">
                <!-- Main Content -->
                <div class="main-content">
                    <!-- Host Information -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-user-star-line"></i>
                            Hướng dẫn viên ${experience.hostName}
                        </h3>

                        <div class="host-info-card">
                            <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                 alt="Host Avatar" class="host-avatar">
                            <div class="host-details">
                                <h4>${experience.hostName}</h4>
                                <p class="text-muted">Hướng dẫn viên địa phương • Tham gia từ 2023</p>
                                <div class="host-stats">
                                    <span class="host-stat">
                                        <i class="ri-star-fill" style="color: #FFD700;"></i>
                                        4.9 (156 đánh giá)
                                    </span>
                                    <span class="host-stat">
                                        <i class="ri-check-line" style="color: #4BB543;"></i>
                                        Đã xác minh danh tính
                                    </span>
                                    <span class="host-stat">
                                        <i class="ri-time-line" style="color: var(--primary-color);"></i>
                                        Phản hồi trong 1 giờ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Experience Info -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin trải nghiệm
                        </h3>

                        <div class="info-cards">
                            <div class="info-card">
                                <i class="ri-time-line"></i>
                                <h5>
                                    <c:choose>
                                        <c:when test="${not empty experience.duration}">
                                            <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                        </c:when>
                                        <c:otherwise>
                                            Cả ngày
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <p>Thời gian</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-group-line"></i>
                                <h5>${experience.maxGroupSize} người</h5>
                                <p>Tối đa</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-global-line"></i>
                                <h5>Tiếng Việt</h5>
                                <p>Ngôn ngữ</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-calendar-line"></i>
                                <h5>Linh hoạt</h5>
                                <p>Lịch trình</p>
                            </div>
                        </div>

                        <p style="font-size: 1.1rem; line-height: 1.7; color: var(--dark-color);">
                            ${experience.description}
                        </p>
                    </div>

                    <!-- What's Included -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-check-line"></i>
                            Bao gồm trong trải nghiệm
                        </h3>

                        <div class="included-items">
                            <c:choose>
                                <c:when test="${not empty experience.includedItems}">
                                    <c:set var="itemList" value="${fn:split(experience.includedItems, ',')}" />
                                    <c:forEach var="item" items="${itemList}">
                                        <div class="included-item">
                                            <i class="ri-check-line"></i>
                                            <span>${fn:trim(item)}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="included-item">
                                        <i class="ri-user-line"></i>
                                        <span>Hướng dẫn viên địa phương</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-camera-line"></i>
                                        <span>Chụp ảnh miễn phí</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-drink-line"></i>
                                        <span>Nước uống</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-book-line"></i>
                                        <span>Tài liệu hướng dẫn</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Schedule Section -->
                    <div class="content-section" id="schedule">
                        <h3 class="section-title">
                            <i class="ri-calendar-line"></i>
                            Lịch trình chi tiết
                        </h3>

                        <div class="schedule-item">
                            <div class="schedule-time">09:00</div>
                            <div class="schedule-content">
                                <h6>Gặp mặt và làm quen</h6>
                                <p>Gặp gỡ hướng dẫn viên tại điểm hẹn, giới thiệu về trải nghiệm và các thành viên trong nhóm.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">09:30</div>
                            <div class="schedule-content">
                                <h6>Bắt đầu trải nghiệm</h6>
                                <p>Khởi hành và tham gia hoạt động chính. Hướng dẫn viên sẽ chia sẻ kiến thức địa phương và văn hóa.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">11:00</div>
                            <div class="schedule-content">
                                <h6>Nghỉ giải lao</h6>
                                <p>Thời gian nghỉ ngơi, thưởng thức đồ uống và chụp ảnh kỷ niệm.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">11:30</div>
                            <div class="schedule-content">
                                <h6>Tiếp tục khám phá</h6>
                                <p>Tham gia các hoạt động thú vị và tìm hiểu thêm về văn hóa bản địa.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">12:30</div>
                            <div class="schedule-content">
                                <h6>Kết thúc trải nghiệm</h6>
                                <p>Tổng kết trải nghiệm, chia sẻ cảm nhận và chào tạm biệt.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="content-section" id="reviews">
                        <h3 class="section-title">
                            <i class="ri-star-line"></i>
                            Đánh giá từ khách hàng
                        </h3>

                        <c:choose>
                            <c:when test="${experience.averageRating > 0}">
                                <div class="rating-overview">
                                    <div class="rating-score">
                                        <div class="rating-number">
                                            <fmt:formatNumber value="${experience.averageRating}" maxFractionDigits="1" />
                                        </div>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= experience.averageRating}">
                                                        <i class="ri-star-fill"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="ri-star-line"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <div class="text-muted">${experience.totalBookings} đánh giá</div>
                                    </div>

                                    <div class="rating-breakdown">
                                        <div class="rating-bar">
                                            <span class="rating-bar-label">5 sao</span>
                                            <div class="progress flex-fill">
                                                <div class="progress-bar" style="width: 75%"></div>
                                            </div>
                                            <span class="text-muted ms-2">75%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-bar-label">4 sao</span>
                                            <div class="progress flex-fill">
                                                <div class="progress-bar" style="width: 18%"></div>
                                            </div>
                                            <span class="text-muted ms-2">18%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-bar-label">3 sao</span>
                                            <div class="progress flex-fill">
                                                <div class="progress-bar" style="width: 5%"></div>
                                            </div>
                                            <span class="text-muted ms-2">5%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-bar-label">2 sao</span>
                                            <div class="progress flex-fill">
                                                <div class="progress-bar" style="width: 1%"></div>
                                            </div>
                                            <span class="text-muted ms-2">1%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-bar-label">1 sao</span>
                                            <div class="progress flex-fill">
                                                <div class="progress-bar" style="width: 1%"></div>
                                            </div>
                                            <span class="text-muted ms-2">1%</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sample Reviews -->
                                <div class="review-item">
                                    <div class="review-header">
                                        <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                             alt="Reviewer" class="reviewer-avatar">
                                        <div class="reviewer-info">
                                            <h6>Nguyễn Thị C</h6>
                                            <div class="review-date">Tháng 6, 2024</div>
                                        </div>
                                        <div class="review-rating">
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                        </div>
                                    </div>
                                    <p>Trải nghiệm tuyệt vời! Hướng dẫn viên rất nhiệt tình và am hiểu về văn hóa địa phương. Tôi đã học được rất nhiều điều thú vị và có những kỷ niệm đáng nhớ.</p>
                                </div>

                                <div class="review-item">
                                    <div class="review-header">
                                        <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                             alt="Reviewer" class="reviewer-avatar">
                                        <div class="reviewer-info">
                                            <h6>Lê Văn D</h6>
                                            <div class="review-date">Tháng 5, 2024</div>
                                        </div>
                                        <div class="review-rating">
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-fill"></i>
                                            <i class="ri-star-line"></i>
                                        </div>
                                    </div>
                                    <p>Hoạt động được tổ chức rất chuyên nghiệp. Lịch trình hợp lý, không bị vội vàng. Rất phù hợp cho gia đình có trẻ em. Sẽ giới thiệu cho bạn bè.</p>
                                </div>

                                <div class="text-center mt-4">
                                    <button class="btn btn-outline-primary">
                                        <i class="ri-more-line me-2"></i>Xem thêm đánh giá
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="ri-chat-3-line" style="font-size: 3rem; color: #6c757d; margin-bottom: 20px;"></i>
                                    <h5>Chưa có đánh giá nào</h5>
                                    <p class="text-muted">Hãy là người đầu tiên đánh giá trải nghiệm này!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Location Section -->
                    <div class="content-section" id="location">
                        <h3 class="section-title">
                            <i class="ri-map-pin-line"></i>
                            Địa điểm
                        </h3>

                        <p class="mb-3">
                            <strong>Điểm hẹn:</strong> ${experience.location}
                            <c:if test="${not empty experience.cityName}">
                                , ${experience.cityName}
                            </c:if>
                        </p>

                        <div class="map-container">
                            <div class="text-center">
                                <i class="ri-map-pin-line" style="font-size: 3rem; margin-bottom: 15px;"></i>
                                <h5>Bản đồ sẽ được hiển thị ở đây</h5>
                                <p class="text-muted">Tích hợp Google Maps hoặc OpenStreetMap</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar - Booking Card -->
                <div class="sidebar">
                    <div class="booking-card">
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

                        <form class="booking-form" action="${pageContext.request.contextPath}/booking" method="get">
                            <input type="hidden" name="experienceId" value="${experience.experienceId}">

                            <div class="form-group">
                                <label for="bookingDate">Ngày tham gia</label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" required>
                            </div>

                            <div class="form-group">
                                <label for="participants">Số người tham gia</label>
                                <select class="form-control" id="participants" name="participants" required>
                                    <option value="">Chọn số người</option>
                                    <c:forEach begin="1" end="${experience.maxGroupSize}" var="i">
                                        <option value="${i}">${i} người</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="timeSlot">Khung giờ</label>
                                <select class="form-control" id="timeSlot" name="timeSlot" required>
                                    <option value="">Chọn khung giờ</option>
                                    <option value="morning">Buổi sáng (9:00 - 12:00)</option>
                                    <option value="afternoon">Buổi chiều (14:00 - 17:00)</option>
                                    <option value="evening">Buổi tối (18:00 - 21:00)</option>
                                </select>
                            </div>

                            <div class="booking-summary" id="bookingSummary" style="display: none;">
                                <div class="summary-row">
                                    <span>Giá × <span id="participantCount">0</span> người</span>
                                    <span id="totalPrice">0 VNĐ</span>
                                </div>
                                <div class="summary-row">
                                    <span>Phí dịch vụ</span>
                                    <span id="serviceFee">0 VNĐ</span>
                                </div>
                                <div class="summary-row summary-total">
                                    <span>Tổng cộng</span>
                                    <span id="finalTotal">0 VNĐ</span>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="ri-calendar-check-line me-2"></i>Đặt Ngay
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary w-100">
                                        <i class="ri-login-circle-line me-2"></i>Đăng Nhập để Đặt
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </form>

                        <div class="text-center mt-3">
                            <small class="text-muted">Bạn sẽ chưa bị tính phí</small>
                        </div>

                        <div class="text-center mt-3">
                            <button class="btn-copy w-100" onclick="shareExperience()">
                                <i class="ri-share-line"></i>
                                <span>Chia sẻ trải nghiệm này</span>
                            </button>
                        </div>
                    </div>

                    <!-- Contact Host -->
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-3">Liên hệ hướng dẫn viên</h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary btn-sm">
                                <i class="ri-message-3-line me-2"></i>Gửi tin nhắn
                            </button>
                            <button class="btn btn-outline-primary btn-sm">
                                <i class="ri-phone-line me-2"></i>Gọi điện thoại
                            </button>
                        </div>
                    </div>

                    <!-- Safety Info -->
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-3">
                            <i class="ri-shield-check-line me-2"></i>An toàn & Bảo mật
                        </h6>
                        <ul class="list-unstyled mb-0 small">
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Thanh toán an toàn
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Hướng dẫn viên đã xác minh
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Hỗ trợ 24/7
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
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
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

                                // Initialize Swiper
                                const swiper = new Swiper('.experience-swiper', {
                                    loop: true,
                                    autoplay: {
                                        delay: 4000,
                                        disableOnInteraction: false,
                                    },
                                    pagination: {
                                        el: '.swiper-pagination',
                                        clickable: true,
                                    },
                                    navigation: {
                                        nextEl: '.swiper-button-next',
                                        prevEl: '.swiper-button-prev',
                                    },
                                    effect: 'fade',
                                    fadeEffect: {
                                        crossFade: true
                                    }
                                });

                                // Booking form functionality
                                const bookingDateInput = document.getElementById('bookingDate');
                                const participantsSelect = document.getElementById('participants');
                                const timeSlotSelect = document.getElementById('timeSlot');
                                const bookingSummary = document.getElementById('bookingSummary');
                                const pricePerPerson = ${experience.price};

                                // Set minimum date to today
                                const today = new Date().toISOString().split('T')[0];
                                bookingDateInput.min = today;

                                // Calculate total when participants change
                                participantsSelect.addEventListener('change', calculateTotal);
                                timeSlotSelect.addEventListener('change', calculateTotal);
                                bookingDateInput.addEventListener('change', calculateTotal);

                                function calculateTotal() {
                                    const participants = parseInt(participantsSelect.value);
                                    const date = bookingDateInput.value;
                                    const timeSlot = timeSlotSelect.value;

                                    if (participants && date && timeSlot) {
                                        const totalPrice = participants * pricePerPerson;
                                        const serviceFee = Math.round(totalPrice * 0.05); // 5% service fee
                                        const finalTotal = totalPrice + serviceFee;

                                        document.getElementById('participantCount').textContent = participants;
                                        document.getElementById('totalPrice').textContent = formatCurrency(totalPrice);
                                        document.getElementById('serviceFee').textContent = formatCurrency(serviceFee);
                                        document.getElementById('finalTotal').textContent = formatCurrency(finalTotal);

                                        bookingSummary.style.display = 'block';
                                    } else {
                                        bookingSummary.style.display = 'none';
                                    }
                                }

                                function formatCurrency(amount) {
                                    return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                }

                                // Share experience function
                                function shareExperience() {
                                    const url = window.location.href;
                                    const experienceTitle = '${experience.title}';
                                    const shareText = `Khám phá "${experienceTitle}" tại VietCulture: ${url}`;

                                    if (navigator.share) {
                                        navigator.share({
                                            title: experienceTitle,
                                            text: `Khám phá "${experienceTitle}" tại VietCulture`,
                                            url: url
                                        }).catch(err => console.log('Error sharing:', err));
                                    } else if (navigator.clipboard) {
                                        navigator.clipboard.writeText(shareText)
                                                .then(() => {
                                                    showToast(`Đã sao chép link "${experienceTitle}"`, 'success');
                                                })
                                                .catch(err => {
                                                    showToast('Không thể sao chép: ' + err, 'error');
                                                });
                                    }
                                }

                                // Save experience function
                                function saveExperience() {
                                    // This would typically save to user's favorites
                                    // For now, just show a toast
                                    const heartIcon = event.target.closest('.action-btn').querySelector('i');

                                    if (heartIcon.classList.contains('ri-heart-line')) {
                                        heartIcon.classList.remove('ri-heart-line');
                                        heartIcon.classList.add('ri-heart-fill');
                                        heartIcon.style.color = 'var(--primary-color)';
                                        showToast('Đã lưu vào danh sách yêu thích', 'success');
                                    } else {
                                        heartIcon.classList.remove('ri-heart-fill');
                                        heartIcon.classList.add('ri-heart-line');
                                        heartIcon.style.color = '';
                                        showToast('Đã bỏ khỏi danh sách yêu thích', 'info');
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

                                // Smooth scroll for anchor links
                                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                                    anchor.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        const target = document.querySelector(this.getAttribute('href'));
                                        if (target) {
                                            target.scrollIntoView({
                                                behavior: 'smooth',
                                                block: 'start'
                                            });
                                        }
                                    });
                                });

                                // Initialize page
                                document.addEventListener('DOMContentLoaded', function () {
                                    // Initial animation check
                                    animateOnScroll();

                                    // Focus on booking date when page loads
                                    if (bookingDateInput) {
                                        bookingDateInput.focus();
                                    }

                                    // Initialize tooltips if any
                                    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                        return new bootstrap.Tooltip(tooltipTriggerEl);
                                    });
                                });

                                // Handle booking form submission

                                document.querySelector('.booking-form').addEventListener('submit', function (e) {
                                    // Bỏ e.preventDefault(); để cho phép form submit bình thường

                                    const bookingDate = bookingDateInput.value;
                                    const participants = participantsSelect.value;
                                    const timeSlot = timeSlotSelect.value;

                                    if (!bookingDate || !participants || !timeSlot) {
                                        e.preventDefault(); // Chỉ preventDefault khi có lỗi
                                        showToast('Vui lòng điền đầy đủ thông tin đặt chỗ', 'error');
                                        return;
                                    }

                                    const selectedDate = new Date(bookingDate);
                                    const today = new Date();
                                    today.setHours(0, 0, 0, 0);

                                    if (selectedDate < today) {
                                        e.preventDefault(); // Chỉ preventDefault khi có lỗi
                                        showToast('Ngày tham gia không thể là ngày trong quá khứ', 'error');
                                        return;
                                    }

                                    // Nếu không có lỗi, form sẽ submit bình thường và chuyển trang
                                    // Show loading state
                                    const submitBtn = this.querySelector('button[type="submit"]');
                                    const originalText = submitBtn.innerHTML;
                                    submitBtn.innerHTML = '<i class="ri-loader-2-line"></i> Đang xử lý...';
                                    submitBtn.disabled = true;
                                });

                                // Image lazy loading
                                const images = document.querySelectorAll('img');
                                const imageObserver = new IntersectionObserver((entries, observer) => {
                                    entries.forEach(entry => {
                                        if (entry.isIntersecting) {
                                            const img = entry.target;
                                            if (img.dataset.src) {
                                                img.src = img.dataset.src;
                                                img.removeAttribute('data-src');
                                            }
                                            observer.unobserve(img);
                                        }
                                    });
                                });

                                images.forEach(img => imageObserver.observe(img));
        </script>
    </body>
</html>
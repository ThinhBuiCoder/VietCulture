<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin Nhắn | VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        /* CSS cho message icon */
        .nav-chat-link {
            position: relative;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

        .nav-chat-link:hover {
            color: var(--primary-color) !important;
            background-color: rgba(255, 56, 92, 0.1);
            transform: translateY(-1px);
        }

        .message-badge {
            position: absolute;
            top: -2px;
            right: -2px;
            background: #FF385C;
            color: white;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 0.6rem;
            font-weight: 600;
            border: 2px solid #10466C;
            animation: pulse 2s infinite;
        }

        .message-badge.show {
            display: flex;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(255, 56, 92, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(255, 56, 92, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(255, 56, 92, 0);
            }
        }

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

        /* Chat Container */
        .chat-main-container {
            margin-top: 40px;
            margin-bottom: 60px;
        }

        .chat-header-section {
            background: var(--gradient-primary);
            color: white;
            padding: 60px 0;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }

        .chat-header-section::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 50px;
            background: linear-gradient(to top, var(--accent-color), transparent);
        }

        .chat-header-section h1 {
            font-size: 3rem;
            margin-bottom: 20px;
            font-weight: 800;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .chat-header-section p {
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto 30px;
            text-shadow: 0 1px 5px rgba(0,0,0,0.2);
        }

        .unread-badge {
            background: #FFD700;
            color: var(--dark-color);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 10px;
        }

        .chat-container {
            background: var(--light-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            margin-bottom: 40px;
        }

        .search-section {
            background: var(--light-color);
            padding: 30px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .search-input-group {
            display: flex;
            align-items: center;
            background: var(--accent-color);
            border-radius: 15px;
            padding: 15px 20px;
            gap: 15px;
            transition: var(--transition);
        }

        .search-input-group:focus-within {
            background: white;
            box-shadow: var(--shadow-md);
        }

        .search-input {
            border: none;
            background: transparent;
            flex: 1;
            font-size: 1rem;
            color: var(--dark-color);
        }

        .search-input:focus {
            outline: none;
        }

        .search-input::placeholder {
            color: #9CA3AF;
        }

        .btn-new-chat {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 30px;
            font-weight: 600;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-new-chat:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            color: white;
        }

        .chat-list {
            min-height: 400px;
        }

        .chat-item {
            display: flex;
            align-items: center;
            padding: 25px 30px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            color: inherit;
            position: relative;
        }

        .chat-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--primary-color);
            opacity: 0;
            transition: var(--transition);
        }

        .chat-item:hover {
            background-color: rgba(255, 56, 92, 0.02);
            color: inherit;
            text-decoration: none;
            transform: translateX(5px);
        }

        .chat-item:hover::before {
            opacity: 1;
        }

        .chat-item.unread {
            background-color: rgba(255, 56, 92, 0.05);
        }

        .chat-item.unread::before {
            opacity: 1;
        }

        .chat-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 20px;
            border: 3px solid var(--secondary-color);
            transition: var(--transition);
        }

        .chat-item:hover .chat-avatar {
            transform: scale(1.05);
        }

        .chat-info {
            flex: 1;
            min-width: 0;
        }

        .chat-name {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-color);
            font-size: 1.1rem;
        }

        .chat-subject {
            font-size: 0.9rem;
            color: var(--secondary-color);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .chat-last-message {
            font-size: 0.9rem;
            color: #6B7280;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            max-width: 300px;
        }

        .chat-meta {
            text-align: right;
            min-width: 100px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
        }

        .chat-time {
            font-size: 0.8rem;
            color: #9CA3AF;
        }

        .chat-unread-count {
            background: var(--primary-color);
            color: white;
            border-radius: 20px;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: 600;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(255, 56, 92, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #6B7280;
        }

        .empty-state i {
            font-size: 5rem;
            margin-bottom: 30px;
            color: var(--primary-color);
            opacity: 0.5;
        }

        .empty-state h3 {
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .empty-state p {
            margin-bottom: 30px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #10B981;
            position: absolute;
            bottom: 2px;
            right: 2px;
            border: 3px solid white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .avatar-container {
            position: relative;
            display: inline-block;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--shadow-lg);
        }

        .modal-header {
            background: var(--gradient-primary);
            color: white;
            border-radius: var(--border-radius) var(--border-radius) 0 0;
            border-bottom: none;
        }

        .modal-title {
            font-weight: 600;
        }

        .btn-close {
            filter: invert(1);
        }

        .form-select, .form-control {
            border-radius: 10px;
            border: 2px solid rgba(0,0,0,0.1);
            padding: 12px;
            transition: var(--transition);
        }

        .form-select:focus, .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
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

        /* Toast Notification */
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

        /* Responsive */
        @media (max-width: 992px) {
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

            .chat-header-section h1 {
                font-size: 2.5rem;
            }
        }

        @media (max-width: 768px) {
            .chat-item {
                padding: 20px 15px;
            }

            .chat-avatar {
                width: 50px;
                height: 50px;
                margin-right: 15px;
            }

            .chat-header-section h1 {
                font-size: 2rem;
            }

            .custom-navbar {
                padding: 10px 0;
            }

            .nav-right {
                margin-top: 15px;
            }

            .search-section {
                padding: 20px 15px;
            }

            .btn-new-chat {
                font-size: 0.9rem;
                padding: 10px 20px;
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
                <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item">
                    Trải Nghiệm
                </a>
                <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item">
                    Lưu Trú
                </a>
            </div>

            <div class="nav-right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Icon tin nhắn cho TẤT CẢ user đã đăng nhập -->
                        <a href="${pageContext.request.contextPath}/chat" class="nav-chat-link me-3">
                            <i class="ri-message-3-line" style="font-size: 1.2rem;"></i>
                            <span class="message-badge"></span>
                        </a>
                        
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
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_service">
                                            <i class="ri-add-circle-line"></i> Tạo Dịch Vụ
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/host/services/manage">
                                            <i class="ri-settings-4-line"></i> Quản Lý Dịch Vụ
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/traveler/upgrade-to-host">
                                            <i class="ri-vip-crown-line"></i> Nâng Lên Host
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
                        <a href="#become-host" class="me-3">Trở thành host</a>
                        <i class="ri-global-line globe-icon me-3"></i>
                        <div class="menu-icon">
                            <i class="ri-menu-line"></i>
                            <div class="dropdown-menu-custom">
                                <a href="#help-center">
                                    <i class="ri-question-line"></i>Trung tâm Trợ giúp
                                </a>
                                <a href="${pageContext.request.contextPath}/contact">
                                    <i class="ri-contacts-line"></i>Liên Hệ
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                    <i class="ri-login-circle-line"></i> Đăng Nhập
                                </a>
                                <a href="${pageContext.request.contextPath}/register">
                                    <i class="ri-user-add-line"></i>Đăng Ký
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Chat Header Section -->
    <section class="chat-header-section">
        <div class="container">
            <div class="fade-up">
                <h1 class="animate__animated animate__fadeInUp">
                    <i class="ri-message-3-line me-3"></i>Tin Nhắn
                    <c:if test="${unreadCount > 0}">
                        <span class="unread-badge">${unreadCount}</span>
                    </c:if>
                </h1>
                <p class="animate__animated animate__fadeInUp animate__delay-1s">
                    Kết nối và trò chuyện với host để có những trải nghiệm du lịch tuyệt vời nhất
                </p>
                <!-- Xoá hoàn toàn nút tạo chat mới khỏi giao diện -->
            </div>
        </div>
    </section>

    <!-- Main Chat Container -->
    <div class="container chat-main-container">
        <div class="chat-container fade-up">
            <!-- Search Section -->
            <div class="search-section">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="search-input-group">
                            <i class="ri-search-line" style="color: #9CA3AF; font-size: 1.2rem;"></i>
                            <input type="text" class="search-input" placeholder="Tìm kiếm cuộc trò chuyện..." id="searchInput">
                        </div>
                    </div>
                    <!-- XÓA NÚT TẠO CHAT MỚI Ở PHẦN SEARCH SECTION -->
                </div>
            </div>

            <!-- Chat List -->
            <div class="chat-list" id="chatList">
                <c:choose>
                    <c:when test="${empty chatRooms}">
                        <div class="empty-state">
                            <i class="ri-chat-3-line"></i>
                            <h3>Chưa có cuộc trò chuyện nào</h3>
                            <p>Bắt đầu chat với host để được tư vấn về trải nghiệm du lịch và nơi lưu trú tuyệt vời</p>
                            <!-- XÓA NÚT TẠO CHAT ĐẦU TIÊN TRONG EMPTY STATE -->
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="room" items="${chatRooms}">
                            <a href="${pageContext.request.contextPath}/chat/room/${room.chatRoomId}" class="chat-item">
                                <c:choose>
                                    <c:when test="${room.userId == currentUser.userId}">
                                        <!-- User đang chat với Host -->
                                        <div class="avatar-container">
                                            <img src="${not empty room.hostAvatar ? room.hostAvatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                                                 alt="${room.hostName}" class="chat-avatar">
                                            <span class="status-indicator"></span>
                                        </div>
                                        <div class="chat-info">
                                            <div class="chat-name">${room.hostName}</div>
                                            <div class="chat-subject">
                                                <c:choose>
                                                    <c:when test="${not empty room.experienceTitle}">
                                                        <i class="ri-map-pin-line"></i>${room.experienceTitle}
                                                    </c:when>
                                                    <c:when test="${not empty room.accommodationName}">
                                                        <i class="ri-home-line"></i>${room.accommodationName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="ri-user-line"></i>Chat trực tiếp
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="chat-last-message">
                                                ${not empty room.lastMessage ? room.lastMessage : 'Chưa có tin nhắn'}
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Host đang chat với User -->
                                        <div class="avatar-container">
                                            <img src="${not empty room.userAvatar ? room.userAvatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                                                 alt="${room.userName}" class="chat-avatar">
                                            <span class="status-indicator"></span>
                                        </div>
                                        <div class="chat-info">
                                            <div class="chat-name">${room.userName}</div>
                                            <div class="chat-subject">
                                                <c:choose>
                                                    <c:when test="${not empty room.experienceTitle}">
                                                        <i class="ri-map-pin-line"></i>${room.experienceTitle}
                                                    </c:when>
                                                    <c:when test="${not empty room.accommodationName}">
                                                        <i class="ri-home-line"></i>${room.accommodationName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="ri-user-line"></i>Khách hàng quan tâm
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="chat-last-message">
                                                ${not empty room.lastMessage ? room.lastMessage : 'Chưa có tin nhắn'}
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="chat-meta">
                                    <c:if test="${not empty room.lastMessageAt}">
                                        <div class="chat-time">
                                            <fmt:formatDate value="${room.lastMessageAt}" pattern="HH:mm"/>
                                        </div>
                                    </c:if>
                                    <!-- Unread count badge sẽ được thêm bằng JavaScript -->
                                    <div class="chat-unread-count" style="display: none;" data-room-id="${room.chatRoomId}">0</div>
                                </div>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Chat Mới -->
    <div class="modal fade" id="newChatModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="ri-chat-new-line me-2"></i>Tạo Cuộc Trò Chuyện Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="newChatForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="ri-user-star-line me-1"></i>Chọn Host
                                </label>
                                <select class="form-select" id="hostSelect" required>
                                    <option value="">-- Chọn Host --</option>
                                    <!-- Hosts sẽ được load bằng JavaScript -->
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="ri-compass-3-line me-1"></i>Trải Nghiệm (tùy chọn)
                                </label>
                                <select class="form-select" id="experienceSelect">
                                    <option value="">-- Chọn Trải Nghiệm --</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="ri-message-2-line me-1"></i>Tin nhắn đầu tiên
                            </label>
                            <textarea class="form-control" id="firstMessage" rows="4" 
                                placeholder="Xin chào! Tôi quan tâm đến dịch vụ của bạn và muốn tìm hiểu thêm..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="ri-close-line me-1"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-primary" onclick="createNewChat()">
                        <i class="ri-send-plane-line me-1"></i>Bắt Đầu Chat
                    </button>
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
                    <p><i class="ri-map-pin-line me-2"></i> Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam</p>
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

    <!-- Toast Notification Container -->
    <div class="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dropdown menu functionality
        const menuIcon = document.querySelector('.menu-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

        if (menuIcon && dropdownMenu) {
            menuIcon.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            document.addEventListener('click', function() {
                dropdownMenu.classList.remove('show');
            });

            dropdownMenu.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        }

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
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

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const chatItems = document.querySelectorAll('.chat-item');
            
            chatItems.forEach(item => {
                const name = item.querySelector('.chat-name').textContent.toLowerCase();
                const subject = item.querySelector('.chat-subject').textContent.toLowerCase();
                const lastMessage = item.querySelector('.chat-last-message').textContent.toLowerCase();
                
                if (name.includes(searchTerm) || subject.includes(searchTerm) || lastMessage.includes(searchTerm)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // Show new chat modal
        function showNewChatModal() {
            const modal = new bootstrap.Modal(document.getElementById('newChatModal'));
            loadHosts();
            modal.show();
        }

        // Load hosts
        function loadHosts() {
            fetch('${pageContext.request.contextPath}/api/hosts')
                .then(response => response.json())
                .then(hosts => {
                    const hostSelect = document.getElementById('hostSelect');
                    hostSelect.innerHTML = '<option value="">-- Chọn Host --</option>';
                    
                    hosts.forEach(host => {
                        const option = document.createElement('option');
                        option.value = host.userId;
                        option.textContent = host.fullName + (host.businessName ? ' (' + host.businessName + ')' : '');
                        hostSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error loading hosts:', error);
                    showToast('Có lỗi xảy ra khi tải danh sách host', 'error');
                });
        }

        // Load experiences when host is selected
        document.getElementById('hostSelect').addEventListener('change', function() {
            const hostId = this.value;
            const experienceSelect = document.getElementById('experienceSelect');
            
            if (hostId) {
                fetch(`${pageContext.request.contextPath}/api/experiences/by-host/${hostId}`)
                    .then(response => response.json())
                    .then(experiences => {
                        experienceSelect.innerHTML = '<option value="">-- Chọn Trải Nghiệm --</option>';
                        
                        experiences.forEach(exp => {
                            const option = document.createElement('option');
                            option.value = exp.experienceId;
                            option.textContent = exp.title;
                            experienceSelect.appendChild(option);
                        });
                    })
                    .catch(error => {
                        console.error('Error loading experiences:', error);
                        experienceSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
                    });
            } else {
                experienceSelect.innerHTML = '<option value="">-- Chọn Trải Nghiệm --</option>';
            }
        });

        // Create new chat
        function createNewChat() {
            const hostId = document.getElementById('hostSelect').value;
            const experienceId = document.getElementById('experienceSelect').value;
            const firstMessage = document.getElementById('firstMessage').value;

            if (!hostId) {
                showToast('Vui lòng chọn Host', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('hostId', hostId);
            if (experienceId) {
                formData.append('experienceId', experienceId);
            }

            fetch('${pageContext.request.contextPath}/chat/api/create-room', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(chatRoom => {
                // Nếu có tin nhắn đầu tiên, gửi luôn
                if (firstMessage.trim()) {
                    const messageData = new FormData();
                    messageData.append('roomId', chatRoom.chatRoomId);
                    messageData.append('receiverId', hostId);
                    messageData.append('messageContent', firstMessage);
                    
                    fetch('${pageContext.request.contextPath}/chat/api/send-message', {
                        method: 'POST',
                        body: messageData
                    });
                }
                
                // Chuyển đến chat room
                window.location.href = `${pageContext.request.contextPath}/chat/room/${chatRoom.chatRoomId}`;
            })
            .catch(error => {
                console.error('Error creating chat:', error);
                showToast('Có lỗi xảy ra khi tạo chat', 'error');
            });
        }

        // Update message badge in navbar
        function updateMessageBadge() {
            <c:if test="${not empty sessionScope.user}">
            fetch('${pageContext.request.contextPath}/chat/api/unread-count')
                .then(response => response.json())
                .then(data => {
                    const unreadCount = data.unreadCount || 0;
                    const chatLink = document.querySelector('.nav-chat-link');
                    
                    if (chatLink) {
                        let badge = chatLink.querySelector('.message-badge');
                        
                        if (unreadCount > 0) {
                            if (!badge) {
                                badge = document.createElement('span');
                                badge.className = 'message-badge';
                                chatLink.appendChild(badge);
                            }
                            
                            badge.textContent = unreadCount > 99 ? '99+' : unreadCount;
                            badge.classList.add('show');
                        } else {
                            if (badge) {
                                badge.classList.remove('show');
                            }
                        }
                    }
                })
                .catch(error => {
                    console.error('Error getting unread count:', error);
                });
            </c:if>
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

        // Auto refresh every 30 seconds
        setInterval(() => {
            updateMessageBadge();
            // Có thể reload danh sách chat hoặc update dynamic content
        }, 30000);

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Initial animation check
            animateOnScroll();
            
            // Update message badge
            updateMessageBadge();
            
            // Update badge when page gets focus
            window.addEventListener('focus', updateMessageBadge);
        });
    </script>
</body>
</html>
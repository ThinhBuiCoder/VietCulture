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
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
            --gradient-accent: linear-gradient(135deg, #FF385C, #FF6B6B);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
            --shadow-xl: 0 20px 40px rgba(0,0,0,0.15);
            --border-radius: 16px;
            --border-radius-lg: 24px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            --border-color: #E5E7EB;
            --hover-color: #F9FAFB;
            --text-light: #6B7280;
            --text-dark: #1F2937;
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
            background: linear-gradient(135deg, rgba(255, 56, 92, 0.05), rgba(131, 197, 190, 0.05)), var(--accent-color);
            padding: 0;
            margin: 0;
            min-height: 100vh;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
        }

        /* Modern Navbar */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: rgba(16, 70, 108, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 1000;
            padding: 12px 0;
            transition: var(--transition);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.4rem;
            color: white;
            text-decoration: none;
            transition: var(--transition);
        }

        .navbar-brand:hover {
            color: var(--primary-color);
            transform: translateY(-1px);
        }

        .navbar-brand img {
            height: 45px !important;
            width: auto !important;
            margin-right: 12px !important;
            filter: drop-shadow(0 2px 8px rgba(0,0,0,0.2)) !important;
            object-fit: contain !important;
            display: inline-block !important;
        }

        .nav-link {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 8px;
            transition: var(--transition);
        }

        .nav-link:hover {
            color: var(--primary-color);
            background: rgba(255, 56, 92, 0.1);
            transform: translateY(-1px);
        }

        .nav-chat-link {
            position: relative;
            color: rgba(255,255,255,0.8);
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

        /* Main Container */
        .chat-list-container {
            padding-top: 100px;
            padding-bottom: 40px;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
        }

        /* Header Section */
        .chat-header-section {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-xl);
            padding: 40px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .chat-header-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23f8f9fa' fill-opacity='0.5'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
            opacity: 0.3;
        }

        .chat-header-content {
            position: relative;
            z-index: 1;
        }

        .chat-title {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-align: center;
        }

        .chat-subtitle {
            color: var(--text-light);
            font-size: 1.1rem;
            text-align: center;
            margin-bottom: 0;
        }

        /* Search Section */
        .search-section {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: 25px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .search-input-group {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 16px 50px 16px 20px;
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 16px;
            transition: var(--transition);
            background: var(--accent-color);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(255, 56, 92, 0.1);
            background: white;
        }

        .search-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--gradient-primary);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }

        .search-btn:hover {
            transform: translateY(-50%) scale(1.05);
            box-shadow: 0 6px 16px rgba(255, 56, 92, 0.4);
        }

        /* Chat List Section */
        .chat-list-section {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .chat-list-header {
            background: var(--gradient-secondary);
            color: white;
            padding: 20px 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .chat-list-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin: 0;
        }

        .unread-count {
            background: rgba(255, 56, 92, 0.9);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* Chat Items */
        .chat-list {
            max-height: 600px;
            overflow-y: auto;
            padding: 0;
        }

        .chat-item {
            display: flex;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid var(--border-color);
            text-decoration: none;
            color: inherit;
            transition: var(--transition);
            position: relative;
            cursor: pointer;
        }

        .chat-item:hover {
            background: var(--hover-color);
            transform: translateX(5px);
            color: inherit;
            text-decoration: none;
        }

        .chat-item:last-child {
            border-bottom: none;
        }

        .chat-item.unread {
            background: rgba(255, 56, 92, 0.02);
            border-left: 4px solid var(--primary-color);
        }

        .chat-item.unread:hover {
            background: rgba(255, 56, 92, 0.05);
        }

        .chat-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 16px;
            border: 3px solid rgba(255, 56, 92, 0.1);
            transition: var(--transition);
            position: relative;
        }

        .chat-item:hover .chat-avatar {
            border-color: var(--primary-color);
            transform: scale(1.05);
        }

        .chat-info {
            flex: 1;
            min-width: 0;
        }

        .chat-name {
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--text-dark);
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .chat-subject {
            background: var(--gradient-accent);
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .chat-last-message {
            color: var(--text-light);
            font-size: 0.95rem;
            margin-bottom: 4px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .chat-item.unread .chat-last-message {
            color: var(--text-dark);
            font-weight: 500;
        }

        .chat-time {
            color: var(--text-light);
            font-size: 0.8rem;
            font-weight: 500;
        }

        .chat-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
        }

        .chat-unread-badge {
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 600;
            animation: pulse 2s infinite;
        }

        .online-indicator {
            position: absolute;
            bottom: 4px;
            right: 4px;
            width: 16px;
            height: 16px;
            background: #10B981;
            border: 3px solid white;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: var(--text-light);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .empty-description {
            font-size: 1rem;
            line-height: 1.6;
        }

        /* Action Buttons */
        .action-buttons {
            padding: 25px;
            background: var(--accent-color);
            border-top: 1px solid var(--border-color);
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn {
            border-radius: var(--border-radius);
            padding: 12px 24px;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            background: transparent;
        }

        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Scrollbar Styling */
        .chat-list::-webkit-scrollbar {
            width: 6px;
        }

        .chat-list::-webkit-scrollbar-track {
            background: transparent;
        }

        .chat-list::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 10px;
            opacity: 0.5;
        }

        .chat-list::-webkit-scrollbar-thumb:hover {
            background: var(--dark-color);
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 56, 92, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(255, 56, 92, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 56, 92, 0); }
        }

        .chat-item {
            animation: fadeInUp 0.6s ease-out;
        }

        .chat-item:nth-child(1) { animation-delay: 0.1s; }
        .chat-item:nth-child(2) { animation-delay: 0.2s; }
        .chat-item:nth-child(3) { animation-delay: 0.3s; }
        .chat-item:nth-child(4) { animation-delay: 0.4s; }
        .chat-item:nth-child(5) { animation-delay: 0.5s; }

        /* Loading States */
        .loading-shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        /* Toast Notifications */
        .toast-container {
            position: fixed;
            top: 100px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            background: white;
            color: var(--text-dark);
            padding: 16px 20px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            margin-bottom: 10px;
            border-left: 4px solid var(--primary-color);
            animation: slideInRight 0.5s ease-out;
        }

        .toast.success {
            border-left-color: #10B981;
        }

        .toast.error {
            border-left-color: #EF4444;
        }

        .toast.warning {
            border-left-color: #F59E0B;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .chat-list-container {
                padding-top: 90px;
                padding-left: 10px;
                padding-right: 10px;
            }

            .chat-header-section,
            .search-section,
            .chat-list-section {
                border-radius: var(--border-radius);
                padding: 20px;
            }

            .chat-title {
                font-size: 2rem;
            }

            .chat-item {
                padding: 15px 20px;
            }

            .chat-avatar {
                width: 50px;
                height: 50px;
            }

            .chat-name {
                font-size: 1rem;
            }

            .action-buttons {
                padding: 20px;
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }
        }
    </style>
</head>

<body>
    <!-- Enhanced Navbar -->
    <nav class="custom-navbar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center w-100">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                    VietCulture
                </a>
                
                <div class="d-flex align-items-center gap-3">
                    <c:if test="${sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER'}">
                        <a href="${pageContext.request.contextPath}/chat" class="nav-chat-link">
                            <i class="ri-message-3-line" style="font-size: 1.2rem;"></i>
                            <span class="message-badge" id="unreadBadge">0</span>
                        </a>
                    </c:if>
                    
                    <div class="dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="ri-user-line me-2"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="ri-user-line me-2"></i>Hồ sơ
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="ri-logout-box-line me-2"></i>Đăng xuất
                            </a></li>
                        </ul>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/" class="nav-link">
                        <i class="ri-home-line me-2"></i>Trang chủ
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="chat-list-container">
        <div class="container">
            <!-- Header Section -->
            <div class="chat-header-section animate__animated animate__fadeInUp">
                <div class="chat-header-content">
                    <h1 class="chat-title">Tin Nhắn</h1>
                    <p class="chat-subtitle">Quản lý cuộc trò chuyện với các đối tác và khách hàng</p>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section animate__animated animate__fadeInUp animate__delay-1s">
                <div class="search-input-group">
                    <input type="text" class="search-input" placeholder="Tìm kiếm cuộc trò chuyện..." id="searchInput">
                    <button class="search-btn" onclick="searchChats()">
                        <i class="ri-search-line"></i>
                    </button>
                </div>
            </div>

            <!-- Chat List Section -->
            <div class="chat-list-section animate__animated animate__fadeInUp animate__delay-2s">
                <div class="chat-list-header">
                    <h3 class="chat-list-title">
                        <i class="ri-chat-3-line me-2"></i>Cuộc trò chuyện
                    </h3>
                    <c:if test="${unreadCount > 0}">
                        <div class="unread-count">${unreadCount} chưa đọc</div>
                    </c:if>
                </div>

                <div class="chat-list" id="chatList">
                    <c:choose>
                        <c:when test="${empty chatRooms}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="ri-chat-3-line"></i>
                                </div>
                                <h4 class="empty-title">Chưa có cuộc trò chuyện nào</h4>
                                <p class="empty-description">
                                    Bắt đầu trò chuyện với host hoặc khách hàng để kết nối và chia sẻ những trải nghiệm tuyệt vời!
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="chatRoom" items="${chatRooms}" varStatus="status">
                                <a href="${pageContext.request.contextPath}/chat/room/${chatRoom.chatRoomId}" 
                                   class="chat-item ${chatRoom.unreadCount > 0 ? 'unread' : ''}"
                                   data-room-id="${chatRoom.chatRoomId}">
                                    
                                    <div class="position-relative">
                                        <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                             alt="Avatar" class="chat-avatar">
                                        <div class="online-indicator"></div>
                                    </div>
                                    
                                    <div class="chat-info">
                                        <div class="chat-name">
                                            <c:choose>
                                                <c:when test="${chatRoom.userId == sessionScope.user.userId}">
                                                    ${chatRoom.hostName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${chatRoom.userName}
                                                </c:otherwise>
                                            </c:choose>
                                            
                                                                                         <c:if test="${not empty chatRoom.experienceTitle}">
                                                 <span class="chat-subject">
                                                     <i class="ri-map-pin-line"></i>
                                                     <c:choose>
                                                         <c:when test="${fn:length(chatRoom.experienceTitle) gt 15}">
                                                             ${fn:substring(chatRoom.experienceTitle, 0, 15)}...
                                                         </c:when>
                                                         <c:otherwise>
                                                             ${chatRoom.experienceTitle}
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </span>
                                             </c:if>
                                             <c:if test="${not empty chatRoom.accommodationName}">
                                                 <span class="chat-subject">
                                                     <i class="ri-home-line"></i>
                                                     <c:choose>
                                                         <c:when test="${fn:length(chatRoom.accommodationName) gt 15}">
                                                             ${fn:substring(chatRoom.accommodationName, 0, 15)}...
                                                         </c:when>
                                                         <c:otherwise>
                                                             ${chatRoom.accommodationName}
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </span>
                                             </c:if>
                                        </div>
                                        
                                                                                 <div class="chat-last-message">
                                             <c:choose>
                                                 <c:when test="${not empty chatRoom.lastMessage}">
                                                     <c:choose>
                                                         <c:when test="${fn:length(chatRoom.lastMessage) gt 60}">
                                                             ${fn:substring(chatRoom.lastMessage, 0, 60)}...
                                                         </c:when>
                                                         <c:otherwise>
                                                             ${chatRoom.lastMessage}
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </c:when>
                                                 <c:otherwise>
                                                     <em>Chưa có tin nhắn nào</em>
                                                 </c:otherwise>
                                             </c:choose>
                                         </div>
                                        
                                        <div class="chat-time">
                                            <c:if test="${not empty chatRoom.lastMessageAt}">
                                                <fmt:formatDate value="${chatRoom.lastMessageAt}" pattern="HH:mm dd/MM" />
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="chat-meta">
                                        <c:if test="${chatRoom.unreadCount > 0}">
                                            <div class="chat-unread-badge">${chatRoom.unreadCount}</div>
                                        </c:if>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty chatRooms}">
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                            <i class="ri-search-line"></i>Tìm trải nghiệm mới
                        </a>
                        <a href="${pageContext.request.contextPath}/accommodations" class="btn btn-primary">
                            <i class="ri-home-line"></i>Khám phá chỗ ở
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

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
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        Chat với 
        <c:choose>
            <c:when test="${chatRoom.userId == currentUser.userId}">
                ${chatRoom.hostName}
            </c:when>
            <c:otherwise>
                ${chatRoom.userName}
            </c:otherwise>
        </c:choose>
        | VietCulture
    </title>
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
            height: 100vh;
            overflow: hidden;
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

        /* Chat Container */
        .chat-container {
            height: 100vh;
            padding-top: 80px;
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            padding-left: 20px;
            padding-right: 20px;
        }

        .chat-wrapper {
            flex: 1;
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* Chat Header */
        .chat-header {
            background: var(--gradient-primary);
            color: white;
            padding: 24px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }

        .chat-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
            opacity: 0.3;
        }

        .chat-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            flex: 1;
        }

        .back-btn {
            background: rgba(255,255,255,0.15);
            border: none;
            color: white;
            font-size: 1.3rem;
            margin-right: 20px;
            cursor: pointer;
            padding: 12px;
            border-radius: 50%;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .chat-user-info {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .chat-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 16px;
            border: 3px solid rgba(255,255,255,0.3);
            object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .chat-user-details h4 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .chat-user-details .text-muted {
            color: rgba(255,255,255,0.8) !important;
            font-size: 0.9rem;
            font-weight: 500;
        }



        /* Messages Area */
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 30px;
            background: linear-gradient(180deg, #FAFBFC 0%, #F8F9FA 100%);
            display: flex;
            flex-direction: column;
            gap: 20px;
            position: relative;
        }

        .chat-messages::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23f1f5f9' fill-opacity='0.3'%3E%3Cpath d='M20 20c0-5.5-4.5-10-10-10s-10 4.5-10 10 4.5 10 10 10 10-4.5 10-10zm10 0c0-5.5-4.5-10-10-10s-10 4.5-10 10 4.5 10 10 10 10-4.5 10-10z'/%3E%3C/g%3E%3C/svg%3E") repeat;
            opacity: 0.3;
            pointer-events: none;
        }

        .message-wrapper {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            margin-bottom: 20px;
            animation: fadeInUp 0.6s ease-out;
        }

        .message-wrapper.sent {
            flex-direction: row-reverse;
            justify-content: flex-start;
        }

        .message-wrapper.received {
            flex-direction: row;
            justify-content: flex-start;
        }

        .message-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            max-width: 70%;
        }

        .message-wrapper.sent .message-group {
            align-items: flex-end;
        }

        .message-wrapper.received .message-group {
            align-items: flex-start;
        }

        .message-sender-name {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 4px;
            text-transform: capitalize;
        }

        .message-wrapper.sent .message-sender-name {
            color: var(--primary-color);
            text-align: right;
        }

        .message-wrapper.received .message-sender-name {
            color: var(--text-dark);
            text-align: left;
        }

        .message-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            border: 2px solid white;
            box-shadow: var(--shadow-sm);
        }

        .message-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .default-avatar {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gradient-primary);
            color: white;
            font-weight: 600;
            font-size: 16px;
            text-transform: uppercase;
        }

        .message-bubble {
            padding: 12px 16px;
            border-radius: 18px;
            font-size: 15px;
            line-height: 1.5;
            word-wrap: break-word;
            position: relative;
            box-shadow: var(--shadow-md);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            min-width: 50px;
        }

        .message-wrapper.sent .message-bubble {
            background: var(--gradient-primary);
            color: white;
            border-bottom-right-radius: 6px;
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.3);
        }

        .message-wrapper.received .message-bubble {
            background: white;
            color: var(--text-dark);
            border-bottom-left-radius: 6px;
            border: 1px solid var(--border-color);
        }

        .message-content {
            white-space: pre-wrap;
        }

        .message-time {
            font-size: 11px;
            color: var(--text-light);
            margin-top: 4px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .message-wrapper.sent .message-time {
            color: var(--text-light);
            justify-content: flex-end;
        }

        .message-wrapper.received .message-time {
            color: var(--text-light);
            justify-content: flex-start;
        }

        /* Typing Indicator */
        .typing-indicator {
            display: none;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            background: white;
            border-radius: 20px;
            border-bottom-left-radius: 6px;
            max-width: 120px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-md);
            animation: fadeInUp 0.4s ease-out;
        }

        .typing-dots {
            display: flex;
            gap: 4px;
            align-items: center;
        }

        .typing-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary-color);
            animation: typingDots 1.5s infinite;
        }

        .typing-dot:nth-child(2) { animation-delay: 0.3s; }
        .typing-dot:nth-child(3) { animation-delay: 0.6s; }

        @keyframes typingDots {
            0%, 60% , 100% { opacity: 0.3; transform: scale(0.8); }
            30% { opacity: 1; transform: scale(1); }
        }

        /* Chat Input */
        .chat-input-area {
            padding: 25px 30px;
            background: white;
            border-top: 1px solid var(--border-color);
            flex-shrink: 0;
        }

        .input-group-chat {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            background: var(--accent-color);
            border-radius: var(--border-radius);
            padding: 8px 8px 8px 16px;
            border: 2px solid transparent;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

        .input-group-chat:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(255, 56, 92, 0.1);
        }

        .attachment-btn {
            background: none;
            border: none;
            color: var(--text-light);
            font-size: 1.2rem;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            transition: var(--transition);
        }

        .attachment-btn:hover {
            color: var(--primary-color);
            background: rgba(255, 56, 92, 0.1);
        }

        .message-input {
            flex: 1;
            border: none;
            background: transparent;
            color: var(--text-dark);
            font-size: 15px;
            line-height: 1.5;
            padding: 12px 0;
            resize: none;
            outline: none;
            max-height: 120px;
            min-height: 20px;
            font-family: 'Inter', sans-serif;
        }

        .message-input::placeholder {
            color: var(--text-light);
        }

        .send-btn {
            background: var(--gradient-primary);
            border: none;
            color: white;
            border-radius: 50%;
            width: 45px;
            height: 45px;
            cursor: pointer;
            font-size: 18px;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }

        .send-btn:hover:not(:disabled) {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        .send-btn:active {
            transform: translateY(0) scale(0.95);
        }

        .send-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
            box-shadow: var(--shadow-sm);
        }

        /* Scrollbar Styling */
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: transparent;
        }

        .chat-messages::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 10px;
            opacity: 0.5;
        }

        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: var(--dark-color);
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
        }
            to {
                opacity: 1;
                transform: translateY(0);
        }
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
        }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .chat-container {
                padding-left: 10px;
                padding-right: 10px;
        }

            .chat-wrapper {
                border-radius: 0;
                margin-bottom: 0;
                height: calc(100vh - 80px);
        }

            .chat-header {
                padding: 20px;
        }

            .chat-messages {
                padding: 20px 15px;
        }

            .chat-input-area {
                padding: 20px 15px;
        }

            .message-wrapper {
                gap: 8px;
                margin-bottom: 15px;
            }

            .message-avatar {
                width: 32px;
                height: 32px;
            }

            .default-avatar {
                font-size: 14px;
        }

            .message-group {
                max-width: 80%;
            }

            .message-bubble {
                padding: 10px 14px;
                font-size: 14px;
        }

            .message-time {
                font-size: 10px;
        }

            .message-sender-name {
                font-size: 11px;
                margin-bottom: 3px;
        }

            .chat-avatar {
                width: 40px;
                height: 40px;
        }

            .chat-user-details h4 {
                font-size: 1.1rem;
        }
        }

        @media (max-width: 480px) {
            .message-group {
                max-width: 85%;
            }
            
            .message-avatar {
                width: 28px;
                height: 28px;
            }

            .default-avatar {
                font-size: 12px;
            }
            
            .message-bubble {
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .message-sender-name {
                font-size: 10px;
                margin-bottom: 2px;
            }
        }

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
                    <a href="${pageContext.request.contextPath}/chat" class="nav-link">
                        <i class="ri-arrow-left-line me-2"></i>Danh sách chat
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="nav-link">
                        <i class="ri-home-line me-2"></i>Trang chủ
                </a>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Main Chat Container -->
    <div class="chat-container">
        <div class="chat-wrapper">
        <!-- Chat Header -->
        <div class="chat-header">
                <div class="chat-header-content">
                    <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/chat'">
                    <i class="ri-arrow-left-line"></i>
                </button>
                
                    <div class="chat-user-info">
                        <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                             alt="User Avatar" class="chat-avatar">
                        
                        <div class="chat-user-details">
                            <h4>
                <c:choose>
                    <c:when test="${chatRoom.userId == currentUser.userId}">
                                        ${chatRoom.hostName}
                    </c:when>
                    <c:otherwise>
                                        ${chatRoom.userName}
                    </c:otherwise>
                </c:choose>
                            </h4>
                            <div class="text-muted">
                                <c:if test="${not empty chatRoom.experienceTitle}">
                                    <i class="ri-map-pin-line me-1"></i>Trải nghiệm: ${chatRoom.experienceTitle}
                                </c:if>
                                <c:if test="${not empty chatRoom.accommodationName}">
                                    <i class="ri-home-line me-1"></i>Chỗ ở: ${chatRoom.accommodationName}
                                </c:if>
                                <c:if test="${empty chatRoom.experienceTitle and empty chatRoom.accommodationName}">
                                    <i class="ri-message-line me-1"></i>Trò chuyện chung
                                </c:if>
            </div>
            </div>
        </div>
            </div>
        </div>

            <!-- Messages Area -->
        <div class="chat-messages" id="chatMessages">
                <c:forEach var="message" items="${messages}">
                    <div class="message-wrapper ${message.senderId == currentUser.userId ? 'sent' : 'received'}">
                        <c:if test="${message.senderId != currentUser.userId}">
                            <div class="message-avatar">
            <c:choose>
                                    <c:when test="${message.senderId == chatRoom.hostId}">
                                        <c:choose>
                                            <c:when test="${not empty chatRoom.hostAvatar}">
                                                <img src="${pageContext.request.contextPath}/view/assets/images/avatars/${chatRoom.hostAvatar}" alt="Host Avatar">
    </c:when>
    <c:otherwise>
                                                <div class="default-avatar">${fn:substring(chatRoom.hostName, 0, 1)}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                        <c:choose>
                                            <c:when test="${not empty chatRoom.userAvatar}">
                                                <img src="${pageContext.request.contextPath}/view/assets/images/avatars/${chatRoom.userAvatar}" alt="User Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="default-avatar">${fn:substring(chatRoom.userName, 0, 1)}</div>
                                            </c:otherwise>
                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                </div>
            </c:if>

                        <div class="message-group">
                            <c:if test="${message.senderId == currentUser.userId}">
                                <div class="message-sender-name">
                                    ${currentUser.fullName}
                                </div>
                </c:if>
                            <c:if test="${message.senderId != currentUser.userId}">
                                <div class="message-sender-name">
                        <c:choose>
                                        <c:when test="${message.senderId == chatRoom.hostId}">
                                            ${chatRoom.hostName}
                            </c:when>
                            <c:otherwise>
                                            ${chatRoom.userName}
                            </c:otherwise>
                        </c:choose>
                    </div>
                            </c:if>
                            <div class="message-bubble">
                                <div class="message-content">${message.messageContent}</div>
                            </div>
                    <div class="message-time">
                        <fmt:formatDate value="${message.sentAt}" pattern="HH:mm" />
                                <c:if test="${message.senderId == currentUser.userId}">
                                    <i class="ri-check-double-line ms-1 ${message.read ? 'text-primary' : 'text-muted'}"></i>
                                </c:if>
                            </div>
                    </div>
                    
                        <c:if test="${message.senderId == currentUser.userId}">
                            <div class="message-avatar">
                                <c:choose>
                                    <c:when test="${not empty currentUser.avatar}">
                                        <img src="${pageContext.request.contextPath}/view/assets/images/avatars/${currentUser.avatar}" alt="Your Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="default-avatar">${fn:substring(currentUser.fullName, 0, 1)}</div>
                                    </c:otherwise>
                                </c:choose>
                        </div>
                    </c:if>
                </div>
                </c:forEach>
                
                <!-- Typing Indicator -->
                <div class="typing-indicator" id="typingIndicator">
                    <div class="typing-dots">
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
            </div>
                    <span class="ms-2 text-muted">đang nhập...</span>
                </div>
        </div>

        <!-- Chat Input --> 
        <div class="chat-input-area">
            <div class="input-group-chat">
                <button class="attachment-btn" onclick="showAttachmentOptions()">
                    <i class="ri-attachment-line"></i>
                </button>
                
                <textarea class="message-input" 
                          id="messageInput" 
                          placeholder="Nhập tin nhắn..."
                          rows="1"
                          onkeydown="handleKeyDown(event)"
                          oninput="handleTyping()"></textarea>
                
                <button class="send-btn" id="sendBtn" onclick="sendMessage()" disabled>
                    <i class="ri-send-plane-line"></i>
                </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // FIX: Properly extract values from JSP with null checking
    const chatRoomId = <c:out value="${chatRoom.chatRoomId}" default="0"/>;
    const currentUserId = <c:out value="${currentUser.userId}" default="0"/>;
    const receiverId = <c:choose>
        <c:when test="${chatRoom.userId == currentUser.userId}">
            <c:out value="${chatRoom.hostId}" default="0"/>
        </c:when>
        <c:otherwise>
            <c:out value="${chatRoom.userId}" default="0"/>
        </c:otherwise>
    </c:choose>;
    
    // Context path for URLs
    const contextPath = '<c:out value="${pageContext.request.contextPath}"/>';
    
    let isTyping = false;
    let typingTimeout = null;
    let ws;

    function connectWebSocket() {
        if (!chatRoomId || !currentUserId) return;
        const wsProtocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        const wsUrl = wsProtocol + window.location.host + contextPath + '/ws/chat/' + chatRoomId;
        ws = new WebSocket(wsUrl);

        ws.onopen = function() {
            console.log('WebSocket connected:', wsUrl);
        };
        ws.onclose = function() {
            console.log('WebSocket disconnected');
        };
        ws.onerror = function(e) {
            console.error('WebSocket error:', e);
        };
        ws.onmessage = function(event) {
            try {
                const data = JSON.parse(event.data);
                console.log('WebSocket message received:', data);
                
                if (data.type === 'message') {
                    // Chỉ hiển thị tin nhắn từ người khác
                    if (data.senderId != currentUserId) {
                        addMessageToUI(data.content, false, data.senderAvatar, data.read, data.senderAvatar);
                    }
                } else if (data.type === 'typing') {
                    // Xử lý typing indicator
                    handleTypingIndicator(data);
                } else if (data.type === 'read') {
                    // Xử lý read receipt
                    handleReadReceipt(data);
                } else if (data.type === 'connection') {
                    console.log('WebSocket connection confirmed:', data);
                }
            } catch (e) {
                console.error('Error parsing WebSocket message:', e);
            }
        };
    }

    // Initialize chat
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Chat initialization:');
        console.log('- chatRoomId:', chatRoomId);
        console.log('- currentUserId:', currentUserId);
        console.log('- receiverId:', receiverId);
        
        // Validate required data
        if (!chatRoomId || !currentUserId || !receiverId) {
            console.error('Missing required chat data');
            showNotification('Lỗi dữ liệu chat. Vui lòng refresh trang.', 'error');
            return;
        }
        
        initializeChat();
        scrollToBottom();
        markMessagesAsRead();
        connectWebSocket();
        
        // Auto-resize textarea
        const messageInput = document.getElementById('messageInput');
        if (messageInput) {
            messageInput.addEventListener('input', autoResizeTextarea);
            messageInput.addEventListener('input', handleTyping);
        }
    });

    function initializeChat() {
        const messageInput = document.getElementById('messageInput');
        const sendBtn = document.getElementById('sendBtn');
        
        if (!messageInput || !sendBtn) {
            console.error('Required elements not found');
            return;
        }
        
        messageInput.addEventListener('input', function() {
            sendBtn.disabled = this.value.trim() === '';
        });
        
        messageInput.focus();
    }

    function scrollToBottom() {
        const chatMessages = document.getElementById('chatMessages');
        if (chatMessages) {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    }

    function autoResizeTextarea() {
        const textarea = document.getElementById('messageInput');
        if (textarea) {
            textarea.style.height = 'auto';
            textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
        }
    }

    function handleKeyDown(event) {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    }

    function handleTyping() {
        if (!isTyping) {
            isTyping = true;
            // Send typing status via WebSocket
            if (ws && ws.readyState === WebSocket.OPEN) {
                const typingData = {
                    type: 'typing',
                    senderId: currentUserId,
                    senderName: '${currentUser.fullName}',
                    isTyping: true
                };
                ws.send(JSON.stringify(typingData));
            }
        }
        
        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            isTyping = false;
            // Send stop typing status
            if (ws && ws.readyState === WebSocket.OPEN) {
                const typingData = {
                    type: 'typing',
                    senderId: currentUserId,
                    senderName: '${currentUser.fullName}',
                    isTyping: false
                };
                ws.send(JSON.stringify(typingData));
            }
        }, 1000);
    }

    function handleTypingIndicator(data) {
        // Hiển thị typing indicator cho người khác
        if (data.senderId != currentUserId) {
            const typingEl = document.getElementById('typingIndicator');
            if (typingEl) {
                if (data.isTyping) {
                    typingEl.textContent = data.senderName + ' đang nhập tin nhắn...';
                    typingEl.style.display = 'block';
                } else {
                    typingEl.style.display = 'none';
                }
            }
        }
    }

    function handleReadReceipt(data) {
        // Cập nhật trạng thái đã đọc
        console.log('Read receipt received:', data);
        // Có thể thêm logic hiển thị "đã đọc" cho tin nhắn
    }

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const messageContent = messageInput.value.trim();
    
    if (messageContent === '') {
        console.log('Empty message, not sending');
        return;
    }
    
    // Validate required data
    if (!chatRoomId || !receiverId || !currentUserId) {
        console.error('Missing chat data:', {chatRoomId: chatRoomId, receiverId: receiverId, currentUserId: currentUserId});
        showNotification('Lỗi dữ liệu chat. Vui lòng refresh trang.', 'error');
        return;
    }
    
    const sendBtn = document.getElementById('sendBtn');
    sendBtn.disabled = true;
    
    // Add message to UI immediately (optimistic UI)
    addMessageToUI(messageContent, true);
    
    // Gửi qua WebSocket nếu kết nối
    if (ws && ws.readyState === WebSocket.OPEN) {
        const messageData = {
            type: 'message',
            content: messageContent,
            senderId: currentUserId,
            senderName: '${currentUser.fullName}',
            receiverId: receiverId,
            roomId: chatRoomId
        };
        ws.send(JSON.stringify(messageData));
        updateLastMessageStatus('sent');
    } else {
        // Fallback: gửi qua fetch như cũ
        const params = new URLSearchParams();
        params.append('roomId', chatRoomId.toString());
        params.append('receiverId', receiverId.toString());
        params.append('messageContent', messageContent);
        params.append('messageType', 'TEXT');
        
        // Debug parameters
        console.log('Sending URL-encoded parameters:');
        for (var pair of params.entries()) {
            console.log('  ' + pair[0] + ': ' + pair[1]);
        }
        
        const url = contextPath + '/chat/api/send-message';
        console.log('Send message URL:', url);
        console.log('Request body:', params.toString());
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            }
        })
        .then(function(response) {
            console.log('Send message response status:', response.status);
            console.log('Response Content-Type:', response.headers.get('content-type'));
            
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                return response.text().then(function(text) {
                    console.error('Expected JSON but got:', text.substring(0, 200));
                    throw new Error('Server returned non-JSON response');
                });
            }
            
            return response.json();
        })
        .then(function(data) {
            console.log('Send message result:', data);
            if (!data.success) {
                removeLastOptimisticMessage();
                showNotification(data.message || 'Có lỗi xảy ra khi gửi tin nhắn', 'error');
            } else {
                updateLastMessageStatus('sent');
                // Optionally refresh messages or use WebSocket for real-time updates
            }
        })
        .catch(function(error) {
            console.error('Error sending message:', error);
            removeLastOptimisticMessage();
            showNotification('Không thể gửi tin nhắn. Vui lòng thử lại.', 'error');
        })
        .finally(function() {
            sendBtn.disabled = false;
        });
    }
    
    // Clear input
    messageInput.value = '';
    messageInput.style.height = 'auto';
    messageInput.focus();
}
function addMessageToUI(content, isSent, avatarUrl, isLastRead, receiverAvatar) {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;
    
    const now = new Date();
    const timeStr = now.getHours().toString().padStart(2, '0') + ':' +
                   now.getMinutes().toString().padStart(2, '0');
    
    const messageWrapper = document.createElement('div');
    messageWrapper.className = 'message-wrapper ' + (isSent ? 'sent' : 'received');
    
    let html = '';
    
    // Avatar for received messages (left side)
    if (!isSent && avatarUrl) {
        html += '<div class="message-avatar">' +
                '<img src="' + avatarUrl + '" alt="Avatar">' +
                '</div>';
    }
    
    // Message group
    html += '<div class="message-group">';
    
    // Add sender name
    if (isSent) {
        const currentUserName = '${currentUser.fullName}';
        html += '<div class="message-sender-name">' + currentUserName + '</div>';
    } else {
        // For received messages, we'll get sender name from context or use default
        html += '<div class="message-sender-name">Người khác</div>';
    }
    
    html += '<div class="message-bubble">' +
            '<div class="message-content">' + escapeHtml(content) + '</div>' +
            '</div>' +
            '<div class="message-time">' + timeStr;
    
    // Read status for sent messages
    if (isSent) {
        html += '<i class="ri-check-double-line ms-1 text-muted"></i>';
    }
    
    html += '</div>' +
            '</div>';
    
    // Avatar for sent messages (right side)
    if (isSent) {
        const currentUserAvatar = '${not empty currentUser.avatar ? pageContext.request.contextPath.concat("/view/assets/images/avatars/").concat(currentUser.avatar) : ""}';
        const currentUserName = '${currentUser.fullName}';
        
        html += '<div class="message-avatar">';
        if (currentUserAvatar) {
            html += '<img src="' + currentUserAvatar + '" alt="Your Avatar">';
        } else {
            html += '<div class="default-avatar">' + currentUserName.charAt(0).toUpperCase() + '</div>';
        }
        html += '</div>';
    }
    
    messageWrapper.innerHTML = html;
    chatMessages.appendChild(messageWrapper);
    scrollToBottom();
}

    function removeLastOptimisticMessage() {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) return;
        
        const lastMessage = chatMessages.lastElementChild;
        if (lastMessage && lastMessage.classList.contains('sent')) {
            chatMessages.removeChild(lastMessage);
        }
    }

    function updateLastMessageStatus(status) {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) return;
        
        const lastMessage = chatMessages.lastElementChild;
        if (lastMessage && lastMessage.classList.contains('sent')) {
            const statusElement = lastMessage.querySelector('.message-status span');
            if (statusElement) {
                statusElement.textContent = status === 'sent' ? 'Đã gửi' : 'Đang gửi...';
            }
            const statusIcon = lastMessage.querySelector('.message-status i');
            if (statusIcon) {
                statusIcon.className = status === 'sent' ? 'ri-check-line' : 'ri-time-line';
            }
        }
    }

    function markMessagesAsRead() {
        // Validate chatRoomId
        if (!chatRoomId || isNaN(chatRoomId)) {
            console.error('Invalid chatRoomId for markMessagesAsRead:', chatRoomId);
            return;
        }
        
        // Gửi read receipt qua WebSocket nếu kết nối
        if (ws && ws.readyState === WebSocket.OPEN) {
            const readData = {
                type: 'read',
                userId: currentUserId,
                roomId: chatRoomId
            };
            ws.send(JSON.stringify(readData));
        }
        
        const url = contextPath + '/chat/api/mark-read/' + chatRoomId;
        
        console.log('Marking messages as read for room:', chatRoomId);
        console.log('Request URL:', url);
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            }
        })
        .then(response => {
            console.log('Mark read response status:', response.status);
            
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                return response.text().then(text => {
                    console.error('Expected JSON but got:', text.substring(0, 200));
                    throw new Error('Server returned non-JSON response');
                });
            }
            
            return response.json();
        })
        .then(data => {
            console.log('Mark as read result:', data);
            if (data.success) {
                console.log('Messages marked as read successfully');
            } else {
                console.warn('Failed to mark messages as read:', data.message);
            }
        })
        .catch(error => {
            console.error('Error marking messages as read:', error);
        });
    }

    function goBack() {
        window.history.back();
    }

    function showAttachmentOptions() {
        showNotification('Tính năng đính kèm file sẽ được phát triển trong phiên bản tiếp theo', 'info');
    }

    function showNotification(message, type) {
        type = type || 'info';
        let backgroundColor, textColor, borderColor;
        
        switch(type) {
            case 'error':
                backgroundColor = '#fee2e2';
                textColor = '#dc2626';
                borderColor = '#dc2626';
                break;
            case 'success':
                backgroundColor = '#d1fae5';
                textColor = '#047857';
                borderColor = '#047857';
                break;
            default: // 'info'
                backgroundColor = '#fef3c7';
                textColor = '#92400e';
                borderColor = '#92400e';
        }
        
        const notification = document.createElement('div');
        notification.className = 'toast';
        notification.classList.add(type);
        notification.textContent = message;
        
        document.getElementById('toastContainer').appendChild(notification);
        
        // Show notification
        setTimeout(function() {
            notification.style.opacity = '1';
            notification.style.transform = 'translateX(0)';
        }, 10);
        
        // Hide notification after 4 seconds
        setTimeout(function() {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%)';
            setTimeout(function() {
                if (document.getElementById('toastContainer').contains(notification)) {
                    document.getElementById('toastContainer').removeChild(notification);
                }
            }, 300);
        }, 4000);
    }

    // Helper function to escape HTML
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // Mark as read when page becomes visible
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            markMessagesAsRead();
        }
    });


</script>
</body>
</html>
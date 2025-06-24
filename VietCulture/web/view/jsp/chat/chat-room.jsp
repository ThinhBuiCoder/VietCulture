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
            --border-color: #E5E7EB;
            --hover-color: #F9FAFB;
            --message-sent: #FF385C;
            --message-received: #F3F4F6;
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
            margin: 0;
            height: 100vh;
            overflow: hidden;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
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

        .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: var(--transition);
        }

        .nav-link:hover {
            color: var(--primary-color);
        }

        /* Chat Container */
        .chat-container {
            height: calc(100vh - 80px);
            display: flex;
            flex-direction: column;
            background: white;
            max-width: 1200px;
            margin: 0 auto;
            box-shadow: var(--shadow-lg);
            border-radius: var(--border-radius) var(--border-radius) 0 0;
            overflow: hidden;
        }

        /* Chat Header */
        .chat-header {
            background: var(--gradient-primary);
            color: white;
            padding: 20px 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
            box-shadow: var(--shadow-md);
        }

        .chat-header-left {
            display: flex;
            align-items: center;
        }

        .back-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            font-size: 1.2rem;
            margin-right: 20px;
            cursor: pointer;
            padding: 10px;
            border-radius: 50%;
            transition: var(--transition);
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateX(-2px);
        }

        .chat-partner-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
            border: 3px solid rgba(255,255,255,0.3);
            transition: var(--transition);
        }

        .chat-partner-avatar:hover {
            transform: scale(1.05);
            border-color: white;
        }

        .chat-partner-info h4 {
            margin: 0;
            font-weight: 700;
            color: white;
        }

        .chat-partner-status {
            font-size: 0.9rem;
            color: rgba(255,255,255,0.8);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .online-indicator {
            width: 8px;
            height: 8px;
            background: #10B981;
            border-radius: 50%;
            border: 2px solid white;
        }

        .chat-subject {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Chat Messages */
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 25px;
            background: linear-gradient(to bottom, #FAFBFC, #F8F9FA);
        }

        .message-date {
            text-align: center;
            margin: 25px 0 20px;
        }

        .date-badge {
            background: white;
            color: #6B7280;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .message {
            display: flex;
            margin-bottom: 15px;
            align-items: flex-end;
            animation: messageSlideIn 0.3s ease-out;
        }

        @keyframes messageSlideIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message.sent {
            justify-content: flex-end;
        }

        .message.received {
            justify-content: flex-start;
        }

        .message-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 10px;
            border: 2px solid var(--border-color);
        }

        .message-content {
            max-width: 70%;
            position: relative;
        }

        .message-bubble {
            padding: 15px 20px;
            border-radius: 20px;
            word-wrap: break-word;
            position: relative;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }

        .message-bubble:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .message.sent .message-bubble {
            background: var(--gradient-primary);
            color: white;
            border-bottom-right-radius: 8px;
        }

        .message.received .message-bubble {
            background: white;
            color: var(--dark-color);
            border: 1px solid var(--border-color);
            border-bottom-left-radius: 8px;
        }

        .message-time {
            font-size: 0.75rem;
            opacity: 0.7;
            margin-top: 6px;
            font-weight: 500;
        }

        .message.sent .message-time {
            text-align: right;
            color: #6B7280;
        }

        .message.received .message-time {
            text-align: left;
            color: #6B7280;
        }

        .message-status {
            font-size: 0.7rem;
            color: #9CA3AF;
            margin-top: 4px;
            text-align: right;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 4px;
        }

        .message.sent .message-status i {
            color: #4ADE80;
        }

        /* Chat Input Area */
        .chat-input-area {
            background: white;
            border-top: 1px solid var(--border-color);
            padding: 20px 25px;
            flex-shrink: 0;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.05);
        }

        .input-group-chat {
            display: flex;
            align-items: flex-end;
            gap: 12px;
        }

        .message-input {
            flex: 1;
            border: 2px solid var(--border-color);
            border-radius: 25px;
            padding: 15px 20px;
            resize: none;
            max-height: 120px;
            min-height: 50px;
            font-size: 0.95rem;
            outline: none;
            transition: var(--transition);
            background: var(--accent-color);
        }

        .message-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(255, 56, 92, 0.1);
            background: white;
        }

        .send-btn {
            background: var(--gradient-primary);
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .send-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 56, 92, 0.4);
        }

        .send-btn:disabled {
            background: #D1D5DB;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .attachment-btn {
            background: var(--accent-color);
            border: 2px solid var(--border-color);
            color: #6B7280;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 12px;
            border-radius: 50%;
            transition: var(--transition);
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .attachment-btn:hover {
            background: white;
            color: var(--primary-color);
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        /* Typing Indicator */
        .typing-indicator {
            display: none;
            padding: 15px 25px;
            color: #6B7280;
            font-style: italic;
            font-size: 0.9rem;
            background: rgba(255,255,255,0.7);
            border-top: 1px solid var(--border-color);
        }

        .typing-dots {
            display: inline-block;
            margin-left: 8px;
        }

        .typing-dots span {
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: var(--primary-color);
            margin: 0 2px;
            animation: typing 1.4s infinite;
        }

        .typing-dots span:nth-child(2) {
            animation-delay: 0.2s;
        }

        .typing-dots span:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes typing {
            0%, 60% , 100% {
                transform: translateY(0);
            }
            30% {
                transform: translateY(-10px);
            }
        }

        /* Connection Status */
        .connection-status {
            background: #FEF3C7;
            color: #92400E;
            padding: 10px 25px;
            text-align: center;
            font-size: 0.9rem;
            font-weight: 500;
            display: none;
        }

        .connection-status.connected {
            background: #D1FAE5;
            color: #047857;
        }

        .connection-status.disconnected {
            background: #FEE2E2;
            color: #DC2626;
        }

        /* Scroll styling */
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: #F1F5F9;
            border-radius: 4px;
        }

        .chat-messages::-webkit-scrollbar-thumb {
            background: #CBD5E1;
            border-radius: 4px;
        }

        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #94A3B8;
        }

        /* Loading Animation */
        .loading-messages {
            text-align: center;
            padding: 60px;
            color: #6B7280;
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
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Media attachments */
        .file-attachment {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px;
            background: rgba(255,255,255,0.1);
            border-radius: 8px;
            margin-top: 5px;
        }

        .message.received .file-attachment {
            background: var(--accent-color);
        }

        .file-attachment i {
            font-size: 1.2rem;
        }

        .file-attachment a {
            color: inherit;
            text-decoration: none;
            font-weight: 500;
        }

        .file-attachment a:hover {
            text-decoration: underline;
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            body {
                padding-top: 60px;
            }
            
            .chat-container {
                height: calc(100vh - 60px);
                border-radius: 0;
            }
            
            .chat-header {
                padding: 15px 20px;
            }
            
            .chat-partner-avatar {
                width: 45px;
                height: 45px;
            }
            
            .chat-messages {
                padding: 20px 15px;
            }
            
            .message-content {
                max-width: 85%;
            }
            
            .chat-input-area {
                padding: 15px 20px;
            }
            
            .input-group-chat {
                gap: 10px;
            }
            
            .send-btn, .attachment-btn {
                width: 45px;
                height: 45px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark custom-navbar">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/chat">
                    <i class="ri-arrow-left-line me-1"></i>Quay lại danh sách
                </a>
            </div>
        </div>
    </nav>
    
    <div class="chat-container">
        <!-- Connection Status -->
        <div class="connection-status" id="connectionStatus">
            Đang kết nối...
        </div>

        <!-- Chat Header -->
        <div class="chat-header">
            <div class="chat-header-left">
                <button class="back-btn" onclick="goBack()">
                    <i class="ri-arrow-left-line"></i>
                </button>
                
                <c:choose>
                    <c:when test="${chatRoom.userId == currentUser.userId}">
                        <!-- User đang chat với Host -->
                        <img src="${not empty chatRoom.hostAvatar ? chatRoom.hostAvatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                             alt="${chatRoom.hostName}" class="chat-partner-avatar">
                        <div class="chat-partner-info">
                            <h4>${chatRoom.hostName}</h4>
                            <p class="chat-partner-status">
                                <span class="online-indicator"></span>
                                Host • Online
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Host đang chat với User -->
                        <img src="${not empty chatRoom.userAvatar ? chatRoom.userAvatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                             alt="${chatRoom.userName}" class="chat-partner-avatar">
                        <div class="chat-partner-info">
                            <h4>${chatRoom.userName}</h4>
                            <p class="chat-partner-status">
                                <span class="online-indicator"></span>
                                Khách hàng • Online
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="chat-header-right">
                <c:choose>
                    <c:when test="${not empty chatRoom.experienceTitle}">
                        <span class="chat-subject">
                            <i class="ri-map-pin-line"></i>${chatRoom.experienceTitle}
                        </span>
                    </c:when>
                    <c:when test="${not empty chatRoom.accommodationName}">
                        <span class="chat-subject">
                            <i class="ri-home-line"></i>${chatRoom.accommodationName}
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="chat-subject">
                            <i class="ri-chat-3-line"></i>Chat trực tiếp
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Typing Indicator -->
        <div class="typing-indicator" id="typingIndicator">
            <span id="typingUser"></span> đang nhập tin nhắn
            <div class="typing-dots">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>

        <!-- Chat Messages -->
        <div class="chat-messages" id="chatMessages">
            <c:choose>
    <c:when test="${empty messages}">
        <div class="loading-messages">
            <div class="spinner"></div>
            <h5>Chưa có tin nhắn nào</h5>
            <p>Hãy bắt đầu cuộc trò chuyện để kết nối và chia sẻ!</p>
        </div>
    </c:when>
    <c:otherwise>
        <c:set var="currentDate" value="" />
        <!-- Hiển thị tin nhắn theo thứ tự từ cũ đến mới -->
        <c:forEach var="message" items="${messages}" varStatus="status">
            <c:set var="messageDate">
                <fmt:formatDate value="${message.sentAt}" pattern="dd/MM/yyyy" />
            </c:set>
            
            <!-- Hiển thị ngày nếu khác ngày trước -->
            <c:if test="${messageDate != currentDate}">
                <div class="message-date">
                    <span class="date-badge">
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate var="today" value="${now}" pattern="dd/MM/yyyy" />
                        <c:choose>
                            <c:when test="${messageDate == today}">Hôm nay</c:when>
                            <c:otherwise>${messageDate}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <c:set var="currentDate" value="${messageDate}" />
            </c:if>

            <!-- Tin nhắn -->
            <div class="message ${message.senderId == currentUser.userId ? 'sent' : 'received'}">
                <c:if test="${message.senderId != currentUser.userId}">
                    <img src="${not empty message.senderAvatar ? message.senderAvatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                         alt="${message.senderName}" class="message-avatar">
                </c:if>
                
                <div class="message-content">
                    <div class="message-bubble">
                        <c:choose>
                            <c:when test="${message.messageType == 'IMAGE'}">
                                <img src="${message.attachmentUrl}" alt="Hình ảnh" style="max-width: 250px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                <c:if test="${not empty message.messageContent}">
                                    <p style="margin-top: 10px; margin-bottom: 0;">${message.messageContent}</p>
                                </c:if>
                            </c:when>
                            <c:when test="${message.messageType == 'FILE'}">
                                <div class="file-attachment">
                                    <i class="ri-file-line"></i>
                                    <a href="${message.attachmentUrl}" target="_blank">
                                        ${not empty message.messageContent ? message.messageContent : 'File đính kèm'}
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                ${message.messageContent}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="message-time">
                        <fmt:formatDate value="${message.sentAt}" pattern="HH:mm" />
                    </div>
                    
                    <c:if test="${message.senderId == currentUser.userId}">
                        <div class="message-status">
                            <c:choose>
                                <c:when test="${message.read}">
                                    <i class="ri-check-double-line"></i>
                                    <span>Đã xem</span>
                                </c:when>
                                <c:otherwise>
                                    <i class="ri-check-line"></i>
                                    <span>Đã gửi</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
                
                <c:if test="${message.senderId == currentUser.userId}">
                    <img src="${not empty currentUser.avatar ? currentUser.avatar : 'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'}" 
                         alt="${currentUser.fullName}" class="message-avatar">
                </c:if>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        
        // Auto-resize textarea
        const messageInput = document.getElementById('messageInput');
        if (messageInput) {
            messageInput.addEventListener('input', autoResizeTextarea);
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
            // Send typing status (có thể implement WebSocket sau)
        }
        
        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            isTyping = false;
            // Send stop typing status
        }, 1000);
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
    
    // FIXED: Use URL-encoded form data instead of FormData
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
        body: params,
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
    
    // Clear input
    messageInput.value = '';
    messageInput.style.height = 'auto';
    messageInput.focus();
}
function addMessageToUI(content, isSent) {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) return;
        
        const now = new Date();
        const timeStr = now.getHours().toString().padStart(2, '0') + ':' + 
                       now.getMinutes().toString().padStart(2, '0');
        
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message ' + (isSent ? 'sent' : 'received');
        
        messageDiv.innerHTML = 
            '<div class="message-content">' +
                '<div class="message-bubble">' + escapeHtml(content) + '</div>' +
                '<div class="message-time">' + timeStr + '</div>' +
                (isSent ? '<div class="message-status"><i class="ri-time-line"></i><span>Đang gửi...</span></div>' : '') +
            '</div>';
        
        chatMessages.appendChild(messageDiv);
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
        notification.className = 'notification';
        notification.style.cssText = 
            'position: fixed;' +
            'top: 100px;' +
            'right: 20px;' +
            'background: ' + backgroundColor + ';' +
            'color: ' + textColor + ';' +
            'padding: 12px 20px;' +
            'border-radius: 8px;' +
            'box-shadow: 0 4px 12px rgba(0,0,0,0.1);' +
            'z-index: 9999;' +
            'font-weight: 500;' +
            'border-left: 4px solid ' + borderColor + ';' +
            'opacity: 0;' +
            'transform: translateX(100%);' +
            'transition: all 0.3s ease;' +
            'max-width: 300px;' +
            'word-wrap: break-word;';
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
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
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
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

    // Show connection status
    function updateConnectionStatus(status) {
        const statusEl = document.getElementById('connectionStatus');
        if (!statusEl) return;
        
        statusEl.className = 'connection-status ' + status;
        
        switch(status) {
            case 'connected':
                statusEl.textContent = 'Đã kết nối';
                statusEl.style.display = 'block';
                setTimeout(function() { statusEl.style.display = 'none'; }, 2000);
                break;
            case 'disconnected':
                statusEl.textContent = 'Mất kết nối';
                statusEl.style.display = 'block';
                break;
            default:
                statusEl.style.display = 'none';
        }
    }

    // Simulate connection status
    setTimeout(function() { updateConnectionStatus('connected'); }, 1000);
</script>
</body>
</html>
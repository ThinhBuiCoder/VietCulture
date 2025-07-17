<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo của bạn</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .page-title {
            font-size: 2.8em;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
            letter-spacing: -0.02em;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 1.1em;
            font-weight: 400;
        }

        .notification-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 2.2em;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .stat-label {
            color: #64748b;
            font-size: 0.95em;
            font-weight: 500;
        }

        .notifications-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .noti-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .notification-item {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 28px;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            position: relative;
            overflow: hidden;
        }

        .notification-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .notification-item:hover::before {
            transform: scaleX(1);
        }

        .notification-item.unread {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-color: #7dd3fc;
            box-shadow: 0 4px 20px rgba(56, 189, 248, 0.1);
        }

        .notification-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .notification-header {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 16px;
        }

        .noti-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4em;
            color: white;
            flex-shrink: 0;
            position: relative;
        }

        .noti-icon::after {
            content: '';
            position: absolute;
            inset: -2px;
            border-radius: 18px;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .notification-item:hover .noti-icon::after {
            opacity: 1;
        }

        .icon-approval {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .icon-hidden {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }

        .icon-reported {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .icon-default {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
        }

        .noti-content {
            flex: 1;
        }

        .noti-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .noti-message {
            color: #475569;
            font-size: 1em;
            line-height: 1.6;
            margin-bottom: 16px;
        }

        .noti-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .noti-time {
            color: #94a3b8;
            font-size: 0.9em;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .noti-status {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-unread {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .status-read {
            background: #f1f5f9;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #64748b;
        }

        .empty-icon {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.6;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .empty-title {
            font-size: 1.3em;
            font-weight: 600;
            margin-bottom: 8px;
            color: #1e293b;
        }

        .empty-message {
            font-size: 1em;
            color: #64748b;
        }

        .notification-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 10px 18px;
            border: none;
            border-radius: 10px;
            font-size: 0.9em;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .btn-secondary {
            background: #f8fafc;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(59, 130, 246, 0.4);
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #1e293b;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 24px;
                border-radius: 16px;
            }

            .page-title {
                font-size: 2.2em;
            }

            .notification-stats {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .notification-item {
                padding: 20px;
            }

            .notification-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .noti-icon {
                width: 48px;
                height: 48px;
                font-size: 1.2em;
            }

            .noti-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .notification-actions {
                flex-direction: column;
            }

            .action-btn {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 20px;
            }

            .page-title {
                font-size: 1.8em;
            }

            .stat-card {
                padding: 20px;
            }

            .notification-item {
                padding: 16px;
            }
        }

        /* Animation for page load */
        .notification-item {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.6s ease forwards;
        }

        .notification-item:nth-child(1) { animation-delay: 0.1s; }
        .notification-item:nth-child(2) { animation-delay: 0.2s; }
        .notification-item:nth-child(3) { animation-delay: 0.3s; }
        .notification-item:nth-child(4) { animation-delay: 0.4s; }
        .notification-item:nth-child(5) { animation-delay: 0.5s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-bell"></i> Thông báo của bạn
            </h1>
            <p class="page-subtitle">Quản lý và theo dõi tất cả thông báo quan trọng</p>
        </div>

        <div class="notification-stats">
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="totalCount" value="0" />
                    <c:forEach var="noti" items="${notifications}">
                        <c:set var="totalCount" value="${totalCount + 1}" />
                    </c:forEach>
                    ${totalCount}
                </div>
                <div class="stat-label">Tổng thông báo</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="unreadCount" value="0" />
                    <c:forEach var="noti" items="${notifications}">
                        <c:if test="${!noti.read}">
                            <c:set var="unreadCount" value="${unreadCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${unreadCount}
                </div>
                <div class="stat-label">Chưa đọc</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="readCount" value="0" />
                    <c:forEach var="noti" items="${notifications}">
                        <c:if test="${noti.read}">
                            <c:set var="readCount" value="${readCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${readCount}
                </div>
                <div class="stat-label">Đã đọc</div>
            </div>
        </div>

        <div class="notifications-container">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-bell-slash"></i>
                        </div>
                        <div class="empty-title">Không có thông báo nào</div>
                        <div class="empty-message">Bạn chưa có thông báo nào. Chúng tôi sẽ thông báo khi có cập nhật mới.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="noti" items="${notifications}">
                        <a class="noti-link" href="${pageContext.request.contextPath}/host/notification-detail?id=${noti.notificationId}">
                            <div class="notification-item ${noti.read ? '' : 'unread'}">
                                <div class="notification-header">
                                    <div class="noti-icon 
                                        <c:choose>
                                            <c:when test="${noti.type eq 'content_approval'}">icon-approval</c:when>
                                            <c:when test="${noti.type eq 'POST_HIDDEN'}">icon-hidden</c:when>
                                            <c:when test="${noti.type eq 'POST_REPORTED'}">icon-reported</c:when>
                                            <c:otherwise>icon-default</c:otherwise>
                                        </c:choose>
                                    ">
                                        <c:choose>
                                            <c:when test="${noti.type eq 'content_approval'}">
                                                <i class="fa-solid fa-circle-check"></i>
                                            </c:when>
                                            <c:when test="${noti.type eq 'POST_HIDDEN'}">
                                                <i class="fa-solid fa-eye-slash"></i>
                                            </c:when>
                                            <c:when test="${noti.type eq 'POST_REPORTED'}">
                                                <i class="fa-solid fa-flag"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-bell"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="noti-content">
                                        <div class="noti-title">${noti.title}</div>
                                        <div class="noti-message">
                                            <c:out value="${noti.message}" escapeXml="false"/>
                                        </div>
                                        <div class="noti-meta">
                                            <div class="noti-time">
                                                <i class="fas fa-clock"></i>
                                                <fmt:formatDate value="${noti.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                            <div class="noti-status ${noti.read ? 'status-read' : 'status-unread'}">
                                                <c:choose>
                                                    <c:when test="${noti.read}">Đã đọc</c:when>
                                                    <c:otherwise>Chưa đọc</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="notification-actions">
                                    <span class="action-btn btn-primary">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </span>
                                    <c:if test="${!noti.read}">
                                        <span class="action-btn btn-secondary">
                                            <i class="fas fa-check"></i>
                                            Đánh dấu đã đọc
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
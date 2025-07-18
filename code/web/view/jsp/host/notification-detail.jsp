<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết thông báo</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --error-color: #ef4444;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --bg-primary: #f8fafc;
            --bg-secondary: #ffffff;
            --border-color: #e5e7eb;
            --shadow-light: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-medium: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --shadow-heavy: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        [data-theme="dark"] {
            --text-primary: #f9fafb;
            --text-secondary: #d1d5db;
            --bg-primary: #0f172a;
            --bg-secondary: #1e293b;
            --border-color: #334155;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
            transition: all 0.3s ease;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 1000;
            color: white;
        }

        .theme-toggle:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
            position: relative;
            z-index: 1;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInUp 0.8s ease;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
        }

        .notification-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-heavy);
            transition: all 0.3s ease;
            animation: slideInRight 0.8s ease;
            position: relative;
            overflow: hidden;
        }

        .notification-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        }

        .notification-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .notification-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .notification-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 5px;
        }

        .notification-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            font-size: 0.9rem;
            background: rgba(102, 126, 234, 0.1);
            padding: 8px 12px;
            border-radius: 20px;
            transition: all 0.3s ease;
        }

        .meta-item:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }

        .notification-message {
            font-size: 1.1rem;
            line-height: 1.8;
            color: var(--text-primary);
            margin-bottom: 20px;
            padding: 20px;
            background: rgba(248, 250, 252, 0.8);
            border-radius: 15px;
            border-left: 4px solid var(--primary-color);
        }

        .success-message {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #065f46;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 600;
            animation: bounceIn 0.8s ease;
        }

        .success-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--success-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .appeal-form {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(230, 247, 255, 0.5);
            padding: 30px;
            border-radius: 20px;
            box-shadow: var(--shadow-medium);
            animation: slideInLeft 0.8s ease;
        }

        .appeal-form h3 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .form-textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            font-family: inherit;
            resize: vertical;
            min-height: 120px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .submit-btn {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 50px;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        .back-link:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-5px);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: var(--shadow-heavy);
            animation: fadeIn 0.8s ease;
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 10px;
        }

        .empty-description {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

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

        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 20px 15px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .notification-card {
                padding: 20px;
            }

            .notification-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .notification-meta {
                flex-direction: column;
                gap: 10px;
            }

            .appeal-form {
                padding: 20px;
            }
        }

        /* Dark mode styles */
        [data-theme="dark"] .notification-card {
            background: rgba(30, 41, 59, 0.95);
            color: var(--text-primary);
        }

        [data-theme="dark"] .notification-message {
            background: rgba(15, 23, 42, 0.8);
            color: var(--text-primary);
        }

        [data-theme="dark"] .appeal-form {
            background: rgba(30, 41, 59, 0.9);
        }

        [data-theme="dark"] .form-textarea {
            background: rgba(15, 23, 42, 0.9);
            color: var(--text-primary);
            border-color: var(--border-color);
        }

        [data-theme="dark"] .meta-item {
            background: rgba(102, 126, 234, 0.2);
            color: var(--text-secondary);
        }

        [data-theme="dark"] .empty-state {
            background: rgba(30, 41, 59, 0.95);
        }
    </style>
</head>
<body>
    <div class="theme-toggle" onclick="toggleTheme()">
        <i class="fas fa-moon" id="theme-icon"></i>
    </div>

    <div class="container">
        <div class="header">
            <h1>Chi tiết thông báo</h1>
            <p>Xem thông tin chi tiết và thực hiện kháng cáo nếu cần</p>
        </div>

        <c:if test="${not empty notification}">
            <div class="notification-card">
                <div class="notification-header">
                    <div class="notification-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div>
                        <div class="notification-title">${notification.title}</div>
                        <div class="notification-meta">
                            <div class="meta-item">
                                <i class="fas fa-tag"></i>
                                <span>${notification.type}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <span><fmt:formatDate value="${notification.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="notification-message">${notification.message}</div>
            </div>

            <c:if test="${appealSuccess}">
                <div class="success-message">
                    <div class="success-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <div>
                        <strong>Thành công!</strong> Kháng cáo của bạn đã được gửi thành công! Admin sẽ xem xét và phản hồi sớm nhất.
                    </div>
                </div>
            </c:if>

            <c:if test="${empty appealSuccess}">
                <form class="appeal-form" method="post" action="${pageContext.request.contextPath}/host/notification-appeal">
                    <h3>
                        <i class="fas fa-gavel"></i>
                        Gửi kháng cáo
                    </h3>
                    <c:if test="${not empty appealError}">
                        <div style="color: #e74c3c; font-weight: 600; margin-bottom: 12px;">
                            ${appealError}
                        </div>
                    </c:if>
                    <input type="hidden" name="notificationId" value="${notification.notificationId}" />
                    <div class="form-group">
                        <label class="form-label" for="appealMessage">Nội dung kháng cáo:</label>
                        <textarea 
                            name="appealMessage" 
                            id="appealMessage" 
                            class="form-textarea" 
                            placeholder="Vui lòng mô tả chi tiết lý do kháng cáo của bạn..."
                            required></textarea>
                    </div>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-paper-plane"></i>
                        Gửi kháng cáo
                    </button>
                </form>
            </c:if>
        </c:if>

        <c:if test="${empty notification}">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="empty-title">Không tìm thấy thông báo</div>
                <div class="empty-description">Thông báo bạn đang tìm kiếm có thể đã bị xóa hoặc không tồn tại.</div>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/host/notifications" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Quay lại danh sách thông báo
        </a>
    </div>

    <script>
        function toggleTheme() {
            const body = document.body;
            const themeIcon = document.getElementById('theme-icon');
            const currentTheme = body.getAttribute('data-theme');
            
            if (currentTheme === 'dark') {
                body.setAttribute('data-theme', 'light');
                themeIcon.className = 'fas fa-moon';
                localStorage.setItem('theme', 'light');
            } else {
                body.setAttribute('data-theme', 'dark');
                themeIcon.className = 'fas fa-sun';
                localStorage.setItem('theme', 'dark');
            }
        }

        // Load saved theme
        document.addEventListener('DOMContentLoaded', function() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            const themeIcon = document.getElementById('theme-icon');
            
            if (savedTheme === 'dark') {
                document.body.setAttribute('data-theme', 'dark');
                themeIcon.className = 'fas fa-sun';
            } else {
                document.body.setAttribute('data-theme', 'light');
                themeIcon.className = 'fas fa-moon';
            }
        });

        // Add smooth scrolling and form validation
        document.addEventListener('DOMContentLoaded', function() {
            const textarea = document.getElementById('appealMessage');
            const submitBtn = document.querySelector('.submit-btn');
            
            if (textarea) {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = this.scrollHeight + 'px';
                });
            }

            if (submitBtn) {
                submitBtn.addEventListener('click', function(e) {
                    if (textarea && textarea.value.trim() === '') {
                        e.preventDefault();
                        textarea.focus();
                        textarea.style.borderColor = 'var(--error-color)';
                        setTimeout(() => {
                            textarea.style.borderColor = 'var(--border-color)';
                        }, 2000);
                    }
                });
            }
        });
    </script>
</body>
</html>
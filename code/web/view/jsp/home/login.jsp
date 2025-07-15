<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #10466C;
                --secondary-color: #83C5BE;
                --accent-color: #006D77;
                --success-color: #28a745;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
                --light-gray: #f8f9fa;
                --border-radius: 12px;
                --shadow: 0 10px 30px rgba(0,0,0,0.1);
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, var(--secondary-color) 0%, var(--primary-color) 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                line-height: 1.6;
            }

            .login-container {
                background: white;
                border-radius: 24px;
                box-shadow: var(--shadow);
                overflow: hidden;
                max-width: 500px;
                width: 100%;
                animation: slideUp 0.6s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-header {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: white;
                padding: 50px 40px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .login-header::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="80" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="40" cy="70" r="1" fill="rgba(255,255,255,0.05)"/><circle cx="90" cy="10" r="1" fill="rgba(255,255,255,0.05)"/></svg>');
                animation: float 20s linear infinite;
            }

            @keyframes float {
                0% {
                    transform: translate(-50%, -50%) rotate(0deg);
                }
                100% {
                    transform: translate(-50%, -50%) rotate(360deg);
                }
            }

            .login-header h2 {
                margin: 0 0 15px;
                font-size: 2.5rem;
                font-weight: 700;
                position: relative;
                z-index: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
            }

            .login-header p {
                margin: 0;
                font-size: 1.1rem;
                opacity: 0.95;
                position: relative;
                z-index: 1;
            }

            .brand-logo {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                object-fit: cover;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .login-body {
                padding: 40px;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 500;
                margin-bottom: 20px;
                transition: var(--transition);
            }

            .back-link:hover {
                color: var(--accent-color);
                transform: translateX(-3px);
            }

            .btn-google {
                width: 100%;
                padding: 14px;
                border: 2px solid #e9ecef;
                border-radius: var(--border-radius);
                background: white;
                color: #374151;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-bottom: 1.5rem;
                cursor: pointer;
                transition: var(--transition);
                text-decoration: none;
            }

            .btn-google:hover {
                border-color: #4285f4;
                background: #fafbff;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(66,133,244,0.2);
                color: #374151;
                text-decoration: none;
            }

            .google-icon {
                width: 20px;
                height: 20px;
            }

            .divider {
                text-align: center;
                color: #9ca3af;
                margin: 1.5rem 0;
                position: relative;
            }

            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: #e5e7eb;
            }

            .divider span {
                background: white;
                padding: 0 15px;
                position: relative;
                font-weight: 500;
            }

            .form-floating {
                margin-bottom: 1.5rem;
            }

            .form-floating > .form-control {
                border: 2px solid #e9ecef;
                border-radius: var(--border-radius);
                padding: 1rem 0.75rem;
                padding-left: 45px;
                font-size: 1rem;
                transition: var(--transition);
                height: calc(3.5rem + 2px);
            }

            .form-floating > .form-control:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 0.25rem rgba(131, 197, 190, 0.15);
            }

            .form-floating > label {
                padding: 1rem 0.75rem;
                padding-left: 45px;
                font-weight: 500;
                color: #6c757d;
            }

            .input-icon {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                z-index: 5;
            }

            /* Password field specific styles */
            .password-field {
                position: relative;
            }

            .password-field .form-control {
                padding-right: 45px;
            }

            .password-toggle {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #9ca3af;
                cursor: pointer;
                z-index: 5;
                padding: 5px;
                border-radius: 4px;
                transition: var(--transition);
            }

            .password-toggle:hover {
                color: var(--primary-color);
                background: rgba(16, 70, 108, 0.1);
            }

            .password-toggle:focus {
                outline: 2px solid var(--secondary-color);
                outline-offset: 2px;
            }

            .btn-login {
                width: 100%;
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                border: none;
                color: white;
                padding: 14px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 50px;
                cursor: pointer;
                transition: var(--transition);
                margin-bottom: 1.5rem;
                position: relative;
                overflow: hidden;
            }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-login:hover::before {
                left: 100%;
            }

            .btn-login:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(16, 70, 108, 0.3);
            }

            .btn-login:disabled {
                opacity: 0.7;
                cursor: not-allowed;
                transform: none;
            }

            .alert-custom {
                border-radius: var(--border-radius);
                border: none;
                padding: 1rem 1.25rem;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .alert-danger {
                background: linear-gradient(135deg, #ffebee, #ffcdd2);
                color: #c62828;
                border-left: 4px solid var(--danger-color);
            }

            .alert-success {
                background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
                color: #2e7d32;
                border-left: 4px solid var(--success-color);
            }

            .alert-info {
                background: linear-gradient(135deg, #e3f2fd, #bbdefb);
                color: #1565c0;
                border-left: 4px solid #2196f3;
            }

            .register-link {
                text-align: center;
                margin-top: 1.5rem;
                color: #6c757d;
            }

            .register-link a {
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 600;
                transition: var(--transition);
            }

            .register-link a:hover {
                color: var(--accent-color);
                text-decoration: underline;
            }

            .form-check {
                margin-bottom: 1rem;
            }

            .form-check-input:checked {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .form-check-input:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 0.25rem rgba(131, 197, 190, 0.15);
            }

            .forgot-password {
                color: var(--primary-color);
                text-decoration: none;
                font-size: 0.9rem;
                font-weight: 500;
                transition: var(--transition);
            }

            .forgot-password:hover {
                color: var(--accent-color);
                text-decoration: underline;
            }

            /* Responsive Design */
            @media (max-width: 576px) {
                .login-container {
                    margin: 10px;
                    border-radius: 16px;
                }

                .login-header {
                    padding: 30px 20px;
                }

                .login-header h2 {
                    font-size: 2rem;
                }

                .login-body {
                    padding: 30px 20px;
                }
            }

            /* Loading animation */
            .spinner-border-sm {
                width: 1rem;
                height: 1rem;
                margin-right: 8px;
            }

            /* Custom scrollbar */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            ::-webkit-scrollbar-thumb {
                background: var(--secondary-color);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: var(--primary-color);
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <h2>
                    <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo" class="brand-logo">
                    VietCulture
                </h2>
                <p>Chào mừng bạn trở lại!</p>
            </div>

            <div class="login-body">
                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="fas fa-arrow-left"></i> Về trang chủ
                </a>

                <!-- Error Messages -->
                <c:if test="${param.error == 'invalid'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-circle"></i>
                        Email hoặc mật khẩu không đúng.
                    </div>
                </c:if>

                <c:if test="${param.error == 'inactive'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-ban"></i>
                        Tài khoản đã bị vô hiệu hóa.
                    </div>
                </c:if>

                <c:if test="${param.error == 'oauth_cancelled'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-times-circle"></i>
                        Đăng nhập Google đã bị hủy.
                    </div>
                </c:if>

                <c:if test="${param.error == 'oauth_failed'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle"></i>
                        Đăng nhập Google thất bại.
                    </div>
                </c:if>

                <c:if test="${param.error == 'token_exchange_failed'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle"></i>
                        Không thể trao đổi mã xác thực.
                    </div>
                </c:if>

                <c:if test="${param.error == 'userinfo_failed'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle"></i>
                        Không thể lấy thông tin người dùng.
                    </div>
                </c:if>

                <c:if test="${param.error == 'processing_failed'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle"></i>
                        Có lỗi xảy ra khi xử lý đăng nhập.
                    </div>
                </c:if>

                <c:if test="${param.error == 'google_login_failed'}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-triangle"></i>
                        Đăng nhập Google thất bại.
                    </div>
                </c:if>

                <c:if test="${param.success == 'registered'}">
                    <div class="alert alert-success alert-custom">
                        <i class="fas fa-check-circle"></i>
                        Tài khoản đã được tạo thành công!
                    </div>
                </c:if>

                <c:if test="${param.message == 'logout'}">
                    <div class="alert alert-info alert-custom">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng xuất thành công!
                    </div>
                </c:if>

                <!-- Display server-side error messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-custom">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <!-- Google Sign-In Button (Redirect Method Only) -->
                <% 
                // Tạo URL Google đăng nhập (Authorization Code Flow)
                String redirectURL = request.getParameter("redirect");
                String contextPath = request.getContextPath();
                String googleLoginUrl = "https://accounts.google.com/o/oauth2/auth" +
                    "?scope=email%20profile%20openid" +
                    "&redirect_uri=http://localhost:8080" + contextPath + "/auth/google" +
                    "&response_type=code" +
                    "&client_id=106009165959-sbaj5qlt77p65jj33qp62kjle5ggchff.apps.googleusercontent.com" +
                    "&access_type=offline" +
                    "&prompt=consent";
                
                // Thêm tham số redirect vào URL nếu cần
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    googleLoginUrl += "&state=" + java.net.URLEncoder.encode(redirectURL, "UTF-8");
                }
                %>

                <a href="<%= googleLoginUrl %>" class="btn-google">
                    <svg class="google-icon" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                    </svg>
                    Đăng nhập với Google
                </a>

                <div class="divider"><span>hoặc</span></div>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                    <div class="form-floating position-relative">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" class="form-control" name="email" id="email" placeholder="Email" required
                               value="${param.email != null ? param.email : (email != null ? email : '')}">
                        <label for="email">Email</label>
                    </div>

                    <div class="form-floating position-relative password-field">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" class="form-control" name="password" id="password" placeholder="Mật khẩu" required minlength="6">
                        <label for="password">Mật khẩu</label>
                        <button type="button" class="password-toggle" id="togglePassword" aria-label="Hiển thị/ẩn mật khẩu">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="remember" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                        </div>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                    </div>

                    <% if (redirectURL != null && !redirectURL.isEmpty()) { %>
                    <input type="hidden" name="returnUrl" value="<%= redirectURL %>">
                    <% } %>

                    <button type="submit" class="btn-login" id="loginBtn">
                        <span class="btn-text">
                            <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                        </span>
                        <span class="btn-loading d-none">
                            <span class="spinner-border spinner-border-sm" role="status"></span>
                            Đang xử lý...
                        </span>
                    </button>
                </form>

                <div class="register-link">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('loginForm');
                const loginBtn = document.getElementById('loginBtn');
                const togglePassword = document.getElementById('togglePassword');
                const passwordField = document.getElementById('password');
                const toggleIcon = document.getElementById('toggleIcon');

                // Password toggle functionality
                togglePassword.addEventListener('click', function () {
                    const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordField.setAttribute('type', type);

                    // Update icon
                    if (type === 'text') {
                        toggleIcon.classList.remove('fa-eye');
                        toggleIcon.classList.add('fa-eye-slash');
                        togglePassword.setAttribute('aria-label', 'Ẩn mật khẩu');
                    } else {
                        toggleIcon.classList.remove('fa-eye-slash');
                        toggleIcon.classList.add('fa-eye');
                        togglePassword.setAttribute('aria-label', 'Hiển thị mật khẩu');
                    }
                });

                // Form validation
                form.addEventListener('submit', function (e) {
                    e.preventDefault();

                    const email = this.email.value.trim();
                    const password = this.password.value.trim();

                    if (!email || !password) {
                        showNotification('Vui lòng nhập đầy đủ thông tin', 'error');
                        return;
                    }

                    if (password.length < 6) {
                        showNotification('Mật khẩu phải có ít nhất 6 ký tự', 'error');
                        return;
                    }

                    // Show loading state
                    loginBtn.disabled = true;
                    loginBtn.querySelector('.btn-text').classList.add('d-none');
                    loginBtn.querySelector('.btn-loading').classList.remove('d-none');

                    // Submit form
                    setTimeout(() => {
                        this.submit();
                    }, 500);
                });

                // Notification system
                function showNotification(message, type = 'info') {
                    const notification = document.createElement('div');
                    const alertClass = type === 'error' ? 'danger' : type;
                    notification.className = 'alert alert-' + alertClass + ' alert-dismissible fade show position-fixed';
                    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 10px 30px rgba(0,0,0,0.2);';

                    const icon = type === 'error' ? 'exclamation-triangle' :
                            type === 'success' ? 'check-circle' : 'info-circle';

                    notification.innerHTML = `
                        <i class="fas fa-${icon} me-2"></i>${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    `;

                    document.body.appendChild(notification);

                    // Auto dismiss after 5 seconds
                    setTimeout(() => {
                        const alert = bootstrap.Alert.getOrCreateInstance(notification);
                        alert.close();
                    }, 5000);
                }

                // Auto-focus email field
                document.getElementById('email').focus();

                // Keyboard shortcuts
                document.addEventListener('keydown', function (e) {
                    // Ctrl/Cmd + Enter to submit
                    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                        e.preventDefault();
                        form.dispatchEvent(new Event('submit'));
                    }

                    // Alt + P to toggle password visibility
                    if (e.altKey && e.key === 'p') {
                        e.preventDefault();
                        togglePassword.click();
                    }
                });
            });
        </script>
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="utils.OAuthConstants" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập | Traveler System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        :root {
            --primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --text: #2d3436;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: url('https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=1350') center/cover fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
        }
        
        body::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.6);
            z-index: 0;
        }
        
        .login-card {
            width: 400px;
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            backdrop-filter: blur(15px);
            position: relative;
            z-index: 10;
            margin: 0 auto;
        }
        
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--primary);
            border-radius: 20px 20px 0 0;
        }
        
        .brand {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .brand h2 {
            color: var(--text);
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }
        
        .brand i {
            color: #667eea;
            font-size: 2rem;
            margin-right: 10px;
        }
        
        .btn-google {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            background: white;
            color: #374151;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
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
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-control {
            padding: 12px 15px 12px 45px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }
        
        .btn-login {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 10px;
            background: var(--primary);
            color: white;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102,126,234,0.3);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 12px 15px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger {
            background: #fef2f2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }
        
        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }
        
        .alert-info {
            background: #eff6ff;
            color: #1e40af;
            border-left: 4px solid #3b82f6;
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text);
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            color: #667eea;
            text-decoration: none;
            margin-bottom: 1rem;
            font-size: 14px;
            gap: 5px;
        }
        
        .back-link:hover {
            color: #764ba2;
            text-decoration: none;
        }
        
        .google-method-toggle {
            text-align: center;
            margin-bottom: 1rem;
        }
        
        .method-btn {
            background: none;
            border: 1px solid #e5e7eb;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            margin: 0 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .method-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        @media (max-width: 576px) {
            .login-card {
                width: 95%;
                padding: 2rem 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-card">
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Về trang chủ
            </a>
            
            <div class="brand">
                <h2><i class="fas fa-plane"></i>Traveler System</h2>
                <p class="text-muted mb-0">Chào mừng bạn trở lại!</p>
            </div>
            
            <!-- Error Messages -->
            <c:if test="${param.error == 'invalid'}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
           
                </div>
            </c:if>
            
            <c:if test="${param.error == 'inactive'}">
                <div class="alert alert-danger">
                    <i class="fas fa-ban"></i>
                    <%= OAuthConstants.ERROR_ACCOUNT_DISABLED %>
                </div>
            </c:if>
            
            <c:if test="${param.success == 'registered'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= OAuthConstants.SUCCESS_ACCOUNT_CREATED %>
                </div>
            </c:if>

            <c:if test="${param.message == 'logout'}">
                <div class="alert alert-info">
                    <i class="fas fa-sign-out-alt"></i>
          
                </div>
            </c:if>
            
            <%-- Method Toggle (for development/testing) --%>
            <div class="google-method-toggle">
                <button type="button" class="method-btn active" id="jsMethodBtn">JS Token</button>
                <button type="button" class="method-btn" id="redirectMethodBtn">Redirect</button>
            </div>
            
            <%-- Method 1: JavaScript ID Token (Default) --%>
            <button type="button" class="btn-google" id="googleSignInBtn">
                <svg class="google-icon" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                <span id="googleBtnText">Đăng nhập với Google</span>
            </button>
            
            <%-- Method 2: Authorization Code Flow (Hidden by default) --%>
            <% 
            // Tạo URL Google đăng nhập (Authorization Code Flow)
            String redirectURL = request.getParameter("redirect");
            String contextPath = request.getContextPath(); // Should be "/Travel"
            String googleLoginUrl = "https://accounts.google.com/o/oauth2/auth" +
                "?scope=email%20profile%20openid" +
                "&redirect_uri=http://localhost:8080" + contextPath + "/loginG" +
                "&response_type=code" +
                "&client_id=615494968856-lmpij4au1k1gmcqmlgfrc70q4dghh7l2.apps.googleusercontent.com" +
                "&access_type=offline" +
                "&prompt=consent";
                
            // Thêm tham số redirect vào URL nếu cần
            if (redirectURL != null && !redirectURL.isEmpty()) {
                googleLoginUrl += "&state=" + java.net.URLEncoder.encode(redirectURL, "UTF-8");
            }
            %>
            
            <a href="<%= googleLoginUrl %>" class="btn-google" id="googleRedirectBtn" style="display: none;">
                <svg class="google-icon" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                Đăng nhập với Google (Redirect)
            </a>
            
            <div class="divider"><span>hoặc</span></div>
            
            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                <div class="form-group position-relative">
                    <input type="email" class="form-control" name="email" placeholder="Email" required>
                    <i class="fas fa-envelope input-icon"></i>
                </div>
                
                <div class="form-group position-relative">
                    <input type="password" class="form-control" name="password" placeholder="Mật khẩu" required id="passwordInput">
                    <i class="fas fa-lock input-icon"></i>
                </div>
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">Ghi nhớ</label>
                    </div>
<a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none" style="color: #667eea; font-size: 14px;">Quên mật khẩu?</a>                </div>
                
                <% if (redirectURL != null && !redirectURL.isEmpty()) { %>
                    <input type="hidden" name="redirect" value="<%= redirectURL %>">
                <% } %>
                
                <button type="submit" class="btn-login" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                </button>
            </form>
            
            <div class="register-link">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
       
        
        let isGoogleReady = false;
        let isProcessing = false;
        let currentMethod = 'js'; // 'js' or 'redirect'
        
        // Method Toggle
        document.getElementById('jsMethodBtn').addEventListener('click', function() {
            switchMethod('js');
        });
        
        document.getElementById('redirectMethodBtn').addEventListener('click', function() {
            switchMethod('redirect');
        });
        
        function switchMethod(method) {
            currentMethod = method;
            
            // Update button states
            document.getElementById('jsMethodBtn').classList.toggle('active', method === 'js');
            document.getElementById('redirectMethodBtn').classList.toggle('active', method === 'redirect');
            
            // Show/hide appropriate buttons
            document.getElementById('googleSignInBtn').style.display = method === 'js' ? 'flex' : 'none';
            document.getElementById('googleRedirectBtn').style.display = method === 'redirect' ? 'flex' : 'none';
        }
        
        // Initialize Google Sign-In (JS Method)
        function initGoogleSignIn() {
            if (typeof google === 'undefined') {
                setTimeout(initGoogleSignIn, 200);
                return;
            }
            try {
                google.accounts.id.initialize({
                    client_id: CONFIG.GOOGLE_CLIENT_ID,
                    callback: handleGoogleSignIn
                });
                isGoogleReady = true;
                document.getElementById('googleBtnText').textContent = 'Đăng nhập với Google';
            } catch (error) {
                console.error('Google Sign-In init failed:', error);
                document.getElementById('googleBtnText').textContent = 'Google không khả dụng';
            }
        }
        
        async function handleGoogleSignIn(response) {
            if (isProcessing) return;
            isProcessing = true;
            
            document.getElementById('googleBtnText').textContent = 'Đang xử lý...';
            
            try {
                const formData = new FormData();
                formData.append('idToken', response.credential);
                
                const result = await fetch(CONFIG.CONTEXT_PATH + '/auth/google', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await result.json();
                
                if (data.success) {
                    window.location.href = data.redirectUrl || CONFIG.CONTEXT_PATH + '/';
                } else {
                    alert('Lỗi: ' + data.error);
                }
            } catch (error) {
                console.error('Google Sign-In Error:', error);
                alert('Lỗi kết nối: ' + error.message);
            } finally {
                isProcessing = false;
                document.getElementById('googleBtnText').textContent = 'Đăng nhập với Google';
            }
        }
        
        // Google button click (JS Method)
        document.getElementById('googleSignInBtn').addEventListener('click', function() {
            if (isGoogleReady && !isProcessing) {
                google.accounts.id.prompt();
            }
        });
        
        // Form submit
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            if (isProcessing) {
                e.preventDefault();
                return;
            }
            
            const email = this.email.value.trim();
            const password = this.password.value.trim();
            
            if (!email || !password) {
                e.preventDefault();
                alert('Vui lòng nhập đầy đủ thông tin');
                return;
            }
            
            if (password.length < CONFIG.MIN_PASSWORD_LENGTH) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất ' + CONFIG.MIN_PASSWORD_LENGTH + ' ký tự');
                return;
            }
            
            isProcessing = true;
            document.getElementById('loginBtn').disabled = true;
        });
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('passwordInput').setAttribute('minlength', CONFIG.MIN_PASSWORD_LENGTH);
            initGoogleSignIn();
            
            // Check URL parameters to determine which method was used
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('code') || urlParams.has('error')) {
                // Came from Google OAuth redirect
                switchMethod('redirect');
            }
        });
    </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký | VietCulture</title>
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

        .register-container {
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

        .register-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 50px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
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
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        .register-header h2 {
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

        .register-header p {
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

        .register-body {
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

        .form-floating {
            margin-bottom: 1.5rem;
            position: relative;
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

        .role-selector {
            margin: 2rem 0;
        }

        .role-option {
            border: 2px solid #e9ecef;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            cursor: pointer;
            transition: var(--transition);
            text-align: center;
            background: white;
        }

        .role-option:hover {
            border-color: var(--secondary-color);
            background: #f8fdfc;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(131, 197, 190, 0.15);
        }

        .role-option.selected {
            border-color: var(--primary-color);
            background: linear-gradient(135deg, #f8fdfc, #e8f7f5);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 70, 108, 0.2);
        }

        .role-option i {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            transition: var(--transition);
        }

        .role-option.selected i {
            color: var(--accent-color);
            transform: scale(1.1);
        }

        .role-option h5 {
            margin: 0 0 0.5rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        .role-option p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .password-strength {
            height: 4px;
            border-radius: 2px;
            margin-top: 0.5rem;
            background: #e9ecef;
            overflow: hidden;
            transition: var(--transition);
        }

        .password-strength-fill {
            height: 100%;
            transition: var(--transition);
            border-radius: 2px;
        }

        .strength-weak {
            background: linear-gradient(90deg, var(--danger-color), #ff6b6b);
            width: 25%;
        }

        .strength-medium {
            background: linear-gradient(90deg, var(--warning-color), #ffeb3b);
            width: 60%;
        }

        .strength-strong {
            background: linear-gradient(90deg, var(--success-color), #4caf50);
            width: 100%;
        }

        .btn-register {
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

        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-register:hover::before {
            left: 100%;
        }

        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(16, 70, 108, 0.3);
        }

        .btn-register:disabled {
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

        .success-message {
            background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
            color: #2e7d32;
            padding: 2rem;
            border-radius: var(--border-radius);
            text-align: center;
            margin-bottom: 2rem;
            border-left: 4px solid var(--success-color);
        }

        .success-message i {
            font-size: 3rem;
            color: var(--success-color);
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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

        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #6c757d;
        }

        .login-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
        }

        .login-link a:hover {
            color: var(--accent-color);
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 576px) {
            .register-container {
                margin: 10px;
                border-radius: 16px;
            }

            .register-header {
                padding: 30px 20px;
            }

            .register-header h2 {
                font-size: 2rem;
            }

            .register-body {
                padding: 30px 20px;
            }

            .role-option {
                margin-bottom: 1rem;
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

        /* Input validation states */
        .is-valid {
            border-color: var(--success-color) !important;
        }

        .is-invalid {
            border-color: var(--danger-color) !important;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>
                <img src="${pageContext.request.contextPath}/view/assets/home/img/logo.jpg" alt="VietCulture Logo" class="brand-logo">
                VietCulture
            </h2>
            <p>Tham gia cộng đồng du lịch ngay hôm nay!</p>
        </div>

        <div class="register-body">
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Về trang chủ
            </a>

            <!-- Success Message -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-custom">
                    <i class="fas fa-check-circle"></i>
                    ${successMessage}
                    <c:if test="${not empty registeredEmail}">
                        <br>Email: <strong>${registeredEmail}</strong>
                        <hr style="border-color: rgba(46, 125, 50, 0.2);">
                        <p class="mb-0">Không nhận được email? 
                            <a href="${pageContext.request.contextPath}/resend-verification?email=${registeredEmail}" 
                               class="text-success">
                                <i class="fas fa-paper-plane"></i> Gửi lại email xác thực
                            </a>
                        </p>
                    </c:if>
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-custom">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Info Message -->
            <c:if test="${not empty message}">
                <div class="alert alert-info alert-custom">
                    <i class="fas fa-info-circle"></i>
                    ${message}
                </div>
            </c:if>

            <!-- Registration Form -->
            <c:if test="${empty successMessage}">
                <form action="${pageContext.request.contextPath}/register" method="post" 
                      id="registerForm" novalidate>
                    <!-- CSRF Token -->
                    <input type="hidden" name="csrfToken" value="${csrfToken}">

                    <div class="form-floating position-relative">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               placeholder="Họ và tên" required minlength="2" maxlength="100"
                               value="${param.fullName}">
                        <label for="fullName">Họ và tên *</label>
                        <div class="invalid-feedback">
                            Họ tên phải từ 2 đến 100 ký tự và chỉ chứa chữ cái
                        </div>
                    </div>

                    <div class="form-floating position-relative">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="Email" required maxlength="255"
                               value="${param.email}">
                        <label for="email">Email *</label>
                        <div class="invalid-feedback">
                            Vui lòng nhập địa chỉ email hợp lệ
                        </div>
                    </div>

                    <div class="form-floating position-relative">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Mật khẩu" required minlength="6" maxlength="128">
                        <label for="password">Mật khẩu *</label>
                        <div class="password-strength">
                            <div class="password-strength-fill" id="passwordStrengthFill"></div>
                        </div>
                        <small class="text-muted mt-1" id="passwordHint">Tối thiểu 6 ký tự</small>
                        <div class="invalid-feedback" id="passwordError">
                            Mật khẩu phải từ 6 đến 128 ký tự
                        </div>
                    </div>

                    <div class="form-floating position-relative">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" class="form-control" id="confirmPassword" 
                               name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                        <label for="confirmPassword">Xác nhận mật khẩu *</label>
                        <div class="invalid-feedback">
                            Mật khẩu xác nhận không khớp
                        </div>
                    </div>

                    <!-- Role Selection -->
                    <div class="role-selector">
                        <label class="form-label fw-semibold">
                            <i class="fas fa-user-tag me-2"></i>Vai trò tham gia: *
                        </label>
                        <div class="row g-3">
                            <div class="col-12">
                                <div class="role-option" data-role="TRAVELER">
                                    <i class="fas fa-suitcase-rolling"></i>
                                    <h5>Du khách</h5>
                                    <p>Khám phá và đặt trải nghiệm du lịch độc đáo</p>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="role-option" data-role="HOST">
                                    <i class="fas fa-house-user"></i>
                                    <h5>Chủ nhà / Host</h5>
                                    <p>Cung cấp dịch vụ và chia sẻ trải nghiệm</p>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="role" id="role">
                        <div class="text-danger d-none mt-2" id="roleError">
                            <i class="fas fa-exclamation-triangle me-1"></i>
                            Vui lòng chọn vai trò
                        </div>
                    </div>

                    <!-- Terms and Newsletter -->
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="agreeTerms" 
                               name="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            Tôi đồng ý với 
                            <a href="#" target="_blank" class="text-decoration-none">Điều khoản sử dụng</a> 
                            và <a href="#" target="_blank" class="text-decoration-none">Chính sách bảo mật</a> *
                        </label>
                        <div class="invalid-feedback">
                            Bạn phải đồng ý với điều khoản sử dụng
                        </div>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="newsletter" 
                               name="newsletter" ${param.newsletter == 'on' ? 'checked' : ''}>
                        <label class="form-check-label" for="newsletter">
                            Nhận thông tin khuyến mãi và cập nhật mới
                        </label>
                    </div>

                    <button type="submit" class="btn-register" id="submitBtn">
                        <span class="btn-text">
                            <i class="fas fa-user-plus"></i> Đăng Ký
                        </span>
                        <span class="btn-loading d-none">
                            <span class="spinner-border spinner-border-sm" role="status"></span>
                            Đang xử lý...
                        </span>
                    </button>

                    <div class="login-link">
                        Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                    </div>
                </form>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const submitBtn = document.getElementById('submitBtn');

            // Role selection
            document.querySelectorAll('.role-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('.role-option').forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    document.getElementById('role').value = this.getAttribute('data-role');
                    document.getElementById('roleError').classList.add('d-none');
                });
            });

            // Preserve selected role
            const selectedRole = '${param.role}';
            if (selectedRole) {
                const roleOption = document.querySelector(`[data-role="${selectedRole}"]`);
                if (roleOption) roleOption.click();
            }

            // Password strength checker
            const passwordInput = document.getElementById('password');
            const strengthFill = document.getElementById('passwordStrengthFill');
            const passwordHint = document.getElementById('passwordHint');

            passwordInput.addEventListener('input', function() {
                const password = this.value;
                strengthFill.className = 'password-strength-fill';

                if (password.length < 6) {
                    passwordHint.textContent = 'Quá yếu - Cần ít nhất 6 ký tự';
                    passwordHint.className = 'text-danger mt-1';
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    return;
                }

                let strength = 0;
                if (password.length >= 8) strength++;
                if (password.match(/[a-z]/)) strength++;
                if (password.match(/[A-Z]/)) strength++;
                if (password.match(/[0-9]/)) strength++;
                if (password.match(/[^a-zA-Z0-9]/)) strength++;

                if (strength <= 2) {
                    strengthFill.classList.add('strength-weak');
                    passwordHint.textContent = 'Yếu - Nên thêm chữ hoa, số hoặc ký tự đặc biệt';
                    passwordHint.className = 'text-warning mt-1';
                } else if (strength <= 3) {
                    strengthFill.classList.add('strength-medium');
                    passwordHint.textContent = 'Trung bình - Khá tốt';
                    passwordHint.className = 'text-info mt-1';
                } else {
                    strengthFill.classList.add('strength-strong');
                    passwordHint.textContent = 'Mạnh - Mật khẩu tốt!';
                    passwordHint.className = 'text-success mt-1';
                }

                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            });

            // Real-time validation
            function validateInput(input, validationFn) {
                input.addEventListener('input', function() {
                    if (validationFn(this.value)) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                });

                input.addEventListener('blur', function() {
                    if (this.value && !validationFn(this.value)) {
                        this.classList.add('is-invalid');
                    }
                });
            }

            validateInput(document.getElementById('fullName'), value => {
                const nameRegex = /^[a-zA-ZÀ-ỹ\s]+$/;
                return value.length >= 2 && value.length <= 100 && nameRegex.test(value);
            });

            validateInput(document.getElementById('email'), value => {
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return emailRegex.test(value) && value.length <= 255;
            });

            const confirmPasswordInput = document.getElementById('confirmPassword');
            confirmPasswordInput.addEventListener('input', function() {
                const password = passwordInput.value;
                const confirmPassword = this.value;

                if (confirmPassword && confirmPassword === password) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else if (confirmPassword) {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });

            // Form submission
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                let isValid = true;
                const errors = [];

                const fullName = document.getElementById('fullName').value.trim();
                const nameRegex = /^[a-zA-ZÀ-ỹ\s]+$/;
                if (!fullName || fullName.length < 2 || fullName.length > 100 || !nameRegex.test(fullName)) {
                    document.getElementById('fullName').classList.add('is-invalid');
                    errors.push('Họ tên không hợp lệ');
                    isValid = false;
                }

                const email = document.getElementById('email').value.trim();
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if (!email || !emailRegex.test(email) || email.length > 255) {
                    document.getElementById('email').classList.add('is-invalid');
                    errors.push('Email không hợp lệ');
                    isValid = false;
                }

                const password = document.getElementById('password').value;
                if (!password || password.length < 6 || password.length > 128) {
                    document.getElementById('password').classList.add('is-invalid');
                    errors.push('Mật khẩu không hợp lệ');
                    isValid = false;
                }

                const confirmPassword = document.getElementById('confirmPassword').value;
                if (!confirmPassword || password !== confirmPassword) {
                    document.getElementById('confirmPassword').classList.add('is-invalid');
                    errors.push('Mật khẩu xác nhận không khớp');
                    isValid = false;
                }

                const role = document.getElementById('role').value;
                if (!role) {
                    document.getElementById('roleError').classList.remove('d-none');
                    errors.push('Chưa chọn vai trò');
                    isValid = false;
                }

                const agreeTerms = document.getElementById('agreeTerms').checked;
                if (!agreeTerms) {
                    document.getElementById('agreeTerms').classList.add('is-invalid');
                    errors.push('Chưa đồng ý điều khoản');
                    isValid = false;
                }

                if (isValid) {
                    submitBtn.disabled = true;
                    submitBtn.querySelector('.btn-text').classList.add('d-none');
                    submitBtn.querySelector('.btn-loading').classList.remove('d-none');
                    setTimeout(() => this.submit(), 500);
                } else {
                    showNotification('Vui lòng kiểm tra lại thông tin: ' + errors.join(', '), 'error');
                    const firstError = this.querySelector('.is-invalid, .d-block:not(.d-none)');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        if (firstError.tagName === 'INPUT') setTimeout(() => firstError.focus(), 300);
                    }
                }
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

                setTimeout(() => {
                    const alert = bootstrap.Alert.getOrCreateInstance(notification);
                    alert.close();
                }, 5000);
            }

            // Auto-focus fullName field
            document.getElementById('fullName').focus();

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                    e.preventDefault();
                    form.dispatchEvent(new Event('submit'));
                }
            });

            // Auto-save form data to sessionStorage
            const autoSaveFields = ['fullName', 'email', 'role', 'newsletter'];
            function saveFormData() {
                const formData = {};
                autoSaveFields.forEach(fieldName => {
                    const field = document.getElementById(fieldName) || document.getElementsByName(fieldName)[0];
                    if (field) {
                        formData[fieldName] = field.type === 'checkbox' ? field.checked : field.value;
                    }
                });
                sessionStorage.setItem('registerFormData', JSON.stringify(formData));
            }

            function loadFormData() {
                try {
                    const savedData = JSON.parse(sessionStorage.getItem('registerFormData') || '{}');
                    autoSaveFields.forEach(fieldName => {
                        const field = document.getElementById(fieldName) || document.getElementsByName(fieldName)[0];
                        if (field && savedData[fieldName] !== undefined) {
                            if (field.type === 'checkbox') {
                                field.checked = savedData[fieldName];
                            } else {
                                field.value = savedData[fieldName];
                                if (fieldName === 'role' && savedData[fieldName]) {
                                    const roleOption = document.querySelector(`[data-role="${savedData[fieldName]}"]`);
                                    if (roleOption) roleOption.click();
                                }
                            }
                        }
                    });
                } catch (e) {
                    console.log('Could not load saved form data');
                }
            }

            loadFormData();
            autoSaveFields.forEach(fieldName => {
                const field = document.getElementById(fieldName) || document.getElementsByName(fieldName)[0];
                if (field) {
                    field.addEventListener('input', saveFormData);
                    field.addEventListener('change', saveFormData);
                }
            });

            if ('${not empty successMessage}' === 'true') {
                sessionStorage.removeItem('registerFormData');
            }
        });
    </script>
</body>
</html>
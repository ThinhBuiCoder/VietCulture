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
   z
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo" class="brand-logo">
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
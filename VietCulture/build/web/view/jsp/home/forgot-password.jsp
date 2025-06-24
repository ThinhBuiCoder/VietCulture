<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên Mật Khẩu | Traveler System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

            .forgot-password-card {
                width: 450px;
                background: rgba(255,255,255,0.95);
                border-radius: 20px;
                padding: 2.5rem;
                box-shadow: 0 20px 40px rgba(0,0,0,0.3);
                backdrop-filter: blur(15px);
                position: relative;
                z-index: 10;
                margin: 0 auto;
            }

            .forgot-password-card::before {
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

            .btn-primary {
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

            .btn-primary:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(102,126,234,0.3);
            }

            .btn-primary:disabled {
                opacity: 0.6;
                cursor: not-allowed;
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

            .otp-input {
                text-align: center;
                font-size: 1.5rem;
                font-weight: bold;
                letter-spacing: 0.5rem;
                padding: 15px 10px;
            }

            .resend-otp {
                text-align: center;
                margin-top: 1rem;
            }

            .resend-link {
                color: #667eea;
                text-decoration: none;
                font-size: 14px;
            }

            .resend-link:hover {
                text-decoration: underline;
            }

            .countdown {
                color: #6b7280;
                font-size: 14px;
                margin-top: 0.5rem;
            }

            .step-indicator {
                display: flex;
                justify-content: center;
                margin-bottom: 2rem;
                gap: 1rem;
            }

            .step {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: bold;
                color: white;
                background: #d1d5db;
            }

            .step.active {
                background: #667eea;
            }

            .step.completed {
                background: #10b981;
            }

            .password-requirements {
                background: #f9fafb;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 12px;
                margin-top: 1rem;
                font-size: 14px;
            }

            .requirement {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 4px;
            }

            .requirement i {
                font-size: 12px;
            }

            .requirement.valid {
                color: #065f46;
            }

            .requirement.invalid {
                color: #991b1b;
            }

            .loading-spinner {
                display: none;
                width: 20px;
                height: 20px;
                border: 2px solid #ffffff;
                border-top: 2px solid transparent;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 8px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            @media (max-width: 576px) {
                .forgot-password-card {
                    width: 95%;
                    padding: 2rem 1.5rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="forgot-password-card">
                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <i class="fas fa-arrow-left"></i> Về đăng nhập
                </a>

                <div class="brand">
                    <h2><i class="fas fa-key"></i>Quên Mật Khẩu</h2>
                    <p class="text-muted mb-0">Đặt lại mật khẩu của bạn</p>
                </div>

                <!-- Step Indicator -->
                <div class="step-indicator">
                    <div class="step ${showOtpForm || showPasswordForm ? 'completed' : 'active'}">1</div>
                    <div class="step ${showPasswordForm ? 'completed' : (showOtpForm ? 'active' : '')}">2</div>
                    <div class="step ${showPasswordForm ? 'active' : ''}">3</div>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>

                <!-- Step 1: Email Input -->
                <c:if test="${!showOtpForm && !showPasswordForm}">
                    <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="emailForm">
                        <input type="hidden" name="action" value="sendOTP">

                        <div class="form-group position-relative">
                            <input type="email" class="form-control" name="email" 
                                   placeholder="Nhập email của bạn" required
                                   value="${email}">
                            <i class="fas fa-envelope input-icon"></i>
                        </div>

                        <button type="submit" class="btn-primary" id="sendOtpBtn">
                            <div class="loading-spinner" id="sendOtpSpinner"></div>
                            <i class="fas fa-paper-plane" id="sendOtpIcon"></i> 
                            <span id="sendOtpText">Gửi Mã OTP</span>
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            Chúng tôi sẽ gửi mã xác thực 6 số đến email của bạn
                        </small>
                    </div>
                </c:if>

                <!-- Step 2: OTP Verification -->
                <c:if test="${showOtpForm && !showPasswordForm}">
                    <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="otpForm">
                        <input type="hidden" name="action" value="verifyOTP">
                        <input type="hidden" name="email" value="${email}">

                        <div class="text-center mb-3">
                            <p>Nhập mã OTP được gửi đến:</p>
                            <strong>${email}</strong>
                        </div>

                        <div class="form-group position-relative">
                            <input type="text" class="form-control otp-input" name="otp" 
                                   placeholder="000000" maxlength="6" required
                                   pattern="[0-9]{6}" inputmode="numeric">
                            <i class="fas fa-shield-alt input-icon"></i>
                        </div>

                        <button type="submit" class="btn-primary" id="verifyOtpBtn">
                            <div class="loading-spinner" id="verifyOtpSpinner"></div>
                            <i class="fas fa-check" id="verifyOtpIcon"></i> 
                            <span id="verifyOtpText">Xác Thực OTP</span>
                        </button>
                    </form>

                    <div class="resend-otp">
                        <div class="countdown" id="countdown">
                            Gửi lại mã sau: <span id="timer">60</span>s
                        </div>
                        <a href="#" class="resend-link" id="resendLink" style="display: none;" 
                           onclick="resendOTP('${email}')">
                            <i class="fas fa-redo"></i> Gửi lại mã OTP
                        </a>
                    </div>
                </c:if>

                <!-- Step 3: Password Reset -->
                <c:if test="${showPasswordForm}">
                    <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="passwordForm">
                        <input type="hidden" name="action" value="resetPassword">
                        <input type="hidden" name="email" value="${email}">

                        <div class="text-center mb-3">
                            <p>Tạo mật khẩu mới cho:</p>
                            <strong>${email}</strong>
                        </div>

                        <div class="form-group position-relative">
                            <input type="password" class="form-control" name="newPassword" 
                                   placeholder="Mật khẩu mới" required minlength="6" id="newPassword">
                            <i class="fas fa-lock input-icon"></i>
                        </div>

                        <div class="form-group position-relative">
                            <input type="password" class="form-control" name="confirmPassword" 
                                   placeholder="Xác nhận mật khẩu" required minlength="6" id="confirmPassword">
                            <i class="fas fa-lock input-icon"></i>
                        </div>

                        <div class="password-requirements">
                            <div class="requirement invalid" id="lengthReq">
                                <i class="fas fa-times"></i>
                                Ít nhất 6 ký tự
                            </div>
                            <div class="requirement invalid" id="matchReq">
                                <i class="fas fa-times"></i>
                                Mật khẩu xác nhận khớp
                            </div>
                        </div>

                        <button type="submit" class="btn-primary" id="resetPasswordBtn" disabled>
                            <div class="loading-spinner" id="resetPasswordSpinner"></div>
                            <i class="fas fa-key" id="resetPasswordIcon"></i> 
                            <span id="resetPasswordText">Đặt Lại Mật Khẩu</span>
                        </button>
                    </form>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                               // OTP Input Formatting
                               const otpInput = document.querySelector('input[name="otp"]');
                               if (otpInput) {
                                   otpInput.addEventListener('input', function (e) {
                                       // Only allow numbers
                                       this.value = this.value.replace(/[^0-9]/g, '');
                                   });

                                   // Auto-submit when 6 digits entered
                                   otpInput.addEventListener('input', function (e) {
                                       if (this.value.length === 6) {
                                           // Small delay to allow user to see the complete OTP
                                           setTimeout(() => {
                                               document.getElementById('otpForm').submit();
                                           }, 500);
                                       }
                                   });
                               }

                               // Countdown Timer
                               let countdownTimer;
                               function startCountdown(seconds = 60) {
                                   const timerElement = document.getElementById('timer');
                                   const countdownElement = document.getElementById('countdown');
                                   const resendLink = document.getElementById('resendLink');

                                   if (!timerElement)
                                       return;

                                   let timeLeft = seconds;

                                   countdownTimer = setInterval(() => {
                                       timeLeft--;
                                       timerElement.textContent = timeLeft;

                                       if (timeLeft <= 0) {
                                           clearInterval(countdownTimer);
                                           countdownElement.style.display = 'none';
                                           resendLink.style.display = 'inline';
                                       }
                                   }, 1000);
                               }

                               // Start countdown if on OTP page
                               if (document.getElementById('countdown')) {
                                   startCountdown(60);
                               }

                               // Resend OTP
                               function resendOTP(email) {
                                   // Show loading state
                                   const resendLink = document.getElementById('resendLink');
                                   const originalText = resendLink.innerHTML;
                                   resendLink.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
                                   resendLink.style.pointerEvents = 'none';

                                   const form = document.createElement('form');
                                   form.method = 'POST';
                                   form.action = '${pageContext.request.contextPath}/forgot-password';

                                   const actionInput = document.createElement('input');
                                   actionInput.type = 'hidden';
                                   actionInput.name = 'action';
                                   actionInput.value = 'sendOTP';

                                   const emailInput = document.createElement('input');
                                   emailInput.type = 'hidden';
                                   emailInput.name = 'email';
                                   emailInput.value = email;

                                   form.appendChild(actionInput);
                                   form.appendChild(emailInput);
                                   document.body.appendChild(form);
                                   form.submit();
                               }

                               // Password validation
                               const newPasswordInput = document.getElementById('newPassword');
                               const confirmPasswordInput = document.getElementById('confirmPassword');
                               const resetButton = document.getElementById('resetPasswordBtn');

                               if (newPasswordInput && confirmPasswordInput) {
                                   function validatePasswords() {
                                       const newPassword = newPasswordInput.value;
                                       const confirmPassword = confirmPasswordInput.value;

                                       // Length requirement
                                       const lengthReq = document.getElementById('lengthReq');
                                       if (newPassword.length >= 6) {
                                           lengthReq.classList.add('valid');
                                           lengthReq.classList.remove('invalid');
                                           lengthReq.querySelector('i').className = 'fas fa-check';
                                       } else {
                                           lengthReq.classList.add('invalid');
                                           lengthReq.classList.remove('valid');
                                           lengthReq.querySelector('i').className = 'fas fa-times';
                                       }

                                       // Match requirement
                                       const matchReq = document.getElementById('matchReq');
                                       if (confirmPassword && newPassword === confirmPassword) {
                                           matchReq.classList.add('valid');
                                           matchReq.classList.remove('invalid');
                                           matchReq.querySelector('i').className = 'fas fa-check';
                                       } else {
                                           matchReq.classList.add('invalid');
                                           matchReq.classList.remove('valid');
                                           matchReq.querySelector('i').className = 'fas fa-times';
                                       }

                                       // Enable/disable submit button
                                       resetButton.disabled = !(newPassword.length >= 6 && confirmPassword && newPassword === confirmPassword);
                                   }

                                   newPasswordInput.addEventListener('input', validatePasswords);
                                   confirmPasswordInput.addEventListener('input', validatePasswords);
                               }

                               // Form submission loading states
                               document.addEventListener('DOMContentLoaded', function () {
                                   const forms = document.querySelectorAll('form');
                                   forms.forEach(form => {
                                       form.addEventListener('submit', function (e) {
                                           const submitBtn = form.querySelector('button[type="submit"]');
                                           if (submitBtn && !submitBtn.disabled) {
                                               // Show loading state
                                               const spinner = submitBtn.querySelector('.loading-spinner');
                                               const icon = submitBtn.querySelector('i:not(.loading-spinner i)');
                                               const text = submitBtn.querySelector('span');

                                               if (spinner)
                                                   spinner.style.display = 'inline-block';
                                               if (icon)
                                                   icon.style.display = 'none';
                                               if (text) {
                                                   const originalText = text.textContent;
                                                   text.textContent = 'Đang xử lý...';
                                               }

                                               submitBtn.disabled = true;
                                               submitBtn.style.opacity = '0.7';
                                           }
                                       });
                                   });
                               });

                               // Email input validation
                               const emailInput = document.querySelector('input[name="email"]');
                               if (emailInput) {
                                   emailInput.addEventListener('input', function () {
                                       // Remove error styling when user starts typing
                                       this.classList.remove('is-invalid');
                                   });
                               }

                               // Focus management
                               document.addEventListener('DOMContentLoaded', function () {
                                   // Auto-focus first input
                                   const firstInput = document.querySelector('input:not([type="hidden"])');
                                   if (firstInput) {
                                       firstInput.focus();
                                   }
                               });

                               // Handle browser back button
                               window.addEventListener('pageshow', function (event) {
                                   if (event.persisted) {
                                       // Reset form states if page is loaded from cache
                                       const forms = document.querySelectorAll('form');
                                       forms.forEach(form => {
                                           const submitBtn = form.querySelector('button[type="submit"]');
                                           if (submitBtn) {
                                               submitBtn.disabled = false;
                                               submitBtn.style.opacity = '1';

                                               const spinner = submitBtn.querySelector('.loading-spinner');
                                               if (spinner)
                                                   spinner.style.display = 'none';
                                           }
                                       });
                                   }
                               });

                               // Prevent multiple form submissions
                               let formSubmitted = false;
                               document.addEventListener('submit', function (e) {
                                   if (formSubmitted) {
                                       e.preventDefault();
                                       return false;
                                   }
                                   formSubmitted = true;

                                   // Reset flag after 3 seconds to allow re-submission if needed
                                   setTimeout(() => {
                                       formSubmitted = false;
                                   }, 3000);
                               });
        </script>
    </body>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu | Traveler System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
        
        .forgot-password-card {
            width: 450px;
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            backdrop-filter: blur(15px);
            position: relative;
            z-index: 10;
            margin: 0 auto;
        }
        
        .forgot-password-card::before {
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
        
        .btn-primary {
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
        
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102,126,234,0.3);
        }
        
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
        
        .otp-input {
            text-align: center;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 0.5rem;
            padding: 15px 10px;
        }
        
        .resend-otp {
            text-align: center;
            margin-top: 1rem;
        }
        
        .resend-link {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .resend-link:hover {
            text-decoration: underline;
        }
        
        .countdown {
            color: #6b7280;
            font-size: 14px;
            margin-top: 0.5rem;
        }
        
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
            gap: 1rem;
        }
        
        .step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
            color: white;
            background: #d1d5db;
        }
        
        .step.active {
            background: #667eea;
        }
        
        .step.completed {
            background: #10b981;
        }
        
        .password-requirements {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px;
            margin-top: 1rem;
            font-size: 14px;
        }
        
        .requirement {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }
        
        .requirement i {
            font-size: 12px;
        }
        
        .requirement.valid {
            color: #065f46;
        }
        
        .requirement.invalid {
            color: #991b1b;
        }
        
        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid #ffffff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @media (max-width: 576px) {
            .forgot-password-card {
                width: 95%;
                padding: 2rem 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="forgot-password-card">
            <a href="${pageContext.request.contextPath}/login" class="back-link">
                <i class="fas fa-arrow-left"></i> Về đăng nhập
            </a>
            
            <div class="brand">
                <h2><i class="fas fa-key"></i>Quên Mật Khẩu</h2>
                <p class="text-muted mb-0">Đặt lại mật khẩu của bạn</p>
            </div>
            
            <!-- Step Indicator -->
            <div class="step-indicator">
                <div class="step ${showOtpForm || showPasswordForm ? 'completed' : 'active'}">1</div>
                <div class="step ${showPasswordForm ? 'completed' : (showOtpForm ? 'active' : '')}">2</div>
                <div class="step ${showPasswordForm ? 'active' : ''}">3</div>
            </div>
            
            <!-- Error/Success Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>
            
            <!-- Step 1: Email Input -->
            <c:if test="${!showOtpForm && !showPasswordForm}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="emailForm">
                    <input type="hidden" name="action" value="sendOTP">
                    
                    <div class="form-group position-relative">
                        <input type="email" class="form-control" name="email" 
                               placeholder="Nhập email của bạn" required
                               value="${email}">
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="sendOtpBtn">
                        <div class="loading-spinner" id="sendOtpSpinner"></div>
                        <i class="fas fa-paper-plane" id="sendOtpIcon"></i> 
                        <span id="sendOtpText">Gửi Mã OTP</span>
                    </button>
                </form>
                
                <div class="text-center mt-3">
                    <small class="text-muted">
                        Chúng tôi sẽ gửi mã xác thực 6 số đến email của bạn
                    </small>
                </div>
            </c:if>
            
            <!-- Step 2: OTP Verification -->
            <c:if test="${showOtpForm && !showPasswordForm}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="otpForm">
                    <input type="hidden" name="action" value="verifyOTP">
                    <input type="hidden" name="email" value="${email}">
                    
                    <div class="text-center mb-3">
                        <p>Nhập mã OTP được gửi đến:</p>
                        <strong>${email}</strong>
                    </div>
                    
                    <div class="form-group position-relative">
                        <input type="text" class="form-control otp-input" name="otp" 
                               placeholder="000000" maxlength="6" required
                               pattern="[0-9]{6}" inputmode="numeric">
                        <i class="fas fa-shield-alt input-icon"></i>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="verifyOtpBtn">
                        <div class="loading-spinner" id="verifyOtpSpinner"></div>
                        <i class="fas fa-check" id="verifyOtpIcon"></i> 
                        <span id="verifyOtpText">Xác Thực OTP</span>
                    </button>
                </form>
                
                <div class="resend-otp">
                    <div class="countdown" id="countdown">
                        Gửi lại mã sau: <span id="timer">60</span>s
                    </div>
                    <a href="#" class="resend-link" id="resendLink" style="display: none;" 
                       onclick="resendOTP('${email}')">
                        <i class="fas fa-redo"></i> Gửi lại mã OTP
                    </a>
                </div>
            </c:if>
            
            <!-- Step 3: Password Reset -->
            <c:if test="${showPasswordForm}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="passwordForm">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="email" value="${email}">
                    
                    <div class="text-center mb-3">
                        <p>Tạo mật khẩu mới cho:</p>
                        <strong>${email}</strong>
                    </div>
                    
                    <div class="form-group position-relative">
                        <input type="password" class="form-control" name="newPassword" 
                               placeholder="Mật khẩu mới" required minlength="6" id="newPassword">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    
                    <div class="form-group position-relative">
                        <input type="password" class="form-control" name="confirmPassword" 
                               placeholder="Xác nhận mật khẩu" required minlength="6" id="confirmPassword">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    
                    <div class="password-requirements">
                        <div class="requirement invalid" id="lengthReq">
                            <i class="fas fa-times"></i>
                            Ít nhất 6 ký tự
                        </div>
                        <div class="requirement invalid" id="matchReq">
                            <i class="fas fa-times"></i>
                            Mật khẩu xác nhận khớp
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="resetPasswordBtn" disabled>
                        <div class="loading-spinner" id="resetPasswordSpinner"></div>
                        <i class="fas fa-key" id="resetPasswordIcon"></i> 
                        <span id="resetPasswordText">Đặt Lại Mật Khẩu</span>
                    </button>
                </form>
            </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // OTP Input Formatting
        const otpInput = document.querySelector('input[name="otp"]');
        if (otpInput) {
            otpInput.addEventListener('input', function(e) {
                // Only allow numbers
                this.value = this.value.replace(/[^0-9]/g, '');
            });
            
            // Auto-submit when 6 digits entered
            otpInput.addEventListener('input', function(e) {
                if (this.value.length === 6) {
                    // Small delay to allow user to see the complete OTP
                    setTimeout(() => {
                        document.getElementById('otpForm').submit();
                    }, 500);
                }
            });
        }
        
        // Countdown Timer
        let countdownTimer;
        function startCountdown(seconds = 60) {
            const timerElement = document.getElementById('timer');
            const countdownElement = document.getElementById('countdown');
            const resendLink = document.getElementById('resendLink');
            
            if (!timerElement) return;
            
            let timeLeft = seconds;
            
            countdownTimer = setInterval(() => {
                timeLeft--;
                timerElement.textContent = timeLeft;
                
                if (timeLeft <= 0) {
                    clearInterval(countdownTimer);
                    countdownElement.style.display = 'none';
                    resendLink.style.display = 'inline';
                }
            }, 1000);
        }
        
        // Start countdown if on OTP page
        if (document.getElementById('countdown')) {
            startCountdown(60);
        }
        
        // Resend OTP
        function resendOTP(email) {
            // Show loading state
            const resendLink = document.getElementById('resendLink');
            const originalText = resendLink.innerHTML;
            resendLink.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
            resendLink.style.pointerEvents = 'none';
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/forgot-password';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'sendOTP';
            
            const emailInput = document.createElement('input');
            emailInput.type = 'hidden';
            emailInput.name = 'email';
            emailInput.value = email;
            
            form.appendChild(actionInput);
            form.appendChild(emailInput);
            document.body.appendChild(form);
            form.submit();
        }
        
        // Password validation
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const resetButton = document.getElementById('resetPasswordBtn');
        
        if (newPasswordInput && confirmPasswordInput) {
            function validatePasswords() {
                const newPassword = newPasswordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                // Length requirement
                const lengthReq = document.getElementById('lengthReq');
                if (newPassword.length >= 6) {
                    lengthReq.classList.add('valid');
                    lengthReq.classList.remove('invalid');
                    lengthReq.querySelector('i').className = 'fas fa-check';
                } else {
                    lengthReq.classList.add('invalid');
                    lengthReq.classList.remove('valid');
                    lengthReq.querySelector('i').className = 'fas fa-times';
                }
                
                // Match requirement
                const matchReq = document.getElementById('matchReq');
                if (confirmPassword && newPassword === confirmPassword) {
                    matchReq.classList.add('valid');
                    matchReq.classList.remove('invalid');
                    matchReq.querySelector('i').className = 'fas fa-check';
                } else {
                    matchReq.classList.add('invalid');
                    matchReq.classList.remove('valid');
                    matchReq.querySelector('i').className = 'fas fa-times';
                }
                
                // Enable/disable submit button
                resetButton.disabled = !(newPassword.length >= 6 && confirmPassword && newPassword === confirmPassword);
            }
            
            newPasswordInput.addEventListener('input', validatePasswords);
            confirmPasswordInput.addEventListener('input', validatePasswords);
        }
        
        // Form submission loading states
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn && !submitBtn.disabled) {
                        // Show loading state
                        const spinner = submitBtn.querySelector('.loading-spinner');
                        const icon = submitBtn.querySelector('i:not(.loading-spinner i)');
                        const text = submitBtn.querySelector('span');
                        
                        if (spinner) spinner.style.display = 'inline-block';
                        if (icon) icon.style.display = 'none';
                        if (text) {
                            const originalText = text.textContent;
                            text.textContent = 'Đang xử lý...';
                        }
                        
                        submitBtn.disabled = true;
                        submitBtn.style.opacity = '0.7';
                    }
                });
            });
        });
        
        // Email input validation
        const emailInput = document.querySelector('input[name="email"]');
        if (emailInput) {
            emailInput.addEventListener('input', function() {
                // Remove error styling when user starts typing
                this.classList.remove('is-invalid');
            });
        }
        
        // Focus management
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-focus first input
            const firstInput = document.querySelector('input:not([type="hidden"])');
            if (firstInput) {
                firstInput.focus();
            }
        });
        
        // Handle browser back button
        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                // Reset form states if page is loaded from cache
                const forms = document.querySelectorAll('form');
                forms.forEach(form => {
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.style.opacity = '1';
                        
                        const spinner = submitBtn.querySelector('.loading-spinner');
                        if (spinner) spinner.style.display = 'none';
                    }
                });
            }
        });
        
        // Prevent multiple form submissions
        let formSubmitted = false;
        document.addEventListener('submit', function(e) {
            if (formSubmitted) {
                e.preventDefault();
                return false;
            }
            formSubmitted = true;
            
            // Reset flag after 3 seconds to allow re-submission if needed
            setTimeout(() => {
                formSubmitted = false;
            }, 3000);
        });
    </script>
</body>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</html>
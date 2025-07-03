<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác thực OTP - VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #83C5BE 0%, #10466C 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .otp-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                overflow: hidden;
                max-width: 500px;
                width: 100%;
                margin: 20px;
            }
            .otp-header {
                background: linear-gradient(135deg, #10466C, #83C5BE);
                color: white;
                padding: 30px;
                text-align: center;
            }
            .otp-header h1 {
                margin: 0;
                font-size: 1.8rem;
                font-weight: 600;
            }
            .otp-body {
                padding: 40px 30px;
            }
            .user-info {
                text-align: center;
                margin-bottom: 30px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
            }
            .user-email {
                color: #10466C;
                font-weight: 600;
                font-size: 1.1rem;
            }
            .otp-input-group {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin: 30px 0;
            }
            .otp-input {
                width: 50px;
                height: 60px;
                text-align: center;
                font-size: 24px;
                font-weight: bold;
                border: 2px solid #ddd;
                border-radius: 10px;
                transition: all 0.3s;
            }
            .otp-input:focus {
                border-color: #10466C;
                box-shadow: 0 0 0 0.2rem rgba(16, 70, 108, 0.25);
                outline: none;
            }
            .btn-verify {
                background: linear-gradient(135deg, #10466C, #83C5BE);
                border: none;
                color: white;
                padding: 15px 40px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 50px;
                width: 100%;
                transition: all 0.3s;
            }
            .btn-verify:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                color: white;
            }
            .btn-verify:disabled {
                opacity: 0.6;
                transform: none;
                cursor: not-allowed;
            }
            .timer-display {
                text-align: center;
                font-size: 1.2rem;
                font-weight: 600;
                margin: 20px 0;
            }
            .timer-active {
                color: #28a745;
            }
            .timer-warning {
                color: #ffc107;
            }
            .timer-expired {
                color: #dc3545;
            }
            .resend-section {
                text-align: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }
            .btn-resend {
                background: transparent;
                border: 2px solid #10466C;
                color: #10466C;
                padding: 10px 25px;
                border-radius: 25px;
                transition: all 0.3s;
            }
            .btn-resend:hover {
                background: #10466C;
                color: white;
            }
            .btn-resend:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }
            .attempts-info {
                background: #fff3cd;
                border-left: 4px solid #ffc107;
                padding: 15px;
                margin: 20px 0;
                border-radius: 5px;
            }
            .error-info {
                background: #f8d7da;
                border-left: 4px solid #dc3545;
                color: #721c24;
                padding: 15px;
                margin: 20px 0;
                border-radius: 5px;
            }
            .success-info {
                background: #d1e7dd;
                border-left: 4px solid #28a745;
                color: #0f5132;
                padding: 15px;
                margin: 20px 0;
                border-radius: 5px;
            }
            .back-link {
                text-align: center;
                margin-top: 20px;
            }
            .back-link a {
                color: #6c757d;
                text-decoration: none;
            }
            .back-link a:hover {
                color: #10466C;
            }
        </style>
    </head>
    <body>
        <div class="otp-container">
            <div class="otp-header">
                <h1><i class="fas fa-shield-alt"></i> Xác Thực OTP</h1>
                <p>Vui lòng nhập mã xác thực đã gửi về email</p>
            </div>

            <div class="otp-body">
                <!-- User Info -->
                <div class="user-info">
                    <div><i class="fas fa-user"></i> <strong>${userName}</strong></div>
                    <div class="user-email"><i class="fas fa-envelope"></i> ${userEmail}</div>
                </div>

                <!-- Success Message -->
                <c:if test="${param.resent == 'true'}">
                    <div class="success-info">
                        <i class="fas fa-check-circle"></i> Mã OTP mới đã được gửi thành công!
                    </div>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="error-info">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>

                <!-- OTP Form -->
                <form method="post" action="${pageContext.request.contextPath}/verify-otp" id="otpForm">
                    <div class="text-center mb-3">
                        <strong>Nhập mã OTP (6 chữ số):</strong>
                    </div>

                    <!-- OTP Input Fields -->
                    <div class="otp-input-group">
                        <input type="text" class="otp-input" maxlength="1" id="otp1" />
                        <input type="text" class="otp-input" maxlength="1" id="otp2" />
                        <input type="text" class="otp-input" maxlength="1" id="otp3" />
                        <input type="text" class="otp-input" maxlength="1" id="otp4" />
                        <input type="text" class="otp-input" maxlength="1" id="otp5" />
                        <input type="text" class="otp-input" maxlength="1" id="otp6" />
                    </div>

                    <!-- Hidden input for combined OTP -->
                    <input type="hidden" name="otpCode" id="otpCode" />

                    <!-- Timer Display -->
                    <c:if test="${not empty remainingTime and remainingTime > 0}">
                        <div class="timer-display timer-active" id="timerDisplay">
                            <i class="fas fa-clock"></i> Mã sẽ hết hạn sau: <span id="countdown">${remainingTime}</span> giây
                        </div>
                    </c:if>

                    <c:if test="${otpExpired}">
                        <div class="timer-display timer-expired">
                            <i class="fas fa-times-circle"></i> Mã OTP đã hết hạn
                        </div>
                    </c:if>

                    <!-- Attempts Info -->
                    <c:if test="${otpAttempts > 0}">
                        <div class="attempts-info">
                            <i class="fas fa-info-circle"></i> 
                            Bạn đã thử ${otpAttempts}/${maxOtpAttempts} lần. 
                            <c:if test="${otpAttempts < maxOtpAttempts}">
                                Còn ${maxOtpAttempts - otpAttempts} lần thử.
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-verify" id="verifyBtn">
                        <i class="fas fa-check"></i> Xác Thực
                    </button>
                </form>

                <!-- Resend Section -->
                <div class="resend-section">
                    <p>Không nhận được mã?</p>

                    <c:choose>
                        <c:when test="${resendAttempts >= maxResendAttempts}">
                            <div class="error-info">
                                <i class="fas fa-ban"></i> 
                                Bạn đã yêu cầu gửi lại quá nhiều lần. Vui lòng đăng ký lại.
                            </div>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-resend">
                                <i class="fas fa-redo"></i> Đăng Ký Lại
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-resend" id="resendBtn" 
                                    onclick="resendOTP()" ${otpExpired ? '' : 'disabled'}>
                                <i class="fas fa-paper-plane"></i> 
                                Gửi Lại Mã (<span id="resendCount">${maxResendAttempts - resendAttempts}</span> lần còn lại)
                            </button>

                            <div id="resendCooldown" style="display: none;" class="mt-2">
                                <small class="text-muted">
                                    <i class="fas fa-hourglass-half"></i> 
                                    Vui lòng đợi <span id="cooldownTimer">30</span> giây
                                </small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Back Link -->
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng ký
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        // OTP Input Handling
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const otpInputs = document.querySelectorAll('.otp-input');
                                            const otpCodeInput = document.getElementById('otpCode');
                                            const verifyBtn = document.getElementById('verifyBtn');
                                            const resendBtn = document.getElementById('resendBtn');

                                            // Focus first input
                                            otpInputs[0].focus();

                                            // Handle OTP input
                                            otpInputs.forEach((input, index) => {
                                                input.addEventListener('input', function (e) {
                                                    // Only allow digits
                                                    this.value = this.value.replace(/[^0-9]/g, '');

                                                    // Move to next input if digit entered
                                                    if (this.value.length === 1 && index < otpInputs.length - 1) {
                                                        otpInputs[index + 1].focus();
                                                    }

                                                    // Update combined OTP code
                                                    updateOTPCode();
                                                });

                                                input.addEventListener('keydown', function (e) {
                                                    // Handle backspace
                                                    if (e.key === 'Backspace' && this.value === '' && index > 0) {
                                                        otpInputs[index - 1].focus();
                                                    }

                                                    // Handle paste
                                                    if (e.key === 'v' && (e.ctrlKey || e.metaKey)) {
                                                        setTimeout(() => handlePaste(), 10);
                                                    }
                                                });

                                                input.addEventListener('focus', function () {
                                                    this.select();
                                                });
                                            });

                                            // Handle paste operation
                                            function handlePaste() {
                                                navigator.clipboard.readText().then(text => {
                                                    const digits = text.replace(/[^0-9]/g, '');
                                                    if (digits.length === 6) {
                                                        for (let i = 0; i < 6; i++) {
                                                            otpInputs[i].value = digits[i];
                                                        }
                                                        updateOTPCode();
                                                        otpInputs[5].focus();
                                                    }
                                                }).catch(err => {
                                                    console.log('Paste failed:', err);
                                                });
                                            }

                                            // Update combined OTP code
                                            function updateOTPCode() {
                                                let combinedOTP = '';
                                                otpInputs.forEach(input => {
                                                    combinedOTP += input.value;
                                                });
                                                otpCodeInput.value = combinedOTP;

                                                // Enable/disable verify button
                                                verifyBtn.disabled = combinedOTP.length !== 6;
                                            }

                                            // Form submission
                                            document.getElementById('otpForm').addEventListener('submit', function (e) {
                                                if (otpCodeInput.value.length !== 6) {
                                                    e.preventDefault();
                                                    alert('Vui lòng nhập đầy đủ 6 chữ số OTP');
                                                    return;
                                                }

                                                // Disable button to prevent double submission
                                                verifyBtn.disabled = true;
                                                verifyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xác thực...';
                                            });
                                        });

                                        // Countdown Timer
            <c:if test="${not empty remainingTime and remainingTime > 0}">
                                        let remainingTime = ${remainingTime};
                                        const countdownElement = document.getElementById('countdown');
                                        const timerDisplay = document.getElementById('timerDisplay');
                                        const resendBtn = document.getElementById('resendBtn');

                                        const timerInterval = setInterval(function () {
                                            remainingTime--;

                                            if (remainingTime > 0) {
                                                countdownElement.textContent = remainingTime;

                                                // Change color based on remaining time
                                                if (remainingTime <= 30) {
                                                    timerDisplay.className = 'timer-display timer-warning';
                                                }
                                                if (remainingTime <= 10) {
                                                    timerDisplay.className = 'timer-display timer-expired';
                                                }
                                            } else {
                                                clearInterval(timerInterval);
                                                timerDisplay.innerHTML = '<i class="fas fa-times-circle"></i> Mã OTP đã hết hạn';
                                                timerDisplay.className = 'timer-display timer-expired';

                                                // Enable resend button
                                                if (resendBtn) {
                                                    resendBtn.disabled = false;
                                                }

                                                // Show expiry alert
                                                showExpiryAlert();
                                            }
                                        }, 1000);
            </c:if>

                                        // Resend OTP function
                                        let resendCooldown = 0;

                                        function resendOTP() {
                                            if (resendCooldown > 0) {
                                                alert('Vui lòng đợi ' + resendCooldown + ' giây trước khi gửi lại');
                                                return;
                                            }

                                            const resendBtn = document.getElementById('resendBtn');
                                            const resendCooldownDiv = document.getElementById('resendCooldown');
                                            const cooldownTimer = document.getElementById('cooldownTimer');

                                            // Disable resend button
                                            resendBtn.disabled = true;
                                            resendBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

                                            // Redirect to resend endpoint
                                            window.location.href = '${pageContext.request.contextPath}/resend-otp';
                                        }

                                        // Show expiry alert
                                        function showExpiryAlert() {
                                            const alertHtml = `
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Mã OTP đã hết hạn!</strong> 
                        Vui lòng yêu cầu gửi lại mã mới để tiếp tục.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;

                                            const otpBody = document.querySelector('.otp-body');
                                            otpBody.insertAdjacentHTML('afterbegin', alertHtml);
                                        }

                                        // Auto-focus and styling
                                        document.addEventListener('DOMContentLoaded', function () {
                                            // Add animation to container
                                            const container = document.querySelector('.otp-container');
                                            container.style.opacity = '0';
                                            container.style.transform = 'translateY(20px)';

                                            setTimeout(() => {
                                                container.style.transition = 'all 0.5s ease';
                                                container.style.opacity = '1';
                                                container.style.transform = 'translateY(0)';
                                            }, 100);

                                            // Add keyboard shortcuts
                                            document.addEventListener('keydown', function (e) {
                                                // Enter key to submit
                                                if (e.key === 'Enter' && document.getElementById('otpCode').value.length === 6) {
                                                    document.getElementById('otpForm').submit();
                                                }

                                                // Escape key to go back
                                                if (e.key === 'Escape') {
                                                    if (confirm('Bạn có muốn quay lại trang đăng ký?')) {
                                                        window.location.href = '${pageContext.request.contextPath}/register';
                                                    }
                                                }
                                            });
                                        });

                                        // Error handling
            <c:if test="${not empty error}">
                                        document.addEventListener('DOMContentLoaded', function () {
                                            // Clear OTP inputs on error
                                            const otpInputs = document.querySelectorAll('.otp-input');
                                            otpInputs.forEach(input => {
                                                input.value = '';
                                                input.style.borderColor = '#dc3545';
                                            });

                                            // Focus first input
                                            setTimeout(() => {
                                                otpInputs[0].focus();
                                                // Reset border colors
                                                otpInputs.forEach(input => {
                                                    input.style.borderColor = '#ddd';
                                                });
                                            }, 2000);
                                        });
            </c:if>

                                        // Copy OTP from clipboard detection
                                        document.addEventListener('DOMContentLoaded', function () {
                                            let clipboardOTP = '';

                                            // Check clipboard periodically for OTP
                                            setInterval(async function () {
                                                try {
                                                    const text = await navigator.clipboard.readText();
                                                    const otpMatch = text.match(/\b\d{6}\b/);

                                                    if (otpMatch && otpMatch[0] !== clipboardOTP) {
                                                        clipboardOTP = otpMatch[0];
                                                        showOTPSuggestion(clipboardOTP);
                                                    }
                                                } catch (err) {
                                                    // Clipboard access denied or not supported
                                                }
                                            }, 1000);
                                        });

                                        function showOTPSuggestion(otp) {
                                            const suggestion = document.createElement('div');
                                            suggestion.className = 'alert alert-info alert-dismissible fade show';
                                            suggestion.innerHTML = `
                    <i class="fas fa-clipboard"></i>
                    <strong>Phát hiện mã OTP:</strong> ${otp}
                    <button type="button" class="btn btn-sm btn-outline-primary ms-2" onclick="fillOTP('${otp}')">
                        Điền tự động
                    </button>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;

                                            document.querySelector('.otp-body').insertAdjacentElement('afterbegin', suggestion);

                                            // Auto-dismiss after 10 seconds
                                            setTimeout(() => {
                                                if (suggestion.parentNode) {
                                                    suggestion.remove();
                                                }
                                            }, 10000);
                                        }

                                        function fillOTP(otp) {
                                            const otpInputs = document.querySelectorAll('.otp-input');
                                            for (let i = 0; i < 6; i++) {
                                                otpInputs[i].value = otp[i];
                                            }

                                            // Update combined OTP
                                            document.getElementById('otpCode').value = otp;
                                            document.getElementById('verifyBtn').disabled = false;

                                            // Remove suggestion
                                            document.querySelector('.alert-info').remove();

                                            // Focus last input
                                            otpInputs[5].focus();
                                        }
        </script>
    </body>
</html>
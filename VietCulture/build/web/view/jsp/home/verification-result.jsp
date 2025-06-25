<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác thực Email - VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #83C5BE 0%, #10466C 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .verification-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                overflow: hidden;
                max-width: 600px;
                width: 100%;
                text-align: center;
                padding: 60px 40px;
            }
            .icon-container {
                margin-bottom: 30px;
            }
            .icon-success {
                color: #28a745;
                font-size: 5rem;
                animation: checkmark 0.5s ease-in-out;
            }
            .icon-error {
                color: #dc3545;
                font-size: 5rem;
                animation: shake 0.5s ease-in-out;
            }
            @keyframes checkmark {
                0% {
                    transform: scale(0);
                }
                50% {
                    transform: scale(1.2);
                }
                100% {
                    transform: scale(1);
                }
            }
            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-10px);
                }
                75% {
                    transform: translateX(10px);
                }
            }
            h2 {
                color: #333;
                margin-bottom: 20px;
                font-weight: bold;
            }
            .message {
                color: #666;
                font-size: 1.1rem;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            .btn-custom {
                background: linear-gradient(135deg, #10466C, #83C5BE);
                border: none;
                color: white;
                padding: 15px 40px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 50px;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
                margin: 10px;
            }
            .btn-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                color: white;
            }
            .btn-secondary-custom {
                background: #6c757d;
            }
            .welcome-note {
                background: #f8f9fa;
                border-radius: 15px;
                padding: 25px;
                margin-top: 30px;
            }
            .welcome-note h5 {
                color: #10466C;
                margin-bottom: 15px;
            }
            .welcome-note ul {
                text-align: left;
                margin: 0;
                padding-left: 20px;
            }
            .welcome-note li {
                margin-bottom: 10px;
                color: #666;
            }
        </style>
    </head>
    <body>
        <div class="verification-container">
            <c:choose>
                <c:when test="${success == true}">
                    <!-- Success Case -->
                    <div class="icon-container">
                        <i class="fas fa-check-circle icon-success"></i>
                    </div>
                    <h2>Xác Thực Thành Công!</h2>
                    <p class="message">
                        Chào mừng <strong>${userName}</strong>!<br>
                        Tài khoản của bạn đã được kích hoạt thành công.
                    </p>

                    <div class="welcome-note">
                        <h5><i class="fas fa-star"></i> Bạn đã sẵn sàng để:</h5>
                        <ul>
                            <li><i class="fas fa-search"></i> Khám phá hàng nghìn trải nghiệm độc đáo</li>
                            <li><i class="fas fa-calendar-check"></i> Đặt tour và chỗ ở dễ dàng</li>
                            <li><i class="fas fa-comments"></i> Kết nối với cộng đồng du lịch</li>
                            <li><i class="fas fa-star"></i> Chia sẻ đánh giá và kinh nghiệm</li>
                        </ul>
                    </div>

                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-custom">
                            <i class="fas fa-sign-in-alt"></i> Đăng Nhập Ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-custom btn-secondary-custom">
                            <i class="fas fa-home"></i> Về Trang Chủ
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- Error Case -->
                    <div class="icon-container">
                        <i class="fas fa-times-circle icon-error"></i>
                    </div>
                    <h2>Xác Thực Không Thành Công</h2>
                    <p class="message">
                        <c:choose>
                            <c:when test="${not empty error}">
                                ${error}
                            </c:when>
                            <c:otherwise>
                                Có lỗi xảy ra trong quá trình xác thực email.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <c:if test="${not empty email}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> 
                            Bạn có thể yêu cầu gửi lại email xác thực cho địa chỉ <strong>${email}</strong>
                        </div>

                        <a href="${pageContext.request.contextPath}/resend-verification?email=${email}" 
                           class="btn btn-custom">
                            <i class="fas fa-paper-plane"></i> Gửi Lại Email Xác Thực
                        </a>
                    </c:if>

                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/register" 
                           class="btn btn-custom btn-secondary-custom">
                            <i class="fas fa-user-plus"></i> Đăng Ký Lại
                        </a>
                        <a href="${pageContext.request.contextPath}/" 
                           class="btn btn-custom btn-secondary-custom">
                            <i class="fas fa-home"></i> Về Trang Chủ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="mt-5">
                <p class="text-muted">
                    <i class="fas fa-question-circle"></i> Cần hỗ trợ? 
                    <a href="mailto:support@vietculture.com">Liên hệ với chúng tôi</a>
                </p>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
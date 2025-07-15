<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lỗi - VietCulture</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <style>
            .error-container {
                min-height: 80vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                position: relative;
                overflow: hidden;
            }

            .error-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('${pageContext.request.contextPath}/assets/images/vietnam-pattern.png') repeat;
                opacity: 0.1;
            }

            .error-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                padding: 3rem;
                text-align: center;
                max-width: 600px;
                width: 90%;
                position: relative;
                z-index: 1;
            }

            .error-icon {
                font-size: 5rem;
                color: #dc3545;
                margin-bottom: 1.5rem;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
                100% {
                    transform: scale(1);
                }
            }

            .error-title {
                color: #2c3e50;
                font-weight: 700;
                margin-bottom: 1rem;
                font-size: 2.5rem;
            }

            .error-message {
                color: #6c757d;
                font-size: 1.1rem;
                margin-bottom: 2rem;
                line-height: 1.6;
            }

            .error-details {
                background: #f8f9fa;
                border-left: 4px solid #dc3545;
                padding: 1rem;
                margin: 1.5rem 0;
                text-align: left;
                border-radius: 0 8px 8px 0;
            }

            .error-code {
                font-family: 'Courier New', monospace;
                font-weight: bold;
                color: #dc3545;
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea, #764ba2);
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
                margin: 0.5rem;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            .btn-secondary {
                background: #6c757d;
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
                margin: 0.5rem;
            }

            .btn-secondary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(108, 117, 125, 0.3);
            }

            .support-info {
                background: #e3f2fd;
                border: 1px solid #bbdefb;
                border-radius: 10px;
                padding: 1.5rem;
                margin-top: 2rem;
            }

            .support-title {
                color: #1976d2;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .navbar {
                background: rgba(255, 255, 255, 0.95) !important;
                backdrop-filter: blur(10px);
                box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            }

            .footer {
                background: #2c3e50;
                color: white;
                padding: 2rem 0;
                margin-top: auto;
            }

            .breadcrumb {
                background: transparent;
                padding: 1rem 0;
            }

            .breadcrumb-item a {
                color: #667eea;
                text-decoration: none;
            }

            .breadcrumb-item.active {
                color: #6c757d;
            }

            @media (max-width: 768px) {
                .error-card {
                    padding: 2rem;
                    margin: 1rem;
                }

                .error-title {
                    font-size: 2rem;
                }

                .error-icon {
                    font-size: 4rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header/Navigation -->
        <jsp:include page="/view/jsp/common/header.jsp" />

        <!-- Breadcrumb -->
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Lỗi hệ thống</li>
                </ol>
            </nav>
        </div>

        <!-- Error Content -->
        <div class="error-container">
            <div class="error-card">
                <!-- Error Icon -->
                <div class="error-icon">
                    <c:choose>
                        <c:when test="${pageContext.errorData.statusCode == 404}">
                            <i class="fas fa-search"></i>
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 403}">
                            <i class="fas fa-lock"></i>
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 500}">
                            <i class="fas fa-exclamation-triangle"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-exclamation-circle"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Error Title -->
                <h1 class="error-title">
                    <c:choose>
                        <c:when test="${pageContext.errorData.statusCode == 404}">
                            Không tìm thấy trang
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 403}">
                            Truy cập bị từ chối
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 500}">
                            Lỗi máy chủ
                        </c:when>
                        <c:otherwise>
                            Đã xảy ra lỗi
                        </c:otherwise>
                    </c:choose>
                </h1>

                <!-- Error Message -->
                <div class="error-message">
                    <c:choose>
                        <c:when test="${not empty errorMessage}">
                            ${errorMessage}
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 404}">
                            Trang bạn đang tìm kiếm không tồn tại hoặc đã được chuyển đi.
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 403}">
                            Bạn không có quyền truy cập vào trang này. Vui lòng đăng nhập hoặc liên hệ quản trị viên.
                        </c:when>
                        <c:when test="${pageContext.errorData.statusCode == 500}">
                            Máy chủ đang gặp sự cố kỹ thuật. Chúng tôi đang khắc phục và sẽ sớm hoạt động trở lại.
                        </c:when>
                        <c:otherwise>
                            Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Error Details (if available) -->
                <c:if test="${not empty pageContext.errorData.statusCode}">
                    <div class="error-details">
                        <div><strong>Mã lỗi:</strong> <span class="error-code">${pageContext.errorData.statusCode}</span></div>
                            <c:if test="${not empty pageContext.errorData.requestURI}">
                            <div><strong>URL:</strong> ${pageContext.errorData.requestURI}</div>
                        </c:if>
                        <div><strong>Thời gian:</strong> <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                        <i class="fas fa-home"></i> Về trang chủ
                    </a>
                    <button onclick="history.back()" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </button>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-primary">
                        <i class="fas fa-headset"></i> Liên hệ hỗ trợ
                    </a>
                </div>

                <!-- Support Information -->
                <div class="support-info">
                    <div class="support-title">
                        <i class="fas fa-info-circle"></i> Cần hỗ trợ?
                    </div>
                    <p class="mb-2">Nếu bạn tiếp tục gặp sự cố, vui lòng liên hệ với chúng tôi:</p>
                    <div class="row text-start">
                        <div class="col-md-6">
                            <small><i class="fas fa-phone"></i> <strong>Hotline:</strong> 1900-xxxx</small>
                        </div>
                        <div class="col-md-6">
                            <small><i class="fas fa-envelope"></i> <strong>Email:</strong> support@vietculture.com</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/view/jsp/common/footer.jsp" />

        <!-- JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                        // Auto refresh page after 30 seconds for 500 errors (server errors)
            <c:if test="${pageContext.errorData.statusCode == 500}">
                        setTimeout(function () {
                            if (confirm('Bạn có muốn thử tải lại trang?')) {
                                window.location.reload();
                            }
                        }, 30000);
            </c:if>

                        // Log error to console for debugging (in development mode)
                        console.error('Error Page Details:', {
                            statusCode: '${pageContext.errorData.statusCode}',
                            requestURI: '${pageContext.errorData.requestURI}',
                            errorMessage: '${errorMessage}',
                            timestamp: new Date().toISOString()
                        });

                        // Track error in analytics (if available)
                        if (typeof gtag !== 'undefined') {
                            gtag('event', 'exception', {
                                'description': 'Error ${pageContext.errorData.statusCode}: ${pageContext.errorData.requestURI}',
                                'fatal': false
                            });
                        }

                        // Add smooth animations
                        document.addEventListener('DOMContentLoaded', function () {
                            const errorCard = document.querySelector('.error-card');
                            if (errorCard) {
                                errorCard.style.opacity = '0';
                                errorCard.style.transform = 'translateY(30px)';

                                setTimeout(() => {
                                    errorCard.style.transition = 'all 0.6s ease';
                                    errorCard.style.opacity = '1';
                                    errorCard.style.transform = 'translateY(0)';
                                }, 100);
                            }
                        });
        </script>
    </body>
</html>
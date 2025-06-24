<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nâng Cấp Lên Host - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        .success-card {
            border-left: 4px solid #28a745;
            animation: fadeInUp 0.6s ease-out;
        }

        .success-icon {
            width: 40px;
            height: 40px;
            background: #28a745;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2em;
        }

        @keyframes fadeInUp {
            from {
                transform: translateY(30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .dropdown-item {
            color: #10466C;
        }

        .dropdown-item i {
            color: #10466C;
        }

        .navbar-brand img {
            height: 50px !important;
            width: auto !important;
            margin-right: 12px !important;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
            object-fit: contain !important;
            display: inline-block !important;
        }

        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: var(--dark-color);
            background-color: var(--accent-color);
            padding-top: 80px;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
        }

        .btn {
            border-radius: 30px;
            padding: 12px 24px;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn-primary {
            background: var(--gradient-primary);
            border: none;
            color: white;
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            background: transparent;
            transition: var(--transition);
        }

        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-3px);
        }

        /* Modern Navbar */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
            transition: var(--transition);
        }

        .custom-navbar.scrolled {
            padding: 10px 0;
            background-color: #10466C;
            box-shadow: var(--shadow-md);
        }

        .custom-navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.3rem;
            color: white;
            text-decoration: none;
        }

        .nav-center {
            display: flex;
            align-items: center;
            gap: 40px;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .nav-center-item {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }

        .nav-center-item:hover {
            color: white;
        }

        .nav-center-item.active {
            color: var(--primary-color);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }

        .nav-right a:hover {
            color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.08);
        }

        .nav-right .globe-icon {
            font-size: 20px;
            cursor: pointer;
            transition: var(--transition);
        }

        .nav-right .globe-icon:hover {
            color: var(--primary-color);
            transform: rotate(15deg);
        }

        .nav-right .menu-icon {
            border: 1px solid rgba(255,255,255,0.2);
            padding: 8px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            position: relative;
            background-color: rgba(255,255,255,0.1);
            color: white;
        }

        .nav-right .menu-icon:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .nav-right .menu-icon i {
            color: white;
        }

        .dropdown-menu-custom {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 250px;
            padding: 15px;
            display: none;
            z-index: 1000;
            margin-top: 10px;
            opacity: 0;
            transform: translateY(10px);
            transition: var(--transition);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .dropdown-menu-custom.show {
            display: block;
            opacity: 1;
            transform: translateY(0);
            color: #10466C;
        }

        .dropdown-menu-custom a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            text-decoration: none;
            color: #10466C;
            transition: var(--transition);
            border-radius: 10px;
            margin-bottom: 5px;
        }

        .dropdown-menu-custom a:hover {
            background-color: rgba(16, 70, 108, 0.05);
            color: #10466C;
            transform: translateX(3px);
        }

        .dropdown-menu-custom a i {
            margin-right: 12px;
            font-size: 18px;
            color: #10466C;
        }

        /* Hero Section */
        .upgrade-hero {
            background: linear-gradient(rgba(0,109,119,0.7), rgba(131,197,190,0.7)),
                url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80') no-repeat center/cover;
            color: var(--light-color);
            padding: 150px 0;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }

        .upgrade-hero::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to top, var(--accent-color), transparent);
        }

        .upgrade-hero h1 {
            font-size: 4rem;
            margin-bottom: 20px;
            font-weight: 800;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .upgrade-hero p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 30px;
            text-shadow: 0 1px 5px rgba(0,0,0,0.2);
        }

        /* Feature Icon */
        .feature-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient-primary);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            transition: var(--transition);
        }

        .feature-icon i {
            font-size: 2rem;
            color: white;
        }

        .feature-icon.error-icon {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff8e8e 100%);
        }

        /* Cards */
        .upgrade-card {
            background-color: var(--light-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            border: none;
        }

        .upgrade-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
        }

        /* Forms */
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 56, 92, 0.25);
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 56, 92, 0.25);
        }

        .required-field::after {
            content: " *";
            color: var(--primary-color);
        }

        /* Benefits Section */
        .benefits-section {
            padding: 80px 0;
            background-color: var(--light-color);
        }

        .benefit-item {
            text-align: center;
            padding: 30px 20px;
            border-radius: var(--border-radius);
            background-color: var(--accent-color);
            transition: var(--transition);
            height: 100%;
        }

        .benefit-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .benefit-item .feature-icon {
            width: 70px;
            height: 70px;
            background: var(--gradient-secondary);
        }

        /* Footer */
        .footer {
            background-color: var(--dark-color);
            color: var(--light-color);
            padding: 80px 0 40px;
            position: relative;
        }

        .footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to bottom, var(--accent-color), transparent);
            opacity: 0.1;
        }

        .footer h5 {
            font-size: 1.3rem;
            margin-bottom: 25px;
            position: relative;
            display: inline-block;
        }

        .footer h5::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 40px;
            height: 3px;
            background: var(--gradient-primary);
            border-radius: 3px;
        }

        .footer p {
            color: rgba(255,255,255,0.7);
            margin-bottom: 15px;
        }

        .footer a {
            color: var(--secondary-color);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
            margin-bottom: 10px;
        }

        .footer a:hover {
            color: var(--primary-color);
            transform: translateX(3px);
        }

        .footer .list-unstyled li {
            margin-bottom: 15px;
        }

        .footer .social-icons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .footer .social-icons a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 50%;
            transition: var(--transition);
        }

        .footer .social-icons a:hover {
            background-color: var(--primary-color);
            transform: translateY(-5px);
        }

        .footer .social-icons i {
            font-size: 1.2rem;
        }

        .footer .copyright {
            text-align: center;
            padding-top: 40px;
            margin-top: 40px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.5);
            font-size: 0.9rem;
        }

        /* Animations */
        .fade-up {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease-out;
        }

        .fade-up.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .upgrade-hero h1 {
                font-size: 3rem;
            }

            .nav-center {
                position: relative;
                left: 0;
                transform: none;
                margin-top: 20px;
                justify-content: center;
            }

            .custom-navbar .container {
                flex-direction: column;
            }
        }

        @media (max-width: 768px) {
            .upgrade-hero h1 {
                font-size: 2.5rem;
            }

            .custom-navbar {
                padding: 10px 0;
            }

            .nav-right {
                margin-top: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>

            <div class="nav-center">
                <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                    Trang Chủ
                </a>
                <a href="/Travel/experiences" class="nav-center-item">
                    Trải Nghiệm
                </a>
                <a href="/Travel/accommodations" class="nav-center-item">
                    Lưu Trú
                </a>
            </div>

            <div class="nav-right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                                <i class="ri-user-line" style="color: white;"></i> 
                                ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu">
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="ri-dashboard-line"></i> Quản Trị
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'HOST'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/host/dashboard" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-dashboard-line"></i> Quản Lý Host
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_service" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-add-circle-line"></i> Tạo Dịch Vụ
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/host/services/manage" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-settings-4-line"></i> Quản Lý Dịch Vụ
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/traveler/upgrade-to-host" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-vip-crown-line"></i> Nâng Lên Host
                                        </a>
                                    </li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="color: #10466C;">
                                        <i class="ri-user-settings-line" style="color: #10466C;"></i> Hồ Sơ
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color: #10466C;">
                                        <i class="ri-logout-circle-r-line" style="color: #10466C;"></i> Đăng Xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="#become-host" class="me-3">Trở thành host</a>
                        <i class="ri-global-line globe-icon me-3"></i>
                        <div class="menu-icon">
                            <i class="ri-menu-line"></i>
                            <div class="dropdown-menu-custom">
                                <a href="#help-center">
                                    <i class="ri-question-line" style="color: #10466C;"></i>Trung tâm Trợ giúp
                                </a>
                                <a href="${pageContext.request.contextPath}/contact">
                                    <i class="ri-contacts-line" style="color: #10466C;"></i>Liên Hệ
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                    <i class="ri-login-circle-line" style="color: #10466C;"></i> Đăng Nhập
                                </a>
                                <a href="${pageContext.request.contextPath}/register">
                                    <i class="ri-user-add-line" style="color: #10466C;" ></i>Đăng Ký
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="upgrade-hero">
        <div class="container text-center">
            <h1 class="animate__animated animate__fadeInUp">
                <i class="ri-vip-crown-line"></i> Trở Thành Host
            </h1>
            <p class="animate__animated animate__fadeInUp animate__delay-1s">
                Chia sẻ trải nghiệm độc đáo của bạn và kiếm thu nhập từ việc làm host
            </p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Success Message -->
        <c:if test="${not empty successMessage}">
            <div class="card border-0 shadow-sm success-card">
                <div class="card-body d-flex align-items-center">
                    <div class="success-icon me-3">
                        <i class="ri-check-circle-fill"></i>
                    </div>
                    <div class="flex-grow-1">
                        <h6 class="mb-1 text-success">Thành công!</h6>
                        <p class="mb-0 text-muted">${successMessage}</p>
                    </div>
                    <button type="button" class="btn-close" onclick="this.closest('.card').style.display = 'none'"></button>
                </div>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="ri-error-warning-line me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:choose>
            <%-- Show complete profile form after successful upgrade --%>
            <c:when test="${showCompleteProfile}">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card upgrade-card">
                            <div class="card-body p-5">
                                <div class="text-center mb-4">
                                    <div class="feature-icon mx-auto">
                                        <i class="ri-building-line"></i>
                                    </div>
                                    <h3 class="fw-bold">Hoàn Thiện Hồ Sơ Host</h3>
                                    <p class="text-muted">Vui lòng cung cấp thông tin doanh nghiệp để hoàn tất việc đăng ký</p>
                                </div>

                                <form method="post" action="${pageContext.request.contextPath}/traveler/upgrade-to-host">
                                    <input type="hidden" name="action" value="complete">
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="businessName" class="form-label required-field">Tên Doanh Nghiệp</label>
                                            <input type="text" class="form-control" id="businessName" name="businessName" 
                                                   value="${businessName}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="businessType" class="form-label required-field">Loại Hình Kinh Doanh</label>
                                            <select class="form-select" id="businessType" name="businessType" required>
                                                <option value="">Chọn loại hình</option>
                                                <option value="Homestay" ${businessType == 'Homestay' ? 'selected' : ''}>Homestay</option>
                                                <option value="Travel Agency" ${businessType == 'Travel Agency' ? 'selected' : ''}>Công ty Du lịch</option>
                                                <option value="Tour Guide" ${businessType == 'Tour Guide' ? 'selected' : ''}>Hướng dẫn viên</option>
                                                <option value="Experience Provider" ${businessType == 'Experience Provider' ? 'selected' : ''}>Nhà cung cấp trải nghiệm</option>
                                                <option value="Restaurant" ${businessType == 'Restaurant' ? 'selected' : ''}>Nhà hàng</option>
                                                <option value="Other" ${businessType == 'Other' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="businessAddress" class="form-label">Địa Chỉ Kinh Doanh</label>
                                        <input type="text" class="form-control" id="businessAddress" name="businessAddress" 
                                               value="${businessAddress}" placeholder="Nhập địa chỉ chi tiết">
                                    </div>

                                    <div class="mb-3">
                                        <label for="businessDescription" class="form-label">Mô Tả Doanh Nghiệp</label>
                                        <textarea class="form-control" id="businessDescription" name="businessDescription" 
                                                  rows="4" placeholder="Mô tả về doanh nghiệp và dịch vụ của bạn">${businessDescription}</textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="taxId" class="form-label">Mã Số Thuế</label>
                                            <input type="text" class="form-control" id="taxId" name="taxId" 
                                                   value="${taxId}" placeholder="Nhập mã số thuế (nếu có)">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="region" class="form-label required-field">Khu Vực Hoạt Động</label>
                                            <select class="form-select" id="region" name="region" required>
                                                <option value="">Chọn khu vực</option>
                                                <option value="North" ${region == 'North' ? 'selected' : ''}>Miền Bắc</option>
                                                <option value="Central" ${region == 'Central' ? 'selected' : ''}>Miền Trung</option>
                                                <option value="South" ${region == 'South' ? 'selected' : ''}>Miền Nam</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="skills" class="form-label">Kỹ Năng & Chuyên Môn</label>
                                        <input type="text" class="form-control" id="skills" name="skills" 
                                               value="${skills}" placeholder="VD: Hướng dẫn viên, Nấu ăn, Nhiếp ảnh...">
                                        <div class="form-text">Liệt kê các kỹ năng của bạn, phân cách bằng dấu phẩy</div>
                                    </div>

                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="ri-check-line me-2"></i>Hoàn Tất Đăng Ký
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>

            <%-- Show upgrade options for eligible users --%>
            <c:when test="${canUpgrade}">
                <!-- Benefits Section -->
                <section class="benefits-section">
                    <div class="container">
                        <div class="row">
                            <div class="col-12 text-center mb-5">
                                <h2 class="fw-bold fade-up">Lợi Ích Khi Trở Thành Host</h2>
                                <p class="text-muted fade-up">Khám phá những cơ hội tuyệt vời đang chờ đợi bạn</p>
                            </div>
                            
                            <div class="col-md-4 mb-4">
                                <div class="benefit-item">
                                    <div class="feature-icon">
                                        <i class="ri-money-dollar-circle-line"></i>
                                    </div>
                                    <h5 class="fw-bold">Thu Nhập Ổn Định</h5>
                                    <p class="text-muted">Kiếm thu nhập từ việc chia sẻ trải nghiệm và dịch vụ của bạn</p>
                                </div>
                            </div>
                            
                            <div class="col-md-4 mb-4">
                                <div class="benefit-item">
                                    <div class="feature-icon">
                                        <i class="ri-group-line"></i>
                                    </div>
                                    <h5 class="fw-bold">Kết Nối Cộng Đồng</h5>
                                    <p class="text-muted">Gặp gỡ và kết nối với du khách từ khắp nơi trên thế giới</p>
                                </div>
                            </div>
                            
                            <div class="col-md-4 mb-4">
                                <div class="benefit-item">
                                    <div class="feature-icon">
                                        <i class="ri-star-line"></i>
                                    </div>
                                    <h5 class="fw-bold">Xây Dựng Thương Hiệu</h5>
                                    <p class="text-muted">Phát triển thương hiệu cá nhân và nâng cao uy tín trong ngành</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Upgrade Form -->
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                        <div class="card upgrade-card">
                            <div class="card-body p-5 text-center">
                                <div class="feature-icon mx-auto">
                                    <i class="ri-vip-crown-line"></i>
                                </div>
                                <h3 class="fw-bold mb-3">Sẵn Sàng Trở Thành Host?</h3>
                                <p class="text-muted mb-4">
                                    Chúc mừng! Tài khoản của bạn đã đủ điều kiện để nâng cấp lên Host. 
                                    Hãy bắt đầu hành trình chia sẻ những trải nghiệm tuyệt vời với cộng đồng du lịch.
                                </p>
                                
                                <form method="post" action="${pageContext.request.contextPath}/traveler/upgrade-to-host">
                                    <input type="hidden" name="action" value="upgrade">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="ri-rocket-line me-2"></i>Nâng Cấp Ngay
                                    </button>
                                </form>
                                
                                <div class="mt-3">
                                    <small class="text-muted">
                                        <i class="ri-shield-check-line me-1"></i>
                                        An toàn và bảo mật 100%
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>

            <%-- Show error for ineligible users --%>
            <c:otherwise>
                <div class="row justify-content-center">
                    <div class="col-lg-6">
                        <div class="card upgrade-card">
                            <div class="card-body p-5 text-center">
                                <div class="feature-icon mx-auto error-icon">
                                    <i class="ri-error-warning-line"></i>
                                </div>
                                <h3 class="fw-bold mb-3">Chưa Đủ Điều Kiện</h3>
                                <p class="text-muted mb-4">
                                    Tài khoản của bạn chưa đủ điều kiện để nâng cấp lên Host. 
                                    Vui lòng đảm bảo:
                                </p>
                                
                                <div class="text-start mb-4">
                                    <ul class="list-unstyled">
                                        <li class="mb-2">
                                            <i class="ri-check-line text-success me-2"></i>
                                            Tài khoản đang hoạt động
                                        </li>
                                        <li class="mb-2">
                                            <i class="ri-mail-check-line text-success me-2"></i>
                                            Email đã được xác thực
                                        </li>
                                        <li class="mb-2">
                                            <i class="ri-user-line text-success me-2"></i>
                                            Đang có vai trò Traveler
                                        </li>
                                    </ul>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-primary">
                                    <i class="ri-settings-line me-2"></i>Kiểm Tra Hồ Sơ
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- How It Works Section -->
    <section class="py-5" style="background-color: var(--light-color);">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-5">
                    <h2 class="fw-bold fade-up">Cách Thức Hoạt Động</h2>
                    <p class="text-muted fade-up">Quy trình đơn giản để trở thành Host</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="text-center">
                        <div class="feature-icon mx-auto" style="background: var(--gradient-secondary);">
                            <i class="ri-user-add-line"></i>
                        </div>
                        <h5 class="fw-bold">1. Đăng Ký</h5>
                        <p class="text-muted">Nâng cấp tài khoản Traveler lên Host và hoàn thiện thông tin doanh nghiệp</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="text-center">
                        <div class="feature-icon mx-auto" style="background: var(--gradient-secondary);">
                            <i class="ri-add-circle-line"></i>
                        </div>
                        <h5 class="fw-bold">2. Tạo Dịch Vụ</h5>
                        <p class="text-muted">Thêm trải nghiệm hoặc nơi lưu trú của bạn với mô tả chi tiết và hình ảnh</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="text-center">
                        <div class="feature-icon mx-auto" style="background: var(--gradient-secondary);">
                            <i class="ri-money-dollar-circle-line"></i>
                        </div>
                        <h5 class="fw-bold">3. Kiếm Thu Nhập</h5>
                        <p class="text-muted">Đón khách và nhận thanh toán qua nền tảng an toàn của chúng tôi</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="py-5" style="background: var(--gradient-primary);">
        <div class="container">
            <div class="row text-center text-white">
                <div class="col-md-3 mb-4">
                    <div class="h2 fw-bold">500+</div>
                    <p>Host đang hoạt động</p>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="h2 fw-bold">10,000+</div>
                    <p>Khách hàng hài lòng</p>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="h2 fw-bold">1,000+</div>
                    <p>Trải nghiệm độc đáo</p>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="h2 fw-bold">63</div>
                    <p>Tỉnh thành</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5>Về Chúng Tôi</h5>
                    <p>Kết nối du khách với những trải nghiệm văn hóa độc đáo và nơi lưu trú ấm cúng trên khắp Việt Nam. Chúng tôi mang đến những giá trị bền vững và góp phần phát triển du lịch cộng đồng.</p>
                    <div class="social-icons">
                        <a href="#"><i class="ri-facebook-fill"></i></a>
                        <a href="#"><i class="ri-instagram-fill"></i></a>
                        <a href="#"><i class="ri-twitter-fill"></i></a>
                        <a href="#"><i class="ri-youtube-fill"></i></a>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>Liên Kết Nhanh</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/"><i class="ri-arrow-right-s-line"></i> Trang Chủ</a></li>
                        <li><a href="/Travel/experiences"><i class="ri-arrow-right-s-line"></i> Trải Nghiệm</a></li>
                        <li><a href="/Travel/accommodations"><i class="ri-arrow-right-s-line"></i> Lưu Trú</a></li>
                        <li><a href="#become-host"><i class="ri-arrow-right-s-line"></i> Trở Thành Host</a></li>
                    </ul>
                </div>
                <div class="col-md-2 mb-4">
                    <h5>Hỗ Trợ</h5>
                    <ul class="list-unstyled">
                        <li><a href="#"><i class="ri-question-line"></i> Trung tâm hỗ trợ</a></li>
                        <li><a href="#"><i class="ri-money-dollar-circle-line"></i> Chính sách giá</a></li>
                        <li><a href="#"><i class="ri-file-list-line"></i> Điều khoản</a></li>
                        <li><a href="#"><i class="ri-shield-check-line"></i> Bảo mật</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>Liên Hệ</h5>
                    <p><i class="ri-map-pin-line me-2"></i> Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam</p>
                    <p><i class="ri-mail-line me-2"></i> f5@vietculture.vn</p>
                    <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                    <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                </div>
            </div>
            <div class="copyright">
                <p>© 2025 VietCulture. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Form Validation & Interactions -->
    <script>
        // Dropdown menu functionality
        const menuIcon = document.querySelector('.menu-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

        if (menuIcon && dropdownMenu) {
            menuIcon.addEventListener('click', function (e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            document.addEventListener('click', function () {
                dropdownMenu.classList.remove('show');
            });

            dropdownMenu.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        // Navbar scroll effect
        window.addEventListener('scroll', function () {
            const navbar = document.querySelector('.custom-navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }

            // Animate elements when they come into view
            animateOnScroll();
        });

        // Animate elements when they come into view
        function animateOnScroll() {
            const fadeElements = document.querySelectorAll('.fade-up');

            fadeElements.forEach(element => {
                const elementTop = element.getBoundingClientRect().top;
                const elementVisible = 150;

                if (elementTop < window.innerHeight - elementVisible) {
                    element.classList.add('active');
                }
            });
        }

        // Client-side form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Show confirmation dialog for upgrade
        document.addEventListener('DOMContentLoaded', function() {
            const upgradeForm = document.querySelector('form[action*="upgrade-to-host"] input[value="upgrade"]');
            if (upgradeForm) {
                upgradeForm.closest('form').addEventListener('submit', function(e) {
                    if (!confirm('Bạn có chắc chắn muốn nâng cấp lên Host? Hành động này không thể hoàn tác.')) {
                        e.preventDefault();
                    }
                });
            }

            // Initialize animations
            animateOnScroll();
        });
    </script>
</body>
</html>
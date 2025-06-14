<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Trải Nghiệm</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Remixicon CDN -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <!-- Animate.css CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --light-green: #E0F7FA;
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
            background: linear-gradient(180deg, #b3e5fc 0%, #e6f0fa 50%, #ffffff 100%);
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
            padding-top: 80px;
            overflow-x: hidden;
            display: flex;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
        }

        /* Navigation styles */
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

        .navbar-brand img {
            height: 50px;
            width: auto;
            margin-right: 12px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
            object-fit: contain;
        }

        .nav-center {
            display: flex;
            align-items: center;
            gap: 40px;
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
        }

        /* Sidebar styles with cards */
        .sidebar {
            width: 250px;
            background: #fff;
            position: fixed;
            top: 80px;
            left: 0;
            height: calc(100vh - 80px);
            padding: 20px 0;
            box-shadow: var(--shadow-md);
            z-index: 900;
            overflow-y: auto;
            border-right: 1px solid #e0e0e0;
        }

        .sidebar .card {
            background: var(--light-color);
            border: 1px solid #e0e0e0;
            border-radius: var(--border-radius);
            margin-bottom: 15px;
            overflow: hidden;
            transition: var(--transition);
        }

        .sidebar .card a {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: var(--dark-color);
            text-decoration: none;
            font-size: 1rem;
        }

        .sidebar .card a i {
            margin-right: 10px;
            font-size: 18px;
        }

        .sidebar .card:hover {
            background: var(--light-green);
            box-shadow: var(--shadow-md);
        }

        .sidebar .card.active {
            background: rgba(255, 56, 92, 0.1);
            color: var(--primary-color);
            font-weight: 600;
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;
            padding: 40px 20px;
            width: calc(100% - 250px);
            min-height: calc(100vh - 120px);
            background: var(--light-green);
        }

        /* Cards Container */
        .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            padding: 20px;
        }

        .experience-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            position: relative;
        }

        .experience-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .card-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .card-content {
            padding: 20px;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 10px;
        }

        .card-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }

        .card-info i {
            color: var(--primary-color);
        }

        .card-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 10px 0;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-edit, .btn-delete {
            padding: 8px 16px;
            border-radius: 20px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            flex: 1;
            text-align: center;
            text-decoration: none;
        }

        .btn-edit {
            background: var(--gradient-secondary);
            color: white;
        }

        .btn-delete {
            background: #ff4757;
            color: white;
        }

        .btn-edit:hover, .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-active {
            background: #2ecc71;
            color: white;
        }

        .status-pending {
            background: #f1c40f;
            color: white;
        }

        .status-inactive {
            background: #95a5a6;
            color: white;
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .sidebar {
                width: 200px;
            }
            .main-content {
                margin-left: 200px;
                width: calc(100% - 200px);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 20px;
            }
            .cards-container {
                grid-template-columns: 1fr;
            }
        }

        .hover-shadow {
            transition: all 0.3s ease;
            border: 1px solid #eee;
        }

        .hover-shadow:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: var(--primary-color);
        }

        .card {
            color: var(--dark-color);
        }

        .card:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
            <div class="nav-center">
                <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                    Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/Travel/experiences" class="nav-center-item active">
                    Trải Nghiệm
                </a>
                <a href="${pageContext.request.contextPath}/Travel/accommodations" class="nav-center-item">
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
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_experience" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-add-circle-line"></i> Tạo Mới
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/host/experiences/manage">
                                            <i class="ri-settings-4-line"></i> Quản Lý Trải Nghiệm
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
                                <a href="#contact">
                                    <i class="ri-contacts-line" style="color: #10466C;"></i>Liên Hệ
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                    <i class="ri-login-circle-line" style="color: #10466C;"></i> Đăng Nhập
                                </a>
                                <a href="${pageContext.request.contextPath}/register">
                                    <i class="ri-user-add-line" style="color: #10466C;"></i>Đăng Ký
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Sidebar with Cards -->
    <div class="sidebar">
        <c:if test="${sessionScope.user.role == 'HOST'}">
            <div class="card ${pageContext.request.requestURI.contains('/create_experience') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/create_experience">
                    <i class="ri-add-circle-line"></i> Tạo Trải Nghiệm Mới
                </a>
            </div>
            <div class="card ${pageContext.request.requestURI.contains('/host/experiences/manage') ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/host/experiences/manage">
                    <i class="ri-settings-4-line"></i> Quản Lý Trải Nghiệm
                </a>
            </div>
        </c:if>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="cards-container">
            <c:forEach var="experience" items="${experiences}">
                <div class="experience-card">
                    <div class="position-relative">
                        <c:choose>
                            <c:when test="${not empty experience.images}">
                                <c:set var="imageArray" value="${fn:split(experience.images, ',')}" />
                                <c:set var="firstImage" value="${fn:trim(imageArray[0])}" />
                                <img src="${pageContext.request.contextPath}/assets/images/experiences/${firstImage}"
                                     class="card-image"
                                     alt="${experience.title}"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default-experience.jpg'">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-experience.jpg"
                                     class="card-image"
                                     alt="${experience.title}">
                            </c:otherwise>
                        </c:choose>
                        <div class="position-absolute top-0 end-0 m-2">
                            <span class="badge ${experience.active ? 'bg-success' : 'bg-warning'}">
                                ${experience.active ? 'Đang hoạt động' : 'Chờ duyệt'}
                            </span>
                        </div>
                    </div>
                    <div class="card-content">
                        <h5 class="card-title">${experience.title}</h5>
                        <p class="card-info"><i class="ri-map-pin-line me-1"></i>${experience.location}</p>
                        <p class="card-info"><i class="ri-money-dollar-circle-line me-1"></i>${experience.price} VNĐ</p>
                        <div class="card-actions">
                            <a href="${pageContext.request.contextPath}/Travel/experiences/${experience.experienceId}"
                               class="btn-edit">
                                <i class="ri-eye-line me-1"></i>Xem
                            </a>
                            <a href="${pageContext.request.contextPath}/Travel/host/experiences/edit/${experience.experienceId}"
                               class="btn-delete"> <%-- Using btn-delete class for edit for now, you might want to rename --%>
                                <i class="ri-edit-line me-1"></i>Sửa
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Create Choice Modal -->
    <div class="modal fade" id="createChoiceModal" tabindex="-1" aria-labelledby="createChoiceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createChoiceModalLabel">Chọn Loại Tạo Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/Travel/create_experience" class="text-decoration-none">
                                <div class="card h-100 text-center p-3 hover-shadow">
                                    <i class="ri-map-pin-line fs-1 text-primary mb-2"></i>
                                    <h5 class="card-title">Tạo Trải Nghiệm</h5>
                                    <p class="card-text small text-muted">Tạo một trải nghiệm du lịch độc đáo</p>
                                </div>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/Travel/create_accommodation" class="text-decoration-none">
                                <div class="card h-100 text-center p-3 hover-shadow">
                                    <i class="ri-home-line fs-1 text-primary mb-2"></i>
                                    <h5 class="card-title">Tạo Lưu Trú</h5>
                                    <p class="card-text small text-muted">Tạo một nơi lưu trú mới</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



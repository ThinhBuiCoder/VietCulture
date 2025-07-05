<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ Sơ Cá Nhân - VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <style>
            .email-display {
                position: relative;
            }

            .email-readonly {
                background-color: #f8f9fa !important;
                cursor: not-allowed;
                color: #6c757d;
            }

            .email-note {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                display: flex;
                align-items: center;
                pointer-events: none;
            }

            .email-note i {
                color: #6c757d;
                font-size: 14px;
            }

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
                transition: all 0.3s ease;
            }

            .password-toggle:hover {
                color: #10466C;
                background: rgba(16, 70, 108, 0.1);
            }

            .password-toggle:focus {
                outline: 2px solid #83C5BE;
                outline-offset: 2px;
            }
            :root {
                --primary-color: #10466C;
                --secondary-color: #83C5BE;
                --accent-color: #F8F9FA;
                --dark-color: #2F4858;
                --light-color: #FFFFFF;
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

            /* Custom Navbar */
            .custom-navbar {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                background-color: var(--primary-color);
                backdrop-filter: blur(10px);
                box-shadow: var(--shadow-sm);
                z-index: 1000;
                padding: 15px 0;
                transition: var(--transition);
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
                margin-right: 12px;
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 24px;
            }

            .nav-right a {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
                transition: var(--transition);
            }

            .nav-right a:hover {
                color: white;
            }

            /* Profile Container */
            .profile-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .profile-header {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: white;
                padding: 40px;
                border-radius: var(--border-radius);
                margin-bottom: 30px;
                position: relative;
                overflow: hidden;
            }

            .profile-header::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 200px;
                height: 200px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
                transform: translate(50px, -50px);
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid rgba(255,255,255,0.3);
                margin-bottom: 20px;
                position: relative;
                z-index: 2;
            }

            .profile-info h2 {
                font-family: 'Playfair Display', serif;
                font-size: 2.5rem;
                margin-bottom: 10px;
            }

            .profile-stats {
                display: flex;
                gap: 30px;
                margin-top: 20px;
            }

            .stat-item {
                text-align: center;
            }

            .stat-number {
                font-size: 1.5rem;
                font-weight: 700;
                display: block;
            }

            .stat-label {
                font-size: 0.9rem;
                opacity: 0.8;
            }

            /* Profile Content */
            .profile-content {
                display: grid;
                grid-template-columns: 1fr 2fr;
                gap: 30px;
            }

            .profile-sidebar {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .profile-card {
                background: white;
                border-radius: var(--border-radius);
                padding: 25px;
                box-shadow: var(--shadow-sm);
                transition: var(--transition);
            }

            .profile-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-2px);
            }

            .profile-card h4 {
                color: var(--primary-color);
                margin-bottom: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .profile-card h4 i {
                font-size: 1.2rem;
            }

            /* Form Styles */
            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 8px;
                display: block;
            }

            .form-control {
                border: 2px solid #e9ecef;
                border-radius: 10px;
                padding: 12px 16px;
                transition: var(--transition);
                font-size: 0.95rem;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(16, 70, 108, 0.1);
            }

            .btn {
                border-radius: 10px;
                padding: 12px 24px;
                font-weight: 500;
                transition: var(--transition);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-primary:hover {
                background-color: #0d3a5a;
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .btn-outline-primary {
                color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-outline-primary:hover {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            /* Tabs */
            .nav-tabs {
                border: none;
                margin-bottom: 25px;
            }

            .nav-tabs .nav-link {
                border: none;
                background: transparent;
                color: var(--dark-color);
                font-weight: 500;
                padding: 12px 20px;
                border-radius: 10px;
                margin-right: 10px;
                transition: var(--transition);
            }

            .nav-tabs .nav-link.active {
                background: var(--primary-color);
                color: white;
            }

            .nav-tabs .nav-link:hover:not(.active) {
                background: rgba(16, 70, 108, 0.1);
            }

            /* Info Items */
            .info-item {
                display: flex;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid #f8f9fa;
            }

            .info-item:last-child {
                border-bottom: none;
            }

            .info-icon {
                width: 40px;
                height: 40px;
                background: rgba(16, 70, 108, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                color: var(--primary-color);
            }

            .info-content {
                flex: 1;
            }

            .info-label {
                font-size: 0.85rem;
                color: #6c757d;
                margin-bottom: 2px;
            }

            .info-value {
                font-weight: 500;
                color: var(--dark-color);
            }

            /* Badge Styles */
            .badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 500;
            }

            .badge-success {
                background-color: #28a745;
                color: white;
            }

            .badge-warning {
                background-color: #ffc107;
                color: #212529;
            }

            .badge-primary {
                background-color: var(--primary-color);
                color: white;
            }

            /* Success/Error Messages */
            .alert {
                border-radius: 10px;
                border: none;
                padding: 15px 20px;
                margin-bottom: 20px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .profile-content {
                    grid-template-columns: 1fr;
                }

                .profile-stats {
                    flex-wrap: wrap;
                    gap: 15px;
                }

                .profile-header {
                    padding: 25px;
                    text-align: center;
                }

                .profile-info h2 {
                    font-size: 2rem;
                }
            }

            /* Avatar Upload */
            .avatar-upload {
                position: relative;
                display: inline-block;
            }

            .avatar-upload-btn {
                position: absolute;
                bottom: 0;
                right: 0;
                width: 36px;
                height: 36px;
                background: var(--primary-color);
                color: white;
                border: none;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: var(--transition);
            }

            .avatar-upload-btn:hover {
                background: #0d3a5a;
                transform: scale(1.1);
            }

            #avatarInput {
                display: none;
            }
        </style>
    </head>
    <body>

        <!-- Navigation -->
        <nav class="custom-navbar">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                        <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                        <span>VIETCULTURE</span>
                    </a>

                    <div class="nav-right">
                        <a href="${pageContext.request.contextPath}/">
                            <i class="ri-home-line me-2"></i>Trang Chủ
                        </a>
                        <c:if test="${sessionScope.user.role == 'HOST'}">
                            <a href="${pageContext.request.contextPath}/host/dashboard">
                                <i class="ri-dashboard-line me-2"></i>Dashboard
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="ri-logout-circle-r-line me-2"></i>Đăng Xuất
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Success/Error Messages -->
        <c:if test="${not empty message}">
            <div class="container mt-3">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="ri-check-circle-line me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="container mt-3">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="ri-error-warning-line me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="d-flex align-items-center">
                    <div class="avatar-upload me-4">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatar}">
                                <!-- Sử dụng ImageServlet -->
                                <img src="${pageContext.request.contextPath}/images/avatars/${sessionScope.user.avatar}?t=${System.currentTimeMillis()}" 
                                     alt="Avatar" class="profile-avatar" id="profileAvatar"
                                     onerror="this.src='https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg" 
                                     alt="Default Avatar" class="profile-avatar" id="profileAvatar">
                            </c:otherwise>
                        </c:choose>
                        <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatarInput').click()">
                            <i class="ri-camera-line"></i>
                        </button>
                        <input type="file" id="avatarInput" accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,.tiff,.svg" 
                               onchange="updateAvatar(this)">
                    </div>

                    <div class="profile-info flex-grow-1">
                        <h2>${sessionScope.user.fullName}</h2>
                        <p class="mb-2">
                            <i class="ri-mail-line me-2"></i>${sessionScope.user.email}
                        </p>
                        <div class="d-flex align-items-center gap-3">
                            <span class="badge badge-primary">${sessionScope.user.role}</span>
                            <c:choose>
                                <c:when test="${sessionScope.user.active}">
                                    <span class="badge badge-success">Đang hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">Tạm khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="profile-stats">
                            <div class="stat-item">
                                <span class="stat-number">${totalBookings}</span>
                                <span class="stat-label">Đặt chỗ</span>
                            </div>
                            <c:if test="${sessionScope.user.role == 'HOST'}">
                                <div class="stat-item">
                                    <span class="stat-number">${totalExperiences}</span>
                                    <span class="stat-label">Trải nghiệm</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-number">${totalRevenue}đ</span>
                                    <span class="stat-label">Doanh thu</span>
                                </div>
                            </c:if>
                            <div class="stat-item">
                                <span class="stat-number">
                                    <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="yyyy"/>
                                </span>
                                <span class="stat-label">Tham gia</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Content -->
            <div class="profile-content">
                <!-- Sidebar -->
                <div class="profile-sidebar">
                    <!-- Personal Info Card -->
                    <div class="profile-card">
                        <h4><i class="ri-user-line"></i>Thông Tin Cá Nhân</h4>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="ri-phone-line"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Số điện thoại</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.phone}">
                                            ${sessionScope.user.phone}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="ri-calendar-line"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Ngày sinh</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.dateOfBirth}">
                                            <fmt:formatDate value="${sessionScope.user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="ri-user-2-line"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Giới tính</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.gender}">
                                            ${sessionScope.user.gender}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="ri-time-line"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Tham gia</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bio Card -->
                    <div class="profile-card">
                        <h4><i class="ri-information-line"></i>Giới Thiệu</h4>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.bio}">
                                    ${sessionScope.user.bio}
                                </c:when>
                                <c:otherwise>
                                    Người dùng chưa thêm mô tả về bản thân.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="profile-main">
                    <!-- Tabs -->
                    <ul class="nav nav-tabs" id="profileTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="edit-tab" data-bs-toggle="tab" data-bs-target="#edit-pane" type="button" role="tab">
                                <i class="ri-edit-line me-2"></i>Chỉnh Sửa Hồ Sơ
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password-pane" type="button" role="tab">
                                <i class="ri-lock-line me-2"></i>Đổi Mật Khẩu
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="profileTabsContent">
                        <!-- Edit Profile Tab -->
                        <div class="tab-pane fade show active" id="edit-pane" role="tabpanel">
                            <div class="profile-card">
                                <form action="${pageContext.request.contextPath}/profile/update" method="post" enctype="multipart/form-data">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="fullName">Họ và tên *</label>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="${sessionScope.user.fullName}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="email">Email</label>
                                                <div class="email-display">
                                                    <input type="email" class="form-control email-readonly" id="email" 
                                                           value="${sessionScope.user.email}" readonly>
                                                    <div class="email-note">
                                                        <i class="ri-information-line me-1"></i>
                                                        <small class="text-muted">Email không thể thay đổi</small>
                                                    </div>
                                                </div>
                                                <!-- Hidden input to ensure email is sent with form -->
                                                <input type="hidden" name="email" value="${sessionScope.user.email}">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="phone">Số điện thoại</label>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="${sessionScope.user.phone}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="dateOfBirth">Ngày sinh</label>
                                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                                       value="<fmt:formatDate value='${sessionScope.user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="gender">Giới tính</label>
                                                <select class="form-control" id="gender" name="gender">
                                                    <option value="">Chọn giới tính</option>
                                                    <option value="Nam" ${sessionScope.user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                                    <option value="Nữ" ${sessionScope.user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                                    <option value="Khác" ${sessionScope.user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="avatarFile">Ảnh đại diện</label>
                                                <input type="file" class="form-control" id="avatarFile" name="avatarFile" 
                                                       accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,.tiff,.svg" onchange="previewAvatarInForm(this)">
                                                <small class="text-muted">Chọn file ảnh (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg). Tối đa 10MB.</small>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="bio">Giới thiệu bản thân</label>
                                        <textarea class="form-control" id="bio" name="bio" rows="4" 
                                                  placeholder="Viết vài dòng giới thiệu về bản thân...">${sessionScope.user.bio}</textarea>
                                    </div>

                                    <div class="d-flex gap-3">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="ri-save-line me-2"></i>Lưu Thay Đổi
                                        </button>
                                        <button type="reset" class="btn btn-outline-secondary">
                                            <i class="ri-refresh-line me-2"></i>Khôi Phục
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Change Password Tab -->
                        <div class="tab-pane fade" id="password-pane" role="tabpanel">
                            <div class="profile-card">
                                <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                                    <div class="form-group">
                                        <label class="form-label" for="currentPassword">Mật khẩu hiện tại *</label>
                                        <div class="password-field position-relative">
                                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                            <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                                <i class="fas fa-eye" id="currentPasswordIcon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="newPassword">Mật khẩu mới *</label>
                                        <div class="password-field position-relative">
                                            <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                                   minlength="6" required>
                                            <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                                            </button>
                                        </div>
                                        <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="confirmPassword">Xác nhận mật khẩu mới *</label>
                                        <div class="password-field position-relative">
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                   minlength="6" required>
                                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                                <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary">
                                        <i class="ri-lock-unlock-line me-2"></i>Đổi Mật Khẩu
                                    </button>
                                </form>
                            </div>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        .email-display {
            position: relative;
        }
        
        .email-readonly {
            background-color: #f8f9fa !important;
            cursor: not-allowed;
            color: #6c757d;
        }
        
        .email-note {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            align-items: center;
            pointer-events: none;
        }
        
        .email-note i {
            color: #6c757d;
            font-size: 14px;
        }
        
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
            transition: all 0.3s ease;
        }
        
        .password-toggle:hover {
            color: #10466C;
            background: rgba(16, 70, 108, 0.1);
        }
        
        .password-toggle:focus {
            outline: 2px solid #83C5BE;
            outline-offset: 2px;
        }

        :root {
            --primary-color: #10466C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
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

        /* Custom Navbar */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: var(--primary-color);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
            transition: var(--transition);
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
            margin-right: 12px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: var(--transition);
        }

        .nav-right a:hover {
            color: white;
        }

        /* Profile Container */
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 40px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: translate(50px, -50px);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin-bottom: 20px;
            position: relative;
            z-index: 2;
        }

        .profile-info h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .profile-stats {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* Profile Content */
        .profile-content {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
        }

        .profile-sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .profile-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }

        .profile-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .profile-card h4 {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile-card h4 i {
            font-size: 1.2rem;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
            display: block;
        }

        .form-label.required::after {
            content: ' *';
            color: #dc3545;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 16px;
            transition: var(--transition);
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(16, 70, 108, 0.1);
        }

        .btn {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #0d3a5a;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Tabs */
        .nav-tabs {
            border: none;
            margin-bottom: 25px;
        }

        .nav-tabs .nav-link {
            border: none;
            background: transparent;
            color: var(--dark-color);
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 10px;
            margin-right: 10px;
            transition: var(--transition);
        }

        .nav-tabs .nav-link.active {
            background: var(--primary-color);
            color: white;
        }

        .nav-tabs .nav-link:hover:not(.active) {
            background: rgba(16, 70, 108, 0.1);
        }

        /* Info Items */
        .info-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            background: rgba(16, 70, 108, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: var(--primary-color);
        }

        .info-content {
            flex: 1;
        }

        .info-label {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 2px;
        }

        .info-value {
            font-weight: 500;
            color: var(--dark-color);
        }

        /* Badge Styles */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .badge-success {
            background-color: #28a745;
            color: white;
        }

        .badge-warning {
            background-color: #ffc107;
            color: #212529;
        }

        .badge-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .badge-host {
            background-color: var(--secondary-color);
            color: white;
        }

        /* Success/Error Messages */
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }

        /* Host Info Section */
        .host-info-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 20px;
        }

        .host-info-section h4 {
            color: white;
            margin-bottom: 20px;
        }

        .host-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .host-info-item {
            background: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }

        .host-info-item .label {
            font-size: 0.85rem;
            opacity: 0.8;
            margin-bottom: 5px;
        }

        .host-info-item .value {
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr;
            }
            
            .profile-stats {
                flex-wrap: wrap;
                gap: 15px;
            }
            
            .profile-header {
                padding: 25px;
                text-align: center;
            }
            
            .profile-info h2 {
                font-size: 2rem;
            }

            .host-info-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Avatar Upload */
        .avatar-upload {
            position: relative;
            display: inline-block;
        }

        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 36px;
            height: 36px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .avatar-upload-btn:hover {
            background: #0d3a5a;
            transform: scale(1.1);
        }

        #avatarInput {
            display: none;
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                    <span>VIETCULTURE</span>
                </a>

                <div class="nav-right">
                    <a href="${pageContext.request.contextPath}/">
                        <i class="ri-home-line me-2"></i>Trang Chủ
                    </a>
                    <c:if test="${sessionScope.user.role == 'HOST'}">
                        <a href="${pageContext.request.contextPath}/host/dashboard">
                            <i class="ri-dashboard-line me-2"></i>Dashboard
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                        <a href="${pageContext.request.contextPath}/traveler/upgrade-to-host">
                            <i class="ri-vip-crown-line me-2"></i>Nâng Lên Host
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="ri-logout-circle-r-line me-2"></i>Đăng Xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Success/Error Messages -->
    <c:if test="${not empty message}">
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="ri-check-circle-line me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="container mt-3">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="ri-error-warning-line me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="d-flex align-items-center">
                <div class="avatar-upload me-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${pageContext.request.contextPath}/images/avatars/${sessionScope.user.avatar}?t=${System.currentTimeMillis()}" 
                                 alt="Avatar" class="profile-avatar" id="profileAvatar"
                                 onerror="this.src='https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg'">
                        </c:when>
                        <c:otherwise>
                            <img src="https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg" 
                                 alt="Default Avatar" class="profile-avatar" id="profileAvatar">
                        </c:otherwise>
                    </c:choose>
                    <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatarInput').click()">
                        <i class="ri-camera-line"></i>
                    </button>
                    <input type="file" id="avatarInput" accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,.tiff,.svg" 
                           onchange="updateAvatar(this)">
                </div>
                
                <div class="profile-info flex-grow-1">
                    <h2>${sessionScope.user.fullName}</h2>
                    <p class="mb-2">
                        <i class="ri-mail-line me-2"></i>${sessionScope.user.email}
                    </p>
                    <div class="d-flex align-items-center gap-3">
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'HOST'}">
                                <span class="badge badge-host">
                                    <i class="ri-vip-crown-line me-1"></i>Host
                                </span>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                <span class="badge badge-warning">
                                    <i class="ri-shield-star-line me-1"></i>Admin
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-primary">
                                    <i class="ri-user-line me-1"></i>Traveler
                                </span>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${sessionScope.user.active}">
                                <span class="badge badge-success">Đang hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-warning">Tạm khóa</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-stats">
                        <div class="stat-item">
                            <span class="stat-number">${totalBookings}</span>
                            <span class="stat-label">Đặt chỗ</span>
                        </div>
                        <c:if test="${sessionScope.user.role == 'HOST'}">
                            <div class="stat-item">
                                <span class="stat-number">${totalExperiences}</span>
                                <span class="stat-label">Trải nghiệm</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">${totalRevenue}đ</span>
                                <span class="stat-label">Doanh thu</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">${sessionScope.user.averageRating}/5</span>
                                <span class="stat-label">Đánh giá</span>
                            </div>
                        </c:if>
                        <div class="stat-item">
                            <span class="stat-number">
                                <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="yyyy"/>
                            </span>
                            <span class="stat-label">Tham gia</span>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                        </div>
                    </div>
                </div>
            </div>
        </div>

<<<<<<< HEAD
        <!-- Additional CSS for readonly email field -->


        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                // Password toggle functionality
                                                function togglePassword(fieldId) {
                                                    const field = document.getElementById(fieldId);
                                                    const icon = document.getElementById(fieldId + 'Icon');

                                                    if (field.type === 'password') {
                                                        field.type = 'text';
                                                        icon.classList.remove('fa-eye');
                                                        icon.classList.add('fa-eye-slash');
                                                    } else {
                                                        field.type = 'password';
                                                        icon.classList.remove('fa-eye-slash');
                                                        icon.classList.add('fa-eye');
                                                    }
                                                }

                                                // Preview avatar from header button
                                                function updateAvatar(inputElement) {
                                                    console.log('updateAvatar called from header button');
                                                    if (inputElement.files && inputElement.files[0]) {
                                                        const file = inputElement.files[0];
                                                        console.log('File selected:', file.name, file.size, 'bytes');

                                                        const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp',
                                                            'image/bmp', 'image/tiff', 'image/svg+xml'];

                                                        if (validImageTypes.includes(file.type)) {
                                                            // Check file size (10MB max)
                                                            if (file.size > 10 * 1024 * 1024) {
                                                                alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
                                                                inputElement.value = '';
                                                                return;
                                                            }

                                                            const reader = new FileReader();
                                                            reader.onload = function (e) {
                                                                const profileAvatar = document.getElementById('profileAvatar');
                                                                // Thêm timestamp để tránh cache
                                                                profileAvatar.src = e.target.result;
                                                                console.log('Avatar preview updated');

                                                                // Đánh dấu rằng có file mới được chọn
                                                                profileAvatar.setAttribute('data-new-upload', 'true');
                                                            };
                                                            reader.readAsDataURL(file);

                                                            // Đồng bộ với form input
                                                            const formInput = document.getElementById('avatarFile');
                                                            if (formInput && inputElement.id !== 'avatarFile') {
                                                                const dt = new DataTransfer();
                                                                dt.items.add(file);
                                                                formInput.files = dt.files;
                                                                console.log('Form input synced');
                                                            }
                                                        } else {
                                                            alert('Vui lòng chọn file ảnh hợp lệ (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg).');
                                                            inputElement.value = '';
                                                        }
                                                    }

                                                }

                                                // Preview avatar from form input
                                                function previewAvatarInForm(inputElement) {
                                                    console.log('previewAvatarInForm called from form input');
                                                    if (inputElement.files && inputElement.files[0]) {
                                                        const file = inputElement.files[0];
                                                        console.log('File selected:', file.name, file.size, 'bytes');

                                                        const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp',
                                                            'image/bmp', 'image/tiff', 'image/svg+xml'];

                                                        if (validImageTypes.includes(file.type)) {
                                                            if (file.size > 10 * 1024 * 1024) {
                                                                alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
                                                                inputElement.value = '';
                                                                return;
                                                            }

                                                            function reloadAvatarAfterUpload(newAvatarName) {
                                                                if (newAvatarName) {
                                                                    const profileAvatar = document.getElementById('profileAvatar');
                                                                    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
                                                                    const timestamp = new Date().getTime();

                                                                    profileAvatar.src = `${contextPath}/view/assets/images/avatars/${newAvatarName}?t=${timestamp}`;
                                                                                            profileAvatar.removeAttribute('data-new-upload');
                                                                                            console.log('Avatar reloaded after upload:', newAvatarName);
                                                                                        }
                                                                                    }
                                                                                    const reader = new FileReader();
                                                                                    reader.onload = function (e) {
                                                                                        const profileAvatar = document.getElementById('profileAvatar');
                                                                                        profileAvatar.src = e.target.result;
                                                                                        profileAvatar.setAttribute('data-new-upload', 'true');
                                                                                        console.log('Avatar preview updated from form');
                                                                                    };
                                                                                    reader.readAsDataURL(file);

                                                                                    // Đồng bộ với header input
                                                                                    const headerInput = document.getElementById('avatarInput');
                                                                                    if (headerInput && inputElement.id !== 'avatarInput') {
                                                                                        const dt = new DataTransfer();
                                                                                        dt.items.add(file);
                                                                                        headerInput.files = dt.files;
                                                                                        console.log('Header input synced');
                                                                                    }
                                                                                } else {
                                                                                    alert('Vui lòng chọn file ảnh hợp lệ (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg).');
                                                                                    inputElement.value = '';
                                                                                }
                                                                            }
                                                                        }

                                                                        // Password confirmation validation
                                                                        document.addEventListener('DOMContentLoaded', function () {
                                                                            const confirmPasswordInput = document.getElementById('confirmPassword');
                                                                            if (confirmPasswordInput) {
                                                                                confirmPasswordInput.addEventListener('input', function () {
                                                                                    const password = document.getElementById('newPassword').value;
                                                                                    const confirmPassword = this.value;

                                                                                    if (password !== confirmPassword) {
                                                                                        this.setCustomValidity('Mật khẩu xác nhận không khớp');
                                                                                    } else {
                                                                                        this.setCustomValidity('');
                                                                                    }
                                                                                });
                                                                            }

                                                                            // Form validation
                                                                            const forms = document.querySelectorAll('form');
                                                                            forms.forEach(form => {
                                                                                form.addEventListener('submit', function (e) {
                                                                                    console.log('Form submitted:', form.action);

                                                                                    // Check if this is the profile update form
                                                                                    if (form.action.includes('/profile/update')) {
                                                                                        const avatarFile = document.getElementById('avatarFile');
                                                                                        if (avatarFile && avatarFile.files.length > 0) {
                                                                                            console.log('Avatar file will be uploaded:', avatarFile.files[0].name);
                                                                                        } else {
                                                                                            console.log('No avatar file selected');
                                                                                        }
                                                                                    }

                                                                                    if (!form.checkValidity()) {
                                                                                        e.preventDefault();
                                                                                        e.stopPropagation();
                                                                                        console.log('Form validation failed');
                                                                                    }
                                                                                    form.classList.add('was-validated');
                                                                                });
                                                                            });

                                                                            console.log('Profile page JavaScript initialized');
                                                                        });
                                                                        const successMessage = document.querySelector('.alert-success');
                                                                        if (successMessage && successMessage.textContent.includes('thành công')) {
                                                                            // Nếu có upload avatar mới, reload ảnh
                                                                            const profileAvatar = document.getElementById('profileAvatar');
                                                                            if (profileAvatar.hasAttribute('data-new-upload')) {
                                                                                setTimeout(() => {
                                                                                    // Force reload ảnh từ server với timestamp mới
                                                                                    const currentSrc = profileAvatar.src;
                                                                                    if (currentSrc.includes('/view/assets/images/avatars/')) {
                                                                                        const timestamp = new Date().getTime();
                                                                                        profileAvatar.src = currentSrc.split('?')[0] + '?t=' + timestamp;
                                                                                        profileAvatar.removeAttribute('data-new-upload');
                                                                                    }
                                                                                }, 500);
                                                                            }
                                                                        }
        </script>
    </body>
=======
        <!-- Host Business Info (if HOST) -->
        <c:if test="${sessionScope.user.role == 'HOST'}">
            <div class="host-info-section">
                <h4><i class="ri-building-line me-2"></i>Thông Tin Doanh Nghiệp</h4>
                <div class="host-info-grid">
                    <div class="host-info-item">
                        <div class="label">Tên doanh nghiệp</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.businessName}">
                                    ${sessionScope.user.businessName}
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="host-info-item">
                        <div class="label">Khu vực hoạt động</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${sessionScope.user.region == 'North'}">Miền Bắc</c:when>
                                <c:when test="${sessionScope.user.region == 'Central'}">Miền Trung</c:when>
                                <c:when test="${sessionScope.user.region == 'South'}">Miền Nam</c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="host-info-item">
                        <div class="label">Kỹ năng</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.skills}">
                                    ${sessionScope.user.skills}
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Profile Content -->
        <div class="profile-content">
            <!-- Sidebar -->
            <div class="profile-sidebar">
                <!-- Personal Info Card -->
                <div class="profile-card">
                    <h4><i class="ri-user-line"></i>Thông Tin Cá Nhân</h4>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="ri-phone-line"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.phone}">
                                        ${sessionScope.user.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="ri-calendar-line"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Ngày sinh</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.dateOfBirth}">
                                        <fmt:formatDate value="${sessionScope.user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="ri-user-2-line"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Giới tính</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.gender}">
                                        ${sessionScope.user.gender}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="ri-time-line"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Tham gia</div>
                            <div class="info-value">
                                <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bio Card -->
                <div class="profile-card">
                    <h4><i class="ri-information-line"></i>Giới Thiệu</h4>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.bio}">
                                ${sessionScope.user.bio}
                            </c:when>
                            <c:otherwise>
                                Người dùng chưa thêm mô tả về bản thân.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- Business Info Card (for HOST only) -->
                <c:if test="${sessionScope.user.role == 'HOST'}">
                    <div class="profile-card">
                        <h4><i class="ri-building-line"></i>Chi Tiết Doanh Nghiệp</h4>
                        
                        <c:if test="${not empty sessionScope.user.businessAddress}">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="ri-map-pin-line"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Địa chỉ</div>
                                    <div class="info-value">${sessionScope.user.businessAddress}</div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty sessionScope.user.businessDescription}">
                            <div class="mt-3">
                                <div class="info-label">Mô tả doanh nghiệp</div>
                                <p class="text-muted mb-0">${sessionScope.user.businessDescription}</p>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <!-- Main Content -->
            <div class="profile-main">
                <!-- Tabs -->
                <ul class="nav nav-tabs" id="profileTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="edit-tab" data-bs-toggle="tab" data-bs-target="#edit-pane" type="button" role="tab">
                            <i class="ri-edit-line me-2"></i>Chỉnh Sửa Hồ Sơ
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password-pane" type="button" role="tab">
                            <i class="ri-lock-line me-2"></i>Đổi Mật Khẩu
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="profileTabsContent">
                    <!-- Edit Profile Tab -->
                    <div class="tab-pane fade show active" id="edit-pane" role="tabpanel">
                        <div class="profile-card">
                            <form action="${pageContext.request.contextPath}/profile/update" method="post" enctype="multipart/form-data">
                                <!-- Basic Information Section -->
                                <h5 class="mb-4 text-primary">
                                    <i class="ri-user-line me-2"></i>Thông Tin Cơ Bản
                                </h5>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label required" for="fullName">Họ và tên</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                   value="${sessionScope.user.fullName}" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label" for="email">Email</label>
                                            <div class="email-display">
                                                <input type="email" class="form-control email-readonly" id="email" 
                                                       value="${sessionScope.user.email}" readonly>
                                                <div class="email-note">
                                                    <i class="ri-information-line me-1"></i>
                                                    <small class="text-muted">Email không thể thay đổi</small>
                                                </div>
                                            </div>
                                            <input type="hidden" name="email" value="${sessionScope.user.email}">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label" for="phone">Số điện thoại</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="${sessionScope.user.phone}">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label" for="dateOfBirth">Ngày sinh</label>
                                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                                   value="<fmt:formatDate value='${sessionScope.user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label" for="gender">Giới tính</label>
                                            <select class="form-control" id="gender" name="gender">
                                                <option value="">Chọn giới tính</option>
                                                <option value="Nam" ${sessionScope.user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                                <option value="Nữ" ${sessionScope.user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                                <option value="Khác" ${sessionScope.user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label" for="avatarFile">Ảnh đại diện</label>
                                            <input type="file" class="form-control" id="avatarFile" name="avatarFile" 
                                                   accept=".jpg,.jpeg,.png,.gif,.webp,.bmp,.tiff,.svg" onchange="previewAvatarInForm(this)">
                                            <small class="text-muted">Chọn file ảnh (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg). Tối đa 10MB.</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="bio">Giới thiệu bản thân</label>
                                    <textarea class="form-control" id="bio" name="bio" rows="4" 
                                              placeholder="Viết vài dòng giới thiệu về bản thân...">${sessionScope.user.bio}</textarea>
                                </div>

                                <!-- Host Business Information Section (only for HOST role) -->
                                <c:if test="${sessionScope.user.role == 'HOST'}">
                                    <hr class="my-4">
                                    <h5 class="mb-4 text-primary">
                                        <i class="ri-building-line me-2"></i>Thông Tin Doanh Nghiệp
                                    </h5>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label required" for="businessName">Tên doanh nghiệp</label>
                                                <input type="text" class="form-control" id="businessName" name="businessName" 
                                                       value="${sessionScope.user.businessName}" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="businessAddress">Địa chỉ kinh doanh</label>
                                        <input type="text" class="form-control" id="businessAddress" name="businessAddress" 
                                               value="${sessionScope.user.businessAddress}"
                                               placeholder="Nhập địa chỉ chi tiết của doanh nghiệp">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="businessDescription">Mô tả doanh nghiệp</label>
                                        <textarea class="form-control" id="businessDescription" name="businessDescription" rows="4" 
                                                  placeholder="Mô tả về doanh nghiệp và dịch vụ của bạn...">${sessionScope.user.businessDescription}</textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label required" for="region">Khu vực hoạt động</label>
                                                <select class="form-control" id="region" name="region" required>
                                                    <option value="">Chọn khu vực</option>
                                                    <option value="North" ${sessionScope.user.region == 'North' ? 'selected' : ''}>Miền Bắc</option>
                                                    <option value="Central" ${sessionScope.user.region == 'Central' ? 'selected' : ''}>Miền Trung</option>
                                                    <option value="South" ${sessionScope.user.region == 'South' ? 'selected' : ''}>Miền Nam</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label" for="skills">Kỹ năng & Chuyên môn</label>
                                                <input type="text" class="form-control" id="skills" name="skills" 
                                                       value="${sessionScope.user.skills}"
                                                       placeholder="VD: Hướng dẫn viên, Nấu ăn, Nhiếp ảnh...">
                                                <small class="text-muted">Liệt kê các kỹ năng của bạn, phân cách bằng dấu phẩy</small>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="d-flex gap-3 mt-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="ri-save-line me-2"></i>Lưu Thay Đổi
                                    </button>
                                    <button type="reset" class="btn btn-outline-secondary">
                                        <i class="ri-refresh-line me-2"></i>Khôi Phục
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Change Password Tab -->
                    <div class="tab-pane fade" id="password-pane" role="tabpanel">
                        <div class="profile-card">
                            <h5 class="mb-4 text-primary">
                                <i class="ri-lock-line me-2"></i>Đổi Mật Khẩu
                            </h5>
                            
                            <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                                <div class="form-group">
                                    <label class="form-label required" for="currentPassword">Mật khẩu hiện tại</label>
                                    <div class="password-field position-relative">
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                            <i class="ri-eye-line" id="currentPasswordIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="newPassword">Mật khẩu mới</label>
                                    <div class="password-field position-relative">
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                               minlength="6" required>
                                        <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                            <i class="ri-eye-line" id="newPasswordIcon"></i>
                                        </button>
                                    </div>
                                    <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="confirmPassword">Xác nhận mật khẩu mới</label>
                                    <div class="password-field position-relative">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               minlength="6" required>
                                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                            <i class="ri-eye-line" id="confirmPasswordIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary">
                                    <i class="ri-lock-unlock-line me-2"></i>Đổi Mật Khẩu
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password toggle functionality
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(fieldId + 'Icon');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('ri-eye-line');
                icon.classList.add('ri-eye-off-line');
            } else {
                field.type = 'password';
                icon.classList.remove('ri-eye-off-line');
                icon.classList.add('ri-eye-line');
            }
        }

        // Preview avatar from header button
        function updateAvatar(inputElement) {
            console.log('updateAvatar called from header button');
            if (inputElement.files && inputElement.files[0]) {
                const file = inputElement.files[0];
                console.log('File selected:', file.name, file.size, 'bytes');
                
                const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 
                                        'image/bmp', 'image/tiff', 'image/svg+xml'];
                
                if (validImageTypes.includes(file.type)) {
                    // Check file size (10MB max)
                    if (file.size > 10 * 1024 * 1024) {
                        alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
                        inputElement.value = '';
                        return;
                    }
                    
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const profileAvatar = document.getElementById('profileAvatar');
                        profileAvatar.src = e.target.result;
                        console.log('Avatar preview updated');
                        profileAvatar.setAttribute('data-new-upload', 'true');
                    };
                    reader.readAsDataURL(file);
                    
                    // Đồng bộ với form input
                    const formInput = document.getElementById('avatarFile');
                    if (formInput && inputElement.id !== 'avatarFile') {
                        const dt = new DataTransfer();
                        dt.items.add(file);
                        formInput.files = dt.files;
                        console.log('Form input synced');
                    }
                } else {
                    alert('Vui lòng chọn file ảnh hợp lệ (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg).');
                    inputElement.value = '';
                }
            }
        }

        // Preview avatar from form input
        function previewAvatarInForm(inputElement) {
            console.log('previewAvatarInForm called from form input');
            if (inputElement.files && inputElement.files[0]) {
                const file = inputElement.files[0];
                console.log('File selected:', file.name, file.size, 'bytes');
                
                const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 
                                        'image/bmp', 'image/tiff', 'image/svg+xml'];
                
                if (validImageTypes.includes(file.type)) {
                    if (file.size > 10 * 1024 * 1024) {
                        alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
                        inputElement.value = '';
                        return;
                    }
                    
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const profileAvatar = document.getElementById('profileAvatar');
                        profileAvatar.src = e.target.result;
                        profileAvatar.setAttribute('data-new-upload', 'true');
                        console.log('Avatar preview updated from form');
                    };
                    reader.readAsDataURL(file);
                    
                    // Đồng bộ với header input
                    const headerInput = document.getElementById('avatarInput');
                    if (headerInput && inputElement.id !== 'avatarInput') {
                        const dt = new DataTransfer();
                        dt.items.add(file);
                        headerInput.files = dt.files;
                        console.log('Header input synced');
                    }
                } else {
                    alert('Vui lòng chọn file ảnh hợp lệ (.jpg, .jpeg, .png, .gif, .webp, .bmp, .tiff, .svg).');
                    inputElement.value = '';
                }
            }
        }

        // Password confirmation validation
        document.addEventListener('DOMContentLoaded', function() {
            const confirmPasswordInput = document.getElementById('confirmPassword');
            if (confirmPasswordInput) {
                confirmPasswordInput.addEventListener('input', function() {
                    const password = document.getElementById('newPassword').value;
                    const confirmPassword = this.value;
                    
                    if (password !== confirmPassword) {
                        this.setCustomValidity('Mật khẩu xác nhận không khớp');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }

            // Form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    console.log('Form submitted:', form.action);
                    
                    // Validate required fields for HOST
                    if (form.action.includes('/profile/update')) {
                        const userRole = '${sessionScope.user.role}';
                        if (userRole === 'HOST') {
                            const businessName = document.getElementById('businessName').value.trim();
                            const businessType = document.getElementById('businessType').value;
                            const region = document.getElementById('region').value;
                            
                            if (!businessName) {
                                alert('Vui lòng nhập tên doanh nghiệp');
                                e.preventDefault();
                                return;
                            }
                           
                            if (!region) {
                                alert('Vui lòng chọn khu vực hoạt động');
                                e.preventDefault();
                                return;
                            }
                        }
                        
                        const avatarFile = document.getElementById('avatarFile');
                        if (avatarFile && avatarFile.files.length > 0) {
                            console.log('Avatar file will be uploaded:', avatarFile.files[0].name);
                        } else {
                            console.log('No avatar file selected');
                        }
                    }
                    
                    if (!form.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                        console.log('Form validation failed');
                    }
                    form.classList.add('was-validated');
                });
            });
            
            console.log('Profile page JavaScript initialized');
            
            // Handle success message and avatar reload
            const successMessage = document.querySelector('.alert-success');
            if (successMessage && successMessage.textContent.includes('thành công')) {
                // Nếu có upload avatar mới, reload ảnh
                const profileAvatar = document.getElementById('profileAvatar');
                if (profileAvatar.hasAttribute('data-new-upload')) {
                    setTimeout(() => {
                        // Force reload ảnh từ server với timestamp mới
                        const currentSrc = profileAvatar.src;
                        if (currentSrc.includes('/images/avatars/')) {
                            const timestamp = new Date().getTime();
                            profileAvatar.src = currentSrc.split('?')[0] + '?t=' + timestamp;
                            profileAvatar.removeAttribute('data-new-upload');
                        }
                    }, 500);
                }
            }
        });
    </script>
</body>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</html>
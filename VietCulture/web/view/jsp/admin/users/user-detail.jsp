<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết người dùng - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .profile-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 10px;
                padding: 2rem;
                margin-bottom: 2rem;
            }
            .profile-avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                border: 4px solid rgba(255,255,255,0.3);
                object-fit: cover;
            }
            .info-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
            .status-badge {
                font-size: 0.875rem;
                padding: 0.375rem 0.75rem;
                border-radius: 20px;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .action-buttons {
                position: sticky;
                top: 20px;
            }
            .stat-item {
                text-align: center;
                padding: 1rem;
                border-radius: 8px;
                background: #f8f9fa;
                margin-bottom: 1rem;
            }
            .stat-number {
                font-size: 2rem;
                font-weight: bold;
                color: #495057;
            }
            .stat-label {
                color: #6c757d;
                font-size: 0.875rem;
            }
        </style>
    </head>
    <body style="background-color: #f8f9fa;">
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container-fluid">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i>Admin Panel
                </a>
                <div class="navbar-nav ms-auto">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
        </nav>

        <div class="container-fluid py-4">
            <div class="row">
                <!-- Main Content -->
                <div class="col-lg-8">
                    <!-- Profile Header -->
                    <div class="profile-header">
                        <div class="d-flex align-items-center">
                            <img src="${not empty user.avatar ? user.avatar : '/assets/images/default-avatar.png'}" 
                                 alt="Avatar" class="profile-avatar me-4">
                            <div>
                                <h2 class="mb-2">${user.fullName}</h2>
                                <p class="mb-2">
                                    <i class="fas fa-envelope me-2"></i>${user.email}
                                </p>
                                <div class="d-flex align-items-center">
                                    <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'} me-3">
                                        <i class="fas ${user.active ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                        ${user.active ? 'Hoạt động' : 'Bị khóa'}
                                    </span>
                                    <span class="status-badge ${user.emailVerified ? 'status-active' : 'status-pending'}">
                                        <i class="fas ${user.emailVerified ? 'fa-shield-check' : 'fa-exclamation-triangle'} me-1"></i>
                                        ${user.emailVerified ? 'Đã xác thực' : 'Chưa xác thực'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="info-card">
                        <h5 class="card-title mb-3">
                            <i class="fas fa-user me-2 text-primary"></i>Thông tin cơ bản
                        </h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">Họ và tên</label>
                                    <p class="fw-medium">${user.fullName}</p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Email</label>
                                    <p class="fw-medium">${user.email}</p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Số điện thoại</label>
                                    <p class="fw-medium">${not empty user.phone ? user.phone : 'Chưa cập nhật'}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">Loại tài khoản</label>
                                    <p class="fw-medium">
                                        <span class="badge bg-info">${user.role}</span>
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Giới tính</label>
                                    <p class="fw-medium">${not empty user.gender ? user.gender : 'Chưa cập nhật'}</p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Ngày sinh</label>
                                    <p class="fw-medium">
                                        <c:choose>
                                            <c:when test="${not empty user.dateOfBirth}">
                                                <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <c:if test="${not empty user.bio}">
                            <div class="mb-3">
                                <label class="form-label text-muted">Giới thiệu</label>
                                <p class="fw-medium">${user.bio}</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Account Information -->
                    <div class="info-card">
                        <h5 class="card-title mb-3">
                            <i class="fas fa-shield-alt me-2 text-primary"></i>Thông tin tài khoản
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Configuration
        var CONFIG = {
            contextPath: '${pageContext.request.contextPath}',
            currentUserId: '${sessionScope.user.userId}',
            debug: true
        };

        // Utility functions
        var Utils = {
            log: function() {
                if (CONFIG.debug) {
                    var args = Array.prototype.slice.call(arguments);
                    console.log.apply(console, ['[UserManager]'].concat(args));
                }
            },
            
            error: function() {
                var args = Array.prototype.slice.call(arguments);
                console.error.apply(console, ['[UserManager]'].concat(args));
            },

            showAlert: function(type, message) {
                let iconClass = 'info-circle';
                if (type === 'success') {
                    iconClass = 'check-circle';
                } else if (type === 'danger') {
                    iconClass = 'exclamation-circle';
                } else if (type === 'warning') {
                    iconClass = 'exclamation-triangle';
                }
                
                var alertHtml = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                    '<i class="fas fa-' + iconClass + ' me-2"></i>' +
                    message +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                    '</div>';
                $('#alertContainer').prepend(alertHtml);
                
                // Auto dismiss after 5 seconds
                setTimeout(() => {
                    $('#alertContainer .alert:first').alert('close');
                }, 5000);
            },

            makeRequest: function(url, options) {
                if (typeof options === 'undefined') options = {};
                var self = this;
                self.log('Making request to:', url, 'with options:', options);
                
                var headers = {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                };
                
                if (options.headers) {
                    for (var key in options.headers) {
                        headers[key] = options.headers[key];
                    }
                }
                
                var fetchOptions = {
                    headers: headers,
                    credentials: 'same-origin'  // Include session cookies
                };
                
                for (var key in options) {
                    if (key !== 'headers') {
                        fetchOptions[key] = options[key];
                    }
                }
                
                // Add timeout to prevent hanging
                var timeoutPromise = new Promise(function(resolve, reject) {
                    setTimeout(function() {
                        reject(new Error('Request timeout after 30 seconds'));
                    }, 30000);
                });
                
                var fetchPromise = fetch(url, fetchOptions).then(function(response) {
                    self.log('Response received:', response.status, response.statusText);
                    
                    if (!response.ok) {
                        self.error('HTTP Error:', response.status, response.statusText);
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }

                    var contentType = response.headers.get('content-type');
                    self.log('Response content type:', contentType);
                    
                    if (contentType && contentType.includes('application/json')) {
                        return response.json().then(function(data) {
                            self.log('JSON response data:', data);
                            return data;
                        });
                    } else {
                        return response.text().then(function(text) {
                            self.log('Text response:', text);
                            // Check if response is actually JSON even if header is wrong
                            try {
                                var jsonData = JSON.parse(text);
                                self.log('Parsed JSON from text response:', jsonData);
                                return jsonData;
                            } catch (e) {
                                // Not JSON, return success for non-JSON responses
                                return { success: true, message: 'Thao tác thành công' };
                            }
                        });
                    }
                });
                
                return Promise.race([fetchPromise, timeoutPromise])
                    .catch(function(error) {
                        self.error('Request failed:', error);
                        if (error.message.includes('timeout')) {
                            throw new Error('Request bị timeout. Vui lòng kiểm tra kết nối mạng.');
                        }
                        throw error;
                    });
            },

            updateUserStatus: function(isActive) {
                var statusBadge = document.querySelector('.status-badge');
                if (isActive) {
                    statusBadge.className = 'status-badge status-active me-3';
                    statusBadge.innerHTML = '<i class="fas fa-check-circle me-1"></i>Hoạt động';
                    
                    // Update lock button
                    var lockBtn = document.querySelector('#lockBtn');
                    lockBtn.className = 'btn btn-warning me-2';
                    lockBtn.innerHTML = '<i class="fas fa-lock me-1"></i>Khóa tài khoản';
                    lockBtn.onclick = function() { UserManager.lockUser('${user.userId}', '${user.fullName}'); };
                } else {
                    statusBadge.className = 'status-badge status-inactive me-3';
                    statusBadge.innerHTML = '<i class="fas fa-times-circle me-1"></i>Bị khóa';
                    
                    // Update unlock button
                    var lockBtn = document.querySelector('#lockBtn');
                    lockBtn.className = 'btn btn-success me-2';
                    lockBtn.innerHTML = '<i class="fas fa-unlock me-1"></i>Mở khóa tài khoản';
                    lockBtn.onclick = function() { UserManager.unlockUser('${user.userId}', '${user.fullName}'); };
                }
            }
        };

        // User Management Functions
        var UserManager = {
            lockUser: function(userId, userName) {
                Utils.log('Locking user:', userId, userName);
                
                try {
                    const nameElement = document.getElementById('lockUserName');
                    const formElement = document.getElementById('lockUserForm');
                    const modalElement = document.getElementById('lockUserModal');
                    
                    if (!nameElement || !formElement || !modalElement) {
                        throw new Error('Modal elements not found');
                    }
                    
                    nameElement.textContent = userName;
                    formElement.action = CONFIG.contextPath + '/admin/users/' + userId + '/lock';
                    formElement.querySelector('textarea[name="reason"]').value = '';
                    
                    const modal = new bootstrap.Modal(modalElement);
                    modal.show();
                } catch (error) {
                    Utils.error('Error in lockUser:', error);
                    Utils.showAlert('danger', 'Có lỗi xảy ra khi mở form khóa tài khoản');
                }
            },

            unlockUser: async function(userId, userName) {
                Utils.log('Unlocking user:', userId, userName);
                
                if (!confirm('Bạn có chắc chắn muốn mở khóa tài khoản "' + userName + '"?')) {
                    return;
                }
                
                try {
                    var url = CONFIG.contextPath + '/admin/users/' + userId + '/unlock';
                    const result = await Utils.makeRequest(url, { 
                        method: 'POST'
                    });
                    
                    if (result.success) {
                        Utils.showAlert('success', 'Mở khóa tài khoản thành công!');
                        Utils.updateUserStatus(true);
                    } else {
                        Utils.showAlert('danger', result.message || 'Có lỗi xảy ra khi mở khóa tài khoản');
                    }
                } catch (error) {
                    Utils.error('Error unlocking user:', error);
                    Utils.showAlert('danger', 'Có lỗi xảy ra khi mở khóa tài khoản');
                }
            }
        };

        // Form handlers
        const FormHandlers = {
            handleLockUser: async function(form) {
                const reasonField = form.querySelector('textarea[name="reason"]');
                
                // Validate reason
                reasonField.classList.remove('is-invalid');
                if (!reasonField.value.trim()) {
                    reasonField.classList.add('is-invalid');
                    const feedback = reasonField.parentNode.querySelector('.invalid-feedback');
                    if (feedback) feedback.textContent = 'Vui lòng nhập lý do khóa tài khoản';
                    return false;
                }

                try {
                    const formData = new FormData(form);
                    // Convert FormData to JSON for proper handling
                    const data = {};
                    formData.forEach((value, key) => {
                        data[key] = value;
                    });
                    
                    const result = await Utils.makeRequest(form.action, {
                        method: 'POST',
                        body: JSON.stringify(data),
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    });

                    if (result.success) {
                        Utils.showAlert('success', 'Khóa tài khoản thành công!');
                        const modal = bootstrap.Modal.getInstance(document.getElementById('lockUserModal'));
                        if (modal) modal.hide();
                        
                        Utils.updateUserStatus(false);
                    } else {
                        Utils.showAlert('danger', result.message || 'Có lỗi xảy ra khi khóa tài khoản');
                    }
                } catch (error) {
                    Utils.error('Error locking user:', error);
                    Utils.showAlert('danger', 'Có lỗi xảy ra khi khóa tài khoản');
                }
                
                return false;
            }
        };

        function verifyEmail(userId) {
            showConfirm('Xác thực email cho người dùng này?', () => {
                fetch(`${CONFIG.contextPath}/admin/users/${userId}/verify-email`, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        Utils.showAlert('success', data.message);
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        Utils.showAlert('danger', data.message);
                    }
                });
            });
        }

        function showConfirm(message, callback) {
            document.getElementById('confirmMessage').textContent = message;
            const modal = new bootstrap.Modal(document.getElementById('confirmModal'));
            
            document.getElementById('confirmButton').onclick = () => {
                modal.hide();
                callback();
            };
            
            modal.show();
        }

        // Initialize everything when document is ready
        $(document).ready(function() {
            Utils.log('Initializing User Detail Page');
            Utils.log('Context Path:', CONFIG.contextPath);
            Utils.log('Current User ID:', CONFIG.currentUserId);

            // Initialize form handlers
            document.getElementById('lockUserForm').onsubmit = function(e) {
                e.preventDefault();
                FormHandlers.handleLockUser(this);
            };
        });
    </script>
    <style>
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            object-fit: cover;
        }
        .info-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .status-badge {
            font-size: 0.875rem;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .action-buttons {
            position: sticky;
            top: 20px;
        }
        .profile-header {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border-left: 4px solid #667eea;
        }
        .stat-item {
            text-align: center;
            padding: 1rem;
            border-radius: 8px;
            background: #f8f9fa;
            margin-bottom: 1rem;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #495057;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.875rem;
        }
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
        .btn-group .btn {
            border-radius: 0.25rem !important;
            margin-right: 2px;
        }
        @media (max-width: 768px) {
            .btn-group {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar -->
            <%@ include file="../includes/admin-sidebar.jsp" %>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 admin-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-user-circle me-2"></i>Chi tiết người dùng</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Alert Container -->
                <div id="alertContainer"></div>

                <div class="row">
                    <!-- Main Content -->
                    <div class="col-lg-8">
                        <!-- Profile Header -->
                        <div class="profile-header">
                            <div class="d-flex align-items-center">
<<<<<<< HEAD
                                <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'} me-3">
                                    <i class="fas ${user.active ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                    ${user.active ? 'Hoạt động' : 'Bị khóa'}
                                </span>
                                <span class="status-badge ${user.emailVerified ? 'status-active' : 'status-pending'}">
                                    <i class="fas ${user.emailVerified ? 'fa-shield-check' : 'fa-exclamation-triangle'} me-1"></i>
                                    ${user.emailVerified ? 'Đã xác thực' : 'Chưa xác thực'}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Basic Information -->
                <div class="info-card">
                    <h5 class="card-title mb-3">
                        <i class="fas fa-user me-2 text-primary"></i>Thông tin cơ bản
                    </h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted">Họ và tên</label>
                                <p class="fw-medium">${user.fullName}</p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted">Email</label>
                                <p class="fw-medium">${user.email}</p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted">Số điện thoại</label>
                                <p class="fw-medium">${not empty user.phone ? user.phone : 'Chưa cập nhật'}</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted">Loại tài khoản</label>
                                <p class="fw-medium">
                                    <span class="badge bg-info">${user.role}</span>
                                </p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted">Giới tính</label>
                                <p class="fw-medium">${not empty user.gender ? user.gender : 'Chưa cập nhật'}</p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted">Ngày sinh</label>
                                <p class="fw-medium">
                                    <c:choose>
                                        <c:when test="${not empty user.dateOfBirth}">
                                            <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                    <c:if test="${not empty user.bio}">
                        <div class="mb-3">
                            <label class="form-label text-muted">Giới thiệu</label>
                            <p class="fw-medium">${user.bio}</p>
                        </div>
                    </c:if>
                </div>

                <!-- Account Information -->
                <div class="info-card">
                    <h5 class="card-title mb-3">
                        <i class="fas fa-shield-alt me-2 text-primary"></i>Thông tin tài khoản
                    </h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted">Ngày tạo</label>
                                <p class="fw-medium">
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted">Nhà cung cấp đăng nhập</label>
                                <p class="fw-medium">
                                    <c:choose>
                                        <c:when test="${user.provider == 'google'}">
                                            <i class="fab fa-google text-danger me-1"></i>Google
                                        </c:when>
                                        <c:when test="${user.provider == 'both'}">
                                            <i class="fas fa-user me-1"></i>Local + 
                                            <i class="fab fa-google text-danger me-1"></i>Google
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user me-1"></i>Hệ thống nội bộ
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label text-muted">Trạng thái xác thực</label>
                                <p class="fw-medium">
                                    <c:choose>
                                        <c:when test="${user.emailVerified}">
                                            <span class="text-success">
                                                <i class="fas fa-check-circle me-1"></i>Đã xác thực
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-warning">
                                                <i class="fas fa-exclamation-circle me-1"></i>Chưa xác thực
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <c:if test="${not empty user.googleId}">
                                <div class="mb-3">
                                    <label class="form-label text-muted">Google ID</label>
                                    <p class="fw-medium font-monospace">${user.googleId}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Role Specific Information -->
                <c:if test="${user.role == 'HOST' and not empty hostInfo}">
                    <div class="info-card">
                        <h5 class="card-title mb-3">
                            <i class="fas fa-store me-2 text-primary"></i>Thông tin Host
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                        </h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
<<<<<<< HEAD
                                    <label class="form-label text-muted">Ngày tạo</label>
                                    <p class="fw-medium">
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Nhà cung cấp đăng nhập</label>
                                    <p class="fw-medium">
                                        <c:choose>
                                            <c:when test="${user.provider == 'google'}">
                                                <i class="fab fa-google text-danger me-1"></i>Google
                                            </c:when>
                                            <c:when test="${user.provider == 'both'}">
                                                <i class="fas fa-user me-1"></i>Local + 
                                                <i class="fab fa-google text-danger me-1"></i>Google
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-user me-1"></i>Hệ thống nội bộ
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
=======
                                    <label class="form-label text-muted">Tên doanh nghiệp</label>
                                    <p class="fw-medium">${not empty hostInfo.businessName ? hostInfo.businessName : 'Chưa cập nhật'}</p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted">Loại hình kinh doanh</label>
                                    <p class="fw-medium">${not empty hostInfo.businessType ? hostInfo.businessType : 'Chưa cập nhật'}</p>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
<<<<<<< HEAD
                                    <label class="form-label text-muted">Trạng thái xác thực</label>
                                    <p class="fw-medium">
                                        <c:choose>
                                            <c:when test="${user.emailVerified}">
                                                <span class="text-success">
                                                    <i class="fas fa-check-circle me-1"></i>Đã xác thực
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-warning">
                                                    <i class="fas fa-exclamation-circle me-1"></i>Chưa xác thực
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:if test="${not empty user.googleId}">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Google ID</label>
                                        <p class="fw-medium font-monospace">${user.googleId}</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Role Specific Information -->
                    <c:if test="${user.role == 'HOST' and not empty hostInfo}">
                        <div class="info-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-store me-2 text-primary"></i>Thông tin Host
                            </h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Tên doanh nghiệp</label>
                                        <p class="fw-medium">${not empty hostInfo.businessName ? hostInfo.businessName : 'Chưa cập nhật'}</p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Loại hình kinh doanh</label>
                                        <p class="fw-medium">${not empty hostInfo.businessType ? hostInfo.businessType : 'Chưa cập nhật'}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Đánh giá trung bình</label>
                                        <p class="fw-medium">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= hostInfo.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                            </c:forEach>
                                            (${hostInfo.averageRating}/5)
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Tổng trải nghiệm</label>
                                        <p class="fw-medium">${hostInfo.totalExperiences} trải nghiệm</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${user.role == 'TRAVELER' and not empty travelerInfo}">
                        <div class="info-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-suitcase me-2 text-primary"></i>Thông tin Traveler
                            </h5>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Sở thích</label>
                                        <p class="fw-medium">${not empty travelerInfo.preferences ? travelerInfo.preferences : 'Chưa cập nhật sở thích'}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Sidebar Actions -->
                <div class="col-lg-4">
                    <div class="action-buttons">
                        <!-- Quick Stats -->
                        <div class="info-card">
                            <h6 class="card-title mb-3">Thống kê nhanh</h6>
                            <div class="stat-item">
                                <div class="stat-number">12</div>
                                <div class="stat-label">Booking đã tạo</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">5</div>
                                <div class="stat-label">Trải nghiệm</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">4.8</div>
                                <div class="stat-label">Đánh giá TB</div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="info-card">
                            <h6 class="card-title mb-3">Hành động</h6>
                            <div class="d-grid gap-2">
                                <button type="button" class="btn btn-outline-primary" onclick="editUser(${user.userId})">
                                    <i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin
                                </button>

                                <c:choose>
                                    <c:when test="${user.active}">
                                        <button type="button" class="btn btn-outline-warning" onclick="lockUser(${user.userId})">
                                            <i class="fas fa-lock me-2"></i>Khóa tài khoản
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-outline-success" onclick="unlockUser(${user.userId})">
                                            <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                                        </button>
                                    </c:otherwise>
                                </c:choose>

                                <a href="${pageContext.request.contextPath}/admin/users/${user.userId}/permissions" 
                                   class="btn btn-outline-info">
                                    <i class="fas fa-user-shield me-2"></i>Quản lý quyền
                                </a>

                                <c:if test="${not user.emailVerified}">
                                    <button type="button" class="btn btn-outline-success" onclick="verifyEmail(${user.userId})">
                                        <i class="fas fa-check-circle me-2"></i>Xác thực email
                                    </button>
                                </c:if>

                                <button type="button" class="btn btn-outline-secondary" onclick="resetPassword(${user.userId})">
                                    <i class="fas fa-key me-2"></i>Đặt lại mật khẩu
                                </button>

                                <hr>

                                <button type="button" class="btn btn-outline-danger" onclick="deleteUser(${user.userId})">
                                    <i class="fas fa-trash me-2"></i>Xóa tài khoản
                                </button>
                            </div>
                        </div>

                        <!-- Recent Activity -->
                        <div class="info-card">
                            <h6 class="card-title mb-3">Hoạt động gần đây</h6>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item border-0 px-0">
                                    <small class="text-muted">2 giờ trước</small>
                                    <div>Đăng nhập vào hệ thống</div>
                                </div>
                                <div class="list-group-item border-0 px-0">
                                    <small class="text-muted">1 ngày trước</small>
                                    <div>Cập nhật thông tin cá nhân</div>
                                </div>
                                <div class="list-group-item border-0 px-0">
                                    <small class="text-muted">3 ngày trước</small>
                                    <div>Tạo booking mới</div>
                                </div>
=======
                                    <label class="form-label text-muted">Đánh giá trung bình</label>
                                    <p class="fw-medium">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= hostInfo.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                        </c:forEach>
                                        (${hostInfo.averageRating}/5)
=======
                                <c:choose>
                                    <c:when test="${not empty user.avatar and user.avatar ne 'default-avatar.png'}">
                                        <img src="${pageContext.request.contextPath}/view/assets/images/avatars/${user.avatar}" 
                                             alt="Avatar" class="user-avatar me-4"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="user-avatar bg-secondary d-none align-items-center justify-content-center me-4">
                                            <i class="fas fa-user text-white fa-2x"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar bg-secondary d-flex align-items-center justify-content-center me-4">
                                            <i class="fas fa-user text-white fa-2x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h2 class="mb-2 text-dark">${user.fullName}</h2>
                                    <p class="mb-2 text-muted">
                                        <i class="fas fa-envelope me-2"></i>${user.email}
>>>>>>> 723a1e4b1bf821e41f6ddab3c60ad275e22095e7
                                    </p>
                                    <div class="d-flex align-items-center">
                                        <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'} me-3">
                                            <i class="fas ${user.active ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                            ${user.active ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                        <span class="status-badge ${user.emailVerified ? 'status-active' : 'status-pending'}">
                                            <i class="fas ${user.emailVerified ? 'fa-shield-check' : 'fa-exclamation-triangle'} me-1"></i>
                                            ${user.emailVerified ? 'Đã xác thực' : 'Chưa xác thực'}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Basic Information -->
                        <div class="info-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-user me-2 text-primary"></i>Thông tin cơ bản
                            </h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Họ và tên</label>
                                        <p class="fw-medium">${user.fullName}</p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Email</label>
                                        <p class="fw-medium">${user.email}</p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Số điện thoại</label>
                                        <p class="fw-medium">${not empty user.phone ? user.phone : 'Chưa cập nhật'}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Loại tài khoản</label>
                                        <p class="fw-medium">
                                            <c:choose>
                                                <c:when test="${user.role == 'ADMIN'}">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-crown me-1"></i>Admin
                                                    </span>
                                                </c:when>
                                                <c:when test="${user.role == 'HOST'}">
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-home me-1"></i>Host
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info">
                                                        <i class="fas fa-user me-1"></i>Traveler
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Ngày tạo</label>
                                        <p class="fw-medium">
                                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar -->
                    <div class="col-lg-4">
                        <!-- Action Buttons -->
                        <div class="info-card action-buttons">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-cog me-2 text-primary"></i>Thao tác
                            </h5>
                            <div class="d-grid gap-2">
                                <c:if test="${!user.emailVerified}">
                                    <button type="button" class="btn btn-primary" onclick="verifyEmail('${user.userId}')">
                                        <i class="fas fa-check-circle me-1"></i>Xác thực email
                                    </button>
                                </c:if>
                                
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <button type="button" id="lockBtn" class="btn btn-warning" onclick="UserManager.lockUser('${user.userId}', '${user.fullName}')">
                                            <i class="fas fa-lock me-1"></i>Khóa tài khoản
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" id="lockBtn" class="btn btn-success" onclick="UserManager.unlockUser('${user.userId}', '${user.fullName}')">
                                            <i class="fas fa-unlock me-1"></i>Mở khóa tài khoản
                                        </button>
                                    </c:otherwise>
                                </c:choose>

<<<<<<< HEAD
                            <a href="${pageContext.request.contextPath}/admin/users/${user.userId}/permissions" 
                               class="btn btn-outline-info">
                                <i class="fas fa-user-shield me-2"></i>Quản lý quyền
                            </a>

                            <c:if test="${not user.emailVerified}">
                                <button type="button" class="btn btn-outline-success" onclick="verifyEmail(${user.userId})">
                                    <i class="fas fa-check-circle me-2"></i>Xác thực email
                                </button>
                            </c:if>

                            <button type="button" class="btn btn-outline-secondary" onclick="resetPassword(${user.userId})">
                                <i class="fas fa-key me-2"></i>Đặt lại mật khẩu
                            </button>

                            <hr>

                            <button type="button" class="btn btn-outline-danger" onclick="deleteUser(${user.userId})">
                                <i class="fas fa-trash me-2"></i>Xóa tài khoản
                            </button>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="info-card">
                        <h6 class="card-title mb-3">Hoạt động gần đây</h6>
                        <div class="list-group list-group-flush">
                            <div class="list-group-item border-0 px-0">
                                <small class="text-muted">2 giờ trước</small>
                                <div>Đăng nhập vào hệ thống</div>
                            </div>
                            <div class="list-group-item border-0 px-0">
                                <small class="text-muted">1 ngày trước</small>
                                <div>Cập nhật thông tin cá nhân</div>
                            </div>
                            <div class="list-group-item border-0 px-0">
                                <small class="text-muted">3 ngày trước</small>
                                <div>Tạo booking mới</div>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
=======
                                <a href="${pageContext.request.contextPath}/admin/users/${user.userId}/permissions" 
                                   class="btn btn-info">
                                    <i class="fas fa-key me-1"></i>Phân quyền
                                </a>
>>>>>>> 723a1e4b1bf821e41f6ddab3c60ad275e22095e7
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Lock User Modal -->
    <div class="modal fade" id="lockUserModal" tabindex="-1" aria-labelledby="lockUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="lockUserModalLabel">
                        <i class="fas fa-lock me-2"></i>Khóa tài khoản
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="lockUserForm" method="POST">
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Bạn có chắc chắn muốn khóa tài khoản <strong id="lockUserName"></strong>?
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Lý do khóa <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="3" required 
                                      placeholder="Nhập lý do khóa tài khoản..." maxlength="500"></textarea>
                            <div class="form-text">Tối đa 500 ký tự</div>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-warning" id="lockUserSubmitBtn">
                            <i class="fas fa-lock me-1"></i>Khóa tài khoản
                        </button>
                    </div>
                </form>
            </div>
        </div>
<<<<<<< HEAD

        <!-- Confirmation Modals -->
        <div class="modal fade" id="confirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p id="confirmMessage"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    let currentAction = null;
                                    let currentUserId = null;

                                    function lockUser(userId) {
                                        const reason = prompt('Nhập lý do khóa tài khoản:');
                                        if (reason && reason.trim()) {
                                            fetch(`${contextPath}/admin/users/${userId}/lock`, {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                },
                                                body: `reason=${encodeURIComponent(reason)}`
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showAlert('success', data.message);
                                                            setTimeout(() => location.reload(), 1500);
                                                        } else {
                                                            showAlert('danger', data.message);
                                                        }
                                                    })
                                                    .catch(error => {
                                                        showAlert('danger', 'Có lỗi xảy ra!');
                                                    });
                                        }
                                    }

                                    function unlockUser(userId) {
                                        showConfirm('Bạn có chắc muốn mở khóa tài khoản này?', () => {
                                            fetch(`${contextPath}/admin/users/${userId}/unlock`, {
                                                method: 'POST'
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showAlert('success', data.message);
                                                            setTimeout(() => location.reload(), 1500);
                                                        } else {
                                                            showAlert('danger', data.message);
                                                        }
                                                    });
                                        });
                                    }

                                    function deleteUser(userId) {
                                        showConfirm('Bạn có chắc muốn xóa tài khoản này? Hành động này không thể hoàn tác!', () => {
                                            fetch(`${contextPath}/admin/users/${userId}/delete`, {
                                                method: 'DELETE'
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showAlert('success', data.message);
                                                            setTimeout(() => {
                                                                window.location.href = '${pageContext.request.contextPath}/admin/users';
                                                            }, 1500);
                                                        } else {
                                                            showAlert('danger', data.message);
                                                        }
                                                    });
                                        });
                                    }

                                    function editUser(userId) {
                                        // Redirect to edit page or open edit modal
                                        window.location.href = `${contextPath}/admin/users/${userId}/edit`;
                                    }

                                    function verifyEmail(userId) {
                                        showConfirm('Xác thực email cho người dùng này?', () => {
                                            fetch(`${contextPath}/admin/users/${userId}/verify-email`, {
                                                method: 'POST'
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showAlert('success', data.message);
                                                            setTimeout(() => location.reload(), 1500);
                                                        } else {
                                                            showAlert('danger', data.message);
                                                        }
                                                    });
                                        });
                                    }

                                    function resetPassword(userId) {
                                        showConfirm('Đặt lại mật khẩu cho người dùng này? Mật khẩu mới sẽ được gửi qua email.', () => {
                                            fetch(`${contextPath}/admin/users/${userId}/reset-password`, {
                                                method: 'POST'
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            showAlert('success', data.message);
                                                        } else {
                                                            showAlert('danger', data.message);
                                                        }
                                                    });
                                        });
                                    }

                                    function showConfirm(message, callback) {
                                        document.getElementById('confirmMessage').textContent = message;
                                        const modal = new bootstrap.Modal(document.getElementById('confirmModal'));

                                        document.getElementById('confirmButton').onclick = () => {
                                            modal.hide();
                                            callback();
                                        };

                                        modal.show();
                                    }

                                    function showAlert(type, message) {
                                        const alertDiv = document.createElement('div');
                                        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
                                        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                                        alertDiv.innerHTML = `
            ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                                        document.body.appendChild(alertDiv);

                                        setTimeout(() => {
                                            if (alertDiv.parentNode) {
                                                alertDiv.parentNode.removeChild(alertDiv);
                                            }
                                        }, 5000);
                                    }

                                    const contextPath = '${pageContext.request.contextPath}';
        </script>
    </body>
=======
    </div>

    <!-- Confirm Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p id="confirmMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>
</body>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Khóa/Mở khóa tài khoản - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .lock-card {
                max-width: 600px;
                margin: 0 auto;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .lock-header {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                color: white;
                padding: 2rem;
                text-align: center;
            }
            .unlock-header {
                background: linear-gradient(135deg, #51cf66 0%, #40c057 100%);
                color: white;
                padding: 2rem;
                text-align: center;
            }
            .user-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                border: 4px solid rgba(255,255,255,0.3);
                object-fit: cover;
                margin-bottom: 1rem;
            }
            .lock-body {
                padding: 2rem;
            }
            .warning-box {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1.5rem;
            }
            .success-box {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1.5rem;
            }
            .user-info {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1.5rem;
            }
            .reason-textarea {
                min-height: 120px;
                resize: vertical;
            }
            .btn-danger-gradient {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                border: none;
                color: white;
            }
            .btn-danger-gradient:hover {
                background: linear-gradient(135deg, #ee5a52 0%, #ff6b6b 100%);
                color: white;
            }
            .btn-success-gradient {
                background: linear-gradient(135deg, #51cf66 0%, #40c057 100%);
                border: none;
                color: white;
            }
            .btn-success-gradient:hover {
                background: linear-gradient(135deg, #40c057 0%, #51cf66 100%);
                color: white;
            }
            .lock-history {
                max-height: 300px;
                overflow-y: auto;
            }
            .history-item {
                border-left: 3px solid #dee2e6;
                padding-left: 1rem;
                margin-bottom: 1rem;
                position: relative;
            }
            .history-item.locked {
                border-left-color: #dc3545;
            }
            .history-item.unlocked {
                border-left-color: #28a745;
            }
            .history-dot {
                position: absolute;
                left: -8px;
                top: 5px;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #dee2e6;
            }
            .history-item.locked .history-dot {
                background: #dc3545;
            }
            .history-item.unlocked .history-dot {
                background: #28a745;
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users/${user.userId}">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại chi tiết
                    </a>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <div class="lock-card">
                <!-- Header -->
                <div class="${user.active ? 'lock-header' : 'unlock-header'}">
                    <img src="${not empty user.avatar ? user.avatar : '/assets/images/default-avatar.png'}" 
                         alt="Avatar" class="user-avatar">
                    <h3 class="mb-2">
                        <c:choose>
                            <c:when test="${user.active}">
                                <i class="fas fa-lock me-2"></i>Khóa tài khoản
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                            </c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="mb-0">${user.fullName}</p>
                </div>

                <!-- Body -->
                <div class="lock-body">
                    <!-- User Information -->
                    <div class="user-info">
                        <h6 class="mb-3">Thông tin người dùng</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Email:</strong> ${user.email}</p>
                                <p><strong>Loại tài khoản:</strong> 
                                    <span class="badge bg-info">${user.role}</span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Ngày tạo:</strong> 
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                </p>
                                <p><strong>Trạng thái hiện tại:</strong> 
                                    <span class="badge ${user.active ? 'bg-success' : 'bg-danger'}">
                                        ${user.active ? 'Hoạt động' : 'Bị khóa'}
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${user.active}">
                            <!-- Lock User Form -->
                            <div class="warning-box">
                                <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                                <strong>Cảnh báo:</strong> Việc khóa tài khoản sẽ ngăn người dùng đăng nhập và sử dụng các dịch vụ.
                            </div>

                            <form id="lockUserForm" onsubmit="lockUser(event)">
                                <input type="hidden" name="userId" value="${user.userId}">

                                <div class="mb-4">
                                    <label for="lockReason" class="form-label">
                                        <i class="fas fa-clipboard-list me-2"></i>Lý do khóa tài khoản *
                                    </label>
                                    <textarea class="form-control reason-textarea" 
                                              id="lockReason" 
                                              name="reason" 
                                              placeholder="Nhập lý do chi tiết về việc khóa tài khoản..."
                                              required></textarea>
                                    <div class="form-text">
                                        Lý do này sẽ được ghi lại trong hệ thống để theo dõi.
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Các hành động kèm theo:</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="sendNotification" name="sendNotification" value="true">
                                        <label class="form-check-label" for="sendNotification">
                                            Gửi email thông báo cho người dùng
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="suspendSessions" name="suspendSessions" value="true" checked>
                                        <label class="form-check-label" for="suspendSessions">
                                            Hủy tất cả phiên đăng nhập hiện tại
                                        </label>
                                    </div>
                                </div>

                                <div class="d-flex gap-3">
                                    <button type="submit" class="btn btn-danger-gradient flex-fill">
                                        <i class="fas fa-lock me-2"></i>Khóa tài khoản
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                       class="btn btn-outline-secondary flex-fill">
                                        <i class="fas fa-times me-2"></i>Hủy bỏ
                                    </a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <!-- Unlock User Form -->
                            <div class="success-box">
                                <i class="fas fa-info-circle text-success me-2"></i>
                                <strong>Thông tin:</strong> Việc mở khóa sẽ cho phép người dùng đăng nhập và sử dụng dịch vụ trở lại.
                            </div>

                            <form id="unlockUserForm" onsubmit="unlockUser(event)">
                                <input type="hidden" name="userId" value="${user.userId}">

                                <div class="mb-4">
                                    <label for="unlockNote" class="form-label">
                                        <i class="fas fa-sticky-note me-2"></i>Ghi chú (tùy chọn)
                                    </label>
                                    <textarea class="form-control" 
                                              id="unlockNote" 
                                              name="note" 
                                              rows="3"
                                              placeholder="Ghi chú về việc mở khóa tài khoản..."></textarea>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Các hành động kèm theo:</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="sendWelcomeBack" name="sendWelcomeBack" value="true" checked>
                                        <label class="form-check-label" for="sendWelcomeBack">
                                            Gửi email chào mừng trở lại
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="resetPassword" name="resetPassword" value="true">
                                        <label class="form-check-label" for="resetPassword">
                                            Yêu cầu đổi mật khẩu khi đăng nhập lần đầu
                                        </label>
                                    </div>
                                </div>

                                <div class="d-flex gap-3">
                                    <button type="submit" class="btn btn-success-gradient flex-fill">
                                        <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                       class="btn btn-outline-secondary flex-fill">
                                        <i class="fas fa-times me-2"></i>Hủy bỏ
                                    </a>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <!-- Lock History -->
                    <div class="mt-5">
                        <h6 class="mb-3">
                            <i class="fas fa-history me-2"></i>Lịch sử khóa/mở khóa
                        </h6>
                        <div class="lock-history">
                            <!-- Sample history items - replace with actual data -->
                            <div class="history-item locked">
                                <div class="history-dot"></div>
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong class="text-danger">Đã khóa tài khoản</strong>
                                        <p class="mb-1 small text-muted">Lý do: Vi phạm điều khoản sử dụng</p>
                                        <p class="mb-0 small text-muted">Bởi: Admin (admin@example.com)</p>
                                    </div>
                                    <small class="text-muted">15/01/2024 14:30</small>
                                </div>
                            </div>

                            <div class="history-item unlocked">
                                <div class="history-dot"></div>
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong class="text-success">Đã mở khóa tài khoản</strong>
                                        <p class="mb-1 small text-muted">Ghi chú: Người dùng đã sửa chữa vi phạm</p>
                                        <p class="mb-0 small text-muted">Bởi: Admin (admin@example.com)</p>
                                    </div>
                                    <small class="text-muted">10/01/2024 09:15</small>
                                </div>
                            </div>

                            <div class="history-item locked">
                                <div class="history-dot"></div>
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong class="text-danger">Đã khóa tài khoản</strong>
                                        <p class="mb-1 small text-muted">Lý do: Hoạt động đáng ngờ</p>
                                        <p class="mb-0 small text-muted">Bởi: System (auto)</p>
                                    </div>
                                    <small class="text-muted">05/01/2024 23:45</small>
                                </div>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khóa/Mở khóa tài khoản - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .lock-card {
            max-width: 600px;
            margin: 0 auto;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .lock-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .unlock-header {
            background: linear-gradient(135deg, #51cf66 0%, #40c057 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            object-fit: cover;
            margin-bottom: 1rem;
        }
        .lock-body {
            padding: 2rem;
        }
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .success-box {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .user-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .reason-textarea {
            min-height: 120px;
            resize: vertical;
        }
        .btn-danger-gradient {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            border: none;
            color: white;
        }
        .btn-danger-gradient:hover {
            background: linear-gradient(135deg, #ee5a52 0%, #ff6b6b 100%);
            color: white;
        }
        .btn-success-gradient {
            background: linear-gradient(135deg, #51cf66 0%, #40c057 100%);
            border: none;
            color: white;
        }
        .btn-success-gradient:hover {
            background: linear-gradient(135deg, #40c057 0%, #51cf66 100%);
            color: white;
        }
        .lock-history {
            max-height: 300px;
            overflow-y: auto;
        }
        .history-item {
            border-left: 3px solid #dee2e6;
            padding-left: 1rem;
            margin-bottom: 1rem;
            position: relative;
        }
        .history-item.locked {
            border-left-color: #dc3545;
        }
        .history-item.unlocked {
            border-left-color: #28a745;
        }
        .history-dot {
            position: absolute;
            left: -8px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #dee2e6;
        }
        .history-item.locked .history-dot {
            background: #dc3545;
        }
        .history-item.unlocked .history-dot {
            background: #28a745;
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
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/users/${user.userId}">
                    <i class="fas fa-arrow-left me-1"></i>Quay lại chi tiết
                </a>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <div class="lock-card">
            <!-- Header -->
            <div class="${user.active ? 'lock-header' : 'unlock-header'}">
                <c:choose>
                    <c:when test="${not empty user.avatar and user.avatar ne 'default-avatar.png'}">
                        <img src="${pageContext.request.contextPath}/view/assets/images/avatars/${user.avatar}" 
                             alt="Avatar" class="user-avatar"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="user-avatar bg-secondary d-none align-items-center justify-content-center">
                            <i class="fas fa-user text-white"></i>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="user-avatar bg-secondary d-flex align-items-center justify-content-center">
                            <i class="fas fa-user text-white"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <h3 class="mb-2">
                    <c:choose>
                        <c:when test="${user.active}">
                            <i class="fas fa-lock me-2"></i>Khóa tài khoản
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                        </c:otherwise>
                    </c:choose>
                </h3>
                <p class="mb-0">${user.fullName}</p>
            </div>

            <!-- Body -->
            <div class="lock-body">
                <!-- User Information -->
                <div class="user-info">
                    <h6 class="mb-3">Thông tin người dùng</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Email:</strong> ${user.email}</p>
                            <p><strong>Loại tài khoản:</strong> 
                                <span class="badge bg-info">${user.role}</span>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Ngày tạo:</strong> 
                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                            </p>
                            <p><strong>Trạng thái hiện tại:</strong> 
                                <span class="badge ${user.active ? 'bg-success' : 'bg-danger'}">
                                    ${user.active ? 'Hoạt động' : 'Bị khóa'}
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${user.active}">
                        <!-- Lock User Form -->
                        <div class="warning-box">
                            <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                            <strong>Cảnh báo:</strong> Việc khóa tài khoản sẽ ngăn người dùng đăng nhập và sử dụng các dịch vụ.
                        </div>

                        <form id="lockUserForm" action="${pageContext.request.contextPath}/admin/users/${user.userId}/lock" method="POST" onsubmit="lockUser(event)">
                            <input type="hidden" name="userId" value="${user.userId}">
                            
                            <div class="mb-4">
                                <label for="lockReason" class="form-label">
                                    <i class="fas fa-clipboard-list me-2"></i>Lý do khóa tài khoản *
                                </label>
                                <textarea class="form-control reason-textarea" 
                                         id="lockReason" 
                                         name="reason" 
                                         placeholder="Nhập lý do chi tiết về việc khóa tài khoản..."
                                         required></textarea>
                                <div class="form-text">
                                    Lý do này sẽ được ghi lại trong hệ thống để theo dõi.
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Các hành động kèm theo:</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="sendNotification" name="sendNotification" value="true">
                                    <label class="form-check-label" for="sendNotification">
                                        Gửi email thông báo cho người dùng
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="suspendSessions" name="suspendSessions" value="true" checked>
                                    <label class="form-check-label" for="suspendSessions">
                                        Hủy tất cả phiên đăng nhập hiện tại
                                    </label>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-danger-gradient flex-fill">
                                    <i class="fas fa-lock me-2"></i>Khóa tài khoản
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                   class="btn btn-outline-secondary">
                                    <i class="fas fa-times me-1"></i>Hủy
                                </a>
                            </div>
                                        <i class="fas fa-lock me-1"></i>Test Simple Form Submit
                                    </button>
                                </form>
                                <small class="text-muted d-block">↑ This form submits directly without JavaScript</small>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <!-- Unlock User Form -->
                        <div class="success-box">
                            <i class="fas fa-info-circle text-success me-2"></i>
                            <strong>Thông tin:</strong> Việc mở khóa sẽ cho phép người dùng đăng nhập và sử dụng dịch vụ trở lại.
                        </div>

                        <form id="unlockUserForm" action="${pageContext.request.contextPath}/admin/users/${user.userId}/unlock" method="POST" onsubmit="unlockUser(event)">
                            <input type="hidden" name="userId" value="${user.userId}">
                            
                            <div class="mb-4">
                                <label for="unlockNote" class="form-label">
                                    <i class="fas fa-sticky-note me-2"></i>Ghi chú (tùy chọn)
                                </label>
                                <textarea class="form-control" 
                                         id="unlockNote" 
                                         name="note" 
                                         rows="3"
                                         placeholder="Ghi chú về việc mở khóa tài khoản..."></textarea>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Các hành động kèm theo:</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="sendWelcomeBack" name="sendWelcomeBack" value="true" checked>
                                    <label class="form-check-label" for="sendWelcomeBack">
                                        Gửi email chào mừng trở lại
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="resetPassword" name="resetPassword" value="true">
                                    <label class="form-check-label" for="resetPassword">
                                        Yêu cầu đổi mật khẩu khi đăng nhập lần đầu
                                    </label>
                                </div>
                            </div>

                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-success-gradient flex-fill">
                                    <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                   class="btn btn-outline-secondary flex-fill">
                                    <i class="fas fa-times me-2"></i>Hủy bỏ
                                </a>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>

                <!-- Lock History -->
                <div class="mt-5">
                    <h6 class="mb-3">
                        <i class="fas fa-history me-2"></i>Lịch sử khóa/mở khóa
                    </h6>
                    <div class="lock-history">
                        <!-- Sample history items - replace with actual data -->
                        <div class="history-item locked">
                            <div class="history-dot"></div>
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <strong class="text-danger">Đã khóa tài khoản</strong>
                                    <p class="mb-1 small text-muted">Lý do: Vi phạm điều khoản sử dụng</p>
                                    <p class="mb-0 small text-muted">Bởi: Admin (admin@example.com)</p>
                                </div>
                                <small class="text-muted">15/01/2024 14:30</small>
                            </div>
                        </div>
                        
                        <div class="history-item unlocked">
                            <div class="history-dot"></div>
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <strong class="text-success">Đã mở khóa tài khoản</strong>
                                    <p class="mb-1 small text-muted">Ghi chú: Người dùng đã sửa chữa vi phạm</p>
                                    <p class="mb-0 small text-muted">Bởi: Admin (admin@example.com)</p>
                                </div>
                                <small class="text-muted">10/01/2024 09:15</small>
                            </div>
                        </div>
                        
                        <div class="history-item locked">
                            <div class="history-dot"></div>
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <strong class="text-danger">Đã khóa tài khoản</strong>
                                    <p class="mb-1 small text-muted">Lý do: Hoạt động đáng ngờ</p>
                                    <p class="mb-0 small text-muted">Bởi: System (auto)</p>
                                </div>
                                <small class="text-muted">05/01/2024 23:45</small>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
<<<<<<< HEAD

        <!-- Loading Modal -->
        <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center py-4">
                        <div class="spinner-border text-primary mb-3" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mb-0">Đang xử lý...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận hành động</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center mb-3">
                            <i class="fas fa-exclamation-triangle text-warning fa-3x"></i>
                        </div>
                        <p id="confirmMessage" class="text-center"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                const contextPath = '${pageContext.request.contextPath}';
                                let loadingModal;
                                let confirmModal;

                                document.addEventListener('DOMContentLoaded', function () {
                                    loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
                                    confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
                                });

                                function lockUser(event) {
                                    event.preventDefault();

                                    const form = document.getElementById('lockUserForm');
                                    const formData = new FormData(form);
                                    const reason = formData.get('reason').trim();

                                    if (!reason) {
                                        showAlert('warning', 'Vui lòng nhập lý do khóa tài khoản.');
                                        return;
                                    }

                                    const message = `Bạn có chắc chắn muốn khóa tài khoản của ${form.elements.fullName ? form.elements.fullName.value : 'người dùng này'}?\n\nLý do: ${reason}`;

                                    showConfirm(message, () => {
                                        performLockAction(formData);
                                    });
                                }

                                function unlockUser(event) {
                                    event.preventDefault();

                                    const form = document.getElementById('unlockUserForm');
                                    const formData = new FormData(form);

                                    const message = `Bạn có chắc chắn muốn mở khóa tài khoản này?\n\nNgười dùng sẽ có thể đăng nhập và sử dụng dịch vụ trở lại.`;

                                    showConfirm(message, () => {
                                        performUnlockAction(formData);
                                    });
                                }

                                function performLockAction(formData) {
                                    loadingModal.show();

                                    const userId = formData.get('userId');

                                    fetch(`${contextPath}/admin/users/${userId}/lock`, {
                                        method: 'POST',
                                        body: formData
                                    })
                                            .then(response => response.json())
                                            .then(data => {
                                                loadingModal.hide();

                                                if (data.success) {
                                                    showAlert('success', data.message);
                                                    setTimeout(() => {
                                                        window.location.href = `${contextPath}/admin/users/${userId}`;
                                                                                }, 2000);
                                                                            } else {
                                                                                showAlert('danger', data.message || 'Có lỗi xảy ra khi khóa tài khoản.');
                                                                            }
                                                                        })
                                                                        .catch(error => {
                                                                            loadingModal.hide();
                                                                            console.error('Error:', error);
                                                                            showAlert('danger', 'Có lỗi xảy ra. Vui lòng thử lại.');
                                                                        });
                                                            }

                                                            function performUnlockAction(formData) {
                                                                loadingModal.show();

                                                                const userId = formData.get('userId');

                                                                fetch(`${contextPath}/admin/users/${userId}/unlock`, {
                                                                    method: 'POST',
                                                                    body: formData
                                                                })
                                                                        .then(response => response.json())
                                                                        .then(data => {
                                                                            loadingModal.hide();

                                                                            if (data.success) {
                                                                                showAlert('success', data.message);
                                                                                setTimeout(() => {
                                                                                    window.location.href = `${contextPath}/admin/users/${userId}`;
                                                                                                            }, 2000);
                                                                                                        } else {
                                                                                                            showAlert('danger', data.message || 'Có lỗi xảy ra khi mở khóa tài khoản.');
                                                                                                        }
                                                                                                    })
                                                                                                    .catch(error => {
                                                                                                        loadingModal.hide();
                                                                                                        console.error('Error:', error);
                                                                                                        showAlert('danger', 'Có lỗi xảy ra. Vui lòng thử lại.');
                                                                                                    });
                                                                                        }

                                                                                        function showConfirm(message, callback) {
                                                                                            document.getElementById('confirmMessage').textContent = message;

                                                                                            document.getElementById('confirmButton').onclick = () => {
                                                                                                confirmModal.hide();
                                                                                                callback();
                                                                                            };

                                                                                            confirmModal.show();
                                                                                        }

                                                                                        function showAlert(type, message) {
                                                                                            // Remove existing alerts
                                                                                            const existingAlerts = document.querySelectorAll('.alert');
                                                                                            existingAlerts.forEach(alert => alert.remove());

                                                                                            const alertDiv = document.createElement('div');
                                                                                            alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
                                                                                            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 350px;';
                                                                                            alertDiv.innerHTML = `
                <i class="fas ${getAlertIcon(type)} me-2"></i>
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

                                                                                        function getAlertIcon(type) {
                                                                                            switch (type) {
                                                                                                case 'success':
                                                                                                    return 'fa-check-circle';
                                                                                                case 'danger':
                                                                                                    return 'fa-exclamation-circle';
                                                                                                case 'warning':
                                                                                                    return 'fa-exclamation-triangle';
                                                                                                case 'info':
                                                                                                    return 'fa-info-circle';
                                                                                                default:
                                                                                                    return 'fa-info-circle';
                                                                                            }
                                                                                        }

                                                                                        // Auto-resize textarea
                                                                                        document.addEventListener('DOMContentLoaded', function () {
                                                                                            const textareas = document.querySelectorAll('textarea');
                                                                                            textareas.forEach(textarea => {
                                                                                                textarea.addEventListener('input', function () {
                                                                                                    this.style.height = 'auto';
                                                                                                    this.style.height = this.scrollHeight + 'px';
                                                                                                });
                                                                                            });
                                                                                        });
        </script>
    </body>
=======
    </div>

    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center py-4">
                    <div class="spinner-border text-primary mb-3" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mb-0">Đang xử lý...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận hành động</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <i class="fas fa-exclamation-triangle text-warning fa-3x"></i>
                    </div>
                    <p id="confirmMessage" class="text-center"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let loadingModal;
        let confirmModal;

        document.addEventListener('DOMContentLoaded', function() {
            loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
        });

        function lockUser(event) {
            event.preventDefault();
            console.log('lockUser function called');
            
            const form = document.getElementById('lockUserForm');
            if (!form) {
                console.error('Lock form not found');
                showAlert('danger', 'Không tìm thấy form khóa tài khoản');
                return;
            }
            
            const formData = new FormData(form);
            const reason = formData.get('reason').trim();
            
            console.log('Form data:', {
                userId: formData.get('userId'),
                reason: reason,
                action: form.action
            });
            
            if (!reason) {
                showAlert('warning', 'Vui lòng nhập lý do khóa tài khoản.');
                return;
            }
            
            const message = `Bạn có chắc chắn muốn khóa tài khoản này?\n\nLý do: ${reason}`;
            
            showConfirm(message, () => {
                performLockAction(formData);
            });
        }

        function unlockUser(event) {
            event.preventDefault();
            
            const form = document.getElementById('unlockUserForm');
            const formData = new FormData(form);
            
            const message = `Bạn có chắc chắn muốn mở khóa tài khoản này?\n\nNgười dùng sẽ có thể đăng nhập và sử dụng dịch vụ trở lại.`;
            
            showConfirm(message, () => {
                performUnlockAction(formData);
            });
        }

        function performLockAction(formData) {
            console.log('performLockAction called');
            loadingModal.show();
            
            const form = document.getElementById('lockUserForm');
            
            console.log('Making fetch request to:', form.action);
            console.log('FormData entries:');
            for (let [key, value] of formData.entries()) {
                console.log(key, value);
            }
            
            // Add timeout to fetch request
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 30000); // 30 second timeout
            
            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                signal: controller.signal
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    throw new Error('Response is not JSON format');
                }
                
                return response.json();
            })
            .then(data => {
                clearTimeout(timeoutId);
                loadingModal.hide();
                console.log('Response data:', data);
                
                if (data.success) {
                    showAlert('success', data.message);
                    setTimeout(() => {
                        const userId = document.querySelector('input[name="userId"]').value;
                        window.location.href = `${contextPath}/admin/users/${userId}`;
                    }, 2000);
                } else {
                    showAlert('danger', data.message || 'Có lỗi xảy ra khi khóa tài khoản.');
                }
            })
            .catch(error => {
                clearTimeout(timeoutId);
                loadingModal.hide();
                console.error('Lock user error:', error);
                
                if (error.name === 'AbortError') {
                    showAlert('danger', 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.');
                } else {
                    showAlert('danger', 'Có lỗi xảy ra: ' + error.message);
                }
            });
        }

        function performUnlockAction(formData) {
            console.log('performUnlockAction called');
            loadingModal.show();
            
            const form = document.getElementById('unlockUserForm');
            
            console.log('Making unlock request to:', form.action);
            console.log('FormData entries:');
            for (let [key, value] of formData.entries()) {
                console.log(key, value);
            }
            
            // Add timeout to fetch request
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 30000); // 30 second timeout
            
            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                signal: controller.signal
            })
            .then(response => {
                console.log('Unlock response status:', response.status);
                console.log('Unlock response headers:', response.headers);
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    throw new Error('Response is not JSON format');
                }
                
                return response.json();
            })
            .then(data => {
                clearTimeout(timeoutId);
                loadingModal.hide();
                console.log('Unlock response data:', data);
                
                if (data.success) {
                    showAlert('success', data.message);
                    setTimeout(() => {
                        const userId = document.querySelector('input[name="userId"]').value;
                        window.location.href = `${contextPath}/admin/users/${userId}`;
                    }, 2000);
                } else {
                    showAlert('danger', data.message || 'Có lỗi xảy ra khi mở khóa tài khoản.');
                }
            })
            .catch(error => {
                clearTimeout(timeoutId);
                loadingModal.hide();
                console.error('Unlock user error:', error);
                
                if (error.name === 'AbortError') {
                    showAlert('danger', 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.');
                } else {
                    showAlert('danger', 'Có lỗi xảy ra: ' + error.message);
                }
            });
        }

        function showConfirm(message, callback) {
            document.getElementById('confirmMessage').textContent = message;
            
            document.getElementById('confirmButton').onclick = () => {
                confirmModal.hide();
                callback();
            };
            
            confirmModal.show();
        }

        function showAlert(type, message) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert');
            existingAlerts.forEach(alert => alert.remove());
            
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 350px;';
            alertDiv.innerHTML = `
                <i class="fas ${getAlertIcon(type)} me-2"></i>
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

        function getAlertIcon(type) {
            switch(type) {
                case 'success': return 'fa-check-circle';
                case 'danger': return 'fa-exclamation-circle';
                case 'warning': return 'fa-exclamation-triangle';
                case 'info': return 'fa-info-circle';
                default: return 'fa-info-circle';
            }
        }

        // Auto-resize textarea
        document.addEventListener('DOMContentLoaded', function() {
            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = this.scrollHeight + 'px';
                });
            });
        });
    </script>
</body>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</html>
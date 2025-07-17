<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Users - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding-left: 250px;
        }
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
        }
        .status-badge {
            font-size: 0.75rem;
        }
        .action-btn {
            padding: 0.25rem 0.5rem;
            margin: 0.1rem;
        }
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
        .btn-group .btn {
            border-radius: 0.25rem !important;
            margin-right: 2px;
        }
        .table td {
            vertical-align: middle;
        }
        .pagination-info {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-top: 1rem;
        }
        
        /* Stat card styles */
        .stat-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        /* Gradient backgrounds */
        .bg-primary-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .bg-success-gradient {
            background: linear-gradient(135deg, #2dd36f 0%, #1db954 100%);
        }
        
        .bg-danger-gradient {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5253 100%);
        }
        
        .bg-warning-gradient {
            background: linear-gradient(135deg, #feca57 0%, #ff9f43 100%);
        }
        
        .bg-info-gradient {
            background: linear-gradient(135deg, #54a0ff 0%, #2e86de 100%);
        }
        
        .bg-secondary-gradient {
            background: linear-gradient(135deg, #778ca3 0%, #546e7a 100%);
        }
        
        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
        }
        
        .stat-icon::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            transition: all 0.6s ease;
            transform: translate(-50%, -50%);
        }
        
        .stat-card:hover .stat-icon::before {
            width: 100px;
            height: 100px;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin: 0.5rem 0;
            line-height: 1.2;
        }
        
        .stat-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }
        
        @media (max-width: 768px) {
            .admin-content {
                padding-left: 0;
            }
            .action-btn {
                padding: 0.2rem 0.4rem;
                font-size: 0.875rem;
            }
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
                    <h1 class="h2"><i class="fas fa-users me-2"></i>Quản lý Users</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-success" id="exportUsersBtn">
                                <i class="fas fa-download me-1"></i>Xuất Excel
                            </button>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fas fa-plus me-1"></i>Thêm User
                        </button>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer"></div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-primary-gradient">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-label">Tổng người dùng</div>
                            <div class="stat-value">${totalUsers != null ? totalUsers : '0'}</div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-info-gradient">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="stat-label">Traveler</div>
                            <div class="stat-value">${travelerCount != null ? travelerCount : '0'}</div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-success-gradient">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="stat-label">Host</div>
                            <div class="stat-value">${hostCount != null ? hostCount : '0'}</div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-danger-gradient">
                                <i class="fas fa-crown"></i>
                            </div>
                            <div class="stat-label">Admin</div>
                            <div class="stat-value">${adminCount != null ? adminCount : '0'}</div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-warning-gradient">
                                <i class="fas fa-lock"></i>
                            </div>
                            <div class="stat-label">Tài khoản bị khóa</div>
                            <div class="stat-value">${lockedCount != null ? lockedCount : '0'}</div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-secondary-gradient">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="stat-label">Mới trong tháng</div>
                            <div class="stat-value">${newUsersThisMonth != null ? newUsersThisMonth : '0'}</div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/users" id="filterForm">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Loại User</label>
                                    <select class="form-select" name="role">
                                        <option value="">Tất cả</option>
                                        <option value="TRAVELER" ${param.role == 'TRAVELER' ? 'selected' : ''}>Traveler</option>
                                        <option value="HOST" ${param.role == 'HOST' ? 'selected' : ''}>Host</option>
                                        <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Bị khóa</option>
                                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chưa xác thực email</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" name="search" value="${param.search}" placeholder="Email, tên, số điện thoại...">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Lọc
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="usersTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Avatar</th>
                                        <th>Thông tin</th>
                                        <th>Loại</th>
                                        <th>Email verified</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th width="200">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr data-user-id="${user.userId}">
                                            <td>${user.userId}</td>
                                            <td>
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
                                            </td>
                                            <td>
                                                <div>
                                                    <strong>${user.fullName}</strong>
                                                    <br>
                                                    <small class="text-muted">${user.email}</small>
                                                    <c:if test="${not empty user.phone}">
                                                        <br>
                                                        <small class="text-muted"><i class="fas fa-phone me-1"></i>${user.phone}</small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'TRAVELER'}">
                                                        <span class="badge bg-info">
                                                            <i class="fas fa-user me-1"></i>Traveler
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'HOST'}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-home me-1"></i>Host
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">
                                                            <i class="fas fa-crown me-1"></i>Admin
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.emailVerified}">
                                                        <span class="badge bg-success status-badge">
                                                            <i class="fas fa-check me-1"></i>Đã xác thực
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning status-badge">
                                                            <i class="fas fa-clock me-1"></i>Chưa xác thực
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="status-cell">
                                                <c:choose>
                                                    <c:when test="${user.active}">
                                                        <span class="badge bg-success status-badge">
                                                            <i class="fas fa-check-circle me-1"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger status-badge">
                                                            <i class="fas fa-ban me-1"></i>Bị khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                                <br>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="HH:mm"/>
                                                </small>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Xem chi tiết"
                                                       data-bs-toggle="tooltip">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/users/${user.userId}/permissions" 
                                                       class="btn btn-sm btn-outline-info action-btn" 
                                                       title="Phân quyền"
                                                       data-bs-toggle="tooltip">
                                                        <i class="fas fa-key"></i>
                                                    </a>
                                                    <c:choose>
                                                        <c:when test="${user.active}">
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-warning action-btn lock-user-btn" 
                                                                    data-user-id="${user.userId}" 
                                                                    data-user-name="${user.fullName}"
                                                                    title="Khóa tài khoản"
                                                                    data-bs-toggle="tooltip">
                                                                <i class="fas fa-lock"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-success action-btn unlock-user-btn" 
                                                                    data-user-id="${user.userId}" 
                                                                    data-user-name="${user.fullName}"
                                                                    title="Mở khóa tài khoản"
                                                                    data-bs-toggle="tooltip">
                                                                <i class="fas fa-unlock"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${user.userId != sessionScope.user.userId}">
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-danger action-btn delete-user-btn" 
                                                                data-user-id="${user.userId}" 
                                                                data-user-name="${user.fullName}"
                                                                title="Xóa tài khoản"
                                                                data-bs-toggle="tooltip">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-info">
                                <small class="text-muted">
                                    Trang ${currentPage} / ${totalPages} 
                                    <c:if test="${not empty totalUsers}">
                                        (Tổng ${totalUsers} users)
                                    </c:if>
                                </small>
                            </div>
                            <nav aria-label="User pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=1&role=${param.role}&status=${param.status}&search=${param.search}" title="Trang đầu">
                                                <i class="fas fa-angle-double-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&role=${param.role}&status=${param.status}&search=${param.search}" title="Trang trước">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                               end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" 
                                               var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${pageNum}&role=${param.role}&status=${param.status}&search=${param.search}">
                                                ${pageNum}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&role=${param.role}&status=${param.status}&search=${param.search}" title="Trang sau">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${totalPages}&role=${param.role}&status=${param.status}&search=${param.search}" title="Trang cuối">
                                                <i class="fas fa-angle-double-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">
                        <i class="fas fa-user-plus me-2"></i>Thêm User mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/users" id="addUserForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" required>
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="fullName" required>
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" name="phone" pattern="[0-9+\-\s\(\)]+">
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Loại User <span class="text-danger">*</span></label>
                            <select class="form-select" name="role" required>
                                <option value="">Chọn loại</option>
                                <option value="TRAVELER">Traveler</option>
                                <option value="HOST">Host</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu tạm thời <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" class="form-control" name="password" value="123456" required minlength="6">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword(this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="form-text">User sẽ được yêu cầu đổi mật khẩu lần đầu đăng nhập</div>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary" id="addUserSubmitBtn">
                            <i class="fas fa-plus me-1"></i>Tạo User
                        </button>
                    </div>
                </form>
            </div>
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
    </div>

    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Đang xử lý...</h6>
                    <button type="button" class="btn-close" onclick="forceHideLoading()" aria-label="Close" title="Force Close (hoặc bấm Esc)"></button>
                </div>
                <div class="modal-body text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 mb-2">Vui lòng chờ...</p>
                    <small class="text-muted">Safety timeout 15s | ESC hoặc Ctrl+L để force tắt</small>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="forceHideLoading()">
                        <i class="fas fa-times me-1"></i>Force Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
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

            showAlert: function(message, type) {
                type = type || 'info';
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

            showLoading: function(show) {
                if (typeof show === 'undefined') show = true;
                var loadingElement = document.getElementById('loadingModal');
                this.log('showLoading called with:', show, 'Modal element found:', !!loadingElement);
                
                if (!loadingElement) {
                    this.error('Loading modal element not found!');
                    return;
                }
                
                try {
                    if (show) {
                        var modal = bootstrap.Modal.getOrCreateInstance(loadingElement);
                        modal.show();
                        this.log('Loading modal shown');
                    } else {
                        // Force hide all loading modals to prevent stuck
                        var existingModal = bootstrap.Modal.getInstance(loadingElement);
                        if (existingModal) {
                            existingModal.hide();
                            this.log('Existing modal hidden');
                        }
                        
                        // Also try to hide via direct manipulation
                        loadingElement.classList.remove('show');
                        loadingElement.style.display = 'none';
                        document.body.classList.remove('modal-open');
                        
                        // Remove any backdrop
                        var backdrops = document.querySelectorAll('.modal-backdrop');
                        backdrops.forEach(function(backdrop) {
                            backdrop.remove();
                        });
                        
                        this.log('Loading modal force hidden');
                    }
                } catch (error) {
                    this.error('Error in showLoading:', error);
                    
                    // Fallback - force hide everything
                    if (!show) {
                        loadingElement.style.display = 'none';
                        document.body.classList.remove('modal-open');
                        var backdrops = document.querySelectorAll('.modal-backdrop');
                        backdrops.forEach(function(backdrop) {
                            backdrop.remove();
                        });
                        this.log('Fallback hide completed');
                    }
                }
            },

            makeRequest: function(url, options) {
                if (typeof options === 'undefined') options = {};
                var self = this;
                self.log('Making request to:', url, 'with options:', options);
                
                // Check if we should show loading modal
                var showModal = options.showLoading !== false;
                if (showModal) {
                    self.showLoading(true);
                }
                
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
                    if (key !== 'headers' && key !== 'showLoading') {
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
                    })
                    .finally(function() {
                        self.log('Request completed, hiding loading');
                        if (showModal) {
                            self.showLoading(false);
                        }
                    });
            },

            updateUserStatus: function(userId, isActive) {
                var row = $('tr[data-user-id="' + userId + '"]');
                var statusCell = row.find('.status-cell');
                var actionCell = row.find('td:last-child .btn-group');
                
                if (isActive) {
                    statusCell.html('<span class="badge bg-success status-badge">' +
                        '<i class="fas fa-check-circle me-1"></i>Hoạt động' +
                        '</span>');
                    // Update lock/unlock button
                    var unlockBtn = actionCell.find('.unlock-user-btn');
                    if (unlockBtn.length) {
                        unlockBtn.removeClass('btn-outline-success unlock-user-btn')
                                .addClass('btn-outline-warning lock-user-btn')
                                .attr('title', 'Khóa tài khoản')
                                .html('<i class="fas fa-lock"></i>');
                    }
                } else {
                    statusCell.html('<span class="badge bg-danger status-badge">' +
                        '<i class="fas fa-ban me-1"></i>Bị khóa' +
                        '</span>');
                    // Update lock/unlock button
                    var lockBtn = actionCell.find('.lock-user-btn');
                    if (lockBtn.length) {
                        lockBtn.removeClass('btn-outline-warning lock-user-btn')
                               .addClass('btn-outline-success unlock-user-btn')
                               .attr('title', 'Mở khóa tài khoản')
                               .html('<i class="fas fa-unlock"></i>');
                    }
                }
                
                // Refresh tooltips
                var tooltipTriggerList = [].slice.call(actionCell.find('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
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
                    Utils.showAlert('Có lỗi xảy ra khi mở form khóa tài khoản', 'danger');
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
                        method: 'POST',
                        showLoading: false  // Tắt loading modal
                    });
                    
                    if (result.success) {
                        Utils.showAlert('Mở khóa tài khoản thành công!', 'success');
                        Utils.updateUserStatus(userId, true);
                    } else {
                        Utils.showAlert(result.message || 'Có lỗi xảy ra khi mở khóa tài khoản', 'danger');
                    }
                } catch (error) {
                    Utils.error('Error unlocking user:', error);
                    Utils.showAlert('Có lỗi xảy ra khi mở khóa tài khoản', 'danger');
                }
            },

            deleteUser: async function(userId, userName) {
                Utils.log('Deleting user:', userId, userName);
                
                var confirmMsg = 'Bạn có chắc chắn muốn XÓA VĨNH VIỄN tài khoản "' + userName + '"?\n\nHành động này không thể hoàn tác!';
                if (!confirm(confirmMsg)) {
                    return;
                }
                
                try {
                    var url = CONFIG.contextPath + '/admin/users/' + userId + '/delete';
                    const result = await Utils.makeRequest(url, { 
                        method: 'DELETE',
                        showLoading: false  // Tắt loading modal
                    });
                    
                    if (result.success) {
                        Utils.showAlert('Xóa tài khoản thành công!', 'success');
                        // Remove row from table
                        $('tr[data-user-id="' + userId + '"]').fadeOut(300, function() {
                            $(this).remove();
                            // Update table if empty
                            if ($('#usersTable tbody tr').length === 0) {
                                setTimeout(() => location.reload(), 1000);
                            }
                        });
                    } else {
                        Utils.showAlert(result.message || 'Có lỗi xảy ra khi xóa tài khoản', 'danger');
                    }
                } catch (error) {
                    Utils.error('Error deleting user:', error);
                    Utils.showAlert('Có lỗi xảy ra khi xóa tài khoản', 'danger');
                }
            },

            exportUsers: function() {
                Utils.log('Exporting users');
                try {
                    var params = new URLSearchParams(window.location.search);
                    params.set('export', 'excel');
                    var url = CONFIG.contextPath + '/admin/users/export?' + params.toString();
                    
                    Utils.showAlert('Đang tạo file Excel...', 'info');
                    window.location.href = url;
                } catch (error) {
                    Utils.error('Error exporting users:', error);
                    Utils.showAlert('Có lỗi xảy ra khi xuất file Excel', 'danger');
                }
            }
        };

        // Form handlers
        const FormHandlers = {
            validateForm: function(form) {
                let isValid = true;
                const requiredFields = form.querySelectorAll('[required]');
                
                requiredFields.forEach(field => {
                    field.classList.remove('is-invalid');
                    const feedback = field.parentNode.querySelector('.invalid-feedback');
                    
                    if (!field.value.trim()) {
                        field.classList.add('is-invalid');
                        if (feedback) feedback.textContent = 'Trường này là bắt buộc';
                        isValid = false;
                    } else if (field.type === 'email' && !this.isValidEmail(field.value)) {
                        field.classList.add('is-invalid');
                        if (feedback) feedback.textContent = 'Email không hợp lệ';
                        isValid = false;
                    } else if (field.type === 'tel' && field.value && !this.isValidPhone(field.value)) {
                        field.classList.add('is-invalid');
                        if (feedback) feedback.textContent = 'Số điện thoại không hợp lệ';
                        isValid = false;
                    } else if (field.type === 'password' && field.value.length < 6) {
                        field.classList.add('is-invalid');
                        if (feedback) feedback.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                        isValid = false;
                    }
                });
                
                return isValid;
            },

            isValidEmail: function(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            },

            isValidPhone: function(phone) {
                const phoneRegex = /^[\d\+\-\s\(\)]{8,15}$/;
                return phoneRegex.test(phone);
            },

            handleAddUser: async function(form) {
                if (!this.validateForm(form)) {
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
                        },
                        showLoading: false  // Tắt loading modal
                    });

                    if (result.success) {
                        Utils.showAlert('Tạo user thành công!', 'success');
                        const modal = bootstrap.Modal.getInstance(document.getElementById('addUserModal'));
                        if (modal) modal.hide();
                        form.reset();
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        Utils.showAlert(result.message || 'Có lỗi xảy ra khi tạo user', 'danger');
                    }
                } catch (error) {
                    Utils.error('Error creating user:', error);
                    Utils.showAlert('Có lỗi xảy ra khi tạo user', 'danger');
                }
                
                return false;
            },

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
                        },
                        showLoading: false  // Tắt loading modal
                    });

                    if (result.success) {
                        Utils.showAlert('Khóa tài khoản thành công!', 'success');
                        const modal = bootstrap.Modal.getInstance(document.getElementById('lockUserModal'));
                        if (modal) modal.hide();
                        
                        // Update UI
                        const userId = form.action.split('/').slice(-2, -1)[0];
                        Utils.updateUserStatus(userId, false);
                    } else {
                        Utils.showAlert(result.message || 'Có lỗi xảy ra khi khóa tài khoản', 'danger');
                    }
                } catch (error) {
                    Utils.error('Error locking user:', error);
                    Utils.showAlert('Có lỗi xảy ra khi khóa tài khoản', 'danger');
                }
                
                return false;
            }
        };

        // Global functions for onclick handlers
        window.togglePassword = function(button) {
            const input = button.parentNode.querySelector('input');
            const icon = button.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        };

        // Initialize everything when document is ready
        $(document).ready(function() {
            Utils.log('Initializing User Management System');
            Utils.log('Context Path:', CONFIG.contextPath);
            Utils.log('Current User ID:', CONFIG.currentUserId);

            // Initialize DataTable
            try {
                const table = $('#usersTable').DataTable({
                    responsive: true,
                    paging: false,
                    searching: false,
                    info: false,
                    ordering: true,
                    order: [[0, 'desc']], // Order by ID descending
                    columnDefs: [
                        { orderable: false, targets: [1, 7] }, // Avatar and Actions columns
                        { className: 'text-center', targets: [0, 1, 3, 4, 5] }
                    ],
                    language: {
                        emptyTable: "Không có dữ liệu người dùng",
                        zeroRecords: "Không tìm thấy kết quả phù hợp",
                        loadingRecords: "Đang tải...",
                        processing: "Đang xử lý..."
                    }
                });
                Utils.log('DataTable initialized successfully');
            } catch (error) {
                Utils.error('DataTable initialization error:', error);
            }

            // Initialize tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Event listeners
            $(document).on('click', '.lock-user-btn', function() {
                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');
                UserManager.lockUser(userId, userName);
            });

            $(document).on('click', '.unlock-user-btn', function() {
                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');
                UserManager.unlockUser(userId, userName);
            });

            $(document).on('click', '.delete-user-btn', function() {
                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');
                UserManager.deleteUser(userId, userName);
            });

            $('#exportUsersBtn').on('click', function() {
                UserManager.exportUsers();
            });

            // Form submissions
            $('#addUserForm').on('submit', function(e) {
                e.preventDefault();
                FormHandlers.handleAddUser(this);
            });

            $('#lockUserForm').on('submit', function(e) {
                e.preventDefault();
                FormHandlers.handleLockUser(this);
            });

            // Clear form validation on input
            $(document).on('input', '.form-control, .form-select', function() {
                $(this).removeClass('is-invalid');
            });

            // Handle modal events
            $('#addUserModal').on('hidden.bs.modal', function() {
                const form = this.querySelector('form');
                form.reset();
                form.querySelectorAll('.form-control, .form-select').forEach(el => {
                    el.classList.remove('is-invalid');
                });
            });

            $('#lockUserModal').on('hidden.bs.modal', function() {
                const form = this.querySelector('form');
                form.reset();
                form.querySelectorAll('.form-control, .form-select').forEach(el => {
                    el.classList.remove('is-invalid');
                });
            });

            // Handle search form with Enter key
            $('#filterForm input[name="search"]').on('keypress', function(e) {
                if (e.which === 13) {
                    $('#filterForm').submit();
                }
            });

            // Auto-refresh page on hash change (for back button support)
            $(window).on('hashchange', function() {
                if (window.location.hash === '#refresh') {
                    location.reload();
                }
            });

            Utils.log('User Management System initialized successfully');
            
            // Show success message if redirected after action
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success')) {
                Utils.showAlert(decodeURIComponent(urlParams.get('success')), 'success');
            }
            if (urlParams.get('error')) {
                Utils.showAlert(decodeURIComponent(urlParams.get('error')), 'danger');
            }
        });

        // Handle page unload
        $(window).on('beforeunload', function() {
            Utils.showLoading(false);
        });

        // Error handling for uncaught errors
        window.onerror = function(msg, url, lineNo, columnNo, error) {
            Utils.error('Uncaught error:', msg, 'at', url + ':' + lineNo + ':' + columnNo);
            Utils.showAlert('Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.', 'danger');
        };
    </script>
</body>
</html>
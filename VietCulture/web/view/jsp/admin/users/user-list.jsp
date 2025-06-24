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
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="exportUsers()">
                                    <i class="fas fa-download me-1"></i>Xuất Excel
                                </button>
                            </div>
                            <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                <i class="fas fa-plus me-1"></i>Thêm User
                            </button>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/admin/users">
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
                                <table class="table table-striped" id="usersTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Avatar</th>
                                            <th>Thông tin</th>
                                            <th>Loại</th>
                                            <th>Email verified</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.avatar}">
                                                            <img src="${pageContext.request.contextPath}/assets/images/avatars/${user.avatar}" 
                                                                 alt="Avatar" class="user-avatar">
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
                                                            <span class="badge bg-info">Traveler</span>
                                                        </c:when>
                                                        <c:when test="${user.role == 'HOST'}">
                                                            <span class="badge bg-success">Host</span>
                                                        </c:when>
                                                        <c:when test="${user.role == 'ADMIN'}">
                                                            <span class="badge bg-danger">Admin</span>
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
                                                <td>
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
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                                                           class="btn btn-sm btn-outline-primary action-btn" 
                                                           title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/users/${user.userId}/permissions" 
                                                           class="btn btn-sm btn-outline-info action-btn" 
                                                           title="Phân quyền">
                                                            <i class="fas fa-key"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${user.active}">
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-warning action-btn" 
                                                                        onclick="lockUser(${user.userId}, '${user.fullName}')" 
                                                                        title="Khóa tài khoản">
                                                                    <i class="fas fa-lock"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-success action-btn" 
                                                                        onclick="unlockUser(${user.userId}, '${user.fullName}')" 
                                                                        title="Mở khóa tài khoản">
                                                                    <i class="fas fa-unlock"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${user.userId != sessionScope.user.userId}">
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-danger action-btn" 
                                                                    onclick="deleteUser(${user.userId}, '${user.fullName}')" 
                                                                    title="Xóa tài khoản">
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
                                <nav aria-label="User pagination">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage - 1}&role=${param.role}&status=${param.status}&search=${param.search}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${pageNum}&role=${param.role}&status=${param.status}&search=${param.search}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage + 1}&role=${param.role}&status=${param.status}&search=${param.search}">
                                                    <i class="fas fa-chevron-right"></i>
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
        <div class="modal fade" id="addUserModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm User mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/users/create">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Họ và tên *</label>
                                <input type="text" class="form-control" name="fullName" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Loại User *</label>
                                <select class="form-select" name="role" required>
                                    <option value="">Chọn loại</option>
                                    <option value="TRAVELER">Traveler</option>
                                    <option value="HOST">Host</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu tạm thời *</label>
                                <input type="password" class="form-control" name="password" value="123456" required>
                                <div class="form-text">User sẽ được yêu cầu đổi mật khẩu lần đầu đăng nhập</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Tạo User</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Lock User Modal -->
        <div class="modal fade" id="lockUserModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Khóa tài khoản</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="lockUserForm" method="POST">
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn khóa tài khoản <strong id="lockUserName"></strong>?</p>
                            <div class="mb-3">
                                <label class="form-label">Lý do khóa *</label>
                                <textarea class="form-control" name="reason" rows="3" required placeholder="Nhập lý do khóa tài khoản..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-warning">Khóa tài khoản</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

        <script>
                                                                        // Initialize DataTable
                                                                        $(document).ready(function () {
                                                                            $('#usersTable').DataTable({
                                                                                "paging": false,
                                                                                "searching": false,
                                                                                "info": false,
                                                                                "columnDefs": [
                                                                                    {"orderable": false, "targets": [1, 7]}
                                                                                ],
                                                                                "language": {
                                                                                    "emptyTable": "Không có dữ liệu",
                                                                                    "zeroRecords": "Không tìm thấy kết quả phù hợp"
                                                                                }
                                                                            });
                                                                        });

                                                                        function lockUser(userId, userName) {
                                                                            document.getElementById('lockUserName').textContent = userName;
                                                                            document.getElementById('lockUserForm').action = '/admin/users/' + userId + '/lock';
                                                                            new bootstrap.Modal(document.getElementById('lockUserModal')).show();
                                                                        }

                                                                        function unlockUser(userId, userName) {
                                                                            if (confirm('Bạn có chắc chắn muốn mở khóa tài khoản ' + userName + '?')) {
                                                                                fetch('/admin/users/' + userId + '/unlock', {
                                                                                    method: 'POST',
                                                                                    headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                    }
                                                                                })
                                                                                        .then(response => response.json())
                                                                                        .then(data => {
                                                                                            if (data.success) {
                                                                                                location.reload();
                                                                                            } else {
                                                                                                alert('Có lỗi xảy ra: ' + data.message);
                                                                                            }
                                                                                        });
                                                                            }
                                                                        }

                                                                        function deleteUser(userId, userName) {
                                                                            if (confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN tài khoản ' + userName + '?\n\nHành động này không thể hoàn tác!')) {
                                                                                fetch('/admin/users/' + userId + '/delete', {
                                                                                    method: 'DELETE',
                                                                                    headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                    }
                                                                                })
                                                                                        .then(response => response.json())
                                                                                        .then(data => {
                                                                                            if (data.success) {
                                                                                                location.reload();
                                                                                            } else {
                                                                                                alert('Có lỗi xảy ra: ' + data.message);
                                                                                            }
                                                                                        });
                                                                            }
                                                                        }

                                                                        function exportUsers() {
                                                                            const params = new URLSearchParams(window.location.search);
                                                                            params.set('export', 'excel');
                                                                            window.location.href = '/admin/users/export?' + params.toString();
                                                                        }
        </script>
    </body>
</html>
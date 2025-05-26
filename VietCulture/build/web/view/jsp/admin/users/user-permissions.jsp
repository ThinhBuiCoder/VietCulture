<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phân quyền - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .permissions-card {
            max-width: 800px;
            margin: 0 auto;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .permissions-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 3px solid rgba(255,255,255,0.3);
            object-fit: cover;
            margin-bottom: 1rem;
        }
        .permissions-body {
            padding: 2rem;
        }
        .role-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .role-card:hover {
            border-color: #007bff;
            box-shadow: 0 4px 15px rgba(0,123,255,0.1);
        }
        .role-card.selected {
            border-color: #007bff;
            background-color: #f8f9ff;
        }
        .role-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-bottom: 1rem;
        }
        .role-icon.traveler {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .role-icon.host {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .role-icon.admin {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }
        .permission-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            background: white;
        }
        .permission-item.enabled {
            border-color: #28a745;
            background-color: #f8fff9;
        }
        .permission-item.disabled {
            border-color: #dc3545;
            background-color: #fff8f8;
        }
        .permission-toggle {
            margin-left: auto;
        }
        .change-log {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1.5rem;
        }
        .change-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        .change-item:last-child {
            border-bottom: none;
        }
        .btn-gradient-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            color: white;
        }
        .btn-gradient-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #007bff 100%);
            color: white;
        }
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
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
        <div class="permissions-card">
            <!-- Header -->
            <div class="permissions-header">
                <img src="${not empty user.avatar ? user.avatar : '/assets/images/default-avatar.png'}" 
                     alt="Avatar" class="user-avatar">
                <h3 class="mb-2">
                    <i class="fas fa-user-shield me-2"></i>Quản lý phân quyền
                </h3>
                <p class="mb-0">${user.fullName} (${user.email})</p>
                <p class="mb-0">
                    <small>Vai trò hiện tại: 
                        <span class="badge bg-light text-dark">${user.userType}</span>
                    </small>
                </p>
            </div>

            <!-- Body -->
            <div class="permissions-body">
                <form id="permissionsForm" onsubmit="updatePermissions(event)">
                    <input type="hidden" name="userId" value="${user.userId}">
                    <input type="hidden" name="currentUserType" value="${user.userType}">

                    <!-- Warning -->
                    <div class="warning-box">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                        <strong>Cảnh báo:</strong> Thay đổi vai trò sẽ ảnh hưởng đến quyền truy cập và chức năng của người dùng.
                    </div>

                    <!-- Role Selection -->
                    <h5 class="mb-4">
                        <i class="fas fa-users-cog me-2"></i>Chọn vai trò
                    </h5>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="role-card ${user.userType == 'TRAVELER' ? 'selected' : ''}" 
                                 onclick="selectRole('TRAVELER', this)">
                                <div class="role-icon traveler">
                                    <i class="fas fa-suitcase-rolling"></i>
                                </div>
                                <h6 class="mb-2">Traveler</h6>
                                <p class="text-muted small mb-0">
                                    Người dùng có thể đặt và tham gia các trải nghiệm du lịch.
                                </p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="role-card ${user.userType == 'HOST' ? 'selected' : ''}" 
                                 onclick="selectRole('HOST', this)">
                                <div class="role-icon host">
                                    <i class="fas fa-store"></i>
                                </div>
                                <h6 class="mb-2">Host</h6>
                                <p class="text-muted small mb-0">
                                    Người dùng có thể tạo và quản lý các trải nghiệm du lịch.
                                </p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="role-card ${user.userType == 'ADMIN' ? 'selected' : ''}" 
                                 onclick="selectRole('ADMIN', this)">
                                <div class="role-icon admin">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <h6 class="mb-2">Admin</h6>
                                <p class="text-muted small mb-0">
                                    Full quyền quản trị hệ thống và người dùng.
                                </p>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="newUserType" id="selectedRole" value="${user.userType}">

                    <!-- Permissions Detail -->
                    <div class="mt-5">
                        <h5 class="mb-4">
                            <i class="fas fa-key me-2"></i>Chi tiết quyền hạn
                        </h5>

                        <div id="permissionsDetail">
                            <!-- Permissions will be loaded dynamically -->
                        </div>
                    </div>

                    <!-- Additional Settings -->
                    <div class="mt-4">
                        <h6 class="mb-3">
                            <i class="fas fa-cog me-2"></i>Cài đặt bổ sung
                        </h6>
                        
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="sendNotification" name="sendNotification" value="true" checked>
                            <label class="form-check-label" for="sendNotification">
                                Gửi email thông báo thay đổi quyền hạn
                            </label>
                        </div>
                        
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="logActivity" name="logActivity" value="true" checked>
                            <label class="form-check-label" for="logActivity">
                                Ghi log hoạt động thay đổi
                            </label>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="requirePasswordReset" name="requirePasswordReset" value="true">
                            <label class="form-check-label" for="requirePasswordReset">
                                Yêu cầu đổi mật khẩu khi đăng nhập lần đầu
                            </label>
                        </div>
                    </div>

                    <!-- Reason -->
                    <div class="mb-4">
                        <label for="changeReason" class="form-label">
                            <i class="fas fa-clipboard-list me-2"></i>Lý do thay đổi *
                        </label>
                        <textarea class="form-control" 
                                 id="changeReason" 
                                 name="reason" 
                                 rows="3"
                                 placeholder="Nhập lý do thay đổi phân quyền..."
                                 required></textarea>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex gap-3">
                        <button type="submit" class="btn btn-gradient-primary flex-fill">
                            <i class="fas fa-save me-2"></i>Cập nhật phân quyền
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users/${user.userId}" 
                           class="btn btn-outline-secondary flex-fill">
                            <i class="fas fa-times me-2"></i>Hủy bỏ
                        </a>
                    </div>
                </form>

                <!-- Change History -->
                <div class="change-log mt-5">
                    <h6 class="mb-3">
                        <i class="fas fa-history me-2"></i>Lịch sử thay đổi quyền hạn
                    </h6>
                    
                    <div class="change-item">
                        <div class="me-3">
                            <i class="fas fa-arrow-right text-primary"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>Thay đổi từ TRAVELER sang HOST</strong>
                            <p class="mb-1 small text-muted">Lý do: Người dùng muốn trở thành host để cung cấp dịch vụ</p>
                            <p class="mb-0 small text-muted">
                                Bởi: Admin (admin@example.com) - 15/01/2024 14:30
                            </p>
                        </div>
                    </div>
                    
                    <div class="change-item">
                        <div class="me-3">
                            <i class="fas fa-user-plus text-success"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>Tài khoản được tạo</strong>
                            <p class="mb-1 small text-muted">Vai trò ban đầu: TRAVELER</p>
                            <p class="mb-0 small text-muted">
                                Bởi: System - 01/01/2024 10:00
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center py-4">
                    <div class="spinner-border text-primary mb-3" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mb-0">Đang cập nhật quyền hạn...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận thay đổi phân quyền</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <i class="fas fa-exclamation-triangle text-warning fa-3x"></i>
                    </div>
                    <p id="confirmMessage" class="text-center"></p>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Thay đổi này sẽ có hiệu lực ngay lập tức và có thể ảnh hưởng đến trải nghiệm của người dùng.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận thay đổi</button>
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
        let currentSelectedRole = '${user.userType}';

        const rolePermissions = {
            'TRAVELER': [
                { name: 'Xem danh sách trải nghiệm', enabled: true, required: true },
                { name: 'Đặt booking trải nghiệm', enabled: true, required: true },
                { name: 'Đánh giá trải nghiệm', enabled: true, required: false },
                { name: 'Quản lý hồ sơ cá nhân', enabled: true, required: true },
                { name: 'Xem lịch sử booking', enabled: true, required: true },
                { name: 'Hủy booking', enabled: true, required: false },
                { name: 'Chat với host', enabled: true, required: false }
            ],
            'HOST': [
                { name: 'Tạo trải nghiệm mới', enabled: true, required: true },
                { name: 'Quản lý trải nghiệm', enabled: true, required: true },
                { name: 'Xem booking của khách', enabled: true, required: true },
                { name: 'Xác nhận/Từ chối booking', enabled: true, required: true },
                { name: 'Chat với traveler', enabled: true, required: true },
                { name: 'Xem báo cáo doanh thu', enabled: true, required: false },
                { name: 'Quản lý lịch trình', enabled: true, required: true },
                { name: 'Cập nhật giá và khuyến mãi', enabled: true, required: false }
            ],
            'ADMIN': [
                { name: 'Quản lý tất cả người dùng', enabled: true, required: true },
                { name: 'Quản lý tất cả trải nghiệm', enabled: true, required: true },
                { name: 'Xem tất cả báo cáo', enabled: true, required: true },
                { name: 'Quản lý hệ thống', enabled: true, required: true },
                { name: 'Phân quyền người dùng', enabled: true, required: true },
                { name: 'Khóa/Mở khóa tài khoản', enabled: true, required: true },
                { name: 'Xem logs hệ thống', enabled: true, required: true },
                { name: 'Quản lý nội dung', enabled: true, required: false }
            ]
        };

        document.addEventListener('DOMContentLoaded', function() {
            loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
            
            // Load initial permissions
            loadPermissions(currentSelectedRole);
        });

        function selectRole(role, element) {
            // Remove selection from all cards
            document.querySelectorAll('.role-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selection to clicked card
            element.classList.add('selected');
            
            // Update hidden input
            document.getElementById('selectedRole').value = role;
            currentSelectedRole = role;
            
            // Load permissions for selected role
            loadPermissions(role);
        }

        function loadPermissions(role) {
            const permissionsContainer = document.getElementById('permissionsDetail');
            const permissions = rolePermissions[role] || [];
            
            let html = '';
            permissions.forEach(permission => {
                html += `
                    <div class="permission-item ${permission.enabled ? 'enabled' : 'disabled'}">
                        <div class="me-3">
                            <i class="fas ${permission.enabled ? 'fa-check-circle text-success' : 'fa-times-circle text-danger'}"></i>
                        </div>
                        <div class="flex-grow-1">
                            <strong>${permission.name}</strong>
                            ${permission.required ? '<span class="badge bg-primary ms-2">Bắt buộc</span>' : ''}
                        </div>
                        <div class="permission-toggle">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" 
                                       ${permission.enabled ? 'checked' : ''} 
                                       ${permission.required ? 'disabled' : ''}
                                       onchange="togglePermission(this, '${permission.name}')">
                            </div>
                        </div>
                    </div>
                `;
            });
            
            permissionsContainer.innerHTML = html;
        }

        function togglePermission(checkbox, permissionName) {
            const permissionItem = checkbox.closest('.permission-item');
            if (checkbox.checked) {
                permissionItem.classList.remove('disabled');
                permissionItem.classList.add('enabled');
                permissionItem.querySelector('i').className = 'fas fa-check-circle text-success';
            } else {
                permissionItem.classList.remove('enabled');
                permissionItem.classList.add('disabled');
                permissionItem.querySelector('i').className = 'fas fa-times-circle text-danger';
            }
        }

        function updatePermissions(event) {
            event.preventDefault();
            
            const form = document.getElementById('permissionsForm');
            const formData = new FormData(form);
            
            const currentRole = formData.get('currentUserType');
            const newRole = formData.get('newUserType');
            const reason = formData.get('reason').trim();
            
            if (!reason) {
                showAlert('warning', 'Vui lòng nhập lý do thay đổi phân quyền.');
                return;
            }
            
            if (currentRole === newRole) {
                showAlert('info', 'Vai trò không thay đổi. Chỉ cập nhật cài đặt bổ sung.');
                performUpdate(formData);
                return;
            }
            
            const message = `Bạn có chắc chắn muốn thay đổi vai trò từ "${currentRole}" sang "${newRole}"?`;
            showConfirm(message, () => {
                performUpdate(formData);
            });
        }

        function performUpdate(formData) {
            loadingModal.show();
            
            const userId = formData.get('userId');
            
            fetch(`${contextPath}/admin/users/${userId}/permissions`, {
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
                    showAlert('danger', data.message || 'Có lỗi xảy ra khi cập nhật phân quyền.');
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
            const existingAlerts = document.querySelectorAll('.alert.position-fixed');
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

        // Prevent form submission if no changes
        function hasChanges() {
            const currentRole = document.querySelector('input[name="currentUserType"]').value;
            const newRole = document.querySelector('input[name="newUserType"]').value;
            
            return currentRole !== newRole;
        }

        // Auto-resize textarea
        document.addEventListener('DOMContentLoaded', function() {
            const textarea = document.getElementById('changeReason');
            if (textarea) {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = this.scrollHeight + 'px';
                });
            }
        });

        // Role comparison helper
        function getRoleLevel(role) {
            switch(role) {
                case 'TRAVELER': return 1;
                case 'HOST': return 2;
                case 'ADMIN': return 3;
                default: return 0;
            }
        }

        // Show warning for role downgrade
        function checkRoleDowngrade() {
            const currentRole = document.querySelector('input[name="currentUserType"]').value;
            const newRole = document.querySelector('input[name="newUserType"]').value;
            
            if (getRoleLevel(newRole) < getRoleLevel(currentRole)) {
                showAlert('warning', 'Bạn đang giảm cấp quyền của người dùng. Hãy chắc chắn rằng đây là điều bạn muốn làm.');
            }
        }
    </script>
</body>
</html>
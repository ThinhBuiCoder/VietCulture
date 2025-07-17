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
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .btn-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-gradient-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            color: white;
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
                <div class="user-avatar bg-secondary d-flex align-items-center justify-content-center">
                    <i class="fas fa-user text-white"></i>
                </div>
                <h3 class="mb-2">
                    <i class="fas fa-user-shield me-2"></i>Quản lý phân quyền
                </h3>
                <p class="mb-0">${user.fullName} (${user.email})</p>
                <p class="mb-0">
                    <small>Vai trò hiện tại: 
                        <span class="badge bg-light text-dark" data-role="${user.role}">${user.role}</span>
                    </small>
                </p>
            </div>

            <!-- Body -->
            <div class="permissions-body">
                <!-- Debug info (ẩn trong production) -->
                <div class="alert alert-info" id="debugInfo" style="display: none;">
                    <strong>Debug Info:</strong><br>
                    User ID: <span id="debugUserId">${user.userId}</span><br>
                    Current Role: <span id="debugRole">${user.role}</span><br>
                    Context Path: <span id="debugContext">${pageContext.request.contextPath}</span>
                </div>

                <form id="permissionsForm">
                    <input type="hidden" name="userId" value="${user.userId}">
                    <input type="hidden" name="currentrole" value="${user.role}">
                    <input type="hidden" name="newrole" value="${user.role}">
                    <input type="hidden" name="action" value="update-permissions">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    
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
                            <div class="role-card ${user.role == 'TRAVELER' ? 'selected' : ''} traveler" data-role="TRAVELER" onclick="selectRole('TRAVELER', this)">
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
                            <div class="role-card ${user.role == 'HOST' ? 'selected' : ''} host" data-role="HOST" onclick="selectRole('HOST', this)">
                                <div class="role-icon host">
                                    <i class="fas fa-home"></i>
                                </div>
                                <h6 class="mb-2">Host</h6>
                                <p class="text-muted small mb-0">
                                    Có thể tạo và quản lý các dịch vụ du lịch.
                                </p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="role-card ${user.role == 'ADMIN' ? 'selected' : ''} admin" data-role="ADMIN" onclick="selectRole('ADMIN', this)">
                                <div class="role-icon admin">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <h6 class="mb-2">Admin</h6>
                                <p class="text-muted small mb-0">
                                    Quyền quản trị hệ thống và người dùng.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Reason for change -->
                    <div class="mt-4">
                        <h5 class="mb-3">
                            <i class="fas fa-comment-alt me-2"></i>Lý do thay đổi
                        </h5>
                        <div class="form-group">
                            <textarea class="form-control" id="changeReason" name="reason" 
                                      rows="3" required minlength="5" maxlength="500"
                                      placeholder="Nhập lý do thay đổi phân quyền..."></textarea>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-gradient-primary w-100">
                            <i class="fas fa-save me-2"></i>Cập nhật phân quyền
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận thay đổi</h5>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectRole(role, element) {
            document.querySelectorAll('.role-card').forEach(function(card) {
                card.classList.remove('selected');
            });
            element.classList.add('selected');
            document.querySelector('input[name="newrole"]').value = role;
            checkRoleDowngrade();
        }

        const confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
        const contextPath = '${pageContext.request.contextPath}';
        const currentRoleServer = "${user.role}";
        function performUpdate(form) {
            const formData = new FormData(form);
            
            // Get values for validation
            const userIdValue = formData.get('userId');
            const currentRoleValue = formData.get('currentrole');
            const newRoleValue = formData.get('newrole');
            const reasonValue = formData.get('reason');
            
            console.log('Form values:', {
                userId: userIdValue,
                currentRole: currentRoleValue,
                newRole: newRoleValue,
                reason: reasonValue
            });
            
            if (!userIdValue || !currentRoleValue || !newRoleValue || !reasonValue) {
                showAlert('danger', 'Vui lòng điền đầy đủ thông tin.');
                return;
            }

            const submitBtn = form.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            submitBtn.disabled = true;

            // Convert FormData to URLSearchParams
            const params = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                params.append(key, value);
            }

            // Fix URL format - use the current URL
            const targetUrl = window.location.href;
            
            fetch(targetUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(async response => {
                const text = await response.text();
                console.log('Raw response:', text);
                
                try {
                    return JSON.parse(text);
                } catch (e) {
                    throw new Error('Invalid JSON response: ' + text);
                }
            })
            .then(data => {
                console.log('Parsed response:', data);
                
                if (data.success) {
                    showAlert('success', data.message || 'Cập nhật phân quyền thành công!');
                    setTimeout(function() {
                        window.location.href = contextPath + "/admin/users/";
                    }, 1200); // Wait 1.2s for user to see the alert
                } else {
                    showAlert('danger', data.message || 'Có lỗi xảy ra khi cập nhật phân quyền.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('danger', 'Có lỗi xảy ra: ' + error.message);
            })
            .finally(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        }

        document.getElementById('permissionsForm').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const reason = document.getElementById('changeReason').value.trim();
            // Always get current role from server-side variable
            const currentRole = typeof currentRoleServer !== 'undefined' ? currentRoleServer : '';
            // Get new role from selected .role-card data-role
            let newRole = '';
            const selectedCard = document.querySelector('.role-card.selected[data-role]');
            if (selectedCard) newRole = selectedCard.getAttribute('data-role');
            // Map role codes to display names
            const roleDisplayNames = {
                'TRAVELER': 'Khách du lịch',
                'HOST': 'Chủ dịch vụ',
                'ADMIN': 'Quản trị viên'
            };
            const currentRoleName = roleDisplayNames[currentRole] || currentRole;
            const newRoleName = roleDisplayNames[newRole] || newRole;
            
            if (!reason) {
                showAlert('warning', 'Vui lòng nhập lý do thay đổi phân quyền.');
                return;
            }
            
            if (reason.length < 5) {
                showAlert('warning', 'Lý do phải có ít nhất 5 ký tự.');
                return;
            }
            
            if (currentRole === newRole) {
                showAlert('info', 'Vai trò không thay đổi.');
                return;
            }
            
            const message = `Bạn có chắc chắn muốn thay đổi vai trò của người dùng này không ?`;
            showConfirm(message, () => performUpdate(this));
        });

        function showAlert(type, message) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 350px;';
            
            let iconClass = '';
            switch(type) {
                case 'success': iconClass = 'fa-check-circle'; break;
                case 'danger': iconClass = 'fa-exclamation-circle'; break;
                case 'warning': iconClass = 'fa-exclamation-triangle'; break;
                case 'info': iconClass = 'fa-info-circle'; break;
                default: iconClass = 'fa-info-circle';
            }
            
            alertDiv.innerHTML = `
                <i class="fas ${iconClass} me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(alertDiv);
            setTimeout(() => alertDiv.remove(), 5000);
        }

        function showConfirm(message, callback) {
            document.getElementById('confirmMessage').textContent = message;
            document.getElementById('confirmButton').onclick = () => {
                confirmModal.hide();
                callback();
            };
            confirmModal.show();
        }

        function getRoleLevel(role) {
            const levels = { 'TRAVELER': 1, 'HOST': 2, 'ADMIN': 3 };
            return levels[role] || 0;
        }

        function checkRoleDowngrade() {
            const currentRole = document.querySelector('input[name="currentrole"]').value;
            const newRole = document.querySelector('input[name="newrole"]').value;
            
            if (getRoleLevel(newRole) < getRoleLevel(currentRole)) {
                showAlert('warning', 'Bạn đang giảm cấp quyền của người dùng. Hãy chắc chắn rằng đây là điều bạn muốn làm.');
            }
        }
    </script>
</body>
</html>
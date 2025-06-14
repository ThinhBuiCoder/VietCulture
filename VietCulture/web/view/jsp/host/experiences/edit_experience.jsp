<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'HOST'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Trải Nghiệm - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        .custom-navbar {
            background-color: #10466C;
            padding: 1rem 0;
        }
        .custom-navbar a {
            color: white;
            text-decoration: none;
        }
        .navbar-brand {
            display: flex;
            align-items: center;
        }
        .navbar-brand img {
            height: 40px;
            margin-right: 10px;
        }
        .nav-right a {
            margin-left: 20px;
        }
        .form-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .form-title {
            color: #10466C;
            margin-bottom: 2rem;
            text-align: center;
        }
        .form-label {
            font-weight: 500;
            color: #10466C;
        }
        .form-control:focus {
            border-color: #10466C;
            box-shadow: 0 0 0 0.2rem rgba(16, 70, 108, 0.25);
        }
        .btn-primary {
            background-color: #10466C;
            border-color: #10466C;
        }
        .btn-primary:hover {
            background-color: #0d3554;
            border-color: #0d3554;
        }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            margin-top: 10px;
            border-radius: 5px;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <img src="${pageContext.request.contextPath}/view/assets/home/img/logo1.jpg" alt="VietCulture Logo">
                    <span>VIETCULTURE</span>
                </a>
                <div class="nav-right">
                    <a href="${pageContext.request.contextPath}/">
                        <i class="ri-home-line me-2"></i>Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/host/dashboard">
                        <i class="ri-dashboard-line me-2"></i>Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="ri-logout-circle-r-line me-2"></i>Đăng Xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <h2 class="form-title">Chỉnh Sửa Trải Nghiệm</h2>
            
            <form id="editExperienceForm" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${experience.id}">
                
                <div class="mb-3">
                    <label for="title" class="form-label">Tên Trải Nghiệm</label>
                    <input type="text" class="form-control" id="title" name="title" 
                           value="${experience.title}" required>
                </div>
                
                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" 
                              rows="4" required>${experience.description}</textarea>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label">Giá (VNĐ)</label>
                        <input type="number" class="form-control" id="price" name="price" 
                               value="${experience.price}" required>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="category" class="form-label">Danh Mục</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="CULTURE" ${experience.category == 'CULTURE' ? 'selected' : ''}>Văn Hóa</option>
                            <option value="FOOD" ${experience.category == 'FOOD' ? 'selected' : ''}>Ẩm Thực</option>
                            <option value="ADVENTURE" ${experience.category == 'ADVENTURE' ? 'selected' : ''}>Khám Phá</option>
                            <option value="NATURE" ${experience.category == 'NATURE' ? 'selected' : ''}>Thiên Nhiên</option>
                        </select>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="status" class="form-label">Trạng Thái</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="ACTIVE" ${experience.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="PENDING" ${experience.status == 'PENDING' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="INACTIVE" ${experience.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="thumbnail" class="form-label">Hình Ảnh Thumbnail</label>
                    <input type="file" class="form-control" id="thumbnail" name="thumbnail" 
                           accept="image/*">
                    <img src="${experience.thumbnailUrl}" alt="Current thumbnail" 
                         class="preview-image" id="thumbnailPreview">
                </div>
                
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/host/experiences" 
                       class="btn btn-secondary">
                        <i class="ri-arrow-left-line me-2"></i>Quay Lại
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-save-line me-2"></i>Lưu Thay Đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Toast Container for Notifications -->
    <div class="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to show toast notification
        function showToast(message, type = 'success') {
            const toastContainer = document.querySelector('.toast-container');
            const toast = document.createElement('div');
            toast.className = `toast align-items-center text-white bg-${type} border-0`;
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');
            
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            `;
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', () => {
                toast.remove();
            });
        }

        // Preview thumbnail image
        document.getElementById('thumbnail').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('thumbnailPreview').src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });

        // Handle form submission
        document.getElementById('editExperienceForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            fetch(`${pageContext.request.contextPath}/host/experiences/update/${formData.get('id')}`, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Cập nhật trải nghiệm thành công');
                    setTimeout(() => {
                        window.location.href = `${pageContext.request.contextPath}/host/experiences`;
                    }, 1000);
                } else {
                    showToast('Có lỗi xảy ra khi cập nhật trải nghiệm', 'danger');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra khi cập nhật trải nghiệm', 'danger');
            });
        });
    </script>
</body>
</html> 
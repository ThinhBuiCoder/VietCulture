<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'HOST'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Trải Nghiệm - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        .experience-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .experience-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .experience-image {
            height: 200px;
            object-fit: cover;
            border-radius: 10px 10px 0 0;
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .action-buttons {
            position: absolute;
            bottom: 10px;
            right: 10px;
        }
        .btn-action {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
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

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary">Quản Lý Trải Nghiệm</h2>
            <a href="${pageContext.request.contextPath}/host/experiences/create" class="btn btn-primary">
                <i class="ri-add-line me-2"></i>Tạo Trải Nghiệm Mới
            </a>
        </div>

        <!-- Filter Section -->
        <div class="card mb-4">
            <div class="card-body">
                <form class="row g-3">
                    <div class="col-md-4">
                        <label for="status" class="form-label">Trạng Thái</label>
                        <select class="form-select" id="status" name="status">
                            <option value="">Tất cả</option>
                            <option value="ACTIVE">Đang hoạt động</option>
                            <option value="PENDING">Chờ duyệt</option>
                            <option value="INACTIVE">Không hoạt động</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="category" class="form-label">Danh Mục</label>
                        <select class="form-select" id="category" name="category">
                            <option value="">Tất cả</option>
                            <option value="CULTURE">Văn Hóa</option>
                            <option value="FOOD">Ẩm Thực</option>
                            <option value="ADVENTURE">Khám Phá</option>
                            <option value="NATURE">Thiên Nhiên</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="search" class="form-label">Tìm Kiếm</label>
                        <input type="text" class="form-control" id="search" name="search" placeholder="Nhập tên trải nghiệm...">
                    </div>
                    <div class="col-12 text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="ri-search-line me-2"></i>Tìm Kiếm
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Experiences List -->
        <div class="row">
            <c:forEach items="${experiences}" var="exp">
                <div class="col-md-6 col-lg-4">
                    <div class="card experience-card">
                        <img src="${exp.thumbnailUrl}" class="experience-image" alt="${exp.title}">
                        <span class="badge ${exp.status == 'ACTIVE' ? 'bg-success' : exp.status == 'PENDING' ? 'bg-warning' : 'bg-danger'} status-badge">
                            ${exp.status == 'ACTIVE' ? 'Đang hoạt động' : exp.status == 'PENDING' ? 'Chờ duyệt' : 'Không hoạt động'}
                        </span>
                        <div class="card-body">
                            <h5 class="card-title">${exp.title}</h5>
                            <p class="card-text text-muted">${exp.description}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-primary fw-bold">
                                        <fmt:formatNumber value="${exp.price}" type="currency" currencySymbol="VNĐ"/>
                                    </span>
                                    <small class="text-muted ms-2">/ người</small>
                                </div>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/host/experiences/edit/${exp.id}" class="btn btn-sm btn-outline-primary btn-action">
                                        <i class="ri-edit-line"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger btn-action" onclick="deleteExperience(${exp.id})">
                                        <i class="ri-delete-bin-line"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}">Trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}">Sau</a>
                </li>
            </ul>
        </nav>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteExperience(id) {
            if (confirm('Bạn có chắc chắn muốn xóa trải nghiệm này?')) {
                fetch(`${pageContext.request.contextPath}/host/experiences/delete/${id}`, {
                    method: 'DELETE'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa trải nghiệm');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa trải nghiệm');
                });
            }
        }
    </script>
</body>
</html> 
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
    <title>Tạo Trải Nghiệm Mới - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .form-title {
            color: #10466C;
            margin-bottom: 2rem;
            text-align: center;
        }
        .form-label {
            color: #10466C;
            font-weight: 500;
        }
        .btn-primary {
            background-color: #10466C;
            border-color: #10466C;
        }
        .btn-primary:hover {
            background-color: #0d3554;
            border-color: #0d3554;
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
            <h2 class="form-title">Tạo Trải Nghiệm Mới</h2>
            
            <form action="${pageContext.request.contextPath}/host/experiences/create" method="POST" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="title" class="form-label">Tên Trải Nghiệm</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label">Giá (VNĐ)</label>
                        <input type="number" class="form-control" id="price" name="price" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="capacity" class="form-label">Số Lượng Người Tối Đa</label>
                        <input type="number" class="form-control" id="capacity" name="capacity" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="location" class="form-label">Địa Điểm</label>
                    <input type="text" class="form-control" id="location" name="location" required>
                </div>

                <div class="mb-3">
                    <label for="duration" class="form-label">Thời Lượng (giờ)</label>
                    <input type="number" class="form-control" id="duration" name="duration" required>
                </div>

                <div class="mb-3">
                    <label for="images" class="form-label">Hình Ảnh</label>
                    <input type="file" class="form-control" id="images" name="images" multiple accept="image/*" required>
                </div>

                <div class="mb-3">
                    <label for="category" class="form-label">Danh Mục</label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="">Chọn danh mục</option>
                        <option value="CULTURE">Văn Hóa</option>
                        <option value="FOOD">Ẩm Thực</option>
                        <option value="ADVENTURE">Khám Phá</option>
                        <option value="NATURE">Thiên Nhiên</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="schedule" class="form-label">Lịch Trình</label>
                    <textarea class="form-control" id="schedule" name="schedule" rows="3" required></textarea>
                </div>

                <div class="mb-3">
                    <label for="requirements" class="form-label">Yêu Cầu</label>
                    <textarea class="form-control" id="requirements" name="requirements" rows="3"></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary px-5">Tạo Trải Nghiệm</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
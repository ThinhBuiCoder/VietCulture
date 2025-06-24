<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa ${serviceType == 'experience' ? 'Trải Nghiệm' : 'Lưu Trú'} - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--accent-color);
            padding-top: 100px;
            padding-bottom: 50px;
        }

        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: var(--light-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .form-header {
            padding: 40px;
            text-align: center;
            color: white;
        }

        .form-header.experience {
            background: var(--gradient-primary);
        }

        .form-header.accommodation {
            background: var(--gradient-secondary);
        }

        .form-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .form-body {
            padding: 40px;
        }

        .form-section {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            padding: 8px;
            border-radius: 8px;
            color: white;
        }

        .experience .section-title i {
            background: var(--primary-color);
        }

        .accommodation .section-title i {
            background: var(--secondary-color);
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid #e9ecef;
            padding: 12px 16px;
            transition: var(--transition);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 56, 92, 0.1);
        }

        .accommodation .form-control:focus, 
        .accommodation .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(131, 197, 190, 0.1);
        }

        .btn-submit {
            background: var(--gradient-primary);
            border: none;
            color: white;
            padding: 15px 40px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: var(--transition);
            width: 100%;
        }

        .accommodation .btn-submit {
            background: var(--gradient-secondary);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.3);
            color: white;
        }

        .accommodation .btn-submit:hover {
            box-shadow: 0 8px 20px rgba(131, 197, 190, 0.3);
        }

        .btn-back {
            background: transparent;
            border: 2px solid #6c757d;
            color: #6c757d;
            padding: 12px 30px;
            border-radius: 30px;
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background: #6c757d;
            color: white;
        }

        .alert {
            border-radius: 12px;
            border: none;
            margin-bottom: 20px;
        }

        .required {
            color: var(--primary-color);
        }

        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
        }

        /* Navbar styles */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
            z-index: 1000;
            padding: 15px 0;
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
            width: auto;
            margin-right: 12px;
        }

        /* Current Images */
        .current-images {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .current-image {
            position: relative;
            width: 100px;
            height: 100px;
            border-radius: 8px;
            overflow: hidden;
            border: 2px solid #e9ecef;
        }

        .current-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .remove-image {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--danger-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .form-container {
                margin: 0 15px;
            }
            
            .form-header, .form-body {
                padding: 20px;
            }
            
            .form-header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body class="${serviceType}">
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
        </div>
    </nav>

    <div class="container">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/host/services/manage" class="btn-back">
            <i class="ri-arrow-left-line me-2"></i>Quay Lại Quản Lý
        </a>

        <!-- Messages -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="ri-error-warning-line me-2"></i>
                ${sessionScope.error}
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="ri-check-circle-line me-2"></i>
                ${sessionScope.success}
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <!-- Form Container -->
        <div class="form-container">
            <!-- Form Header -->
            <div class="form-header ${serviceType}">
                <h1>Chỉnh Sửa ${serviceType == 'experience' ? 'Trải Nghiệm' : 'Lưu Trú'}</h1>
                <p>Cập nhật thông tin dịch vụ của bạn</p>
            </div>

            <!-- Form Body -->
            <div class="form-body">
                <!-- ✅ SỬA ACTION URL ĐỂ GỬI ĐẾN ĐÚNG ENDPOINT -->
                <c:choose>
                    <c:when test="${serviceType == 'experience'}">
                        <c:set var="formAction" value="${pageContext.request.contextPath}/host/services/edit/experience/${experience.experienceId}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="formAction" value="${pageContext.request.contextPath}/host/services/edit/accommodation/${accommodation.accommodationId}" />
                    </c:otherwise>
                </c:choose>

                <form method="POST" enctype="multipart/form-data" id="editServiceForm" action="${formAction}">
                    <!-- ✅ BỎ CÁC HIDDEN INPUT KHÔNG CẦN THIẾT -->
                    
                    <c:choose>
                        <c:when test="${serviceType == 'experience'}">
                            <!-- Experience Edit Form -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="ri-information-line"></i>
                                    Thông Tin Cơ Bản
                                </h3>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="title" class="form-label">Tiêu Đề <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="title" name="title" required
                                               value="${experience.title}">
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="description" class="form-label">Mô Tả Chi Tiết <span class="required">*</span></label>
                                        <textarea class="form-control" id="description" name="description" rows="5" required>${experience.description}</textarea>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="price" class="form-label">Giá <span class="required">*</span></label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="price" name="price" required 
                                                   min="0" step="1000" value="${experience.price}">
                                            <span class="input-group-text">VNĐ/người</span>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="cityId" class="form-label">Thành Phố <span class="required">*</span></label>
                                        <select class="form-select" id="cityId" name="cityId" required>
                                            <option value="">Chọn thành phố</option>
                                            <c:forEach var="city" items="${cities}">
                                                <option value="${city.cityId}" ${city.cityId == experience.cityId ? 'selected' : ''}>
                                                    <c:choose>
                                                        <c:when test="${not empty city.vietnameseName}">
                                                            ${city.vietnameseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${city.name}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="location" class="form-label">Địa Điểm Cụ Thể <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="location" name="location" required
                                               value="${experience.location}">
                                    </div>
                                </div>
                            </div>

                            <!-- Experience Details -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="ri-time-line"></i>
                                    Chi Tiết Trải Nghiệm
                                </h3>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="type" class="form-label">Loại Trải Nghiệm <span class="required">*</span></label>
                                        <select class="form-select" id="type" name="type" required>
                                            <option value="">Chọn loại trải nghiệm</option>
                                            <option value="Ẩm thực" ${experience.type == 'Ẩm thực' ? 'selected' : ''}>Ẩm thực</option>
                                            <option value="Văn hóa" ${experience.type == 'Văn hóa' ? 'selected' : ''}>Văn hóa</option>
                                            <option value="Thiên nhiên" ${experience.type == 'Thiên nhiên' ? 'selected' : ''}>Thiên nhiên</option>
                                            <option value="Workshop" ${experience.type == 'Workshop' ? 'selected' : ''}>Workshop</option>
                                            <option value="Phiêu lưu" ${experience.type == 'Phiêu lưu' ? 'selected' : ''}>Phiêu lưu</option>
                                            <option value="Lịch sử" ${experience.type == 'Lịch sử' ? 'selected' : ''}>Lịch sử</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="duration" class="form-label">Thời Gian (giờ) <span class="required">*</span></label>
                                        <input type="number" class="form-control" id="duration" name="duration" required 
                                               min="1" max="24" value="${experience.duration.hours}">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="groupSize" class="form-label">Số Người Tối Đa <span class="required">*</span></label>
                                        <input type="number" class="form-control" id="groupSize" name="groupSize" required 
                                               min="1" max="50" value="${experience.maxGroupSize}">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="languages" class="form-label">Ngôn Ngữ Hỗ Trợ</label>
                                        <input type="text" class="form-control" id="languages" name="languages"
                                               value="${experience.language}" placeholder="Tiếng Việt, English">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="difficulty" class="form-label">Độ Khó</label>
                                        <select class="form-select" id="difficulty" name="difficulty">
                                            <option value="EASY" ${experience.difficulty == 'EASY' ? 'selected' : ''}>Dễ</option>
                                            <option value="MODERATE" ${experience.difficulty == 'MODERATE' ? 'selected' : ''}>Trung bình</option>
                                            <option value="CHALLENGING" ${experience.difficulty == 'CHALLENGING' ? 'selected' : ''}>Khó</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="included" class="form-label">Bao Gồm</label>
                                        <textarea class="form-control" id="included" name="included" rows="3">${experience.includedItems}</textarea>
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="requirements" class="form-label">Yêu Cầu</label>
                                        <textarea class="form-control" id="requirements" name="requirements" rows="3">${experience.requirements}</textarea>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Accommodation Edit Form -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="ri-information-line"></i>
                                    Thông Tin Cơ Bản
                                </h3>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="title" class="form-label">Tên Lưu Trú <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="title" name="title" required
                                               value="${accommodation.name}">
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="description" class="form-label">Mô Tả Chi Tiết <span class="required">*</span></label>
                                        <textarea class="form-control" id="description" name="description" rows="5" required>${accommodation.description}</textarea>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="price" class="form-label">Giá <span class="required">*</span></label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="price" name="price" required 
                                                   min="0" step="1000" value="${accommodation.pricePerNight}">
                                            <span class="input-group-text">VNĐ/đêm</span>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="cityId" class="form-label">Thành Phố <span class="required">*</span></label>
                                        <select class="form-select" id="cityId" name="cityId" required>
                                            <option value="">Chọn thành phố</option>
                                            <c:forEach var="city" items="${cities}">
                                                <option value="${city.cityId}" ${city.cityId == accommodation.cityId ? 'selected' : ''}>
                                                    <c:choose>
                                                        <c:when test="${not empty city.vietnameseName}">
                                                            ${city.vietnameseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${city.name}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="address" class="form-label">Địa Chỉ Cụ Thể <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="address" name="address" required
                                               value="${accommodation.address}">
                                    </div>
                                </div>
                            </div>

                            <!-- Accommodation Details -->
                            <div class="form-section">
                                <h3 class="section-title">
                                    <i class="ri-home-2-line"></i>
                                    Chi Tiết Lưu Trú
                                </h3>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="accommodationType" class="form-label">Loại Lưu Trú <span class="required">*</span></label>
                                        <select class="form-select" id="accommodationType" name="accommodationType" required>
                                            <option value="">Chọn loại lưu trú</option>
                                            <option value="Homestay" ${accommodation.type == 'Homestay' ? 'selected' : ''}>Homestay</option>
                                            <option value="Hotel" ${accommodation.type == 'Hotel' ? 'selected' : ''}>Khách sạn</option>
                                            <option value="Resort" ${accommodation.type == 'Resort' ? 'selected' : ''}>Resort</option>
                                            <option value="Villa" ${accommodation.type == 'Villa' ? 'selected' : ''}>Villa</option>
                                            <option value="Apartment" ${accommodation.type == 'Apartment' ? 'selected' : ''}>Căn hộ</option>
                                            <option value="Hostel" ${accommodation.type == 'Hostel' ? 'selected' : ''}>Hostel</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="bedrooms" class="form-label">Số Phòng Ngủ</label>
                                        <input type="number" class="form-control" id="bedrooms" name="bedrooms" 
                                               min="1" max="10" value="${accommodation.numberOfRooms}">
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="amenities" class="form-label">Tiện Nghi</label>
                                        <textarea class="form-control" id="amenities" name="amenities" rows="4">${accommodation.amenities}</textarea>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Current Images Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-image-line"></i>
                            Hình Ảnh Hiện Tại
                        </h3>

                        <c:set var="currentImages" value="${serviceType == 'experience' ? experience.images : accommodation.images}" />
                        <c:if test="${not empty currentImages}">
                            <div class="current-images">
                                <c:forEach var="image" items="${fn:split(currentImages, ',')}" varStatus="status">
                                    <div class="current-image">
                                        <img src="${pageContext.request.contextPath}/${fn:trim(image)}" alt="Current image ${status.index + 1}">
                                        <button type="button" class="remove-image" onclick="removeImage('${fn:trim(image)}')">×</button>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="mt-3">
                            <label for="images" class="form-label">Thêm Hình Ảnh Mới</label>
                            <input type="file" class="form-control" id="images" name="images" multiple accept="image/*">
                            <div class="help-text">Chọn hình ảnh mới để thêm vào dịch vụ</div>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-submit">
                            <i class="ri-save-line me-2"></i>
                            Cập Nhật ${serviceType == 'experience' ? 'Trải Nghiệm' : 'Lưu Trú'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('editServiceForm').addEventListener('submit', function(e) {
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc');
            }
        });

        // Auto-resize textareas
        document.querySelectorAll('textarea').forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
            // Trigger on page load
            textarea.style.height = textarea.scrollHeight + 'px';
        });

        // Remove image functionality
        function removeImage(imagePath) {
            if (confirm('Bạn có chắc muốn xóa hình ảnh này?')) {
                // Create hidden input to mark image for removal
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'removeImages';
                hiddenInput.value = imagePath;
                document.getElementById('editServiceForm').appendChild(hiddenInput);
                
                // Hide the image visually
                event.target.closest('.current-image').style.display = 'none';
            }
        }

        // Image preview for new uploads
        document.getElementById('images').addEventListener('change', function(e) {
            const files = e.target.files;
            const container = this.parentNode;
            
            // Remove previous preview
            const existingPreview = container.querySelector('.new-image-preview');
            if (existingPreview) {
                existingPreview.remove();
            }
            
            if (files.length > 0) {
                const preview = document.createElement('div');
                preview.className = 'new-image-preview mt-3';
                preview.innerHTML = '<strong>Hình ảnh mới được chọn:</strong>';
                
                Array.from(files).forEach((file, index) => {
                    if (file.type.startsWith('image/')) {
                        const span = document.createElement('span');
                        span.className = 'badge bg-primary me-2 mt-2';
                        span.textContent = file.name;
                        preview.appendChild(span);
                    }
                });
                
                container.appendChild(preview);
            }
        });
    </script>
</body>
</html>
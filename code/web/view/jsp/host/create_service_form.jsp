<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - VietCulture</title>
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

        .image-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            transition: var(--transition);
            cursor: pointer;
        }

        .image-upload-area:hover {
            border-color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.05);
        }

        .accommodation .image-upload-area:hover {
            border-color: var(--secondary-color);
            background-color: rgba(131, 197, 190, 0.05);
        }

        .image-preview {
            display: none;
            margin-top: 20px;
        }

        .image-preview img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 8px;
            margin: 5px;
            object-fit: cover;
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
        <a href="${pageContext.request.contextPath}/Travel/create_service" class="btn-back">
            <i class="ri-arrow-left-line me-2"></i>Quay Lại
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
                <h1>${pageTitle}</h1>
                <p>${pageDescription}</p>
            </div>

            <!-- Form Body -->
            <div class="form-body">
                <form method="POST" enctype="multipart/form-data" id="serviceForm">
                    <!-- Basic Information -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông Tin Cơ Bản
                        </h3>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="title" class="form-label">
                                    Tiêu Đề <span class="required">*</span>
                                </label>
                                <input type="text" class="form-control" id="title" name="title" required
                                       placeholder="${serviceType == 'experience' ? 'Ví dụ: Tour ẩm thực phố cổ Hà Nội' : 'Ví dụ: Homestay ven biển Đà Nẵng'}">
                                <div class="help-text">Tiêu đề hấp dẫn sẽ thu hút nhiều khách hàng hơn</div>
                            </div>

                            <div class="col-md-12 mb-3">
                                <label for="description" class="form-label">
                                    Mô Tả Chi Tiết <span class="required">*</span>
                                </label>
                                <textarea class="form-control" id="description" name="description" rows="5" required
                                          placeholder="Mô tả chi tiết về ${serviceType == 'experience' ? 'trải nghiệm' : 'chỗ lưu trú'} của bạn..."></textarea>
                                <div class="help-text">Mô tả càng chi tiết, khách hàng càng tin tưởng</div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">
                                    Giá <span class="required">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="price" name="price" required min="0" step="1000">
                                    <span class="input-group-text">
                                        ${serviceType == 'experience' ? 'VNĐ/người' : 'VNĐ/đêm'}
                                    </span>
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="promotion_percent" class="form-label">
                                    Khuyến Mãi (%)
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="promotion_percent" name="promotion_percent" min="0" max="100" value="0">
                                    <span class="input-group-text">%</span>
                                </div>
                                <div class="help-text">Phần trăm giảm giá khuyến mãi (nếu có)</div>
                            </div>

                            <!-- Promotion Start Date -->
                            <div class="col-md-6 mb-3">
                                <label for="promotion_start" class="form-label">Khuyến Mãi Từ Ngày</label>
                                <input type="datetime-local" class="form-control" id="promotion_start" name="promotion_start">
                                <div class="help-text">Thời gian bắt đầu khuyến mãi (tùy chọn)</div>
                            </div>
                            
                            <!-- Promotion End Date -->
                            <div class="col-md-6 mb-3">
                                <label for="promotion_end" class="form-label">Khuyến Mãi Đến Ngày</label>
                                <input type="datetime-local" class="form-control" id="promotion_end" name="promotion_end">
                                <div class="help-text">Thời gian kết thúc khuyến mãi (tùy chọn)</div>
                            </div>

                            <!-- Location Section với Region/City Selection -->
                            <div class="col-md-6 mb-3">
                                <label for="regionId" class="form-label">
                                    Miền <span class="required">*</span>
                                </label>
                                <select class="form-select" id="regionId" name="regionId" required onchange="loadCitiesByRegion()">
                                    <option value="">Chọn miền</option>
                                    <c:forEach var="region" items="${regions}">
                                      <option value="${region.regionId}">${region.vietnameseName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="cityId" class="form-label">
                                    Thành Phố <span class="required">*</span>
                                </label>
                                <select class="form-select" id="cityId" name="cityId" required disabled>
                                    <option value="">Chọn miền trước</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Service Specific Fields -->
                    <c:choose>
                        <c:when test="${serviceType == 'experience'}">
    <!-- Experience Specific Fields -->
    <div class="form-section">
        <h3 class="section-title">
            <i class="ri-time-line"></i>
            Chi Tiết Trải Nghiệm
        </h3>

        <div class="row">
            <!-- LOCATION - REQUIRED theo DB -->
            <div class="col-md-12 mb-3">
                <label for="location" class="form-label">
                    Địa Điểm Cụ Thể <span class="required">*</span>
                </label>
                <input type="text" class="form-control" id="location" name="location" required
                       placeholder="Địa chỉ hoặc điểm hẹn cụ thể">
                <div class="help-text">Địa điểm tập trung hoặc điểm bắt đầu tour (bắt buộc)</div>
            </div>

            <!-- TYPE - REQUIRED theo DB -->
            <div class="col-md-6 mb-3">
                <label for="type" class="form-label">
                    Loại Trải Nghiệm <span class="required">*</span>
                </label>
                <select class="form-select" id="type" name="type" required>
                    <option value="">Chọn loại trải nghiệm</option>
                    <option value="Food">Ẩm thực</option>
                    <option value="Culture">Văn hóa</option>
                    <option value="Adventure">Phiêu lưu</option>
                    <option value="History">Lịch sử</option>
                </select>
            </div>

            <!-- DURATION - REQUIRED theo DB -->
            <div class="col-md-6 mb-3">
                <label for="duration" class="form-label">
                    Thời Gian (giờ) <span class="required">*</span>
                </label>
                <input type="number" class="form-control" id="duration" name="duration" 
                       required min="1" max="24" placeholder="Ví dụ: 3">
                <div class="help-text">Thời gian thực hiện trải nghiệm</div>
            </div>

            <!-- MAX GROUP SIZE - REQUIRED theo DB -->
            <div class="col-md-6 mb-3">
                <label for="groupSize" class="form-label">
                    Số Người Tối Đa <span class="required">*</span>
                </label>
                <input type="number" class="form-control" id="groupSize" name="groupSize" 
                       required min="1" max="50" placeholder="Ví dụ: 10">
                <div class="help-text">Số lượng khách tối đa có thể tham gia</div>
            </div>

            <!-- LANGUAGE - Optional -->
            <div class="col-md-6 mb-3">
                <label for="languages" class="form-label">Ngôn Ngữ Hỗ Trợ</label>
                <input type="text" class="form-control" id="languages" name="languages" 
                       placeholder="Tiếng Việt, English">
                <div class="help-text">Các ngôn ngữ bạn có thể giao tiếp</div>
            </div>

            <!-- CATEGORY - Optional (nếu có bảng Categories) -->
            <div class="col-md-6 mb-3">
                <label for="categoryId" class="form-label">Danh Mục</label>
                <select class="form-select" id="categoryId" name="categoryId">
                    <option value="">Chọn danh mục (tùy chọn)</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- DIFFICULTY - với giá trị chuẩn -->
            <div class="col-md-6 mb-3">
                <label for="difficulty" class="form-label">Độ Khó</label>
                <select class="form-select" id="difficulty" name="difficulty">
                    <option value="Dễ">Dễ (EASY)</option>
                    <option value="Trung bình" selected>Trung bình (MODERATE)</option>
                    <option value="Khó">Khó (CHALLENGING)</option>
                </select>
                <div class="help-text">Đánh giá mức độ khó của trải nghiệm</div>
            </div>
        </div>

        <div class="row">
            <!-- INCLUDED ITEMS - Optional -->
            <div class="col-md-12 mb-3">
                <label for="included" class="form-label">Bao Gồm</label>
                <textarea class="form-control" id="included" name="included" rows="3" 
                          placeholder="Những gì được bao gồm trong trải nghiệm: thức ăn, đồ uống, vận chuyển..."></textarea>
                <div class="help-text">Liệt kê những gì được bao gồm trong giá</div>
            </div>

            <!-- REQUIREMENTS - Optional -->
            <div class="col-md-12 mb-3">
                <label for="requirements" class="form-label">Yêu Cầu</label>
                <textarea class="form-control" id="requirements" name="requirements" rows="3" 
                          placeholder="Yêu cầu và lưu ý cho khách tham gia: độ tuổi, sức khỏe, trang phục..."></textarea>
                <div class="help-text">Các yêu cầu hoặc lưu ý cho khách hàng</div>
            </div>
        </div>
    </div>
</c:when>
                        <c:otherwise>
                            <!-- Accommodation Specific Fields -->
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
                                            <option value="Homestay">Homestay</option>
                                            <option value="Hotel">Khách sạn</option>
                                            <option value="Resort">Resort</option>
                                            <option value="Villa">Villa</option>
                                            <option value="Apartment">Căn hộ</option>
                                            <option value="Hostel">Hostel</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="maxGuests" class="form-label">Số Khách Tối Đa</label>
                                        <input type="number" class="form-control" id="maxGuests" name="maxGuests" min="1" max="20" value="2">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="bedrooms" class="form-label">Số Phòng Ngủ</label>
                                        <input type="number" class="form-control" id="bedrooms" name="bedrooms" min="1" max="10" value="1">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="bathrooms" class="form-label">Số Phòng Tắm</label>
                                        <input type="number" class="form-control" id="bathrooms" name="bathrooms" min="1" max="10" value="1">
                                    </div>

                                    <!-- Địa chỉ cụ thể CHỈ cho Accommodation -->
                                    <div class="col-md-12 mb-3">
                                        <label for="address" class="form-label">Địa Chỉ Cụ Thể <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="address" name="address" required
                                               placeholder="Số nhà, tên đường, phường/xã...">
                                        <div class="help-text">Địa chỉ chi tiết của chỗ lưu trú</div>
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <label for="amenities" class="form-label">Tiện Nghi</label>
                                        <textarea class="form-control" id="amenities" name="amenities" rows="4" 
                                                  placeholder="Mô tả các tiện nghi có sẵn: WiFi, điều hòa, bếp, máy giặt..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Images Upload Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-image-line"></i>
                            Hình Ảnh
                        </h3>

                        <div class="image-upload-area" onclick="document.getElementById('images').click()">
                            <i class="ri-upload-cloud-2-line" style="font-size: 3rem; color: #dee2e6; margin-bottom: 15px;"></i>
                            <h5>Tải lên hình ảnh</h5>
                            <p>Chọn hoặc kéo thả hình ảnh vào đây</p>
                            <small class="text-muted">Hỗ trợ: JPG, PNG, GIF (tối đa 10MB mỗi file)</small>
                        </div>
                        
                        <input type="file" id="images" name="images" multiple accept="image/*" style="display: none;" onchange="previewImages(this)">
                        
                        <div class="image-preview" id="imagePreview">
                            <!-- Preview images will be shown here -->
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-submit">
                            <i class="ri-save-line me-2"></i>
                            <c:choose>
                                <c:when test="${serviceType == 'experience'}">
                                    Tạo Trải Nghiệm
                                </c:when>
                                <c:otherwise>
                                    Tạo Lưu Trú
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cities data (load từ server)
        const citiesData = [
            <c:forEach var="city" items="${cities}" varStatus="status">
                {
                    cityId: ${city.cityId},
                    cityName: "<c:choose><c:when test='${not empty city.vietnameseName}'>${city.vietnameseName}</c:when><c:otherwise>${city.name}</c:otherwise></c:choose>",
                    regionId: ${city.regionId}
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Load cities based on selected region
        function loadCitiesByRegion() {
            const regionSelect = document.getElementById('regionId');
            const citySelect = document.getElementById('cityId');
            const selectedRegionId = parseInt(regionSelect.value);

            // Clear city options
            citySelect.innerHTML = '<option value="">Chọn thành phố</option>';
            
            if (selectedRegionId) {
                // Filter cities by region
                const filteredCities = citiesData.filter(city => city.regionId === selectedRegionId);
                
                console.log('Selected region ID:', selectedRegionId);
                console.log('Filtered cities:', filteredCities);
                
                // Add city options
                filteredCities.forEach(city => {
                    const option = document.createElement('option');
                    option.value = city.cityId;
                    option.textContent = city.cityName;
                    citySelect.appendChild(option);
                });
                
                // Enable city select
                citySelect.disabled = false;
                
                if (filteredCities.length === 0) {
                    citySelect.innerHTML = '<option value="">Không có thành phố nào</option>';
                }
            } else {
                // Disable city select
                citySelect.disabled = true;
            }
        }

        // Image preview functionality
function previewImages(input) {
    console.log('previewImages called');
    const preview = document.getElementById('imagePreview');
    preview.innerHTML = '';
    
    if (!input.files) {
        console.log('No files selected');
        return;
    }
    
    const files = Array.from(input.files);
    console.log('Files selected:', files.length);
    
    // Validate file count (optional - match servlet limits)
    if (files.length > 10) {
        alert('Chỉ được chọn tối đa 10 ảnh.');
        input.value = '';
        return;
    }
    
    let validFiles = [];
    
    files.forEach((file, index) => {
        console.log(`Processing file ${index + 1}:`, file.name, file.size, 'bytes');
        
        // Validate file type (match servlet validation)
        if (!isValidImageFile(file.name)) {
            alert(`File "${file.name}" không phải là định dạng ảnh hợp lệ (.jpg, .jpeg, .png, .gif).`);
            return;
        }
        
        // Validate file size (match servlet: 10MB max)
        if (file.size > 10 * 1024 * 1024) {
            alert(`File "${file.name}" quá lớn! Vui lòng chọn file nhỏ hơn 10MB.`);
            return;
        }
        
        validFiles.push(file);
        
        const reader = new FileReader();
        
        reader.onload = function(e) {
            console.log(`Image loaded for file: ${file.name}`);
            
            const imgContainer = document.createElement('div');
            imgContainer.className = 'image-preview-item';
            imgContainer.style.display = 'inline-block';
            imgContainer.style.position = 'relative';
            imgContainer.style.margin = '8px';
            imgContainer.style.border = '2px solid #dee2e6';
            imgContainer.style.borderRadius = '12px';
            imgContainer.style.overflow = 'hidden';
            imgContainer.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
            imgContainer.style.transition = 'all 0.3s ease';
            
            const img = document.createElement('img');
            img.src = e.target.result;
            img.alt = `Preview ${index + 1}`;
            img.style.width = '150px';
            img.style.height = '150px';
            img.style.objectFit = 'cover';
            img.style.display = 'block';
            
            // File info overlay
            const fileInfo = document.createElement('div');
            fileInfo.className = 'file-info';
            fileInfo.style.position = 'absolute';
            fileInfo.style.bottom = '0';
            fileInfo.style.left = '0';
            fileInfo.style.right = '0';
            fileInfo.style.background = 'rgba(0,0,0,0.7)';
            fileInfo.style.color = 'white';
            fileInfo.style.padding = '4px 8px';
            fileInfo.style.fontSize = '11px';
            fileInfo.style.lineHeight = '1.2';
            
            const fileName = sanitizeDisplayName(file.name);
            const fileSize = formatFileSize(file.size);
            fileInfo.innerHTML = `${fileName}<br>${fileSize}`;
            
            const removeBtn = document.createElement('button');
            removeBtn.innerHTML = '×';
            removeBtn.title = 'Xóa ảnh này';
            removeBtn.className = 'remove-image-btn';
            removeBtn.style.position = 'absolute';
            removeBtn.style.top = '-8px';
            removeBtn.style.right = '-8px';
            removeBtn.style.background = '#dc3545';
            removeBtn.style.color = 'white';
            removeBtn.style.border = 'none';
            removeBtn.style.borderRadius = '50%';
            removeBtn.style.width = '28px';
            removeBtn.style.height = '28px';
            removeBtn.style.cursor = 'pointer';
            removeBtn.style.fontSize = '18px';
            removeBtn.style.lineHeight = '1';
            removeBtn.style.fontWeight = 'bold';
            removeBtn.style.boxShadow = '0 2px 4px rgba(0,0,0,0.3)';
            removeBtn.style.transition = 'all 0.2s ease';
            
            // Hover effects
            removeBtn.onmouseover = function() {
                this.style.background = '#c82333';
                this.style.transform = 'scale(1.1)';
            };
            
            removeBtn.onmouseout = function() {
                this.style.background = '#dc3545';
                this.style.transform = 'scale(1)';
            };
            
            imgContainer.onmouseover = function() {
                this.style.borderColor = '#10466C';
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
            };
            
            imgContainer.onmouseout = function() {
                this.style.borderColor = '#dee2e6';
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
            };
            
            removeBtn.onclick = function(e) {
                e.preventDefault();
                console.log('Removing image:', file.name);
                
                // Remove from preview
                imgContainer.remove();
                
                // Update file input by removing this file
                removeFileFromInput(input, index);
                
                // Update counter
                updateImageCounter();
            };
            
            imgContainer.appendChild(img);
            imgContainer.appendChild(fileInfo);
            imgContainer.appendChild(removeBtn);
            preview.appendChild(imgContainer);
            
            // Update counter after adding image
            updateImageCounter();
        };
        
        reader.onerror = function() {
            console.error('Error reading file:', file.name);
            alert(`Không thể đọc file "${file.name}".`);
        };
        
        reader.readAsDataURL(file);
    });
    
    // Show preview container if we have valid files
    if (validFiles.length > 0) {
        preview.style.display = 'block';
        console.log('Valid files processed:', validFiles.length);
    } else {
        preview.style.display = 'none';
        input.value = ''; // Clear input if no valid files
    }
}

// Helper function to validate image file (match servlet logic)
function isValidImageFile(fileName) {
    if (!fileName) return false;
    const lowerFileName = fileName.toLowerCase();
    return lowerFileName.endsWith('.jpg') || 
           lowerFileName.endsWith('.jpeg') || 
           lowerFileName.endsWith('.png') || 
           lowerFileName.endsWith('.gif');
}

// Helper function to sanitize file name for display (match servlet logic)
function sanitizeDisplayName(fileName) {
    if (!fileName) return 'image';
    
    // Get just the filename without path
    fileName = fileName.split('/').pop().split('\\').pop();
    
    // Truncate if too long
    if (fileName.length > 20) {
        const extension = fileName.substring(fileName.lastIndexOf('.'));
        const nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
        return nameWithoutExt.substring(0, 15) + '...' + extension;
    }
    
    return fileName;
}

// Helper function to format file size
function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
}

// Helper function to remove file from input
function removeFileFromInput(input, indexToRemove) {
    const dt = new DataTransfer();
    const files = Array.from(input.files);
    
    files.forEach((file, index) => {
        if (index !== indexToRemove) {
            dt.items.add(file);
        }
    });
    
    input.files = dt.files;
    console.log('Updated file input. Remaining files:', input.files.length);
}

// Helper function to update image counter
function updateImageCounter() {
    const preview = document.getElementById('imagePreview');
    const images = preview.querySelectorAll('.image-preview-item');
    const counter = document.getElementById('imageCounter');
    
    if (counter) {
        counter.textContent = `${images.length} ảnh đã chọn`;
        counter.style.display = images.length > 0 ? 'block' : 'none';
    }
}

// Optional: Add CSS styles dynamically
function addImagePreviewStyles() {
    const style = document.createElement('style');
    style.textContent = `
        #imagePreview {
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            background: #f8f9fa;
            margin-top: 10px;
        }
        
        #imagePreview:empty {
            display: none !important;
        }
        
        .image-preview-item {
            animation: fadeIn 0.3s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .remove-image-btn:active {
            transform: scale(0.95) !important;
        }
        
        #imageCounter {
            color: #6c757d;
            font-size: 14px;
            margin-top: 8px;
            font-weight: 500;
        }
    `;
    document.head.appendChild(style);
}

// Initialize styles when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    addImagePreviewStyles();
    console.log('Image preview styles initialized');
});

        // Form validation
      document.getElementById('serviceForm').addEventListener('submit', function(e) {
    const serviceType = '${serviceType}';
    const requiredFields = this.querySelectorAll('[required]');
    let isValid = true;
    let missingFields = [];
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            missingFields.push(field.previousElementSibling.textContent.replace('*', '').trim());
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
        }
    });
    
    // Additional validation for experience
    if (serviceType === 'experience') {
        const location = document.getElementById('location');
        const type = document.getElementById('type');
        const groupSize = document.getElementById('groupSize');
        const duration = document.getElementById('duration');
        
        if (!location.value.trim()) {
            location.classList.add('is-invalid');
            missingFields.push('Địa điểm cụ thể');
            isValid = false;
        }
        
        if (!type.value.trim()) {
            type.classList.add('is-invalid');
            missingFields.push('Loại trải nghiệm');
            isValid = false;
        }
        
        if (!groupSize.value.trim()) {
            groupSize.classList.add('is-invalid');
            missingFields.push('Số người tối đa');
            isValid = false;
        }
        
        if (!duration.value.trim()) {
            duration.classList.add('is-invalid');
            missingFields.push('Thời gian');
            isValid = false;
        }
    }
    
    if (!isValid) {
        e.preventDefault();
        alert('Vui lòng điền đầy đủ các trường bắt buộc:\n- ' + missingFields.join('\n- '));
    }
});

        // Auto-resize textareas
        document.querySelectorAll('textarea').forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        });

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Debug: Check if data is loaded
            console.log('Regions data:', 
                <c:choose>
                    <c:when test="${not empty regions}">
                        [<c:forEach var="region" items="${regions}" varStatus="status">
                            {id: ${region.regionId}, name: "${region.name}", vnName: "${region.vietnameseName}"}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>]
                    </c:when>
                    <c:otherwise>
                        'No regions loaded'
                    </c:otherwise>
                </c:choose>
            );
            
            console.log('Cities data loaded:', citiesData.length);
            console.log('First few cities:', citiesData.slice(0, 5));
            
            // Check if regions dropdown has options
            const regionSelect = document.getElementById('regionId');
            console.log('Region options count:', regionSelect.options.length);
        });
    </script>
    <script>
        // Validate form for handling promotion fields
        document.addEventListener('DOMContentLoaded', function() {
            // Get promotion fields
            const promotionPercentInput = document.getElementById('promotion_percent');
            const promotionStartInput = document.getElementById('promotion_start');
            const promotionEndInput = document.getElementById('promotion_end');
            
            // Function to update promotion date fields status
            function updatePromotionDateFields() {
                const percentValue = parseInt(promotionPercentInput.value) || 0;
                
                if (percentValue > 0) {
                    // If there's a promotion percent, enable date fields
                    promotionStartInput.disabled = false;
                    promotionEndInput.disabled = false;
                    
                    // Set default dates if empty
                    if (!promotionStartInput.value) {
                        const now = new Date();
                        promotionStartInput.value = now.toISOString().slice(0, 16);
                    }
                    
                    if (!promotionEndInput.value) {
                        const oneMonthLater = new Date();
                        oneMonthLater.setMonth(oneMonthLater.getMonth() + 1);
                        promotionEndInput.value = oneMonthLater.toISOString().slice(0, 16);
                    }
                } else {
                    // If no promotion percent, disable and clear date fields
                    promotionStartInput.disabled = true;
                    promotionEndInput.disabled = true;
                    promotionStartInput.value = '';
                    promotionEndInput.value = '';
                }
            }
            
            // Initialize fields status
            updatePromotionDateFields();
            
            // Add event listener to update when promotion percent changes
            promotionPercentInput.addEventListener('change', updatePromotionDateFields);
            promotionPercentInput.addEventListener('input', updatePromotionDateFields);
            
            // Add validation to ensure promotion dates are valid
            document.getElementById('serviceForm').addEventListener('submit', function(e) {
                const percentValue = parseInt(promotionPercentInput.value) || 0;
                
                if (percentValue > 0) {
                    const startDate = new Date(promotionStartInput.value);
                    const endDate = new Date(promotionEndInput.value);
                    
                    // Validate dates if promotion is set
                    if (isNaN(startDate.getTime())) {
                        e.preventDefault();
                        alert('Vui lòng nhập ngày bắt đầu khuyến mãi hợp lệ.');
                        promotionStartInput.focus();
                        return;
                    }
                    
                    if (isNaN(endDate.getTime())) {
                        e.preventDefault();
                        alert('Vui lòng nhập ngày kết thúc khuyến mãi hợp lệ.');
                        promotionEndInput.focus();
                        return;
                    }
                    
                    if (startDate >= endDate) {
                        e.preventDefault();
                        alert('Ngày kết thúc khuyến mãi phải sau ngày bắt đầu.');
                        promotionEndInput.focus();
                        return;
                    }
                }
            });
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nâng Cấp Tài Khoản Host - VietCulture</title>
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
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            min-height: 100vh;
            padding: 40px 0;
        }

        .upgrade-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .upgrade-header {
            background: var(--gradient-primary);
            color: white;
            padding: 40px;
            text-align: center;
        }

        .upgrade-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .upgrade-header p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 0;
        }

        .upgrade-content {
            padding: 40px;
        }

        .benefits-section {
            background: rgba(131, 197, 190, 0.1);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .benefit-item:last-child {
            margin-bottom: 0;
        }

        .benefit-icon {
            width: 40px;
            height: 40px;
            background: var(--gradient-secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 1.2rem;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            font-family: 'Playfair Display', serif;
            color: var(--dark-color);
            margin-bottom: 20px;
            font-size: 1.5rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 16px;
            transition: var(--transition);
            font-size: 1rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
        }

        .form-control.is-invalid {
            border-color: #dc3545;
        }

        .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
        }

        .btn-primary {
            background: var(--gradient-primary);
            border: none;
            border-radius: 30px;
            padding: 15px 40px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: var(--transition);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 30px;
            padding: 15px 40px;
            font-weight: 600;
            transition: var(--transition);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: #721c24;
        }

        .alert-success {
            background-color: rgba(40, 167, 69, 0.1);
            color: #155724;
        }

        .required {
            color: var(--primary-color);
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }

        .progress-steps::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: #e9ecef;
            z-index: 1;
        }

        .step {
            background: white;
            border: 3px solid var(--primary-color);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: var(--primary-color);
            position: relative;
            z-index: 2;
        }

        .step.completed {
            background: var(--primary-color);
            color: white;
        }

        @media (max-width: 768px) {
            .upgrade-container {
                margin: 20px;
            }

            .upgrade-header {
                padding: 30px 20px;
            }

            .upgrade-header h1 {
                font-size: 2rem;
            }

            .upgrade-content {
                padding: 30px 20px;
            }

            .benefits-section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="upgrade-container">
            <!-- Header -->
            <div class="upgrade-header">
                <h1>Trở Thành Host VietCulture</h1>
                <p>Chia sẻ trải nghiệm độc đáo và kiếm thêm thu nhập</p>
            </div>

            <!-- Content -->
            <div class="upgrade-content">
                <!-- Progress Steps -->
                <div class="progress-steps">
                    <div class="step completed">1</div>
                    <div class="step">2</div>
                    <div class="step">3</div>
                </div>

                <!-- Benefits Section -->
                <div class="benefits-section">
                    <h3><i class="ri-star-line"></i> Lợi Ích Khi Trở Thành Host</h3>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="ri-money-dollar-circle-line"></i>
                        </div>
                        <div>
                            <strong>Thu Nhập Bổ Sung</strong><br>
                            <small class="text-muted">Kiếm thêm thu nhập từ việc chia sẻ trải nghiệm hoặc cho thuê nơi ở</small>
                        </div>
                    </div>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="ri-global-line"></i>
                        </div>
                        <div>
                            <strong>Kết Nối Quốc Tế</strong><br>
                            <small class="text-muted">Gặp gỡ du khách từ khắp nơi trên thế giới</small>
                        </div>
                    </div>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="ri-heart-line"></i>
                        </div>
                        <div>
                            <strong>Chia Sẻ Văn Hóa</strong><br>
                            <small class="text-muted">Giới thiệu văn hóa Việt Nam và tạo kỷ niệm đáng nhớ</small>
                        </div>
                    </div>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="ri-error-warning-line me-2"></i>${error}
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="ri-check-circle-line me-2"></i>${success}
                    </div>
                </c:if>

                <!-- Upgrade Form -->
                <form action="${pageContext.request.contextPath}/host/upgrade" method="post" id="upgradeForm">
                    <!-- Business Information -->
                    <div class="form-section">
                        <h3><i class="ri-building-line me-2"></i>Thông Tin Kinh Doanh</h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="businessName" class="form-label">
                                        Tên Doanh Nghiệp/Dịch Vụ <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="businessName" name="businessName" 
                                           required placeholder="VD: Homestay Hoa Mai">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="businessType" class="form-label">
                                        Loại Hình Kinh Doanh <span class="required">*</span>
                                    </label>
                                    <select class="form-control" id="businessType" name="businessType" required>
                                        <option value="">Chọn loại hình</option>
                                        <option value="Homestay">Homestay</option>
                                        <option value="Hotel">Khách sạn</option>
                                        <option value="Resort">Resort</option>
                                        <option value="Tour">Tour du lịch</option>
                                        <option value="Experience">Trải nghiệm văn hóa</option>
                                        <option value="Restaurant">Nhà hàng</option>
                                        <option value="Other">Khác</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="businessAddress" class="form-label">Địa Chỉ Kinh Doanh</label>
                            <input type="text" class="form-control" id="businessAddress" name="businessAddress" 
                                   placeholder="Địa chỉ chi tiết của doanh nghiệp">
                        </div>

                        <div class="form-group">
                            <label for="businessDescription" class="form-label">Mô Tả Doanh Nghiệp</label>
                            <textarea class="form-control" id="businessDescription" name="businessDescription" 
                                      rows="4" placeholder="Mô tả về doanh nghiệp, dịch vụ của bạn..."></textarea>
                        </div>
                    </div>

                    <!-- Personal Information -->
                    <div class="form-section">
                        <h3><i class="ri-user-line me-2"></i>Thông Tin Cá Nhân</h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="skills" class="form-label">Kỹ Năng & Chuyên Môn</label>
                                    <input type="text" class="form-control" id="skills" name="skills" 
                                           placeholder="VD: Nấu ăn, hướng dẫn viên, nhiếp ảnh...">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="region" class="form-label">Khu Vực Hoạt Động</label>
                                    <select class="form-control" id="region" name="region">
                                        <option value="">Chọn khu vực</option>
                                        <option value="North">Miền Bắc</option>
                                        <option value="Central">Miền Trung</option>
                                        <option value="South">Miền Nam</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Terms & Conditions -->
                    <div class="form-section">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                            <label class="form-check-label" for="agreeTerms">
                                Tôi đồng ý với <a href="#" target="_blank">Điều khoản dịch vụ</a> và 
                                <a href="#" target="_blank">Chính sách bảo mật</a> của VietCulture
                            </label>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/Travel/create_service" class="btn btn-secondary">
                            <i class="ri-arrow-left-line me-2"></i>Quay Lại
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="ri-check-line me-2"></i>Nâng Cấp Tài Khoản
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('upgradeForm').addEventListener('submit', function(e) {
            const requiredFields = ['businessName', 'businessType', 'agreeTerms'];
            let isValid = true;

            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                const isCheckbox = field.type === 'checkbox';
                
                if ((isCheckbox && !field.checked) || (!isCheckbox && !field.value.trim())) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                document.querySelector('.is-invalid').scrollIntoView({ 
                    behavior: 'smooth', 
                    block: 'center' 
                });
            }
        });

        // Remove invalid class on input
        document.querySelectorAll('.form-control, .form-check-input').forEach(field => {
            field.addEventListener('input', function() {
                this.classList.remove('is-invalid');
            });
        });

        // Auto-resize textarea
        document.getElementById('businessDescription').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    </script>
</body>
</html>
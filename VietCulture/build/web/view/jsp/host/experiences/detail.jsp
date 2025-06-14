<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${experience.title} - VietCulture</title>
    
    <!-- Favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/assets/home/img/favicon.png">
    
    <!-- CSS -->
    <%@include file="../common/web/add_css.jsp"%>
    
    <style>
        .experience-header {
            position: relative;
            height: 400px;
            overflow: hidden;
        }
        .experience-header img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .experience-header-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.7));
            display: flex;
            align-items: flex-end;
            padding: 2rem;
        }
        .experience-title {
            color: white;
            margin: 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        .experience-meta {
            color: rgba(255,255,255,0.9);
            margin-top: 0.5rem;
        }
        .experience-content {
            padding: 2rem 0;
        }
        .experience-section {
            margin-bottom: 2rem;
        }
        .experience-section h3 {
            color: #10466C;
            margin-bottom: 1rem;
        }
        .host-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        .host-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }
        .status-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            margin-bottom: 1rem;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@include file="../common/web/header.jsp"%>

    <!-- Success Message -->
    <c:if test="${not empty message}">
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="ri-check-circle-line me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <!-- Experience Header -->
    <div class="experience-header">
        <img src="data:image/jpeg;base64,${experience.images}" alt="${experience.title}">
        <div class="experience-header-overlay">
            <div class="container">
                <h1 class="experience-title">${experience.title}</h1>
                <div class="experience-meta">
                    <i class="ri-map-pin-line me-2"></i>${experience.location}
                    <span class="mx-3">|</span>
                    <i class="ri-time-line me-2"></i>${experience.duration} giờ
                    <span class="mx-3">|</span>
                    <i class="ri-group-line me-2"></i>Tối đa ${experience.maxGroupSize} người
                </div>
            </div>
        </div>
    </div>

    <div class="container experience-content">
        <!-- Status Badge -->
        <c:choose>
            <c:when test="${experience.active}">
                <span class="status-badge status-active">
                    <i class="ri-check-circle-line me-1"></i>Đang hoạt động
                </span>
            </c:when>
            <c:when test="${experience.pending}">
                <span class="status-badge status-pending">
                    <i class="ri-time-line me-1"></i>Đang chờ phê duyệt
                </span>
            </c:when>
            <c:otherwise>
                <span class="status-badge status-inactive">
                    <i class="ri-close-circle-line me-1"></i>Không hoạt động
                </span>
            </c:otherwise>
        </c:choose>

        <div class="row">
            <div class="col-lg-8">
                <!-- Description -->
                <div class="experience-section">
                    <h3>Mô tả</h3>
                    <p>${experience.description}</p>
                </div>

                <!-- Details -->
                <div class="experience-section">
                    <h3>Chi tiết</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Loại trải nghiệm:</strong> ${experience.type}</p>
                            <p><strong>Độ khó:</strong> ${experience.difficulty}</p>
                            <p><strong>Ngôn ngữ:</strong> ${experience.language}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Giá:</strong> ${experience.price} VNĐ</p>
                            <p><strong>Số người tối đa:</strong> ${experience.maxGroupSize}</p>
                            <p><strong>Thời gian:</strong> ${experience.duration} giờ</p>
                        </div>
                    </div>
                </div>

                <!-- Requirements -->
                <c:if test="${not empty experience.requirements}">
                    <div class="experience-section">
                        <h3>Yêu cầu</h3>
                        <p>${experience.requirements}</p>
                    </div>
                </c:if>

                <!-- Included Items -->
                <c:if test="${not empty experience.includedItems}">
                    <div class="experience-section">
                        <h3>Bao gồm</h3>
                        <p>${experience.includedItems}</p>
                    </div>
                </c:if>
            </div>

            <div class="col-lg-4">
                <!-- Host Information -->
                <div class="host-info">
                    <div class="d-flex align-items-center mb-3">
                        <img src="${pageContext.request.contextPath}/view/assets/home/img/default-avatar.jpg" 
                             alt="${experience.host.fullName}" 
                             class="host-avatar me-3">
                        <div>
                            <h4 class="mb-1">${experience.host.fullName}</h4>
                            <p class="text-muted mb-0">Host</p>
                        </div>
                    </div>
                    <p class="mb-0">
                        <i class="ri-star-fill text-warning me-1"></i>
                        <strong>4.8</strong> (120 đánh giá)
                    </p>
                </div>

                <!-- Booking Section -->
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title mb-4">Đặt trải nghiệm</h4>
                        <p class="h3 mb-4">${experience.price} VNĐ</p>
                        <c:choose>
                            <c:when test="${experience.active}">
                                <a href="${pageContext.request.contextPath}/booking/create?experienceId=${experience.experienceId}" 
                                   class="btn btn-primary w-100">
                                    Đặt ngay
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary w-100" disabled>
                                    Tạm thời không thể đặt
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <%@include file="../common/web/footer.jsp"%>

    <!-- JavaScript -->
    <%@include file="../common/web/add_js.jsp"%>
</body>
</html>
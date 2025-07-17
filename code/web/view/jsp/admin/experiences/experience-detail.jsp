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
    <title>Chi tiết Trải nghiệm - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .status-badge {
            font-size: 0.85rem;
        }
        .gallery-img {
            height: 150px;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.2s;
            border-radius: 8px;
        }
        .gallery-img:hover {
            transform: scale(1.05);
        }
        .feature-icon {
            font-size: 1.2rem;
            margin-right: 0.5rem;
            color: #6c757d;
        }
        .section-heading {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            color: #495057;
        }
        .detail-item {
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            border-radius: 4px;
            background-color: #f8f9fa;
        }
        .detail-label {
            font-weight: 600;
            color: #495057;
        }
        .detail-value {
            color: #212529;
        }
        .amenity-badge {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            background-color: #e9ecef;
            color: #495057;
            font-weight: normal;
            font-size: 0.9rem;
        }
        .modal-img {
            width: 100%;
            max-height: 80vh;
            object-fit: contain;
        }
        .carousel-item img {
            width: 100%;
            height: 60vh;
            object-fit: cover;
            border-radius: 8px;
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
                    <h1 class="h2">Chi tiết Trải nghiệm</h1>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/experiences" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer"></div>

                <!-- Experience Details -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <h2>${experience.title}</h2>
                                <p class="text-muted">
                                    <i class="fas fa-map-marker-alt me-2"></i>${experience.location}, ${experience.cityName}
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${experience.adminApprovalStatus eq 'PENDING'}">
                                            <span class="badge bg-warning status-badge">
                                                <i class="fas fa-clock me-1"></i>Chờ duyệt
                                            </span>
                                        </c:when>
                                        <c:when test="${experience.adminApprovalStatus eq 'APPROVED'}">
                                            <span class="badge bg-success status-badge">
                                                <i class="fas fa-check-circle me-1"></i>Đã duyệt
                                            </span>
                                        </c:when>
                                        <c:when test="${experience.adminApprovalStatus eq 'REJECTED'}">
                                            <span class="badge bg-danger status-badge">
                                                <i class="fas fa-ban me-1"></i>Từ chối
                                            </span>
                                        </c:when>
                                    </c:choose>
                                    
                                    <c:if test="${experience.adminApprovalStatus eq 'APPROVED'}">
                                        <span class="badge ${experience.active ? 'bg-success' : 'bg-secondary'} ms-2 status-badge">
                                            <i class="fas ${experience.active ? 'fa-eye' : 'fa-eye-slash'} me-1"></i>
                                            ${experience.active ? 'Hiển thị' : 'Đang ẩn'}
                                        </span>
                                    </c:if>
                                </div>
                                
                                <!-- Action buttons -->
                                <div class="btn-group">
                                    <c:if test="${experience.adminApprovalStatus eq 'PENDING'}">
                                        <button class="btn btn-success approve-btn" 
                                                data-id="${experience.experienceId}">
                                            <i class="fas fa-check me-1"></i>Duyệt trải nghiệm
                                        </button>
                                        <button class="btn btn-danger ms-2 reject-btn"
                                                data-id="${experience.experienceId}">
                                            <i class="fas fa-times me-1"></i>Từ chối
                                        </button>
                                    </c:if>
                                    
                                    <button class="btn btn-warning ms-2 toggle-status-btn"
                                            data-id="${experience.experienceId}"
                                            data-current-status="${experience.active}">
                                        <i class="fas ${experience.active ? 'fa-eye-slash' : 'fa-eye'} me-1"></i>
                                        ${experience.active ? 'Ẩn trải nghiệm' : 'Hiển thị trải nghiệm'}
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Experience Images -->
                        <c:if test="${not empty experience.images}">
                            <div class="mb-4">
                                <div id="experienceCarousel" class="carousel slide" data-bs-ride="carousel">
                                    <div class="carousel-inner">
                                        <c:forEach var="image" items="${experience.images.split(',')}" varStatus="status">
                                            <div class="carousel-item ${status.first ? 'active' : ''}">
                                                <img src="${pageContext.request.contextPath}/images/experiences/${image}" 
                                                    alt="${experience.title}" class="d-block"
                                                    onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/assets/images/placeholder.jpg';">
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <button class="carousel-control-prev" type="button" data-bs-target="#experienceCarousel" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#experienceCarousel" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Thumbnails -->
                            <div class="row mb-4">
                                <c:forEach var="image" items="${experience.images.split(',')}" varStatus="status">
                                    <div class="col-md-2 col-4 mb-3">
                                        <img src="${pageContext.request.contextPath}/images/experiences/${image}" 
                                            alt="${experience.title}" class="img-fluid gallery-img"
                                            onclick="openImageModal('${pageContext.request.contextPath}/images/experiences/${image}')"
                                            onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/assets/images/placeholder.jpg';">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="row">
                            <div class="col-md-8">
                                <!-- Description -->
                                <h4 class="section-heading">Mô tả trải nghiệm</h4>
                                <p>${experience.description}</p>
                                
                                <!-- What's included -->
                                <h4 class="section-heading mt-4">Bao gồm</h4>
                                <p>${experience.includedItems}</p>
                                
                                <!-- Requirements -->
                                <h4 class="section-heading mt-4">Yêu cầu</h4>
                                <p>${experience.requirements}</p>
                            </div>
                            
                            <div class="col-md-4">
                                <!-- Details -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h5 class="mb-3">Thông tin chi tiết</h5>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-user me-2"></i>Host</div>
                                            <div class="detail-value">${experience.hostName} (ID: ${experience.hostId})</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-tags me-2"></i>Loại</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${experience.type eq 'Food'}">
                                                        <span class="badge bg-primary">Ẩm thực</span>
                                                    </c:when>
                                                    <c:when test="${experience.type eq 'Culture'}">
                                                        <span class="badge bg-info">Văn hóa</span>
                                                    </c:when>
                                                    <c:when test="${experience.type eq 'Adventure'}">
                                                        <span class="badge bg-success">Phiêu lưu</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${experience.type}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-coins me-2"></i>Giá</div>
                                            <div class="detail-value">
                                                <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                                <c:if test="${experience.promotionPercent > 0}">
                                                    <span class="badge bg-danger ms-2">Giảm ${experience.promotionPercent}%</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-users me-2"></i>Số người tối đa</div>
                                            <div class="detail-value">${experience.maxGroupSize}</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-clock me-2"></i>Thời gian</div>
                                            <div class="detail-value">
                                                <fmt:formatDate value="${experience.duration}" pattern="HH:mm"/> (giờ:phút)
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-hiking me-2"></i>Độ khó</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${experience.difficulty eq 'Easy'}">
                                                        <span class="badge bg-success">Dễ</span>
                                                    </c:when>
                                                    <c:when test="${experience.difficulty eq 'Moderate'}">
                                                        <span class="badge bg-warning">Trung bình</span>
                                                    </c:when>
                                                    <c:when test="${experience.difficulty eq 'Difficult'}">
                                                        <span class="badge bg-danger">Khó</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${experience.difficulty}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-globe me-2"></i>Ngôn ngữ</div>
                                            <div class="detail-value">${experience.language}</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-calendar me-2"></i>Ngày tạo</div>
                                            <div class="detail-value">
                                                <fmt:formatDate value="${experience.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-star me-2"></i>Đánh giá</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${experience.averageRating > 0}">
                                                        ${experience.averageRating} / 5 (${experience.totalBookings} lượt đặt)
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có đánh giá
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Admin Notes -->
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="mb-3">Thông tin hệ thống</h5>
                                        
                                        <c:if test="${not empty experience.adminApprovedAt}">
                                            <div class="detail-item">
                                                <div class="detail-label">Ngày duyệt/từ chối</div>
                                                <div class="detail-value">
                                                    <fmt:formatDate value="${experience.adminApprovedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty experience.adminRejectReason}">
                                            <div class="detail-item">
                                                <div class="detail-label">Lý do từ chối</div>
                                                <div class="detail-value text-danger">${experience.adminRejectReason}</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty experience.adminNotes}">
                                            <div class="detail-item">
                                                <div class="detail-label">Ghi chú admin</div>
                                                <div class="detail-value">${experience.adminNotes}</div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content">
                <div class="modal-body p-0">
                    <button type="button" class="btn-close position-absolute top-0 end-0 m-2" data-bs-dismiss="modal" aria-label="Close"></button>
                    <img id="modalImage" src="" alt="Experience image" class="modal-img">
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Từ chối trải nghiệm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="rejectForm">
                        <input type="hidden" id="rejectExperienceId" name="experienceId">
                        <div class="mb-3">
                            <label for="rejectReason" class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="rejectReason" name="reason" rows="4" required></textarea>
                            <div class="form-text">Lý do này sẽ được gửi cho Host để họ hiểu lý do bị từ chối.</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" id="confirmRejectBtn">Xác nhận từ chối</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Approve experience
            $('.approve-btn').click(function() {
                const experienceId = $(this).data('id');
                
                if (confirm('Bạn có chắc chắn muốn duyệt trải nghiệm này?')) {
                    $.post('${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/approve', 
                        function(response) {
                            if (response.success) {
                                showAlert('success', response.message);
                                setTimeout(function() {
                                    window.location.reload();
                                }, 1000);
                            } else {
                                showAlert('danger', response.message);
                            }
                        });
                }
            });
            
            // Show reject modal
            $('.reject-btn').click(function() {
                const experienceId = $(this).data('id');
                $('#rejectExperienceId').val(experienceId);
                $('#rejectModal').modal('show');
            });
            
            // Confirm reject
            $('#confirmRejectBtn').click(function() {
                const experienceId = $('#rejectExperienceId').val();
                const reason = $('#rejectReason').val().trim();
                
                if (!reason) {
                    alert('Vui lòng nhập lý do từ chối');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/reject',
                    { reason: reason },
                    function(response) {
                        $('#rejectModal').modal('hide');
                        
                        if (response.success) {
                            showAlert('success', response.message);
                            setTimeout(function() {
                                window.location.reload();
                            }, 1000);
                        } else {
                            showAlert('danger', response.message);
                        }
                    });
            });
            
            // Toggle status
            $('.toggle-status-btn').click(function() {
                const experienceId = $(this).data('id');
                const currentStatus = $(this).data('current-status');
                const action = currentStatus ? 'ẩn' : 'hiển thị';
                
                if (confirm('Bạn có chắc chắn muốn ' + action + ' trải nghiệm này?')) {
                    $.post('${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/toggle-status', 
                        function(response) {
                            if (response.success) {
                                showAlert('success', response.message);
                                setTimeout(function() {
                                    window.location.reload();
                                }, 1000);
                            } else {
                                showAlert('danger', response.message);
                            }
                        });
                }
            });
        });
        
        // Open image modal
        function openImageModal(imageSrc) {
            document.getElementById('modalImage').src = imageSrc;
            new bootstrap.Modal(document.getElementById('imageModal')).show();
        }
        
        // Show alert message
        function showAlert(type, message) {
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;
            $('#alertContainer').html(alertHtml);
            
            // Auto hide after 5 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
        }
    </script>
</body>
</html> 
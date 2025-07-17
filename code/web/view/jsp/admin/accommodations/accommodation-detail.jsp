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
    <title>Chi tiết Lưu trú - Admin</title>
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
                    <h1 class="h2">Chi tiết Lưu trú</h1>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/accommodations" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer"></div>

                <!-- Accommodation Details -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <h2>${accommodation.name}</h2>
                                <p class="text-muted">
                                    <i class="fas fa-map-marker-alt me-2"></i>${accommodation.address}, ${accommodation.cityName}
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${accommodation.adminApprovalStatus eq 'PENDING'}">
                                            <span class="badge bg-warning status-badge">
                                                <i class="fas fa-clock me-1"></i>Chờ duyệt
                                            </span>
                                        </c:when>
                                        <c:when test="${accommodation.adminApprovalStatus eq 'APPROVED'}">
                                            <span class="badge bg-success status-badge">
                                                <i class="fas fa-check-circle me-1"></i>Đã duyệt
                                            </span>
                                        </c:when>
                                        <c:when test="${accommodation.adminApprovalStatus eq 'REJECTED'}">
                                            <span class="badge bg-danger status-badge">
                                                <i class="fas fa-ban me-1"></i>Từ chối
                                            </span>
                                        </c:when>
                                    </c:choose>
                                    
                                    <c:if test="${accommodation.adminApprovalStatus eq 'APPROVED'}">
                                        <span class="badge ${accommodation.active ? 'bg-success' : 'bg-secondary'} ms-2 status-badge">
                                            <i class="fas ${accommodation.active ? 'fa-eye' : 'fa-eye-slash'} me-1"></i>
                                            ${accommodation.active ? 'Hiển thị' : 'Đang ẩn'}
                                        </span>
                                    </c:if>
                                </div>
                                
                                <!-- Action buttons -->
                                <div class="btn-group">
                                    <c:if test="${accommodation.adminApprovalStatus eq 'PENDING'}">
                                        <button class="btn btn-success approve-btn" 
                                                data-id="${accommodation.accommodationId}">
                                            <i class="fas fa-check me-1"></i>Duyệt lưu trú
                                        </button>
                                        <button class="btn btn-danger ms-2 reject-btn"
                                                data-id="${accommodation.accommodationId}">
                                            <i class="fas fa-times me-1"></i>Từ chối
                                        </button>
                                    </c:if>
                                    
                                    <button class="btn btn-warning ms-2 toggle-status-btn"
                                            data-id="${accommodation.accommodationId}"
                                            data-current-status="${accommodation.active}">
                                        <i class="fas ${accommodation.active ? 'fa-eye-slash' : 'fa-eye'} me-1"></i>
                                        ${accommodation.active ? 'Ẩn lưu trú' : 'Hiển thị lưu trú'}
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Accommodation Images -->
                        <c:if test="${not empty accommodation.images}">
                            <div class="mb-4">
                                <div id="accommodationCarousel" class="carousel slide" data-bs-ride="carousel">
                                    <div class="carousel-inner">
                                        <c:forEach var="image" items="${accommodation.images.split(',')}" varStatus="status">
                                            <div class="carousel-item ${status.first ? 'active' : ''}">
                                                <img src="${pageContext.request.contextPath}/images/accommodations/${image}" 
                                                    alt="${accommodation.name}" class="d-block"
                                                    onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/assets/images/placeholder.jpg';">
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <button class="carousel-control-prev" type="button" data-bs-target="#accommodationCarousel" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#accommodationCarousel" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Thumbnails -->
                            <div class="row mb-4">
                                <c:forEach var="image" items="${accommodation.images.split(',')}" varStatus="status">
                                    <div class="col-md-2 col-4 mb-3">
                                        <img src="${pageContext.request.contextPath}/images/accommodations/${image}" 
                                            alt="${accommodation.name}" class="img-fluid gallery-img"
                                            onclick="openImageModal('${pageContext.request.contextPath}/images/accommodations/${image}')"
                                            onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/assets/images/placeholder.jpg';">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="row">
                            <div class="col-md-8">
                                <!-- Description -->
                                <h4 class="section-heading">Mô tả lưu trú</h4>
                                <p>${accommodation.description}</p>
                                
                                <!-- Amenities -->
                                <h4 class="section-heading mt-4">Tiện nghi</h4>
                                <div class="mb-4">
                                    <c:forEach var="amenity" items="${accommodation.amenities.split(',')}">
                                        <span class="badge rounded-pill amenity-badge py-2">
                                            <i class="fas fa-check me-1"></i>${amenity.trim()}
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <!-- Details -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h5 class="mb-3">Thông tin chi tiết</h5>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-user me-2"></i>Host</div>
                                            <div class="detail-value">${accommodation.hostName} (ID: ${accommodation.hostId})</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-building me-2"></i>Loại</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${accommodation.type eq 'Hotel'}">
                                                        <span class="badge bg-primary">Khách sạn</span>
                                                    </c:when>
                                                    <c:when test="${accommodation.type eq 'Apartment'}">
                                                        <span class="badge bg-info">Căn hộ</span>
                                                    </c:when>
                                                    <c:when test="${accommodation.type eq 'Villa'}">
                                                        <span class="badge bg-success">Biệt thự</span>
                                                    </c:when>
                                                    <c:when test="${accommodation.type eq 'Homestay'}">
                                                        <span class="badge bg-warning">Homestay</span>
                                                    </c:when>
                                                    <c:when test="${accommodation.type eq 'Resort'}">
                                                        <span class="badge bg-danger">Resort</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${accommodation.type}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-coins me-2"></i>Giá mỗi đêm</div>
                                            <div class="detail-value">
                                                <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                                <c:if test="${accommodation.promotionPercent > 0}">
                                                    <span class="badge bg-danger ms-2">Giảm ${accommodation.promotionPercent}%</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-door-open me-2"></i>Số phòng</div>
                                            <div class="detail-value">${accommodation.numberOfRooms}</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-users me-2"></i>Sức chứa tối đa</div>
                                            <div class="detail-value">${accommodation.maxOccupancy} người</div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-calendar me-2"></i>Ngày tạo</div>
                                            <div class="detail-value">
                                                <fmt:formatDate value="${accommodation.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-label"><i class="fas fa-star me-2"></i>Đánh giá</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${accommodation.averageRating > 0}">
                                                        ${accommodation.averageRating} / 5 (${accommodation.totalBookings} lượt đặt)
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
                                        
                                        <c:if test="${not empty accommodation.adminApprovedAt}">
                                            <div class="detail-item">
                                                <div class="detail-label">Ngày duyệt/từ chối</div>
                                                <div class="detail-value">
                                                    <fmt:formatDate value="${accommodation.adminApprovedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty accommodation.adminRejectReason}">
                                            <div class="detail-item">
                                                <div class="detail-label">Lý do từ chối</div>
                                                <div class="detail-value text-danger">${accommodation.adminRejectReason}</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty accommodation.adminNotes}">
                                            <div class="detail-item">
                                                <div class="detail-label">Ghi chú admin</div>
                                                <div class="detail-value">${accommodation.adminNotes}</div>
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
                    <img id="modalImage" src="" alt="Accommodation image" class="modal-img">
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Từ chối lưu trú</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="rejectForm">
                        <input type="hidden" id="rejectAccommodationId" name="accommodationId">
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
            // Approve accommodation
            $('.approve-btn').click(function() {
                const accommodationId = $(this).data('id');
                
                if (confirm('Bạn có chắc chắn muốn duyệt lưu trú này?')) {
                    $.post('${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/approve', 
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
                const accommodationId = $(this).data('id');
                $('#rejectAccommodationId').val(accommodationId);
                $('#rejectModal').modal('show');
            });
            
            // Confirm reject
            $('#confirmRejectBtn').click(function() {
                const accommodationId = $('#rejectAccommodationId').val();
                const reason = $('#rejectReason').val().trim();
                
                if (!reason) {
                    alert('Vui lòng nhập lý do từ chối');
                    return;
                }
                
                $.post('${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/reject',
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
                const accommodationId = $(this).data('id');
                const currentStatus = $(this).data('current-status');
                const action = currentStatus ? 'ẩn' : 'hiển thị';
                
                if (confirm('Bạn có chắc chắn muốn ' + action + ' lưu trú này?')) {
                    $.post('${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/toggle-status', 
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
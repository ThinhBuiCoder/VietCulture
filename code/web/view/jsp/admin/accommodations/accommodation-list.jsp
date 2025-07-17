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
    <title>Quản lý Lưu trú - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .accommodation-image {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 4px;
        }
        .status-badge {
            font-size: 0.75rem;
        }
        .action-btn {
            padding: 0.25rem 0.5rem;
            margin: 0.1rem;
        }
        .table td {
            vertical-align: middle;
        }
        .pagination-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
        }
        .stats-card {
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .table-responsive {
            overflow-x: auto;
        }
        @media (max-width: 768px) {
            .action-btn {
                padding: 0.2rem 0.4rem;
                font-size: 0.875rem;
            }
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
                    <h1 class="h2"><i class="fas fa-bed me-2"></i>Quản lý Lưu trú</h1>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty message}">
                    <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <div id="alertContainer"></div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-warning bg-opacity-25 h-100">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-clock me-2"></i>Chờ duyệt</h5>
                                <p class="card-text display-6">${stats.pending}</p>
                                <a href="${pageContext.request.contextPath}/admin/accommodations?status=pending" class="btn btn-sm btn-warning">Xem danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-success bg-opacity-25 h-100">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-check-circle me-2"></i>Đã duyệt</h5>
                                <p class="card-text display-6">${stats.approved}</p>
                                <a href="${pageContext.request.contextPath}/admin/accommodations?status=approved" class="btn btn-sm btn-success">Xem danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-danger bg-opacity-25 h-100">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-ban me-2"></i>Từ chối</h5>
                                <p class="card-text display-6">${stats.rejected}</p>
                                <a href="${pageContext.request.contextPath}/admin/accommodations?status=rejected" class="btn btn-sm btn-danger">Xem danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-info bg-opacity-25 h-100">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-list me-2"></i>Tổng số</h5>
                                <p class="card-text display-6">${stats.total}</p>
                                <a href="${pageContext.request.contextPath}/admin/accommodations" class="btn btn-sm btn-info">Xem tất cả</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/accommodations" id="filterForm">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status" onchange="this.form.submit()">
                                        <option value="" ${empty param.status ? 'selected' : ''}>Tất cả trạng thái</option>
                                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                        <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Từ chối</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Loại lưu trú</label>
                                    <select class="form-select" name="type" onchange="this.form.submit()">
                                        <option value="" ${empty param.type ? 'selected' : ''}>Tất cả loại</option>
                                        <option value="Hotel" ${param.type == 'Hotel' ? 'selected' : ''}>Khách sạn</option>
                                        <option value="Apartment" ${param.type == 'Apartment' ? 'selected' : ''}>Căn hộ</option>
                                        <option value="Villa" ${param.type == 'Villa' ? 'selected' : ''}>Biệt thự</option>
                                        <option value="Homestay" ${param.type == 'Homestay' ? 'selected' : ''}>Homestay</option>
                                        <option value="Resort" ${param.type == 'Resort' ? 'selected' : ''}>Resort</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="search" value="${param.search}" placeholder="Tìm theo tên, địa chỉ...">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Tìm kiếm
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/admin/accommodations" class="btn btn-outline-secondary d-block">
                                        <i class="fas fa-redo me-1"></i>Làm mới
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Accommodations Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="accommodationsTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Hình ảnh</th>
                                        <th>Tên lưu trú</th>
                                        <th>Host</th>
                                        <th>Loại</th>
                                        <th>Giá (VND)</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th width="160">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="accommodation" items="${accommodations}">
                                        <tr data-accommodation-id="${accommodation.accommodationId}">
                                            <td>${accommodation.accommodationId}</td>
                                            <td>
                                                <c:if test="${not empty accommodation.images}">
                                                    <c:set var="firstImage" value="${accommodation.images.split(',')[0]}" />
                                                    <img src="${pageContext.request.contextPath}/images/accommodations/${firstImage}" 
                                                        alt="${accommodation.name}" class="accommodation-image"
                                                        onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/assets/images/placeholder.jpg';">
                                                </c:if>
                                                <c:if test="${empty accommodation.images}">
                                                    <div class="accommodation-image bg-secondary d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-image text-white"></i>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <strong>${accommodation.name}</strong>
                                                <br>
                                                <small class="text-muted"><i class="fas fa-map-marker-alt me-1"></i>${accommodation.address}, ${accommodation.cityName}</small>
                                            </td>
                                            <td>${accommodation.hostName}</td>
                                            <td>
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
                                            </td>
                                            <td><fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0"/></td>
                                            <td>
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
                                                        <c:if test="${not accommodation.active}">
                                                            <br>
                                                            <span class="badge bg-secondary status-badge mt-1">
                                                                <i class="fas fa-eye-slash me-1"></i>Đã ẩn
                                                            </span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:when test="${accommodation.adminApprovalStatus eq 'REJECTED'}">
                                                        <span class="badge bg-danger status-badge">
                                                            <i class="fas fa-ban me-1"></i>Từ chối
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${accommodation.createdAt}" pattern="dd/MM/yyyy"/>
                                                <br>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${accommodation.createdAt}" pattern="HH:mm"/>
                                                </small>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/accommodations/${accommodation.accommodationId}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    
                                                    <c:if test="${accommodation.adminApprovalStatus eq 'PENDING'}">
                                                        <button class="btn btn-sm btn-outline-success action-btn approve-btn" 
                                                                data-id="${accommodation.accommodationId}"
                                                                title="Duyệt lưu trú">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-danger action-btn reject-btn"
                                                                data-id="${accommodation.accommodationId}"
                                                                title="Từ chối lưu trú">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </c:if>
                                                    
                                                    <button class="btn btn-sm btn-outline-warning action-btn toggle-status-btn"
                                                            data-id="${accommodation.accommodationId}"
                                                            data-current-status="${accommodation.active}"
                                                            title="${accommodation.active ? 'Ẩn lưu trú' : 'Hiện lưu trú'}">
                                                        <i class="fas ${accommodation.active ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty accommodations}">
                                        <tr>
                                            <td colspan="9" class="text-center py-4">Không có lưu trú nào phù hợp với bộ lọc hiện tại</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-info">
                                <div class="text-muted">
                                    Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                                    ${currentPage == totalPages ? totalItems : currentPage * pageSize}
                                    trên tổng số ${totalItems} lưu trú
                                </div>
                                <nav>
                                    <ul class="pagination">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/accommodations?page=${currentPage - 1}&status=${param.status}&type=${param.type}&search=${param.search}">&laquo;</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/admin/accommodations?page=${i}&status=${param.status}&type=${param.type}&search=${param.search}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/accommodations?page=${currentPage + 1}&status=${param.status}&type=${param.type}&search=${param.search}">&raquo;</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
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
        });
    </script>
</body>
</html> 
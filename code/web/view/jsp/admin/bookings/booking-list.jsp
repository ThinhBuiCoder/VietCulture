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
    <title>Quản lý Bookings - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .booking-card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
        }
        .type-badge {
            font-size: 0.7rem;
            padding: 0.3rem 0.6rem;
            border-radius: 15px;
        }
        .action-btn {
            padding: 0.25rem 0.5rem;
            margin: 0.1rem;
            border-radius: 6px;
        }
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .stats-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .filter-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        .table-responsive {
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .table th {
            background-color: #f8f9fa;
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        .pagination-info {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-top: 1rem;
        }
        @media (max-width: 768px) {
            .action-btn {
                padding: 0.2rem 0.4rem;
                font-size: 0.875rem;
            }
            .stats-card {
                margin-bottom: 1rem;
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
                    <h1 class="h2"><i class="fas fa-calendar-check me-2"></i>Quản lý Bookings</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-success" id="exportBookingsBtn">
                                <i class="fas fa-download me-1"></i>Xuất Excel
                            </button>
                            <button type="button" class="btn btn-info" id="refreshStatsBtn">
                                <i class="fas fa-sync-alt me-1"></i>Refresh
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-primary">${statistics.totalBookings}</div>
                            <div class="stats-label">Tổng Bookings</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-warning">${statistics.pendingBookings}</div>
                            <div class="stats-label">Chờ xác nhận</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-success">${statistics.confirmedBookings}</div>
                            <div class="stats-label">Đã xác nhận</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-info">${statistics.todayBookings}</div>
                            <div class="stats-label">Booking hôm nay</div>
                        </div>
                    </div>
                </div>

                <!-- Additional Statistics Row -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-info">${statistics.experienceBookings}</div>
                            <div class="stats-label">Experience Bookings</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-purple">${statistics.accommodationBookings}</div>
                            <div class="stats-label">Accommodation Bookings</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-danger">${statistics.cancelledBookings}</div>
                            <div class="stats-label">Đã hủy</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-success">
                                <fmt:formatNumber value="${statistics.totalRevenue}" type="currency" currencyCode="VND" pattern="#,##0"/>
                            </div>
                            <div class="stats-label">Tổng doanh thu</div>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="filter-card">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/bookings" id="filterForm">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="CONFIRMED" ${currentStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                        <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="CANCELLED" ${currentStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Loại</label>
                                    <select class="form-select" name="type">
                                        <option value="">Tất cả loại</option>
                                        <option value="EXPERIENCE" ${currentType == 'EXPERIENCE' ? 'selected' : ''}>Experience</option>
                                        <option value="ACCOMMODATION" ${currentType == 'ACCOMMODATION' ? 'selected' : ''}>Accommodation</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" name="search" 
                                           value="${currentSearch}" 
                                           placeholder="Tên khách hàng, email, tên dịch vụ...">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Tìm kiếm
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Bookings Table -->
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>Danh sách Bookings
                                <span class="badge bg-primary ms-2">${totalBookings}</span>
                            </h5>
                            <div class="d-flex align-items-center">
                                <span class="text-muted me-3">Hiển thị ${pageSize} booking/trang</span>
                                <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10/trang</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20/trang</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50/trang</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100/trang</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <div class="text-center py-5">
                                    <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có booking nào</h5>
                                    <p class="text-muted">Thử thay đổi bộ lọc để xem thêm kết quả</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 80px;">ID</th>
                                                <th>Khách hàng</th>
                                                <th>Dịch vụ</th>
                                                <th>Loại</th>
                                                <th>Ngày đặt</th>
                                                <th>Số người</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th style="width: 150px;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <tr data-booking-id="${booking.bookingId}">
                                                    <td class="fw-bold">#${booking.bookingId}</td>
                                                    <td>
                                                        <div>
                                                            <div class="fw-bold">${booking.travelerName}</div>
                                                            <small class="text-muted">${booking.travelerEmail}</small>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="fw-medium">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.experienceName}">
                                                                    ${booking.experienceName}
                                                                </c:when>
                                                                <c:when test="${not empty booking.accommodationName}">
                                                                    ${booking.accommodationName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.experienceId != null}">
                                                                <span class="type-badge bg-info text-white">
                                                                    <i class="fas fa-map-marker-alt me-1"></i>Experience
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.accommodationId != null}">
                                                                <span class="type-badge bg-warning text-dark">
                                                                    <i class="fas fa-bed me-1"></i>Accommodation
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                                        <c:if test="${booking.bookingTime != null}">
                                                            <br>
                                                            <small class="text-muted">
                                                                <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                                                            </small>
                                                        </c:if>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-light text-dark">${booking.numberOfPeople}</span>
                                                    </td>
                                                    <td class="fw-bold text-success">
                                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND" pattern="#,##0 VND"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'PENDING'}">
                                                                <span class="status-badge bg-warning text-dark">
                                                                    <i class="fas fa-clock me-1"></i>Chờ xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CONFIRMED'}">
                                                                <span class="status-badge bg-success text-white">
                                                                    <i class="fas fa-check me-1"></i>Đã xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'COMPLETED'}">
                                                                <span class="status-badge bg-primary text-white">
                                                                    <i class="fas fa-check-double me-1"></i>Hoàn thành
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CANCELLED'}">
                                                                <span class="status-badge bg-danger text-white">
                                                                    <i class="fas fa-times me-1"></i>Đã hủy
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy"/>
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${booking.createdAt}" pattern="HH:mm"/>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm btn-primary action-btn" 
                                                                title="Xem chi tiết" onclick="viewBookingDetail(${booking.bookingId})">
                                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="card-footer">
                            <div class="pagination-info">
                                <small class="text-muted">
                                    Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                                    ${currentPage * pageSize > totalBookings ? totalBookings : currentPage * pageSize} 
                                    trong tổng số ${totalBookings} booking
                                </small>
                            </div>
                            <nav aria-label="Booking pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=1&status=${currentStatus}&type=${currentType}&search=${currentSearch}&pageSize=${pageSize}" title="Trang đầu">
                                                <i class="fas fa-angle-double-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&status=${currentStatus}&type=${currentType}&search=${currentSearch}&pageSize=${pageSize}" title="Trang trước">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                               end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" 
                                               var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${pageNum}&status=${currentStatus}&type=${currentType}&search=${currentSearch}&pageSize=${pageSize}">
                                                ${pageNum}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&status=${currentStatus}&type=${currentType}&search=${currentSearch}&pageSize=${pageSize}" title="Trang sau">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${totalPages}&status=${currentStatus}&type=${currentType}&search=${currentSearch}&pageSize=${pageSize}" title="Trang cuối">
                                                <i class="fas fa-angle-double-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </div>



    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 mb-0">Đang xử lý...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        // Configuration
        var CONFIG = {
            contextPath: '${pageContext.request.contextPath}',
            currentUserId: '${sessionScope.user.userId}',
            debug: true
        };

        // View booking detail
        function viewBookingDetail(bookingId) {
            window.location.href = CONFIG.contextPath + '/admin/bookings/' + bookingId;
        }



        // Change page size
        function changePageSize(pageSize) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('pageSize', pageSize);
            urlParams.set('page', '1'); // Reset to first page
            window.location.search = urlParams.toString();
        }

        // Export bookings
        function exportBookings() {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('export', 'excel');
            window.open(CONFIG.contextPath + '/admin/bookings?' + urlParams.toString(), '_blank');
        }

        // Refresh statistics
        function refreshStats() {
            fetch(CONFIG.contextPath + '/admin/bookings/statistics', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showAlert('Đã cập nhật thống kê', 'success');
                    // You can update the statistics on the page here
                    setTimeout(() => window.location.reload(), 1000);
                } else {
                    showAlert('Không thể cập nhật thống kê', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Lỗi kết nối: ' + error.message, 'error');
            });
        }

        // Show loading modal
        function showLoading() {
            new bootstrap.Modal(document.getElementById('loadingModal')).show();
        }

        // Hide loading modal
        function hideLoading() {
            const modal = bootstrap.Modal.getInstance(document.getElementById('loadingModal'));
            if (modal) {
                modal.hide();
            }
        }

        // Show alert
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertClass = 'alert alert-' + (type === 'error' ? 'danger' : type) + ' alert-dismissible fade show';
            const iconClass = type === 'success' ? 'fas fa-check-circle' : 
                             type === 'error' ? 'fas fa-exclamation-circle' : 'fas fa-info-circle';
            
            const alertHTML = `
                <div class="${alertClass}">
                    <i class="${iconClass} me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            alertContainer.insertAdjacentHTML('beforeend', alertHTML);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                const alerts = alertContainer.querySelectorAll('.alert');
                if (alerts.length > 0) {
                    alerts[0].remove();
                }
            }, 5000);
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Export button
            document.getElementById('exportBookingsBtn').addEventListener('click', exportBookings);
            
            // Refresh button
            document.getElementById('refreshStatsBtn').addEventListener('click', refreshStats);
            
            // Auto-submit form on filter change
            const filterForm = document.getElementById('filterForm');
            const selects = filterForm.querySelectorAll('select');
            selects.forEach(select => {
                select.addEventListener('change', () => {
                    filterForm.submit();
                });
            });
            
            // Search input with debounce
            const searchInput = filterForm.querySelector('input[name="search"]');
            let searchTimeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    filterForm.submit();
                }, 1000); // 1 second delay
            });
        });
    </script>
</body>
</html> 
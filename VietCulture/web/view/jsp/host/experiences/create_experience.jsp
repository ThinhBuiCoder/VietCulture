<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE
html >
  <html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale: 1.0">
  <title>Tạo Trải Nghiệm Mới - VietCulture</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
  <style>
      :root {
          --primary-color: #FF385C;
          --secondary-color: #83C5BE;
          --accent-color: #F8F9FA;
          --dark-color: #2F4858;
          --light-color: #FFFFFF;
          --light-green: #E0F7FA;
          --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
          --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
          --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
          --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
          --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
          --border-radius: 16px;
          --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
      }

      body {
          font-family: 'Inter', sans-serif;
          line-height: 1.6;
          color: var(--dark-color);
          background-color: #f5f7fa;
          padding-top: 80px;
      }

      h1, h2, h3, h4, h5 {
          font-family: 'Playfair Display', serif;
      }

      .btn {
          border-radius: 30px;
          padding: 12px 24px;
          font-weight: 500;
          transition: var(--transition);
      }

      .btn-primary {
          background: var(--gradient-primary);
          border: none;
          color: white;
          box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
      }

      .btn-primary:hover {
          transform: translateY(-3px);
          box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
      }

      /* Giữ nguyên CSS cho thanh điều hướng */
      .custom-navbar {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          background-color: #10466C;
          backdrop-filter: blur(10px);
          box-shadow: var(--shadow-sm);
          z-index: 1000;
          padding: 15px 0;
          transition: var(--transition);
      }

      .custom-navbar.scrolled {
          padding: 10px 0;
          background-color: #10466C;
          box-shadow: var(--shadow-md);
      }

      .custom-navbar .container {
          display: flex;
          justify-content: space-between;
          align-items: center;
      }

      .navbar-brand {
          display: flex;
          align-items: center;
          font-weight: 700;
          font-size: 1.3rem;
          color: white;
          text-decoration: none;
          white-space: nowrap;
          min-width: 150px;
      }

      .navbar-brand img {
          height: 50px !important;
          width: auto !important;
          margin-right: 12px !important;
          filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
          object-fit: contain !important;
          display: inline-block !important;
      }

      .nav-center {
          display: flex;
          align-items: center;
          gap: 40px;
          position: absolute;
          left: 50%;
          transform: translateX(-50%);
      }

      .nav-center-item {
          color: rgba(255,255,255,0.7);
          text-decoration: none;
      }

      .nav-center-item:hover {
          color: white;
      }

      .nav-center-item.active {
          color: var(--primary-color);
      }

      .nav-center-item img {
          height: 24px;
          margin-bottom: 5px;
          transition: var(--transition);
      }

      .nav-center-item:hover img {
          transform: translateY(-3px);
      }

      .nav-right {
          display: flex;
          align-items: center;
          gap: 24px;
      }

      .nav-right a {
          color: rgba(255,255,255,0.7);
          text-decoration: none;
      }

      .nav-right a:hover {
          color: var(--primary-color);
          background-color: rgba(255, 56, 92, 0.08);
      }

      .nav-right .globe-icon {
          font-size: 20px;
          cursor: pointer;
          transition: var(--transition);
      }

      .nav-right .globe-icon:hover {
          color: var(--primary-color);
          transform: rotate(15deg);
      }

      .nav-right .menu-icon {
          border: 1px solid rgba(255,255,255,0.2);
          padding: 8px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: var(--transition);
          box-shadow: var(--shadow-sm);
          position: relative;
          background-color: rgba(255,255,255,0.1);
          color: white;
      }

      .nav-right .menu-icon:hover {
          background: rgba(255,255,255,0.2);
          transform: translateY(-2px);
          box-shadow: var(--shadow-md);
      }

      .nav-right .menu-icon i {
          color: white;
      }

      .dropdown-menu-custom {
          position: absolute;
          top: 100%;
          right: 0;
          background-color: white;
          border-radius: var(--border-radius);
          box-shadow: 0 10px 25px rgba(0,0,0,0.2);
          width: 250px;
          padding: 15px;
          display: none;
          z-index: 1000;
          margin-top: 10px;
          opacity: 0;
          transform: translateY(10px);
          transition: var(--transition);
          border: 1px solid rgba(0,0,0,0.1);
      }

      .dropdown-menu-custom.show {
          display: block;
          opacity: 1;
          transform: translateY(0);
          color: #10466C;
      }

      .dropdown-menu-custom a {
          display: flex;
          align-items: center;
          padding: 12px 15px;
          text-decoration: none;
          color: #10466C;
          transition: var(--transition);
          border-radius: 10px;
          margin-bottom: 5px;
      }

      .dropdown-menu-custom a:hover {
          background-color: rgba(16, 70, 108, 0.05);
          color: #10466C;
          transform: translateX(3px);
      }

      .dropdown-menu-custom a i {
          margin-right: 12px;
          font-size: 18px;
          color: #10466C;
      }

      /* CSS mới cho form hiện đại */
      .page-container {
          max-width: 1200px;
          margin: 2rem auto;
          padding: 0 1rem;
      }

      .page-header {
          text-align: center;
          margin-bottom: 2rem;
      }

      .page-title {
          font-size: 2.5rem;
          color: #10466C;
          margin-bottom: 0.5rem;
          font-weight: 700;
      }

      .page-subtitle {
          color: #64748b;
          font-size: 1.1rem;
      }

      .form-container {
          background: white;
          border-radius: 16px;
          box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
          overflow: hidden;
      }

      .form-section {
          padding: 2rem;
          border-bottom: 1px solid #f1f5f9;
      }

      .form-section:last-child {
          border-bottom: none;
      }

      .section-header {
          display: flex;
          align-items: center;
          margin-bottom: 1.5rem;
      }

      .section-icon {
          width: 40px;
          height: 40px;
          background: #e0f2fe;
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 1rem;
      }

      .section-icon i {
          color: #0284c7;
          font-size: 1.25rem;
      }

      .section-title {
          font-size: 1.25rem;
          font-weight: 600;
          color: #0f172a;
          margin: 0;
      }

      .form-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          gap: 1.5rem;
      }

      .form-group {
          margin-bottom: 1.5rem;
      }

      .form-label {
          display: block;
          margin-bottom: 0.5rem;
          font-weight: 500;
          color: #334155;
      }

      .form-control {
          width: 100%;
          padding: 0.75rem 1rem;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          font-size: 1rem;
          transition: all 0.2s ease;
      }

      .form-control:focus {
          outline: none;
          border-color: #0284c7;
          box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.1);
      }

      .form-control::placeholder {
          color: #94a3b8;
      }

      .form-select {
          width: 100%;
          padding: 0.75rem 1rem;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          font-size: 1rem;
          appearance: none;
          background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b'%3E%3Cpath strokeLinecap='round' strokeLinejoin='round' strokeWidth='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
          background-repeat: no-repeat;
          background-position: right 1rem center;
          background-size: 1rem;
      }

      .form-textarea {
          min-height: 120px;
          resize: vertical;
      }

      .image-upload-container {
          border: 2px dashed #e2e8f0;
          border-radius: 8px;
          padding: 2rem;
          text-align: center;
          cursor: pointer;
          transition: all 0.2s ease;
      }

      .image-upload-container:hover {
          border-color: #0284c7;
          background-color: #f0f9ff;
      }

      .image-upload-icon {
          font-size: 2.5rem;
          color: #94a3b8;
          margin-bottom: 1rem;
      }

      .image-upload-text {
          color: #64748b;
          margin-bottom: 0.5rem;
      }

      .image-upload-hint {
          font-size: 0.875rem;
          color: #94a3b8;
      }

      .image-preview-container {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
          gap: 1rem;
          margin-top: 1.5rem;
      }

      .image-preview-item {
          position: relative;
          border-radius: 8px;
          overflow: hidden;
          aspect-ratio: 1;
      }

      .image-preview-item img {
          width: 100%;
          height: 100%;
          object-fit: cover;
      }

      .image-preview-remove {
          position: absolute;
          top: 0.5rem;
          right: 0.5rem;
          width: 24px;
          height: 24px;
          background: rgba(255, 255, 255, 0.8);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.2s ease;
      }

      .image-preview-remove:hover {
          background: white;
          transform: scale(1.1);
      }

      .form-actions {
          display: flex;
          justify-content: flex-end;
          padding: 1.5rem 2rem;
          background: #f8fafc;
      }

      .btn-submit {
          background: #0284c7;
          color: white;
          border: none;
          border-radius: 8px;
          padding: 0.75rem 2rem;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.2s ease;
      }

      .btn-submit:hover {
          background: #0369a1;
          transform: translateY(-2px);
      }

      .error-messages {
          background-color: #fee2e2;
          color: #b91c1c;
          padding: 1rem;
          border-radius: 8px;
          margin-bottom: 1.5rem;
          list-style-position: inside;
      }

      /* Responsive */
      @media (max-width: 768px) {
          .page-title {
              font-size: 2rem;
          }
          
          .form-section {
              padding: 1.5rem;
          }
          
          .form-grid {
              grid-template-columns: 1fr;
          }
      }

      /* Thêm hiệu ứng cho các phần tử */
      .form-section {
          opacity: 0;
          transform: translateY(20px);
          animation: fadeInUp 0.5s forwards;
      }

      @keyframes fadeInUp {
          to {
              opacity: 1;
              transform: translateY(0);
          }
      }

      .form-section:nth-child(1) { animation-delay: 0.1s; }
      .form-section:nth-child(2) { animation-delay: 0.2s; }
      .form-section:nth-child(3) { animation-delay: 0.3s; }
      .form-section:nth-child(4) { animation-delay: 0.4s; }
      .form-section:nth-child(5) { animation-delay: 0.5s; }

      /* Thêm CSS cho thanh điều hướng phụ */
      .sub-nav {
          background-color: white;
          padding: 1rem 0;
          box-shadow: 0 2px 10px rgba(0,0,0,0.05);
          margin-bottom: 2rem;
          border-radius: 12px;
          display: flex;
          justify-content: center;
          gap: 1rem;
      }

      .sub-nav-btn {
          padding: 0.75rem 1.5rem;
          border-radius: 8px;
          font-weight: 500;
          transition: all 0.2s ease;
          text-decoration: none;
          display: flex;
          align-items: center;
          gap: 0.5rem;
      }

      .sub-nav-btn.active {
          background-color: #0284c7;
          color: white;
      }

      .sub-nav-btn:not(.active) {
          background-color: #f1f5f9;
          color: #334155;
      }

      .sub-nav-btn:hover:not(.active) {
          background-color: #e2e8f0;
          transform: translateY(-2px);
      }

      .sub-nav-btn i {
          font-size: 1.25rem;
      }
  </style>
</head>
<body>
  <!-- Giữ nguyên thanh điều hướng -->
  <div class="custom-navbar">
      <div class="container">
          <a class="navbar-brand" href="#">
              <img src="${pageContext.request.contextPath}/assets/img/Logo.png" alt="Logo">
              VIETCULTURE
          </a>
          <div class="nav-center">
              <a class="nav-center-item" href="${pageContext.request.contextPath}/home">
                  Trang Chủ
              </a>
              <a class="nav-center-item active" href="${pageContext.request.contextPath}/Travel/Travel">
                  Trải Nghiệm
              </a>
              <a class="nav-center-item" href="${pageContext.request.contextPath}/save">
                  Lưu Trú
              </a>
          </div>
          <div class="nav-right">
              <i class="ri-global-line globe-icon"></i>
              <div class="menu-icon" id="userMenuButton">
                  <i class="ri-menu-line"></i>
                  <i class="ri-user-line"></i>
              </div>
              <div class="dropdown-menu-custom" id="userMenu">
                  <c:if test="${sessionScope.user == null}">
                      <a href="${pageContext.request.contextPath}/login"><i class="ri-login-box-line me-2"></i> Đăng nhập</a>
                      <a href="${pageContext.request.contextPath}/register"><i class="ri-user-add-line me-2"></i> Đăng ký</a>
                  </c:if>
                  <c:if test="${sessionScope.user != null}">
                      <c:choose>
                          <c:when test="${sessionScope.user.role == 'ADMIN'}">
                              <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ri-dashboard-line me-2"></i> Bảng điều khiển Admin</a>
                          </c:when>
                          <c:when test="${sessionScope.user.role == 'HOST'}">
                              <a href="${pageContext.request.contextPath}/host/manage-experiences"><i class="ri-compass-3-line me-2"></i> Quản lý Trải nghiệm</a>
                              <a href="${pageContext.request.contextPath}/host/manage-accommodations"><i class="ri-hotel-bed-line me-2"></i> Quản lý Lưu trú</a>
                              <a href="${pageContext.request.contextPath}/host/transactions"><i class="ri-exchange-dollar-line me-2"></i> Giao dịch</a>
                          </c:when>
                          <c:otherwise>
                              <a href="${pageContext.request.contextPath}/user/profile"><i class="ri-user-line me-2"></i> Hồ sơ</a>
                              <a href="${pageContext.request.contextPath}/user/bookings"><i class="ri-calendar-line me-2"></i> Đặt chỗ của tôi</a>
                          </c:otherwise>
                      </c:choose>
                      <hr class="dropdown-divider">
                      <a href="${pageContext.request.contextPath}/logout"><i class="ri-logout-box-line me-2"></i> Đăng xuất</a>
                  </c:if>
              </div>
          </div>
      </div>
  </div>

  <!-- Nội dung trang mới -->
  <div class="page-container">
      <div class="page-header">
          <h1 class="page-title">Tạo Trải Nghiệm Mới</h1>
          <p class="page-subtitle">Chia sẻ kỹ năng và đam mê của bạn với du khách từ khắp nơi</p>
      </div>

      <!-- Thêm thanh điều hướng phụ -->
      <div class="sub-nav">
          <a href="${pageContext.request.contextPath}/Travel/create_experience" class="sub-nav-btn active">
              <i class="ri-compass-3-line"></i> Tạo Trải Nghiệm
          </a>
          <a href="${pageContext.request.contextPath}/Travel/create_accommodation" class="sub-nav-btn">
              <i class="ri-hotel-bed-line"></i> Tạo Lưu Trú
          </a>
      </div>

      <!-- Hiển thị thông báo lỗi nếu có -->
      <c:if test="${not empty requestScope.errors}">
          <ul class="error-messages">
              <c:forEach items="${requestScope.errors}" var="error">
                  <li>${error}</li>
              </c:forEach>
          </ul>
      </c:if>

      <form action="${pageContext.request.contextPath}/Travel/create_experience" method="post" enctype="multipart/form-data">
          <div class="form-container">
              <!-- Thông tin cơ bản -->
              <div class="form-section">
                  <div class="section-header">
                      <div class="section-icon">
                          <i class="ri-information-line"></i>
                      </div>
                      <h2 class="section-title">Thông tin cơ bản</h2>
                  </div>
                  <div class="form-grid">
                      <div class="form-group">
                          <label for="title" class="form-label">Tiêu đề trải nghiệm</label>
                          <input type="text" class="form-control" id="title" name="title" required placeholder="Nhập tiêu đề trải nghiệm" maxlength="100">
                      </div>
                      <div class="form-group">
                          <label for="type" class="form-label">Loại hình trải nghiệm</label>
                          <select class="form-select" id="type" name="type" required>
                              <option value="">Chọn loại hình</option>
                              <option value="Cultural">Văn hóa</option>
                              <option value="Adventure">Phiêu lưu</option>
                              <option value="Food">Ẩm thực</option>
                              <option value="Nature">Thiên nhiên</option>
                              <option value="Workshop">Workshop</option>
                              <option value="Photography">Nhiếp ảnh</option>
                          </select>
                      </div>
                  </div>
                  <div class="form-group">
                      <label for="description" class="form-label">Mô tả</label>
                      <textarea class="form-control form-textarea" id="description" name="description" rows="4" placeholder="Nhập mô tả chi tiết về trải nghiệm"></textarea>
                  </div>
              </div>

              <!-- Vị trí -->
              <div class="form-section">
                  <div class="section-header">
                      <div class="section-icon">
                          <i class="ri-map-pin-line"></i>
                      </div>
                      <h2 class="section-title">Vị trí</h2>
                  </div>
                  <div class="form-grid">
                      <div class="form-group">
                          <label for="location" class="form-label">Địa điểm</label>
                          <input type="text" class="form-control" id="location" name="location" required placeholder="Nhập địa điểm diễn ra trải nghiệm">
                      </div>
                      <div class="form-group">
                          <label for="cityId" class="form-label">Thành phố</label>
                          <select class="form-select" id="cityId" name="cityId" required>
                              <option value="">Chọn thành phố</option>
                              <!-- Danh sách thành phố sẽ được thêm bằng JavaScript -->
                          </select>
                      </div>
                  </div>
              </div>

              <!-- Chi tiết trải nghiệm -->
              <div class="form-section">
                  <div class="section-header">
                      <div class="section-icon">
                          <i class="ri-compass-3-line"></i>
                      </div>
                      <h2 class="section-title">Chi tiết trải nghiệm</h2>
                  </div>
                  <div class="form-grid">
                      <div class="form-group">
                          <label for="price" class="form-label">Giá mỗi người (VNĐ)</label>
                          <input type="number" class="form-control" id="price" name="price" required min="0" step="1000">
                      </div>
                      <div class="form-group">
                          <label for="maxGroupSize" class="form-label">Số lượng khách tối đa</label>
                          <input type="number" class="form-control" id="maxGroupSize" name="maxGroupSize" required min="1">
                      </div>
                      <div class="form-group">
                          <label for="duration" class="form-label">Thời lượng (HH:mm)</label>
                          <input type="time" class="form-control" id="duration" name="duration" required>
                      </div>
                      <div class="form-group">
                          <label for="difficulty" class="form-label">Mức độ khó</label>
                          <select class="form-select" id="difficulty" name="difficulty">
                              <option value="">Chọn mức độ</option>
                              <option value="EASY">Dễ</option>
                              <option value="MODERATE">Trung bình</option>
                              <option value="CHALLENGING">Khó</option>
                          </select>
                      </div>
                      <div class="form-group">
                          <label for="language" class="form-label">Ngôn ngữ</label>
                          <input type="text" class="form-control" id="language" name="language" placeholder="Ví dụ: Tiếng Việt, Tiếng Anh">
                      </div>
                  </div>
              </div>

              <!-- Thông tin bổ sung -->
              <div class="form-section">
                  <div class="section-header">
                      <div class="section-icon">
                          <i class="ri-list-check"></i>
                      </div>
                      <h2 class="section-title">Thông tin bổ sung</h2>
                  </div>
                  <div class="form-group">
                      <label for="includedItems" class="form-label">Những gì được bao gồm</label>
                      <textarea class="form-control form-textarea" id="includedItems" name="includedItems" rows="3" placeholder="Liệt kê các vật phẩm/dịch vụ đi kèm (mỗi mục một dòng)"></textarea>
                  </div>
                  <div class="form-group">
                      <label for="requirements" class="form-label">Yêu cầu đặc biệt</label>
                      <textarea class="form-control form-textarea" id="requirements" name="requirements" rows="3" placeholder="Ví dụ: Yêu cầu về thể chất, trang phục..."></textarea>
                  </div>
              </div>

              <!-- Hình ảnh -->
              <div class="form-section">
                  <div class="section-header">
                      <div class="section-icon">
                          <i class="ri-image-line"></i>
                      </div>
                      <h2 class="section-title">Hình ảnh</h2>
                  </div>
                  <div class="form-group">
                      <label for="experienceImage" class="form-label">Tải lên hình ảnh (tối đa 5 hình)</label>
                      <div class="image-upload-container" id="imageUploadContainer" onclick="document.getElementById('experienceImage').click();">
                          <i class="ri-upload-cloud-line image-upload-icon"></i>
                          <p class="image-upload-text">Kéo và thả hình ảnh hoặc nhấp để chọn</p>
                          <p class="image-upload-hint">Hỗ trợ: JPG, PNG, GIF (tối đa 5MB mỗi ảnh)</p>
                      </div>
                      <input type="file" class="form-control" id="experienceImage" name="experienceImage" accept="image/*" multiple required style="display: none;">
                      <div id="experienceImagePreview" class="image-preview-container"></div>
                  </div>
              </div>

              <!-- Nút gửi -->
              <div class="form-actions">
                  <button type="submit" class="btn-submit">Tạo Trải Nghiệm</button>
              </div>
          </div>
      </form>
  </div>

  <!-- Bootstrap JS CDN (Bundle with Popper) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
      $(document).ready(function(){
          // User menu toggle
          const userMenuToggle = document.getElementById('userMenuButton');
          const userMenu = document.getElementById('userMenu');

          if (userMenuToggle) {
              userMenuToggle.addEventListener('click', () => {
                  userMenu.classList.toggle('show');
              });
          }

          window.addEventListener('click', function(event) {
              if (userMenuToggle && !userMenuToggle.contains(event.target) && userMenu && !userMenu.contains(event.target)) {
                  userMenu.classList.remove('show');
              }
          });

          // Navbar scroll effect
          window.addEventListener('scroll', function() {
              const navbar = document.querySelector('.custom-navbar');
              if (navbar) {
                  if (window.scrollY > 0) {
                      navbar.classList.add('scrolled');
                  } else {
                      navbar.classList.remove('scrolled');
                  }
              }
          });

          // Image preview for multiple files
          $('#experienceImage').on('change', function(event) {
              const previewContainer = $('#experienceImagePreview');
              previewContainer.empty(); // Clear previous previews

              if (this.files) {
                  Array.from(this.files).forEach((file, index) => {
                      const reader = new FileReader();
                      reader.onload = (e) => {
                          const previewItem = $('<div>').addClass('image-preview-item');
                          const img = $('<img>').attr('src', e.target.result);
                          const removeBtn = $('<div>').addClass('image-preview-remove').html('<i class="ri-close-line"></i>');
                          
                          removeBtn.on('click', (e) => {
                              e.stopPropagation();
                              previewItem.remove();
                              // Note: In a real implementation, you would need to handle removing the file from the input
                          });
                          
                          previewItem.append(img, removeBtn);
                          previewContainer.append(previewItem);
                      };
                      reader.readAsDataURL(file);
                  });
              }
          });

          // Load danh sách thành phố
          fetch('${pageContext.request.contextPath}/Travel/cities')
              .then(response => response.json())
              .then(cities => {
                  const citySelect = document.getElementById('cityId');
                  cities.forEach(city => {
                      const option = document.createElement('option');
                      option.value = city.cityId;
                      option.textContent = city.name;
                      citySelect.appendChild(option);
                  });
              })
              .catch(error => console.error('Error loading cities:', error));
      });
  </script>
</body>
</html>

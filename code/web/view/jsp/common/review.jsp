<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
.review-form-modern {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 4px 24px rgba(16,70,108,0.08);
    padding: 24px 18px 18px 18px;
    max-width: 420px;
    margin: 0 auto;
}
.star-rating-modern {
    direction: rtl;
    display: flex;
    justify-content: center;
    gap: 0.2em;
    font-size: 2.1rem;
    margin-bottom: 10px;
}
.star-rating-modern input[type="radio"] {
    display: none;
}
.star-rating-modern label {
    color: #ccc;
    cursor: pointer;
    transition: color 0.2s, transform 0.2s;
    padding: 0 2px;
}
.star-rating-modern label:before {
    content: '\2605';
    display: inline-block;
}
.star-rating-modern input[type="radio"]:checked ~ label,
.star-rating-modern label:hover,
.star-rating-modern label:hover ~ label {
    color: #FFD700;
    transform: scale(1.15);
}
.review-form-modern textarea {
    border-radius: 10px;
    border: 1.5px solid #e0e0e0;
    padding: 12px;
    font-size: 1rem;
    resize: vertical;
    min-height: 80px;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.review-form-modern textarea:focus {
    border-color: #ff385c;
    box-shadow: 0 0 0 2px #ff385c33;
}
.review-form-modern .char-count {
    font-size: 0.95rem;
    color: #888;
    text-align: right;
    margin-top: 2px;
}
.review-form-modern .btn-submit {
    background: linear-gradient(90deg,#ff385c,#ff6b6b);
    border: none;
    color: #fff;
    font-size: 1.1rem;
    font-weight: 600;
    border-radius: 30px;
    width: 100%;
    padding: 12px 0;
    margin-top: 10px;
    box-shadow: 0 4px 16px rgba(255,56,92,0.10);
    transition: background 0.2s, box-shadow 0.2s;
}
.review-form-modern .btn-submit:hover, .review-form-modern .btn-submit:focus {
    background: linear-gradient(90deg,#ff385c,#ff6b6b,#ff385c);
    box-shadow: 0 6px 20px rgba(255,56,92,0.18);
}
@media (max-width: 600px) {
    .review-form-modern {
        padding: 14px 4px 10px 4px;
        max-width: 98vw;
    }
    .star-rating-modern {
        font-size: 1.5rem;
    }
}
</style>
<div class="review-section">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <c:choose>
                <c:when test="${hasBooked}">
                    <form class="review-form-modern" action="${pageContext.request.contextPath}/submitReview" method="post">
                        <c:if test="${not empty experience}">
                            <input type="hidden" name="experienceId" value="${experience.experienceId}" />
                        </c:if>
                        <c:if test="${not empty accommodation}">
                            <input type="hidden" name="accommodationId" value="${accommodation.accommodationId}" />
                        </c:if>
                        <input type="hidden" name="userId" value="${sessionScope.user.userId}" />
                        <div class="mb-2 text-center">
                            <label class="form-label fw-bold fs-5 mb-2" style="color:#10466C;">Đánh giá của bạn</label>
                            <div class="star-rating-modern d-flex justify-content-center">
                                <input type="radio" id="star5" name="rating" value="5" required><label for="star5" title="5 sao"></label>
                                <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4 sao"></label>
                                <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3 sao"></label>
                                <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2 sao"></label>
                                <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1 sao"></label>
                            </div>
                        </div>
                        <div class="mb-2">
                            <label for="reviewText" class="form-label fw-bold">Nhận xét của bạn</label>
                            <textarea class="form-control shadow-sm" id="reviewText" name="comment" rows="4" maxlength="500" placeholder="Chia sẻ trải nghiệm của bạn..." required></textarea>
                            <div class="char-count"><span id="charCount">0</span>/500 ký tự</div>
                        </div>
                        <button type="submit" class="btn btn-submit">
                            <i class="ri-send-plane-line me-2"></i>Gửi đánh giá
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="text-center">
                        <i class="ri-information-line" style="font-size: 3rem; color: var(--primary-color); margin-bottom: 20px;"></i>
                        <h5>Chỉ khách đã đặt tour mới có thể đánh giá</h5>
                        <p class="text-muted">Vui lòng đặt và tham gia trải nghiệm để để lại đánh giá.</p>
                        <button type="button" class="btn btn-primary" onclick="goToBooking()">
                            <i class="ri-calendar-check-line me-2"></i>Đặt ngay
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <div class="text-center">
                <i class="ri-login-circle-line" style="font-size: 3rem; color: var(--primary-color); margin-bottom: 20px;"></i>
                <h5>Vui lòng đăng nhập để đánh giá</h5>
                <p class="text-muted">Bạn cần đăng nhập để chia sẻ trải nghiệm của mình.</p>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                    <i class="ri-login-circle-line me-2"></i>Đăng nhập
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var reviewText = document.getElementById('reviewText');
    var charCount = document.getElementById('charCount');
    if (reviewText && charCount) {
        reviewText.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });
    }
    var reviewForm = document.querySelector('.review-form-modern');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            fetch(this.action, {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Ẩn modal nếu có
                    try {
                        const modalInstance = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
                        if (modalInstance) modalInstance.hide();
                    } catch (e) {}
                    // Reload lại trang chi tiết trải nghiệm
                    window.location.replace(window.location.pathname + window.location.search);
                } else {
                    alert(data.message || 'Có lỗi xảy ra khi gửi đánh giá.');
                }
            })
            .catch(error => {
                alert('Lỗi: ' + (error.message || 'Không thể kết nối đến máy chủ.'));
            });
        });
    }
    // Xử lý nút Đặt ngay: đóng modal và cuộn đến form booking
    var goToBookingBtn = document.querySelector('.btn.btn-primary[onclick="goToBooking()"]');
    if (goToBookingBtn) {
        goToBookingBtn.addEventListener('click', function(e) {
            e.preventDefault();
            var modal = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
            if (modal) modal.hide();
            setTimeout(function() {
                document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
                document.body.classList.remove('modal-open');
                document.body.style = '';
                var bookingSection = document.querySelector('.booking-form');
                if (bookingSection) {
                    bookingSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }, 350);
        });
    }
});
</script> 
<!-- Thông tin liên hệ -->
<div class="section">
    <h3>Thông tin liên hệ</h3>
    <div class="contact-info">
        <c:if test="${not empty contactName}">
            <div>Tên: ${contactName}</div>
        </c:if>
        <c:if test="${not empty contactEmail}">
            <div>Email: ${contactEmail}</div>
        </c:if>
        <c:if test="${not empty contactPhone}">
            <div>Điện thoại: ${contactPhone}</div>
        </c:if>
    </div>
</div> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>PayOS Demo</title></head>
<body>
    <h1>Demo Thanh Toán PayOS</h1>
    <form action="payment" method="post">
        <label>Sản phẩm:</label><input type="text" name="productName" required><br>
        <label>Số lượng:</label><input type="number" name="quantity" required><br>
        <label>Giá (VNĐ):</label><input type="number" name="price" required><br>
        <button type="submit">Tạo đơn thanh toán</button>
    </form>
</body>
</html>

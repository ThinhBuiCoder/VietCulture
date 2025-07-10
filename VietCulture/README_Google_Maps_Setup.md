# 🗺️ Hướng dẫn cấu hình Google Maps API cho VietCulture

## ❗ Vấn đề hiện tại
Bạn đang gặp lỗi sau khi tích hợp Google Maps:
- `BillingNotEnabledMapError` - Chưa kích hoạt billing
- `REQUEST_DENIED` - API chưa được enable hoặc cấu hình sai

## 🔧 Cách khắc phục

### Bước 1: Truy cập Google Cloud Console
1. Vào https://console.cloud.google.com/
2. Đăng nhập với tài khoản Google
3. Tạo project mới hoặc chọn project hiện có

### Bước 2: Kích hoạt Billing 💳
1. Trong sidebar, chọn **"Billing"**
2. Chọn **"Link a billing account"**
3. Thêm thẻ tín dụng (Visa/MasterCard)
4. **Lưu ý:** Google Maps có $200 credit miễn phí mỗi tháng

### Bước 3: Enable các APIs cần thiết 🚀
Vào **"APIs & Services"** → **"Library"** và enable:

- ✅ **Maps JavaScript API** - Hiển thị bản đồ
- ✅ **Geocoding API** - Chuyển địa chỉ thành tọa độ  
- ✅ **Directions API** - Tính toán đường đi
- ✅ **Places API** - Tìm kiếm địa điểm
- ✅ **Maps Static API** - Bản đồ tĩnh backup

### Bước 4: Tạo hoặc cấu hình API Key 🔑
1. Vào **"APIs & Services"** → **"Credentials"**
2. Nhấn **"Create Credentials"** → **"API key"**
3. Copy API key vừa tạo
4. Nhấn **"Restrict Key"** để bảo mật:

#### Cấu hình Application restrictions:
- Chọn **"HTTP referrers (web sites)"**
- Thêm domains:
  ```
  http://localhost:8080/*
  https://yourdomain.com/*
  ```

#### Cấu hình API restrictions:
- Chọn **"Restrict key"**
- Chọn các APIs đã enable ở bước 3

### Bước 5: Cập nhật API Key trong code 📝
Thay thế API key hiện tại trong file:
`VietCulture/web/view/jsp/home/experience-detail.jsp`

```javascript
// Tìm dòng này:
script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyA_wn1UlF0T9fIA-4mSO74giEIAn_BVQEg&libraries=geometry,places&callback=initMapSuccess';

// Thay bằng API key mới:
script.src = 'https://maps.googleapis.com/maps/api/js?key=YOUR_NEW_API_KEY&libraries=geometry,places&callback=initMapSuccess';
```

## 🧪 Test API Key
Kiểm tra API key hoạt động:
1. Vào: https://developers.google.com/maps/documentation/javascript/examples/map-simple
2. Thay API key trong example
3. Nếu bản đồ hiển thị → API key OK ✅

## 💰 Chi phí dự kiến
- **$200/tháng miễn phí** từ Google
- **Maps JavaScript API**: $7/1000 requests (sau khi hết free tier)
- **Geocoding API**: $5/1000 requests
- **Directions API**: $5/1000 requests

**Ước tính cho dự án nhỏ**: < $10/tháng

## 🛠️ Debugging
Nếu vẫn gặp lỗi, kiểm tra:
1. **Console Browser** (F12) - xem lỗi cụ thể
2. **Google Cloud Console** → **"APIs & Services"** → **"Metrics"** - xem request status
3. **Billing** - đảm bảo có payment method hợp lệ

## 📞 Hỗ trợ
- Google Maps Documentation: https://developers.google.com/maps/documentation/javascript
- Stack Overflow: Tag `google-maps-api-3`

## 🎯 Kết quả mong đợi
Sau khi cấu hình xong:
- ✅ Bản đồ hiển thị vị trí trải nghiệm
- ✅ Marker tùy chỉnh màu đỏ
- ✅ Info window với thông tin
- ✅ Nút "Chỉ đường từ vị trí hiện tại"
- ✅ Chọn phương tiện di chuyển
- ✅ Panel hướng dẫn chi tiết
- ✅ Nút "Mở Google Maps"

**Chúc bạn cấu hình thành công! 🎉** 
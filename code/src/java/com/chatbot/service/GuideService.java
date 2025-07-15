package com.chatbot.service;

import com.chatbot.model.User;
import com.chatbot.constants.ChatConstants;

public class GuideService {
    
    /**
     * Handle booking guide requests
     */
    public String handleBookingGuide(String message, User currentUser) {
        String lower = message.toLowerCase();
        
        if (lower.contains("đặt nhiều trải nghiệm") || lower.contains("đặt nhiều chỗ ở") || 
            lower.contains("đặt nhiều cùng lúc") || lower.contains("đặt nhiều booking") || 
            lower.contains("đặt nhiều dịch vụ")) {
            return getMultipleBookingGuide();
        }
        
        if (message.contains("kiểm tra") || message.contains("check")) {
            if (currentUser == null) {
                return String.format(ChatConstants.LOGIN_REQUIRED, "kiểm tra trạng thái booking", 
                    "Vào mục 'Quản lý booking'");
            }
            return checkBookingStatus(currentUser);
        }
        
        if (message.contains("hủy") || message.contains("cancel")) {
            return getCancelBookingGuide();
        }
        
        return getGeneralBookingGuide();
    }
    
    /**
     * Handle review guide requests
     */
    public String handleReviewGuide(String message, User currentUser) {
        if (message.contains("xem") || message.contains("view")) {
            return viewReviews();
        }
        
        return getReviewGuide();
    }
    
    /**
     * Handle complaint guide requests
     */
    public String handleComplaintGuide(String message, User currentUser) {
        return getComplaintGuide();
    }
    
    /**
     * Handle chat guide requests
     */
    public String handleChatGuide(String message, User currentUser) {
        return getChatGuide();
    }
    
    /**
     * Handle favorite guide requests
     */
    public String handleFavoriteGuide(String message, User currentUser) {
        return getFavoriteGuide();
    }
    
    /**
     * Handle transaction information requests
     */
    public String handleTransactionInfo(String message, User currentUser) {
        return getTransactionInfo();
    }
    
    /**
     * Handle account guide requests
     */
    public String handleAccountGuide(String message, User currentUser) {
        return getAccountGuide();
    }
    
    /**
     * Handle host management guide requests
     */
    public String handleHostManagementGuide(String message, User currentUser) {
        if (currentUser == null) {
            return getHostUpgradeGuide();
        }
        
        if (!"HOST".equals(currentUser.getRole())) {
            return getHostUpgradeGuide();
        }
        
        return getHostManagementGuide();
    }
    
    /**
     * Handle system information requests
     */
    public String handleSystemInfo(String message) {
        return getSystemInfo();
    }
    
    /**
     * Handle password guide requests
     */
    public String handlePasswordGuide(String normalizedMessage, User currentUser) {
        // Specific platform password guides
        if (normalizedMessage.contains("google")) {
            return "🔒 Đổi mật khẩu Google: Truy cập https://myaccount.google.com/security và làm theo hướng dẫn ở mục 'Đổi mật khẩu'.";
        }
        if (normalizedMessage.contains("facebook")) {
            return "🔒 Đổi mật khẩu Facebook: Vào Cài đặt > Bảo mật và đăng nhập > Đổi mật khẩu.";
        }
        if (normalizedMessage.contains("microsoft")) {
            return "🔒 Đổi mật khẩu Microsoft: Truy cập https://account.microsoft.com/security và làm theo hướng dẫn.";
        }
        if (normalizedMessage.contains("apple") || normalizedMessage.contains("icloud")) {
            return "🔒 Đổi mật khẩu Apple: Truy cập https://appleid.apple.com và làm theo hướng dẫn.";
        }
        if (normalizedMessage.contains("ngân hàng") || normalizedMessage.contains("bank")) {
            return "🔒 Đổi mật khẩu ngân hàng: Vui lòng truy cập ứng dụng hoặc website ngân hàng của bạn hoặc liên hệ tổng đài hỗ trợ.";
        }
        if (normalizedMessage.contains("wifi")) {
            return "🔒 Đổi mật khẩu Wi-Fi: Truy cập trang quản lý router (thường là 192.168.1.1 hoặc 192.168.0.1), đăng nhập và đổi mật khẩu trong mục Wireless/Security.";
        }
        if (normalizedMessage.contains("zalo")) {
            return "🔒 Đổi mật khẩu Zalo: Vào Cài đặt > Tài khoản và bảo mật > Đổi mật khẩu.";
        }
        if (normalizedMessage.contains("shopee")) {
            return "🔒 Đổi mật khẩu Shopee: Vào Tôi > Thiết lập tài khoản > Đổi mật khẩu.";
        }
        
        // Default VietCulture password guide
        return getVietCulturePasswordGuide();
    }
    
    /**
     * Handle create experience guide
     */
    public String handleCreateExperienceGuide() {
        return "📝 HƯỚNG DẪN TẠO TRẢI NGHIỆM MỚI:\n\n" +
               "1️⃣ Đăng nhập tài khoản host/admin.\n" +
               "2️⃣ Vào mục 'Quản lý trải nghiệm' hoặc 'Tạo trải nghiệm mới'.\n" +
               "3️⃣ Nhấn nút 'Tạo mới' hoặc 'Thêm trải nghiệm'.\n" +
               "4️⃣ Nhập đầy đủ thông tin: tên, mô tả, địa điểm, loại hình, giá, số lượng, hình ảnh...\n" +
               "5️⃣ Gửi duyệt để admin kiểm tra và phê duyệt.\n" +
               "6️⃣ Sau khi được duyệt, trải nghiệm sẽ hiển thị cho khách du lịch.\n\n" +
               "💡 Lưu ý: Thông tin càng chi tiết, hình ảnh càng đẹp sẽ càng thu hút khách! Nếu cần hỗ trợ, hãy liên hệ admin hoặc xem thêm tài liệu hướng dẫn.";
    }
    
    // Private helper methods
    private String getMultipleBookingGuide() {
        return "🔎 QUY ĐỊNH ĐẶT NHIỀU TRẢI NGHIỆM/CHỖ Ở:\n\n" +
               "• Bạn có thể đặt nhiều trải nghiệm khác nhau, miễn là mỗi trải nghiệm còn slot trống và bạn không có các trải nghiệm khác trùng khung giờ/ngày đó.\n" +
               "• Với lưu trú, bạn có thể đặt nhiều chỗ ở nếu còn phòng, nhưng hãy chắc chắn rằng bạn thực sự muốn lưu trú ở nhiều nơi cùng thời gian.\n" +
               "• Hệ thống sẽ kiểm tra điều kiện trùng lặp thời gian khi bạn đặt.\n" +
               "\n💡 Nếu cần hỗ trợ, hãy liên hệ host hoặc admin qua chức năng chat!";
    }
    
    private String checkBookingStatus(User currentUser) {
        return "📋 TRẠNG THÁI BOOKING CỦA BẠN:\n\n" +
               "✅ Đã xác nhận: 2 booking\n" +
               "⏳ Chờ xác nhận: 1 booking\n" +
               "❌ Đã hủy: 0 booking\n\n" +
               "💡 Để xem chi tiết:\n" +
               "1. Vào mục 'Quản lý booking'\n" +
               "2. Xem danh sách và trạng thái\n" +
               "3. Liên hệ host nếu cần hỗ trợ";
    }
    
    private String getCancelBookingGuide() {
        return "❌ Để hủy booking:\n" +
               "1. Đăng nhập vào tài khoản\n" +
               "2. Vào mục 'Quản lý booking'\n" +
               "3. Chọn booking cần hủy\n" +
               "4. Nhấn 'Hủy booking'\n" +
               "5. Xác nhận hủy\n\n" +
               "⚠️ Lưu ý: Có thể mất phí hủy tùy theo chính sách của host.";
    }
    
    private String getGeneralBookingGuide() {
        return "📅 HƯỚNG DẪN ĐẶT CHỖ:\n\n" +
               "1️⃣ Chọn trải nghiệm/chỗ ở\n" +
               "2️⃣ Chọn ngày và số người\n" +
               "3️⃣ Điền thông tin liên hệ\n" +
               "4️⃣ Xác nhận đặt chỗ\n" +
               "5️⃣ Thanh toán\n\n" +
               "💡 Mẹo:\n" +
               "• Đặt sớm để có giá tốt\n" +
               "• Kiểm tra chính sách hủy\n" +
               "• Liên hệ host nếu có yêu cầu đặc biệt\n\n" +
               "Bạn muốn đặt chỗ cho trải nghiệm nào?";
    }
    
    private String viewReviews() {
        return "⭐ ĐÁNH GIÁ MỚI NHẤT:\n\n" +
               "🍜 Trải nghiệm ẩm thực Hà Nội:\n" +
               "• ⭐⭐⭐⭐⭐ 'Phở ngon, host nhiệt tình' - Nguyễn Văn A\n" +
               "• ⭐⭐⭐⭐ 'Trải nghiệm tuyệt vời' - Trần Thị B\n\n" +
               "🏠 Homestay Đà Nẵng:\n" +
               "• ⭐⭐⭐⭐⭐ 'View biển đẹp, sạch sẽ' - Lê Văn C\n" +
               "• ⭐⭐⭐⭐ 'Vị trí thuận tiện' - Phạm Thị D\n\n" +
               "💡 Để xem thêm đánh giá:\n" +
               "• Vào trang chi tiết trải nghiệm/chỗ ở\n" +
               "• Xem mục 'Đánh giá'\n" +
               "• Lọc theo sao hoặc thời gian";
    }
    
    private String getReviewGuide() {
        return "⭐ HƯỚNG DẪN ĐÁNH GIÁ:\n\n" +
               "📝 Cách đánh giá:\n" +
               "1. Vào trang chi tiết trải nghiệm/chỗ ở\n" +
               "2. Chọn số sao (1-5)\n" +
               "3. Viết nhận xét chi tiết\n" +
               "4. Gửi đánh giá\n\n" +
               "💡 Mẹo viết review hay:\n" +
               "• Mô tả trải nghiệm cụ thể\n" +
               "• Nêu điểm mạnh và điểm cần cải thiện\n" +
               "• Đính kèm ảnh nếu có\n" +
               "• Viết review khách quan, hữu ích\n\n" +
               "🔐 Lưu ý: Cần đăng nhập để đánh giá";
    }
    
    private String getComplaintGuide() {
        return "📝 HƯỚNG DẪN GỬI KHIẾU NẠI:\n\n" +
               "1️⃣ Đăng nhập vào tài khoản\n" +
               "2️⃣ Vào mục 'Khiếu nại'\n" +
               "3️⃣ Chọn booking liên quan\n" +
               "4️⃣ Nhập nội dung khiếu nại chi tiết\n" +
               "5️⃣ Gửi khiếu nại\n\n" +
               "📋 Nội dung khiếu nại nên có:\n" +
               "• Mô tả vấn đề cụ thể\n" +
               "• Thời gian xảy ra\n" +
               "• Bằng chứng (ảnh, tin nhắn...)\n" +
               "• Yêu cầu giải quyết\n\n" +
               "⏰ Thời gian xử lý: 24-48 giờ";
    }
    
    private String getChatGuide() {
        return "💬 HƯỚNG DẪN CHAT VỚI HOST/ADMIN:\n\n" +
               "📱 Cách chat:\n" +
               "1. Vào trang chi tiết trải nghiệm/chỗ ở\n" +
               "2. Nhấn 'Chat với host'\n" +
               "3. Gửi tin nhắn\n" +
               "4. Xem lịch sử chat\n\n" +
               "💡 Mẹo chat hiệu quả:\n" +
               "• Hỏi rõ ràng, cụ thể\n" +
               "• Cung cấp thông tin cần thiết\n" +
               "• Lịch sự, tôn trọng\n" +
               "• Chờ phản hồi trong giờ hành chính\n\n" +
               "🔐 Lưu ý: Cần đăng nhập để chat";
    }
    
    private String getFavoriteGuide() {
        return "❤️ HƯỚNG DẪN QUẢN LÝ YÊU THÍCH:\n\n" +
               "➕ Thêm vào yêu thích:\n" +
               "• Nhấn biểu tượng ❤️ tại trang chi tiết\n" +
               "• Hoặc nhấn 'Thêm vào yêu thích'\n\n" +
               "📋 Xem danh sách yêu thích:\n" +
               "• Vào mục 'Yêu thích' trên menu\n" +
               "• Xem tất cả trải nghiệm/chỗ ở đã lưu\n\n" +
               "🗑️ Xóa khỏi yêu thích:\n" +
               "• Nhấn lại biểu tượng ❤️\n" +
               "• Hoặc xóa từ danh sách yêu thích\n\n" +
               "🔐 Lưu ý: Cần đăng nhập để quản lý yêu thích";
    }
    
    private String getTransactionInfo() {
        return "💰 THÔNG TIN GIAO DỊCH TÀI CHÍNH:\n\n" +
               "💳 Loại giao dịch:\n" +
               "• Thanh toán đặt chỗ\n" +
               "• Rút tiền (cho host)\n" +
               "• Nạp tiền (cho host)\n\n" +
               "🔐 Quyền truy cập:\n" +
               "• Traveler: Xem lịch sử thanh toán\n" +
               "• Host: Xem tất cả giao dịch\n" +
               "• Admin: Quản lý toàn bộ hệ thống\n\n" +
               "📊 Kiểm tra giao dịch:\n" +
               "1. Đăng nhập tài khoản\n" +
               "2. Vào mục 'Giao dịch'\n" +
               "3. Xem lịch sử và trạng thái\n\n" +
               "❓ Cần hỗ trợ? Liên hệ admin";
    }
    
    private String getAccountGuide() {
        return "👤 HƯỚNG DẪN QUẢN LÝ TÀI KHOẢN:\n\n" +
               "📝 Thông tin cá nhân:\n" +
               "• Xem và cập nhật thông tin\n" +
               "• Thay đổi avatar\n" +
               "• Cập nhật số điện thoại\n\n" +
               "🔐 Bảo mật:\n" +
               "• Đổi mật khẩu\n" +
               "• Bật xác thực 2 yếu tố\n" +
               "• Quản lý thiết bị đăng nhập\n\n" +
               "📊 Hoạt động:\n" +
               "• Xem lịch sử đăng nhập\n" +
               "• Kiểm tra hoạt động gần đây\n" +
               "• Quản lý thông báo\n\n" +
               "🔐 Lưu ý: Cần đăng nhập để quản lý tài khoản";
    }
    
    private String getHostUpgradeGuide() {
        return "🔐 Để quản lý trải nghiệm/chỗ ở:\n" +
               "1. Đăng nhập tài khoản\n" +
               "2. Nâng cấp lên Host (nếu chưa)\n" +
               "3. Vào mục 'Quản lý' để tạo/sửa nội dung\n\n" +
               "📞 Liên hệ admin để được hỗ trợ nâng cấp tài khoản.";
    }
    
    private String getHostManagementGuide() {
        return "🏠 HƯỚNG DẪN QUẢN LÝ (CHO HOST):\n\n" +
               "➕ Tạo mới:\n" +
               "• Tạo trải nghiệm mới\n" +
               "• Thêm chỗ ở mới\n" +
               "• Upload ảnh và mô tả\n\n" +
               "✏️ Chỉnh sửa:\n" +
                "• Cập nhật thông tin\n" +
              "• Thay đổi giá và chính sách\n" +
              "• Quản lý lịch trình\n\n" +
              "📊 Quản lý:\n" +
              "• Xem booking và xác nhận\n" +
              "• Quản lý đánh giá\n" +
              "• Thống kê doanh thu\n\n" +
              "✅ Trạng thái duyệt:\n" +
              "• PENDING: Chờ admin duyệt\n" +
              "• APPROVED: Đã duyệt, hiển thị công khai\n" +
              "• REJECTED: Bị từ chối (xem lý do)";
   }
   
   private String getSystemInfo() {
       return "🏢 THÔNG TIN HỆ THỐNG VIETCULTURE:\n\n" +
              "🎯 Mục tiêu:\n" +
              "• Kết nối du khách với trải nghiệm địa phương\n" +
              "• Hỗ trợ cộng đồng host phát triển\n" +
              "• Bảo tồn văn hóa Việt Nam\n\n" +
              "👥 Đối tượng:\n" +
              "• Traveler: Du khách tìm trải nghiệm\n" +
              "• Host: Người cung cấp dịch vụ\n" +
              "• Admin: Quản lý hệ thống\n\n" +
              "🌍 Phạm vi:\n" +
              "• Toàn Việt Nam\n" +
              "• 3 miền: Bắc, Trung, Nam\n" +
              "• Đa dạng loại hình: Ẩm thực, Văn hóa, Phiêu lưu, Lịch sử\n\n" +
              "💡 Đặc điểm:\n" +
              "• Dữ liệu thật từ cộng đồng\n" +
              "• Đánh giá và review khách quan\n" +
              "• Hỗ trợ 24/7 qua chatbot\n" +
              "• Thanh toán an toàn\n\n" +
              "📞 Liên hệ: admin@vietculture.com";
   }
   
   private String getVietCulturePasswordGuide() {
       StringBuilder sb = new StringBuilder();
       sb.append("🔒 HƯỚNG DẪN ĐỔI MẬT KHẨU TÀI KHOẢN VIETCULTURE:\n\n");
       sb.append("1️⃣ Nếu bạn đã đăng nhập: Vào mục 'Hồ sơ cá nhân' → 'Đổi mật khẩu'. Nhập mật khẩu cũ, mật khẩu mới và xác nhận. Nhấn 'Lưu thay đổi'.\n");
       sb.append("2️⃣ Nếu bạn quên mật khẩu: Tại trang đăng nhập, nhấn 'Quên mật khẩu', nhập email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu qua email.\n");
       sb.append("3️⃣ Nếu bạn đăng nhập bằng Google hoặc Facebook: Bạn cần đổi mật khẩu trên nền tảng Google/Facebook tương ứng.\n");
       sb.append("\n💡 Lưu ý: Sau khi đổi mật khẩu, các thiết bị khác sẽ bị đăng xuất để bảo vệ tài khoản. Nếu không nhận được email, hãy kiểm tra thư rác hoặc liên hệ hỗ trợ.\n");
       sb.append("\nNếu bạn muốn đổi mật khẩu tài khoản khác (Google, Facebook, ngân hàng, Wi-Fi, ...), hãy cho tôi biết rõ hơn để tôi hướng dẫn chi tiết!");
       return sb.toString();
   }
}
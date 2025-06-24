package controller;

import dao.ChatDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/chat/*")
@MultipartConfig
public class ChatServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ChatServlet.class.getName());
    private ChatDAO chatDAO;
    
    @Override
    public void init() {
        chatDAO = new ChatDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị danh sách chat rooms
            showChatList(request, response, currentUser);
        } else if (pathInfo.startsWith("/room/")) {
            // Hiển thị chat room cụ thể
            String roomIdStr = pathInfo.substring(6);
            try {
                int roomId = Integer.parseInt(roomIdStr);
                showChatRoom(request, response, currentUser, roomId);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else if (pathInfo.equals("/api/rooms")) {
            // API: Lấy danh sách chat rooms
            getChatRoomsAPI(request, response, currentUser);
        } else if (pathInfo.startsWith("/api/messages/")) {
            // API: Lấy tin nhắn
            String roomIdStr = pathInfo.substring(14);
            try {
                int roomId = Integer.parseInt(roomIdStr);
                getMessagesAPI(request, response, currentUser, roomId);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else if (pathInfo.equals("/api/unread-count")) {
            // API: Đếm tin nhắn chưa đọc
            getUnreadCountAPI(request, response, currentUser);
        }
    }
    
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    String pathInfo = request.getPathInfo();
    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");
    
    // Enhanced logging
    LOGGER.info("=== POST REQUEST ===");
    LOGGER.info("Path Info: " + pathInfo);
    LOGGER.info("Request URI: " + request.getRequestURI());
    LOGGER.info("Context Path: " + request.getContextPath());
    LOGGER.info("Servlet Path: " + request.getServletPath());
    
    if (currentUser == null) {
        LOGGER.warning("User not logged in");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Not logged in\"}");
        return;
    }
    
    // Handle null pathInfo
    if (pathInfo == null) {
        LOGGER.warning("Path info is null");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Invalid request path\"}");
        return;
    }
    
    try {
        if (pathInfo.equals("/api/create-room")) {
            LOGGER.info("Handling create-room request");
            createChatRoomAPI(request, response, currentUser);
            
        } else if (pathInfo.equals("/api/send-message")) {
            LOGGER.info("Handling send-message request");
            sendMessageAPI(request, response, currentUser);
            
        } else if (pathInfo.startsWith("/api/mark-read/")) {
            LOGGER.info("Handling mark-read request");
            String roomIdStr = pathInfo.substring(15); // "/api/mark-read/".length() = 15
            LOGGER.info("Extracted room ID string: '" + roomIdStr + "'");
            
            if (roomIdStr.isEmpty()) {
                LOGGER.warning("Room ID is empty");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Room ID is required\"}");
                return;
            }
            
            try {
                int roomId = Integer.parseInt(roomIdStr);
                LOGGER.info("Parsed room ID: " + roomId);
                markAsReadAPI(request, response, currentUser, roomId);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid room ID format: " + roomIdStr);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid room ID format\"}");
            }
            
        } else {
            LOGGER.warning("Unknown path: " + pathInfo);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Endpoint not found: " + pathInfo + "\"}");
        }
        
    } catch (Exception e) {
        LOGGER.severe("Unexpected error in doPost: " + e.getMessage());
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Internal server error: " + e.getMessage() + "\"}");
    }
}
    
    // Hiển thị danh sách chat rooms
    private void showChatList(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        List<ChatRoom> chatRooms = chatDAO.getChatRoomsByUserId(currentUser.getUserId());
        int unreadCount = chatDAO.getUnreadMessageCount(currentUser.getUserId());
        
        request.setAttribute("chatRooms", chatRooms);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("currentUser", currentUser);
        
        // SỬA LẠI ĐƯỜNG DẪN JSP
        request.getRequestDispatcher("/view/jsp/chat/chat-list.jsp").forward(request, response);
    }
    
    // Hiển thị chat room cụ thể
    private void showChatRoom(HttpServletRequest request, HttpServletResponse response, User currentUser, int roomId) 
            throws ServletException, IOException {
        
        ChatRoom chatRoom = chatDAO.getChatRoomById(roomId);
        if (chatRoom == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Chat room not found");
            return;
        }
        
        // Kiểm tra quyền truy cập
        if (chatRoom.getUserId() != currentUser.getUserId() && chatRoom.getHostId() != currentUser.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Lấy tin nhắn gần đây (30 tin nhắn đầu)
        List<ChatMessage> messages = chatDAO.getMessages(roomId, 30, 0);
        
        // Đánh dấu tin nhắn đã đọc
        chatDAO.markMessagesAsRead(roomId, currentUser.getUserId());
        
        // Cập nhật last seen
        chatDAO.updateLastSeen(roomId, currentUser.getUserId());
        
        request.setAttribute("chatRoom", chatRoom);
        request.setAttribute("messages", messages);
        request.setAttribute("currentUser", currentUser);
        
        // SỬA LẠI ĐƯỜNG DẪN JSP
        request.getRequestDispatcher("/view/jsp/chat/chat-room.jsp").forward(request, response);
    }
    
    // API: Tạo chat room - SỬA LẠI LOGIC
 private void createChatRoomAPI(HttpServletRequest request, HttpServletResponse response, User currentUser) 
        throws IOException {
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // Enhanced debug logging
    LOGGER.info("=== CREATE CHAT ROOM API CALLED ===");
    LOGGER.info("Request Method: " + request.getMethod());
    LOGGER.info("Content Type: " + request.getContentType());
    LOGGER.info("Content Length: " + request.getContentLength());
    LOGGER.info("Request URI: " + request.getRequestURI());
    LOGGER.info("Query String: " + request.getQueryString());
    
    LOGGER.info("Current User ID: " + currentUser.getUserId());
    LOGGER.info("Current User Name: " + currentUser.getFullName());
    
    // DEBUG: Log ALL parameters
    LOGGER.info("=== ALL REQUEST PARAMETERS ===");
    java.util.Map<String, String[]> paramMap = request.getParameterMap();
    if (paramMap.isEmpty()) {
        LOGGER.warning("Parameter map is EMPTY!");
    } else {
        for (java.util.Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            LOGGER.info("Parameter: " + entry.getKey() + " = " + java.util.Arrays.toString(entry.getValue()));
        }
    }
    
    // DEBUG: Log ALL headers
    LOGGER.info("=== REQUEST HEADERS ===");
    java.util.Enumeration<String> headerNames = request.getHeaderNames();
    while (headerNames.hasMoreElements()) {
        String headerName = headerNames.nextElement();
        String headerValue = request.getHeader(headerName);
        LOGGER.info("Header: " + headerName + " = " + headerValue);
    }
    
    try {
        String hostIdStr = request.getParameter("hostId");
        String experienceIdStr = request.getParameter("experienceId");
        String accommodationIdStr = request.getParameter("accommodationId");
        
        LOGGER.info("Parameters received:");
        LOGGER.info("  hostId: " + hostIdStr);
        LOGGER.info("  experienceId: " + experienceIdStr);
        LOGGER.info("  accommodationId: " + accommodationIdStr);
        
        if (hostIdStr == null || hostIdStr.trim().isEmpty()) {
            LOGGER.warning("Host ID is null or empty - returning error");
            response.getWriter().write("{\"success\": false, \"message\": \"Host ID is required\"}");
            return;
        }
        
        int hostId = Integer.parseInt(hostIdStr);
        LOGGER.info("Parsed hostId: " + hostId);
        
        // Kiểm tra user không thể chat với chính mình
        if (hostId == currentUser.getUserId()) {
            LOGGER.warning("User trying to chat with themselves - returning error");
            response.getWriter().write("{\"success\": false, \"message\": \"Cannot chat with yourself\"}");
            return;
        }
        
        Integer experienceId = experienceIdStr != null && !experienceIdStr.isEmpty() ? Integer.parseInt(experienceIdStr) : null;
        Integer accommodationId = accommodationIdStr != null && !accommodationIdStr.isEmpty() ? Integer.parseInt(accommodationIdStr) : null;
        
        LOGGER.info("Calling chatDAO.getOrCreateChatRoom with:");
        LOGGER.info("  userId: " + currentUser.getUserId());
        LOGGER.info("  hostId: " + hostId);
        LOGGER.info("  experienceId: " + experienceId);
        LOGGER.info("  accommodationId: " + accommodationId);
        
        ChatRoom chatRoom = chatDAO.getOrCreateChatRoom(currentUser.getUserId(), hostId, experienceId, accommodationId);
        
        if (chatRoom != null) {
            LOGGER.info("Chat room created/retrieved successfully:");
            LOGGER.info("  chatRoomId: " + chatRoom.getChatRoomId());
            LOGGER.info("  status: " + chatRoom.getStatus());
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\": true,");
            json.append("\"chatRoomId\":").append(chatRoom.getChatRoomId()).append(",");
            json.append("\"userId\":").append(chatRoom.getUserId()).append(",");
            json.append("\"hostId\":").append(chatRoom.getHostId()).append(",");
            json.append("\"status\":\"").append(chatRoom.getStatus()).append("\"");
            json.append("}");
            
            String jsonResponse = json.toString();
            LOGGER.info("Sending JSON response: " + jsonResponse);
            response.getWriter().write(jsonResponse);
        } else {
            LOGGER.severe("chatDAO.getOrCreateChatRoom returned null");
            response.getWriter().write("{\"success\": false, \"message\": \"Error creating chat room - returned null\"}");
        }
        
    } catch (NumberFormatException e) {
        LOGGER.severe("NumberFormatException: " + e.getMessage());
        response.getWriter().write("{\"success\": false, \"message\": \"Invalid parameters: " + e.getMessage() + "\"}");
    } catch (Exception e) {
        LOGGER.severe("Exception in createChatRoomAPI: " + e.getMessage());
        e.printStackTrace();
        response.getWriter().write("{\"success\": false, \"message\": \"Error creating chat room: " + e.getMessage() + "\"}");
    }
    
    LOGGER.info("=== CREATE CHAT ROOM API FINISHED ===");
}
    
    // API: Gửi tin nhắn
 private void sendMessageAPI(HttpServletRequest request, HttpServletResponse response, User currentUser) 
        throws IOException {
    
    PrintWriter out = null;
    
    try {
        // Set response headers trước khi ghi bất cứ gì
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        // SỬA: Không set Transfer-Encoding để tránh chunked encoding issues
        response.setHeader("Connection", "close");
        
        out = response.getWriter();
        
        LOGGER.info("=== SEND MESSAGE API START ===");
        
        // Extract parameters với null safety
        String roomIdStr = request.getParameter("roomId");
        String receiverIdStr = request.getParameter("receiverId");
        String messageContent = request.getParameter("messageContent");
        String messageType = request.getParameter("messageType");
        
        LOGGER.info("Parameters: roomId=" + roomIdStr + 
                   ", receiverId=" + receiverIdStr + 
                   ", content=" + (messageContent != null ? "'" + messageContent + "'" : "NULL") + 
                   ", type=" + messageType);
        
        // Validate parameters
        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            sendJsonError(response, out, "Room ID is required");
            return;
        }
        
        if (receiverIdStr == null || receiverIdStr.trim().isEmpty()) {
            sendJsonError(response, out, "Receiver ID is required");
            return;
        }
        
        if (messageContent == null || messageContent.trim().isEmpty()) {
            sendJsonError(response, out, "Message content is required");
            return;
        }
        
        // Parse integers
        int roomId, receiverId;
        
        try {
            roomId = Integer.parseInt(roomIdStr.trim());
            receiverId = Integer.parseInt(receiverIdStr.trim());
        } catch (NumberFormatException e) {
            sendJsonError(response, out, "Invalid number format");
            return;
        }
        
        // Validate chat room access
        ChatRoom chatRoom = chatDAO.getChatRoomById(roomId);
        if (chatRoom == null) {
            sendJsonError(response, out, "Chat room not found");
            return;
        }
        
        // Check access permissions
        boolean hasAccess = (chatRoom.getUserId() == currentUser.getUserId()) || 
                           (chatRoom.getHostId() == currentUser.getUserId());
        
        if (!hasAccess) {
            sendJsonError(response, out, "Access denied to this chat room");
            return;
        }
        
        // Validate receiver
        boolean validReceiver = (receiverId == chatRoom.getUserId() && currentUser.getUserId() == chatRoom.getHostId()) ||
                               (receiverId == chatRoom.getHostId() && currentUser.getUserId() == chatRoom.getUserId());
        
        if (!validReceiver) {
            sendJsonError(response, out, "Invalid receiver for this chat room");
            return;
        }
        
        // Create message object
        ChatMessage message = new ChatMessage();
        message.setChatRoomId(roomId);
        message.setSenderId(currentUser.getUserId());
        message.setReceiverId(receiverId);
        message.setMessageContent(messageContent.trim());
        message.setMessageType(messageType != null && !messageType.trim().isEmpty() ? messageType.trim() : "TEXT");
        
        // Send message
        boolean success = chatDAO.sendMessage(message);
        
        // Send response - SỬA: Tạo JSON response cố định độ dài
        String jsonResponse;
        if (success) {
            jsonResponse = "{\"success\": true, \"message\": \"Message sent successfully\"}";
        } else {
            jsonResponse = "{\"success\": false, \"message\": \"Failed to save message to database\"}";
        }
        
        // SỬA: Set Content-Length để tránh chunked encoding
        response.setContentLength(jsonResponse.getBytes("UTF-8").length);
        
        out.write(jsonResponse);
        out.flush();
        
        LOGGER.info("Response sent successfully: " + jsonResponse);
        
    } catch (Exception e) {
        LOGGER.severe("Unexpected exception in sendMessageAPI: " + e.getMessage());
        e.printStackTrace();
        
        if (out != null && !response.isCommitted()) {
            try {
                String errorResponse = "{\"success\": false, \"message\": \"Internal server error\"}";
                response.setContentLength(errorResponse.getBytes("UTF-8").length);
                out.write(errorResponse);
                out.flush();
            } catch (Exception ex) {
                LOGGER.severe("Failed to send error response: " + ex.getMessage());
            }
        }
    } finally {
        if (out != null) {
            try {
                out.close();
            } catch (Exception e) {
                LOGGER.warning("Error closing PrintWriter: " + e.getMessage());
            }
        }
        LOGGER.info("=== SEND MESSAGE API END ===");
    }
}

// Helper method để gửi JSON error response
private void sendJsonError(HttpServletResponse response, PrintWriter out, String errorMessage) throws IOException {
    String jsonError = "{\"success\": false, \"message\": \"" + errorMessage.replace("\"", "\\\"") + "\"}";
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.setContentLength(jsonError.getBytes("UTF-8").length);
    out.write(jsonError);
    out.flush();
}
    
    // API: Đánh dấu đã đọc
    private void markAsReadAPI(HttpServletRequest request, HttpServletResponse response, User currentUser, int roomId) 
        throws IOException {
    
    LOGGER.info("=== MARK AS READ API ===");
    LOGGER.info("Room ID: " + roomId);
    LOGGER.info("User ID: " + currentUser.getUserId());
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        // Verify chat room exists and user has access
        ChatRoom chatRoom = chatDAO.getChatRoomById(roomId);
        if (chatRoom == null) {
            LOGGER.warning("Chat room not found: " + roomId);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"success\": false, \"message\": \"Chat room not found\"}");
            return;
        }
        
        // Check access permissions
        boolean hasAccess = (chatRoom.getUserId() == currentUser.getUserId()) || 
                           (chatRoom.getHostId() == currentUser.getUserId());
        
        if (!hasAccess) {
            LOGGER.warning("Access denied for user " + currentUser.getUserId() + " to room " + roomId);
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
            return;
        }
        
        LOGGER.info("Marking messages as read...");
        boolean success = chatDAO.markMessagesAsRead(roomId, currentUser.getUserId());
        
        LOGGER.info("Updating last seen...");
        chatDAO.updateLastSeen(roomId, currentUser.getUserId());
        
        if (success) {
            LOGGER.info("Messages marked as read successfully");
            response.getWriter().write("{\"success\": true, \"message\": \"Messages marked as read\"}");
        } else {
            LOGGER.info("No messages to mark as read");
            response.getWriter().write("{\"success\": true, \"message\": \"No new messages to mark as read\"}");
        }
        
    } catch (Exception e) {
        LOGGER.severe("Error marking messages as read: " + e.getMessage());
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"success\": false, \"message\": \"Error marking messages as read: " + e.getMessage() + "\"}");
    }
    
    LOGGER.info("=== MARK AS READ API FINISHED ===");
}
    // API: Đếm tin nhắn chưa đọc
    private void getUnreadCountAPI(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int unreadCount = chatDAO.getUnreadMessageCount(currentUser.getUserId());
            response.getWriter().write("{\"unreadCount\": " + unreadCount + "}");
            
        } catch (Exception e) {
            LOGGER.severe("Error getting unread count: " + e.getMessage());
            response.getWriter().write("{\"unreadCount\": 0}");
        }
    }
    
    // API: Lấy danh sách chat rooms (JSON)
    private void getChatRoomsAPI(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<ChatRoom> chatRooms = chatDAO.getChatRoomsByUserId(currentUser.getUserId());
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < chatRooms.size(); i++) {
                ChatRoom room = chatRooms.get(i);
                int unreadCount = chatDAO.getUnreadMessageCountInRoom(room.getChatRoomId(), currentUser.getUserId());
                
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"chatRoomId\":").append(room.getChatRoomId()).append(",");
                json.append("\"userId\":").append(room.getUserId()).append(",");
                json.append("\"hostId\":").append(room.getHostId()).append(",");
                json.append("\"userName\":\"").append(escapeJson(room.getUserName())).append("\",");
                json.append("\"hostName\":\"").append(escapeJson(room.getHostName())).append("\",");
                json.append("\"lastMessage\":\"").append(escapeJson(room.getLastMessage())).append("\",");
                json.append("\"unreadCount\":").append(unreadCount);
                json.append("}");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            LOGGER.severe("Error getting chat rooms: " + e.getMessage());
            response.getWriter().write("[]");
        }
    }
    
    // API: Lấy tin nhắn (JSON)
    private void getMessagesAPI(HttpServletRequest request, HttpServletResponse response, User currentUser, int roomId) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            ChatRoom chatRoom = chatDAO.getChatRoomById(roomId);
            if (chatRoom == null || 
                (chatRoom.getUserId() != currentUser.getUserId() && chatRoom.getHostId() != currentUser.getUserId())) {
                response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
                return;
            }
            
            int limit = 30;
            int offset = 0;
            
            String limitParam = request.getParameter("limit");
            String offsetParam = request.getParameter("offset");
            
            if (limitParam != null) {
                try {
                    limit = Integer.parseInt(limitParam);
                } catch (NumberFormatException ignored) {}
            }
            
            if (offsetParam != null) {
                try {
                    offset = Integer.parseInt(offsetParam);
                } catch (NumberFormatException ignored) {}
            }
            
            List<ChatMessage> messages = chatDAO.getMessages(roomId, limit, offset);
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < messages.size(); i++) {
                ChatMessage msg = messages.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"messageId\":").append(msg.getMessageId()).append(",");
                json.append("\"senderId\":").append(msg.getSenderId()).append(",");
                json.append("\"receiverId\":").append(msg.getReceiverId()).append(",");
                json.append("\"messageContent\":\"").append(escapeJson(msg.getMessageContent())).append("\",");
                json.append("\"messageType\":\"").append(msg.getMessageType()).append("\",");
                json.append("\"isRead\":").append(msg.isRead()).append(",");
                json.append("\"senderName\":\"").append(escapeJson(msg.getSenderName())).append("\",");
                json.append("\"sentAt\":\"").append(msg.getSentAt() != null ? msg.getSentAt().getTime() : "null").append("\"");
                json.append("}");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            LOGGER.severe("Error getting messages: " + e.getMessage());
            response.getWriter().write("[]");
        }
    }
    
    // Helper method để escape JSON strings
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
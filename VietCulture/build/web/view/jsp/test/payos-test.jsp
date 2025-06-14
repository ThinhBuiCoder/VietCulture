<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="utils.PayOSConfig" %>
<%@ page import="test.PayOSConnectionTest" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PayOS Quick Test - Travel</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .status-box {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            border-left: 4px solid;
        }
        .success {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }
        .warning {
            background-color: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }
        .info {
            background-color: #d1ecf1;
            border-color: #17a2b8;
            color: #0c5460;
        }
        .test-result {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
            white-space: pre-wrap;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        h1, h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        th, td {
            text-align: left;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 PayOS Quick Test</h1>
        <p><strong>Project:</strong> Travel System</p>
        <p><strong>Test URL:</strong> <code>http://localhost:8080/Travel/test/payos-quick</code></p>
        
        <hr>
        
        <h2>📋 Configuration Status</h2>
        <%
            boolean isConfigured = PayOSConfig.isConfigured();
            String configStatus = PayOSConfig.getConfigurationStatus();
        %>
        
        <div class="status-box <%= isConfigured ? "success" : "error" %>">
            <strong>Configuration:</strong> <%= isConfigured ? "✅ VALID" : "❌ INVALID" %><br>
            <%= configStatus %>
        </div>
        
        <table>
            <tr><th>Setting</th><th>Value</th><th>Status</th></tr>
            <tr>
                <td>Environment</td>
                <td><%= PayOSConfig.IS_SANDBOX ? "SANDBOX" : "PRODUCTION" %></td>
                <td><span class="<%= PayOSConfig.IS_SANDBOX ? "warning" : "info" %>">
                    <%= PayOSConfig.IS_SANDBOX ? "⚠️ Test Mode" : "🔴 Live Mode" %>
                </span></td>
            </tr>
            <tr>
                <td>API Base URL</td>
                <td><%= PayOSConfig.getApiBaseUrl() %></td>
                <td>✅ Valid</td>
            </tr>
            <tr>
                <td>Client ID</td>
                <td><%= PayOSConfig.CLIENT_ID != null && !PayOSConfig.CLIENT_ID.isEmpty() ? "SET" : "NOT SET" %></td>
                <td><%= PayOSConfig.CLIENT_ID != null && !PayOSConfig.CLIENT_ID.isEmpty() ? "✅" : "❌" %></td>
            </tr>
            <tr>
                <td>API Key</td>
                <td><%= PayOSConfig.API_KEY != null && !PayOSConfig.API_KEY.isEmpty() ? "SET" : "NOT SET" %></td>
                <td><%= PayOSConfig.API_KEY != null && !PayOSConfig.API_KEY.isEmpty() ? "✅" : "❌" %></td>
            </tr>
            <tr>
                <td>Checksum Key</td>
                <td><%= PayOSConfig.CHECKSUM_KEY != null && !PayOSConfig.CHECKSUM_KEY.isEmpty() ? "SET" : "NOT SET" %></td>
                <td><%= PayOSConfig.CHECKSUM_KEY != null && !PayOSConfig.CHECKSUM_KEY.isEmpty() ? "✅" : "❌" %></td>
            </tr>
        </table>
        
        <h2>🌐 Connectivity Test</h2>
        <%
            boolean canConnect = PayOSConnectionTest.quickConnectivityTest();
        %>
        
        <div class="status-box <%= canConnect ? "success" : "error" %>">
            <strong>Network Connectivity:</strong> <%= canConnect ? "✅ CONNECTED" : "❌ FAILED" %><br>
            <%= canConnect ? "Successfully connected to PayOS API" : "Cannot reach PayOS servers" %>
        </div>
        
        <% if (!canConnect) { %>
        <div class="status-box warning">
            <strong>Troubleshooting:</strong><br>
            1. Check your internet connection<br>
            2. Verify firewall settings<br>
            3. Try ping: <code>ping sandbox-api-merchant.payos.vn</code><br>
            4. Check if PayOS API is down
        </div>
        <% } %>
        
        <h2>🔧 Quick Actions</h2>
        
        <a href="<%= request.getContextPath() %>/test/payos" class="btn">
            📊 Detailed Test Report
        </a>
        
        <% if (isConfigured && canConnect) { %>
        <a href="<%= request.getContextPath() %>/booking/confirm" class="btn">
            💳 Test Booking Flow
        </a>
        <% } %>
        
        <a href="<%= request.getContextPath() %>/" class="btn">
            🏠 Back to Home
        </a>
        
        <% if (isConfigured && canConnect) { %>
        <div class="status-box success">
            <h3>🎉 Ready to Go!</h3>
            PayOS integration is properly configured and connected. You can now:
            <ul>
                <li>Create test bookings</li>
                <li>Process payments</li>
                <li>Test the full booking flow</li>
            </ul>
        </div>
        <% } else { %>
        <div class="status-box error">
            <h3>🚨 Issues Found</h3>
            Please fix the following issues before using PayOS:
            <ul>
                <% if (!isConfigured) { %>
                <li>Update PayOS credentials in <code>PayOSConfig.java</code></li>
                <% } %>
                <% if (!canConnect) { %>
                <li>Fix network connectivity issues</li>
                <% } %>
            </ul>
        </div>
        <% } %>
        
        <hr>
        
        <h2>📖 Next Steps</h2>
        <div class="test-result">
1. Truy cập: http://localhost:8080/Travel/test/payos
2. Kiểm tra detailed test report
3. Nếu mọi thứ OK, test booking: http://localhost:8080/Travel/booking?experienceId=1
4. Monitor logs trong console để debug

Current Time: <%= new java.util.Date() %>
        </div>
        
        <div class="status-box info">
            <small>
                <strong>Note:</strong> This is a quick diagnostic page. 
                For detailed testing, use the full test servlet at 
                <code>/test/payos</code>
            </small>
        </div>
    </div>
</body>
</html>
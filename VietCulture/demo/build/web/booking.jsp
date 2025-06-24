<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Tour Trải Nghiệm Cộng Đồng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 50px auto;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #2c3e50;
                text-align: center;
                margin-bottom: 30px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #34495e;
            }
            input[type="text"], input[type="email"], input[type="number"], select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
                box-sizing: border-box;
            }
            input:focus {
                border-color: #3498db;
                outline: none;
            }
            .btn {
                width: 100%;
                padding: 15px;
                background-color: #3498db;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            .btn:hover {
                background-color: #2980b9;
            }
            .error {
                color: #e74c3c;
                margin-bottom: 20px;
                padding: 10px;
                background-color: #fadbd8;
                border-radius: 5px;
            }
            .tour-info {
                background-color: #ecf0f1;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>🏞️ Đặt Tour Trải Nghiệm Cộng Đồng</h2>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <div class="tour-info">
                <h3>Thông tin tour mẫu:</h3>
                <ul>
                    <li>🌾 Tour làm nông nghiệp với người dân địa phương - 500,000 VND</li>
                    <li>🏘️ Tour khám phá làng nghề truyền thống - 400,000 VND</li>
                    <li>🍲 Tour ẩm thực bản địa - 350,000 VND</li>
                    <li>🎭 Tour văn hóa dân gian - 450,000 VND</li>
                </ul>
            </div>

            <form action="BookingServlet" method="post">
                <div class="form-group">
                    <label for="customerName">Họ và tên <span style="color: red;">*</span></label>
                    <input type="text" id="customerName" name="customerName" required 
                           placeholder="Nhập họ và tên của bạn">
                </div>

                <div class="form-group">
                    <label for="email">Email <span style="color: red;">*</span></label>
                    <input type="email" id="email" name="email" required 
                           placeholder="Nhập địa chỉ email">
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại <span style="color: red;">*</span></label>
                    <input type="text" id="phone" name="phone" required 
                           placeholder="Nhập số điện thoại">
                </div>

                <div class="form-group">
                    <label for="tourName">Tên tour <span style="color: red;">*</span></label>
                    <select id="tourName" name="tourName" required>
                        <option value="">-- Chọn tour --</option>
                        <option value="Tour làm nông nghiệp với người dân địa phương">Tour làm nông nghiệp với người dân địa phương</option>
                        <option value="Tour khám phá làng nghề truyền thống">Tour khám phá làng nghề truyền thống</option>
                        <option value="Tour ẩm thực bản địa">Tour ẩm thực bản địa</option>
                        <option value="Tour văn hóa dân gian">Tour văn hóa dân gian</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="amount">Giá tour (VND) <span style="color: red;">*</span></label>
                    <input type="number" id="amount" name="amount" required min="1000" 
                           placeholder="Nhập giá tour">
                </div>

                <button type="submit" class="btn">📝 Đặt Tour Ngay</button>
            </form>
        </div>

        <script>
            // Auto fill giá khi chọn tour
            document.getElementById('tourName').addEventListener('change', function () {
                const amountField = document.getElementById('amount');
                const selectedTour = this.value;

                switch (selectedTour) {
                    case 'Tour làm nông nghiệp với người dân địa phương':
                        amountField.value = '500000';
                        break;
                    case 'Tour khám phá làng nghề truyền thống':
                        amountField.value = '400000';
                        break;
                    case 'Tour ẩm thực bản địa':
                        amountField.value = '350000';
                        break;
                    case 'Tour văn hóa dân gian':
                        amountField.value = '450000';
                        break;
                    default:
                        amountField.value = '';
                }
            });
        </script>
    </body>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Tour Trải Nghiệm Cộng Đồng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #34495e;
        }
        input[type="text"], input[type="email"], input[type="number"], select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        input:focus {
            border-color: #3498db;
            outline: none;
        }
        .btn {
            width: 100%;
            padding: 15px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .error {
            color: #e74c3c;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #fadbd8;
            border-radius: 5px;
        }
        .tour-info {
            background-color: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏞️ Đặt Tour Trải Nghiệm Cộng Đồng</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="tour-info">
            <h3>Thông tin tour mẫu:</h3>
            <ul>
                <li>🌾 Tour làm nông nghiệp với người dân địa phương - 500,000 VND</li>
                <li>🏘️ Tour khám phá làng nghề truyền thống - 400,000 VND</li>
                <li>🍲 Tour ẩm thực bản địa - 350,000 VND</li>
                <li>🎭 Tour văn hóa dân gian - 450,000 VND</li>
            </ul>
        </div>

        <form action="BookingServlet" method="post">
            <div class="form-group">
                <label for="customerName">Họ và tên <span style="color: red;">*</span></label>
                <input type="text" id="customerName" name="customerName" required 
                       placeholder="Nhập họ và tên của bạn">
            </div>

            <div class="form-group">
                <label for="email">Email <span style="color: red;">*</span></label>
                <input type="email" id="email" name="email" required 
                       placeholder="Nhập địa chỉ email">
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại <span style="color: red;">*</span></label>
                <input type="text" id="phone" name="phone" required 
                       placeholder="Nhập số điện thoại">
            </div>

            <div class="form-group">
                <label for="tourName">Tên tour <span style="color: red;">*</span></label>
                <select id="tourName" name="tourName" required>
                    <option value="">-- Chọn tour --</option>
                    <option value="Tour làm nông nghiệp với người dân địa phương">Tour làm nông nghiệp với người dân địa phương</option>
                    <option value="Tour khám phá làng nghề truyền thống">Tour khám phá làng nghề truyền thống</option>
                    <option value="Tour ẩm thực bản địa">Tour ẩm thực bản địa</option>
                    <option value="Tour văn hóa dân gian">Tour văn hóa dân gian</option>
                </select>
            </div>

            <div class="form-group">
                <label for="amount">Giá tour (VND) <span style="color: red;">*</span></label>
                <input type="number" id="amount" name="amount" required min="1000" 
                       placeholder="Nhập giá tour">
            </div>

            <button type="submit" class="btn">📝 Đặt Tour Ngay</button>
        </form>
    </div>

    <script>
        // Auto fill giá khi chọn tour
        document.getElementById('tourName').addEventListener('change', function() {
            const amountField = document.getElementById('amount');
            const selectedTour = this.value;
            
            switch(selectedTour) {
                case 'Tour làm nông nghiệp với người dân địa phương':
                    amountField.value = '500000';
                    break;
                case 'Tour khám phá làng nghề truyền thống':
                    amountField.value = '400000';
                    break;
                case 'Tour ẩm thực bản địa':
                    amountField.value = '350000';
                    break;
                case 'Tour văn hóa dân gian':
                    amountField.value = '450000';
                    break;
                default:
                    amountField.value = '';
            }
        });
    </script>
</body>
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trải Nghiệm Du Lịch Cộng Đồng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <style>
            .nav-chat-link {
    position: relative;
    color: rgba(255,255,255,0.7);
    text-decoration: none;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.nav-chat-link:hover {
    color: var(--primary-color) !important;
    background-color: rgba(255, 56, 92, 0.1);
    transform: translateY(-1px);
}

.message-badge {
    position: absolute;
    top: -2px;
    right: -2px;
    background: #FF385C;
    color: white;
    border-radius: 50%;
    width: 16px;
    height: 16px;
    display: none;
    align-items: center;
    justify-content: center;
    font-size: 0.6rem;
    font-weight: 600;
    border: 2px solid #10466C;
    animation: pulse 2s infinite;
}

.message-badge.show {
    display: flex;
}

@keyframes pulse {
    0% {
        box-shadow: 0 0 0 0 rgba(255, 56, 92, 0.7);
    }
    70% {
        box-shadow: 0 0 0 10px rgba(255, 56, 92, 0);
    }
    100% {
        box-shadow: 0 0 0 0 rgba(255, 56, 92, 0);
    }
}
            .success-card {
                border-left: 4px solid #28a745;
                animation: fadeInUp 0.6s ease-out;
            }
            .category-icon {
                width: 60px;
                height: 60px;
                margin-bottom: 15px;
                border-radius: 50%; /* Làm tròn hình ảnh */
                object-fit: cover; /* Đảm bảo hình ảnh không bị méo */
                box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Thêm bóng đổ */
                transition: transform 0.3s ease; /* Hiệu ứng hover */
            }

            .category-item:hover .category-icon {
                transform: scale(1.1); /* Phóng to khi hover */
            }

            .success-icon {
                width: 40px;
                height: 40px;
                background: #28a745;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2em;
            }

            @keyframes fadeInUp {
                from {
                    transform: translateY(30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .dropdown-item {
                color: #10466C ;
            }

            .dropdown-item i {
                color: #10466C ;
            }
            .navbar-brand img {
                height: 50px !important;
                width: auto !important;
                margin-right: 12px !important;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
                object-fit: contain !important;
                display: inline-block !important;
            }
            :root {
                --primary-color: #FF385C;
                --secondary-color: #83C5BE;
                --accent-color: #F8F9FA;
                --dark-color: #2F4858;
                --light-color: #FFFFFF;
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
                background-color: var(--accent-color);
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

            .btn-outline-primary {
                color: var(--primary-color);
                border: 2px solid var(--primary-color);
                background: transparent;
                transition: var(--transition);
            }

            .btn-outline-primary:hover {
                background: var(--primary-color);
                color: white;
                transform: translateY(-3px);
            }

            /* Modern Navbar */
            .custom-navbar {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                background-color: #10466C; /* Thay đổi màu nền */
                backdrop-filter: blur(10px);
                box-shadow: var(--shadow-sm);
                z-index: 1000;
                padding: 15px 0;
                transition: var(--transition);
            }

            .custom-navbar.scrolled {
                padding: 10px 0;
                background-color: #10466C; /* Giữ nguyên màu navbar */
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
                color: white; /* Đổi màu chữ thành trắng để dễ đọc */
                text-decoration: none;
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
                color: rgba(255,255,255,0.7); /* Màu chữ nhạt hơn */
                text-decoration: none;
            }

            .nav-center-item:hover {
                color: white; /* Màu chữ trắng khi hover */
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
                color: rgba(255,255,255,0.7); /* Màu chữ nhạt hơn */
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
                border: 1px solid rgba(255,255,255,0.2); /* Viền nhạt màu trắng */
                padding: 8px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: var(--transition);
                box-shadow: var(--shadow-sm);
                position: relative;
                background-color: rgba(255,255,255,0.1); /* Nền nhẹ */
                color: white; /* Màu icon trắng */
            }

            .nav-right .menu-icon:hover {
                background: rgba(255,255,255,0.2); /* Nền sáng hơn khi hover */
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }
            .nav-right .menu-icon i {
                color: white; /* Đảm bảo icon luôn trắng */
            }

            .dropdown-menu-custom {
                position: absolute;
                top: 100%;
                right: 0;
                background-color: white; /* Thay đổi màu nền thành trắng */
                border-radius: var(--border-radius);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2); /* Tăng độ mờ của shadow */
                width: 250px;
                padding: 15px;
                display: none;
                z-index: 1000;
                margin-top: 10px;
                opacity: 0;
                transform: translateY(10px);
                transition: var(--transition);
                border: 1px solid rgba(0,0,0,0.1); /* Thêm viền nhẹ */
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
                color: #10466C; /* Đổi màu chữ thành màu navbar */
                transition: var(--transition);
                border-radius: 10px;
                margin-bottom: 5px;
            }

            .dropdown-menu-custom a:hover {
                background-color: rgba(16, 70, 108, 0.05); /* Màu nền nhẹ của navbar */
                color: #10466C; /* Giữ nguyên màu chữ khi hover */
                transform: translateX(3px);
            }

            .dropdown-menu-custom a i {
                margin-right: 12px;
                font-size: 18px;
                color: #10466C; /* Màu icon theo navbar */
            }

            /* Hero Section */
            .hero-section {
                background: linear-gradient(rgba(0,109,119,0.7), rgba(131,197,190,0.7)),
                    url('https://cdn.pixabay.com/photo/2019/05/30/01/52/rice-terraces-4239042_1280.jpg') no-repeat center/cover;
                color: var(--light-color);
                padding: 150px 0;
                text-align: center;
                margin-bottom: 50px;
                position: relative;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 100px;
                background: linear-gradient(to top, var(--accent-color), transparent);
            }

            .hero-section h1 {
                font-size: 4rem;
                margin-bottom: 20px;
                font-weight: 800;
                text-shadow: 0 2px 10px rgba(0,0,0,0.2);
            }

            .hero-section p {
                font-size: 1.2rem;
                max-width: 700px;
                margin: 0 auto 30px;
                text-shadow: 0 1px 5px rgba(0,0,0,0.2);
            }

            /* Tabs Section */
            .tabs-section {
                margin-bottom: 30px;
            }

            .nav-tabs {
                border: none;
                display: flex;
                justify-content: center;
                margin-bottom: 40px;
            }

            .nav-tabs .nav-item {
                margin: 0 10px;
            }

            .nav-tabs .nav-link {
                border: none;
                background-color: transparent;
                color: var(--dark-color);
                font-weight: 500;
                padding: 15px 25px;
                border-radius: 30px;
                transition: var(--transition);
            }

            .nav-tabs .nav-link.active {
                background: var(--gradient-primary);
                color: white;
                box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
            }

            .nav-tabs .nav-link:hover:not(.active) {
                background-color: rgba(255, 56, 92, 0.1);
                transform: translateY(-3px);
            }

            /* Categories Section */
            .categories-section {
                padding: 50px 0;
                background-color: var(--light-color);
            }

            .category-item {
                text-align: center;
                padding: 20px;
                border-radius: var(--border-radius);
                background-color: var(--accent-color);
                transition: var(--transition);
                cursor: pointer;
                box-shadow: var(--shadow-sm);
            }

            .category-item:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-md);
            }

            .category-icon {
                width: 60px;
                height: 60px;
                margin-bottom: 15px;
            }

            .category-item h5 {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .category-item p {
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Search Container with Glass Effect */
            .search-container {
                background: rgba(255,255,255,0.7);
                backdrop-filter: blur(10px);
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-lg);
                padding: 30px;
                max-width: 900px;
                margin: 0 auto 50px;
                border: 1px solid rgba(255,255,255,0.2);
                transition: var(--transition);
            }

            .search-container:hover {
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                transform: translateY(-5px);
            }

            .search-form {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            .search-form .form-group {
                display: flex;
                flex-direction: column;
            }

            .search-form label {
                margin-bottom: 8px;
                color: var(--dark-color);
                font-weight: 600;
                font-size: 0.9rem;
            }

            .search-form .form-control {
                border-radius: 10px;
                padding: 12px;
                border: 1px solid rgba(0,0,0,0.1);
                transition: var(--transition);
                background-color: rgba(255,255,255,0.8);
            }

            .search-form .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .search-form .input-group {
                display: flex;
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid rgba(0,0,0,0.1);
                background-color: rgba(255,255,255,0.8);
            }

            .search-form .input-group .btn {
                border-radius: 0;
                padding: 0 15px;
                font-size: 1.2rem;
                background-color: transparent;
                color: var(--dark-color);
                border: none;
                transition: var(--transition);
            }

            .search-form .input-group .btn:hover {
                background-color: rgba(0,0,0,0.05);
            }

            .search-form .input-group input {
                border: none;
                text-align: center;
                font-weight: 600;
                background-color: transparent;
            }

            .search-form .input-group input:focus {
                box-shadow: none;
            }

            .search-form .btn-primary {
                background: var(--gradient-primary);
                border: none;
                padding: 15px;
                margin-top: 10px;
                grid-column: span 2;
                font-weight: 600;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: var(--transition);
            }

            .search-form .btn-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(255, 56, 92, 0.25);
            }

            .search-form .btn-primary i {
                font-size: 1.1rem;
            }

            /* Cards Grid */
            .cards-grid {
                display: grid !important;
                grid-template-columns: repeat(3, 1fr);
                gap: 30px;
                margin-top: 50px;
                position: relative;
                z-index: 1;
            }

            /* Experience Card */
            .card-item {
                background-color: var(--light-color) !important;
                border-radius: var(--border-radius) !important;
                overflow: hidden !important;
                transition: var(--transition);
                box-shadow: var(--shadow-md) !important;
                position: relative;
                height: auto !important;
                min-height: 370px !important;
                display: flex !important;
                flex-direction: column !important;
                z-index: 5;
                opacity: 1 !important;
                visibility: visible !important;
                transform: none !important;
            }

            .card-item:hover {
                transform: translateY(-10px) !important;
                box-shadow: var(--shadow-lg) !important;
            }

            .card-image {
                height: 200px !important;
                position: relative !important;
                overflow: hidden !important;
            }

            .card-image img {
                width: 100% !important;
                height: 100% !important;
                object-fit: cover !important;
                transition: var(--transition);
            }

            .card-item:hover .card-image img {
                transform: scale(1.1);
            }

            .card-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: var(--gradient-primary);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(255, 56, 92, 0.3);
            }

            .difficulty-badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background: var(--gradient-secondary);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(0, 109, 119, 0.3);
            }

            .card-content {
                padding: 25px !important;
                text-align: left;
                flex-grow: 1 !important;
                display: flex !important;
                flex-direction: column !important;
            }

            .card-item h5 {
                color: var(--dark-color);
                margin-bottom: 10px;
                font-weight: 700;
                font-size: 1.25rem;
            }

            .location {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                color: #6c757d;
                font-size: 0.9rem;
            }

            .location i {
                margin-right: 5px;
                color: var(--primary-color);
            }

            .card-item p {
                color: #6c757d;
                margin-bottom: 20px;
                font-size: 0.9rem;
                flex-grow: 1;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                font-size: 0.85rem;
                color: #6c757d;
            }

            .info-row i {
                margin-right: 5px;
                font-size: 1rem;
            }

            .card-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: auto;
            }

            .price {
                font-weight: 700;
                color: var(--primary-color);
                font-size: 1.1rem;
            }

            .rating {
                display: flex;
                align-items: center;
                font-weight: 600;
                color: var(--dark-color);
            }

            .rating i {
                color: #FFD700;
                margin-right: 5px;
            }

            .host-info {
                display: flex;
                align-items: center;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid rgba(0,0,0,0.1);
            }

            .host-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
                border: 2px solid var(--secondary-color);
            }

            .host-name {
                font-weight: 600;
                font-size: 0.9rem;
            }

            .card-action {
                margin-top: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-item .btn-outline-primary {
                padding: 8px 16px;
                font-size: 0.9rem;
            }

            .card-item .btn-copy {
                background-color: transparent;
                border: none;
                cursor: pointer;
                color: #6c757d;
                transition: var(--transition);
                padding: 5px 10px;
                border-radius: 5px;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .card-item .btn-copy:hover {
                color: var(--dark-color);
                background-color: rgba(0,0,0,0.05);
            }

            .card-item .btn-copy i {
                font-size: 1rem;
            }

            /* Accommodation Card Specific */
            .accommodation-card .amenities {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }

            .accommodation-card .amenity {
                background-color: rgba(0,109,119,0.1);
                color: var(--dark-color);
                border-radius: 20px;
                padding: 4px 12px;
                font-size: 0.75rem;
                display: inline-flex;
                align-items: center;
            }

            .accommodation-card .amenity i {
                margin-right: 5px;
                font-size: 0.9rem;
                color: var(--secondary-color);
            }

            .accommodation-card .type-badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background: var(--gradient-secondary);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 3px 10px rgba(0, 109, 119, 0.3);
            }

            .accommodation-card .rooms-info {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .accommodation-card .rooms-info i {
                margin-right: 5px;
                color: var(--secondary-color);
                font-size: 1rem;
            }

            /* Footer */
            .footer {
                background-color: var(--dark-color);
                color: var(--light-color);
                padding: 80px 0 40px;
                position: relative;
            }

            .footer::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100px;
                background: linear-gradient(to bottom, var(--accent-color), transparent);
                opacity: 0.1;
            }

            .footer h5 {
                font-size: 1.3rem;
                margin-bottom: 25px;
                position: relative;
                display: inline-block;
            }

            .footer h5::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                width: 40px;
                height: 3px;
                background: var(--gradient-primary);
                border-radius: 3px;
            }

            .footer p {
                color: rgba(255,255,255,0.7);
                margin-bottom: 15px;
            }

            .footer a {
                color: var(--secondary-color);
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
                margin-bottom: 10px;
            }

            .footer a:hover {
                color: var(--primary-color);
                transform: translateX(3px);
            }

            .footer .list-unstyled li {
                margin-bottom: 15px;
            }

            .footer .social-icons {
                display: flex;
                gap: 15px;
                margin-top: 20px;
            }

            .footer .social-icons a {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background-color: rgba(255,255,255,0.1);
                border-radius: 50%;
                transition: var(--transition);
            }

            .footer .social-icons a:hover {
                background-color: var(--primary-color);
                transform: translateY(-5px);
            }

            .footer .social-icons i {
                font-size: 1.2rem;
            }

            .footer .copyright {
                text-align: center;
                padding-top: 40px;
                margin-top: 40px;
                border-top: 1px solid rgba(255,255,255,0.1);
                color: rgba(255,255,255,0.5);
                font-size: 0.9rem;
            }

            /* Toast Notification */
            .toast-container {
                position: fixed;
                bottom: 20px;
                right: 20px;
                z-index: 9999;
            }

            .toast {
                background-color: var(--dark-color);
                color: white;
                padding: 15px 25px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
                transform: translateX(100%);
                opacity: 0;
                transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            }

            .toast.show {
                transform: translateX(0);
                opacity: 1;
            }

            .toast i {
                font-size: 1.2rem;
                color: #4BB543;
            }

            /* Animations */
            .fade-up {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.8s ease-out;
            }

            .fade-up.active {
                opacity: 1;
                transform: translateY(0);
            }

            .stagger-item {
                opacity: 1;
                transform: translateY(0);
                transition: all 0.5s ease-out;
            }

            /* Responsive Adjustments */
            @media (max-width: 992px) {
                .hero-section h1 {
                    font-size: 3rem;
                }

                .nav-center {
                    position: relative;
                    left: 0;
                    transform: none;
                    margin-top: 20px;
                    justify-content: center;
                }

                .custom-navbar .container {
                    flex-direction: column;
                }

                .cards-grid {
                    grid-template-columns: repeat(2, 1fr) !important;
                }
            }

            @media (max-width: 768px) {
                .cards-grid {
                    grid-template-columns: 1fr !important;
                }

                .search-form {
                    grid-template-columns: 1fr;
                }

                .search-form .btn-primary {
                    grid-column: span 1;
                }

                .hero-section h1 {
                    font-size: 2.5rem;
                }

                .custom-navbar {
                    padding: 10px 0;
                }

                .nav-right {
                    margin-top: 15px;
                }

                .nav-tabs .nav-item {
                    margin: 0 5px;
                }

                .nav-tabs .nav-link {
                    padding: 10px 15px;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>


        <%-- Debugging Information (can be removed in production) --%>
        <div style="display:none;">
            Logged In: ${not empty sessionScope.user}
            <c:if test="${not empty sessionScope.user}">
                User Email: ${sessionScope.user.email}
                User Full Name: ${sessionScope.user.fullName}
                User Type: ${sessionScope.user.role}
            </c:if>
        </div>

        <!-- Kiểm tra thông báo từ session -->
        <c:if test="${not empty sessionScope.loginMessage}">
            <div class="container mt-3">
                <div class="card border-0 shadow-sm success-card">
                    <div class="card-body d-flex align-items-center">
                        <div class="success-icon me-3">
                            <i class="ri-check-circle-fill"></i>
                        </div>
                        <div class="flex-grow-1">
                            <h6 class="mb-1 text-success">Đăng nhập thành công!</h6>
                            <p class="mb-0 text-muted">${sessionScope.loginMessage}</p>
                        </div>
                        <button type="button" class="btn-close" onclick="this.closest('.card').style.display = 'none'"></button>
                    </div>
                </div>
            </div>
            <c:remove var="loginMessage" scope="session"/>
        </c:if>

        <!-- Navigation -->
        <%-- Navigation (modified to work with servlet-based authentication) --%>
   <nav class="custom-navbar">
    <div class="container">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
            <span>VIETCULTURE</span>
        </a>

        <div class="nav-center">
            <a href="#home" class="nav-center-item">
                Trang Chủ
            </a>
            <a href="/Travel/experiences" class="nav-center-item">
                Trải Nghiệm
            </a>
            <a href="/Travel/accommodations" class="nav-center-item">
                Lưu Trú
            </a>
        </div>

        <div class="nav-right">
            <%-- Conditional rendering based on user authentication --%>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Icon tin nhắn cố định cho HOST và TRAVELER -->
                    <c:if test="${sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER'}">
                        <a href="${pageContext.request.contextPath}/chat" class="nav-chat-link me-3">
                            <i class="ri-message-3-line" style="font-size: 1.2rem; color: rgba(255,255,255,0.7);"></i>
                            <!-- Badge đỏ sẽ được thêm bằng JavaScript -->
                        </a>
                    </c:if>
                    
                    <div class="dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                            <i class="ri-user-line" style="color: white;"></i> 
                            ${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <%-- Role-based dashboard access --%>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard" style="color: #10466C; font-weight: 600;">
                                        <i class="ri-dashboard-line"></i> Quản Trị
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user.role == 'HOST'}">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_service" style="color: #10466C; font-weight: 600;">
                                        <i class="ri-add-circle-line"></i> Tạo Dịch Vụ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/host/services/manage" style="color: #10466C; font-weight: 600;">
                                        <i class="ri-settings-4-line"></i> Quản Lý Dịch Vụ
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/traveler/upgrade-to-host" style="color: #10466C; font-weight: 600;">
                                        <i class="ri-vip-crown-line"></i> Nâng Lên Host
                                    </a>
                                </li>
                            </c:if>
                            
                            <%-- Common profile options --%>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-user-settings-line"></i> Hồ Sơ
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-logout-circle-r-line"></i> Đăng Xuất
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Not logged in state --%>
                    <i class="ri-global-line globe-icon me-3"></i>
                    <div class="menu-icon">
                        <i class="ri-menu-line"></i>
                        <div class="dropdown-menu-custom">
                            <a href="#help-center">
                                <i class="ri-question-line" style="color: #10466C;"></i>Trung tâm Trợ giúp
                            </a>
                            <a href="${pageContext.request.contextPath}/contact">
                                <i class="ri-contacts-line" style="color: #10466C;"></i>Liên Hệ
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="nav-link">
                                <i class="ri-login-circle-line" style="color: #10466C;"></i> Đăng Nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register">
                                <i class="ri-user-add-line" style="color: #10466C;"></i>Đăng Ký
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

        <!-- Hero Section -->
        <section class="hero-section" id="home">
            <div class="container">
                <h1 class="animate__animated animate__fadeInUp">Khám Phá Việt Nam Cùng Người Dân Địa Phương</h1>
                <p class="animate__animated animate__fadeInUp animate__delay-1s">Trải nghiệm du lịch độc đáo, lưu trú thoải mái và kết nối với văn hóa bản địa</p>
                <div class="d-flex justify-content-center gap-3 animate__animated animate__fadeInUp animate__delay-2s">
                    <a href="/Travel/experiences" class="btn btn-primary">
                        <i class="ri-search-line"></i> Khám Phá Trải Nghiệm
                    </a>
                    <a href="/Travel/accommodations" class="btn btn-outline-primary">
                        <i class="ri-home-line"></i> Tìm Nơi Lưu Trú
                    </a>
                </div>
            </div>
        </section>

        <!-- Categories Section -->
        <section id="categories" class="categories-section">
            <div class="container">
                <h2 class="text-center mb-5 fade-up">Danh Mục Trải Nghiệm</h2>

                <div class="row fade-up">
                    <c:forEach var="category" items="${categories}">
                        <div class="col-md-3 col-6 mb-4 stagger-item">
                            <div class="category-item" data-category="${category.name}">
                                <img src="${pageContext.request.contextPath}/assets/images/categories/${category.iconUrl}" alt="${category.name}" class="category-icon">
                                <h5>
                                    <c:choose>
                                        <c:when test="${category.name == 'Food'}">Ẩm Thực</c:when>
                                        <c:when test="${category.name == 'Culture'}">Văn Hóa</c:when>
                                        <c:when test="${category.name == 'Adventure'}">Phiêu Lưu</c:when>
                                        <c:when test="${category.name == 'History'}">Lịch Sử</c:when>
                                        <c:otherwise>${category.name}</c:otherwise>
                                    </c:choose>
                                </h5>
                                <p>${category.description}</p>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Default categories if none from database -->
                    <c:if test="${empty categories}">
                        <div class="col-md-3 col-6 mb-4 stagger-item">
                            <div class="category-item" data-category="Food">
                                <!-- Hình ảnh ẩm thực Việt Nam -->
                                <img src="https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2023/9/29/1247753/Am-Thuc-Viet-Nam.jpeg" alt="Food" class="category-icon">
                                <h5>Ẩm Thực</h5>
                                <p>Khám phá nền ẩm thực địa phương & học nấu ăn</p>
                            </div>
                        </div>

                        <div class="col-md-3 col-6 mb-4 stagger-item">
                            <div class="category-item" data-category="Culture">
                                <!-- Hình ảnh văn hóa truyền thống -->
                                <img src="http://files.auditnews.vn/2023/03/02/van-hoa.png" alt="Culture" class="category-icon">
                                <h5>Văn Hóa</h5>
                                <p>Trải nghiệm văn hóa & lễ hội địa phương</p>
                            </div>
                        </div>

                        <div class="col-md-3 col-6 mb-4 stagger-item">
                            <div class="category-item" data-category="Adventure">
                                <!-- Hình ảnh phiêu lưu -->
                                <img src="https://img.thuthuatphanmem.vn/uploads/2018/10/26/nhung-anh-dep-ve-viet-nam_055420259.jpg" alt="Adventure" class="category-icon">
                                <h5>Phiêu Lưu</h5>
                                <p>Khám phá thiên nhiên & hoạt động thể thao</p>
                            </div>
                        </div>

                        <div class="col-md-3 col-6 mb-4 stagger-item">
                            <div class="category-item" data-category="History">
                                <!-- Hình ảnh lịch sử -->
                                <img src="https://images.unsplash.com/photo-1568849676085-51415703900f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400&q=80" alt="History" class="category-icon">
                                <h5>Lịch Sử</h5>
                                <p>Tham quan di tích lịch sử & địa điểm văn hóa</p>
                            </div>
                        </div>
                    </c:if>




                </div>
            </div>
        </section>

        <!-- Regions Section -->
        <section id="regions" class="py-5 bg-light">
            <div class="container">
                <h2 class="text-center mb-5 fade-up">Khám Phá Theo Vùng Miền</h2>

                <div class="row fade-up">
                    <c:forEach var="region" items="${regions}">
                        <div class="col-md-4 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/regions/${region.imageUrl}" alt="${region.vietnameseName}">
                                    <div class="card-badge">${region.vietnameseName}</div>
                                </div>
                                <div class="card-content">
                                    <h5>${region.vietnameseName}</h5>
                                    <p>${region.description}</p>
                                    <div class="info-row">
                                        <span><i class="ri-sun-line"></i> ${region.climate}</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-map-pin-line"></i> 
                                            <c:forEach var="city" items="${region.cities}" varStatus="status">
                                                ${city.vietnameseName}<c:if test="${!status.last}">, </c:if>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <div class="card-footer">
                                        <div>${region.experienceCount}+ trải nghiệm</div>
                                        <a href="#" class="btn btn-sm btn-outline-primary" onclick="filterByRegion('${region.name}')">Khám phá</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Default regions if none from database -->
                    <c:if test="${empty regions}">
                        <div class="col-md-4 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-image">
                                    <!-- Hình ảnh Miền Bắc: Vịnh Hạ Long -->
                                    <img src="https://images.unsplash.com/photo-1528127269322-539801943592?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Miền Bắc">
                                    <div class="card-badge">Miền Bắc</div>
                                </div>
                                <div class="card-content">
                                    <h5>Miền Bắc</h5>
                                    <p>Khám phá ruộng bậc thang, cố đô Hà Nội và vịnh Hạ Long - Di sản thiên nhiên thế giới.</p>
                                    <div class="info-row">
                                        <span><i class="ri-sun-line"></i> Khí hậu cận nhiệt đới</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-map-pin-line"></i> Hà Nội, Sapa, Hạ Long, Ninh Bình, Hải Phòng</span>
                                    </div>
                                    <div class="card-footer">
                                        <div>20+ trải nghiệm</div>
                                        <a href="#" class="btn btn-sm btn-outline-primary" onclick="filterByRegion('North')">Khám phá</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-image">
                                    <!-- Hình ảnh Miền Trung: Hội An -->
                                    <img src="https://drt.danang.vn/content/images/2024/07/diem-check-in-hoi-an-1.jpg" alt="Miền Trung">
                                    <div class="card-badge">Miền Trung</div>
                                </div>
                                <div class="card-content">
                                    <h5>Miền Trung</h5>
                                    <p>Trải nghiệm vẻ đẹp cổ kính của Huế, Hội An và bãi biển tuyệt đẹp tại Đà Nẵng, Nha Trang.</p>
                                    <div class="info-row">
                                        <span><i class="ri-sun-line"></i> Nóng, khô vào mùa hè</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-map-pin-line"></i> Đà Nẵng, Huế, Hội An, Nha Trang, Quy Nhơn</span>
                                    </div>
                                    <div class="card-footer">
                                        <div>25+ trải nghiệm</div>
                                        <a href="#" class="btn btn-sm btn-outline-primary" onclick="filterByRegion('Central')">Khám phá</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-image">
                                    <!-- Hình ảnh Miền Nam: Đồng bằng sông Cửu Long -->
                                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Miền Nam">
                                    <div class="card-badge">Miền Nam</div>
                                </div>
                                <div class="card-content">
                                    <h5>Miền Nam</h5>
                                    <p>Khám phá cuộc sống sôi động tại TP.HCM, miệt vườn ĐBSCL, thiên đường biển Phú Quốc và Đà Lạt.</p>
                                    <div class="info-row">
                                        <span><i class="ri-sun-line"></i> Nhiệt đới, nóng ẩm quanh năm</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-map-pin-line"></i> TP.HCM, Cần Thơ, Phú Quốc, Đà Lạt, Vũng Tàu, Bến Tre</span>
                                    </div>
                                    <div class="card-footer">
                                        <div>30+ trải nghiệm</div>
                                        <a href="#" class="btn btn-sm btn-outline-primary" onclick="filterByRegion('South')">Khám phá</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>

        <!-- Main Content Tabs -->

        <!-- Testimonials Section -->
        <section class="py-5 bg-light">
            <div class="container">
                <h2 class="text-center mb-5 fade-up">Đánh Giá Từ Khách Hàng</h2>

                <div class="row fade-up">
                    <c:forEach var="review" items="${reviews}" varStatus="status">
                        <c:if test="${status.index < 2}">
                            <div class="col-md-6 mb-4 stagger-item">
                                <div class="card-item h-100">
                                    <div class="card-content">
                                        <div class="d-flex align-items-center mb-3">
                                            <c:choose>
                                                <c:when test="${not empty review.traveler.avatar}">
                                                    <img src="${pageContext.request.contextPath}/assets/images/avatars/${review.traveler.avatar}" alt="Traveler" class="rounded-circle me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://cdn.pixabay.com/photo/2020/09/18/05/58/lights-5580916_1280.jpg" alt="Traveler" class="rounded-circle me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <h5 class="mb-0">${review.traveler.fullName}</h5>
                                                <small class="text-muted">Khách hàng</small>
                                            </div>
                                        </div>
                                        <p class="fst-italic">"${review.comment}"</p>
                                        <div class="mt-3">
                                            <c:choose>
                                                <c:when test="${not empty review.experience}">
                                                    <span class="badge bg-primary">${review.experience.title}</span>
                                                    <span class="badge bg-dark">Trải Nghiệm</span>
                                                </c:when>
                                                <c:when test="${not empty review.accommodation}">
                                                    <span class="badge bg-primary">${review.accommodation.name}</span>
                                                    <span class="badge bg-dark">Lưu Trú</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="rating mt-3">
                                            <c:forEach begin="1" end="${review.rating}">
                                                <i class="ri-star-fill text-warning"></i>
                                            </c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5">
                                                <i class="ri-star-line text-warning"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <!-- Default testimonials if none from database -->
                    <c:if test="${empty reviews}">
                        <div class="col-md-6 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-content">
                                    <div class="d-flex align-items-center mb-3">
                                        <img src="https://cdn.pixabay.com/photo/2020/09/18/05/58/lights-5580916_1280.jpg" alt="Traveler" class="rounded-circle me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                        <div>
                                            <h5 class="mb-0">Nguyễn A</h5>
                                            <small class="text-muted">Hà Nội</small>
                                        </div>
                                    </div>
                                    <p class="fst-italic">"Trải nghiệm tuyệt vời, hướng dẫn viên thân thiện! Tour đạp xe quanh Hà Nội cho tôi cơ hội nhìn thành phố từ góc nhìn hoàn toàn mới."</p>
                                    <div class="mt-3">
                                        <span class="badge bg-primary">Tour đạp xe quanh Hà Nội</span>
                                        <span class="badge bg-dark">Trải Nghiệm</span>
                                    </div>
                                    <div class="rating mt-3">
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4 stagger-item">
                            <div class="card-item h-100">
                                <div class="card-content">
                                    <div class="d-flex align-items-center mb-3">
                                        <img src="https://cdn.pixabay.com/photo/2018/04/27/03/50/portrait-3353699_1280.jpg" alt="Traveler" class="rounded-circle me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                        <div>
                                            <h5 class="mb-0">Lê B</h5>
                                            <small class="text-muted">TP. Hồ Chí Minh</small>
                                        </div>
                                    </div>
                                    <p class="fst-italic">"Không gian rất thoải mái, sẽ quay lại! Homestay Hoa Mai có vị trí thuận lợi, chủ nhà nhiệt tình và không gian rất sạch sẽ, ấm cúng."</p>
                                    <div class="mt-3">
                                        <span class="badge bg-primary">Homestay Hoa Mai</span>
                                        <span class="badge bg-dark">Lưu Trú</span>
                                    </div>
                                    <div class="rating mt-3">
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-fill text-warning"></i>
                                        <i class="ri-star-half-fill text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>

        <!-- Become a Host Section -->
        <section class="py-5" id="become-host">
            <div class="container">
                <div class="row align-items-center fade-up">
                    <div class="col-md-6 mb-4 mb-md-0">
                        <img src="https://cdn.pixabay.com/photo/2018/03/13/22/53/puzzle-3223941_1280.jpg" alt="Become a Host" class="img-fluid rounded-3 shadow-lg">
                    </div>
                    <div class="col-md-6">
                        <h2>Trở Thành Host Cùng Chúng Tôi</h2>
                        <p class="lead">Chia sẻ trải nghiệm độc đáo của bạn hoặc cho thuê nơi ở và kiếm thêm thu nhập.</p>
                        <p>Nền tảng của chúng tôi kết nối bạn với du khách trên khắp thế giới, mang đến cơ hội giới thiệu văn hóa Việt Nam và kiếm thêm thu nhập.</p>
                        <div class="d-flex flex-column flex-sm-row gap-3 mt-4">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="${pageContext.request.contextPath}/host/experiences/create" class="btn btn-primary">
                                        <i class="ri-compass-3-line me-2"></i>Chia sẻ Trải Nghiệm
                                    </a>
                                    <a href="${pageContext.request.contextPath}/host/accommodations/create" class="btn btn-outline-primary">
                                        <i class="ri-home-line me-2"></i>Cho Thuê Nơi Ở
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login?redirect=host" class="btn btn-primary">
                                        <i class="ri-compass-3-line me-2"></i>Chia sẻ Trải Nghiệm
                                    </a>
                                    <a href="${pageContext.request.contextPath}/login?redirect=host" class="btn btn-outline-primary">
                                        <i class="ri-home-line me-2"></i>Cho Thuê Nơi Ở
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <h5>Về Chúng Tôi</h5>
                        <p>Kết nối du khách với những trải nghiệm văn hóa độc đáo và nơi lưu trú ấm cúng trên khắp Việt Nam. Chúng tôi mang đến những giá trị bền vững và góp phần phát triển du lịch cộng đồng.</p>
                        <div class="social-icons">
                            <a href="#"><i class="ri-facebook-fill"></i></a>
                            <a href="#"><i class="ri-instagram-fill"></i></a>
                            <a href="#"><i class="ri-twitter-fill"></i></a>
                            <a href="#"><i class="ri-youtube-fill"></i></a>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <h5>Liên Kết Nhanh</h5>
                        <ul class="list-unstyled">
                            <li><a href="#home"><i class="ri-arrow-right-s-line"></i> Trang Chủ</a></li>
                            <li><a href="#experiences"><i class="ri-arrow-right-s-line"></i> Trải Nghiệm</a></li>
                            <li><a href="#accommodations"><i class="ri-arrow-right-s-line"></i> Lưu Trú</a></li>
                            <li><a href="#regions"><i class="ri-arrow-right-s-line"></i> Vùng Miền</a></li>
                            <li><a href="#become-host"><i class="ri-arrow-right-s-line"></i> Trở Thành Host</a></li>
                        </ul>
                    </div>
                    <div class="col-md-2 mb-4">
                        <h5>Hỗ Trợ</h5>
                        <ul class="list-unstyled">
                            <li><a href="#"><i class="ri-question-line"></i> Trung tâm hỗ trợ</a></li>
                            <li><a href="#"><i class="ri-money-dollar-circle-line"></i> Chính sách giá</a></li>
                            <li><a href="#"><i class="ri-file-list-line"></i> Điều khoản</a></li>
                            <li><a href="#"><i class="ri-shield-check-line"></i> Bảo mật</a></li>
                        </ul>
                    </div>
                    <div class="col-md-3 mb-4">
                        <h5>Liên Hệ</h5>
                        <p><i class="ri-map-pin-line me-2"></i> Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam </p>
                        <p><i class="ri-mail-line me-2"></i> f5@vietculture.vn</p>
                        <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                        <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                    </div>
                </div>
                <div class="copyright">
                    <p>© 2025 VietCulture.</p>
                </div>
            </div>
        </footer>

        <!-- Toast Notification Container -->
        <div class="toast-container"></div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            // Dropdown menu
                            const menuIcon = document.querySelector('.menu-icon');
                            const dropdownMenu = document.querySelector('.dropdown-menu-custom');

                            if (menuIcon && dropdownMenu) {
                                // Toggle dropdown on click
                                menuIcon.addEventListener('click', function (e) {
                                    e.stopPropagation();
                                    dropdownMenu.classList.toggle('show');
                                });

                                // Close dropdown when clicking outside
                                document.addEventListener('click', function () {
                                    dropdownMenu.classList.remove('show');
                                });

                                // Prevent dropdown from closing when clicking inside
                                dropdownMenu.addEventListener('click', function (e) {
                                    e.stopPropagation();
                                });
                            }

                            // Navbar scroll effect
                            window.addEventListener('scroll', function () {
                                const navbar = document.querySelector('.custom-navbar');
                                if (window.scrollY > 50) {
                                    navbar.classList.add('scrolled');
                                } else {
                                    navbar.classList.remove('scrolled');
                                }

                                // Animate elements when they come into view
                                animateOnScroll();
                            });

                            // Animate elements when they come into view
                            function animateOnScroll() {
                                const fadeElements = document.querySelectorAll('.fade-up');

                                fadeElements.forEach(element => {
                                    const elementTop = element.getBoundingClientRect().top;
                                    const elementVisible = 150;

                                    if (elementTop < window.innerHeight - elementVisible) {
                                        element.classList.add('active');

                                        // Stagger child elements if any
                                        const staggerItems = element.querySelectorAll('.stagger-item');
                                        staggerItems.forEach((item, index) => {
                                            setTimeout(() => {
                                                item.style.opacity = 1;
                                                item.style.transform = 'translateY(0)';
                                            }, 150 * index);
                                        });
                                    }
                                });
                            }

                            // Cities data from backend - will be populated by controller
                            const citiesData = {};
            <c:forEach var="region" items="${regions}">
                            citiesData['${region.regionId}'] = [
                <c:forEach var="city" items="${region.cities}" varStatus="status">
                            {id: '${city.cityId}', name: '${city.name}', vietnameseName: '${city.vietnameseName}'}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                            ];
            </c:forEach>

                            // Handle region selection for experiences
                            const regionSelect = document.getElementById('regionSelect');
                            if (regionSelect) {
                                regionSelect.addEventListener('change', function () {
                                    const citySelect = document.getElementById('citySelect');
                                    const selectedRegionId = this.value;

                                    // Clear previous options
                                    citySelect.innerHTML = '<option value="">Chọn Thành Phố</option>';

                                    // If valid region is selected
                                    if (citiesData[selectedRegionId]) {
                                        citySelect.disabled = false;
                                        citiesData[selectedRegionId].forEach(city => {
                                            const option = document.createElement('option');
                                            option.value = city.id;
                                            option.textContent = city.vietnameseName;
                                            citySelect.appendChild(option);
                                        });
                                    } else {
                                        citySelect.disabled = true;
                                    }
                                });
                            }

                            // Handle region selection for accommodations
                            const accommodationRegionSelect = document.getElementById('accommodationRegionSelect');
                            if (accommodationRegionSelect) {
                                accommodationRegionSelect.addEventListener('change', function () {
                                    const citySelect = document.getElementById('accommodationCitySelect');
                                    const selectedRegionId = this.value;

                                    // Clear previous options
                                    citySelect.innerHTML = '<option value="">Chọn Thành Phố</option>';

                                    // If valid region is selected
                                    if (citiesData[selectedRegionId]) {
                                        citySelect.disabled = false;
                                        citiesData[selectedRegionId].forEach(city => {
                                            const option = document.createElement('option');
                                            option.value = city.id;
                                            option.textContent = city.vietnameseName;
                                            citySelect.appendChild(option);
                                        });
                                    } else {
                                        citySelect.disabled = true;
                                    }
                                });
                            }

                            // Increase guests function for experiences
                            function increaseGuests() {
                                const guestInput = document.getElementById('guests');
                                let currentGuests = parseInt(guestInput.value);
                                if (currentGuests < 10) {
                                    guestInput.value = currentGuests + 1;
                                }
                            }

                            // Decrease guests function for experiences
                            function decreaseGuests() {
                                const guestInput = document.getElementById('guests');
                                let currentGuests = parseInt(guestInput.value);
                                if (currentGuests > 1) {
                                    guestInput.value = currentGuests - 1;
                                }
                            }

                            // Increase guests function for accommodations
                            function increaseAccommodationGuests() {
                                const guestInput = document.getElementById('accommodationGuests');
                                let currentGuests = parseInt(guestInput.value);
                                if (currentGuests < 10) {
                                    guestInput.value = currentGuests + 1;
                                }
                            }

                            // Decrease guests function for accommodations
                            function decreaseAccommodationGuests() {
                                const guestInput = document.getElementById('accommodationGuests');
                                let currentGuests = parseInt(guestInput.value);
                                if (currentGuests > 1) {
                                    guestInput.value = currentGuests - 1;
                                }
                            }

                            // Filter by region function (used in Regions section)
                            function filterByRegion(regionName) {
                                let regionId = '';
                                // Nếu có biến regions từ backend
                                <c:if test="${not empty regions}">
                                    <c:forEach var="region" items="${regions}">
                                        if ('${region.name}' === regionName) {
                                            regionId = '${region.regionId}';
                                        }
                                    </c:forEach>
                                </c:if>
                                // Nếu không có regions (dùng mặc định)
                                if (!regionId) {
                                    if (regionName === 'North') regionId = '1';
                                    else if (regionName === 'Central') regionId = '2';
                                    else if (regionName === 'South') regionId = '3';
                                }
                                if (regionId) {
                                    window.location.href = '${pageContext.request.contextPath}/experiences?region=' + regionId;
                                }
                            }

                            // Copy experience function
                            function copyExperience(experienceName) {
                                navigator.clipboard.writeText(experienceName)
                                        .then(() => {
                                            showToast(`Đã sao chép "${experienceName}"`, 'success');
                                        })
                                        .catch(err => {
                                            showToast('Không thể sao chép: ' + err, 'error');
                                        });
                            }

                            // Copy accommodation function
                            function copyAccommodation(accommodationName) {
                                navigator.clipboard.writeText(accommodationName)
                                        .then(() => {
                                            showToast(`Đã sao chép "${accommodationName}"`, 'success');
                                        })
                                        .catch(err => {
                                            showToast('Không thể sao chép: ' + err, 'error');
                                        });
                            }

                            // Show toast notification
                            function showToast(message, type = 'success') {
                                const toastContainer = document.querySelector('.toast-container');

                                const toast = document.createElement('div');
                                toast.className = 'toast';

                                let icon = '<i class="ri-check-line"></i>';
                                if (type === 'error') {
                                    icon = '<i class="ri-error-warning-line" style="color: #FF385C;"></i>';
                                } else if (type === 'info') {
                                    icon = '<i class="ri-information-line" style="color: #3498db;"></i>';
                                }

                                toast.innerHTML = `${icon}<span>${message}</span>`;

                                toastContainer.appendChild(toast);

                                // Show toast
                                setTimeout(() => {
                                    toast.classList.add('show');
                                }, 10);

                                // Hide toast after 3 seconds
                                setTimeout(() => {
                                    toast.classList.remove('show');
                                    setTimeout(() => {
                                        if (toastContainer.contains(toast)) {
                                            toastContainer.removeChild(toast);
                                        }
                                    }, 500);
                                }, 3000);
                            }

                            // Initialize animations on page load
                            document.addEventListener('DOMContentLoaded', function () {
                                // Add js-enabled class to body to activate JavaScript animations
                                document.body.classList.add('js-enabled');

                                // Force display all cards to ensure they're visible
                                setTimeout(function () {
                                    document.querySelectorAll('.stagger-item').forEach(item => {
                                        item.style.opacity = 1;
                                        item.style.transform = 'translateY(0)';
                                    });
                                }, 500);

                                // Initial animation check
                                animateOnScroll();

                                // Initialize staggered items
                                const staggerItems = document.querySelectorAll('.stagger-item');
                                staggerItems.forEach((item, index) => {
                                    item.style.transitionDelay = `${index * 0.1}s`;
                                });

                                // Smooth scroll for nav links
                                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                                    anchor.addEventListener('click', function (e) {
                                        e.preventDefault();

                                        const targetId = this.getAttribute('href').substring(1);
                                        if (targetId === '')
                                            return;

                                        const targetElement = document.getElementById(targetId);
                                        if (targetElement) {
                                            window.scrollTo({
                                                top: targetElement.offsetTop - 100,
                                                behavior: 'smooth'
                                            });
                                        }
                                    });
                                });

                                // Category filter functionality
                                document.querySelectorAll('.category-item').forEach(category => {
                                    category.addEventListener('click', function (event) {
                                        event.preventDefault(); // Ngăn hành vi mặc định
                                        const categoryValue = this.getAttribute('data-category');
                                        let categoryId = '';
            <c:forEach var="category" items="${categories}">
                                        if ('${category.name}' === categoryValue) {
                                            categoryId = '${category.categoryId}';
                                        }
            </c:forEach>
                                        // Nếu không có categories từ backend (danh mục mặc định)
                                        if (!categoryId) {
                                            if (categoryValue === 'Food') categoryId = '1';
                                            else if (categoryValue === 'Culture') categoryId = '2';
                                            else if (categoryValue === 'Adventure') categoryId = '3';
                                            else if (categoryValue === 'History') categoryId = '4';
                                        }
                                        if (categoryId) {
                                            window.location.href = '${pageContext.request.contextPath}/experiences?category=' + categoryId;
                                        } else {
                                            console.log('Không tìm thấy categoryId cho', categoryValue);
                                        }
                                    });
                                });
                            });
                            
function updateMessageBadge() {
    <c:if test="${not empty sessionScope.user && (sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER')}">
        fetch('${pageContext.request.contextPath}/chat/api/unread-count')
            .then(response => response.json())
            .then(data => {
                const unreadCount = data.unreadCount || 0;
                const chatLink = document.querySelector('.nav-chat-link');
                
                if (chatLink) {
                    // Tìm hoặc tạo badge
                    let badge = chatLink.querySelector('.message-badge');
                    
                    if (unreadCount > 0) {
                        if (!badge) {
                            // Tạo badge mới
                            badge = document.createElement('span');
                            badge.className = 'message-badge';
                            chatLink.appendChild(badge);
                        }
                        
                        // Cập nhật số lượng và hiển thị
                        badge.textContent = unreadCount > 99 ? '99+' : unreadCount;
                        badge.classList.add('show');
                    } else {
                        // Ẩn badge nếu không có tin nhắn
                        if (badge) {
                            badge.classList.remove('show');
                        }
                    }
                }
            })
            .catch(error => {
                console.error('Error getting unread count:', error);
            });
    </c:if>
}

// Cập nhật DOMContentLoaded hiện có
document.addEventListener('DOMContentLoaded', function () {
    // ... các code hiện có ...
    
    // Thêm vào cuối function DOMContentLoaded
    updateMessageBadge();
    
    // Cập nhật badge mỗi 30 giây
    setInterval(updateMessageBadge, 30000);
    
    // Cập nhật badge khi focus vào trang
    window.addEventListener('focus', updateMessageBadge);
    
    // ... phần còn lại của code hiện có ...
});
                            // Add JSTL functions
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        </script>
        
    </body>
</html>
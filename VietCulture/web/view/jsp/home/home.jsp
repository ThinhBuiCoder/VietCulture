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
            background-color: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
            transition: var(--transition);
        }

        .custom-navbar.scrolled {
            padding: 10px 0;
            background-color: rgba(255, 255, 255, 0.98);
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
            color: var(--dark-color);
            text-decoration: none;
        }

        .navbar-brand img {
            height: 40px;
            margin-right: 12px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
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
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--dark-color);
            font-weight: 500;
            padding: 10px;
            position: relative;
            transition: var(--transition);
        }

        .nav-center-item:hover {
            color: var(--primary-color);
        }

        .nav-center-item.active {
            color: var(--primary-color);
        }

        .nav-center-item.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 24px;
            height: 3px;
            background-color: var(--primary-color);
            border-radius: 10px;
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
            text-decoration: none;
            color: var(--dark-color);
            font-weight: 500;
            transition: var(--transition);
            padding: 8px 16px;
            border-radius: 20px;
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
            border: 1px solid #eee;
            padding: 8px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            position: relative;
        }

        .nav-right .menu-icon:hover {
            background: var(--accent-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .dropdown-menu-custom {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: var(--light-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            width: 250px;
            padding: 15px;
            display: none;
            z-index: 1000;
            margin-top: 10px;
            opacity: 0;
            transform: translateY(10px);
            transition: var(--transition);
        }

        .dropdown-menu-custom.show {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        .dropdown-menu-custom a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            text-decoration: none;
            color: var(--dark-color);
            transition: var(--transition);
            border-radius: 10px;
            margin-bottom: 5px;
        }

        .dropdown-menu-custom a:hover {
            background-color: var(--accent-color);
            color: var(--primary-color);
            transform: translateX(3px);
        }

        .dropdown-menu-custom a i {
            margin-right: 12px;
            font-size: 18px;
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

        /* Login/Register Modal */
        .auth-modal .modal-content {
            border-radius: var(--border-radius);
            border: none;
            overflow: hidden;
        }

        .auth-modal .modal-header {
            border-bottom: none;
            padding: 20px 30px 0;
        }

        .auth-modal .modal-body {
            padding: 20px 30px 30px;
        }

        .auth-modal .modal-title {
            font-weight: 700;
        }

        .auth-modal .close {
            background: none;
            border: none;
            font-size: 1.5rem;
            opacity: 0.5;
            transition: var(--transition);
        }

        .auth-modal .close:hover {
            opacity: 1;
        }

        .auth-form .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }

        .auth-form .btn-primary {
            width: 100%;
            margin-top: 10px;
        }

        .auth-form .form-text {
            text-align: center;
            margin-top: 20px;
        }

        .auth-form .form-text a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .social-login {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(0,0,0,0.1);
        }

        .social-login-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            background-color: transparent;
            border: 1px solid rgba(0,0,0,0.1);
            font-weight: 600;
            margin-bottom: 10px;
            transition: var(--transition);
        }

        .social-login-btn:hover {
            background-color: var(--accent-color);
            transform: translateY(-3px);
        }

        .social-login-btn img {
            height: 20px;
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
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="#" class="navbar-brand">
                <img src="https://cdn-icons-png.flaticon.com/512/3022/3022422.png" alt="Logo">
                <span>Trải Nghiệm Cộng Đồng</span>
            </a>

            <div class="nav-center">
                <a href="#home" class="nav-center-item active">
                    <img src="https://www.svgrepo.com/show/532485/home.svg" alt="Trang Chủ">
                </a>
                <a href="#experiences" class="nav-center-item">
                    <img src="https://www.svgrepo.com/show/532544/hot-air-balloon.svg" alt="Trải Nghiệm">
                </a>
                <a href="#accommodations" class="nav-center-item">
                    <img src="https://www.svgrepo.com/show/532516/building-house.svg" alt="Lưu Trú">
                </a>
            </div>

            <div class="nav-right">
                <a href="#become-host">Trở thành host</a>
                <i class="ri-global-line globe-icon"></i>
                <div class="menu-icon">
                    <i class="ri-menu-line"></i>
                    <div class="dropdown-menu-custom">
                        <a href="#help-center"><i class="ri-question-line"></i>Trung tâm Trợ giúp</a>
                        <a href="#contact"><i class="ri-contacts-line"></i>Liên Hệ</a>
                        <a href="#" data-bs-toggle="modal" data-bs-target="#loginModal"><i class="ri-login-circle-line"></i>Đăng Nhập</a>
                        <a href="#" data-bs-toggle="modal" data-bs-target="#registerModal"><i class="ri-user-add-line"></i>Đăng Ký</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
        <div class="container">
            <h1 class="animate__animated animate__fadeInUp">Khám Phá Việt Nam Cùng Người Dân Địa Phương</h1>
            <p class="animate__animated animate__fadeInUp animate__delay-1s">Trải nghiệm du lịch độc đáo, lưu trú thoải mái và kết nối với văn hóa bản địa</p>
            <div class="d-flex justify-content-center gap-3 animate__animated animate__fadeInUp animate__delay-2s">
                <a href="#experiences" class="btn btn-primary">
                    <i class="ri-search-line"></i> Khám Phá Trải Nghiệm
                </a>
                <a href="#accommodations" class="btn btn-outline-primary">
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
                <div class="col-md-3 col-6 mb-4 stagger-item">
                    <div class="category-item" data-category="Food">
                        <img src="https://www.svgrepo.com/show/532491/dinner.svg" alt="Food" class="category-icon">
                        <h5>Ẩm Thực</h5>
                        <p>Khám phá nền ẩm thực địa phương & học nấu ăn</p>
                    </div>
                </div>
                
                <div class="col-md-3 col-6 mb-4 stagger-item">
                    <div class="category-item" data-category="Culture">
                        <img src="https://www.svgrepo.com/show/532517/landmark.svg" alt="Culture" class="category-icon">
                        <h5>Văn Hóa</h5>
                        <p>Trải nghiệm văn hóa & lễ hội địa phương</p>
                    </div>
                </div>
                
                <div class="col-md-3 col-6 mb-4 stagger-item">
                    <div class="category-item" data-category="Adventure">
                        <img src="https://www.svgrepo.com/show/532544/hot-air-balloon.svg" alt="Adventure" class="category-icon">
                        <h5>Phiêu Lưu</h5>
                        <p>Khám phá thiên nhiên & hoạt động thể thao</p>
                    </div>
                </div>
                
                <div class="col-md-3 col-6 mb-4 stagger-item">
                    <div class="category-item" data-category="History">
                        <img src="https://www.svgrepo.com/show/532536/temple-hindu.svg" alt="History" class="category-icon">
                        <h5>Lịch Sử</h5>
                        <p>Tham quan di tích lịch sử & địa điểm văn hóa</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Regions Section -->
    <section id="regions" class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5 fade-up">Khám Phá Theo Vùng Miền</h2>
            
            <div class="row fade-up">
                <!-- North Region -->
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="card-item h-100">
                        <div class="card-image">
                            <img src="https://cdn.pixabay.com/photo/2019/05/30/01/52/rice-terraces-4239042_1280.jpg" alt="Miền Bắc">
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
                
                <!-- Central Region -->
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="card-item h-100">
                        <div class="card-image">
                            <img src="https://cdn.pixabay.com/photo/2018/07/15/13/58/hoi-an-3539629_1280.jpg" alt="Miền Trung">
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
                
                <!-- South Region -->
                <div class="col-md-4 mb-4 stagger-item">
                    <div class="card-item h-100">
                        <div class="card-image">
                            <img src="https://cdn.pixabay.com/photo/2018/07/14/11/32/mekong-delta-3537513_1280.jpg" alt="Miền Nam">
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
            </div>
        </div>
    </section>

    <!-- Main Content Tabs -->
    <section class="py-5" id="main-content">
        <div class="container">
            <div class="tabs-section">
                <ul class="nav nav-tabs" id="contentTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="experiences-tab" data-bs-toggle="tab" data-bs-target="#experiences-tab-pane" type="button" role="tab" aria-controls="experiences-tab-pane" aria-selected="true">
                            <i class="ri-compass-3-line me-2"></i>Trải Nghiệm
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="accommodations-tab" data-bs-toggle="tab" data-bs-target="#accommodations-tab-pane" type="button" role="tab" aria-controls="accommodations-tab-pane" aria-selected="false">
                            <i class="ri-hotel-line me-2"></i>Lưu Trú
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content" id="contentTabsContent">
                    <!-- Experiences Tab -->
                    <div class="tab-pane fade show active" id="experiences-tab-pane" role="tabpanel" aria-labelledby="experiences-tab" tabindex="0">
                        <h2 class="fade-up" id="experiences">Khám Phá Trải Nghiệm</h2>
                        
                        <!-- Search Container for Experiences -->
                        <div class="search-container fade-up">
                            <form class="search-form" id="experience-search">
                                <div class="form-group">
                                    <label for="regionSelect">Miền</label>
                                    <select class="form-control" id="regionSelect" name="region">
                                        <option value="">Chọn Miền</option>
                                        <option value="North">Miền Bắc</option>
                                        <option value="Central">Miền Trung</option>
                                        <option value="South">Miền Nam</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="citySelect">Thành Phố</label>
                                    <select class="form-control" id="citySelect" name="city" disabled>
                                        <option value="">Chọn Thành Phố</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="categorySelect">Danh Mục</label>
                                    <select class="form-control" id="categorySelect" name="category">
                                        <option value="">Tất Cả</option>
                                        <option value="Food">Ẩm Thực</option>
                                        <option value="Culture">Văn Hóa</option>
                                        <option value="Adventure">Phiêu Lưu</option>
                                        <option value="History">Lịch Sử</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="guests">Số Khách</label>
                                    <div class="input-group">
                                        <button type="button" class="btn" onclick="decreaseGuests()">-</button>
                                        <input type="text" class="form-control text-center" id="guests" value="1" readonly>
                                        <button type="button" class="btn" onclick="increaseGuests()">+</button>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="ri-search-line"></i> Tìm Kiếm Trải Nghiệm
                                </button>
                            </form>
                        </div>

                        <!-- Experiences Grid -->
                        <div class="cards-grid" id="experiences-grid">
                            <!-- Card 1 - Tour đạp xe -->
                            <div class="card-item stagger-item experience-card" data-region="North" data-city="Hanoi" data-category="Adventure">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2017/02/01/10/00/vietnam-2029597_1280.jpg" alt="Tour đạp xe quanh Hà Nội">
                                    <div class="card-badge">Adventure</div>
                                    <div class="difficulty-badge">MODERATE</div>
                                </div>
                                <div class="card-content">
                                    <h5>Tour đạp xe quanh Hà Nội</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>Phố cổ Hà Nội, Hà Nội</span>
                                    </div>
                                    <p>Tour đạp xe khám phá phố cổ và hồ Tây. Trải nghiệm nhịp sống Hà Nội từ góc nhìn độc đáo.</p>
                                    
                                    <div class="info-row">
                                        <span><i class="ri-time-line"></i> 3 giờ</span>
                                        <span><i class="ri-user-line"></i> Tối đa 8 người</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-translate-2"></i> Tiếng Việt, Tiếng Anh</span>
                                        <span><i class="ri-bike-line"></i> Xe đạp được cung cấp</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">500.000đ / người</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.8</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2017/08/01/08/29/woman-2563491_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Nguyễn Host</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyExperience('Tour đạp xe quanh Hà Nội')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Card 2 - Tour ẩm thực Đà Nẵng -->
                            <div class="card-item stagger-item experience-card" data-region="Central" data-city="Da Nang" data-category="Food">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2020/01/20/21/44/vietnamese-food-4781349_1280.jpg" alt="Tour ẩm thực Đà Nẵng">
                                    <div class="card-badge">Food</div>
                                    <div class="difficulty-badge">EASY</div>
                                </div>
                                <div class="card-content">
                                    <h5>Tour ẩm thực Đà Nẵng</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>Chợ Cồn, Đà Nẵng</span>
                                    </div>
                                    <p>Khám phá ẩm thực địa phương Đà Nẵng. Thưởng thức các món ngon nổi tiếng tại chợ Cồn và khu phố ẩm thực.</p>
                                    
                                    <div class="info-row">
                                        <span><i class="ri-time-line"></i> 4 giờ</span>
                                        <span><i class="ri-user-line"></i> Tối đa 10 người</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-translate-2"></i> Tiếng Việt, Tiếng Anh</span>
                                        <span><i class="ri-restaurant-line"></i> Bao gồm bữa ăn</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">700.000đ / người</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.7</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Trần Host</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyExperience('Tour ẩm thực Đà Nẵng')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Card 3 - Khám phá văn hóa Sài Gòn -->
                            <div class="card-item stagger-item experience-card" data-region="South" data-city="Ho Chi Minh City" data-category="Culture">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2020/02/02/17/24/travel-4813658_1280.jpg" alt="Khám phá văn hóa Sài Gòn">
                                    <div class="card-badge">Culture</div>
                                    <div class="difficulty-badge">EASY</div>
                                </div>
                                <div class="card-content">
                                    <h5>Khám phá văn hóa Sài Gòn</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>Quận 1, TP.HCM</span>
                                    </div>
                                    <p>Tour tham quan những địa điểm văn hóa biểu tượng của Sài Gòn như Nhà thờ Đức Bà, Bưu điện Trung tâm và Chợ Bến Thành.</p>
                                    
                                    <div class="info-row">
                                        <span><i class="ri-time-line"></i> 5 giờ</span>
                                        <span><i class="ri-user-line"></i> Tối đa 12 người</span>
                                    </div>
                                    <div class="info-row">
                                        <span><i class="ri-translate-2"></i> Tiếng Việt, Tiếng Anh</span>
                                        <span><i class="ri-cup-line"></i> Bao gồm đồ uống</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">550.000đ / người</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.9</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2018/04/27/03/50/portrait-3353699_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Trần Host</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyExperience('Khám phá văn hóa Sài Gòn')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- "Xem thêm" Button for Experiences -->
                        <div class="text-center mt-5 fade-up">
                            <a href="#" class="btn btn-outline-primary" id="load-more-experiences">
                                <i class="ri-arrow-down-line"></i> Xem Thêm Trải Nghiệm
                            </a>
                        </div>
                    </div>
                    
                    <!-- Accommodations Tab -->
                    <div class="tab-pane fade" id="accommodations-tab-pane" role="tabpanel" aria-labelledby="accommodations-tab" tabindex="0">
                        <h2 class="fade-up" id="accommodations">Tìm Nơi Lưu Trú</h2>
                        
                        <!-- Search Container for Accommodations -->
                        <div class="search-container fade-up">
                            <form class="search-form" id="accommodation-search">
                                <div class="form-group">
                                    <label for="accommodationRegionSelect">Miền</label>
                                    <select class="form-control" id="accommodationRegionSelect" name="region">
                                        <option value="">Chọn Miền</option>
                                        <option value="North">Miền Bắc</option>
                                        <option value="Central">Miền Trung</option>
                                        <option value="South">Miền Nam</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="accommodationCitySelect">Thành Phố</label>
                                    <select class="form-control" id="accommodationCitySelect" name="city" disabled>
                                        <option value="">Chọn Thành Phố</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="accommodationType">Loại Hình</label>
                                    <select class="form-control" id="accommodationType" name="type">
                                        <option value="">Tất Cả</option>
                                        <option value="Homestay">Homestay</option>
                                        <option value="Hotel">Khách sạn</option>
                                        <option value="Resort">Resort</option>
                                        <option value="Guesthouse">Nhà nghỉ</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="accommodationGuests">Số Khách</label>
                                    <div class="input-group">
                                        <button type="button" class="btn" onclick="decreaseAccommodationGuests()">-</button>
                                        <input type="text" class="form-control text-center" id="accommodationGuests" value="2" readonly>
                                        <button type="button" class="btn" onclick="increaseAccommodationGuests()">+</button>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="ri-search-line"></i> Tìm Kiếm Nơi Lưu Trú
                                </button>
                            </form>
                        </div>

                        <!-- Accommodations Grid -->
                        <div class="cards-grid" id="accommodations-grid">
                            <!-- Accommodation Card 1 - Homestay -->
                            <div class="card-item stagger-item accommodation-card" data-region="North" data-city="Hanoi" data-type="Homestay">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2016/04/15/11/45/hotel-1330841_1280.jpg" alt="Homestay Hoa Mai">
                                    <div class="card-badge">Homestay</div>
                                </div>
                                <div class="card-content">
                                    <h5>Homestay Hoa Mai</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>456 Đường Láng, Hà Nội</span>
                                    </div>
                                    <p>Không gian ấm cúng, gần hồ Tây với cách bài trí hiện đại pha trộn phong cách truyền thống.</p>
                                    
                                    <div class="rooms-info">
                                        <i class="ri-door-line"></i> 6 phòng
                                    </div>
                                    
                                    <div class="amenities">
                                        <span class="amenity"><i class="ri-wifi-line"></i> Wifi</span>
                                        <span class="amenity"><i class="ri-car-line"></i> Bãi đỗ xe</span>
                                        <span class="amenity"><i class="ri-restaurant-line"></i> Bữa sáng</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">400.000đ / đêm</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.8</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2017/08/01/08/29/woman-2563491_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Nguyễn Host</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyAccommodation('Homestay Hoa Mai')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Accommodation Card 2 - Hotel -->
                            <div class="card-item stagger-item accommodation-card" data-region="Central" data-city="Da Nang" data-type="Hotel">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2016/10/18/09/02/hotel-1749602_1280.jpg" alt="Khách sạn Mặt Trời">
                                    <div class="card-badge">Hotel</div>
                                </div>
                                <div class="card-content">
                                    <h5>Khách sạn Mặt Trời</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>789 Trần Phú, Đà Nẵng</span>
                                    </div>
                                    <p>Khách sạn 3 sao trung tâm Đà Nẵng, gần biển với tầm nhìn tuyệt đẹp hướng ra biển và sông Hàn.</p>
                                    
                                    <div class="rooms-info">
                                        <i class="ri-door-line"></i> 30 phòng
                                    </div>
                                    
                                    <div class="amenities">
                                        <span class="amenity"><i class="ri-water-flash-line"></i> Hồ bơi</span>
                                        <span class="amenity"><i class="ri-wifi-line"></i> Wifi</span>
                                        <span class="amenity"><i class="ri-run-line"></i> Phòng gym</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">1.200.000đ / đêm</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.7</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Trần Host</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyAccommodation('Khách sạn Mặt Trời')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Accommodation Card 3 - Resort -->
                            <div class="card-item stagger-item accommodation-card" data-region="South" data-city="Phu Quoc" data-type="Resort">
                                <div class="card-image">
                                    <img src="https://cdn.pixabay.com/photo/2017/08/09/03/54/bungalow-2613466_1280.jpg" alt="Resort Biển Xanh">
                                    <div class="card-badge">Resort</div>
                                </div>
                                <div class="card-content">
                                    <h5>Resort Biển Xanh</h5>
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>Bãi Dài, Phú Quốc</span>
                                    </div>
                                    <p>Resort cao cấp với bungalow riêng biệt, bãi biển riêng và dịch vụ spa đẳng cấp. Không gian nghỉ dưỡng lý tưởng.</p>
                                    
                                    <div class="rooms-info">
                                        <i class="ri-door-line"></i> 20 bungalow
                                    </div>
                                    
                                    <div class="amenities">
                                        <span class="amenity"><i class="ri-water-flash-line"></i> Hồ bơi</span>
                                        <span class="amenity"><i class="ri-hearts-line"></i> Spa</span>
                                        <span class="amenity"><i class="ri-restaurant-line"></i> Nhà hàng</span>
                                        <span class="amenity"><i class="ri-ship-line"></i> Bãi biển</span>
                                    </div>
                                    
                                    <div class="card-footer">
                                        <div class="price">2.500.000đ / đêm</div>
                                        <div class="rating"><i class="ri-star-fill"></i> 4.9</div>
                                    </div>
                                    
                                    <div class="host-info">
                                        <img src="https://cdn.pixabay.com/photo/2018/04/27/03/50/portrait-3353699_1280.jpg" alt="Host" class="host-avatar">
                                        <span class="host-name">Khách sạn ABC</span>
                                    </div>
                                    
                                    <div class="card-action">
                                        <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                        <button class="btn-copy" onclick="copyAccommodation('Resort Biển Xanh')">
                                            <i class="ri-file-copy-line"></i> Sao chép
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- "Xem thêm" Button for Accommodations -->
                        <div class="text-center mt-5 fade-up">
                            <a href="#" class="btn btn-outline-primary" id="load-more-accommodations">
                                <i class="ri-arrow-down-line"></i> Xem Thêm Nơi Lưu Trú
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Testimonials Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5 fade-up">Đánh Giá Từ Khách Hàng</h2>
            
            <div class="row fade-up">
                <!-- Testimonial for Experience -->
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
                
                <!-- Testimonial for Accommodation -->
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
                        <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#becomeHostModal">
                            <i class="ri-compass-3-line me-2"></i>Chia sẻ Trải Nghiệm
                        </a>
                        <a href="#" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#becomeHostModal">
                            <i class="ri-home-line me-2"></i>Cho Thuê Nơi Ở
                        </a>
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
                    <p><i class="ri-map-pin-line me-2"></i> 123 Đường ABC, Quận XYZ, Hà Nội</p>
                    <p><i class="ri-mail-line me-2"></i> info@trainghiemcongdong.vn</p>
                    <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                    <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                </div>
            </div>
            <div class="copyright">
                <p>© 2025 Trải Nghiệm Cộng Đồng. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Login Modal -->
    <div class="modal fade auth-modal" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Đăng Nhập</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="auth-form" id="loginForm">
                        <div class="mb-3">
                            <label for="loginEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="loginEmail" placeholder="Nhập email của bạn">
                        </div>
                        <div class="mb-3">
                            <label for="loginPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="loginPassword" placeholder="Nhập mật khẩu">
                        </div>
                        <div class="form-check mb-3">
                            <input type="checkbox" class="form-check-input" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                        </div>
                        <button type="submit" class="btn btn-primary">Đăng Nhập</button>
                        <div class="form-text">
                            Chưa có tài khoản? <a href="#" data-bs-toggle="modal" data-bs-target="#registerModal" data-bs-dismiss="modal">Đăng ký ngay</a>
                        </div>
                        
                        <div class="social-login">
                            <p class="text-center mb-3">Hoặc đăng nhập với</p>
                            <button type="button" class="social-login-btn mb-2">
                                <img src="https://cdn.cdnlogo.com/logos/g/35/google-icon.svg" alt="Google">
                                Google
                            </button>
                            <button type="button" class="social-login-btn">
                                <img src="https://cdn.cdnlogo.com/logos/f/84/facebook-icon.svg" alt="Facebook">
                                Facebook
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Register Modal -->
    <div class="modal fade auth-modal" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">Đăng Ký Tài Khoản</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="auth-form" id="registerForm">
                        <div class="mb-3">
                            <label for="registerName" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="registerName" placeholder="Nhập họ và tên">
                        </div>
                        <div class="mb-3">
                            <label for="registerEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="registerEmail" placeholder="Nhập email của bạn">
                        </div>
                        <div class="mb-3">
                            <label for="registerPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="registerPassword" placeholder="Tạo mật khẩu">
                        </div>
                        <div class="mb-3">
                            <label for="registerConfirmPassword" class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" id="registerConfirmPassword" placeholder="Nhập lại mật khẩu">
                        </div>
                        <div class="mb-3">
                            <label for="userType" class="form-label">Đăng ký với tư cách</label>
                            <select class="form-control" id="userType">
                                <option value="TRAVELER">Khách du lịch</option>
                                <option value="HOST">Host (cung cấp dịch vụ)</option>
                            </select>
                        </div>
                        <div class="form-check mb-3">
                            <input type="checkbox" class="form-check-input" id="termsCheck">
                            <label class="form-check-label" for="termsCheck">Tôi đồng ý với <a href="#">Điều khoản sử dụng</a> và <a href="#">Chính sách bảo mật</a></label>
                        </div>
                        <button type="submit" class="btn btn-primary">Đăng Ký</button>
                        <div class="form-text">
                            Đã có tài khoản? <a href="#" data-bs-toggle="modal" data-bs-target="#loginModal" data-bs-dismiss="modal">Đăng nhập</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Become Host Modal -->
    <div class="modal fade auth-modal" id="becomeHostModal" tabindex="-1" aria-labelledby="becomeHostModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="becomeHostModalLabel">Đăng Ký Trở Thành Host</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="auth-form" id="becomeHostForm">
                        <div class="mb-3">
                            <label for="hostName" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="hostName" placeholder="Nhập họ và tên">
                        </div>
                        <div class="mb-3">
                            <label for="hostEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="hostEmail" placeholder="Nhập email của bạn">
                        </div>
                        <div class="mb-3">
                            <label for="hostPhone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="hostPhone" placeholder="Nhập số điện thoại">
                        </div>
                        <div class="mb-3">
                            <label for="businessType" class="form-label">Loại hình kinh doanh</label>
                            <select class="form-control" id="businessType">
                                <option value="">Chọn loại hình</option>
                                <option value="Homestay">Homestay</option>
                                <option value="Travel Agency">Công ty du lịch</option>
                                <option value="Tour Guide">Hướng dẫn viên</option>
                                <option value="Local Experience">Trải nghiệm địa phương</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="hostRegion" class="form-label">Khu vực hoạt động</label>
                            <select class="form-control" id="hostRegion">
                                <option value="">Chọn khu vực</option>
                                <option value="North">Miền Bắc</option>
                                <option value="Central">Miền Trung</option>
                                <option value="South">Miền Nam</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="hostDescription" class="form-label">Mô tả về bạn hoặc dịch vụ của bạn</label>
                            <textarea class="form-control" id="hostDescription" rows="3" placeholder="Giới thiệu ngắn gọn về bạn hoặc dịch vụ bạn muốn cung cấp"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Đăng Ký</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Notification Container -->
    <div class="toast-container"></div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dropdown menu
        const menuIcon = document.querySelector('.menu-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

        // Toggle dropdown on click
        menuIcon.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdownMenu.classList.toggle('show');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            dropdownMenu.classList.remove('show');
        });

        // Prevent dropdown from closing when clicking inside
        dropdownMenu.addEventListener('click', function(e) {
            e.stopPropagation();
        });
        
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
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

        // Cities data based on Regions from database
        const regionsData = {
            'North': ['Hanoi', 'Haiphong', 'Sapa', 'Ha Long', 'Ninh Binh'],
            'Central': ['Da Nang', 'Hue', 'Hoi An', 'Nha Trang', 'Quy Nhon'],
            'South': ['Ho Chi Minh City', 'Vung Tau', 'Can Tho', 'Phu Quoc', 'Da Lat', 'Ben Tre']
        };

        // Vietnamese names mapping
        const cityNamesVI = {
            'Hanoi': 'Hà Nội',
            'Haiphong': 'Hải Phòng',
            'Sapa': 'Sa Pa',
            'Ha Long': 'Hạ Long',
            'Ninh Binh': 'Ninh Bình',
            'Da Nang': 'Đà Nẵng',
            'Hue': 'Huế',
            'Hoi An': 'Hội An',
            'Nha Trang': 'Nha Trang',
            'Quy Nhon': 'Quy Nhơn',
            'Ho Chi Minh City': 'TP.HCM',
            'Vung Tau': 'Vũng Tàu',
            'Can Tho': 'Cần Thơ',
            'Phu Quoc': 'Phú Quốc',
            'Da Lat': 'Đà Lạt',
            'Ben Tre': 'Bến Tre'
        };

        // Handle region selection for experiences
        document.getElementById('regionSelect').addEventListener('change', function() {
            const citySelect = document.getElementById('citySelect');
            const selectedRegion = this.value;

            // Clear previous options
            citySelect.innerHTML = '<option selected value="">Chọn Thành Phố</option>';

            // If valid region is selected
            if (regionsData[selectedRegion]) {
                citySelect.disabled = false;
                regionsData[selectedRegion].forEach(city => {
                    const option = document.createElement('option');
                    option.value = city;
                    option.textContent = cityNamesVI[city] || city; // Use Vietnamese name if available
                    citySelect.appendChild(option);
                });
            } else {
                citySelect.disabled = true;
            }
        });

        // Handle region selection for accommodations
        document.getElementById('accommodationRegionSelect').addEventListener('change', function() {
            const citySelect = document.getElementById('accommodationCitySelect');
            const selectedRegion = this.value;

            // Clear previous options
            citySelect.innerHTML = '<option selected value="">Chọn Thành Phố</option>';

            // If valid region is selected
            if (regionsData[selectedRegion]) {
                citySelect.disabled = false;
                regionsData[selectedRegion].forEach(city => {
                    const option = document.createElement('option');
                    option.value = city;
                    option.textContent = cityNamesVI[city] || city; // Use Vietnamese name if available
                    citySelect.appendChild(option);
                });
            } else {
                citySelect.disabled = true;
            }
        });

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

        // Handle experience search form submission
        document.getElementById('experience-search').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values
            const region = document.getElementById('regionSelect').value;
            const city = document.getElementById('citySelect').value;
            const category = document.getElementById('categorySelect').value;
            const guests = document.getElementById('guests').value;

            // Validate inputs
            if (region === '') {
                showToast('Vui lòng chọn miền', 'error');
                return;
            }
            
            if (city === '') {
                showToast('Vui lòng chọn thành phố', 'error');
                return;
            }

            // Show search information
            showToast(`Đang tìm kiếm trải nghiệm tại ${cityNamesVI[city] || city}`, 'success');
            
            // Filter experiences
            filterExperiences(region, city, category, guests);
        });

        // Handle accommodation search form submission
        document.getElementById('accommodation-search').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values
            const region = document.getElementById('accommodationRegionSelect').value;
            const city = document.getElementById('accommodationCitySelect').value;
            const type = document.getElementById('accommodationType').value;
            const guests = document.getElementById('accommodationGuests').value;

            // Validate inputs
            if (region === '') {
                showToast('Vui lòng chọn miền', 'error');
                return;
            }
            
            if (city === '') {
                showToast('Vui lòng chọn thành phố', 'error');
                return;
            }

            // Show search information
            showToast(`Đang tìm kiếm nơi lưu trú tại ${cityNamesVI[city] || city}`, 'success');
            
            // Filter accommodations
            filterAccommodations(region, city, type, guests);
        });

        // Filter experiences function
        function filterExperiences(region, city, category, guests) {
            const experienceCards = document.querySelectorAll('.experience-card');
            let visibleCount = 0;
            
            experienceCards.forEach(card => {
                const cardRegion = card.getAttribute('data-region');
                const cardCity = card.getAttribute('data-city');
                const cardCategory = card.getAttribute('data-category');
                
                // Check if card matches filters
                const regionMatch = !region || cardRegion === region;
                const cityMatch = !city || cardCity === city;
                const categoryMatch = !category || cardCategory === category;
                
                // Show or hide card
                if (regionMatch && cityMatch && categoryMatch) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Show message if no results
            if (visibleCount === 0) {
                showToast('Không tìm thấy trải nghiệm phù hợp', 'error');
            } else {
                showToast(`Tìm thấy ${visibleCount} trải nghiệm phù hợp`, 'success');
            }
        }

        // Filter accommodations function
        function filterAccommodations(region, city, type, guests) {
            const accommodationCards = document.querySelectorAll('.accommodation-card');
            let visibleCount = 0;
            
            accommodationCards.forEach(card => {
                const cardRegion = card.getAttribute('data-region');
                const cardCity = card.getAttribute('data-city');
                const cardType = card.getAttribute('data-type');
                
                // Check if card matches filters
                const regionMatch = !region || cardRegion === region;
                const cityMatch = !city || cardCity === city;
                const typeMatch = !type || cardType === type;
                
                // Show or hide card
                if (regionMatch && cityMatch && typeMatch) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Show message if no results
            if (visibleCount === 0) {
                showToast('Không tìm thấy nơi lưu trú phù hợp', 'error');
            } else {
                showToast(`Tìm thấy ${visibleCount} nơi lưu trú phù hợp`, 'success');
            }
        }

        // Filter by region function (used in Regions section)
        function filterByRegion(region) {
            // Set region in the experiences form
            document.getElementById('regionSelect').value = region;
            
            // Trigger change event to update city options
            document.getElementById('regionSelect').dispatchEvent(new Event('change'));
            
            // Scroll to experiences section and switch to experiences tab
            document.getElementById('experiences-tab').click();
            document.getElementById('experiences').scrollIntoView({ behavior: 'smooth' });
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
                    toastContainer.removeChild(toast);
                }, 500);
            }, 3000);
        }

        // Form submission handlers
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            
            if (!email || !password) {
                showToast('Vui lòng điền đầy đủ thông tin', 'error');
                return;
            }
            
            // Simulate login API call
            setTimeout(() => {
                showToast('Đăng nhập thành công', 'success');
                $('#loginModal').modal('hide');
            }, 1000);
        });

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const name = document.getElementById('registerName').value;
            const email = document.getElementById('registerEmail').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('registerConfirmPassword').value;
            const termsCheck = document.getElementById('termsCheck').checked;
            
            if (!name || !email || !password || !confirmPassword) {
                showToast('Vui lòng điền đầy đủ thông tin', 'error');
                return;
            }
            
            if (password !== confirmPassword) {
                showToast('Mật khẩu không khớp', 'error');
                return;
            }
            
            if (!termsCheck) {
                showToast('Vui lòng đồng ý với điều khoản sử dụng', 'error');
                return;
            }
            
            // Simulate register API call
            setTimeout(() => {
                showToast('Đăng ký thành công', 'success');
                $('#registerModal').modal('hide');
            }, 1000);
        });

        document.getElementById('becomeHostForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const name = document.getElementById('hostName').value;
            const email = document.getElementById('hostEmail').value;
            const phone = document.getElementById('hostPhone').value;
            const businessType = document.getElementById('businessType').value;
            const region = document.getElementById('hostRegion').value;
            
            if (!name || !email || !phone || !businessType || !region) {
                showToast('Vui lòng điền đầy đủ thông tin', 'error');
                return;
            }
            
            // Simulate become host API call
            setTimeout(() => {
                showToast('Đăng ký trở thành host thành công! Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất.', 'success');
                $('#becomeHostModal').modal('hide');
            }, 1000);
        });

        // Initialize animations on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Add js-enabled class to body to activate JavaScript animations
            document.body.classList.add('js-enabled');
            
            // Force display all cards to ensure they're visible
            setTimeout(function() {
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
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const targetId = this.getAttribute('href').substring(1);
                    if (targetId === '') return;
                    
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
                category.addEventListener('click', function() {
                    const categoryValue = this.getAttribute('data-category');
                    const categorySelect = document.getElementById('categorySelect');
                    
                    // Set category in the form
                    for (let i = 0; i < categorySelect.options.length; i++) {
                        if (categorySelect.options[i].value === categoryValue) {
                            categorySelect.selectedIndex = i;
                            break;
                        }
                    }
                    
                    // Switch to experiences tab and scroll there
                    document.getElementById('experiences-tab').click();
                    document.getElementById('experiences').scrollIntoView({ behavior: 'smooth' });
                });
            });
            
            // Load more experiences button
            document.getElementById('load-more-experiences').addEventListener('click', function(e) {
                e.preventDefault();
                showToast('Đang tải thêm trải nghiệm...', 'info');
                
                // Simulate loading more experiences (would be replaced with actual API call)
                setTimeout(() => {
                    showToast('Đã tải thêm trải nghiệm mới', 'success');

                    // Demo: Add new experience card
                    const experiencesGrid = document.getElementById('experiences-grid');
                    const newExperience = document.createElement('div');
                    newExperience.className = 'card-item stagger-item experience-card';
                    newExperience.setAttribute('data-region', 'North');
                    newExperience.setAttribute('data-city', 'Ha Long');
                    newExperience.setAttribute('data-category', 'History');
                    
                    newExperience.innerHTML = `
                        <div class="card-image">
                            <img src="https://cdn.pixabay.com/photo/2016/01/09/19/13/sea-1130626_1280.jpg" alt="Tour Vịnh Hạ Long">
                            <div class="card-badge">History</div>
                            <div class="difficulty-badge">EASY</div>
                        </div>
                        <div class="card-content">
                            <h5>Khám Phá Vịnh Hạ Long</h5>
                            <div class="location">
                                <i class="ri-map-pin-line"></i>
                                <span>Vịnh Hạ Long, Hạ Long</span>
                            </div>
                            <p>Tour thuyền khám phá Vịnh Hạ Long, di sản thiên nhiên thế giới. Tham quan các hang động và đảo đá vôi tuyệt đẹp.</p>
                            
                            <div class="info-row">
                                <span><i class="ri-time-line"></i> 8 giờ</span>
                                <span><i class="ri-user-line"></i> Tối đa 15 người</span>
                            </div>
                            <div class="info-row">
                                <span><i class="ri-translate-2"></i> Tiếng Việt, Tiếng Anh</span>
                                <span><i class="ri-restaurant-line"></i> Bao gồm bữa trưa</span>
                            </div>
                            
                            <div class="card-footer">
                                <div class="price">950.000đ / người</div>
                                <div class="rating"><i class="ri-star-fill"></i> 4.9</div>
                            </div>
                            
                            <div class="host-info">
                                <img src="https://cdn.pixabay.com/photo/2017/08/01/08/29/woman-2563491_1280.jpg" alt="Host" class="host-avatar">
                                <span class="host-name">Nguyễn Host</span>
                            </div>
                            
                            <div class="card-action">
                                <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                <button class="btn-copy" onclick="copyExperience('Khám Phá Vịnh Hạ Long')">
                                    <i class="ri-file-copy-line"></i> Sao chép
                                </button>
                            </div>
                        </div>
                    `;
                    
                    experiencesGrid.appendChild(newExperience);
                    
                    // Apply animation
                    setTimeout(() => {
                        newExperience.style.opacity = 1;
                        newExperience.style.transform = 'translateY(0)';
                    }, 100);
                    
                }, 1500);
            });
            
            // Load more accommodations button
            document.getElementById('load-more-accommodations').addEventListener('click', function(e) {
                e.preventDefault();
                showToast('Đang tải thêm nơi lưu trú...', 'info');
                
                // Simulate loading more accommodations (would be replaced with actual API call)
                setTimeout(() => {
                    showToast('Đã tải thêm nơi lưu trú mới', 'success');
                    
                    // Demo: Add new accommodation card
                    const accommodationsGrid = document.getElementById('accommodations-grid');
                    const newAccommodation = document.createElement('div');
                    newAccommodation.className = 'card-item stagger-item accommodation-card';
                    newAccommodation.setAttribute('data-region', 'South');
                    newAccommodation.setAttribute('data-city', 'Da Lat');
                    newAccommodation.setAttribute('data-type', 'Guesthouse');
                    
                    newAccommodation.innerHTML = `
                        <div class="card-image">
                            <img src="https://cdn.pixabay.com/photo/2016/10/22/17/06/farmhouse-1761364_1280.jpg" alt="Nhà nghỉ Đà Lạt">
                            <div class="card-badge">Guesthouse</div>
                        </div>
                        <div class="card-content">
                            <h5>Nhà nghỉ Thung Lũng Xanh</h5>
                            <div class="location">
                                <i class="ri-map-pin-line"></i>
                                <span>Đường Trần Hưng Đạo, Đà Lạt</span>
                            </div>
                            <p>Nhà nghỉ phong cách châu Âu giữa rừng thông Đà Lạt. Không gian yên tĩnh, lãng mạn và gần gũi với thiên nhiên.</p>
                            
                            <div class="rooms-info">
                                <i class="ri-door-line"></i> 10 phòng
                            </div>
                            
                            <div class="amenities">
                                <span class="amenity"><i class="ri-wifi-line"></i> Wifi</span>
                                <span class="amenity"><i class="ri-parking-box-line"></i> Bãi đỗ xe</span>
                                <span class="amenity"><i class="ri-restaurant-line"></i> Bữa sáng</span>
                                <span class="amenity"><i class="ri-fireplace-line"></i> Lò sưởi</span>
                            </div>
                            
                            <div class="card-footer">
                                <div class="price">600.000đ / đêm</div>
                                <div class="rating"><i class="ri-star-fill"></i> 4.6</div>
                            </div>
                            
                            <div class="host-info">
                                <img src="https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg" alt="Host" class="host-avatar">
                                <span class="host-name">Trần Host</span>
                            </div>
                            
                            <div class="card-action">
                                <a href="#" class="btn btn-outline-primary">Chi Tiết</a>
                                <button class="btn-copy" onclick="copyAccommodation('Nhà nghỉ Thung Lũng Xanh')">
                                    <i class="ri-file-copy-line"></i> Sao chép
                                </button>
                            </div>
                        </div>
                    `;
                    
                    accommodationsGrid.appendChild(newAccommodation);
                    
                    // Apply animation
                    setTimeout(() => {
                        newAccommodation.style.opacity = 1;
                        newAccommodation.style.transform = 'translateY(0)';
                    }, 100);
                    
                }, 1500);
            });
        });
    </script>
</body>
</html>
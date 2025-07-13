<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trải Nghiệm Du Lịch | VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/improved-styles.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/assets/css/enhanced-components.css" />
    <style>
        /* Heart/Favorite Button Styles */
        .favorite-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 10;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            backdrop-filter: blur(10px);
        }

        .favorite-btn:hover {
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .favorite-btn:disabled {
            cursor: not-allowed;
            opacity: 0.6;
        }

        .favorite-btn i {
            font-size: 1.2rem;
            color: #6c757d;
            transition: all 0.3s ease;
        }

        .favorite-btn.active i {
            color: #FF385C;
            animation: heartBeat 0.6s ease-in-out;
        }

        .favorite-btn.adding i {
            animation: heartPulse 0.4s ease-in-out;
        }

        @keyframes heartBeat {
            0% { transform: scale(1); }
            25% { transform: scale(1.3); }
            50% { transform: scale(1.1); }
            75% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        @keyframes heartPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        /* Navigation Chat Link */
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

        /* Toast Container */
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

        /* Image Placeholder Styles */
        .no-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            color: #6c757d;
            font-size: 0.9rem;
        }

        .no-image-placeholder i {
            font-size: 3rem;
            margin-bottom: 10px;
            opacity: 0.5;
        }

        .image-error {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            font-size: 0.85rem;
        }

        .image-error i {
            font-size: 2.5rem;
            margin-bottom: 8px;
        }

        /* Distance Filter Component Styles */
        .distance-filter-container {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-top: 5px;
        }

        .distance-filter-header {
            margin-bottom: 15px;
        }

        .distance-filter-header .form-check-label {
            font-weight: 500;
            color: #495057;
            cursor: pointer;
        }

        .distance-filter-controls {
            transition: all 0.3s ease;
        }

        .distance-slider-container {
            margin-bottom: 15px;
        }

        .distance-slider-wrapper {
            position: relative;
            margin-top: 10px;
        }

        .distance-slider {
            width: 100%;
            height: 6px;
            background: #e9ecef;
            border-radius: 3px;
            outline: none;
            transition: background 0.3s ease;
        }

        .distance-slider::-webkit-slider-thumb {
            appearance: none;
            width: 20px;
            height: 20px;
            background: var(--primary-color);
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .distance-slider::-webkit-slider-thumb:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }

        .distance-slider::-moz-range-thumb {
            width: 20px;
            height: 20px;
            background: var(--primary-color);
            border-radius: 50%;
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .slider-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 0.85rem;
            color: #6c757d;
        }

        .location-status {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .location-status i {
            font-size: 1.1rem;
        }

        .location-status i.spin {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Copy Button */
        .btn-copy {
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

        .btn-copy:hover {
            color: var(--dark-color);
            background-color: rgba(0,0,0,0.05);
        }

        .btn-copy i {
            font-size: 1rem;
        }

        /* Root Variables */
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
            background-color: #10466C;
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
            transition: var(--transition);
        }

        .custom-navbar.scrolled {
            padding: 10px 0;
            background-color: #10466C;
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
            color: white;
            text-decoration: none;
        }

        .navbar-brand img {
            height: 50px !important;
            width: auto !important;
            margin-right: 12px !important;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
            object-fit: contain !important;
            display: inline-block !important;
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
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-center-item:hover {
            color: white;
        }

        .nav-center-item.active {
            color: var(--primary-color);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }

        .nav-right a:hover {
            color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.08);
        }

        .dropdown-menu-custom {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 250px;
            padding: 15px;
            display: none;
            z-index: 1000;
            margin-top: 10px;
            opacity: 0;
            transform: translateY(10px);
            transition: var(--transition);
            border: 1px solid rgba(0,0,0,0.1);
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
            color: #10466C;
            transition: var(--transition);
            border-radius: 10px;
            margin-bottom: 5px;
        }

        .dropdown-menu-custom a:hover {
            background-color: rgba(16, 70, 108, 0.05);
            color: #10466C;
            transform: translateX(3px);
        }

        .dropdown-menu-custom a i {
            margin-right: 12px;
            font-size: 18px;
            color: #10466C;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(rgba(0,109,119,0.8), rgba(131,197,190,0.8)), 
                        url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80') no-repeat center/cover;
            color: var(--light-color);
            padding: 100px 0;
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
            font-size: 3.5rem;
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

        /* Search Container */
        .search-container {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            padding: 30px;
            max-width: 1000px;
            margin: -80px auto 50px;
            border: 1px solid rgba(255,255,255,0.2);
            transition: var(--transition);
            position: relative;
            z-index: 10;
        }

        .search-container:hover {
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }

        .search-form {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            align-items: start;
        }

        .search-row-main {
            display: grid;
            grid-template-columns: 2fr auto;
            gap: 15px;
            align-items: end;
        }

        .search-row-filters {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            align-items: end;
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

        .search-form .btn-primary {
            background: var(--gradient-primary);
            border: none;
            padding: 15px 25px;
            font-weight: 600;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: var(--transition);
            height: fit-content;
            white-space: nowrap;
        }

        .search-form .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 56, 92, 0.25);
        }

        /* Keyword search container styles */
        .keyword-search-main {
            width: 100%;
        }

        .keyword-search-container {
            position: relative;
            display: flex;
            align-items: center;
            border: 2px solid #ddd;
            border-radius: 12px;
            padding: 12px 16px;
            background-color: white;
            transition: all 0.3s ease;
            min-height: 50px;
        }

        .keyword-search-container:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
        }

        .keyword-input {
            flex-grow: 1;
            border: none;
            outline: none;
            padding: 0 10px;
            font-size: 1.1rem;
            background-color: transparent;
            font-weight: 500;
        }

        .keyword-input::placeholder {
            color: #999;
            font-weight: 400;
        }

        /* Popular keywords styling */
        .popular-keywords {
            margin-top: 15px;
            padding: 12px 16px;
            background-color: #f8f9fa;
            border-radius: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            border: 1px solid #e0e0e0;
        }

        .keyword-label {
            font-weight: 600;
            color: #555;
            margin-right: 10px;
            font-size: 0.9rem;
        }

        .keyword-tag {
            background-color: #e9ecef;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #495057;
            cursor: pointer;
            transition: all 0.2s ease;
            border: 1px solid transparent;
        }

        .keyword-tag:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-1px);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .search-row-main {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .search-row-filters {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .keyword-input {
                font-size: 1rem;
            }
        }

        /* Filters Section */
        .filters-section {
            padding: 30px 0;
            background-color: var(--light-color);
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .filter-item {
            background-color: var(--accent-color);
            border-radius: 25px;
            padding: 8px 20px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            color: var(--dark-color);
            display: inline-block;
            margin: 5px;
        }

        .filter-item:hover {
            border-color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.1);
            color: var(--primary-color);
            text-decoration: none;
        }

        .filter-item.active {
            background: var(--gradient-primary);
            color: white;
            border-color: var(--primary-color);
        }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        /* Experience Card */
        .card-item {
            background-color: var(--light-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            position: relative;
            height: auto;
            min-height: 450px;
            display: flex;
            flex-direction: column;
        }

        .card-item:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
        }

        .card-image {
            height: 250px;
            position: relative;
            overflow: hidden;
        }

        .card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .card-item:hover .card-image img {
            transform: scale(1.1);
        }

        .card-badge {
            position: absolute;
            top: 15px;
            left: 15px;
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
            bottom: 15px;
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
            padding: 25px;
            text-align: left;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
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

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 50px;
        }

        .pagination .page-link {
            border-radius: 8px;
            margin: 0 5px;
            border: 1px solid rgba(0,0,0,0.1);
            color: var(--dark-color);
            transition: var(--transition);
        }

        .pagination .page-link:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Footer */
        .footer {
            background-color: var(--dark-color);
            color: var(--light-color);
            padding: 80px 0 40px;
            position: relative;
            margin-top: 80px;
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

        /* No results */
        .no-results {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }

        .no-results i {
            font-size: 4rem;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }

        .fade-up {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease-out;
        }

        .fade-up.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .search-form {
                grid-template-columns: repeat(2, 1fr);
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
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .cards-grid {
                grid-template-columns: 1fr;
            }
            
            .hero-section h1 {
                font-size: 2.5rem;
            }
            
            .custom-navbar {
                padding: 10px 0;
            }
        }

        /* New styles for keyword search */
        .keyword-search-container {
            position: relative;
            display: flex;
            align-items: center;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 8px 12px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        .keyword-search-container:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
        }

        .keyword-input {
            flex-grow: 1;
            border: none;
            outline: none;
            padding: 0 5px;
            font-size: 0.9rem;
            background-color: transparent;
        }

        .keyword-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            max-height: 200px;
            overflow-y: auto;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            z-index: 100;
            display: none;
        }

        .keyword-suggestions.show {
            display: block;
        }

        .keyword-suggestions div {
            padding: 10px 12px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .keyword-suggestions div:hover {
            background-color: #f0f0f0;
        }

        .keyword-search-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            color: #6c757d;
            transition: color 0.3s ease;
        }

        .keyword-search-btn:hover {
            color: var(--primary-color);
        }

        .popular-keywords {
            margin-top: 15px;
            padding: 10px 15px;
            background-color: #f0f0f0;
            border-radius: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            border: 1px solid #ccc;
        }

        .keyword-label {
            font-weight: 600;
            color: #555;
            margin-right: 10px;
        }

        .keyword-tag {
            background-color: #e0e0e0;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            color: #333;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .keyword-tag:hover {
            background-color: #d0d0d0;
        }

        /* Distance filter styles */
        .distance-filter-container {
            position: relative;
        }

        .distance-status {
            font-size: 0.75rem;
            margin-top: 4px;
            padding: 4px 8px;
            border-radius: 4px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .distance-status.detecting {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .distance-status.enabled {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .distance-status.disabled {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .location-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            padding: 4px;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .location-btn:hover {
            color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.1);
        }

        .location-btn.active {
            color: var(--primary-color);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        /* Update responsive design */
        @media (max-width: 768px) {
            .search-row-main {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .search-row-filters {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .keyword-input {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>

            <div class="nav-center">
                <a href="/Travel" class="nav-center-item">Trang Chủ</a>
                <a href="/Travel/experiences" class="nav-center-item">Trải Nghiệm</a>
                <a href="/Travel/accommodations" class="nav-center-item">Lưu Trú</a>
            </div>

            <div class="nav-right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER'}">
                            <a href="${pageContext.request.contextPath}/chat" class="nav-chat-link me-3">
                                <i class="ri-message-3-line" style="font-size: 1.2rem; color: rgba(255,255,255,0.7);"></i>
                            </a>
                        </c:if>
                        
                        <div class="dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                                <i class="ri-user-line" style="color: white;"></i> 
                                ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu">
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
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/favorites" style="color: #10466C; font-weight: 600;">
                                            <i class="ri-heart-line"></i> Yêu Thích
                                        </a>
                                    </li>
                                </c:if>
                                
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
    <section class="hero-section">
        <div class="container">
            <h1 class="animate__animated animate__fadeInUp">Khám Phá Trải Nghiệm Độc Đáo</h1>
            <p class="animate__animated animate__fadeInUp animate__delay-1s">Tham gia những hoạt động thú vị cùng người dân địa phương và khám phá văn hóa Việt Nam</p>
        </div>
    </section>

    <!-- Search Container -->
    <div class="container">
        <div class="search-container">
            <form class="search-form" method="GET" action="${pageContext.request.contextPath}/experiences">
                <!-- Main Search Row: Keyword + Search Button -->
                <div class="search-row-main">
                    <div class="form-group keyword-search-main">
                        <label for="keywordSearch">Từ Khóa Tìm Kiếm</label>
                        <div class="keyword-search-container">
                            <input type="text" 
                                   class="keyword-input" 
                                   name="search" 
                                   id="keywordSearch"
                                   value="${param.search}"
                                   placeholder="Nhập từ khóa để tìm trải nghiệm tương tự..."
                                   autocomplete="off">
                            <div class="keyword-suggestions" id="keywordSuggestions"></div>
                            <button type="button" class="keyword-search-btn" onclick="showPopularKeywords()">
                                <i class="ri-search-2-line"></i>
                            </button>
                        </div>
                        <div class="popular-keywords" id="popularKeywords" style="display: none;">
                            <span class="keyword-label">Từ khóa phổ biến:</span>
                            <span class="keyword-tag" onclick="selectKeyword('ẩm thực')">ẩm thực</span>
                            <span class="keyword-tag" onclick="selectKeyword('văn hóa')">văn hóa</span>
                            <span class="keyword-tag" onclick="selectKeyword('phiêu lưu')">phiêu lưu</span>
                            <span class="keyword-tag" onclick="selectKeyword('thiên nhiên')">thiên nhiên</span>
                            <span class="keyword-tag" onclick="selectKeyword('làng nghề')">làng nghề</span>
                            <span class="keyword-tag" onclick="selectKeyword('festival')">festival</span>
                            <span class="keyword-tag" onclick="selectKeyword('biển')">biển</span>
                            <span class="keyword-tag" onclick="selectKeyword('núi')">núi</span>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="ri-search-line"></i> Tìm Kiếm
                    </button>
                </div>

                <!-- Filters Row: Category + Region + City + Distance -->
                <div class="search-row-filters">
                    <div class="form-group">
                        <label for="categorySelect">Danh Mục</label>
                        <select class="form-control" name="category" id="categorySelect">
                            <option value="">Tất Cả Danh Mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" ${param.category == category.categoryId ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${category.name == 'Food'}">Ẩm Thực</c:when>
                                        <c:when test="${category.name == 'Culture'}">Văn Hóa</c:when>
                                        <c:when test="${category.name == 'Adventure'}">Phiêu Lưu</c:when>
                                        <c:when test="${category.name == 'History'}">Lịch Sử</c:when>
                                        <c:otherwise>${category.name}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="regionSelect">Vùng Miền</label>
                        <select class="form-control" name="region" id="regionSelect">
                            <option value="">Chọn Vùng Miền</option>
                            <c:forEach var="region" items="${regions}">
                                <option value="${region.regionId}" ${param.region == region.regionId ? 'selected' : ''}>
                                    ${region.vietnameseName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="citySelect">Thành Phố</label>
                        <select class="form-control" name="city" id="citySelect" ${empty param.region ? 'disabled' : ''}>
                            <option value="">Chọn Thành Phố</option>
                            <c:if test="${not empty param.region}">
                                <c:forEach var="region" items="${regions}">
                                    <c:if test="${region.regionId == param.region}">
                                        <c:forEach var="city" items="${region.cities}">
                                            <option value="${city.cityId}" ${param.city == city.cityId ? 'selected' : ''}>
                                                ${city.vietnameseName}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Khoảng Cách</label>
                        <div id="distanceFilterContainer">
                            <!-- Fallback simple distance filter -->
                            <div class="simple-distance-filter">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox" id="locationToggle">
                                    <label class="form-check-label" for="locationToggle">
                                        <i class="ri-map-pin-line me-2"></i>Lọc theo khoảng cách
                                    </label>
                        </div>
                                <div id="distanceControls" class="d-none">
                                    <label class="form-label">
                                        Khoảng cách: <span id="distanceValue">20</span>km
                                    </label>
                                    <input type="range" class="form-range" id="distanceSlider" 
                                           min="1" max="100" value="20" step="1">
                                    <div class="d-flex justify-content-between small text-muted">
                                        <span>1km</span>
                                        <span>100km</span>
                                    </div>
                                    <div id="locationStatus" class="mt-2 small text-muted">
                                        <i class="ri-information-line"></i> Bấm để bật định vị
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Filters Section -->
    <section class="filters-section">
        <div class="container">
            <div class="d-flex flex-wrap justify-content-center">
                <a href="${pageContext.request.contextPath}/experiences" class="filter-item ${empty param.filter ? 'active' : ''}">
                    <i class="ri-apps-line me-2"></i>Tất Cả
                </a>
                <a href="${pageContext.request.contextPath}/experiences?filter=popular" class="filter-item ${param.filter == 'popular' ? 'active' : ''}">
                    <i class="ri-fire-line me-2"></i>Phổ Biến
                </a>
                <a href="${pageContext.request.contextPath}/experiences?filter=newest" class="filter-item ${param.filter == 'newest' ? 'active' : ''}">
                    <i class="ri-time-line me-2"></i>Mới Nhất
                </a>
                <a href="${pageContext.request.contextPath}/experiences?filter=top-rated" class="filter-item ${param.filter == 'top-rated' ? 'active' : ''}">
                    <i class="ri-star-line me-2"></i>Đánh Giá Cao
                </a>
                <a href="${pageContext.request.contextPath}/experiences?filter=low-price" class="filter-item ${param.filter == 'low-price' ? 'active' : ''}">
                    <i class="ri-money-dollar-circle-line me-2"></i>Giá Tốt
                </a>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container">
        <!-- Results Count -->
        <div class="results-header fade-up">
            <h3 id="resultsTitle">
                <c:choose>
                    <c:when test="${not empty experiences}">
                        <i class="ri-compass-discover-line me-2" style="color: var(--primary-500);"></i>
                        <c:choose>
                            <c:when test="${not empty totalExperiences}">
                                ${totalExperiences} trải nghiệm được tìm thấy
                            </c:when>
                            <c:otherwise>
                        ${fn:length(experiences)} trải nghiệm được tìm thấy
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <i class="ri-map-pin-2-line me-2" style="color: var(--secondary-500);"></i>
                        Khám phá trải nghiệm
                    </c:otherwise>
                </c:choose>
            </h3>
            
            <div class="d-flex align-items-center gap-3">
                <select class="form-select" style="min-width: 180px;" onchange="sortExperiences(this.value)">
                    <option value="">Sắp xếp theo</option>
                    <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
                    <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
                    <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>⭐ Đánh giá cao nhất</option>
                    <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>🆕 Mới nhất</option>
                </select>
            </div>
        </div>

        <!-- Experiences Grid -->
        <div id="experiencesContainer">
            <c:choose>
                <c:when test="${not empty experiences}">
                    <div class="cards-grid fade-up">
                        <c:forEach var="experience" items="${experiences}">
                            <div class="card-item">
                                <div class="card-image">
                                    <!-- Favorite Button -->
                                    <c:if test="${not empty sessionScope.user}">
                                        <button class="favorite-btn" 
                                                data-experience-id="${experience.experienceId}" 
                                                data-type="experience"
                                                onclick="toggleFavorite(this)">
                                            <i class="ri-heart-line"></i>
                                        </button>
                                    </c:if>
                                    
                                    <c:choose>
                                        <c:when test="${not empty experience.firstImage}">
                                            <img src="${pageContext.request.contextPath}/images/experiences/${experience.firstImage}" 
                                                 alt="${fn:escapeXml(experience.title)}"
                                                 onerror="handleImageError(this);">
                                        </c:when>
                                        <c:when test="${not empty experience.images}">
                                            <c:set var="imageList" value="${fn:split(experience.images, ',')}" />
                                            <c:if test="${fn:length(imageList) > 0}">
                                                <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(imageList[0])}" 
                                                     alt="${fn:escapeXml(experience.title)}"
                                                     onerror="handleImageError(this);">
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-image-placeholder">
                                                <i class="ri-image-line"></i>
                                                <span>Không có ảnh</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div class="card-badge">
                                        <c:choose>
                                            <c:when test="${experience.type == 'Food'}">Ẩm Thực</c:when>
                                            <c:when test="${experience.type == 'Culture'}">Văn Hóa</c:when>
                                            <c:when test="${experience.type == 'Adventure'}">Phiêu Lưu</c:when>
                                            <c:when test="${experience.type == 'History'}">Lịch Sử</c:when>
                                            <c:otherwise>${experience.type}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <c:if test="${not empty experience.difficulty}">
                                        <div class="difficulty-badge">
                                            <c:choose>
                                                <c:when test="${experience.difficulty == 'EASY'}">Dễ</c:when>
                                                <c:when test="${experience.difficulty == 'MODERATE'}">Vừa</c:when>
                                                <c:when test="${experience.difficulty == 'CHALLENGING'}">Khó</c:when>
                                                <c:otherwise>${experience.difficulty}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="card-content">
                                    <h5>${experience.title}</h5>
                                    
                                    <div class="location">
                                        <i class="ri-map-pin-line"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty experience.cityName}">
                                                    ${experience.cityName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${experience.location}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <p>
                                        <c:choose>
                                            <c:when test="${fn:length(experience.description) > 100}">
                                                ${fn:substring(experience.description, 0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${experience.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <div class="info-row">
                                        <span><i class="ri-time-line"></i> 
                                            <c:choose>
                                                <c:when test="${not empty experience.duration}">
                                                    <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    Cả ngày
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span><i class="ri-group-line"></i> Tối đa ${experience.maxGroupSize} người</span>
                                    </div>
                                    
                                    <c:if test="${not empty experience.includedItems}">
                                        <div class="info-row">
                                            <span><i class="ri-check-line"></i> 
                                                <c:set var="itemList" value="${fn:split(experience.includedItems, ',')}" />
                                                <c:choose>
                                                    <c:when test="${fn:length(itemList) > 2}">
                                                        ${fn:trim(itemList[0])}, ${fn:trim(itemList[1])}...
                                                    </c:when>
                                                    <c:when test="${fn:length(itemList) == 2}">
                                                        ${fn:trim(itemList[0])}, ${fn:trim(itemList[1])}
                                                    </c:when>
                                                    <c:when test="${fn:length(itemList) == 1}">
                                                        ${fn:trim(itemList[0])}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${fn:length(experience.includedItems) > 50}">
                                                                ${fn:substring(experience.includedItems, 0, 50)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${experience.includedItems}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </c:if>
                                    
                                    <div class="card-footer">
                                        <div class="price">
                                            <c:choose>
                                                <c:when test="${experience.price == 0}">
                                                    Miễn phí
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ <small>/người</small>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <c:if test="${experience.averageRating > 0}">
                                            <div class="rating">
                                                <i class="ri-star-fill"></i>
                                                <span><fmt:formatNumber value="${experience.averageRating}" maxFractionDigits="1" /></span>
                                                <small>(${experience.totalBookings} đánh giá)</small>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <c:if test="${not empty experience.hostName}">
                                        <div class="host-info">
                                            <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" alt="Host" class="host-avatar">
                                            <div>
                                                <div class="host-name">Host: ${experience.hostName}</div>
                                                <small class="text-muted">Trải nghiệm địa phương</small>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="card-action">
                                        <a href="${pageContext.request.contextPath}/experiences/${experience.experienceId}" class="btn btn-outline-primary">
                                            <i class="ri-eye-line me-2"></i>Xem Chi Tiết
                                        </a>
                                        <button class="btn-copy" onclick="copyExperience('${fn:escapeXml(experience.title)}')">
                                            <i class="ri-share-line"></i>
                                            <span>Chia sẻ</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- No results message -->
                    <div class="no-results">
                        <i class="ri-search-line"></i>
                        <h4>Không tìm thấy trải nghiệm nào</h4>
                        <p>Hãy thử tìm kiếm với từ khóa khác hoặc bỏ bớt bộ lọc</p>
                        <a href="${pageContext.request.contextPath}/experiences" class="btn btn-primary">
                            <i class="ri-refresh-line me-2"></i>Xem Tất Cả Trải Nghiệm
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${not empty experiences and totalPages > 1}">
            <nav class="pagination-container">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&${queryString}">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <li class="page-item ${page == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${page}&${queryString}">${page}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&${queryString}">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

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
                        <li><a href="${pageContext.request.contextPath}/"><i class="ri-arrow-right-s-line"></i> Trang Chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/experiences"><i class="ri-arrow-right-s-line"></i> Trải Nghiệm</a></li>
                        <li><a href="${pageContext.request.contextPath}/accommodations"><i class="ri-arrow-right-s-line"></i> Lưu Trú</a></li>
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
                    <p><i class="ri-mail-line me-2"></i> info@vietculture.vn</p>
                    <p><i class="ri-phone-line me-2"></i> 0123 456 789</p>
                    <p><i class="ri-customer-service-2-line me-2"></i> 1900 1234</p>
                </div>
            </div>
            <div class="copyright">
                <p>© 2025 VietCulture. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Toast Notification Container -->
    <div class="toast-container"></div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Initialize distance filter component
        let distanceFilter;
        let allExperiences = [];
        let totalExperiencesCount = 0;
        let originalResultsTitle = '';
        
        document.addEventListener('DOMContentLoaded', function() {
            // Save original total count and title
            const resultsTitle = document.getElementById('resultsTitle');
            if (resultsTitle) {
                originalResultsTitle = resultsTitle.innerHTML;
                // Extract total count from title text
                const titleText = resultsTitle.textContent;
                const match = titleText.match(/(\d+)\s+trải nghiệm/);
                if (match) {
                    totalExperiencesCount = parseInt(match[1]);
                }
            }
            // Collect all experiences data for client-side filtering
            <c:if test="${not empty experiences}">
                allExperiences = [
                    <c:forEach var="experience" items="${experiences}" varStatus="status">
                        {
                            id: ${experience.experienceId},
                            title: "${fn:escapeXml(experience.title)}",
                            location: "${fn:escapeXml(experience.location)}",
                            cityName: "${fn:escapeXml(experience.cityName)}",
                            price: ${experience.price},
                            rating: ${experience.averageRating},
                            totalBookings: ${experience.totalBookings},
                            firstImage: "${not empty experience.firstImage ? experience.firstImage : ''}",
                            images: "${not empty experience.images ? experience.images : ''}",
                            type: "${experience.type}",
                            difficulty: "${experience.difficulty}",
                            element: null // Will be set later
                        }<c:if test="${not status.last}">,</c:if>
                    </c:forEach>
                ];
            </c:if>
            
            // Initialize simple distance filter
            initializeSimpleDistanceFilter();
            
            // Store references to DOM elements for each experience
            const experienceCards = document.querySelectorAll('.card-item');
            experienceCards.forEach((card, index) => {
                if (allExperiences[index]) {
                    allExperiences[index].element = card;
                }
            });
        });
        
        // Filter experiences by distance
        async function filterExperiencesByDistance(maxDistance) {
            if (!distanceFilter || !distanceFilter.isLocationEnabled) {
                showAllExperiences();
                return;
            }
            
            try {
                const filteredExperiences = await distanceFilter.filterItems(allExperiences, 'location');
                
                // Hide all experiences first
                hideAllExperiences();
                
                // Show filtered experiences
                let visibleCount = 0;
                filteredExperiences.forEach(exp => {
                    if (exp.element) {
                        exp.element.style.display = 'block';
                        
                        // Add distance badge
                        const distanceBadge = exp.element.querySelector('.distance-badge');
                        if (distanceBadge) {
                            distanceBadge.remove();
                        }
                        
                        if (exp.distance !== undefined) {
                            const badge = document.createElement('div');
                            badge.className = 'distance-badge';
                                                         badge.innerHTML = '<i class="ri-map-pin-line"></i> ' + formatDistance(exp.distance);
                            exp.element.querySelector('.card-image').appendChild(badge);
                        }
                        
                        visibleCount++;
                    }
                });
                
                // Update results count
                updateResultsCount(visibleCount, 'trải nghiệm trong bán kính ' + maxDistance + 'km');
                
            } catch (error) {
                console.error('Error filtering experiences:', error);
                showAllExperiences();
            }
        }
        
        // Show all experiences
        function showAllExperiences() {
            const experienceCards = document.querySelectorAll('.card-item');
            experienceCards.forEach(card => {
                card.style.display = 'block';
                
                // Remove distance badges
                const distanceBadge = card.querySelector('.distance-badge');
                if (distanceBadge) {
                    distanceBadge.remove();
                }
            });
            
            updateResultsCount(allExperiences.length, 'trải nghiệm được tìm thấy');
        }
        
        // Hide all experiences
        function hideAllExperiences() {
            const experienceCards = document.querySelectorAll('.card-item');
            experienceCards.forEach(card => {
                card.style.display = 'none';
            });
        }
        
                     // Update results count
             function updateResultsCount(visibleCount, suffix) {
                 const resultsHeader = document.querySelector('#resultsTitle');
                 if (resultsHeader) {
                     if (suffix.includes('trong bán kính')) {
                         // When filtering by distance, show filtered count and total
                         resultsHeader.innerHTML = '<i class="ri-compass-discover-line me-2" style="color: var(--primary-500);"></i>' + 
                             visibleCount + '/' + totalExperiencesCount + ' ' + suffix;
                     } else {
                         // When showing all, show original title or total count
                         if (originalResultsTitle) {
                             resultsHeader.innerHTML = originalResultsTitle;
                         } else {
                             resultsHeader.innerHTML = '<i class="ri-compass-discover-line me-2" style="color: var(--primary-500);"></i>' + 
                                 totalExperiencesCount + ' trải nghiệm được tìm thấy';
                         }
                     }
                 }
             }
        
        // Format distance
        function formatDistance(distance) {
            if (distance < 1) {
                return Math.round(distance * 1000) + 'm';
            }
            return distance.toFixed(1) + 'km';
        }
        
        // Simple distance filter initialization
        function initializeSimpleDistanceFilter() {
            const locationToggle = document.getElementById('locationToggle');
            const distanceControls = document.getElementById('distanceControls');
            const distanceSlider = document.getElementById('distanceSlider');
            const distanceValue = document.getElementById('distanceValue');
            const locationStatus = document.getElementById('locationStatus');
            
            if (!locationToggle || !distanceControls || !distanceSlider || !distanceValue) {
                console.log('Distance filter elements not found');
                return;
            }
            
            let userLocation = null;
            let isLocationEnabled = false;
            
            // Location toggle handler
            locationToggle.addEventListener('change', function() {
                if (this.checked) {
                    distanceControls.classList.remove('d-none');
                    requestUserLocation();
                } else {
                    distanceControls.classList.add('d-none');
                    isLocationEnabled = false;
                    showAllExperiences();
                }
            });
            
            // Distance slider handler
            distanceSlider.addEventListener('input', function() {
                distanceValue.textContent = this.value;
            });
            
            distanceSlider.addEventListener('change', function() {
                if (isLocationEnabled && userLocation) {
                    filterByDistance(parseInt(this.value));
                }
            });
            
            // Request user location
            function requestUserLocation() {
                locationStatus.innerHTML = '<i class="ri-loader-4-line"></i> Đang lấy vị trí...';
                
                if (!navigator.geolocation) {
                    locationStatus.innerHTML = '<i class="ri-error-warning-line text-danger"></i> Trình duyệt không hỗ trợ định vị';
                    locationToggle.checked = false;
                    distanceControls.classList.add('d-none');
                    return;
                }
                
                navigator.geolocation.getCurrentPosition(
                    function(position) {
                        userLocation = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        };
                        isLocationEnabled = true;
                        locationStatus.innerHTML = '<i class="ri-map-pin-line text-success"></i> Đã lấy vị trí thành công';
                        
                        // Start filtering with current distance
                        filterByDistance(parseInt(distanceSlider.value));
                    },
                    function(error) {
                        let errorMessage = 'Không thể lấy vị trí';
                        if (error.code === 1) errorMessage = 'Bạn đã từ chối truy cập vị trí';
                        
                        locationStatus.innerHTML = '<i class="ri-error-warning-line text-danger"></i> ' + errorMessage;
                        locationToggle.checked = false;
                        distanceControls.classList.add('d-none');
                    }
                );
            }
            
                         // Filter experiences by distance
             async function filterByDistance(maxDistance) {
                 if (!userLocation || !isLocationEnabled) return;
                 
                 const experienceCards = document.querySelectorAll('.card-item');
                 let visibleCount = 0;
                 
                 for (let i = 0; i < experienceCards.length; i++) {
                     const card = experienceCards[i];
                     
                     // Get experience data
                     const experienceData = allExperiences[i];
                     if (!experienceData || !experienceData.location) {
                         card.style.display = 'none';
                         continue;
                     }
                     
                     // Get coordinates for experience location
                     const experienceCoords = await getCoordinatesFromAddress(experienceData.location);
                     
                     if (experienceCoords) {
                         // Calculate real distance
                         const distance = calculateDistance(userLocation, experienceCoords);
                         
                         if (distance <= maxDistance) {
                             card.style.display = 'block';
                             visibleCount++;
                             
                             // Add distance badge with real distance
                             let distanceBadge = card.querySelector('.distance-badge');
                             if (distanceBadge) {
                                 distanceBadge.remove();
                             }
                             
                             const badge = document.createElement('div');
                             badge.className = 'distance-badge';
                             badge.innerHTML = '<i class="ri-map-pin-line"></i> ' + formatDistance(distance);
                             card.querySelector('.card-image').appendChild(badge);
                         } else {
                             card.style.display = 'none';
                         }
                     } else {
                         // If can't geocode, hide the experience
                         card.style.display = 'none';
                     }
                 }
                 
                 updateResultsCount(visibleCount, 'trải nghiệm trong bán kính ' + maxDistance + 'km');
             }
             
             // Calculate distance between two coordinates using Haversine formula
             function calculateDistance(coord1, coord2) {
                 const R = 6371; // Earth's radius in kilometers
                 const dLat = toRadians(coord2.lat - coord1.lat);
                 const dLng = toRadians(coord2.lng - coord1.lng);
                 
                 const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                           Math.cos(toRadians(coord1.lat)) * Math.cos(toRadians(coord2.lat)) *
                           Math.sin(dLng/2) * Math.sin(dLng/2);
                 
                 const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                 return R * c;
             }
             
             // Convert degrees to radians
             function toRadians(degrees) {
                 return degrees * (Math.PI / 180);
             }
             
             // Get coordinates from address using fallback Vietnam cities data
             async function getCoordinatesFromAddress(address) {
                 if (!address || address.trim() === '') {
                     return null;
                 }
                 
                 // Vietnam cities coordinates fallback
                 const vietnamCities = {
                     'hà nội': { lat: 21.0285, lng: 105.8542 },
                     'hanoi': { lat: 21.0285, lng: 105.8542 },
                     'hồ chí minh': { lat: 10.8231, lng: 106.6297 },
                     'ho chi minh': { lat: 10.8231, lng: 106.6297 },
                     'đà nẵng': { lat: 16.0471, lng: 108.2068 },
                     'da nang': { lat: 16.0471, lng: 108.2068 },
                     'hải phòng': { lat: 20.8449, lng: 106.6881 },
                     'hai phong': { lat: 20.8449, lng: 106.6881 },
                     'cần thơ': { lat: 10.0452, lng: 105.7469 },
                     'can tho': { lat: 10.0452, lng: 105.7469 },
                     'nha trang': { lat: 12.2388, lng: 109.1967 },
                     'hội an': { lat: 15.8801, lng: 108.3380 },
                     'hoi an': { lat: 15.8801, lng: 108.3380 },
                     'sapa': { lat: 22.3380, lng: 103.8438 },
                     'sa pa': { lat: 22.3380, lng: 103.8438 },
                     'đà lạt': { lat: 11.9404, lng: 108.4583 },
                     'da lat': { lat: 11.9404, lng: 108.4583 },
                     'phú quốc': { lat: 10.2899, lng: 103.9840 },
                     'phu quoc': { lat: 10.2899, lng: 103.9840 },
                     'vịnh hạ long': { lat: 20.9101, lng: 107.1839 },
                     'ha long': { lat: 20.9101, lng: 107.1839 },
                     'hạ long': { lat: 20.9101, lng: 107.1839 },
                     'ninh bình': { lat: 20.2540, lng: 105.9750 },
                     'ninh binh': { lat: 20.2540, lng: 105.9750 },
                     'quảng bình': { lat: 17.4677, lng: 106.6220 },
                     'quang binh': { lat: 17.4677, lng: 106.6220 },
                     'huế': { lat: 16.4637, lng: 107.5909 },
                     'hue': { lat: 16.4637, lng: 107.5909 },
                     'quy nhơn': { lat: 13.7563, lng: 109.2297 },
                     'quy nhon': { lat: 13.7563, lng: 109.2297 },
                     'vũng tàu': { lat: 10.4109, lng: 107.1361 },
                     'vung tau': { lat: 10.4109, lng: 107.1361 },
                     'bến tre': { lat: 10.2415, lng: 106.3759 },
                     'ben tre': { lat: 10.2415, lng: 106.3759 }
                 };
                 
                 const addressLower = address.toLowerCase().trim();
                 
                 // Check for exact matches first
                 if (vietnamCities[addressLower]) {
                     return vietnamCities[addressLower];
                 }
                 
                 // Check for partial matches
                 for (const [city, coords] of Object.entries(vietnamCities)) {
                     if (addressLower.includes(city) || city.includes(addressLower)) {
                         return coords;
                     }
                 }
                 
                 // Default fallback to Ho Chi Minh City if no match found
                 return { lat: 10.8231, lng: 106.6297 };
             }
        }
    </script>
    
    <style>
        /* Distance badge styling */
        .distance-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
            z-index: 5;
        }
        
        .distance-badge i {
            font-size: 0.8rem;
        }
    </style>
    <script>
        // JSP Variables for JavaScript use
        const JSP_VARS = {
            isLoggedIn: <c:choose><c:when test="${not empty sessionScope.user}">true</c:when><c:otherwise>false</c:otherwise></c:choose>,
            userRole: '<c:out value="${sessionScope.user.role}" default="" />',
            contextPath: '${pageContext.request.contextPath}',
            canChat: <c:choose><c:when test="${not empty sessionScope.user && (sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER')}">true</c:when><c:otherwise>false</c:otherwise></c:choose>
        };

        // Handle image error function
        function handleImageError(img) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'image-error';
            errorDiv.innerHTML = `
                <i class="ri-image-off-line"></i>
                <span>Không tải được ảnh</span>
            `;
            img.parentNode.replaceChild(errorDiv, img);
        }

        // Improved favorite functionality
        function toggleFavorite(button) {
            // Check if user is logged in and is TRAVELER
            const isLoggedIn = JSP_VARS.isLoggedIn;
            const userRole = JSP_VARS.userRole;
            
            if (!isLoggedIn) {
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            if (userRole !== 'TRAVELER') {
                showToast('Chỉ có Traveler mới có thể lưu yêu thích', 'error');
                return;
            }
            
            const experienceId = button.getAttribute('data-experience-id');
            const accommodationId = button.getAttribute('data-accommodation-id');
            const itemType = button.getAttribute('data-type');
            const icon = button.querySelector('i');
            
            // Debug logging
            console.log('Toggle favorite called with:', {
                experienceId: experienceId,
                accommodationId: accommodationId,
                itemType: itemType
            });
            
            // Validate data
            if (!itemType || (itemType !== 'experience' && itemType !== 'accommodation')) {
                showToast('Loại dữ liệu không hợp lệ', 'error');
                return;
            }
            
            if ((itemType === 'experience' && !experienceId) || 
                (itemType === 'accommodation' && !accommodationId)) {
                showToast('Thiếu ID của mục yêu thích', 'error');
                return;
            }
            
            // Prevent multiple clicks
            if (button.disabled) {
                console.log('Button already disabled, ignoring click');
                return;
            }
            
            // Add loading animation and disable button
            button.classList.add('adding');
            button.disabled = true;
            
            // Prepare request data
            const requestData = {
                itemType: itemType
            };
            
            // Add the appropriate ID based on type
            if (itemType === 'experience' && experienceId) {
                requestData.experienceId = parseInt(experienceId);
            } else if (itemType === 'accommodation' && accommodationId) {
                requestData.accommodationId = parseInt(accommodationId);
            }
            
            console.log('Sending request data:', requestData);
            
            // Make AJAX request to toggle favorite
            fetch('${pageContext.request.contextPath}/favorites/toggle', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(requestData)
            })
            .then(response => {
                console.log('Response status:', response.status);
                
                // Always remove loading state
                button.classList.remove('adding');
                button.disabled = false;
                
                if (!response.ok) {
                    if (response.status === 401) {
                        showToast('Vui lòng đăng nhập lại', 'error');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        }, 2000);
                        return;
                    }
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                
                if (data.success) {
                    if (data.isFavorited) {
                        button.classList.add('active');
                        icon.className = 'ri-heart-fill';
                        showToast('Đã thêm vào danh sách yêu thích ❤️', 'success');
                    } else {
                        button.classList.remove('active');
                        icon.className = 'ri-heart-line';
                        showToast('Đã xóa khỏi danh sách yêu thích', 'info');
                    }
                } else {
                    showToast(data.message || 'Có lỗi xảy ra khi xử lý yêu thích', 'error');
                    console.error('Server error:', data);
                }
            })
            .catch(error => {
                // Ensure loading state is removed
                button.classList.remove('adding');
                button.disabled = false;
                
                console.error('Error:', error);
                showToast('Không thể kết nối đến máy chủ. Vui lòng thử lại.', 'error');
            });
        }

        // Load user favorites on page load
        function loadUserFavorites() {
            const isLoggedIn = ${not empty sessionScope.user};
            const userRole = '${sessionScope.user.role}';
            
            if (!isLoggedIn || userRole !== 'TRAVELER') {
                console.log('User not logged in or not TRAVELER, skipping favorites load');
                return;
            }
            
            console.log('Loading user favorites...');
            
            fetch('${pageContext.request.contextPath}/favorites/list', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Favorites loaded:', data);
                
                if (data.success && data.experienceIds) {
                    // Mark experience favorites
                    data.experienceIds.forEach(experienceId => {
                        const button = document.querySelector('button[data-experience-id="' + experienceId + '"][data-type="experience"]');
                        if (button) {
                            button.classList.add('active');
                            const icon = button.querySelector('i');
                            if (icon) {
                                icon.className = 'ri-heart-fill';
                            }
                            console.log('Marked experience as favorite:', experienceId);
                        }
                    });
                }
                
                if (data.success && data.accommodationIds) {
                    // Mark accommodation favorites (if any accommodations on this page)
                    data.accommodationIds.forEach(accommodationId => {
                        const button = document.querySelector(`button[data-accommodation-id="${accommodationId}"][data-type="accommodation"]`);
                        if (button) {
                            button.classList.add('active');
                            const icon = button.querySelector('i');
                            if (icon) {
                                icon.className = 'ri-heart-fill';
                            }
                            console.log('Marked accommodation as favorite:', accommodationId);
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Error loading favorites:', error);
                // Don't show error toast for this as it's not critical
            });
        }

        // Update message badge
        function updateMessageBadge() {
            <c:if test="${not empty sessionScope.user && (sessionScope.user.role == 'HOST' || sessionScope.user.role == 'TRAVELER')}">
                fetch('${pageContext.request.contextPath}/chat/api/unread-count')
                    .then(response => response.json())
                    .then(data => {
                        const unreadCount = data.unreadCount || 0;
                        const chatLink = document.querySelector('.nav-chat-link');
                        
                        if (chatLink) {
                            let badge = chatLink.querySelector('.message-badge');
                            
                            if (unreadCount > 0) {
                                if (!badge) {
                                    badge = document.createElement('span');
                                    badge.className = 'message-badge';
                                    chatLink.appendChild(badge);
                                }
                                badge.textContent = unreadCount > 99 ? '99+' : unreadCount;
                                badge.classList.add('show');
                            } else {
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

        // Dropdown menu functionality
        const menuIcon = document.querySelector('.menu-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

        if (menuIcon && dropdownMenu) {
            menuIcon.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            document.addEventListener('click', function() {
                dropdownMenu.classList.remove('show');
            });

            dropdownMenu.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        }
        
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.custom-navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
            
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
                }
            });
        }

        // Cities data - USE FIXED DATA SINCE BACKEND IS EMPTY
        console.log('Using fixed cities data since backend has empty cities');
        const citiesData = {
            '1': [
                {id: '1', name: 'Hanoi', vietnameseName: 'Hà Nội'},
                {id: '2', name: 'Haiphong', vietnameseName: 'Hải Phòng'},
                {id: '3', name: 'Sapa', vietnameseName: 'Sa Pa'},
                {id: '4', name: 'Ha Long', vietnameseName: 'Hạ Long'},
                {id: '5', name: 'Ninh Binh', vietnameseName: 'Ninh Bình'}
            ],
            '2': [
                {id: '6', name: 'Da Nang', vietnameseName: 'Đà Nẵng'},
                {id: '7', name: 'Hue', vietnameseName: 'Huế'},
                {id: '8', name: 'Hoi An', vietnameseName: 'Hội An'},
                {id: '9', name: 'Nha Trang', vietnameseName: 'Nha Trang'},
                {id: '10', name: 'Quy Nhon', vietnameseName: 'Quy Nhơn'}
            ],
            '3': [
                {id: '11', name: 'Ho Chi Minh City', vietnameseName: 'TP.HCM'},
                {id: '12', name: 'Vung Tau', vietnameseName: 'Vũng Tàu'},
                {id: '13', name: 'Can Tho', vietnameseName: 'Cần Thơ'},
                {id: '14', name: 'Phu Quoc', vietnameseName: 'Phú Quốc'},
                {id: '15', name: 'Da Lat', vietnameseName: 'Đà Lạt'},
                {id: '16', name: 'Ben Tre', vietnameseName: 'Bến Tre'}
            ]
        };

        console.log('Fixed cities data loaded:', citiesData);

        // Function to load cities via AJAX
        function loadCitiesForRegion(regionId) {
            console.log('Loading cities for region:', regionId);
            
            // First try to fetch from backend
            fetch(JSP_VARS.contextPath + '/api/cities/region/' + regionId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('API not available');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Cities loaded from API:', data);
                    if (data && data.length > 0) {
                        citiesData[regionId] = data;
                        updateCitySelect(regionId);
                    } else {
                        // Use fixed data if API returns empty
                        updateCitySelect(regionId);
                    }
                })
                .catch(error => {
                    console.log('API not available, using fixed data:', error.message);
                    // Use fixed data
                    updateCitySelect(regionId);
                });
        }

        // Function to update city select options
        function updateCitySelect(regionId) {
            const citySelect = document.getElementById('citySelect');
            const cities = citiesData[regionId] || [];
            
            console.log('Updating city select for region', regionId, 'with', cities.length, 'cities');
            
            // Clear existing options
            citySelect.innerHTML = '<option value="">Chọn Thành Phố</option>';
            
            if (cities.length > 0) {
                citySelect.disabled = false;
                cities.forEach(city => {
                    const option = document.createElement('option');
                    option.value = city.id;
                    option.textContent = city.vietnameseName || city.name;
                    citySelect.appendChild(option);
                });
                console.log('Successfully added', cities.length, 'cities');
            } else {
                citySelect.disabled = true;
                console.log('No cities available for region', regionId);
            }
        }

        // Sort experiences function
        function sortExperiences(sortValue) {
            if (sortValue) {
                const url = new URL(window.location);
                url.searchParams.set('sort', sortValue);
                window.location = url;
            }
        }

        // Copy experience function
        function copyExperience(experienceName) {
            const url = window.location.href;
            const shareText = 'Khám phá "' + experienceName + '" tại VietCulture: ' + url;
            
            if (navigator.share) {
                navigator.share({
                    title: experienceName,
                    text: 'Khám phá "' + experienceName + '" tại VietCulture',
                    url: url
                }).catch(err => console.log('Error sharing:', err));
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(shareText)
                    .then(() => {
                        showToast('Đã sao chép link "' + experienceName + '"', 'success');
                    })
                    .catch(err => {
                        showToast('Không thể sao chép: ' + err, 'error');
                    });
            }
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
            
            toast.innerHTML = icon + '<span>' + message + '</span>';
            
            toastContainer.appendChild(toast);
            
            setTimeout(() => {
                toast.classList.add('show');
            }, 100);
            
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toastContainer.removeChild(toast);
                    }
                }, 300);
            }, 3000);
        }

        // Initialize everything when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing...');
            
            // Load user favorites
            loadUserFavorites();
            
            // Update message badge
            updateMessageBadge();
            
            // Setup region/city functionality
            const regionSelect = document.getElementById('regionSelect');
            if (regionSelect) {
                regionSelect.addEventListener('change', function() {
                    const selectedRegionId = this.value;
                    
                    if (selectedRegionId) {
                        loadCitiesForRegion(selectedRegionId);
                    } else {
                        const citySelect = document.getElementById('citySelect');
                        citySelect.innerHTML = '<option value="">Chọn Thành Phố</option>';
                        citySelect.disabled = true;
                    }
                });
            }
            
            // Setup keyword search functionality
            setupKeywordSearch();
            
            // Initialize distance filter
            initializeDistanceFilter();
            
            // Animate on load
            animateOnScroll();
            
            console.log('Initialization complete');
        });

        // Debug function
        function debugExperiences() {
            console.log('=== DEBUG INFO ===');
            console.log('Cities data:', citiesData);
            console.log('Region select:', document.getElementById('regionSelect'));
            console.log('City select:', document.getElementById('citySelect'));
            
            // Test each region
            Object.keys(citiesData).forEach(regionId => {
                console.log(`Testing region ${regionId}:`, citiesData[regionId]);
            });
        }

        // Make debug function available globally
        window.debugExperiences = debugExperiences;

        // ===== KEYWORD SEARCH FUNCTIONALITY =====
        
        // Show/hide popular keywords
        function showPopularKeywords() {
            const popularKeywords = document.getElementById('popularKeywords');
            if (popularKeywords.style.display === 'none') {
                popularKeywords.style.display = 'flex';
            } else {
                popularKeywords.style.display = 'none';
            }
        }

        // Select a keyword and put it in search box
        function selectKeyword(keyword) {
            const keywordInput = document.getElementById('keywordSearch');
            keywordInput.value = keyword;
            
            // Hide popular keywords
            const popularKeywords = document.getElementById('popularKeywords');
            popularKeywords.style.display = 'none';
            
            // Trigger search suggestions
            handleKeywordInput();
        }

        // Handle keyword input and show suggestions
        function handleKeywordInput() {
            const keywordInput = document.getElementById('keywordSearch');
            const suggestions = document.getElementById('keywordSuggestions');
            const keyword = keywordInput.value.trim();
            
            if (keyword.length < 2) {
                suggestions.classList.remove('show');
                return;
            }
            
            // Get suggestions from server
            fetch('${pageContext.request.contextPath}/api/keyword-suggestions?q=' + encodeURIComponent(keyword))
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.suggestions && data.suggestions.length > 0) {
                        suggestions.innerHTML = '';
                        data.suggestions.forEach(function(suggestion) {
                            const div = document.createElement('div');
                            div.textContent = suggestion;
                            div.onclick = function() {
                                keywordInput.value = suggestion;
                                suggestions.classList.remove('show');
                                // Optionally trigger search immediately
                                // document.querySelector('.search-form').submit();
                            };
                            suggestions.appendChild(div);
                        });
                        suggestions.classList.add('show');
                    } else {
                        suggestions.classList.remove('show');
                    }
                })
                .catch(error => {
                    console.error('Error fetching suggestions:', error);
                    suggestions.classList.remove('show');
                });
        }

        // ===== DISTANCE FILTERING & GEOLOCATION =====
        
        let userLocation = {
            lat: null,
            lng: null,
            enabled: false
        };

        // Request user location
        function requestLocation() {
            const btn = document.getElementById('locationBtn');
            const status = document.getElementById('distanceStatus');
            const distanceSelect = document.getElementById('distanceSelect');
            
            if (!navigator.geolocation) {
                updateLocationStatus('disabled', 'Trình duyệt không hỗ trợ định vị');
                return;
            }

            // Show loading state
            btn.classList.add('active');
            updateLocationStatus('detecting', 'Đang xác định vị trí...');

            navigator.geolocation.getCurrentPosition(
                function(position) {
                    // Success
                    userLocation.lat = position.coords.latitude;
                    userLocation.lng = position.coords.longitude;
                    userLocation.enabled = true;
                    
                    // Update UI
                    btn.classList.remove('active');
                    btn.classList.add('enabled');
                    distanceSelect.disabled = false;
                    
                    // Update hidden inputs
                    document.getElementById('userLat').value = userLocation.lat;
                    document.getElementById('userLng').value = userLocation.lng;
                    
                    updateLocationStatus('enabled', 'Định vị thành công (±' + Math.round(position.coords.accuracy) + 'm)');
                    
                    console.log('Location acquired:', userLocation);
                },
                function(error) {
                    // Error
                    btn.classList.remove('active');
                    updateLocationStatus('disabled', getLocationErrorMessage(error));
                    console.error('Geolocation error:', error);
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 300000 // 5 minutes
                }
            );
        }

        // Update location status UI
        function updateLocationStatus(type, message) {
            const status = document.getElementById('distanceStatus');
            status.className = 'distance-status ' + type;
            status.innerHTML = '<i class="ri-information-line"></i> ' + message;
        }

        // Get user-friendly error message
        function getLocationErrorMessage(error) {
            switch(error.code) {
                case error.PERMISSION_DENIED:
                    return "Quyền truy cập vị trí bị từ chối";
                case error.POSITION_UNAVAILABLE:
                    return "Không thể xác định vị trí";
                case error.TIMEOUT:
                    return "Hết thời gian chờ định vị";
                default:
                    return "Lỗi không xác định khi định vị";
            }
        }

        // Initialize distance filter if coordinates are available
        function initializeDistanceFilter() {
            const userLat = document.getElementById('userLat').value;
            const userLng = document.getElementById('userLng').value;
            
            if (userLat && userLng) {
                userLocation.lat = parseFloat(userLat);
                userLocation.lng = parseFloat(userLng);
                userLocation.enabled = true;
                
                const btn = document.getElementById('locationBtn');
                const distanceSelect = document.getElementById('distanceSelect');
                
                btn.classList.add('enabled');
                distanceSelect.disabled = false;
                updateLocationStatus('enabled', 'Vị trí đã được lưu từ lần trước');
            }
        }

        // Setup keyword search event listeners
        function setupKeywordSearch() {
            const keywordInput = document.getElementById('keywordSearch');
            const suggestions = document.getElementById('keywordSuggestions');
            
            if (keywordInput) {
                // Input event for suggestions
                keywordInput.addEventListener('input', handleKeywordInput);
                
                // Click outside to hide suggestions
                document.addEventListener('click', function(event) {
                    if (!keywordInput.contains(event.target) && !suggestions.contains(event.target)) {
                        suggestions.classList.remove('show');
                    }
                });
                
                // Enter key to submit form
                keywordInput.addEventListener('keypress', function(event) {
                    if (event.key === 'Enter') {
                        suggestions.classList.remove('show');
                        document.querySelector('.search-form').submit();
                    }
                });
            }
        }
    </script>

</body>
</html>
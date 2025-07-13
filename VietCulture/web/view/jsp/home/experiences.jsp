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

        .distance-badge {
            position: absolute;
            bottom: 15px;
            right: 15px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .distance-badge i {
            font-size: 0.8rem;
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
            errorDiv.innerHTML = '<i class="ri-image-off-line"></i><span>Không tải được ảnh</span>';
            img.parentNode.replaceChild(errorDiv, img);
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

        // Improved favorite functionality
        function toggleFavorite(button) {
            // Check if user is logged in and is TRAVELER
            const isLoggedIn = JSP_VARS.isLoggedIn;
            const userRole = JSP_VARS.userRole;
            
            if (!isLoggedIn) {
                window.location.href = JSP_VARS.contextPath + '/login';
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
            
            // Make AJAX request to toggle favorite
            fetch(JSP_VARS.contextPath + '/favorites/toggle', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(requestData)
            })
            .then(response => {
                // Always remove loading state
                button.classList.remove('adding');
                button.disabled = false;
                
                if (!response.ok) {
                    if (response.status === 401) {
                        showToast('Vui lòng đăng nhập lại', 'error');
                        setTimeout(() => {
                            window.location.href = JSP_VARS.contextPath + '/login';
                        }, 2000);
                        return;
                    }
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
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
            const isLoggedIn = JSP_VARS.isLoggedIn;
            const userRole = JSP_VARS.userRole;
            
            if (!isLoggedIn || userRole !== 'TRAVELER') {
                return;
            }
            
            fetch(JSP_VARS.contextPath + '/favorites/list', {
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
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Error loading favorites:', error);
            });
        }

        // Initialize distance filter component
        let distanceFilter;
        let allExperiences = [];
        let allExperiencesFromAllPages = []; // Store all experiences from all pages
        let totalExperiencesCount = 0;
        let originalResultsTitle = '';
        let isDistanceFilterActive = false;
        let currentFilteredExperiences = [];
        let itemsPerPage = 10; // Default items per page
        let currentDistanceFilterPage = 1;
        
        // Vietnam cities coordinates for fallback
        const vietnamCities = {
            "Hồ Chí Minh": { lat: 10.8231, lng: 106.6297 },
            "Hà Nội": { lat: 21.0285, lng: 105.8542 },
            "Đà Nẵng": { lat: 16.0544, lng: 108.2022 },
            "Nha Trang": { lat: 12.2388, lng: 109.1967 },
            "Hội An": { lat: 15.8801, lng: 108.335 },
            "Hạ Long": { lat: 20.9101, lng: 107.1839 },
            "Huế": { lat: 16.4637, lng: 107.5909 },
            "Đà Lạt": { lat: 11.9404, lng: 108.4583 },
            "Cần Thơ": { lat: 10.0452, lng: 105.7469 },
            "Vũng Tàu": { lat: 10.4113, lng: 107.1362 },
            "Phú Quốc": { lat: 10.2899, lng: 103.9840 },
            "Sapa": { lat: 22.3380, lng: 103.8438 },
            "Ninh Bình": { lat: 20.2506, lng: 105.9744 },
            "Cao Bằng": { lat: 22.6663, lng: 106.2529 },
            "Lạng Sơn": { lat: 21.8533, lng: 106.7614 },
            "Quảng Ninh": { lat: 21.0069, lng: 107.2925 },
            "Thanh Hóa": { lat: 19.8069, lng: 105.7851 },
            "Nghệ An": { lat: 19.2342, lng: 104.9200 },
            "Hà Tĩnh": { lat: 18.3430, lng: 105.9005 },
            "Quảng Bình": { lat: 17.4677, lng: 106.6222 },
            "Quảng Trị": { lat: 16.7403, lng: 107.1858 },
            "Thừa Thiên Huế": { lat: 16.4637, lng: 107.5909 },
            "Quảng Nam": { lat: 15.5394, lng: 108.0191 },
            "Quảng Ngãi": { lat: 15.1214, lng: 108.8044 },
            "Bình Định": { lat: 13.7763, lng: 109.2177 },
            "Phú Yên": { lat: 13.0881, lng: 109.0929 },
            "Khánh Hòa": { lat: 12.2388, lng: 109.1967 },
            "Ninh Thuận": { lat: 11.5752, lng: 108.9229 },
            "Bình Thuận": { lat: 11.0904, lng: 108.0721 },
            "Kon Tum": { lat: 14.3497, lng: 108.0130 },
            "Gia Lai": { lat: 13.9833, lng: 108.0000 },
            "Đắk Lắk": { lat: 12.7100, lng: 108.2378 },
            "Đắk Nông": { lat: 12.2646, lng: 107.6098 },
            "Lâm Đồng": { lat: 11.5752, lng: 108.1429 },
            "Bình Phước": { lat: 11.7511, lng: 106.7234 },
            "Tây Ninh": { lat: 11.3100, lng: 106.1000 },
            "Bình Dương": { lat: 11.3254, lng: 106.4770 },
            "Đồng Nai": { lat: 10.9571, lng: 106.8438 },
            "Bà Rịa - Vũng Tàu": { lat: 10.4113, lng: 107.1362 },
            "Long An": { lat: 10.6956, lng: 106.2431 },
            "Tiền Giang": { lat: 10.3632, lng: 106.3600 },
            "Bến Tre": { lat: 10.2431, lng: 106.3757 },
            "Trà Vinh": { lat: 9.9478, lng: 106.3267 },
            "Vĩnh Long": { lat: 10.2397, lng: 105.9571 },
            "Đồng Tháp": { lat: 10.6637, lng: 105.6357 },
            "An Giang": { lat: 10.5215, lng: 105.1258 },
            "Kiên Giang": { lat: 10.0125, lng: 105.0806 },
            "Cà Mau": { lat: 9.1767, lng: 105.1524 },
            "Bạc Liêu": { lat: 9.2945, lng: 105.7244 },
            "Sóc Trăng": { lat: 9.6003, lng: 105.9800 },
            "Hậu Giang": { lat: 9.7570, lng: 105.6412 }
        };
        
        // Calculate distance between two coordinates using Haversine formula
        function calculateDistance(coord1, coord2) {
            const R = 6371; // Earth's radius in km
            
            const lat1 = coord1.lat * Math.PI / 180;
            const lat2 = coord2.lat * Math.PI / 180;
            const deltaLat = (coord2.lat - coord1.lat) * Math.PI / 180;
            const deltaLng = (coord2.lng - coord1.lng) * Math.PI / 180;
            
            const a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                      Math.cos(lat1) * Math.cos(lat2) *
                      Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);
            
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            const distance = R * c;
            
            return distance;
        }
        
        // Get coordinates from address (with fallback to Vietnam cities)
        async function getCoordinatesFromAddress(address) {
            try {
                // First try to find exact match in Vietnam cities
                const cleanAddress = address.trim();
                
                // Check for exact match
                if (vietnamCities[cleanAddress]) {
                    return vietnamCities[cleanAddress];
                }
                
                // Check for partial match
                for (const cityName in vietnamCities) {
                    if (cleanAddress.toLowerCase().includes(cityName.toLowerCase()) || 
                        cityName.toLowerCase().includes(cleanAddress.toLowerCase())) {
                        return vietnamCities[cityName];
                    }
                }
                
                // If no match found, try geocoding API (optional)
                // For now, return null to skip this experience
                return null;
                
            } catch (error) {
                console.error('Error getting coordinates for address:', address, error);
                return null;
            }
        }
        
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
            
            // Save original pagination
            const paginationContainer = document.querySelector('.pagination-container');
            if (paginationContainer) {
                paginationContainer.setAttribute('data-original-pagination', paginationContainer.innerHTML);
            }
            
            // Initialize empty experiences array - will be populated from DOM
            allExperiences = [];
            
            // Initialize simple distance filter
            initializeSimpleDistanceFilter();
            
            // Extract experience data from DOM cards
            const experienceCards = document.querySelectorAll('.card-item');
            experienceCards.forEach((card, index) => {
                const experience = extractExperienceDataFromCard(card);
                if (experience) {
                    // Clone the original card element for restoration
                    experience.element = card.cloneNode(true);
                    allExperiences.push(experience);
                }
            });
            
            // Copy initial experiences to all experiences array
            allExperiencesFromAllPages = [...allExperiences];
            
            // Detect items per page from current display
            const currentDisplayedItems = document.querySelectorAll('.card-item').length;
            if (currentDisplayedItems > 0) {
                itemsPerPage = currentDisplayedItems;
            }
            
            // Load user favorites
            loadUserFavorites();
            
            // Setup keyword search functionality
            setupKeywordSearch();
            
            // Animate on load
            animateOnScroll();
        });
        
        // Cải thiện function extractExperienceDataFromCard để lưu thêm thông tin
        function extractExperienceDataFromCard(card) {
            try {
                const titleElement = card.querySelector('h5');
                const locationElement = card.querySelector('.location span');
                const priceElement = card.querySelector('.price');
                const ratingElement = card.querySelector('.rating span');
                const imageElement = card.querySelector('.card-image img');
                const typeElement = card.querySelector('.card-badge');
                const difficultyElement = card.querySelector('.difficulty-badge');
                const viewButton = card.querySelector('a[href*="/experiences/"]');
                const descriptionElement = card.querySelector('.card-content p');
                const hostElement = card.querySelector('.host-name');
                const durationElement = card.querySelector('.info-row span i.ri-time-line');
                const groupSizeElement = card.querySelector('.info-row span i.ri-group-line');
                const includedItemsElement = card.querySelector('.info-row span i.ri-check-line');
                
                if (!titleElement || !viewButton) {
                    return null;
                }
                
                return {
                    id: extractExperienceId(card),
                    title: titleElement.textContent.trim(),
                    location: locationElement ? locationElement.textContent.trim() : '',
                    cityName: locationElement ? locationElement.textContent.trim() : '',
                    price: extractPrice(priceElement),
                    rating: extractRating(ratingElement),
                    totalBookings: extractTotalBookings(card),
                    firstImage: imageElement ? imageElement.src.split('/').pop() : '',
                    images: imageElement ? imageElement.src.split('/').pop() : '',
                    type: typeElement ? typeElement.textContent.trim() : '',
                    difficulty: difficultyElement ? difficultyElement.textContent.trim() : '',
                    description: descriptionElement ? descriptionElement.textContent.trim() : '',
                    hostName: hostElement ? hostElement.textContent.replace('Host: ', '').trim() : '',
                    duration: durationElement ? durationElement.parentElement.textContent.trim() : '',
                    maxGroupSize: groupSizeElement ? extractGroupSize(groupSizeElement.parentElement.textContent) : '',
                    includedItems: includedItemsElement ? includedItemsElement.parentElement.textContent.replace(/^[^:]*:\s*/, '').trim() : '',
                    element: null // Sẽ được gán sau
                };
            } catch (error) {
                console.error('Error extracting experience data from card:', error);
                return null;
            }
        }

        // Helper functions mới
        function extractTotalBookings(card) {
            const ratingElement = card.querySelector('.rating small');
            if (ratingElement) {
                const match = ratingElement.textContent.match(/\((\d+)/);
                return match ? parseInt(match[1]) : 0;
            }
            return 0;
        }

        function extractGroupSize(text) {
            const match = text.match(/(\d+)\s*người/);
            return match ? parseInt(match[1]) : '';
        }

        function formatDuration(duration) {
            // Nếu duration là string từ DOM
            if (typeof duration === 'string') {
                return duration;
            }
            // Nếu duration là Date object từ database
            if (duration instanceof Date) {
                const hours = duration.getHours();
                const minutes = duration.getMinutes();
                return hours + 'h' + (minutes > 0 ? minutes.toString().padStart(2, '0') : '');
            }
            return 'Cả ngày';
        }
        
        // Load all experiences from all pages
        async function loadAllExperiences() {
            if (allExperiencesFromAllPages.length >= totalExperiencesCount) {
                return allExperiencesFromAllPages;
            }
            
            try {
                const allExperiences = [];
                const totalPages = Math.ceil(totalExperiencesCount / itemsPerPage);
                
                // Create promises for all pages
                const pagePromises = [];
                for (let page = 1; page <= totalPages; page++) {
                    pagePromises.push(loadExperiencesFromPage(page));
                }
                
                // Wait for all pages to load
                const pageResults = await Promise.all(pagePromises);
                
                // Combine all results
                pageResults.forEach(pageExperiences => {
                    allExperiences.push(...pageExperiences);
                });
                
                allExperiencesFromAllPages = allExperiences;
                return allExperiences;
                
            } catch (error) {
                console.error('Error loading all experiences:', error);
                return allExperiencesFromAllPages;
            }
        }
        
        // Load experiences from a specific page
        async function loadExperiencesFromPage(pageNumber) {
            try {
                const currentUrl = new URL(window.location.href);
                currentUrl.searchParams.set('page', pageNumber);
                
                const response = await fetch(currentUrl.toString(), {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const html = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                // Extract experiences data from the page
                const experienceCards = doc.querySelectorAll('.card-item');
                const pageExperiences = [];
                
                experienceCards.forEach((card, index) => {
                    const experience = extractExperienceDataFromCard(card);
                    if (experience) {
                        // Clone the card element
                        experience.element = card.cloneNode(true);
                        pageExperiences.push(experience);
                    }
                });
                
                return pageExperiences;
                
            } catch (error) {
                console.error(`Error loading page ${pageNumber}:`, error);
                return [];
            }
        }
        
        // Helper functions to extract data from DOM elements
        function extractExperienceId(card) {
            const viewButton = card.querySelector('a[href*="/experiences/"]');
            if (viewButton) {
                const href = viewButton.getAttribute('href');
                const match = href.match(/\/experiences\/(\d+)/);
                return match ? parseInt(match[1]) : 0;
            }
            return 0;
        }
        
        function extractPrice(priceElement) {
            if (!priceElement) return 0;
            const text = priceElement.textContent;
            if (text.includes('Miễn phí')) return 0;
            const match = text.match(/[\d,]+/);
            return match ? parseInt(match[0].replace(/,/g, '')) : 0;
        }
        
        function extractRating(ratingElement) {
            if (!ratingElement) return 0;
            const text = ratingElement.textContent;
            const match = text.match(/[\d.]+/);
            return match ? parseFloat(match[0]) : 0;
        }
        
        // Filter experiences by distance with proper pagination
        async function filterExperiencesByDistance(maxDistance) {
            if (!distanceFilter || !distanceFilter.isLocationEnabled || !distanceFilter.userLocation) {
                showToast('Vui lòng cho phép truy cập vị trí để lọc theo khoảng cách', 'error');
                return;
            }
            
            try {
                // Show loading state
                showLoadingState();
                
                // Load all experiences from all pages
                const allExperiences = await loadAllExperiences();
                
                if (allExperiences.length === 0) {
                    showToast('Không tìm thấy trải nghiệm nào để lọc', 'error');
                    return;
                }
                
                // Filter by distance
                const filteredExperiences = await filterExperiencesByDistanceFromList(allExperiences, maxDistance);
                
                // Sort by distance
                filteredExperiences.sort((a, b) => (a.distance || 0) - (b.distance || 0));
                
                // Store filtered experiences
                currentFilteredExperiences = filteredExperiences;
                isDistanceFilterActive = true;
                currentDistanceFilterPage = 1;
                
                if (filteredExperiences.length === 0) {
                    showNoDistanceResults(maxDistance);
                } else {
                    // Display first page of filtered results
                    displayFilteredExperiences(currentDistanceFilterPage);
                    
                    // Update results count
                    updateResultsCount(filteredExperiences.length, 'trải nghiệm trong bán kính ' + maxDistance + 'km');
                    
                    // Create pagination for filtered results
                    createDistanceFilterPagination(filteredExperiences.length, maxDistance);
                    
                    showToast('Tìm thấy ' + filteredExperiences.length + ' trải nghiệm trong bán kính ' + maxDistance + 'km', 'success');
                }
                
            } catch (error) {
                console.error('Error filtering experiences:', error);
                showToast('Có lỗi xảy ra khi lọc theo khoảng cách: ' + error.message, 'error');
                // Don't call showAllExperiences() here, just hide loading
            } finally {
                hideLoadingState();
            }
        }
        
        // Filter experiences by distance from a list
        async function filterExperiencesByDistanceFromList(experiences, maxDistance) {
            const filteredExperiences = [];
            
            for (const experience of experiences) {
                if (!experience.location) continue;
                
                // Get coordinates for experience location
                const experienceCoords = await getCoordinatesFromAddress(experience.location);
                
                if (experienceCoords) {
                    // Calculate distance
                    const distance = calculateDistance(distanceFilter.userLocation, experienceCoords);
                    
                    if (distance <= maxDistance) {
                        experience.distance = distance;
                        filteredExperiences.push(experience);
                    }
                }
            }
            
            return filteredExperiences;
        }
        
        // Display filtered experiences with pagination
        function displayFilteredExperiences(page) {
            const startIndex = (page - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const pageExperiences = currentFilteredExperiences.slice(startIndex, endIndex);
            
            // Clear current display
            const container = document.querySelector('.cards-grid');
            container.innerHTML = '';
            
            // Add filtered experiences
            pageExperiences.forEach(experience => {
                const card = createExperienceCard(experience);
                container.appendChild(card);
            });
            
            // Update page number
            currentDistanceFilterPage = page;
            
            // Reload favorites for new cards
            setTimeout(() => {
                loadUserFavorites();
            }, 100);
        }
        
        // Cải thiện function createExperienceCard để tạo card giống hệt card gốc
        function createExperienceCard(experience) {
            // Nếu có element gốc, clone và cập nhật distance badge
            if (experience.element) {
                const card = experience.element.cloneNode(true);
                
                // Thêm distance badge nếu có distance
                if (experience.distance !== undefined) {
                    const cardImage = card.querySelector('.card-image');
                    if (cardImage) {
                        // Xóa distance badge cũ nếu có
                        const existingDistanceBadge = cardImage.querySelector('.distance-badge');
                        if (existingDistanceBadge) {
                            existingDistanceBadge.remove();
                        }
                        
                        // Thêm distance badge mới
                        const distanceBadge = document.createElement('div');
                        distanceBadge.className = 'distance-badge';
                        distanceBadge.innerHTML = '<i class="ri-map-pin-line"></i> ' + formatDistance(experience.distance);
                        cardImage.appendChild(distanceBadge);
                    }
                }
                
                // Đảm bảo favorite button hoạt động đúng
                const favoriteBtn = card.querySelector('.favorite-btn');
                if (favoriteBtn) {
                    favoriteBtn.setAttribute('onclick', 'toggleFavorite(this)');
                }
                
                return card;
            }
            
            // Fallback: tạo card mới với cấu trúc đầy đủ
            return createFullExperienceCard(experience);
        }

        // Function tạo card đầy đủ (backup cho trường hợp không có element gốc)
        function createFullExperienceCard(experience) {
            const card = document.createElement('div');
            card.className = 'card-item';
            
            // Create card image
            const cardImage = document.createElement('div');
            cardImage.className = 'card-image';
            
            // Add favorite button if user is logged in
            const isLoggedIn = JSP_VARS.isLoggedIn;
            if (isLoggedIn) {
                const favoriteBtn = document.createElement('button');
                favoriteBtn.className = 'favorite-btn';
                favoriteBtn.setAttribute('data-experience-id', experience.id);
                favoriteBtn.setAttribute('data-type', 'experience');
                favoriteBtn.setAttribute('onclick', 'toggleFavorite(this)');
                favoriteBtn.innerHTML = '<i class="ri-heart-line"></i>';
                cardImage.appendChild(favoriteBtn);
            }
            
            // Add image or placeholder
            const imageUrl = experience.firstImage || experience.images ? 
                JSP_VARS.contextPath + '/images/experiences/' + (experience.firstImage || experience.images) : '';
            
            if (imageUrl) {
                const img = document.createElement('img');
                img.src = imageUrl;
                img.alt = experience.title;
                img.setAttribute('onerror', 'handleImageError(this)');
                cardImage.appendChild(img);
            } else {
                const placeholder = document.createElement('div');
                placeholder.className = 'no-image-placeholder';
                placeholder.innerHTML = '<i class="ri-image-line"></i><span>Không có ảnh</span>';
                cardImage.appendChild(placeholder);
            }
            
            // Add type badge
            if (experience.type) {
                const typeBadge = document.createElement('div');
                typeBadge.className = 'card-badge';
                let typeText = experience.type;
                // Convert type to Vietnamese
                switch(experience.type) {
                    case 'Food': typeText = 'Ẩm Thực'; break;
                    case 'Culture': typeText = 'Văn Hóa'; break;
                    case 'Adventure': typeText = 'Phiêu Lưu'; break;
                    case 'History': typeText = 'Lịch Sử'; break;
                }
                typeBadge.textContent = typeText;
                cardImage.appendChild(typeBadge);
            }
            
            // Add difficulty badge if exists
            if (experience.difficulty) {
                const difficultyBadge = document.createElement('div');
                difficultyBadge.className = 'difficulty-badge';
                let difficultyText = experience.difficulty;
                // Convert difficulty to Vietnamese
                switch(experience.difficulty) {
                    case 'EASY': difficultyText = 'Dễ'; break;
                    case 'MODERATE': difficultyText = 'Vừa'; break;
                    case 'CHALLENGING': difficultyText = 'Khó'; break;
                }
                difficultyBadge.textContent = difficultyText;
                cardImage.appendChild(difficultyBadge);
            }
            
            // Add distance badge if exists
            if (experience.distance !== undefined) {
                const distanceBadge = document.createElement('div');
                distanceBadge.className = 'distance-badge';
                distanceBadge.innerHTML = '<i class="ri-map-pin-line"></i> ' + formatDistance(experience.distance);
                cardImage.appendChild(distanceBadge);
            }
            
            // Create card content
            const cardContent = document.createElement('div');
            cardContent.className = 'card-content';
            
            // Title
            const title = document.createElement('h5');
            title.textContent = experience.title;
            cardContent.appendChild(title);
            
            // Location
            const location = document.createElement('div');
            location.className = 'location';
            location.innerHTML = '<i class="ri-map-pin-line"></i><span>' + (experience.cityName || experience.location) + '</span>';
            cardContent.appendChild(location);
            
            // Description (if available from experience data)
            if (experience.description) {
                const description = document.createElement('p');
                const desc = experience.description.length > 100 ? 
                    experience.description.substring(0, 100) + '...' : 
                    experience.description;
                description.textContent = desc;
                cardContent.appendChild(description);
            }
            
            // Info rows (duration, group size, etc.)
            if (experience.duration || experience.maxGroupSize) {
                const infoRow1 = document.createElement('div');
                infoRow1.className = 'info-row';
                
                let infoHtml = '';
                if (experience.duration) {
                    infoHtml += '<span><i class="ri-time-line"></i> ' + formatDuration(experience.duration) + '</span>';
                }
                if (experience.maxGroupSize) {
                    infoHtml += '<span><i class="ri-group-line"></i> Tối đa ' + experience.maxGroupSize + ' người</span>';
                }
                
                infoRow1.innerHTML = infoHtml;
                cardContent.appendChild(infoRow1);
            }
            
            // Included items (if available)
            if (experience.includedItems) {
                const infoRow2 = document.createElement('div');
                infoRow2.className = 'info-row';
                
                const items = experience.includedItems.split(',');
                let itemsText = '';
                if (items.length > 2) {
                    itemsText = items[0].trim() + ', ' + items[1].trim() + '...';
                } else {
                    itemsText = experience.includedItems.length > 50 ? 
                        experience.includedItems.substring(0, 50) + '...' : 
                        experience.includedItems;
                }
                
                infoRow2.innerHTML = '<span><i class="ri-check-line"></i> ' + itemsText + '</span>';
                cardContent.appendChild(infoRow2);
            }
            
            // Footer with price and rating
            const cardFooter = document.createElement('div');
            cardFooter.className = 'card-footer';
            
            // Price
            const price = document.createElement('div');
            price.className = 'price';
            if (experience.price === 0) {
                price.textContent = 'Miễn phí';
            } else {
                price.innerHTML = new Intl.NumberFormat('vi-VN').format(experience.price) + ' VNĐ <small>/người</small>';
            }
            cardFooter.appendChild(price);
            
            // Rating
            if (experience.rating > 0) {
                const rating = document.createElement('div');
                rating.className = 'rating';
                rating.innerHTML = '<i class="ri-star-fill"></i><span>' + experience.rating.toFixed(1) + '</span>';
                if (experience.totalBookings > 0) {
                    rating.innerHTML += '<small>(' + experience.totalBookings + ' đánh giá)</small>';
                }
                cardFooter.appendChild(rating);
            }
            
            cardContent.appendChild(cardFooter);
            
            // Host info (if available)
            if (experience.hostName) {
                const hostInfo = document.createElement('div');
                hostInfo.className = 'host-info';
                hostInfo.innerHTML = `
                    <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" alt="Host" class="host-avatar">
                    <div>
                        <div class="host-name">Host: ${experience.hostName}</div>
                        <small class="text-muted">Trải nghiệm địa phương</small>
                    </div>
                `;
                cardContent.appendChild(hostInfo);
            }
            
            // Action buttons
            const cardAction = document.createElement('div');
            cardAction.className = 'card-action';
            
            // View detail button
            const viewBtn = document.createElement('a');
            viewBtn.href = JSP_VARS.contextPath + '/experiences/' + experience.id;
            viewBtn.className = 'btn btn-outline-primary';
            viewBtn.innerHTML = '<i class="ri-eye-line me-2"></i>Xem Chi Tiết';
            cardAction.appendChild(viewBtn);
            
            // Share button
            const shareBtn = document.createElement('button');
            shareBtn.className = 'btn-copy';
            shareBtn.setAttribute('onclick', "copyExperience('" + experience.title.replace(/'/g, "\\'") + "')");
            shareBtn.innerHTML = '<i class="ri-share-line"></i><span>Chia sẻ</span>';
            cardAction.appendChild(shareBtn);
            
            cardContent.appendChild(cardAction);
            
            // Assemble the card
            card.appendChild(cardImage);
            card.appendChild(cardContent);
            
            return card;
        }
        
        // Create pagination for distance filter
        function createDistanceFilterPagination(totalItems, maxDistance) {
            const totalPages = Math.ceil(totalItems / itemsPerPage);
            
            if (totalPages <= 1) {
                // Hide pagination if only one page
                const paginationContainer = document.querySelector('.pagination-container');
                if (paginationContainer) {
                    paginationContainer.style.display = 'none';
                }
                return;
            }
            
            const paginationContainer = document.querySelector('.pagination-container');
            if (!paginationContainer) return;
            
            paginationContainer.style.display = 'flex';
            
            const pagination = paginationContainer.querySelector('.pagination');
            pagination.innerHTML = '';
            
            // Previous button
            if (currentDistanceFilterPage > 1) {
                const prevLi = document.createElement('li');
                prevLi.className = 'page-item';
                const prevLink = document.createElement('a');
                prevLink.className = 'page-link';
                prevLink.href = '#';
                prevLink.setAttribute('onclick', 'changeDistanceFilterPage(' + (currentDistanceFilterPage - 1) + ', ' + maxDistance + ')');
                prevLink.innerHTML = '<i class="ri-arrow-left-s-line"></i>';
                prevLi.appendChild(prevLink);
                pagination.appendChild(prevLi);
            }
            
            // Page numbers
            for (let i = 1; i <= totalPages; i++) {
                const pageLi = document.createElement('li');
                pageLi.className = 'page-item' + (i === currentDistanceFilterPage ? ' active' : '');
                const pageLink = document.createElement('a');
                pageLink.className = 'page-link';
                pageLink.href = '#';
                pageLink.setAttribute('onclick', 'changeDistanceFilterPage(' + i + ', ' + maxDistance + ')');
                pageLink.textContent = i;
                pageLi.appendChild(pageLink);
                pagination.appendChild(pageLi);
            }
            
            // Next button
            if (currentDistanceFilterPage < totalPages) {
                const nextLi = document.createElement('li');
                nextLi.className = 'page-item';
                const nextLink = document.createElement('a');
                nextLink.className = 'page-link';
                nextLink.href = '#';
                nextLink.setAttribute('onclick', 'changeDistanceFilterPage(' + (currentDistanceFilterPage + 1) + ', ' + maxDistance + ')');
                nextLink.innerHTML = '<i class="ri-arrow-right-s-line"></i>';
                nextLi.appendChild(nextLink);
                pagination.appendChild(nextLi);
            }
        }
        
        // Change page in distance filter
        function changeDistanceFilterPage(page, maxDistance) {
            if (page < 1 || page > Math.ceil(currentFilteredExperiences.length / itemsPerPage)) {
                return;
            }
            
            displayFilteredExperiences(page);
            createDistanceFilterPagination(currentFilteredExperiences.length, maxDistance);
            
            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        // Show loading state
        function showLoadingState() {
            const container = document.querySelector('.cards-grid');
            
            // Create loading wrapper
            const loadingWrapper = document.createElement('div');
            loadingWrapper.className = 'col-12 text-center py-5';
            
            // Create spinner
            const spinner = document.createElement('div');
            spinner.className = 'spinner-border text-primary';
            spinner.setAttribute('role', 'status');
            
            const spinnerText = document.createElement('span');
            spinnerText.className = 'visually-hidden';
            spinnerText.textContent = 'Đang tải...';
            spinner.appendChild(spinnerText);
            
            // Create message
            const message = document.createElement('p');
            message.className = 'mt-3';
            message.textContent = 'Đang tìm kiếm trải nghiệm gần bạn...';
            
            // Assemble loading state
            loadingWrapper.appendChild(spinner);
            loadingWrapper.appendChild(message);
            
            // Clear container and add loading
            container.innerHTML = '';
            container.appendChild(loadingWrapper);
        }

        // Show no distance results
        function showNoDistanceResults(maxDistance) {
            const container = document.querySelector('.cards-grid');
            
            const noResultsWrapper = document.createElement('div');
            noResultsWrapper.className = 'no-results';
            
            noResultsWrapper.innerHTML = `
                <i class="ri-map-pin-line"></i>
                <h4>Không tìm thấy trải nghiệm nào trong bán kính ${maxDistance}km</h4>
                <p>Hãy thử tăng khoảng cách tìm kiếm hoặc tắt bộ lọc khoảng cách</p>
                <div class="mt-3">
                    <button class="btn btn-primary me-2" onclick="increaseDistance()">
                        <i class="ri-add-line me-2"></i>Tăng khoảng cách
                    </button>
                    <button class="btn btn-outline-primary" onclick="disableDistanceFilter()">
                        <i class="ri-close-line me-2"></i>Tắt lọc khoảng cách
                    </button>
                </div>
            `;
            
            container.innerHTML = '';
            container.appendChild(noResultsWrapper);
            
            // Hide pagination
            const paginationContainer = document.querySelector('.pagination-container');
            if (paginationContainer) {
                paginationContainer.style.display = 'none';
            }
        }

        // Increase distance when no results found
        function increaseDistance() {
            const distanceSlider = document.getElementById('distanceSlider');
            const distanceValue = document.getElementById('distanceValue');
            
            if (distanceSlider && distanceValue) {
                const currentValue = parseInt(distanceSlider.value);
                const newValue = Math.min(currentValue + 20, 100); // Increase by 20km, max 100km
                
                distanceSlider.value = newValue;
                distanceValue.textContent = newValue;
                
                // Trigger filter with new distance
                filterExperiencesByDistance(newValue);
            }
        }

        // Disable distance filter
        function disableDistanceFilter() {
            const locationToggle = document.getElementById('locationToggle');
            const distanceControls = document.getElementById('distanceControls');
            
            if (locationToggle && distanceControls) {
                locationToggle.checked = false;
                distanceControls.classList.add('d-none');
                distanceFilter.isLocationEnabled = false;
                showAllExperiences();
            }
        }
        
        // Hide loading state
        function hideLoadingState() {
            // Loading state will be replaced by actual content
        }
        
        // Show all experiences (reset distance filter)
        function showAllExperiences() {
            isDistanceFilterActive = false;
            currentFilteredExperiences = [];
            
            // Instead of reloading, restore original display
            const container = document.querySelector('.cards-grid');
            container.innerHTML = '';
            
            // Show original experiences
            allExperiences.forEach(experience => {
                if (experience.element) {
                    container.appendChild(experience.element);
                }
            });
            
            // Restore original pagination
            const paginationContainer = document.querySelector('.pagination-container');
            if (paginationContainer) {
                paginationContainer.style.display = 'flex';
                // Restore original pagination if it exists
                const originalPagination = paginationContainer.getAttribute('data-original-pagination');
                if (originalPagination) {
                    paginationContainer.innerHTML = originalPagination;
                }
            }
            
            // Restore original results count
            updateResultsCount(totalExperiencesCount, 'trải nghiệm được tìm thấy');
            
            // Reload favorites
            setTimeout(() => {
                loadUserFavorites();
            }, 100);
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
            
            // Initialize distance filter object
            distanceFilter = {
                userLocation: null,
                isLocationEnabled: false
            };
            
            // Location toggle handler
            locationToggle.addEventListener('change', function() {
                if (this.checked) {
                    distanceControls.classList.remove('d-none');
                    requestUserLocation();
                } else {
                    distanceControls.classList.add('d-none');
                    distanceFilter.isLocationEnabled = false;
                    showAllExperiences();
                }
            });
            
            // Distance slider handler
            distanceSlider.addEventListener('input', function() {
                distanceValue.textContent = this.value;
            });
            
            distanceSlider.addEventListener('change', function() {
                if (distanceFilter.isLocationEnabled && distanceFilter.userLocation) {
                    filterExperiencesByDistance(parseInt(this.value));
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
                        distanceFilter.userLocation = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        };
                        distanceFilter.isLocationEnabled = true;
                        locationStatus.innerHTML = '<i class="ri-map-pin-line text-success"></i> Đã lấy vị trí thành công';
                        
                        // Start filtering with current distance
                        filterExperiencesByDistance(parseInt(distanceSlider.value));
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
        }

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

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.custom-navbar');
            if (navbar) {
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            }
            
            animateOnScroll();
        });

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

        // Sort experiences function
        function sortExperiences(sortValue) {
            if (sortValue) {
                const url = new URL(window.location);
                url.searchParams.set('sort', sortValue);
                window.location = url;
            }
        }

        // Debug function
        function debugExperiences() {
            console.log('=== DEBUG INFO ===');
            console.log('All experiences:', allExperiences);
            console.log('Distance filter:', distanceFilter);
            console.log('Current filtered:', currentFilteredExperiences);
        }

        // Make debug function available globally
        window.debugExperiences = debugExperiences;
    </script>

</body>
</html>
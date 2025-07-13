<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${experience.title} | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
        <style>
            /* CSS cho message icon */
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

            .btn-chat.chat-pulse {
                animation: chatPulse 2s infinite;
                box-shadow: 0 0 0 0 rgba(255, 56, 92, 0.7);
            }

            @keyframes chatPulse {
                0% {
                    transform: scale(0.95);
                    box-shadow: 0 0 0 0 rgba(255, 56, 92, 0.7);
                }
                70% {
                    transform: scale(1);
                    box-shadow: 0 0 0 10px rgba(255, 56, 92, 0);
                }
                100% {
                    transform: scale(0.95);
                    box-shadow: 0 0 0 0 rgba(255, 56, 92, 0);
                }
            }

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

            .toast-close {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 2px;
                margin-left: auto;
            }

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

            /* Google Maps Styles */
            .map-container {
                border-radius: var(--border-radius);
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .directions-controls {
                margin-top: 20px;
            }

            .directions-controls .btn-group {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: var(--shadow-sm);
            }

            .directions-controls .btn {
                border-radius: 0;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: 500;
                transition: var(--transition);
            }

            .directions-controls .btn:first-child {
                border-top-left-radius: 12px;
                border-bottom-left-radius: 12px;
            }

            .directions-controls .btn:last-child {
                border-top-right-radius: 12px;
                border-bottom-right-radius: 12px;
            }

            .directions-controls .btn-outline-primary {
                border-color: var(--primary-color);
                color: var(--primary-color);
            }

            .directions-controls .btn-outline-primary:hover {
                background-color: var(--primary-color);
                color: white;
                transform: translateY(-2px);
            }

            .directions-controls .btn-outline-secondary {
                border-color: #6c757d;
                color: #6c757d;
            }

            .directions-controls .btn-outline-secondary:hover {
                background-color: #6c757d;
                color: white;
                transform: translateY(-2px);
            }

            .directions-controls .form-select {
                border-radius: 12px;
                border: 2px solid #e0e0e0;
                padding: 12px 16px;
                font-weight: 500;
                transition: var(--transition);
            }

            .directions-controls .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(255, 56, 92, 0.25);
                outline: none;
            }

            .directions-panel {
                margin-top: 20px;
                animation: slideDown 0.5s ease-out;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .directions-panel .card {
                border: none;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-md);
                overflow: hidden;
            }

            .directions-panel .card-header {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border-bottom: 1px solid #dee2e6;
                padding: 15px 20px;
            }

            .directions-panel .card-header h6 {
                color: var(--dark-color);
                font-weight: 600;
                margin: 0;
            }

            .directions-panel .card-body {
                padding: 20px;
                max-height: 400px;
                overflow-y: auto;
            }

            .directions-panel .card-body::-webkit-scrollbar {
                width: 6px;
            }

            .directions-panel .card-body::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 3px;
            }

            .directions-panel .card-body::-webkit-scrollbar-thumb {
                background: var(--primary-color);
                border-radius: 3px;
            }

            .directions-panel .card-body::-webkit-scrollbar-thumb:hover {
                background: #ff1744;
            }

            /* Google Maps Custom Styles for Info Windows */
            .gm-style .gm-style-iw-c {
                border-radius: 12px !important;
                overflow: hidden !important;
            }

            .gm-style .gm-style-iw-d {
                overflow: hidden !important;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .directions-controls .btn-group {
                    flex-direction: column;
                }

                .directions-controls .btn {
                    border-radius: 12px !important;
                    margin-bottom: 10px;
                }

                .directions-controls .row > div {
                    margin-bottom: 10px;
                }

                #experienceMap {
                    height: 300px !important;
                }
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

            /* Keyboard navigation support */
            body.keyboard-navigation *:focus {
                outline: 2px solid var(--primary-color);
                outline-offset: 2px;
            }

            h1, h2, h3, h4, h5 {
                font-family: 'Playfair Display', serif;
            }

            .btn {
                border-radius: 30px;
                padding: 12px 24px;
                font-weight: 500;
                transition: var(--transition);
                border: none;
                cursor: pointer;
            }

            .btn-primary {
                background: var(--gradient-primary);
                border: none;
                color: white;
                box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
            }

            .btn-primary:hover:not(:disabled) {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
                color: white;
            }

            .btn-primary:disabled {
                background: #6c757d;
                border-color: #6c757d;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .btn-primary.loading {
                position: relative;
                color: transparent;
            }

            .btn-primary.loading::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 20px;
                height: 20px;
                border: 2px solid transparent;
                border-top: 2px solid white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
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

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-sm {
                padding: 8px 16px;
                font-size: 0.9rem;
                border-radius: 20px;
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

            /* Breadcrumb */
            .breadcrumb-container {
                background-color: var(--light-color);
                padding: 15px 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .breadcrumb {
                background: none;
                margin: 0;
                padding: 0;
            }

            .breadcrumb-item {
                color: #6c757d;
            }

            .breadcrumb-item.active {
                color: var(--dark-color);
                font-weight: 600;
            }

            .breadcrumb-item a {
                color: var(--primary-color);
                text-decoration: none;
                transition: var(--transition);
            }

            .breadcrumb-item a:hover {
                color: var(--dark-color);
            }

            /* Header Section */
            .detail-header {
                background-color: var(--light-color);
                padding: 30px 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .experience-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 15px;
                color: var(--dark-color);
            }

            .experience-subtitle {
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
                margin-bottom: 20px;
                color: #6c757d;
            }

            .subtitle-item {
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
            }

            .subtitle-item i {
                color: var(--primary-color);
            }

            .category-badge {
                background: var(--gradient-secondary);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }

            .difficulty-badge {
                background: var(--gradient-primary);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .action-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border: 1px solid rgba(0,0,0,0.2);
                border-radius: 25px;
                background: white;
                text-decoration: none;
                color: var(--dark-color);
                transition: var(--transition);
                font-size: 0.9rem;
            }

            .action-btn:hover {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
                transform: translateY(-2px);
            }

            /* Image Gallery */
            .image-gallery {
                margin: 30px 0;
            }

            .swiper {
                width: 100%;
                height: 500px;
                border-radius: var(--border-radius);
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .swiper-slide img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .swiper-button-next,
            .swiper-button-prev {
                background: rgba(255,255,255,0.9);
                width: 40px;
                height: 40px;
                border-radius: 50%;
                margin: 0 15px;
            }

            .swiper-button-next:after,
            .swiper-button-prev:after {
                color: var(--dark-color);
                font-size: 16px;
                font-weight: bold;
            }

            .swiper-pagination-bullet {
                background: var(--primary-color);
                opacity: 0.5;
            }

            .swiper-pagination-bullet-active {
                opacity: 1;
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                margin: 40px 0;
            }

            .main-content {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
            }

            .sidebar {
                background: var(--light-color);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-sm);
                height: fit-content;
                position: sticky;
                top: 120px;
            }

            /* Content Sections */
            .content-section {
                margin-bottom: 40px;
                padding-bottom: 30px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .content-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.5rem;
                font-weight: 700;
                margin-bottom: 20px;
                color: var(--dark-color);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .section-title i {
                color: var(--primary-color);
                font-size: 1.3rem;
            }

            /* Host Info */
            .host-info-card {
                display: flex;
                align-items: center;
                gap: 20px;
                padding: 20px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 15px;
                margin-bottom: 20px;
            }

            .host-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 3px solid var(--secondary-color);
            }

            .host-details h4 {
                font-size: 1.2rem;
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .host-stats {
                display: flex;
                gap: 15px;
                margin-top: 10px;
            }

            .host-stat {
                font-size: 0.85rem;
                color: #6c757d;
            }

            /* Info Cards */
            .info-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .info-card {
                background: rgba(255, 56, 92, 0.05);
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                transition: var(--transition);
                border: 1px solid rgba(255, 56, 92, 0.1);
            }

            .info-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-md);
            }

            .info-card i {
                font-size: 2rem;
                color: var(--primary-color);
                margin-bottom: 10px;
            }

            .info-card h5 {
                font-size: 1.1rem;
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .info-card p {
                color: #6c757d;
                margin: 0;
                font-size: 0.9rem;
            }

            /* Included Items */
            .included-items {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .included-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 10px;
                transition: var(--transition);
            }

            .included-item:hover {
                background: rgba(131, 197, 190, 0.2);
                transform: translateX(5px);
            }

            .included-item i {
                color: var(--secondary-color);
                font-size: 1.1rem;
            }

            /* Enhanced Booking Card */
            .booking-card {
                border: 2px solid var(--primary-color);
                border-radius: var(--border-radius);
                padding: 25px;
                background: var(--light-color);
                box-shadow: var(--shadow-lg);
            }

            .price-display {
                text-align: center;
                margin-bottom: 25px;
            }

            .price-amount {
                font-size: 2rem;
                font-weight: 800;
                color: var(--primary-color);
                margin-bottom: 5px;
            }

            .price-unit {
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Enhanced Booking Form */
            .booking-form .form-group {
                margin-bottom: 20px;
                position: relative;
            }

            .booking-form label {
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
                display: block;
            }

            .booking-form .form-control {
                border-radius: 10px;
                padding: 12px;
                border: 2px solid rgba(0,0,0,0.1);
                transition: var(--transition);
                width: 100%;
                font-size: 0.95rem;
            }

            .booking-form .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
                outline: none;
            }

            /* Date input specific styling */
            .booking-form input[type="date"] {
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23FF385C' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3crect x='3' y='4' width='18' height='18' rx='2' ry='2'%3e%3c/rect%3e%3cline x1='16' y1='2' x2='16' y2='6'%3e%3c/line%3e%3cline x1='8' y1='2' x2='8' y2='6'%3e%3c/line%3e%3cline x1='3' y1='10' x2='21' y2='10'%3e%3c/line%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 20px;
                padding-right: 40px;
            }

            /* Date restriction notice */
            .date-restriction-notice {
                background: rgba(255, 165, 0, 0.1);
                border: 1px solid rgba(255, 165, 0, 0.3);
                color: #8B4513;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 15px;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .date-restriction-notice i {
                color: #FF8C00;
                font-size: 1rem;
            }

            /* Form validation styles */
            .form-control.is-valid {
                border-color: #28a745;
                padding-right: 2.25rem;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%2328a745' d='m2.3 6.73.79.76 3.25-3.24'/3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 0.75rem center;
                background-size: 1rem 1rem;
            }

            .form-control.is-invalid {
                border-color: #dc3545;
                padding-right: 2.25rem;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='%23dc3545' viewBox='-2 -2 7 7'%3e%3cpath stroke='%23dc3545' d='m0 0l3 3m0-3L0 3'/3e%3ccircle r='.5'/3e%3ccircle cx='3' r='.5'/3e%3ccircle cy='3' r='.5'/3e%3ccircle cx='3' cy='3' r='.5'/3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 0.75rem center;
                background-size: 1rem 1rem;
            }

            .valid-feedback {
                display: block;
                width: 100%;
                margin-top: 0.25rem;
                font-size: 0.8rem;
                color: #28a745;
            }

            .invalid-feedback {
                display: block;
                width: 100%;
                margin-top: 0.25rem;
                font-size: 0.8rem;
                color: #dc3545;
            }

            .warning-feedback {
                display: block;
                width: 100%;
                margin-top: 0.25rem;
                font-size: 0.8rem;
                color: #ffc107;
            }

            .booking-summary {
                background: rgba(131, 197, 190, 0.1);
                padding: 15px;
                border-radius: 10px;
                margin: 20px 0;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                font-size: 0.9rem;
            }

            .summary-total {
                font-weight: 700;
                font-size: 1.1rem;
                color: var(--dark-color);
                border-top: 1px solid rgba(0,0,0,0.2);
                padding-top: 10px;
                margin-top: 10px;
            }

            /* Contact Host Section */
            .contact-host-section {
                margin-top: 20px;
                padding: 20px;
                background: rgba(131, 197, 190, 0.05);
                border-radius: 15px;
                border: 1px solid rgba(131, 197, 190, 0.2);
            }

            .contact-host-section h6 {
                margin-bottom: 15px;
                color: var(--dark-color);
                font-weight: 600;
            }

            .contact-buttons {
                display: grid;
                gap: 10px;
            }

            .contact-buttons .btn {
                border-radius: 8px;
                padding: 10px 15px;
                font-size: 0.9rem;
                transition: var(--transition);
            }

            .contact-buttons .btn:hover {
                transform: translateY(-2px);
            }

            /* Safety Info */
            .safety-info {
                margin-top: 20px;
                padding: 20px;
                background: rgba(76, 181, 67, 0.05);
                border-radius: 15px;
                border: 1px solid rgba(76, 181, 67, 0.2);
            }

            .safety-info h6 {
                color: var(--dark-color);
                font-weight: 600;
                margin-bottom: 15px;
            }

            .safety-info ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .safety-info li {
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 0.9rem;
            }

            .safety-info .ri-check-line {
                color: #4BB543;
                font-size: 1.1rem;
            }

            /* Schedule Section */
            .schedule-item {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
                padding: 15px;
                background: rgba(0,0,0,0.02);
                border-radius: 10px;
                transition: var(--transition);
            }

            .schedule-item:hover {
                background: rgba(0,0,0,0.05);
            }

            .schedule-time {
                min-width: 80px;
                font-weight: 600;
                color: var(--primary-color);
                font-size: 0.9rem;
            }

            .schedule-content h6 {
                margin-bottom: 5px;
                color: var(--dark-color);
            }

            .schedule-content p {
                margin: 0;
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Reviews Section */
            .rating-overview {
                display: grid;
                grid-template-columns: auto 1fr;
                gap: 30px;
                margin-bottom: 30px;
            }

            .rating-score {
                text-align: center;
            }

            .rating-number {
                font-size: 3rem;
                font-weight: 800;
                color: var(--primary-color);
                margin-bottom: 10px;
            }

            .rating-stars {
                color: #FFD700;
                font-size: 1.2rem;
                margin-bottom: 5px;
            }

            .rating-breakdown {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .rating-bar {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .rating-bar-label {
                min-width: 60px;
                font-size: 0.9rem;
                color: #6c757d;
            }

            .progress {
                height: 8px;
                background: rgba(0,0,0,0.1);
                border-radius: 10px;
                overflow: hidden;
            }

            .progress-bar {
                background: var(--gradient-primary);
            }

            .review-item {
                background: rgba(0,0,0,0.02);
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 20px;
                transition: var(--transition);
            }

            .review-item:hover {
                background: rgba(0,0,0,0.05);
            }

            .review-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
            }

            .reviewer-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid var(--secondary-color);
            }

            .reviewer-info h6 {
                margin: 0;
                font-weight: 600;
                color: var(--dark-color);
            }

            .review-date {
                font-size: 0.8rem;
                color: #6c757d;
            }

            .review-rating {
                direction: ltr !important;
            }

            .review-rating i {
                color: #FFD700;
                font-size: 1.3rem;
            }

            /* Location Map */
            .map-container {
                height: 300px;
                background: rgba(131, 197, 190, 0.2);
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #6c757d;
                border: 2px dashed var(--secondary-color);
            }

            /* Enhanced Modal Styles */
            .modal-content {
                border-radius: 15px;
                border: none;
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }

            .modal-header {
                border-bottom: 1px solid rgba(0,0,0,0.1);
                padding: 20px 25px 15px;
            }

            .modal-body {
                padding: 25px;
            }

            .modal-footer {
                border-top: 1px solid rgba(0,0,0,0.1);
                padding: 15px 25px 20px;
            }

            .contact-info {
                margin-top: 20px;
            }

            .contact-item {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                padding: 10px;
                border-radius: 8px;
                transition: var(--transition);
            }

            .contact-item:hover {
                background: rgba(0,0,0,0.02);
            }

            .contact-icon {
                margin-right: 15px;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(255, 56, 92, 0.1);
                border-radius: 50%;
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

            .social-icons {
                margin-top: 20px;
            }

            .social-icons a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
                margin-right: 10px;
                color: white;
                font-size: 1.2rem;
                transition: var(--transition);
            }

            .social-icons a:hover {
                background: var(--primary-color);
                transform: translateY(-2px);
            }

            .copyright {
                text-align: center;
                margin-top: 40px;
                padding-top: 30px;
                border-top: 1px solid rgba(255,255,255,0.1);
                color: rgba(255,255,255,0.6);
            }

            /* Loading Animation */
            .loading {
                text-align: center;
                padding: 50px;
            }

            .spinner {
                width: 40px;
                height: 40px;
                border: 4px solid #f3f3f3;
                border-top: 4px solid var(--primary-color);
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin: 0 auto 20px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
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

            /* No image placeholder */
            .no-image-placeholder {
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background: rgba(131, 197, 190, 0.1);
                color: #6c757d;
            }

            .no-image-placeholder i {
                font-size: 3rem;
                margin-bottom: 10px;
            }

            /* Image loading states */
            img {
                transition: opacity 0.3s ease;
            }

            img.loaded {
                opacity: 1;
            }

            img:not(.loaded) {
                opacity: 0.7;
            }

            /* Responsive Design */
            @media (max-width: 1200px) {
                .container {
                    max-width: 1140px;
                }

                .content-grid {
                    gap: 30px;
                }
            }

            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .sidebar {
                    position: relative;
                    top: 0;
                    order: -1;
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

                .info-cards {
                    grid-template-columns: repeat(2, 1fr);
                }

                .rating-overview {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .experience-title {
                    font-size: 2rem;
                }

                .main-content,
                .sidebar {
                    padding: 25px;
                }
            }

            @media (max-width: 768px) {
                body {
                    padding-top: 120px;
                }

                .experience-title {
                    font-size: 1.8rem;
                }

                .experience-subtitle {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .action-buttons {
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .info-cards {
                    grid-template-columns: 1fr;
                }

                .custom-navbar {
                    padding: 10px 0;
                }

                .nav-center {
                    gap: 20px;
                    flex-wrap: wrap;
                }

                .price-amount {
                    font-size: 1.6rem;
                }

                .booking-card {
                    padding: 20px;
                }

                .host-info-card {
                    flex-direction: column;
                    text-align: center;
                }

                .host-stats {
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .included-items {
                    grid-template-columns: 1fr;
                }

                .swiper {
                    height: 300px;
                }

                .contact-buttons {
                    gap: 8px;
                }

                .contact-buttons .btn {
                    padding: 8px 12px;
                    font-size: 0.85rem;
                }
            }

            @media (max-width: 576px) {
                .container {
                    padding: 0 15px;
                }

                .main-content,
                .sidebar {
                    padding: 20px;
                }

                .schedule-item {
                    flex-direction: column;
                    gap: 10px;
                }

                .schedule-time {
                    min-width: auto;
                    font-size: 1rem;
                    margin-bottom: 5px;
                }

                .review-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .navbar-brand img {
                    height: 40px !important;
                }

                .navbar-brand {
                    font-size: 1.1rem;
                }

                .dropdown-menu-custom {
                    width: 200px;
                }

                .modal-dialog {
                    margin: 10px;
                }

                .modal-body {
                    padding: 20px;
                }

                .contact-host-section,
                .safety-info {
                    padding: 15px;
                }

                .date-restriction-notice {
                    padding: 10px;
                    font-size: 0.8rem;
                }
            }

            /* Print Styles */
            @media print {
                .custom-navbar,
                .footer,
                .action-buttons,
                .booking-card,
                .contact-host-section,
                .safety-info {
                    display: none !important;
                }

                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .main-content {
                    box-shadow: none;
                    border: 1px solid #ddd;
                }

                .swiper {
                    height: 300px;
                }

                body {
                    padding-top: 0;
                    font-size: 12pt;
                    line-height: 1.4;
                }

                .experience-title {
                    font-size: 24pt;
                }

                .section-title {
                    font-size: 18pt;
                }
            }

            /* =================================
               Weather Widget Styles
               ================================= */

            .weather-widget {
                background: linear-gradient(135deg, 
                    rgba(131, 197, 190, 0.1) 0%, 
                    rgba(255, 56, 92, 0.05) 100%),
                    var(--bg-primary);
                border-radius: var(--border-radius);
                padding: 20px;
                margin-top: 20px;
                border: 1px solid rgba(0,0,0,0.1);
                position: relative;
                overflow: hidden;
            }

            .weather-widget::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 80px;
                height: 80px;
                background: radial-gradient(circle, rgba(255, 56, 92, 0.1) 0%, transparent 70%);
                border-radius: 50%;
                pointer-events: none;
            }

            .weather-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 15px;
                position: relative;
                z-index: 1;
            }

            .weather-title {
                display: flex;
                align-items: center;
                gap: 8px;
                margin: 0;
                font-size: 1rem;
                font-weight: 600;
                color: var(--dark-color);
            }

            .weather-title i {
                font-size: 1.1rem;
                color: var(--primary-color);
            }

            .weather-refresh {
                background: none;
                border: none;
                color: #6c757d;
                cursor: pointer;
                padding: 5px;
                border-radius: 5px;
                transition: var(--transition);
            }

            .weather-refresh:hover {
                color: var(--primary-color);
                background: rgba(0,0,0,0.05);
                transform: rotate(180deg);
            }

            .weather-content {
                position: relative;
                z-index: 1;
            }

            .weather-loading {
                text-align: center;
                padding: 20px 0;
                color: #6c757d;
            }

            .weather-loading i {
                font-size: 1.5rem;
                animation: spin 2s linear infinite;
                color: var(--primary-color);
                margin-bottom: 10px;
            }

            .weather-error {
                text-align: center;
                padding: 15px;
                color: #dc3545;
                background: #f8d7da;
                border-radius: 8px;
                border: 1px solid #f5c6cb;
            }

            .weather-current {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 20px;
                padding: 15px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            .weather-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--primary-color), #FF6B6B);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.5rem;
                flex-shrink: 0;
                animation: float 3s ease-in-out infinite;
            }

            .weather-main {
                flex: 1;
            }

            .weather-temp {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--dark-color);
                line-height: 1;
                margin-bottom: 5px;
            }

            .weather-desc {
                font-size: 0.85rem;
                color: #6c757d;
                text-transform: capitalize;
                margin-bottom: 5px;
            }

            .weather-location {
                font-size: 0.75rem;
                color: #6c757d;
                display: flex;
                align-items: center;
                gap: 3px;
            }

            .weather-details {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                margin-bottom: 15px;
            }

            .weather-detail {
                background: white;
                padding: 10px;
                border-radius: 8px;
                text-align: center;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                border: 1px solid rgba(0,0,0,0.05);
            }

            .weather-detail i {
                font-size: 1rem;
                color: var(--secondary-color);
                margin-bottom: 5px;
            }

            .weather-detail-value {
                font-size: 1rem;
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 2px;
            }

            .weather-detail-label {
                font-size: 0.65rem;
                color: #6c757d;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .weather-forecast {
                margin-top: 15px;
            }

            .forecast-title {
                font-size: 0.9rem;
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .forecast-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .forecast-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px;
                background: white;
                border-radius: 8px;
                border: 1px solid rgba(0,0,0,0.05);
                transition: var(--transition);
            }

            .forecast-item:hover {
                border-color: rgba(0,0,0,0.1);
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            .forecast-date {
                font-size: 0.75rem;
                color: var(--dark-color);
                font-weight: 500;
                min-width: 35px;
            }

            .forecast-weather {
                display: flex;
                align-items: center;
                gap: 8px;
                flex: 1;
            }

            .forecast-icon {
                width: 20px;
                height: 20px;
                border-radius: 4px;
                background: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
                color: #6c757d;
            }

            .forecast-desc {
                font-size: 0.7rem;
                color: #6c757d;
                text-transform: capitalize;
            }

            .forecast-temp {
                font-size: 0.75rem;
                font-weight: 600;
                color: var(--dark-color);
                text-align: right;
                min-width: 40px;
            }

            .weather-quality {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 0.65rem;
                font-weight: 500;
                margin-top: 5px;
            }

            .weather-quality.excellent {
                background: #d4edda;
                color: #155724;
            }

            .weather-quality.good {
                background: #fff3cd;
                color: #856404;
            }

            .weather-quality.poor {
                background: #f8d7da;
                color: #721c24;
            }

            .weather-attribution {
                margin-top: 15px;
                padding-top: 10px;
                border-top: 1px solid rgba(0,0,0,0.1);
                text-align: center;
            }

            .weather-attribution a {
                color: #6c757d;
                text-decoration: none;
                font-size: 0.65rem;
                transition: var(--transition);
            }

            .weather-attribution a:hover {
                color: var(--primary-color);
            }

            /* Weather Animations */
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }

            @keyframes float {
                0%, 100% { transform: translateY(0px); }
                50% { transform: translateY(-4px); }
            }

            /* Weather Themes */
            .weather-widget.sunny {
                background: linear-gradient(135deg, 
                    rgba(251, 191, 36, 0.1) 0%, 
                    rgba(245, 158, 11, 0.05) 100%);
            }

            .weather-widget.rainy {
                background: linear-gradient(135deg, 
                    rgba(59, 130, 246, 0.1) 0%, 
                    rgba(37, 99, 235, 0.05) 100%);
            }

            .weather-widget.stormy {
                background: linear-gradient(135deg, 
                    rgba(75, 85, 99, 0.1) 0%, 
                    rgba(55, 65, 81, 0.05) 100%);
            }

            /* High Contrast Mode Support */
            @media (prefers-contrast: high) {
                :root {
                    --primary-color: #FF0000;
                    --secondary-color: #0000FF;
                    --dark-color: #000000;
                    --light-color: #FFFFFF;
                }

                .btn-primary {
                    background: #FF0000;
                    color: #FFFFFF;
                }

                .btn-outline-primary {
                    border-color: #FF0000;
                    color: #FF0000;
                }

                .form-control:focus {
                    border-color: #FF0000;
                    box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.2);
                }
            }

            /* Reduced Motion Support */
            @media (prefers-reduced-motion: reduce) {
                *,
                *::before,
                *::after {
                    animation-duration: 0.01ms !important;
                    animation-iteration-count: 1 !important;
                    transition-duration: 0.01ms !important;
                }

                .fade-up {
                    opacity: 1;
                    transform: none;
                }

                .btn:hover {
                    transform: none;
                }

                .action-btn:hover {
                    transform: none;
                }
            }

            /* Dark mode support */
            @media (prefers-color-scheme: dark) {
                :root {
                    --accent-color: #1a1a1a;
                    --light-color: #2d2d2d;
                    --dark-color: #ffffff;
                }

                body {
                    background-color: var(--accent-color);
                    color: var(--dark-color);
                }

                .main-content,
                .sidebar,
                .booking-card {
                    background-color: var(--light-color);
                    color: var(--dark-color);
                }

                .form-control {
                    background-color: var(--light-color);
                    color: var(--dark-color);
                    border-color: rgba(255,255,255,0.2);
                }

                .breadcrumb-container,
                .detail-header {
                    background-color: var(--light-color);
                }
            }

            /* Focus indicators for better accessibility */
            .btn:focus,
            .form-control:focus,
            .action-btn:focus {
                outline: 2px solid var(--primary-color);
                outline-offset: 2px;
            }

            /* Screen reader only content */
            .sr-only {
                position: absolute;
                width: 1px;
                height: 1px;
                padding: 0;
                margin: -1px;
                overflow: hidden;
                clip: rect(0, 0, 0, 0);
                white-space: nowrap;
                border: 0;
            }

            /* Improve text readability */
            .text-muted {
                color: #6c757d !important;
            }

            .text-success {
                color: #28a745 !important;
            }

            /* Enhanced error states */
            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 16px;
                border: 1px solid transparent;
            }

            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }

            .alert-warning {
                color: #856404;
                background-color: #fff3cd;
                border-color: #ffeaa7;
            }

            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
            }

            /* Utility classes */
            .d-none {
                display: none !important;
            }

            .d-block {
                display: block !important;
            }

            .d-flex {
                display: flex !important;
            }

            .d-grid {
                display: grid !important;
            }

            .w-100 {
                width: 100% !important;
            }

            .text-center {
                text-align: center !important;
            }

            .me-2 {
                margin-right: 0.5rem !important;
            }

            .me-3 {
                margin-right: 1rem !important;
            }

            .mb-3 {
                margin-bottom: 1rem !important;
            }

            .mb-4 {
                margin-bottom: 1.5rem !important;
            }

            .gap-2 {
                gap: 0.5rem !important;
            }

            /* List styling */
            .list-unstyled {
                padding-left: 0;
                list-style: none;
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
                    <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                        Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item active">
                        Trải Nghiệm
                    </a>
                    <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item">
                        Lưu Trú
                    </a>
                </div>

                <div class="nav-right">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                                    <i class="ri-user-line" style="color: white;"></i> 
                                    ${sessionScope.user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                                <i class="ri-dashboard-line"></i> Quản Trị
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:if test="${sessionScope.user.role == 'HOST'}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/dashboard">
                                                <i class="ri-dashboard-line"></i> Quản Lý Host
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/host/bookings/manage">
                                                <i class="ri-calendar-check-line"></i> Quản Lý Booking
                                            </a>
                                        </li>
                                    </c:if>

                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="color: #10466C;">
                                            <i class="ri-user-settings-line" style="color: #10466C;"></i> Hồ Sơ
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color: #10466C;">
                                            <i class="ri-logout-circle-r-line" style="color: #10466C;"></i> Đăng Xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="#become-host" class="me-3">Trở thành host</a>
                            <i class="ri-global-line globe-icon me-3"></i>
                            <div class="menu-icon">
                                <i class="ri-menu-line"></i>
                                <div class="dropdown-menu-custom">
                                    <a href="#help-center">
                                        <i class="ri-question-line" style="color: #10466C;"></i>Trung tâm Trợ giúp
                                    </a>
                                    <a href="#contact">
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

        <!-- Breadcrumb -->
        <div class="breadcrumb-container">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="ri-home-line me-1"></i>Trang Chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/experiences">Trải Nghiệm</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            ${experience.title}
                        </li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Header Section -->
        <section class="detail-header">
            <div class="container">
                <div class="fade-up">
                    <h1 class="experience-title">${experience.title}</h1>

                    <div class="experience-subtitle">
                        <div class="subtitle-item">
                            <i class="ri-star-fill"></i>
                            <c:choose>
                                <c:when test="${experience.averageRating > 0}">
                                    <span><fmt:formatNumber value="${experience.averageRating}" maxFractionDigits="1" /></span>
                                    <span>(${experience.totalBookings} đánh giá)</span>
                                </c:when>
                                <c:otherwise>
                                    <span>Chưa có đánh giá</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="subtitle-item">
                            <i class="ri-map-pin-line"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty experience.cityName}">
                                        ${experience.cityName}, ${experience.location}
                                    </c:when>
                                    <c:otherwise>
                                        ${experience.location}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <c:if test="${not empty experience.categoryName}">
                            <span class="category-badge">
                                <c:choose>
                                    <c:when test="${experience.categoryName == 'Food'}">Ẩm Thực</c:when>
                                    <c:when test="${experience.categoryName == 'Culture'}">Văn Hóa</c:when>
                                    <c:when test="${experience.categoryName == 'Adventure'}">Phiêu Lưu</c:when>
                                    <c:when test="${experience.categoryName == 'History'}">Lịch Sử</c:when>
                                    <c:otherwise>${experience.categoryName}</c:otherwise>
                                </c:choose>
                            </span>
                        </c:if>

                        <c:if test="${not empty experience.difficulty}">
                            <span class="difficulty-badge">
                                <c:choose>
                                    <c:when test="${experience.difficulty == 'Easy'}">Dễ</c:when>
                                    <c:when test="${experience.difficulty == 'Medium'}">Trung Bình</c:when>
                                    <c:when test="${experience.difficulty == 'Hard'}">Khó</c:when>
                                    <c:otherwise>${experience.difficulty}</c:otherwise>
                                </c:choose>
                            </span>
                        </c:if>
                    </div>

                    <div class="action-buttons">
                        <a href="#" class="action-btn" onclick="shareExperience()">
                            <i class="ri-share-line"></i>
                            <span>Chia sẻ</span>
                        </a>
                        <a href="#" class="action-btn" onclick="saveExperience()">
                            <i class="ri-heart-line"></i>
                            <span>Lưu</span>
                        </a>
                        <a href="#" class="action-btn" onclick="openReviewModal(); return false;">
                            <i class="ri-chat-3-line"></i>
                            <span>Đánh giá</span>
                        </a>
                        <a href="#schedule" class="action-btn">
                            <i class="ri-calendar-line"></i>
                            <span>Lịch trình</span>
                        </a>
                        <!-- Nút Báo cáo -->
                        <a href="#" class="action-btn" onclick="openReportModal(); return false;">
                            <i class="ri-flag-2-line"></i>
                            <span>Báo cáo</span>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Image Gallery -->
        <div class="container">
            <div class="image-gallery fade-up">
                <div class="swiper experience-swiper">
                    <div class="swiper-wrapper">
                        <c:choose>
                            <c:when test="${not empty experience.images}">
                                <c:set var="imageList" value="${fn:split(experience.images, ',')}" />
                                <c:forEach var="image" items="${imageList}">
                                    <div class="swiper-slide">
                                        <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(image)}" 
                                             alt="${experience.title}" 
                                             onerror="this.src='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1552832230-c0197047daf1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${experience.title}">
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="content-grid fade-up">
                <!-- Main Content -->
                <div class="main-content">
                    <!-- Host Information -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-user-star-line"></i>
                            Hướng dẫn viên ${experience.hostName}
                        </h3>

                        <div class="host-info-card">
                            <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                 alt="Host Avatar" class="host-avatar">
                            <div class="host-details">
                                <h4>${experience.hostName}</h4>
                                <p class="text-muted">Hướng dẫn viên địa phương • Tham gia từ 2023</p>
                                <div class="host-stats">
                                    <span class="host-stat">
                                        <i class="ri-star-fill" style="color: #FFD700;"></i>
                                        4.9 (156 đánh giá)
                                    </span>
                                    <span class="host-stat">
                                        <i class="ri-check-line" style="color: #4BB543;"></i>
                                        Đã xác minh danh tính
                                    </span>
                                    <span class="host-stat">
                                        <i class="ri-time-line" style="color: var(--primary-color);"></i>
                                        Phản hồi trong 1 giờ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Experience Info -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin trải nghiệm
                        </h3>

                        <div class="info-cards">
                            <div class="info-card">
                                <i class="ri-time-line"></i>
                                <h5>
                                    <c:choose>
                                        <c:when test="${not empty experience.duration}">
                                            <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                        </c:when>
                                        <c:otherwise>
                                            Cả ngày
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <p>Thời gian</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-group-line"></i>
                                <h5>${experience.maxGroupSize} người</h5>
                                <p>Tối đa</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-global-line"></i>
                                <h5>Tiếng Việt</h5>
                                <p>Ngôn ngữ</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-calendar-line"></i>
                                <h5>Linh hoạt</h5>
                                <p>Lịch trình</p>
                            </div>
                        </div>

                        <p style="font-size: 1.1rem; line-height: 1.7; color: var(--dark-color);">
                            ${experience.description}
                        </p>
                    </div>

                    <!-- What's Included -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-check-line"></i>
                            Bao gồm trong trải nghiệm
                        </h3>

                        <div class="included-items">
                            <c:choose>
                                <c:when test="${not empty experience.includedItems}">
                                    <c:set var="itemList" value="${fn:split(experience.includedItems, ',')}" />
                                    <c:forEach var="item" items="${itemList}">
                                        <div class="included-item">
                                            <i class="ri-check-line"></i>
                                            <span>${fn:trim(item)}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="included-item">
                                        <i class="ri-user-line"></i>
                                        <span>Hướng dẫn viên địa phương</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-camera-line"></i>
                                        <span>Chụp ảnh miễn phí</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-drink-line"></i>
                                        <span>Nước uống</span>
                                    </div>
                                    <div class="included-item">
                                        <i class="ri-book-line"></i>
                                        <span>Tài liệu hướng dẫn</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Schedule Section -->
                    <div class="content-section" id="schedule">
                        <h3 class="section-title">
                            <i class="ri-calendar-line"></i>
                            Lịch trình chi tiết
                        </h3>

                        <div class="schedule-item">
                            <div class="schedule-time">09:00</div>
                            <div class="schedule-content">
                                <h6>Gặp mặt và làm quen</h6>
                                <p>Gặp gỡ hướng dẫn viên tại điểm hẹn, giới thiệu về trải nghiệm và các thành viên trong nhóm.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">09:30</div>
                            <div class="schedule-content">
                                <h6>Bắt đầu trải nghiệm</h6>
                                <p>Khởi hành và tham gia hoạt động chính. Hướng dẫn viên sẽ chia sẻ kiến thức địa phương và văn hóa.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">11:00</div>
                            <div class="schedule-content">
                                <h6>Nghỉ giải lao</h6>
                                <p>Thời gian nghỉ ngơi, thưởng thức đồ uống và chụp ảnh kỷ niệm.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">11:30</div>
                            <div class="schedule-content">
                                <h6>Tiếp tục khám phá</h6>
                                <p>Tham gia các hoạt động thú vị và tìm hiểu thêm về văn hóa bản địa.</p>
                            </div>
                        </div>

                        <div class="schedule-item">
                            <div class="schedule-time">12:30</div>
                            <div class="schedule-content">
                                <h6>Kết thúc trải nghiệm</h6>
                                <p>Tổng kết trải nghiệm, chia sẻ cảm nhận và chào tạm biệt.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="content-section" id="reviews">
                        <h3 class="section-title">
                            <i class="ri-star-line"></i>
                            Đánh giá từ khách hàng
                        </h3>
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="review" items="${reviews}">
                                    <div class="review-item">
                                        <div class="review-header">
                                            <img src="${not empty review.travelerAvatar ? pageContext.request.contextPath.concat('/images/avatars/').concat(review.travelerAvatar) : 'https://cdn.sforum.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg'}" 
                                                 alt="Reviewer" class="reviewer-avatar"
                                                 onerror="this.src='https://cdn.sforum.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg'">
                                            <div class="reviewer-info">
                                                <h6>${review.travelerName}</h6>
                                                <div class="review-date">
                                                    <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                                </div>
                                            </div>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="${i <= review.rating ? 'ri-star-fill' : 'ri-star-line'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p>${review.comment}</p>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="ri-chat-3-line" style="font-size: 3rem; color: #6c757d; margin-bottom: 20px;"></i>
                                    <h5>Chưa có đánh giá nào</h5>
                                    <p class="text-muted">Hãy là người đầu tiên đánh giá trải nghiệm này!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Location Section -->
                    <div class="content-section" id="location">
                        <h3 class="section-title">
                            <i class="ri-map-pin-line"></i>
                            Địa điểm
                        </h3>

                        <div class="location-info mb-3">
                            <p class="mb-2">
                                <strong>Điểm hẹn:</strong> 
                                <span id="locationText">${experience.location}<c:if test="${not empty experience.cityName}">, ${experience.cityName}</c:if></span>
                                <button class="btn btn-link btn-sm p-0 ms-2" onclick="copyLocation()" title="Copy địa chỉ">
                                    <i class="ri-file-copy-line"></i>
                                </button>
                            </p>
                            <div class="location-actions">
                                <small class="text-muted">
                                    <a href="javascript:void(0)" onclick="openInZalo()" class="text-decoration-none me-3">
                                        <i class="ri-smartphone-line me-1"></i>Zalo Map
                                    </a>
                                    <a href="javascript:void(0)" onclick="openInAppleMaps()" class="text-decoration-none me-3">
                                        <i class="ri-map-2-line me-1"></i>Apple Maps
                                    </a>
                                    <a href="javascript:void(0)" onclick="copyLocation()" class="text-decoration-none">
                                        <i class="ri-file-copy-line me-1"></i>Copy địa chỉ
                                    </a>
                                </small>
                            </div>
                        </div>

                        <!-- Map Container -->
                        <div class="map-container mb-3">
                            <!-- Enhanced Google Maps Embed - NO API KEY NEEDED -->
                            <iframe 
                                src="https://www.google.com/maps?q=${fn:escapeXml(experience.location)}${not empty experience.cityName ? ', ' : ''}${fn:escapeXml(experience.cityName)}, Việt Nam&output=embed&zoom=15" 
                                width="100%" 
                                height="400" 
                                style="border:0; border-radius: 10px;" 
                                allowfullscreen="" 
                                loading="lazy" 
                                referrerpolicy="no-referrer-when-downgrade"
                                title="Bản đồ ${experience.title}">
                            </iframe>
                            <!-- Fallback for when iframe fails -->
                            <div id="mapFallback" style="display: none; background: #f8f9fa; height: 400px; border-radius: 10px; border: 1px solid #ddd;">
                                <div class="d-flex align-items-center justify-content-center h-100">
                                    <div class="text-center">
                                        <i class="ri-map-pin-line" style="font-size: 3rem; color: #FF385C; margin-bottom: 15px;"></i>
                                        <h5>Bản đồ không khả dụng</h5>
                                        <p class="text-muted mb-3">${experience.location}<c:if test="${not empty experience.cityName}">, ${experience.cityName}</c:if></p>
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                            <button class="btn btn-outline-primary btn-sm" onclick="openInGoogleMaps()">
                                                <i class="ri-external-link-line me-1"></i>Mở Google Maps
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm" onclick="copyLocation()">
                                                <i class="ri-file-copy-line me-1"></i>Copy địa chỉ
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Map Actions -->
                        <div class="map-actions mb-3">
                            <div class="row">
                                <div class="col-12">
                                    <button type="button" class="btn btn-primary btn-lg w-100" onclick="openGoogleMapsDirections()">
                                        <i class="ri-direction-line me-2"></i>Chỉ đường
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar - Booking Card -->
                <div class="sidebar">
                    <div class="booking-card">
                        <div class="price-display">
                            <div class="price-amount">
                                <c:choose>
                                    <c:when test="${experience.price == 0}">
                                        Miễn phí
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="price-unit">mỗi người</div>
                        </div>
                        <form class="booking-form" action="${pageContext.request.contextPath}/booking" method="get">
                            <input type="hidden" name="experienceId" value="${experience.experienceId}">
                            <input type="hidden" name="bookingDate" id="hiddenBookingDate">
                            <input type="hidden" name="participants" id="hiddenParticipants">
                            <input type="hidden" name="timeSlot" id="hiddenTimeSlot">

                            <div class="form-group">
                                <label for="bookingDate">Ngày tham gia</label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="form-group">
                                <label for="participants">Số người tham gia</label>
                                <select class="form-control" id="participants" name="participants" required>
                                    <option value="">Chọn số người</option>
                                    <c:forEach begin="1" end="${experience.maxGroupSize}" var="i">
                                        <option value="${i}">${i} người</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="booking-summary" id="bookingSummary" style="display: none;">
                                <div class="summary-row">
                                    <span>Giá × <span id="participantCount">0</span> người</span>
                                    <span id="totalPrice">0 VNĐ</span>
                                </div>
                                <div class="summary-row">
                                    <span>Phí dịch vụ</span>
                                    <span id="serviceFee">0 VNĐ</span>
                                </div>
                                <div class="summary-row summary-total">
                                    <span>Tổng cộng</span>
                                    <span id="finalTotal">0 VNĐ</span>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="ri-calendar-check-line me-2"></i>Đặt Ngay
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary w-100">
                                        <i class="ri-login-circle-line me-2"></i>Đăng Nhập để Đặt
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </form>

                        </form>

                        <div class="text-center mt-3">
                            <small class="text-muted">Bạn sẽ chưa bị tính phí</small>
                        </div>

                        <div class="text-center mt-3">
                            <button class="btn-copy w-100" onclick="shareExperience()">
                                <i class="ri-share-line"></i>
                                <span>Chia sẻ trải nghiệm này</span>
                            </button>
                        </div>
                    </div>

                    <!-- Sửa lại phần contact host trong sidebar -->
                    <div class="contact-host-section">
                        <h6 class="mb-3">Liên hệ hướng dẫn viên</h6>
                        <div class="contact-buttons">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.userId == experience.hostId}">
                                            <button class="btn btn-secondary btn-sm" disabled>
                                                <i class="ri-user-line me-2"></i>Đây là trải nghiệm của bạn
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary btn-sm btn-chat chat-pulse" 
                                                    onclick="chatWithHost()"
                                                    data-host-id="${experience.hostId}"
                                                    data-experience-id="${experience.experienceId}"
                                                    data-current-user-id="${sessionScope.user.userId}">
                                                <i class="ri-message-3-line me-2"></i>Chat với Host
                                            </button>
                                            <button class="btn btn-outline-primary btn-sm" onclick="showContactInfo()">
                                                <i class="ri-phone-line me-2"></i>Thông tin liên hệ
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login?redirect=chat&experienceId=${experience.experienceId}" 
                                       class="btn btn-primary btn-sm">
                                        <i class="ri-message-3-line me-2"></i>Đăng nhập để Chat
                                    </a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="showLoginRequired()">
                                        <i class="ri-phone-line me-2"></i>Thông tin liên hệ
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Weather Widget -->
                    <div class="weather-widget">
                        <div class="weather-header">
                            <h6 class="weather-title">
                                <i class="ri-sun-line"></i>
                                Thời tiết tại điểm đến
                            </h6>
                            <button class="weather-refresh" onclick="refreshWeather()" title="Cập nhật thời tiết">
                                <i class="ri-refresh-line"></i>
                            </button>
                        </div>
                        <div class="weather-content" id="weatherContent">
                            <div class="weather-loading">
                                <i class="ri-loader-4-line"></i>
                                <div>Đang tải thông tin thời tiết...</div>
                            </div>
                        </div>
                    </div>

                    <div class="safety-info">
                        <h6 class="mb-3">
                            <i class="ri-shield-check-line me-2"></i>An toàn & Bảo mật
                        </h6>
                        <ul class="list-unstyled mb-0">
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Thanh toán an toàn
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Hướng dẫn viên đã xác minh
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Hỗ trợ 24/7
                            </li>
                            <li>
                                <i class="ri-check-line text-success me-2"></i>
                                Chính sách hủy linh hoạt
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
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
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
        <script>
                                        // Global variables
                                        let swiper;
                                        const MAX_BOOKING_DAYS = 60; // 60 days advance booking limit

// Dropdown menu functionality
                                        const menuIcon = document.querySelector('.menu-icon');
                                        const dropdownMenu = document.querySelector('.dropdown-menu-custom');

                                        if (menuIcon && dropdownMenu) {
                                            menuIcon.addEventListener('click', function (e) {
                                                e.stopPropagation();
                                                dropdownMenu.classList.toggle('show');
                                            });

                                            document.addEventListener('click', function () {
                                                dropdownMenu.classList.remove('show');
                                            });

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

// Initialize Swiper
                                        function initializeSwiper() {
                                            swiper = new Swiper('.experience-swiper', {
                                                loop: true,
                                                autoplay: {
                                                    delay: 4000,
                                                    disableOnInteraction: false,
                                                },
                                                pagination: {
                                                    el: '.swiper-pagination',
                                                    clickable: true,
                                                },
                                                navigation: {
                                                    nextEl: '.swiper-button-next',
                                                    prevEl: '.swiper-button-prev',
                                                },
                                                effect: 'fade',
                                                fadeEffect: {
                                                    crossFade: true
                                                },
                                                lazy: true,
                                                preloadImages: false,
                                                watchSlidesProgress: true,
                                                on: {
                                                    init: function () {
                                                        console.log('Swiper initialized');
                                                    },
                                                    slideChange: function () {
                                                        // Optional: track slide changes for analytics
                                                    }
                                                }
                                            });
                                        }

// Enhanced booking form functionality
                                        class BookingFormManager {
                                            constructor() {
                                                this.bookingDateInput = document.getElementById('bookingDate');
                                                this.participantsSelect = document.getElementById('participants');
                                                this.bookingSummary = document.getElementById('bookingSummary');
                                                this.form = document.querySelector('.booking-form');

                                                // Get price from page content
                                                const priceElement = document.querySelector('.price-amount');
                                                if (priceElement) {
                                                    const priceText = priceElement.textContent.replace(/[^\d]/g, '');
                                                    this.pricePerPerson = parseInt(priceText) || 0;
                                                } else {
                                                    this.pricePerPerson = 0;
                                                }

                                                this.init();
                                            }

                                            init() {
                                                this.setupDateRestrictions();
                                                this.bindEvents();
                                                this.addDateRestrictionNotice();
                                            }

                                            setupDateRestrictions() {
                                                if (!this.bookingDateInput)
                                                    return;

                                                const today = new Date();
                                                const maxDate = new Date();
                                                maxDate.setDate(today.getDate() + MAX_BOOKING_DAYS);

                                                // Set minimum date to tomorrow
                                                const tomorrow = new Date(today);
                                                tomorrow.setDate(today.getDate() + 1);

                                                this.bookingDateInput.min = this.formatDate(tomorrow);
                                                this.bookingDateInput.max = this.formatDate(maxDate);
                                            }

                                            addDateRestrictionNotice() {
                                                if (!this.bookingDateInput)
                                                    return;

                                                const notice = document.createElement('div');
                                                notice.className = 'date-restriction-notice';
                                                notice.innerHTML =
                                                        '<i class="ri-information-line"></i>' +
                                                        '<span>Bạn có thể đặt trước từ ngày mai đến ' + MAX_BOOKING_DAYS + ' ngày tới.</span>';

                                                this.bookingDateInput.parentNode.insertBefore(notice, this.bookingDateInput);
                                            }

                                            bindEvents() {
                                                if (this.bookingDateInput) {
                                                    this.bookingDateInput.addEventListener('change', () => this.validateAndCalculate());
                                                    this.bookingDateInput.addEventListener('blur', () => this.validateDate());
                                                }

                                                if (this.participantsSelect) {
                                                    this.participantsSelect.addEventListener('change', () => this.validateAndCalculate());
                                                }

                                                if (this.form) {
                                                    this.form.addEventListener('submit', (e) => this.handleSubmit(e));
                                                }
                                            }

                                            validateDate() {
                                                if (!this.bookingDateInput.value)
                                                    return true;

                                                const selectedDate = new Date(this.bookingDateInput.value);
                                                const today = new Date();
                                                const tomorrow = new Date(today);
                                                tomorrow.setDate(today.getDate() + 1);
                                                const maxDate = new Date(today);
                                                maxDate.setDate(today.getDate() + MAX_BOOKING_DAYS);

                                                // Reset validation state
                                                this.clearFieldValidation(this.bookingDateInput);

                                                if (selectedDate < tomorrow) {
                                                    this.setFieldError(this.bookingDateInput, 'Ngày tham gia phải từ ngày mai trở đi');
                                                    return false;
                                                }

                                                if (selectedDate > maxDate) {
                                                    this.setFieldError(this.bookingDateInput, 'Chỉ có thể đặt trước tối đa ' + MAX_BOOKING_DAYS + ' ngày');
                                                    return false;
                                                }

                                                // Check if selected date is a weekend (optional restriction)
                                                const dayOfWeek = selectedDate.getDay();
                                                if (dayOfWeek === 0 || dayOfWeek === 6) {
                                                    // Just a warning, not an error
                                                    this.setFieldWarning(this.bookingDateInput, 'Lưu ý: Ngày cuối tuần có thể có thêm phụ phí');
                                                } else {
                                                    this.setFieldValid(this.bookingDateInput);
                                                }

                                                return true;
                                            }

                                            validateParticipants() {
                                                if (!this.participantsSelect.value)
                                                    return false;

                                                const participants = parseInt(this.participantsSelect.value);
                                                this.clearFieldValidation(this.participantsSelect);

                                                if (participants < 1) {
                                                    this.setFieldError(this.participantsSelect, 'Số người tham gia phải ít nhất 1 người');
                                                    return false;
                                                }

                                                this.setFieldValid(this.participantsSelect);
                                                return true;
                                            }

                                            validateAndCalculate() {
                                                const isDateValid = this.validateDate();
                                                const isParticipantsValid = this.validateParticipants();

                                                if (isDateValid && isParticipantsValid && this.bookingDateInput.value && this.participantsSelect.value) {
                                                    this.calculateTotal();
                                                    this.showBookingSummary();
                                                } else {
                                                    this.hideBookingSummary();
                                                }
                                            }

                                            calculateTotal() {
                                                const participants = parseInt(this.participantsSelect.value);
                                                const selectedDate = new Date(this.bookingDateInput.value);
                                                const dayOfWeek = selectedDate.getDay();

                                                let basePrice = participants * this.pricePerPerson;

                                                // Weekend surcharge (10% extra for Saturday and Sunday)
                                                let weekendSurcharge = 0;
                                                if (dayOfWeek === 0 || dayOfWeek === 6) {
                                                    weekendSurcharge = Math.round(basePrice * 0.1);
                                                }

                                                const totalPrice = basePrice + weekendSurcharge;
                                                const serviceFee = Math.round(totalPrice * 0.05); // 5% service fee
                                                const finalTotal = totalPrice + serviceFee;

                                                // Update display
                                                const participantCountEl = document.getElementById('participantCount');
                                                const totalPriceEl = document.getElementById('totalPrice');
                                                const serviceFeeEl = document.getElementById('serviceFee');
                                                const finalTotalEl = document.getElementById('finalTotal');

                                                if (participantCountEl)
                                                    participantCountEl.textContent = participants;
                                                if (totalPriceEl)
                                                    totalPriceEl.textContent = this.formatCurrency(basePrice);
                                                if (serviceFeeEl)
                                                    serviceFeeEl.textContent = this.formatCurrency(serviceFee);
                                                if (finalTotalEl)
                                                    finalTotalEl.textContent = this.formatCurrency(finalTotal);

                                                // Show weekend surcharge if applicable
                                                this.updateWeekendSurcharge(weekendSurcharge);
                                            }

                                            updateWeekendSurcharge(surcharge) {
                                                let surchargeRow = document.getElementById('weekendSurchargeRow');

                                                if (surcharge > 0) {
                                                    if (!surchargeRow) {
                                                        surchargeRow = document.createElement('div');
                                                        surchargeRow.id = 'weekendSurchargeRow';
                                                        surchargeRow.className = 'summary-row';
                                                        surchargeRow.innerHTML =
                                                                '<span>Phụ phí cuối tuần</span>' +
                                                                '<span id="weekendSurcharge">0 VNĐ</span>';
                                                        // Insert before service fee row
                                                        const serviceFeeRow = document.querySelector('.summary-row:nth-child(2)');
                                                        if (serviceFeeRow) {
                                                            serviceFeeRow.parentNode.insertBefore(surchargeRow, serviceFeeRow);
                                                        }
                                                    }
                                                    const weekendSurchargeEl = document.getElementById('weekendSurcharge');
                                                    if (weekendSurchargeEl) {
                                                        weekendSurchargeEl.textContent = this.formatCurrency(surcharge);
                                                    }
                                                    surchargeRow.style.display = 'flex';
                                                } else if (surchargeRow) {
                                                    surchargeRow.style.display = 'none';
                                                }
                                            }

                                            showBookingSummary() {
                                                if (this.bookingSummary) {
                                                    this.bookingSummary.style.display = 'block';
                                                    this.bookingSummary.classList.add('fade-up', 'active');
                                                }
                                            }

                                            hideBookingSummary() {
                                                if (this.bookingSummary) {
                                                    this.bookingSummary.style.display = 'none';
                                                }
                                            }

                                            handleSubmit(e) {
                                                e.preventDefault();

                                                // Final validation
                                                const isDateValid = this.validateDate();
                                                const isParticipantsValid = this.validateParticipants();

                                                if (!isDateValid || !isParticipantsValid) {
                                                    showToast('Vui lòng kiểm tra lại thông tin đặt chỗ', 'error');
                                                    return;
                                                }

                                                if (!this.bookingDateInput.value || !this.participantsSelect.value) {
                                                    showToast('Vui lòng điền đầy đủ thông tin đặt chỗ', 'error');
                                                    return;
                                                }

                                                // Show loading state
                                                const submitBtn = this.form.querySelector('button[type="submit"]');
                                                if (submitBtn) {
                                                    const originalText = submitBtn.innerHTML;
                                                    submitBtn.innerHTML = '<i class="ri-loader-2-line"></i> Đang xử lý...';
                                                    submitBtn.disabled = true;
                                                    submitBtn.classList.add('loading');

                                                    // Simulate processing delay (remove in production)
                                                    setTimeout(() => {
                                                        this.form.submit();
                                                    }, 1000);
                                                }
                                            }

                                            setFieldError(field, message) {
                                                field.classList.remove('is-valid');
                                                field.classList.add('is-invalid');
                                                this.setFieldFeedback(field, message, 'invalid-feedback');
                                            }

                                            setFieldWarning(field, message) {
                                                field.classList.remove('is-invalid', 'is-valid');
                                                this.setFieldFeedback(field, message, 'warning-feedback');
                                            }

                                            setFieldValid(field) {
                                                field.classList.remove('is-invalid');
                                                field.classList.add('is-valid');
                                                this.clearFieldFeedback(field);
                                            }

                                            clearFieldValidation(field) {
                                                field.classList.remove('is-valid', 'is-invalid');
                                                this.clearFieldFeedback(field);
                                            }

                                            setFieldFeedback(field, message, className) {
                                                this.clearFieldFeedback(field);
                                                const feedback = document.createElement('div');
                                                feedback.className = className;
                                                feedback.textContent = message;
                                                field.parentNode.appendChild(feedback);
                                            }

                                            clearFieldFeedback(field) {
                                                const existingFeedback = field.parentNode.querySelectorAll('.invalid-feedback, .valid-feedback, .warning-feedback');
                                                existingFeedback.forEach(el => el.remove());
                                            }

                                            formatDate(date) {
                                                return date.toISOString().split('T')[0];
                                            }

                                            formatCurrency(amount) {
                                                return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                            }
                                        }

// Share experience function
                                        function shareExperience() {
                                            const url = window.location.href;
                                            const experienceTitleEl = document.querySelector('.experience-title');
                                            const experienceTitle = experienceTitleEl ? experienceTitleEl.textContent : 'Trải nghiệm VietCulture';
                                            const shareText = 'Khám phá "' + experienceTitle + '" tại VietCulture: ' + url;

                                            if (navigator.share) {
                                                navigator.share({
                                                    title: experienceTitle,
                                                    text: 'Khám phá "' + experienceTitle + '" tại VietCulture',
                                                    url: url
                                                }).catch(err => console.log('Error sharing:', err));
                                            } else if (navigator.clipboard) {
                                                navigator.clipboard.writeText(shareText)
                                                        .then(() => {
                                                            showToast('Đã sao chép link "' + experienceTitle + '"', 'success');
                                                        })
                                                        .catch(err => {
                                                            showToast('Không thể sao chép: ' + err, 'error');
                                                        });
                                            } else {
                                                // Fallback for older browsers
                                                const textArea = document.createElement('textarea');
                                                textArea.value = shareText;
                                                document.body.appendChild(textArea);
                                                textArea.select();
                                                try {
                                                    document.execCommand('copy');
                                                    showToast('Đã sao chép link "' + experienceTitle + '"', 'success');
                                                } catch (err) {
                                                    showToast('Không thể sao chép link', 'error');
                                                }
                                                document.body.removeChild(textArea);
                                            }
                                        }

// Save experience function
                                        function saveExperience() {
                                            const heartIcon = event.target.closest('.action-btn').querySelector('i');
                                            const experienceId = new URLSearchParams(window.location.search).get('id') ||
                                                    window.location.pathname.split('/').pop();

                                            if (heartIcon.classList.contains('ri-heart-line')) {
                                                heartIcon.classList.remove('ri-heart-line');
                                                heartIcon.classList.add('ri-heart-fill');
                                                heartIcon.style.color = 'var(--primary-color)';

                                                // Save to localStorage for now (in production, save to server)
                                                saveFavoriteExperience(experienceId);
                                                showToast('Đã lưu vào danh sách yêu thích', 'success');
                                            } else {
                                                heartIcon.classList.remove('ri-heart-fill');
                                                heartIcon.classList.add('ri-heart-line');
                                                heartIcon.style.color = '';

                                                // Remove from localStorage
                                                removeFavoriteExperience(experienceId);
                                                showToast('Đã bỏ khỏi danh sách yêu thích', 'info');
                                            }
                                        }

// Favorite management functions
                                        function saveFavoriteExperience(experienceId) {
                                            let favorites = JSON.parse(localStorage.getItem('favoriteExperiences')) || [];
                                            if (!favorites.includes(experienceId)) {
                                                favorites.push(experienceId);
                                                localStorage.setItem('favoriteExperiences', JSON.stringify(favorites));
                                            }
                                        }

                                        function removeFavoriteExperience(experienceId) {
                                            let favorites = JSON.parse(localStorage.getItem('favoriteExperiences')) || [];
                                            favorites = favorites.filter(id => id !== experienceId);
                                            localStorage.setItem('favoriteExperiences', JSON.stringify(favorites));
                                        }

                                        function checkIfFavorite() {
                                            const experienceId = new URLSearchParams(window.location.search).get('id') ||
                                                    window.location.pathname.split('/').pop();
                                            const favorites = JSON.parse(localStorage.getItem('favoriteExperiences')) || [];

                                            if (favorites.includes(experienceId)) {
                                                const heartIcon = document.querySelector('.action-btn i.ri-heart-line');
                                                if (heartIcon) {
                                                    heartIcon.classList.remove('ri-heart-line');
                                                    heartIcon.classList.add('ri-heart-fill');
                                                    heartIcon.style.color = 'var(--primary-color)';
                                                }
                                            }
                                        }

// Enhanced toast notification system
                                        function showToast(message, type = 'success', duration = 3000) {
                                            const toastContainer = document.querySelector('.toast-container');

                                            if (!toastContainer) {
                                                console.error('Toast container not found');
                                                return;
                                            }

                                            const toast = document.createElement('div');
                                            toast.className = 'toast';

                                            let icon = '<i class="ri-check-line"></i>';
                                            let bgColor = 'var(--dark-color)';

                                            switch (type) {
                                                case 'error':
                                                    icon = '<i class="ri-error-warning-line" style="color: #FF385C;"></i>';
                                                    bgColor = '#dc3545';
                                                    break;
                                                case 'info':
                                                    icon = '<i class="ri-information-line" style="color: #3498db;"></i>';
                                                    bgColor = '#17a2b8';
                                                    break;
                                                case 'warning':
                                                    icon = '<i class="ri-alert-line" style="color: #ffc107;"></i>';
                                                    bgColor = '#ffc107';
                                                    break;
                                                case 'success':
                                                default:
                                                    icon = '<i class="ri-check-line" style="color: #4BB543;"></i>';
                                                    break;
                                            }

                                            toast.style.backgroundColor = bgColor;
                                            toast.innerHTML = icon + '<span>' + message + '</span>';

                                            // Add close button for longer messages
                                            if (message.length > 50) {
                                                toast.innerHTML += '<button class="toast-close" onclick="this.parentElement.remove()"><i class="ri-close-line"></i></button>';
                                                toast.style.paddingRight = '50px';
                                            }

                                            toastContainer.appendChild(toast);

                                            // Show toast
                                            setTimeout(() => toast.classList.add('show'), 10);

                                            // Auto hide toast
                                            setTimeout(() => {
                                                toast.classList.remove('show');
                                                setTimeout(() => {
                                                    if (toastContainer.contains(toast)) {
                                                        toastContainer.removeChild(toast);
                                                    }
                                                }, 500);
                                            }, duration);
                                        }

// Smooth scroll for anchor links
                                        function initializeSmoothScroll() {
                                            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                                                anchor.addEventListener('click', function (e) {
                                                    e.preventDefault();
                                                    const target = document.querySelector(this.getAttribute('href'));
                                                    if (target) {
                                                        const navbar = document.querySelector('.custom-navbar');
                                                        const navbarHeight = navbar ? navbar.offsetHeight : 0;
                                                        const targetPosition = target.offsetTop - navbarHeight - 20;

                                                        window.scrollTo({
                                                            top: targetPosition,
                                                            behavior: 'smooth'
                                                        });
                                                    }
                                                });
                                            });
                                        }

// Chat functionality
                                        function chatWithHost() {
                                            const chatBtn = document.querySelector('.btn-chat');
                                            if (!chatBtn) {
                                                console.error('Chat button not found');
                                                return;
                                            }

                                            const hostId = chatBtn.getAttribute('data-host-id');
                                            const experienceId = chatBtn.getAttribute('data-experience-id');
                                            const currentUserId = chatBtn.getAttribute('data-current-user-id');

                                            console.log('Chat data:', {hostId, experienceId, currentUserId});

                                            if (!hostId) {
                                                showToast('Không tìm thấy thông tin host', 'error');
                                                return;
                                            }

                                            if (!currentUserId) {
                                                // Redirect to login with current page as return URL
                                                const currentPath = window.location.pathname + window.location.search;
                                                window.location.href = '/login?redirect=' + encodeURIComponent(currentPath);
                                                return;
                                            }

                                            if (hostId === currentUserId) {
                                                showToast('Bạn không thể chat với chính mình', 'info');
                                                return;
                                            }

                                            const originalText = chatBtn.innerHTML;
                                            chatBtn.innerHTML = '<i class="ri-loader-2-line"></i> Đang tạo chat...';
                                            chatBtn.disabled = true;

                                            const formData = new FormData();
                                            formData.append('hostId', hostId);
                                            if (experienceId) {
                                                formData.append('experienceId', experienceId);
                                            }

                                            // Try multiple methods to ensure compatibility
                                            fetch('/chat/api/create-room', {
                                                method: 'POST',
                                                body: formData
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            window.location.href = '/chat/room/' + data.chatRoomId;
                                                        } else {
                                                            showToast('Lỗi: ' + (data.message || 'Không thể tạo chat'), 'error');
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Chat error:', error);
                                                        showToast('Có lỗi xảy ra: ' + error.message, 'error');
                                                    })
                                                    .finally(() => {
                                                        chatBtn.innerHTML = originalText;
                                                        chatBtn.disabled = false;
                                                    });
                                        }

                                        function showContactInfo() {
                                            const hostNameEl = document.querySelector('.host-details h4');
                                            const hostName = hostNameEl ? hostNameEl.textContent : 'Host';

                                            const modal = createModal('contactInfoModal', 'Thông Tin Liên Hệ',
                                                    '<div class="text-center mb-4">' +
                                                    '<img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" ' +
                                                    'alt="Host Avatar" ' +
                                                    'style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid var(--secondary-color);">' +
                                                    '<h4 class="mt-3 mb-1">' + hostName + '</h4>' +
                                                    '<p class="text-muted">Hướng dẫn viên địa phương</p>' +
                                                    '</div>' +
                                                    '<div class="contact-info">' +
                                                    '<div class="contact-item d-flex align-items-center mb-3">' +
                                                    '<div class="contact-icon me-3">' +
                                                    '<i class="ri-phone-line" style="font-size: 1.2rem; color: var(--primary-color);"></i>' +
                                                    '</div>' +
                                                    '<div>' +
                                                    '<strong>Điện thoại:</strong><br>' +
                                                    '<span class="text-muted">Đăng nhập để xem số điện thoại</span>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '<div class="contact-item d-flex align-items-center mb-3">' +
                                                    '<div class="contact-icon me-3">' +
                                                    '<i class="ri-mail-line" style="font-size: 1.2rem; color: var(--primary-color);"></i>' +
                                                    '</div>' +
                                                    '<div>' +
                                                    '<strong>Email:</strong><br>' +
                                                    '<span class="text-muted">Đăng nhập để xem email</span>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '<div class="contact-item d-flex align-items-center mb-3">' +
                                                    '<div class="contact-icon me-3">' +
                                                    '<i class="ri-time-line" style="font-size: 1.2rem; color: var(--primary-color);"></i>' +
                                                    '</div>' +
                                                    '<div>' +
                                                    '<strong>Thời gian phản hồi:</strong><br>' +
                                                    '<span class="text-success">Trong vòng 1 giờ</span>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '<div class="contact-item d-flex align-items-center">' +
                                                    '<div class="contact-icon me-3">' +
                                                    '<i class="ri-star-fill" style="font-size: 1.2rem; color: #FFD700;"></i>' +
                                                    '</div>' +
                                                    '<div>' +
                                                    '<strong>Đánh giá:</strong><br>' +
                                                    '<span>4.9/5 (156 đánh giá)</span>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>', [
                                                        {
                                                            text: 'Đóng',
                                                            class: 'btn-secondary',
                                                            action: 'dismiss'
                                                        },
                                                        {
                                                            text: '<i class="ri-message-3-line me-1"></i>Bắt Đầu Chat',
                                                            class: 'btn-primary',
                                                            action: 'chatWithHost()'
                                                        }
                                                    ]);
                                        }

                                        function showLoginRequired() {
                                            const experienceId = window.location.pathname.split('/').pop();

                                            createModal('loginRequiredModal', 'Yêu Cầu Đăng Nhập',
                                                    '<div class="text-center">' +
                                                    '<div class="mb-4">' +
                                                    '<i class="ri-user-add-line" style="font-size: 4rem; color: var(--primary-color);"></i>' +
                                                    '</div>' +
                                                    '<h5 class="mb-3">Cần đăng nhập để xem thông tin liên hệ</h5>' +
                                                    '<p class="text-muted mb-4">' +
                                                    'Đăng nhập để có thể xem thông tin liên hệ của host và bắt đầu trò chuyện để được tư vấn chi tiết.' +
                                                    '</p>' +
                                                    '<div class="d-grid gap-2">' +
                                                    '<a href="/login?redirect=chat&experienceId=' + experienceId + '" ' +
                                                    'class="btn btn-primary">' +
                                                    '<i class="ri-login-circle-line me-2"></i>Đăng Nhập' +
                                                    '</a>' +
                                                    '<a href="/register" class="btn btn-outline-primary">' +
                                                    '<i class="ri-user-add-line me-2"></i>Tạo Tài Khoản Mới' +
                                                    '</a>' +
                                                    '</div>' +
                                                    '</div>', [
                                                        {
                                                            text: 'Đóng',
                                                            class: 'btn-secondary',
                                                            action: 'dismiss'
                                                        }
                                                    ]);
                                        }

// Universal modal creator
                                        function createModal(id, title, body, buttons = []) {
                                            // Remove existing modal if any
                                            const existingModal = document.getElementById(id);
                                            if (existingModal) {
                                                existingModal.remove();
                                            }

                                            const modal = document.createElement('div');
                                            modal.className = 'modal fade';
                                            modal.id = id;
                                            modal.setAttribute('tabindex', '-1');
                                            modal.setAttribute('aria-hidden', 'true');

                                            let buttonsHtml = '';
                                            buttons.forEach(button => {
                                                if (button.action === 'dismiss') {
                                                    buttonsHtml += '<button type="button" class="btn ' + button.class + '" data-bs-dismiss="modal">' + button.text + '</button>';
                                                } else {
                                                    buttonsHtml += '<button type="button" class="btn ' + button.class + '" onclick="' + button.action + '">' + button.text + '</button>';
                                                }
                                            });

                                            modal.innerHTML =
                                                    '<div class="modal-dialog modal-dialog-centered">' +
                                                    '<div class="modal-content">' +
                                                    '<div class="modal-header">' +
                                                    '<h5 class="modal-title">' +
                                                    '<i class="ri-phone-line me-2"></i>' + title +
                                                    '</h5>' +
                                                    '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>' +
                                                    '</div>' +
                                                    '<div class="modal-body">' +
                                                    body +
                                                    '</div>' +
                                                    (buttonsHtml ? '<div class="modal-footer">' + buttonsHtml + '</div>' : '') +
                                                    '</div>' +
                                                    '</div>';

                                            document.body.appendChild(modal);

                                            // Initialize Bootstrap modal if available
                                            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                const bsModal = new bootstrap.Modal(modal);
                                                bsModal.show();
                                            } else {
                                                // Fallback: show modal manually
                                                modal.style.display = 'block';
                                                modal.classList.add('show');
                                                document.body.classList.add('modal-open');
                                            }

                                            // Clean up modal when closed
                                            modal.addEventListener('hidden.bs.modal', function () {
                                                document.body.removeChild(modal);
                                            });

                                            return modal;
                                        }

// Update message badge in navbar
                                        function updateMessageBadge() {
                                            const user = document.querySelector('[data-current-user-id]');
                                            if (!user)
                                                return; // User not logged in

                                            fetch('/chat/api/unread-count')
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
                                        }

// Image lazy loading with intersection observer
                                        function initializeLazyLoading() {
                                            const images = document.querySelectorAll('img[data-src]');

                                            const imageObserver = new IntersectionObserver((entries, observer) => {
                                                entries.forEach(entry => {
                                                    if (entry.isIntersecting) {
                                                        const img = entry.target;
                                                        img.src = img.dataset.src;
                                                        img.removeAttribute('data-src');
                                                        img.classList.add('loaded');
                                                        observer.unobserve(img);
                                                    }
                                                });
                                            }, {
                                                rootMargin: '50px 0px',
                                                threshold: 0.01
                                            });

                                            images.forEach(img => imageObserver.observe(img));
                                        }

// Performance monitoring
                                        function trackPerformance() {
                                            if ('performance' in window && 'getEntriesByType' in performance) {
                                                window.addEventListener('load', () => {
                                                    setTimeout(() => {
                                                        const perfData = performance.getEntriesByType('navigation')[0];
                                                        console.log('Page load performance:', {
                                                            domContentLoaded: perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart,
                                                            loadComplete: perfData.loadEventEnd - perfData.loadEventStart,
                                                            totalTime: perfData.loadEventEnd - perfData.fetchStart
                                                        });
                                                    }, 1000);
                                                });
                                            }
                                        }

// Accessibility enhancements
                                        function enhanceAccessibility() {
                                            // Add focus indicators for keyboard navigation
                                            document.addEventListener('keydown', (e) => {
                                                if (e.key === 'Tab') {
                                                    document.body.classList.add('keyboard-navigation');
                                                }
                                            });

                                            document.addEventListener('mousedown', () => {
                                                document.body.classList.remove('keyboard-navigation');
                                            });

                                            // Add aria-labels for better screen reader support
                                            const buttons = document.querySelectorAll('button:not([aria-label])');
                                            buttons.forEach(button => {
                                                const icon = button.querySelector('i');
                                                if (icon && !button.textContent.trim()) {
                                                    const iconClass = icon.className;
                                                    if (iconClass.includes('share')) {
                                                        button.setAttribute('aria-label', 'Chia sẻ trải nghiệm');
                                                    } else if (iconClass.includes('heart')) {
                                                        button.setAttribute('aria-label', 'Lưu vào danh sách yêu thích');
                                                    } else if (iconClass.includes('message')) {
                                                        button.setAttribute('aria-label', 'Chat với host');
                                                    }
                                                }
                                            });
                                        }

// Error handling for API calls
                                        function handleApiError(error, context = '') {
                                            console.error(`API Error ${context}:`, error);

                                            if (error.name === 'TypeError' && error.message.includes('fetch')) {
                                                showToast('Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.', 'error', 5000);
                                            } else if (error.status === 401) {
                                                showToast('Phiên đăng nhập đã hết hạn. Đang chuyển hướng...', 'warning', 3000);
                                                setTimeout(() => {
                                                    window.location.href = '/login';
                                                }, 3000);
                                            } else if (error.status === 403) {
                                                showToast('Bạn không có quyền thực hiện hành động này.', 'error');
                                            } else if (error.status >= 500) {
                                                showToast('Lỗi server. Vui lòng thử lại sau.', 'error');
                                            } else {
                                                showToast('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
                                        }
                                        }

// Review modal functionality
                                        function openReviewModal() {
                                            const modal = document.getElementById('reviewModal');
                                            if (modal) {
                                                if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                    const bsModal = new bootstrap.Modal(modal);
                                                    bsModal.show();
                                                } else {
                                                    // Fallback
                                                    modal.style.display = 'block';
                                                    modal.classList.add('show');
                                                    document.body.classList.add('modal-open');
                                                }
                                            }
                                        }

                                        function goToBooking() {
                                            // Close review modal if open
                                            const reviewModal = document.getElementById('reviewModal');
                                            if (reviewModal) {
                                                if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                    const modal = bootstrap.Modal.getInstance(reviewModal);
                                                    if (modal)
                                                        modal.hide();
                                                } else {
                                                    reviewModal.style.display = 'none';
                                                    reviewModal.classList.remove('show');
                                                    document.body.classList.remove('modal-open');
                                                }
                                            }

                                            setTimeout(() => {
                                                // Clean up modal backdrop
                                                document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
                                                document.body.classList.remove('modal-open');
                                                document.body.style = '';

                                                // Scroll to booking section
                                                const bookingSection = document.querySelector('.booking-card');
                                                if (bookingSection) {
                                                    const navbar = document.querySelector('.custom-navbar');
                                                    const navbarHeight = navbar ? navbar.offsetHeight : 0;
                                                    const targetPosition = bookingSection.offsetTop - navbarHeight - 20;

                                                    window.scrollTo({
                                                        top: targetPosition,
                                                        behavior: 'smooth'
                                                    });

                                                    // Highlight booking card briefly
                                                    bookingSection.style.transition = 'all 0.3s ease';
                                                    bookingSection.style.boxShadow = '0 0 20px rgba(255, 56, 92, 0.4)';
                                                    setTimeout(() => {
                                                        bookingSection.style.boxShadow = '';
                                                    }, 2000);
                                                }
                                            }, 350);
                                        }

// Service Worker registration for PWA features
                                        function registerServiceWorker() {
                                            if ('serviceWorker' in navigator) {
                                                window.addEventListener('load', () => {
                                                    navigator.serviceWorker.register('/sw.js')
                                                            .then(registration => {
                                                                console.log('SW registered: ', registration);
                                                            })
                                                            .catch(registrationError => {
                                                                console.log('SW registration failed: ', registrationError);
                                                            });
                                                });
                                            }
                                        }

// Legacy functions for backward compatibility
                                        function calculateTotal() {
                                            // This function is now handled by BookingFormManager
                                            // Keep for backward compatibility if called elsewhere
                                            if (window.bookingFormManager) {
                                                window.bookingFormManager.validateAndCalculate();
                                            }
                                        }

                                        function formatCurrency(amount) {
                                            return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                        }

// Message functions for chat integration
                                        function sendMessage() {
                                            const messageInput = document.getElementById('messageInput');
                                            if (!messageInput)
                                                return;

                                            const messageContent = messageInput.value.trim();

                                            if (messageContent === '')
                                                return;

                                            const sendBtn = document.getElementById('sendBtn');
                                            if (sendBtn)
                                                sendBtn.disabled = true;

                                            // Add message to UI immediately (optimistic UI)
                                            if (typeof addMessageToUI === 'function') {
                                                addMessageToUI(messageContent, true);
                                            }

                                            // Send to server
                                            const formData = new FormData();
                                            const chatRoomId = window.chatRoomId || '';
                                            const receiverId = window.receiverId || '';

                                            formData.append('roomId', chatRoomId);
                                            formData.append('receiverId', receiverId);
                                            formData.append('messageContent', messageContent);
                                            formData.append('messageType', 'TEXT');

                                            fetch('/chat/api/send-message', {
                                                method: 'POST',
                                                body: formData
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (!data.success) {
                                                            // Remove optimistic message and show error
                                                            if (typeof removeLastOptimisticMessage === 'function') {
                                                                removeLastOptimisticMessage();
                                                            }
                                                            showToast('Có lỗi xảy ra khi gửi tin nhắn: ' + (data.message || ''), 'error');
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error sending message:', error);
                                                        if (typeof removeLastOptimisticMessage === 'function') {
                                                            removeLastOptimisticMessage();
                                                        }
                                                        showToast('Có lỗi xảy ra khi gửi tin nhắn', 'error');
                                                    });

                                            messageInput.value = '';
                                            messageInput.style.height = 'auto';
                                            if (sendBtn)
                                                sendBtn.disabled = false;
                                            messageInput.focus();
                                        }

                                        function markMessagesAsRead() {
                                            const chatRoomId = window.chatRoomId || '';
                                            if (!chatRoomId)
                                                return;

                                            fetch(`/chat/api/mark-read/${chatRoomId}`, {
                                                method: 'POST'
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            console.log('Messages marked as read');
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error marking messages as read:', error);
                                                    });
                                        }

                        // Weather Widget Functions
                                        let weatherData = null;
                                        let isLoadingWeather = false;

                                                                                                async function loadWeatherData() {
                                            if (isLoadingWeather) return;
                                            
                                            isLoadingWeather = true;
                                            showWeatherLoading();

                                            try {
                                                // Try multiple location formats for better API recognition
                                                const primaryLocation = getLocationForWeather();
                                                const fallbackLocations = [
                                                    primaryLocation,
                                                    'Ho Chi Minh City, Vietnam',  // Always working fallback
                                                    'Hanoi, Vietnam',
                                                    'Da Nang, Vietnam'
                                                ];

                                                let weatherResult = null;
                                                let workingLocation = null;

                                                // Try each location until one works
                                                for (let locationName of fallbackLocations) {
                                                    try {
                                                        console.log('🔄 Trying location:', locationName);
                                                        
                                                        const result = await tryLoadWeatherForLocation(locationName);
                                                        
                                                        if (result && result.location && 
                                                            !result.location.name.toLowerCase().includes('adial')) {
                                                            weatherResult = result;
                                                            workingLocation = locationName;
                                                            console.log('✅ Successfully loaded weather for:', locationName);
                                                            break;
                                                        }
                                                        
                                                    } catch (locationError) {
                                                        console.log('❌ Failed for location:', locationName, locationError.message);
                                                        continue;
                                                    }
                                                }

                                                if (!weatherResult) {
                                                    throw new Error('Không thể tải dữ liệu thời tiết cho bất kỳ địa điểm nào');
                                                }

                                                // Override location name if we had to use fallback
                                                if (workingLocation !== primaryLocation) {
                                                    weatherResult.location.name = getExpectedLocationName();
                                                    console.log('📍 Using display name:', weatherResult.location.name);
                                                }

                                                weatherData = weatherResult;
                                                renderWeatherData();
                                                applyWeatherTheme();
                                                
                                            } catch (error) {
                                                console.error('Weather API Error:', error);
                                                showWeatherError('Không thể tải dữ liệu thời tiết. Vui lòng thử lại sau.');
                                            } finally {
                                                isLoadingWeather = false;
                                            }
                                        }

                                        async function tryLoadWeatherForLocation(locationName) {
                                            const apiKey = 'b872f76c011e4a5fbab105122251107';
                                            const baseUrl = 'https://api.weatherapi.com/v1';

                                            const currentUrl = baseUrl + '/current.json?key=' + apiKey + '&q=' + encodeURIComponent(locationName) + '&aqi=yes&lang=vi';
                                            const forecastUrl = baseUrl + '/forecast.json?key=' + apiKey + '&q=' + encodeURIComponent(locationName) + '&days=4&aqi=yes&lang=vi';

                                            const [currentResponse, forecastResponse] = await Promise.all([
                                                fetch(currentUrl),
                                                fetch(forecastUrl)
                                            ]);

                                            if (!currentResponse.ok || !forecastResponse.ok) {
                                                throw new Error('API request failed');
                                            }

                                            const currentData = await currentResponse.json();
                                            const forecastData = await forecastResponse.json();

                                            return {
                                                current: currentData.current,
                                                location: currentData.location,
                                                forecast: forecastData.forecast.forecastday.slice(1, 4)
                                            };
                                        }

                                        function getLocationForWeather() {
                                            // Get experience data from JSP
                                            const expTitle = "${experience.title}";
                                            const expLocation = "${experience.location}";
                                            const expCityName = "${experience.cityName}";
                                            const expCityId = "${experience.cityId}";
                                            
                                            console.log('🌍 Experience data for weather:');
                                            console.log('- Title:', expTitle);
                                            console.log('- Location:', expLocation);
                                            console.log('- City Name:', expCityName);
                                            console.log('- City ID:', expCityId);
                                            
                                            let weatherLocation = '';
                                            
                                            // Priority 1: Map cityId to exact location (MOST ACCURATE)
                                            if (expCityId && expCityId !== 'null' && expCityId !== '0') {
                                                weatherLocation = mapCityIdToLocation(parseInt(expCityId));
                                                console.log('✅ Using cityId mapping (ID=' + expCityId + '):', weatherLocation);
                                            }
                                            // Priority 2: Use cityName mapping
                                            else if (expCityName && expCityName.trim() !== '' && expCityName !== 'null') {
                                                weatherLocation = mapCityNameToEnglish(expCityName.trim());
                                                console.log('✅ Using mapped city name:', weatherLocation);
                                            } 
                                            // Priority 3: Parse location string intelligently
                                            else if (expLocation && expLocation.trim() !== '' && expLocation !== 'null') {
                                                weatherLocation = parseLocationString(expLocation);
                                                console.log('✅ Using parsed location:', weatherLocation);
                                            } 
                                            // Priority 4: Default fallback
                                            else {
                                                weatherLocation = 'Ho Chi Minh City';
                                                console.log('⚠️ Using default location:', weatherLocation);
                                            }
                                            
                                            // Validate and add Vietnam if needed
                                            const finalLocation = validateLocation(weatherLocation);
                                            
                                            console.log('🎯 Final weather location for \'' + expTitle + '\' (CityID: ' + expCityId + '):', finalLocation);
                                            return finalLocation;
                                        }

                                        function mapCityIdToLocation(cityId) {
                                            // Get city data from current experience (from database)
                                            const expCityId = parseInt("${experience.cityId}");
                                            const expCityName = "${experience.cityName}";
                                            
                                            console.log('🗺️ Experience city data:');
                                            console.log('- Experience CityID:', expCityId);
                                            console.log('- Experience City Name:', expCityName);
                                            console.log('- Requested CityID:', cityId);
                                            
                                            // If the requested cityId matches current experience city
                                            if (cityId === expCityId && expCityName && expCityName.trim() !== '' && expCityName !== 'null') {
                                                const weatherLocation = mapVietnameseCityToEnglish(expCityName.trim());
                                                console.log('✅ Using database city name for CityID ' + cityId + ':', weatherLocation);
                                                return weatherLocation;
                                            }
                                            
                                            // Fallback mapping for other cities (limited but covers main cities)
                                            const fallbackMapping = {
                                                1: 'Hanoi',                    // Hanoi
                                                2: 'Hai Phong',                // Haiphong  
                                                3: 'Sapa',                     // Sapa
                                                4: 'Ha Long',                  // Ha Long
                                                5: 'Ninh Binh',               // Ninh Binh
                                                6: 'Da Nang',                  // Da Nang
                                                7: 'Hue',                      // Hue
                                                8: 'Hoi An',                   // Hoi An
                                                9: 'Nha Trang',                // Nha Trang
                                                10: 'Quy Nhon',                // Quy Nhon
                                                11: 'Ho Chi Minh City',        // Ho Chi Minh City
                                                12: 'Vung Tau',                // Vung Tau
                                                13: 'Can Tho',                 // Can Tho
                                                14: 'Phu Quoc',                // Phu Quoc
                                                15: 'Da Lat',                  // Da Lat
                                                16: 'Ben Tre'                  // Ben Tre
                                            };
                                            
                                            const location = fallbackMapping[cityId];
                                            
                                            if (location) {
                                                console.log('🗺️ Fallback CityID ' + cityId + ' mapped to:', location);
                                                return location;
                                            } else {
                                                console.log('⚠️ Unknown cityID:', cityId, '- using default fallback');
                                                return 'Ho Chi Minh City'; // Fallback for unknown cityId
                                            }
                                        }

                                        function mapVietnameseCityToEnglish(vietnameseName) {
                                            // Map Vietnamese city names to English for weather API
                                            const mapping = {
                                                'Hà Nội': 'Hanoi',
                                                'Hanoi': 'Hanoi',
                                                'Hồ Chí Minh': 'Ho Chi Minh City',
                                                'Ho Chi Minh City': 'Ho Chi Minh City',
                                                'TP.HCM': 'Ho Chi Minh City',
                                                'Sài Gòn': 'Ho Chi Minh City',
                                                'Đà Nẵng': 'Da Nang',
                                                'Da Nang': 'Da Nang',
                                                'Huế': 'Hue',
                                                'Hue': 'Hue',
                                                'Hội An': 'Hoi An',
                                                'Hoi An': 'Hoi An',
                                                'Nha Trang': 'Nha Trang',
                                                'Đà Lạt': 'Da Lat',
                                                'Da Lat': 'Da Lat',
                                                'Vũng Tàu': 'Vung Tau',
                                                'Vung Tau': 'Vung Tau',
                                                'Cần Thơ': 'Can Tho',
                                                'Can Tho': 'Can Tho',
                                                'Hạ Long': 'Ha Long',
                                                'Ha Long': 'Ha Long',
                                                'Phú Quốc': 'Phu Quoc',
                                                'Phu Quoc': 'Phu Quoc',
                                                'Quy Nhon': 'Quy Nhon',
                                                'Hải Phòng': 'Hai Phong',
                                                'Haiphong': 'Hai Phong',
                                                'Ninh Bình': 'Ninh Binh',
                                                'Ninh Binh': 'Ninh Binh',
                                                'Bến Tre': 'Ben Tre',
                                                'Ben Tre': 'Ben Tre',
                                                'Sapa': 'Sapa'
                                            };
                                            
                                            const englishName = mapping[vietnameseName];
                                            if (englishName) {
                                                console.log('🌏 Mapped Vietnamese "' + vietnameseName + '" to English "' + englishName + '"');
                                                return englishName;
                                            }
                                            
                                            console.log('⚠️ No mapping found for "' + vietnameseName + '", using as-is');
                                            return vietnameseName; // Use as-is if no mapping found
                                        }

                                        function mapCityNameToEnglish(cityName) {
                                            const cityMapping = {
                                                'Hà Nội': 'Hanoi',
                                                'Hồ Chí Minh': 'Ho Chi Minh City', 
                                                'Đà Nẵng': 'Da Nang',
                                                'Nha Trang': 'Nha Trang',
                                                'Hội An': 'Hoi An',
                                                'Huế': 'Hue',
                                                'Đà Lạt': 'Da Lat',
                                                'Vũng Tàu': 'Vung Tau',
                                                'Cần Thơ': 'Can Tho',
                                                'Hạ Long': 'Ha Long',
                                                'Phú Quốc': 'Phu Quoc',
                                                'Quy Nhon': 'Quy Nhon',
                                                'Vinh': 'Vinh'
                                            };
                                            
                                            return cityMapping[cityName] || cityName;
                                        }

                                        function validateLocation(location) {
                                            // Known problematic responses that should trigger fallback - EXACT matches only
                                            const problematicLocations = ['adial', 'unknown', 'error', 'null', ''];
                                            const lowerLocation = location.toLowerCase().trim();
                                            
                                            // Check for exact problematic patterns (not just contains)
                                            const isProblematic = problematicLocations.some(bad => {
                                                if (bad === '') return lowerLocation === '';
                                                return lowerLocation === bad || lowerLocation.includes(' ' + bad + ' ') || 
                                                       lowerLocation.startsWith(bad + ' ') || lowerLocation.endsWith(' ' + bad) ||
                                                       lowerLocation === bad + ', vietnam' || lowerLocation === bad + ' vietnam';
                                            });
                                            
                                            if (isProblematic) {
                                                console.log('⚠️ Problematic location detected (exact match):', location);
                                                return 'Ho Chi Minh City, Vietnam';
                                            }
                                            
                                            // Valid city names should pass through
                                            console.log('✅ Location validated successfully:', location);
                                            
                                            // Ensure Vietnam is included for better API results
                                            if (!location.toLowerCase().includes('vietnam') && 
                                                !location.toLowerCase().includes('việt nam')) {
                                                return location + ', Vietnam';
                                            }
                                            
                                            return location;
                                        }

                                        function getExpectedLocationName() {
                                            // Get the display name for location (without "Vietnam")
                                            const expCityId = "${experience.cityId}";
                                            const expCityName = "${experience.cityName}";
                                            const expLocation = "${experience.location}";
                                            
                                            // Priority 1: Use cityName from database (most accurate)
                                            if (expCityName && expCityName.trim() !== '' && expCityName !== 'null') {
                                                const mapped = mapVietnameseCityToEnglish(expCityName.trim());
                                                return mapped.replace(', Vietnam', '');
                                            } 
                                            // Priority 2: Use cityId mapping
                                            else if (expCityId && expCityId !== 'null' && expCityId !== '0') {
                                                const mapped = mapCityIdToLocation(parseInt(expCityId));
                                                return mapped.replace(', Vietnam', '');
                                            }
                                            // Priority 3: Parse location string
                                            else if (expLocation && expLocation.trim() !== '' && expLocation !== 'null') {
                                                const parsed = parseLocationString(expLocation);
                                                return parsed.replace(', Vietnam', '');
                                            }
                                            
                                            return 'Ho Chi Minh City';
                                        }

                                        function parseLocationString(location) {
                                            // Clean location string but preserve Vietnamese characters and punctuation
                                            let cleaned = location.trim();
                                            
                                            console.log('📍 Parsing location:', cleaned);
                                            
                                            // Define Vietnamese cities with API-friendly names mapping
                                            const locationMapping = {
                                                // Major cities - use English names for better API recognition
                                                'hồ chí minh': 'Ho Chi Minh City',
                                                'tp.hcm': 'Ho Chi Minh City', 
                                                'tp hcm': 'Ho Chi Minh City',
                                                'sài gòn': 'Ho Chi Minh City',
                                                'saigon': 'Ho Chi Minh City',
                                                'hà nội': 'Hanoi',
                                                'hanoi': 'Hanoi',
                                                'đà nẵng': 'Da Nang',
                                                'da nang': 'Da Nang',
                                                'nha trang': 'Nha Trang',
                                                'hội an': 'Hoi An',
                                                'hoi an': 'Hoi An',
                                                'vũng tàu': 'Vung Tau',
                                                'vung tau': 'Vung Tau',
                                                'huế': 'Hue',
                                                'hue': 'Hue',
                                                'đà lạt': 'Da Lat',
                                                'da lat': 'Da Lat',
                                                'phú quốc': 'Phu Quoc',
                                                'phu quoc': 'Phu Quoc',
                                                'cần thơ': 'Can Tho',
                                                'can tho': 'Can Tho',
                                                'hải phòng': 'Hai Phong',
                                                'hai phong': 'Hai Phong',
                                                
                                                // Provinces - map to major cities in those provinces
                                                'quảng ninh': 'Ha Long',
                                                'quang ninh': 'Ha Long',
                                                'hạ long': 'Ha Long',
                                                'ha long': 'Ha Long',
                                                'quảng nam': 'Hoi An',
                                                'quang nam': 'Hoi An',
                                                'khánh hòa': 'Nha Trang',
                                                'khanh hoa': 'Nha Trang',
                                                'lâm đồng': 'Da Lat',
                                                'lam dong': 'Da Lat',
                                                'kiên giang': 'Phu Quoc',
                                                'kien giang': 'Phu Quoc',
                                                'bình định': 'Quy Nhon',
                                                'binh dinh': 'Quy Nhon',
                                                'quy nhon': 'Quy Nhon',
                                                'nghệ an': 'Vinh',
                                                'nghe an': 'Vinh',
                                                'vinh': 'Vinh',
                                                'thanh hóa': 'Thanh Hoa',
                                                'thanh hoa': 'Thanh Hoa',
                                                'ninh bình': 'Ninh Binh',
                                                'ninh binh': 'Ninh Binh',
                                                'lào cai': 'Lao Cai',
                                                'lao cai': 'Lao Cai',
                                                'sapa': 'Sapa',
                                                'sa pa': 'Sapa',
                                                'cao bằng': 'Cao Bang',
                                                'cao bang': 'Cao Bang',
                                                'đồng nai': 'Bien Hoa',
                                                'dong nai': 'Bien Hoa',
                                                'biên hòa': 'Bien Hoa',
                                                'bien hoa': 'Bien Hoa'
                                            };
                                            
                                            // Check if location matches our mapping
                                            const lowerLocation = cleaned.toLowerCase();
                                            
                                            // Direct mapping check
                                            for (let [vietnamese, english] of Object.entries(locationMapping)) {
                                                if (lowerLocation.includes(vietnamese)) {
                                                    console.log('🎯 Found location mapping:', vietnamese, '→', english);
                                                    return english;
                                                }
                                            }
                                            
                                            // If no direct mapping, try to extract from comma-separated format
                                            if (cleaned.includes(',')) {
                                                const parts = cleaned.split(',');
                                                // Check each part for mappings
                                                for (let part of parts) {
                                                    const partLower = part.trim().toLowerCase();
                                                    for (let [vietnamese, english] of Object.entries(locationMapping)) {
                                                        if (partLower.includes(vietnamese)) {
                                                            console.log('🎯 Found location mapping in part:', vietnamese, '→', english);
                                                            return english;
                                                        }
                                                    }
                                                }
                                                
                                                // Use last part if no mapping found
                                                const lastPart = parts[parts.length - 1].trim();
                                                console.log('📝 Using last part:', lastPart);
                                                return lastPart;
                                            }
                                            
                                            // As last resort, return the cleaned location
                                            console.log('📍 Using full location string:', cleaned);
                                            return cleaned;
                                        }

                                        function showWeatherLoading() {
                                            const content = document.getElementById('weatherContent');
                                            if (content) {
                                                content.innerHTML = 
                                                    '<div class="weather-loading">' +
                                                        '<i class="ri-loader-4-line"></i>' +
                                                        '<div>Đang tải thông tin thời tiết...</div>' +
                                                    '</div>';
                                            }
                                        }

                                                                function showWeatherError(message) {
                            const content = document.getElementById('weatherContent');
                            if (content) {
                                content.innerHTML = 
                                    '<div class="weather-error">' +
                                        '<i class="ri-error-warning-line"></i>' +
                                        '<div>' + message + '</div>' +
                                        '<button class="btn btn-sm btn-outline-primary mt-2" onclick="refreshWeather()">' +
                                            '<i class="ri-refresh-line me-1"></i>Thử lại' +
                                        '</button>' +
                                    '</div>';
                            }
                        }

                                        function renderWeatherData() {
                                            if (!weatherData) return;

                                            const { current, location, forecast } = weatherData;
                                            const content = document.getElementById('weatherContent');
                                            
                                            if (!content) return;

                                            // Get weather condition and appropriate icon
                                            const weatherIcon = getWeatherIcon(current.condition.code, current.is_day);
                                            const weatherQuality = getWeatherQuality(current);
                                            
                                            content.innerHTML = 
                                                '<!-- Current Weather -->' +
                                                '<div class="weather-current">' +
                                                    '<div class="weather-icon">' +
                                                        '<i class="' + weatherIcon + '"></i>' +
                                                    '</div>' +
                                                    '<div class="weather-main">' +
                                                        '<div class="weather-temp">' + Math.round(current.temp_c) + '°C</div>' +
                                                        '<div class="weather-desc">' + current.condition.text + '</div>' +
                                                        '<div class="weather-location">' +
                                                            '<i class="ri-map-pin-line"></i>' +
                                                            location.name + ', ' + location.country +
                                                        '</div>' +
                                                        weatherQuality +
                                                    '</div>' +
                                                '</div>' +

                                                '<!-- Weather Details -->' +
                                                '<div class="weather-details">' +
                                                    '<div class="weather-detail">' +
                                                        '<i class="ri-drop-line"></i>' +
                                                        '<div class="weather-detail-value">' + current.humidity + '%</div>' +
                                                        '<div class="weather-detail-label">Độ ẩm</div>' +
                                                    '</div>' +
                                                    '<div class="weather-detail">' +
                                                        '<i class="ri-windy-line"></i>' +
                                                        '<div class="weather-detail-value">' + Math.round(current.wind_kph) + '</div>' +
                                                        '<div class="weather-detail-label">km/h</div>' +
                                                    '</div>' +
                                                    '<div class="weather-detail">' +
                                                        '<i class="ri-eye-line"></i>' +
                                                        '<div class="weather-detail-value">' + Math.round(current.vis_km) + '</div>' +
                                                        '<div class="weather-detail-label">km tầm nhìn</div>' +
                                                    '</div>' +
                                                    '<div class="weather-detail">' +
                                                        '<i class="ri-temperature-line"></i>' +
                                                        '<div class="weather-detail-value">' + Math.round(current.feelslike_c) + '°</div>' +
                                                        '<div class="weather-detail-label">Cảm giác</div>' +
                                                    '</div>' +
                                                                                                 '</div>' +

                                                '<!-- 3-Day Forecast -->' +
                                                '<div class="weather-forecast">' +
                                                    '<div class="forecast-title">' +
                                                        '<i class="ri-calendar-line"></i>' +
                                                        'Dự báo 3 ngày tới' +
                                                    '</div>' +
                                                    '<div class="forecast-list">' +
                                                        forecast.map(day => renderForecastItem(day)).join('') +
                                                    '</div>' +
                                                '</div>' +

                                                '<!-- Attribution -->' +
                                                '<div class="weather-attribution">' +
                                                    '<a href="https://www.weatherapi.com/" target="_blank" rel="noopener">' +
                                                        'Dữ liệu từ WeatherAPI.com' +
                                                    '</a>' +
                                                '</div>';
                                        }

                                                                function renderForecastItem(day) {
                            const date = new Date(day.date);
                            const dayName = getDayName(date);
                            const weatherIcon = getWeatherIcon(day.day.condition.code, true);
                            
                            return '<div class="forecast-item">' +
                                       '<div class="forecast-date">' + dayName + '</div>' +
                                       '<div class="forecast-weather">' +
                                           '<div class="forecast-icon">' +
                                               '<i class="' + weatherIcon + '"></i>' +
                                           '</div>' +
                                           '<div class="forecast-desc">' + day.day.condition.text + '</div>' +
                                       '</div>' +
                                       '<div class="forecast-temp">' +
                                           '<span class="temp-high">' + Math.round(day.day.maxtemp_c) + '°</span>' +
                                           '<span class="temp-low">' + Math.round(day.day.mintemp_c) + '°</span>' +
                                       '</div>' +
                                   '</div>';
                        }

                                        function getWeatherIcon(conditionCode, isDay) {
                                            // Map WeatherAPI condition codes to Remix Icons
                                            const iconMap = {
                                                1000: isDay ? 'ri-sun-line' : 'ri-moon-line',
                                                1003: isDay ? 'ri-sun-cloudy-line' : 'ri-moon-cloudy-line',
                                                1006: 'ri-cloudy-line',
                                                1009: 'ri-cloudy-2-line',
                                                1030: 'ri-mist-line',
                                                1063: 'ri-drizzle-line',
                                                1087: 'ri-thunderstorms-line',
                                                1180: 'ri-rainy-line',
                                                1183: 'ri-rainy-line',
                                                1186: 'ri-rainy-line',
                                                1189: 'ri-rainy-line',
                                                1192: 'ri-heavy-showers-line',
                                                1195: 'ri-heavy-showers-line',
                                                1240: 'ri-showers-line',
                                                1243: 'ri-heavy-showers-line'
                                            };
                                            return iconMap[conditionCode] || (isDay ? 'ri-sun-line' : 'ri-moon-line');
                                        }

                                        function getWeatherQuality(current) {
                                            // Determine weather quality for travel
                                            const temp = current.temp_c;
                                            const humidity = current.humidity;
                                            const windSpeed = current.wind_kph;
                                            const visKm = current.vis_km;
                                            const isRaining = current.condition.text.toLowerCase().includes('rain') || 
                                                             current.condition.text.toLowerCase().includes('mưa');
                                            
                                            let quality = 'excellent';
                                            let qualityText = 'Tuyệt vời cho du lịch';
                                            let icon = 'ri-thumb-up-line';

                                            // Check conditions
                                            if (isRaining || temp < 10 || temp > 38 || windSpeed > 25 || visKm < 5) {
                                                quality = 'poor';
                                                qualityText = 'Cần chuẩn bị kỹ';
                                                icon = 'ri-alert-line';
                                            } else if (temp < 18 || temp > 32 || humidity > 80 || windSpeed > 15) {
                                                quality = 'good';
                                                qualityText = 'Khá tốt cho du lịch';
                                                icon = 'ri-thumb-up-line';
                                            }

                                                                        return '<div class="weather-quality ' + quality + '">' +
                                       '<i class="' + icon + '"></i>' +
                                       qualityText +
                                   '</div>';
                                        }

                                        function getDayName(date) {
                                            const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
                                            return days[date.getDay()];
                                        }

                                        function applyWeatherTheme() {
                                            if (!weatherData) return;

                                            const widget = document.querySelector('.weather-widget');
                                            if (!widget) return;

                                            const condition = weatherData.current.condition.text.toLowerCase();
                                            
                                            // Remove existing theme classes
                                            widget.classList.remove('sunny', 'rainy', 'stormy');
                                            
                                            // Apply theme based on weather condition
                                            if (condition.includes('sunny') || condition.includes('clear') || condition.includes('nắng')) {
                                                widget.classList.add('sunny');
                                            } else if (condition.includes('rain') || condition.includes('drizzle') || condition.includes('mưa')) {
                                                widget.classList.add('rainy');
                                            } else if (condition.includes('thunder') || condition.includes('storm') || condition.includes('giông')) {
                                                widget.classList.add('stormy');
                                            }
                                        }

                                        function refreshWeather() {
                                            loadWeatherData();
                                        }

// Main initialization function
                                        function initializePage() {
                                            try {
                                                // Initialize core components
                                                initializeSwiper();

                                                // Initialize booking form manager
                                                window.bookingFormManager = new BookingFormManager();

                                                // Initialize weather widget
                                                setTimeout(() => {
                                                    loadWeatherData();
                                                }, 1000); // Delay to ensure page is fully loaded

                                                initializeSmoothScroll();
                                                initializeLazyLoading();

                                                // Enhance accessibility
                                                enhanceAccessibility();

                                                // Check favorite status
                                                checkIfFavorite();

                                                // Performance tracking
                                                trackPerformance();

                                                // Initial animation check
                                                animateOnScroll();

                                                // Update message badge if user is logged in
                                                updateMessageBadge();

                                                // Set up periodic message badge updates
                                                setInterval(updateMessageBadge, 30000);

                                                // Update badge when page gains focus
                                                window.addEventListener('focus', updateMessageBadge);

                                                // Initialize tooltips if Bootstrap is available
                                                if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                                                    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                        return new bootstrap.Tooltip(tooltipTriggerEl);
                                                    });
                                                }

                                                // Register service worker
                                                registerServiceWorker();

                                                console.log('Experience detail page initialized successfully');
                                            } catch (error) {
                                                console.error('Error initializing page:', error);
                                                showToast('Có lỗi xảy ra khi tải trang', 'error');
                                            }
                                        }

// Page load event
                                        document.addEventListener('DOMContentLoaded', initializePage);

// Page unload cleanup
                                        window.addEventListener('beforeunload', () => {
                                            if (swiper) {
                                                swiper.destroy(true, true);
                                            }
                                        });

// Handle page visibility changes
                                        document.addEventListener('visibilitychange', () => {
                                            if (!document.hidden) {
                                                // Page became visible, update message badge
                                                updateMessageBadge();
                                            }
                                        });

// Handle online/offline status
                                        window.addEventListener('online', () => {
                                            showToast('Kết nối mạng đã được khôi phục', 'success');
                                            updateMessageBadge();
                                        });

                                        window.addEventListener('offline', () => {
                                            showToast('Mất kết nối mạng. Một số tính năng có thể không hoạt động.', 'warning', 5000);
                                        });

// Export functions for global access
                                        window.experienceDetailFunctions = {
                                            shareExperience,
                                            saveExperience,
                                            chatWithHost,
                                            showContactInfo,
                                            showLoginRequired,
                                            openReviewModal,
                                            goToBooking,
                                            showToast,
                                            calculateTotal,
                                            formatCurrency,
                                            sendMessage,
                                            markMessagesAsRead,
                                            refreshWeather,
                                            loadWeatherData
                                        };

// Legacy global functions for backward compatibility
                                        window.shareExperience = shareExperience;
                                        window.saveExperience = saveExperience;
                                        window.chatWithHost = chatWithHost;
                                        window.showContactInfo = showContactInfo;
                                        window.showLoginRequired = showLoginRequired;
                                        window.openReviewModal = openReviewModal;
                                        window.goToBooking = goToBooking;
                                        window.showToast = showToast;
                                        window.calculateTotal = calculateTotal;
                                        window.formatCurrency = formatCurrency;
                                        window.sendMessage = sendMessage;
                                        window.markMessagesAsRead = markMessagesAsRead;
                                        window.refreshWeather = refreshWeather;
                                        window.loadWeatherData = loadWeatherData;

// Khi submit form booking, tự động điền các trường ẩn từ input người dùng
                                        const bookingForm = document.querySelector('.booking-form');
                                        if (bookingForm) {
                                          bookingForm.addEventListener('submit', function(e) {
                                            document.getElementById('hiddenBookingDate').value = document.getElementById('bookingDate').value;
                                            document.getElementById('hiddenParticipants').value = document.getElementById('participants').value;
                                            // Nếu có chọn khung giờ thì điền vào
                                            const selectedSlot = document.querySelector('.time-slot-option.selected');
                                            if (selectedSlot) {
                                              document.getElementById('hiddenTimeSlot').value = selectedSlot.getAttribute('data-slot');
                                            }
                                          });
                                        }

                                        function openReportModal() {
                                            // Lấy biến từ JSP
                                            var isLoggedIn = ('${not empty sessionScope.user ? "true" : "false"}' === 'true');
                                            var canReport = ('${canReportExperience ? "true" : "false"}' === 'true');

                                            const modal = document.getElementById('reportModal');
                                            const modalContent = document.getElementById('reportModalContent');
                                            if (!modal || !modalContent) return;

                                            if (!isLoggedIn || !canReport) {
                                                // Hiện thông báo giống modal đánh giá
                                                modalContent.innerHTML = `
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Báo cáo trải nghiệm</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                                    </div>
                                                    <div class="modal-body text-center">
                                                        <i class="ri-information-line" style="font-size:3rem;color:#FF385C"></i>
                                                        <h5 class="mt-3 mb-2">Chỉ khách đã đặt tour mới có thể báo cáo</h5>
                                                        <p class="text-muted mb-4">Vui lòng đặt và tham gia trải nghiệm để có thể gửi báo cáo.</p>
                                                        <button class="btn btn-primary" onclick="goToBookingFromReport();return false;">Đặt ngay</button>
                                                    </div>
                                                `;
                                            } else {
                                                // Hiện form báo cáo như cũ
                                                modalContent.innerHTML = `
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="reportModalLabel">Báo cáo trải nghiệm</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form id="reportForm">
                                                            <div class="mb-3">
                                                                <label for="reportReason" class="form-label">Lý do báo cáo</label>
                                                                <select class="form-control" id="reportReason" required>
                                                                    <option value="">Chọn lý do</option>
                                                                    <option value="spam">Spam/quảng cáo</option>
                                                                    <option value="inappropriate">Nội dung không phù hợp</option>
                                                                    <option value="fraud">Lừa đảo</option>
                                                                    <option value="other">Khác</option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="reportDetail" class="form-label">Chi tiết (tuỳ chọn)</label>
                                                                <textarea class="form-control" id="reportDetail" rows="3"></textarea>
                                                            </div>
                                                            <button type="submit" class="btn btn-primary">Gửi báo cáo</button>
                                                        </form>
                                                    </div>
                                                `;
                                            }

                                            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                const bsModal = new bootstrap.Modal(modal);
                                                bsModal.show();
                                            } else {
                                                modal.style.display = 'block';
                                                modal.classList.add('show');
                                                document.body.classList.add('modal-open');
                                            }

                                            // Gắn lại event submit cho form nếu có
                                            setTimeout(() => {
                                                const reportForm = document.getElementById('reportForm');
                                                if (reportForm) {
                                                    reportForm.addEventListener('submit', function(e) {
                                                        e.preventDefault();
                                                        // Lấy dữ liệu từ form
                                                        const reason = document.getElementById('reportReason').value;
                                                        const description = document.getElementById('reportDetail').value;
                                                        const experienceId = "${experience.experienceId}";

                                                        // Gửi AJAX POST tới JSP handler
                                                        fetch('${pageContext.request.contextPath}/view/jsp/report-handler.jsp', {
                                                            method: 'POST',
                                                            headers: {
                                                                'Content-Type': 'application/x-www-form-urlencoded'
                                                            },
                                                            body: new URLSearchParams({
                                                                contentType: 'experience',
                                                                contentId: experienceId,
                                                                reason: reason,
                                                                description: description
                                                            })
                                                        })
                                                        .then(response => {
                                                            if (response.ok) {
                                                                showToast('Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét trong thời gian sớm nhất!', 'success');
                                                            } else {
                                                                showToast('Gửi báo cáo thất bại!', 'error');
                                                            }
                                                            // Đóng modal
                                                            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                                const modal = bootstrap.Modal.getInstance(document.getElementById('reportModal'));
                                                                if (modal) modal.hide();
                                                            }
                                                            reportForm.reset();
                                                        })
                                                        .catch(() => {
                                                            showToast('Gửi báo cáo thất bại!', 'error');
                                                        });
                                                    });
                                                }
                                            }, 200);
                                        }

                                        document.addEventListener('DOMContentLoaded', function() {
                                            const reportForm = document.getElementById('reportForm');
                                            if (reportForm) {
                                                reportForm.addEventListener('submit', function(e) {
                                                    e.preventDefault();
                                                    showToast('Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét trong thời gian sớm nhất!', 'success');
                                                    if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                        const modal = bootstrap.Modal.getInstance(document.getElementById('reportModal'));
                                                        if (modal) modal.hide();
                                                    } else {
                                                        const modal = document.getElementById('reportModal');
                                                        modal.style.display = 'none';
                                                        modal.classList.remove('show');
                                                        document.body.classList.remove('modal-open');
                                                    }
                                                    reportForm.reset();
                                                });
                                            }
                                        });

                                        function goToBookingFromReport() {
                                            // Đóng modal báo cáo
                                            const reportModal = document.getElementById('reportModal');
                                            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                                                const modal = bootstrap.Modal.getInstance(reportModal);
                                                if (modal) modal.hide();
                                            } else {
                                                reportModal.style.display = 'none';
                                                reportModal.classList.remove('show');
                                                document.body.classList.remove('modal-open');
                                            }
                                            // Cuộn mượt xuống phần booking
                                            setTimeout(() => {
                                                const bookingSection = document.querySelector('.booking-card');
                                                if (bookingSection) {
                                                    const navbar = document.querySelector('.custom-navbar');
                                                    const navbarHeight = navbar ? navbar.offsetHeight : 0;
                                                    const targetPosition = bookingSection.getBoundingClientRect().top + window.scrollY - navbarHeight - 20;
                                                    window.scrollTo({
                                                        top: targetPosition,
                                                        behavior: 'smooth'
                                                    });
                                                    // Highlight booking card
                                                    bookingSection.style.transition = 'all 0.3s ease';
                                                    bookingSection.style.boxShadow = '0 0 20px rgba(255, 56, 92, 0.4)';
                                                    setTimeout(() => {
                                                        bookingSection.style.boxShadow = '';
                                                    }, 2000);
                                                }
                                            }, 350);
                                        }
        </script>

        <!-- Simple Map Helper Functions -->
        <script>
            // CRITICAL DEBUG: Check if JSP object exists first
            console.log("🚨 CRITICAL DEBUG - JSP Object Check:");
            console.log("experience object exists:", typeof experience !== 'undefined');
            
            // Try to access experience from window/global
            console.log("window.experience exists:", typeof window.experience !== 'undefined');
            console.log("Page title:", document.title);
            console.log("Current URL:", window.location.href);
            
            // Raw JSP output debugging
            console.log("Raw JSP outputs:");
            console.log("experience.location JSP:", "${experience.location}");
            console.log("experience.cityName JSP:", "${experience.cityName}");
            console.log("experience.title JSP:", "${experience.title}");
            
            // Experience location from JSP - Enhanced formatting with validation
            const rawLocation = "${experience.location}" || "";
            const cityName = "${experience.cityName}" || "";
            const experienceTitle = "${experience.title}" || "";
            
            // Immediate debug - check if JSP variables are properly loaded
            console.log("🔍 JSP Variables Check:", {
                rawLocation: rawLocation,
                cityName: cityName,
                experienceTitle: experienceTitle,
                rawLocationLength: rawLocation.length,
                cityNameLength: cityName.length,
                rawLocationEquals: (rawLocation === "${experience.location}"),
                cityNameEquals: (cityName === "${experience.cityName}"),
                rawLocationTrimmed: rawLocation.trim(),
                cityNameTrimmed: cityName.trim()
            });
            
            // Create comprehensive address for better Google Maps recognition
            function buildFullAddress() {
                console.log("🏗️ buildFullAddress() called with:", {
                    rawLocation: rawLocation,
                    rawLocationType: typeof rawLocation,
                    rawLocationLength: rawLocation ? rawLocation.length : 'N/A',
                    cityName: cityName,
                    cityNameType: typeof cityName
                });
                
                // Validate inputs first
                if (!rawLocation || rawLocation.trim() === "" || rawLocation === "null") {
                    console.error("❌ rawLocation validation failed:", rawLocation);
                    return "Không có địa chỉ";
                }
                
                let fullAddress = rawLocation.trim();
                console.log("🔧 Step 1 - Trimmed rawLocation:", fullAddress);
                
                // Add city if not already included and exists
                if (cityName && cityName.trim() && !fullAddress.toLowerCase().includes(cityName.toLowerCase())) {
                    fullAddress += ", " + cityName.trim();
                    console.log("🔧 Step 2 - Added city:", fullAddress);
                } else {
                    console.log("🔧 Step 2 - City already included or empty");
                }
                
                // Add country if not already included
                if (!fullAddress.toLowerCase().includes("việt nam") && !fullAddress.toLowerCase().includes("vietnam")) {
                    fullAddress += ", Việt Nam";
                    console.log("🔧 Step 3 - Added country:", fullAddress);
                } else {
                    console.log("🔧 Step 3 - Country already included");
                }
                
                console.log("✅ buildFullAddress() result:", fullAddress);
                return fullAddress;
            }
            
            // Build the address with fallback
            console.log("🚀 Calling buildFullAddress()...");
            let experienceLocation = buildFullAddress();
            console.log("🎯 buildFullAddress() returned:", experienceLocation);
            
            // ENHANCED FALLBACK SYSTEM
            if (!experienceLocation || experienceLocation === "Không có địa chỉ") {
                console.error("❌ buildFullAddress() failed, trying fallbacks...");
                
                // Try cityName
                if (cityName && cityName.trim() && cityName !== "${experience.cityName}") {
                    experienceLocation = cityName + ", Việt Nam";
                    console.warn("⚠️ Using cityName fallback:", experienceLocation);
                }
                // Try title as location
                else if (experienceTitle && experienceTitle.trim() && experienceTitle !== "${experience.title}") {
                    experienceLocation = experienceTitle + ", Việt Nam";
                    console.warn("⚠️ Using title fallback:", experienceLocation);
                }
                // Ultimate fallback
                else {
                    experienceLocation = "Việt Nam";
                    console.warn("⚠️ Using ultimate fallback:", experienceLocation);
                    
                    // Show user a helpful message
                    setTimeout(() => {
                        showToast('⚠️ Không tìm thấy địa chỉ cụ thể. Hãy dùng "Nhập địa chỉ thủ công"', 'warning', 5000);
                    }, 2000);
                }
            } else {
                console.log("✅ Address built successfully:", experienceLocation);
            }
            
            // Debug info for address building
            console.log("📍 Address Debug:", {
                rawLocation: rawLocation,
                cityName: cityName,
                fullAddress: experienceLocation,
                experienceLocationLength: experienceLocation ? experienceLocation.length : 0,
                experienceLocationType: typeof experienceLocation,
                isValid: experienceLocation && experienceLocation !== "Không có địa chỉ"
            });

            // Open Google Maps with directions (Primary method)
            function openGoogleMapsDirections() {
                // Safety check and fallback
                let addressToUse = experienceLocation;
                if (!addressToUse || addressToUse.trim() === "") {
                    addressToUse = "Việt Nam"; // Ultimate fallback
                    console.warn("🚨 No address available, using fallback");
                    showToast('⚠️ Không có địa chỉ cụ thể, mở Google Maps Việt Nam', 'warning');
                }
                
                const encodedLocation = encodeURIComponent(addressToUse);
                
                // ENHANCED FORMAT: Include current location detection
                const mapsUrl = 'https://www.google.com/maps/dir//' + encodedLocation + '?hl=vi';
                
                console.log('🗺️ Opening Google Maps (Enhanced with Current Location):', {
                    originalAddress: experienceLocation,
                    addressUsed: addressToUse,
                    encodedAddress: encodedLocation,
                    url: mapsUrl,
                    urlLength: mapsUrl.length
                });
                
                // Validate URL before opening
                if (!mapsUrl || mapsUrl.length < 40 || !mapsUrl.includes('google.com/maps')) {
                    console.error('❌ Invalid Google Maps URL:', mapsUrl);
                    showToast('❌ Lỗi tạo URL Google Maps', 'error');
                    return;
                }
                
                window.open(mapsUrl, '_blank');
                showToast('🎯 Google Maps: Tự động điền đích + detect vị trí hiện tại', 'success');
                
                // Enhanced instructions
                setTimeout(() => {
                    showToast('📍 Cho phép Google Maps truy cập vị trí để có directions tự động!', 'info');
                }, 2000);
                
                setTimeout(() => {
                    showToast('✅ Nếu không detect vị trí → Bấm "Your location" hoặc nhập địa chỉ xuất phát', 'info');
                }, 4000);
            }






















            






            // Export variable to global scope for debugging
            window.debugVars = {
                rawLocation: rawLocation,
                cityName: cityName,
                experienceTitle: experienceTitle,
                experienceLocation: experienceLocation
            };
            
            console.log("🌍 Global debug vars exported:", window.debugVars);

        </script>

        <!-- Modal chứa form đánh giá đặt ngay sau action-buttons -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel">Đánh giá trải nghiệm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <jsp:include page="/view/jsp/common/review.jsp">
                            <jsp:param name="experience" value="${experience}" />
                        </jsp:include>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Báo Cáo -->
        <div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" id="reportModalContent">
                    <!-- Nội dung sẽ được render bằng JS -->
                </div>
            </div>
        </div>
    </body>
</html>
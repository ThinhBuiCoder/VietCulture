<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${accommodation.name} | VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
        <style>
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

            .btn-copy {
                background-color: transparent;
                border: 1px solid rgba(0,0,0,0.1);
                cursor: pointer;
                color: #6c757d;
                transition: var(--transition);
                padding: 10px 15px;
                border-radius: 8px;
                font-size: 0.9rem;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                width: 100%;
            }

            .btn-copy:hover {
                color: var(--dark-color);
                background-color: rgba(0,0,0,0.05);
                border-color: rgba(0,0,0,0.2);
            }

            .btn-copy i {
                font-size: 1rem;
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
                width: 100%;
            }

            .btn-primary:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            }

            .btn-primary:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
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

            .accommodation-title {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 15px;
                color: var(--dark-color);
            }

            .accommodation-subtitle {
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

            /* Amenities Grid */
            .amenities-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .amenity-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px;
                background: rgba(131, 197, 190, 0.1);
                border-radius: 10px;
                transition: var(--transition);
            }

            .amenity-item:hover {
                background: rgba(131, 197, 190, 0.2);
                transform: translateX(5px);
            }

            .amenity-item i {
                color: var(--secondary-color);
                font-size: 1.1rem;
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

            /* ============================================================================= */
            /* FIXED BOOKING FORM STYLES */
            /* ============================================================================= */

            /* Booking Card */
            .booking-card {
                border: 2px solid var(--primary-color);
                border-radius: var(--border-radius);
                padding: 25px;
                background: var(--light-color);
                box-shadow: var(--shadow-lg);
            }

            /* Price Display */
            .price-display {
                text-align: center;
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .price-amount {
                font-size: 2rem;
                font-weight: 800;
                color: var(--primary-color);
                margin-bottom: 5px;
                line-height: 1.2;
            }

            .price-unit {
                color: #6c757d;
                font-size: 0.9rem;
                font-weight: 500;
            }

            /* Date Selection Wrapper */
            .date-selection-wrapper {
                margin-bottom: 20px;
            }

            .date-input-group {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .date-field {
                width: 100%;
            }

            .date-field label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
                font-size: 0.9rem;
            }

            .date-field .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid rgba(0,0,0,0.1);
                border-radius: 10px;
                font-size: 1rem;
                transition: var(--transition);
                background: white;
                box-sizing: border-box;
            }

            .date-field .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            .date-field .form-control.is-valid {
                border-color: #28a745;
                background-image: none;
            }

            .date-field .form-control.is-invalid {
                border-color: #dc3545;
                background-image: none;
            }

            .date-field .form-text {
                font-size: 0.8rem;
                color: #6c757d;
                margin-top: 5px;
            }

            .date-field .invalid-feedback {
                display: block;
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
            }

            /* Fix for date input styling */
            .date-field .form-control[type="date"] {
                position: relative;
                padding-right: 40px;
            }

            .date-field .form-control[type="date"]::-webkit-calendar-picker-indicator {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                color: var(--primary-color);
            }

            /* Availability Info */
            .availability-info {
                margin: 15px 0;
            }

            .availability-info .alert {
                margin: 0;
                padding: 12px;
                border-radius: 8px;
                font-size: 0.9rem;
            }

            .alert-info {
                background-color: rgba(23, 162, 184, 0.1);
                border-color: rgba(23, 162, 184, 0.3);
                color: #0c5460;
            }

            .alert-success {
                background-color: rgba(40, 167, 69, 0.1);
                border-color: rgba(40, 167, 69, 0.3);
                color: #155724;
            }

            /* Date Warning */
            .date-warning {
                margin: 15px 0;
            }

            .date-warning .alert-warning {
                background-color: rgba(255, 193, 7, 0.1);
                border-color: rgba(255, 193, 7, 0.3);
                color: #856404;
                padding: 12px;
                border-radius: 8px;
                font-size: 0.9rem;
            }

            /* Booking Summary */
            .booking-summary {
                background: rgba(131, 197, 190, 0.1);
                padding: 15px;
                border-radius: 10px;
                margin: 20px 0;
                border: 1px solid rgba(131, 197, 190, 0.3);
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
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
                margin-bottom: 0;
            }

            /* Submit Section */
            .submit-section {
                margin: 20px 0;
            }

            /* Loading state for button */
            .btn-primary .btn-loading {
                display: none !important;
                align-items: center;
                justify-content: center;
            }

            .btn-primary.loading .btn-text {
                display: none;
            }

            .btn-primary.loading .btn-loading {
                display: flex !important;
            }

            /* Security Notice */
            .security-notice {
                text-align: center;
                margin: 15px 0;
                padding: 10px;
                background: rgba(40, 167, 69, 0.05);
                border-radius: 8px;
                border: 1px solid rgba(40, 167, 69, 0.1);
            }

            .security-notice small {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 5px;
                color: #28a745;
                font-weight: 500;
            }

            /* Share Section */
            .share-section {
                margin: 15px 0;
            }

            /* Contact Host Section */
            .contact-host-section {
                margin-top: 25px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                border: 1px solid rgba(0,0,0,0.1);
            }

            .contact-host-section h6 {
                color: var(--dark-color);
                font-weight: 600;
            }

            /* Safety Info Section */
            .safety-info-section {
                margin-top: 20px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                border: 1px solid rgba(0,0,0,0.1);
            }

            .safety-info-section h6 {
                color: var(--dark-color);
                font-weight: 600;
            }

            .safety-info-section ul li {
                display: flex;
                align-items: center;
                font-size: 0.9rem;
                color: #6c757d;
            }

            /* ============================================================================= */
            /* END OF FIXED BOOKING FORM STYLES */
            /* ============================================================================= */

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
                color: #FFD700;
                margin-left: auto;
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

            /* Responsive Design */
            @media (max-width: 992px) {
                .content-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .sidebar {
                    position: relative;
                    top: 0;
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
            }

            @media (max-width: 768px) {
                .accommodation-title {
                    font-size: 1.8rem;
                }

                .accommodation-subtitle {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .action-buttons {
                    justify-content: center;
                }

                .rating-overview {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .info-cards {
                    grid-template-columns: 1fr;
                }

                .custom-navbar {
                    padding: 10px 0;
                }

                /* Responsive booking form */
                .date-input-group {
                    gap: 12px;
                }

                .date-field .form-control {
                    padding: 10px 14px;
                    font-size: 0.95rem;
                }

                .booking-summary {
                    padding: 12px;
                }

                .contact-host-section,
                .safety-info-section {
                    padding: 15px;
                }
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

            /* Legacy form styles - keep for compatibility */
            .booking-form .form-group {
                margin-bottom: 20px;
            }

            .booking-form label {
                font-weight: 600;
                margin-bottom: 8px;
                color: var(--dark-color);
            }

            .booking-form .form-control {
                border-radius: 10px;
                padding: 12px;
                border: 2px solid rgba(0,0,0,0.1);
                transition: var(--transition);
            }

            .booking-form .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
            }

            /* Additional validation states */
            .form-control.is-valid {
                border-color: #28a745;
                background-image: none;
            }

            .form-control.is-invalid {
                border-color: #dc3545;
                background-image: none;
            }

            .invalid-feedback {
                display: block;
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
            }

            .btn-loading {
                display: none;
            }

            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .form-text {
                font-size: 0.8rem;
                color: #6c757d;
                margin-top: 3px;
            }

            /* Enhanced form field focus states */
            .date-field .form-control:focus,
            .booking-form .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
                transform: translateY(-1px);
            }

            /* Smooth transitions for all interactive elements */
            .date-field .form-control,
            .booking-form .form-control,
            .btn,
            .action-btn,
            .btn-copy {
                transition: all 0.3s ease;
            }

            /* Enhanced hover states */
            .date-field .form-control:hover:not(:focus),
            .booking-form .form-control:hover:not(:focus) {
                border-color: rgba(255, 56, 92, 0.3);
            }

            /* Accessibility improvements */
            .date-field label,
            .booking-form label {
                cursor: pointer;
            }

            .date-field .form-control:focus + .form-text,
            .booking-form .form-control:focus + .form-text {
                color: var(--primary-color);
            }

            /* Error state animations */
            .form-control.is-invalid {
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                10%, 30%, 50%, 70%, 90% {
                    transform: translateX(-2px);
                }
                20%, 40%, 60%, 80% {
                    transform: translateX(2px);
                }
            }

            /* Success state animations */
            .form-control.is-valid {
                animation: successPulse 0.6s ease-in-out;
            }

            @keyframes successPulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.02);
                }
                100% {
                    transform: scale(1);
                }
            }

            /* Loading spinner for submit button */
            .spinner-border-sm {
                width: 1rem;
                height: 1rem;
                border-width: 0.2em;
            }

            /* Enhanced mobile responsiveness */
            @media (max-width: 576px) {
                .booking-card {
                    padding: 20px;
                }

                .price-amount {
                    font-size: 1.7rem;
                }

                .date-field .form-control {
                    padding: 12px;
                    font-size: 0.9rem;
                }

                .btn-primary {
                    padding: 14px 20px;
                    font-size: 0.95rem;
                }

                .contact-host-section,
                .safety-info-section {
                    padding: 12px;
                }
            }

            /* Dark mode support (optional) */
            @media (prefers-color-scheme: dark) {
                .booking-card {
                    background: #1a1a1a;
                    border-color: var(--primary-color);
                }

                .date-field .form-control,
                .booking-form .form-control {
                    background: #2a2a2a;
                    color: white;
                    border-color: #444;
                }

                .date-field .form-control:focus,
                .booking-form .form-control:focus {
                    background: #2a2a2a;
                    color: white;
                }
            }

            /* Print styles */
            @media print {
                .booking-card,
                .contact-host-section,
                .safety-info-section {
                    box-shadow: none;
                    border: 1px solid #ccc;
                }

                .btn-primary,
                .btn-copy {
                    display: none;
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
                    <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                        Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/experiences" class="nav-center-item">
                        Trải Nghiệm
                    </a>
                    <a href="${pageContext.request.contextPath}/accommodations" class="nav-center-item active">
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
                            <a href="${pageContext.request.contextPath}/accommodations">Chỗ Lưu Trú</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            ${accommodation.name}
                        </li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Header Section -->
        <section class="detail-header">
            <div class="container">
                <div class="fade-up">
                    <h1 class="accommodation-title">${accommodation.name}</h1>

                    <div class="accommodation-subtitle">
                        <div class="subtitle-item">
                            <i class="ri-star-fill"></i>
                            <c:choose>
                                <c:when test="${accommodation.averageRating > 0}">
                                    <span><fmt:formatNumber value="${accommodation.averageRating}" maxFractionDigits="1" /></span>
                                    <span>(${accommodation.totalBookings} đánh giá)</span>
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
                                    <c:when test="${not empty accommodation.cityName}">
                                        ${accommodation.cityName}, ${accommodation.address}
                                    </c:when>
                                    <c:otherwise>
                                        ${accommodation.address}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="subtitle-item">
                            <i class="ri-building-line"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${accommodation.type == 'Homestay'}">Homestay</c:when>
                                    <c:when test="${accommodation.type == 'Hotel'}">Khách Sạn</c:when>
                                    <c:when test="${accommodation.type == 'Resort'}">Resort</c:when>
                                    <c:when test="${accommodation.type == 'Guesthouse'}">Nhà Nghỉ</c:when>
                                    <c:otherwise>${accommodation.type}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="#" class="action-btn" onclick="event.preventDefault(); shareAccommodation();">
                            <i class="ri-share-line"></i>
                            <span>Chia sẻ</span>
                        </a>
                        <a href="#" class="action-btn" onclick="event.preventDefault(); saveAccommodation();">
                            <i class="ri-heart-line"></i>
                            <span>Lưu</span>
                        </a>
                        <button class="action-btn" type="button" data-bs-toggle="modal" data-bs-target="#reviewModal">
                            <i class="ri-star-line"></i>
                            <span>Đánh giá</span>
                        </button>
                        <a href="#location" class="action-btn">
                            <i class="ri-map-pin-line"></i>
                            <span>Vị trí</span>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Image Gallery -->
        <div class="container">
            <div class="image-gallery fade-up">
                <div class="swiper accommodation-swiper">
                    <div class="swiper-wrapper">
                        <c:choose>
                            <c:when test="${not empty accommodation.images}">
                                <c:set var="imageList" value="${fn:split(accommodation.images, ',')}" />
                                <c:forEach var="image" items="${imageList}">
                                    <div class="swiper-slide">
                                        <img src="${pageContext.request.contextPath}/images/accommodations/${fn:trim(image)}" 
                                             alt="${accommodation.name}" 
                                             onerror="this.src='https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${accommodation.name}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${accommodation.name}">
                                </div>
                                <div class="swiper-slide">
                                    <img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                         alt="${accommodation.name}">
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
                            Chủ nhà ${accommodation.hostName}
                        </h3>

                        <div class="host-info-card">
                            <img src="https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png" 
                                 alt="Host Avatar" class="host-avatar">
                            <div class="host-details">
                                <h4>${accommodation.hostName}</h4>
                                <p class="text-muted">Chủ nhà địa phương • Tham gia từ 2023</p>
                                <div class="host-stats">
                                    <span class="host-stat">
                                        <i class="ri-star-fill" style="color: #FFD700;"></i>
                                        4.8 (127 đánh giá)
                                    </span>
                                    <span class="host-stat">
                                        <i class="ri-check-line" style="color: #4BB543;"></i>
                                        Đã xác minh danh tính
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Accommodation Info -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-information-line"></i>
                            Thông tin chỗ ở
                        </h3>

                        <div class="info-cards">
                            <div class="info-card">
                                <i class="ri-door-line"></i>
                                <h5>${accommodation.numberOfRooms} Phòng</h5>
                                <p>Phòng riêng tư</p>
                            </div>


                            <div class="info-card">
                                <i class="ri-group-line"></i>
                                <h5>${accommodation.maxOccupancy} khách</h5>
                                <p>Tối đa cho nhóm</p>
                            </div>


                            <div class="info-card">
                                <i class="ri-car-line"></i>
                                <h5>Chỗ đậu xe</h5>
                                <p>Miễn phí</p>
                            </div>
                            <div class="info-card">
                                <i class="ri-wifi-line"></i>
                                <h5>WiFi</h5>
                                <p>Tốc độ cao</p>
                            </div>
                        </div>

                        <p style="font-size: 1.1rem; line-height: 1.7; color: var(--dark-color);">
                            ${accommodation.description}
                        </p>
                    </div>

                    <!-- Amenities -->
                    <div class="content-section">
                        <h3 class="section-title">
                            <i class="ri-service-line"></i>
                            Tiện nghi
                        </h3>

                        <div class="amenities-grid">
                            <c:choose>
                                <c:when test="${not empty accommodation.amenities}">
                                    <c:set var="amenityList" value="${fn:split(accommodation.amenities, ',')}" />
                                    <c:forEach var="amenity" items="${amenityList}">
                                        <div class="amenity-item">
                                            <i class="ri-check-line"></i>
                                            <span>${fn:trim(amenity)}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="amenity-item">
                                        <i class="ri-wifi-line"></i>
                                        <span>WiFi miễn phí</span>
                                    </div>
                                    <div class="amenity-item">
                                        <i class="ri-car-line"></i>
                                        <span>Chỗ đậu xe</span>
                                    </div>
                                    <div class="amenity-item">
                                        <i class="ri-air-conditioner-line"></i>
                                        <span>Điều hòa không khí</span>
                                    </div>
                                    <div class="amenity-item">
                                        <i class="ri-tv-line"></i>
                                        <span>TV</span>
                                    </div>
                                    <div class="amenity-item">
                                        <i class="ri-fridge-line"></i>
                                        <span>Tủ lạnh</span>
                                    </div>
                                    <div class="amenity-item">
                                        <i class="ri-wash-machine-line"></i>
                                        <span>Máy giặt</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
                                    <p class="text-muted">Hãy là người đầu tiên đánh giá chỗ lưu trú này!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Location Section -->
                    <div class="content-section" id="location">
                        <h3 class="section-title">
                            <i class="ri-map-pin-line"></i>
                            Vị trí
                        </h3>

                        <p class="mb-3">
                            <strong>Địa chỉ:</strong> ${accommodation.address}
                            <c:if test="${not empty accommodation.cityName}">
                                , ${accommodation.cityName}
                            </c:if>
                        </p>

                        <div class="map-container">
                            <div class="text-center">
                                <i class="ri-map-pin-line" style="font-size: 3rem; margin-bottom: 15px;"></i>
                                <h5>Bản đồ sẽ được hiển thị ở đây</h5>
                                <p class="text-muted">Tích hợp Google Maps hoặc OpenStreetMap</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar - Booking Card -->
                <div class="sidebar">
                    <div class="booking-card">
                        <div class="price-display">
                            <div class="price-amount">
                                <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                            </div>
                            <div class="price-unit">mỗi đêm</div>
                        </div>

                        <form class="booking-form" action="${pageContext.request.contextPath}/booking" method="get">
                            <input type="hidden" name="accommodationId" value="${accommodation.accommodationId}">

                            <!-- Date Selection Section -->
                            <div class="date-selection-wrapper">
                                <div class="date-input-group">
                                    <div class="date-field">
                                        <label for="checkIn">Ngày nhận phòng <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="checkIn" name="checkIn" required>
                                        <div class="form-text">14:00 - Nhận phòng</div>
                                        <div class="invalid-feedback" id="checkInError"></div>
                                    </div>

                                    <div class="date-field">
                                        <label for="checkOut">Ngày trả phòng <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="checkOut" name="checkOut" required>
                                        <div class="form-text">12:00 - Trả phòng</div>
                                        <div class="invalid-feedback" id="checkOutError"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Booking availability info -->
                            <div class="availability-info" id="availabilityInfo" style="display: none;">
                                <div class="alert alert-info">
                                    <i class="ri-information-line me-2"></i>
                                    <span id="availabilityText"></span>
                                </div>
                            </div>

                            <!-- Date validation warning -->
                            <div class="date-warning" id="dateWarning" style="display: none;">
                                <div class="alert alert-warning">
                                    <i class="ri-alert-line me-2"></i>
                                    <span id="warningText"></span>
                                </div>
                            </div>

                            <!-- Booking Summary -->
                            <div class="booking-summary" id="bookingSummary" style="display: none;">
                                <div class="summary-row">
                                    <span>Giá phòng × <span id="nightCount">0</span> đêm</span>
                                    <span id="roomTotal">0 VNĐ</span>
                                </div>
                                <div class="summary-row">
                                    <span>Phí dịch vụ (5%)</span>
                                    <span id="serviceFee">0 VNĐ</span>
                                </div>
                                <div class="summary-row summary-total">
                                    <span>Tổng cộng</span>
                                    <span id="totalAmount">0 VNĐ</span>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="submit-section">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <button type="submit" class="btn btn-primary w-100" id="bookingBtn" disabled>
                                            <span class="btn-text">
                                                <i class="ri-calendar-check-line me-2"></i>Đặt Phòng Ngay
                                            </span>
                                            <span class="btn-loading d-none">
                                                <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                            </span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary w-100">
                                            <i class="ri-login-circle-line me-2"></i>Đăng Nhập để Đặt Phòng
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </form>

                        <!-- Security Notice -->
                        <div class="security-notice">
                            <small class="text-muted">
                                <i class="ri-shield-check-line me-1"></i>
                                Bạn sẽ chưa bị tính phí - Thanh toán an toàn
                            </small>
                        </div>

                        <!-- Share Button -->
                        <div class="share-section">
                            <button class="btn-copy w-100" onclick="shareAccommodation()">
                                <i class="ri-share-line"></i>
                                <span>Chia sẻ chỗ lưu trú này</span>
                            </button>
                        </div>
                    </div>

                    <!-- Contact Host Section -->
                    <div class="contact-host-section">
                        <h6 class="mb-3">Liên hệ chủ nhà</h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary btn-sm">
                                <i class="ri-message-3-line me-2"></i>Gửi tin nhắn
                            </button>
                            <button class="btn btn-outline-primary btn-sm">
                                <i class="ri-phone-line me-2"></i>Gọi điện thoại
                            </button>
                        </div>
                    </div>

                    <!-- Safety Info Section -->
                    <div class="safety-info-section">
                        <h6 class="mb-3">
                            <i class="ri-shield-check-line me-2"></i>An toàn & Bảo mật
                        </h6>
                        <ul class="list-unstyled mb-0 small">
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Thanh toán an toàn
                            </li>
                            <li class="mb-2">
                                <i class="ri-check-line text-success me-2"></i>
                                Chủ nhà đã xác minh
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
                        <p><i class="ri-map-pin-line me-2"></i>  Khu đô thị FPT City, Ngũ Hành Sơn, Da Nang 550000, Vietnam</p>
                        <p><i class="ri-mail-line me-2"></i>  f5@vietculture.vn</p>
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
                                const swiper = new Swiper('.accommodation-swiper', {
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
                                    }
                                });

// Utility function for currency formatting
                                function formatCurrency(amount) {
                                    return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                }

// Enhanced booking form functionality with validation
                                document.addEventListener('DOMContentLoaded', function () {
                                    const checkInInput = document.getElementById('checkIn');
                                    const checkOutInput = document.getElementById('checkOut');
                                    const bookingSummary = document.getElementById('bookingSummary');
                                    const bookingBtn = document.getElementById('bookingBtn');
                                    const availabilityInfo = document.getElementById('availabilityInfo');
                                    const dateWarning = document.getElementById('dateWarning');

                                    let pricePerNight = Number('${accommodation.pricePerNight}');
                                    if (isNaN(pricePerNight))
                                        pricePerNight = 0;

                                    // Constants
                                    const MAX_ADVANCE_BOOKING_DAYS = 60;
                                    const MAX_STAY_DURATION_DAYS = 30;

                                    // Set date constraints
                                    initializeDateConstraints();

                                    // Add event listeners
                                    if (checkInInput) {
                                        checkInInput.addEventListener('change', function () {
                                            validateCheckInDate(this.value);
                                            updateCheckOutConstraints(this.value);
                                            calculateTotal();
                                        });
                                    }

                                    if (checkOutInput) {
                                        checkOutInput.addEventListener('change', function () {
                                            validateCheckOutDate(checkInInput.value, this.value);
                                            calculateTotal();
                                        });
                                    }

                                    function initializeDateConstraints() {
                                        if (!checkInInput)
                                            return;

                                        const today = new Date();
                                        const todayStr = today.toISOString().split('T')[0];

                                        // Set minimum date to today
                                        checkInInput.min = todayStr;

                                        // Set maximum date to 60 days from today
                                        const maxDate = new Date();
                                        maxDate.setDate(maxDate.getDate() + MAX_ADVANCE_BOOKING_DAYS);
                                        checkInInput.max = maxDate.toISOString().split('T')[0];

                                        console.log('Date constraints set:', {
                                            min: todayStr,
                                            max: maxDate.toISOString().split('T')[0]
                                        });
                                    }

                                    function updateCheckOutConstraints(checkInValue) {
                                        if (!checkInValue || !checkOutInput)
                                            return;

                                        const checkInDate = new Date(checkInValue);

                                        // Minimum checkout: 1 day after checkin
                                        const minCheckOut = new Date(checkInDate);
                                        minCheckOut.setDate(minCheckOut.getDate() + 1);
                                        checkOutInput.min = minCheckOut.toISOString().split('T')[0];

                                        // Maximum checkout: 30 days after checkin or 60 days from today, whichever is earlier
                                        const maxFromStay = new Date(checkInDate);
                                        maxFromStay.setDate(maxFromStay.getDate() + MAX_STAY_DURATION_DAYS);

                                        const maxFromToday = new Date();
                                        maxFromToday.setDate(maxFromToday.getDate() + MAX_ADVANCE_BOOKING_DAYS);

                                        const maxCheckOut = maxFromStay < maxFromToday ? maxFromStay : maxFromToday;
                                        checkOutInput.max = maxCheckOut.toISOString().split('T')[0];

                                        // Auto-set checkout if not set
                                        if (!checkOutInput.value && checkInValue) {
                                            const autoCheckOut = new Date(checkInDate);
                                            autoCheckOut.setDate(autoCheckOut.getDate() + 1);
                                            checkOutInput.value = autoCheckOut.toISOString().split('T')[0];
                                            checkOutInput.classList.add('auto-filled');

                                            // Show notification
                                            showAvailabilityInfo('Tự động đặt ngày trả phòng: ' + formatDateVN(autoCheckOut), 'info');
                                        }
                                    }

                                    function validateCheckInDate(dateStr) {
                                        if (!checkInInput)
                                            return false;

                                        if (!dateStr) {
                                            setValidationState(checkInInput, false, 'Vui lòng chọn ngày nhận phòng');
                                            return false;
                                        }

                                        const checkInDate = new Date(dateStr);
                                        const today = new Date();
                                        today.setHours(0, 0, 0, 0);

                                        // Check if date is in the past
                                        if (checkInDate < today) {
                                            setValidationState(checkInInput, false, 'Ngày nhận phòng không thể là ngày trong quá khứ');
                                            return false;
                                        }

                                        // Check maximum advance booking
                                        const maxDate = new Date();
                                        maxDate.setDate(maxDate.getDate() + MAX_ADVANCE_BOOKING_DAYS);
                                        if (checkInDate > maxDate) {
                                            setValidationState(checkInInput, false, 'Chỉ có thể đặt trước tối đa ' + MAX_ADVANCE_BOOKING_DAYS + ' ngày');
                                            return false;
                                        }

                                        // Check if today (same day booking warning)
                                        if (checkInDate.toDateString() === today.toDateString()) {
                                            showDateWarning('Bạn đang đặt phòng cho ngày hôm nay, hãy chắc chắn rằng bạn có thể nhận phòng. Khuyến nghị đặt trước ít nhất 1 ngày.');
                                        } else {
                                            hideDateWarning();
                                        }

                                        setValidationState(checkInInput, true, 'Ngày nhận phòng hợp lệ');
                                        return true;
                                    }

                                    function validateCheckOutDate(checkInStr, checkOutStr) {
                                        if (!checkOutInput)
                                            return false;

                                        if (!checkOutStr) {
                                            setValidationState(checkOutInput, false, 'Vui lòng chọn ngày trả phòng');
                                            return false;
                                        }

                                        if (!checkInStr) {
                                            setValidationState(checkOutInput, false, 'Vui lòng chọn ngày nhận phòng trước');
                                            return false;
                                        }

                                        const checkInDate = new Date(checkInStr);
                                        const checkOutDate = new Date(checkOutStr);

                                        if (checkOutDate <= checkInDate) {
                                            setValidationState(checkOutInput, false, 'Ngày trả phòng phải sau ngày nhận phòng');
                                            return false;
                                        }

                                        // Calculate nights
                                        const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));

                                        if (nights > MAX_STAY_DURATION_DAYS) {
                                            setValidationState(checkOutInput, false, 'Chỉ có thể đặt tối đa ' + MAX_STAY_DURATION_DAYS + ' đêm');
                                            return false;
                                        }

                                        setValidationState(checkOutInput, true, nights + ' đêm - Hợp lệ');
                                        return true;
                                    }

                                    function setValidationState(input, isValid, message) {
                                        const errorElement = document.getElementById(input.id + 'Error');

                                        if (isValid) {
                                            input.classList.remove('is-invalid');
                                            input.classList.add('is-valid');
                                            if (errorElement)
                                                errorElement.textContent = '';
                                        } else {
                                            input.classList.remove('is-valid');
                                            input.classList.add('is-invalid');
                                            if (errorElement)
                                                errorElement.textContent = message;
                                        }

                                        updateBookingButtonState();
                                    }

                                    function updateBookingButtonState() {
                                        if (!bookingBtn || !checkInInput || !checkOutInput)
                                            return;

                                        const checkInValid = checkInInput.classList.contains('is-valid');
                                        const checkOutValid = checkOutInput.classList.contains('is-valid');
                                        const hasValues = checkInInput.value && checkOutInput.value;

                                        bookingBtn.disabled = !(checkInValid && checkOutValid && hasValues);
                                    }

                                    function calculateTotal() {
                                        if (!checkInInput || !checkOutInput || !bookingSummary)
                                            return;

                                        const checkIn = new Date(checkInInput.value);
                                        const checkOut = new Date(checkOutInput.value);

                                        if (checkIn && checkOut && checkOut > checkIn &&
                                                checkInInput.classList.contains('is-valid') &&
                                                checkOutInput.classList.contains('is-valid')) {

                                            const nightCount = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                                            const roomTotal = nightCount * pricePerNight;
                                            const serviceFee = Math.round(roomTotal * 0.05); // 5% service fee
                                            const totalAmount = roomTotal + serviceFee;

                                            const nightCountEl = document.getElementById('nightCount');
                                            const roomTotalEl = document.getElementById('roomTotal');
                                            const serviceFeeEl = document.getElementById('serviceFee');
                                            const totalAmountEl = document.getElementById('totalAmount');

                                            if (nightCountEl)
                                                nightCountEl.textContent = nightCount;
                                            if (roomTotalEl)
                                                roomTotalEl.textContent = formatCurrency(roomTotal);
                                            if (serviceFeeEl)
                                                serviceFeeEl.textContent = formatCurrency(serviceFee);
                                            if (totalAmountEl)
                                                totalAmountEl.textContent = formatCurrency(totalAmount);

                                            bookingSummary.style.display = 'block';

                                            // Show availability info
                                            showAvailabilityInfo(nightCount + ' đêm từ ' + formatDateVN(checkIn) + ' đến ' + formatDateVN(checkOut), 'success');
                                        } else {
                                            bookingSummary.style.display = 'none';
                                            hideAvailabilityInfo();
                                        }
                                    }

                                    function showAvailabilityInfo(message, type) {
                                        type = type || 'info';
                                        const availabilityText = document.getElementById('availabilityText');
                                        if (availabilityInfo && availabilityText) {
                                            availabilityText.textContent = message;

                                            const alertDiv = availabilityInfo.querySelector('.alert');
                                            if (alertDiv) {
                                                alertDiv.className = 'alert alert-' + type;
                                            }

                                            availabilityInfo.style.display = 'block';
                                        }
                                    }

                                    function hideAvailabilityInfo() {
                                        if (availabilityInfo) {
                                            availabilityInfo.style.display = 'none';
                                        }
                                    }

                                    function showDateWarning(message) {
                                        const warningText = document.getElementById('warningText');
                                        if (dateWarning && warningText) {
                                            warningText.textContent = message;
                                            dateWarning.style.display = 'block';
                                        }
                                    }

                                    function hideDateWarning() {
                                        if (dateWarning) {
                                            dateWarning.style.display = 'none';
                                        }
                                    }

                                    function formatDateVN(date) {
                                        return date.toLocaleDateString('vi-VN', {
                                            weekday: 'short',
                                            day: '2-digit',
                                            month: '2-digit'
                                        });
                                    }

                                    // Handle booking form submission
                                    const bookingForm = document.querySelector('.booking-form');
                                    if (bookingForm) {
                                        bookingForm.addEventListener('submit', function (e) {
                                            e.preventDefault();

                                            // Final validation
                                            const checkInValid = validateCheckInDate(checkInInput ? checkInInput.value : null);
                                            const checkOutValid = validateCheckOutDate(
                                                    checkInInput ? checkInInput.value : null,
                                                    checkOutInput ? checkOutInput.value : null
                                                    );

                                            if (!checkInValid || !checkOutValid) {
                                                showToast('Vui lòng kiểm tra lại ngày nhận phòng và trả phòng', 'error');
                                                return;
                                            }

                                            // Show loading state
                                            if (bookingBtn) {
                                                const btnText = bookingBtn.querySelector('.btn-text');
                                                const btnLoading = bookingBtn.querySelector('.btn-loading');

                                                if (btnText && btnLoading) {
                                                    btnText.style.display = 'none';
                                                    btnLoading.style.display = 'inline-flex';
                                                }

                                                bookingBtn.disabled = true;
                                            }

                                            // Submit form after short delay
                                            setTimeout(function () {
                                                bookingForm.submit();
                                            }, 500);
                                        });
                                    }

                                    // Focus on check-in date when page loads
                                    if (checkInInput) {
                                        checkInInput.focus();
                                    }

                                    // Initial animation check
                                    animateOnScroll();

                                    // Initialize tooltips if any
                                    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                        return new bootstrap.Tooltip(tooltipTriggerEl);
                                    });
                                });

// Share accommodation function
                                function shareAccommodation() {
                                    const url = window.location.href;
                                    const accommodationName = '${accommodation.name}';
                                    const shareText = 'Khám phá "' + accommodationName + '" tại VietCulture: ' + url;

                                    if (navigator.share) {
                                        navigator.share({
                                            title: accommodationName,
                                            text: 'Khám phá "' + accommodationName + '" tại VietCulture',
                                            url: url
                                        }).catch(function (err) {
                                            console.log('Error sharing:', err);
                                        });
                                    } else if (navigator.clipboard) {
                                        navigator.clipboard.writeText(shareText)
                                                .then(function () {
                                                    showToast('Đã sao chép link "' + accommodationName + '"', 'success');
                                                })
                                                .catch(function (err) {
                                                    showToast('Không thể sao chép: ' + err, 'error');
                                                });
                                    }
                                }

// Save accommodation function
                                function saveAccommodation() {
                                    // This would typically save to user's favorites
                                    // For now, just show a toast
                                    const heartIcon = event.target.closest('.action-btn').querySelector('i');

                                    if (heartIcon.classList.contains('ri-heart-line')) {
                                        heartIcon.classList.remove('ri-heart-line');
                                        heartIcon.classList.add('ri-heart-fill');
                                        heartIcon.style.color = 'var(--primary-color)';
                                        showToast('Đã lưu vào danh sách yêu thích', 'success');
                                    } else {
                                        heartIcon.classList.remove('ri-heart-fill');
                                        heartIcon.classList.add('ri-heart-line');
                                        heartIcon.style.color = '';
                                        showToast('Đã bỏ khỏi danh sách yêu thích', 'info');
                                    }
                                }

// Show toast notification
                                function showToast(message, type) {
                                    type = type || 'success';
                                    const toastContainer = document.querySelector('.toast-container');
                                    if (!toastContainer)
                                        return;

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

                                    setTimeout(function () {
                                        toast.classList.add('show');
                                    }, 10);

                                    setTimeout(function () {
                                        toast.classList.remove('show');
                                        setTimeout(function () {
                                            if (toastContainer.contains(toast)) {
                                                toastContainer.removeChild(toast);
                                            }
                                        }, 500);
                                    }, 3000);
                                }

// Smooth scroll for anchor links
                                document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
                                    anchor.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        const target = document.querySelector(this.getAttribute('href'));
                                        if (target) {
                                            target.scrollIntoView({
                                                behavior: 'smooth',
                                                block: 'start'
                                            });
                                        }
                                    });
                                });

// Image lazy loading
                                const images = document.querySelectorAll('img');
                                const imageObserver = new IntersectionObserver(function (entries, observer) {
                                    entries.forEach(function (entry) {
                                        if (entry.isIntersecting) {
                                            const img = entry.target;
                                            if (img.dataset.src) {
                                                img.src = img.dataset.src;
                                                img.removeAttribute('data-src');
                                            }
                                            observer.unobserve(img);
                                        }
                                    });
                                });

                                images.forEach(function (img) {
                                    imageObserver.observe(img);
                                });
        </script>
        <!-- Modal chứa form đánh giá đặt ngay sau action-buttons -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel">Đánh giá chỗ lưu trú</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <jsp:include page="/view/jsp/common/review.jsp" />
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Thay thế phần Google Maps bằng Leaflet OpenStreetMap -->
<!-- Đây là phiên bản miễn phí hoàn toàn, không cần API key -->

<!-- Thêm Leaflet CSS và JS -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" 
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>

<!-- Leaflet JavaScript -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" 
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

<!-- Leaflet Routing Machine for directions -->
<link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.css" />
<script src="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.js"></script>

<!-- Location Section with Leaflet Map -->
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
                <a href="javascript:void(0)" onclick="openInGoogleMaps()" class="text-decoration-none me-3">
                    <i class="ri-map-2-line me-1"></i>Google Maps
                </a>
                <a href="javascript:void(0)" onclick="copyLocation()" class="text-decoration-none">
                    <i class="ri-file-copy-line me-1"></i>Copy địa chỉ
                </a>
            </small>
        </div>
    </div>

    <!-- Map Container -->
    <div class="map-container mb-3">
        <div id="leafletMap" style="height: 400px; width: 100%; border-radius: 10px; border: 1px solid #ddd;"></div>
    </div>

    <!-- Directions Controls -->
    <div class="directions-controls mb-3">
        <div class="row">
            <div class="col-md-8">
                <div class="btn-group w-100" role="group">
                    <button type="button" class="btn btn-outline-primary" onclick="getDirectionsLeaflet()">
                        <i class="ri-direction-line me-2"></i>Chỉ đường từ vị trí hiện tại
                    </button>
                    <button type="button" class="btn btn-outline-secondary" onclick="openInGoogleMaps()">
                        <i class="ri-external-link-line me-2"></i>Mở Google Maps
                    </button>
                </div>
            </div>
            <div class="col-md-4">
                <select class="form-select" id="leafletTravelMode" onchange="updateDirectionsLeaflet()">
                    <option value="driving">Xe hơi</option>
                    <option value="walking">Đi bộ</option>
                    <option value="cycling">Xe đạp</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Map Info -->
    <div class="map-info">
        <div class="alert alert-info">
            <i class="ri-information-line me-2"></i>
            <strong>Bản đồ miễn phí:</strong> Sử dụng OpenStreetMap - không cần API key, hoàn toàn miễn phí!
        </div>
    </div>
</div>

<script>
// Leaflet Map Variables
let leafletMap;
let routingControl;
let experienceMarker;
let userMarker;

// Experience data
const experienceLocation = "${experience.location}${not empty experience.cityName ? ', ' : ''}${experience.cityName}, Việt Nam";
const experienceTitle = "${experience.title}";

// Default coordinates for Vietnam center
const defaultCenter = [16.047079, 108.206230];

// Initialize Leaflet Map
function initLeafletMap() {
    try {
        // Create map centered on Vietnam
        leafletMap = L.map('leafletMap').setView(defaultCenter, 6);

        // Add OpenStreetMap tiles
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
            maxZoom: 19
        }).addTo(leafletMap);

        // Geocode location and add marker
        geocodeLocationLeaflet();

        showToast('Bản đồ đã tải thành công!', 'success');
    } catch (error) {
        console.error('Error initializing Leaflet map:', error);
        showMapError('Không thể khởi tạo bản đồ: ' + error.message);
    }
}

// Geocode location using Nominatim (free OSM geocoding service)
async function geocodeLocationLeaflet() {
    try {
        const response = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(experienceLocation)}&limit=1`);
        const data = await response.json();

        if (data && data.length > 0) {
            const lat = parseFloat(data[0].lat);
            const lon = parseFloat(data[0].lon);

            // Center map on location
            leafletMap.setView([lat, lon], 15);

            // Create custom marker
            const customIcon = L.divIcon({
                className: 'custom-marker',
                html: `<div style="
                    background-color: #FF385C;
                    width: 30px;
                    height: 30px;
                    border-radius: 50% 50% 50% 0;
                    border: 3px solid white;
                    transform: rotate(-45deg);
                    box-shadow: 0 2px 10px rgba(0,0,0,0.3);
                "><div style="
                    width: 12px;
                    height: 12px;
                    background: white;
                    border-radius: 50%;
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                "></div></div>`,
                iconSize: [30, 30],
                iconAnchor: [15, 30]
            });

            // Add marker
            experienceMarker = L.marker([lat, lon], { icon: customIcon })
                .addTo(leafletMap)
                .bindPopup(`
                    <div style="text-align: center; padding: 10px;">
                        <h6 style="margin: 0 0 8px 0; color: #FF385C;">${experienceTitle}</h6>
                        <p style="margin: 0; font-size: 14px;">${experienceLocation}</p>
                    </div>
                `)
                .openPopup();

        } else {
            throw new Error('Không tìm thấy địa điểm');
        }
    } catch (error) {
        console.error('Geocoding failed:', error);
        showToast('Không thể tìm thấy địa điểm. Hiển thị vị trí mặc định.', 'warning');
        
        // Add default marker in center of Vietnam
        experienceMarker = L.marker(defaultCenter)
            .addTo(leafletMap)
            .bindPopup(`
                <div style="text-align: center; padding: 10px;">
                    <h6 style="margin: 0 0 8px 0; color: #FF385C;">${experienceTitle}</h6>
                    <p style="margin: 0; font-size: 14px;">${experienceLocation}</p>
                    <small style="color: #666;">Vị trí ước lượng</small>
                </div>
            `);
    }
}

// Get directions using user's location
function getDirectionsLeaflet() {
    if (!experienceMarker) {
        showToast('Vui lòng đợi bản đồ tải xong', 'warning');
        return;
    }

    if (navigator.geolocation) {
        showToast('Đang lấy vị trí của bạn...', 'info');
        
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const userLat = position.coords.latitude;
                const userLng = position.coords.longitude;
                const userLatLng = [userLat, userLng];
                const destinationLatLng = experienceMarker.getLatLng();

                // Remove existing user marker
                if (userMarker) {
                    leafletMap.removeLayer(userMarker);
                }

                // Add user location marker
                userMarker = L.marker(userLatLng, {
                    icon: L.divIcon({
                        className: 'user-marker',
                        html: `<div style="
                            background-color: #4285F4;
                            width: 20px;
                            height: 20px;
                            border-radius: 50%;
                            border: 3px solid white;
                            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
                        "></div>`,
                        iconSize: [20, 20],
                        iconAnchor: [10, 10]
                    })
                }).addTo(leafletMap).bindPopup('Vị trí của bạn');

                // Add routing
                addRoutingLeaflet(userLatLng, [destinationLatLng.lat, destinationLatLng.lng]);
                
                showToast('Đã tìm thấy đường đi!', 'success');
            },
            (error) => {
                handleGeolocationError(error);
            },
            {
                enableHighAccuracy: true,
                timeout: 10000,
                maximumAge: 300000
            }
        );
    } else {
        showToast('Trình duyệt không hỗ trợ lấy vị trí', 'error');
    }
}

// Add routing between two points
function addRoutingLeaflet(start, end) {
    // Remove existing routing
    if (routingControl) {
        leafletMap.removeControl(routingControl);
    }

    const profile = document.getElementById('leafletTravelMode').value;

    // Use OSRM routing service (free)
    routingControl = L.Routing.control({
        waypoints: [
            L.latLng(start[0], start[1]),
            L.latLng(end[0], end[1])
        ],
        routeWhileDragging: false,
        addWaypoints: false,
        router: L.Routing.osrmv1({
            serviceUrl: `https://router.project-osrm.org/route/v1/${profile}`,
            profile: profile
        }),
        createMarker: function() { return null; }, // Don't create default markers
        lineOptions: {
            styles: [{ color: '#FF385C', weight: 4, opacity: 0.8 }]
        },
        show: true,
        collapsible: true,
        language: 'vi'
    }).addTo(leafletMap);

    // Fit map to show both markers and route
    const group = new L.featureGroup([userMarker, experienceMarker]);
    leafletMap.fitBounds(group.getBounds().pad(0.1));
}

// Update directions when travel mode changes
function updateDirectionsLeaflet() {
    if (userMarker && experienceMarker) {
        const userLatLng = userMarker.getLatLng();
        const destLatLng = experienceMarker.getLatLng();
        addRoutingLeaflet([userLatLng.lat, userLatLng.lng], [destLatLng.lat, destLatLng.lng]);
    }
}

// Geolocation error handling
function handleGeolocationError(error) {
    let errorMessage = 'Không thể lấy vị trí của bạn. ';
    switch(error.code) {
        case error.PERMISSION_DENIED:
            errorMessage += 'Vui lòng cho phép truy cập vị trí.';
            break;
        case error.POSITION_UNAVAILABLE:
            errorMessage += 'Thông tin vị trí không khả dụng.';
            break;
        case error.TIMEOUT:
            errorMessage += 'Yêu cầu lấy vị trí bị hết thời gian.';
            break;
        default:
            errorMessage += 'Đã xảy ra lỗi không xác định.';
            break;
    }
    showToast(errorMessage, 'error');
}

// External map functions
function openInGoogleMaps() {
    const encodedLocation = encodeURIComponent(experienceLocation);
    const mapsUrl = `https://www.google.com/maps/search/${encodedLocation}`;
    window.open(mapsUrl, '_blank');
}

function openInZalo() {
    const encodedLocation = encodeURIComponent(experienceLocation);
    const zaloUrl = `https://zalo.me/maps/search/${encodedLocation}`;
    window.open(zaloUrl, '_blank');
}

function copyLocation() {
    const locationText = document.getElementById('locationText').textContent;
    
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(locationText).then(() => {
            showToast('Đã copy địa chỉ vào clipboard!', 'success');
        }).catch(() => {
            fallbackCopyTextToClipboard(locationText);
        });
    } else {
        fallbackCopyTextToClipboard(locationText);
    }
}

function fallbackCopyTextToClipboard(text) {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.position = "fixed";
    textArea.style.top = "0";
    textArea.style.left = "0";
    
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
        const successful = document.execCommand('copy');
        showToast(successful ? 'Đã copy địa chỉ!' : 'Không thể copy địa chỉ', successful ? 'success' : 'warning');
    } catch (err) {
        showToast('Không thể copy địa chỉ', 'error');
    }

    document.body.removeChild(textArea);
}

function showMapError(message) {
    document.getElementById('leafletMap').innerHTML = `
        <div class="d-flex align-items-center justify-content-center h-100 bg-light text-muted" style="min-height: 400px;">
            <div class="text-center">
                <i class="ri-map-pin-line" style="font-size: 3rem; margin-bottom: 15px; color: #FF385C;"></i>
                <h5>Lỗi tải bản đồ</h5>
                <p>${message}</p>
                <button class="btn btn-outline-primary btn-sm" onclick="initLeafletMap()">
                    <i class="ri-refresh-line me-1"></i>Thử lại
                </button>
            </div>
        </div>
    `;
}

// Initialize map when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('leafletMap')) {
        initLeafletMap();
    }
});
</script>

<style>
/* Leaflet custom styles */
.custom-marker {
    background: transparent;
    border: none;
}

.user-marker {
    background: transparent;
    border: none;
}

.leaflet-routing-container {
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.leaflet-routing-container h3 {
    font-size: 14px;
    color: var(--primary-color);
}

.leaflet-bar {
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.leaflet-popup-content-wrapper {
    border-radius: 10px;
}

.leaflet-popup-tip {
    background: white;
}
</style> 
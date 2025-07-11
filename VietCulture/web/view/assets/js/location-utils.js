// Location utilities for VietCulture
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
    if (status) {
        status.className = 'distance-status ' + type;
        status.innerHTML = '<i class="ri-information-line"></i> ' + message;
    }
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
    const userLat = document.getElementById('userLat');
    const userLng = document.getElementById('userLng');
    
    if (userLat && userLng && userLat.value && userLng.value) {
        userLocation.lat = parseFloat(userLat.value);
        userLocation.lng = parseFloat(userLng.value);
        userLocation.enabled = true;
        
        const btn = document.getElementById('locationBtn');
        const distanceSelect = document.getElementById('distanceSelect');
        
        if (btn) btn.classList.add('enabled');
        if (distanceSelect) distanceSelect.disabled = false;
        updateLocationStatus('enabled', 'Vị trí đã được lưu từ lần trước');
    }
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    initializeDistanceFilter();
}); 
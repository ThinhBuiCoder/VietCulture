package model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Accommodation {
    private int accommodationId;
    private int hostId;
    private String name;
    private String description;
    private int cityId;
    private String address;
    private String type; // Homestay, Hotel, Resort, Guesthouse
    private int numberOfRooms;
    private int maxGuests;
    private int bedrooms;
    private int bathrooms;
    private String amenities; // Comma-separated amenities
    private double pricePerNight;
    private String images; // Comma-separated image URLs
    private Date createdAt;
    private boolean isActive;
    private double averageRating;
    private int totalBookings;
    
    // Admin fields
    private String rejectionReason;
    private Date approvedAt;
    private Date rejectedAt;
    private Date revokedAt;
    private boolean allowResubmit;
    private boolean isDeleted;
    private String deleteReason;
    private Date deletedAt;
    private Date restoredAt;
    
    // Related objects
    private Host host;
    private City city;
    private String hostName;
    private String cityName;
    private List<Review> reviews;
    private List<Booking> bookings;
    
    // Constructors
    public Accommodation() {
        this.reviews = new ArrayList<>();
        this.bookings = new ArrayList<>();
        this.averageRating = 0.0;
        this.totalBookings = 0;
        this.isActive = false; // Default to inactive until approved
        this.isDeleted = false;
        this.allowResubmit = true;
    }
    
    public Accommodation(int hostId, String name, String description, int cityId, 
                        String address, String type, double pricePerNight) {
        this();
        this.hostId = hostId;
        this.name = name;
        this.description = description;
        this.cityId = cityId;
        this.address = address;
        this.type = type;
        this.pricePerNight = pricePerNight;
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public int getAccommodationId() {
        return accommodationId;
    }
    
    public void setAccommodationId(int accommodationId) {
        this.accommodationId = accommodationId;
    }
    
    public int getHostId() {
        return hostId;
    }
    
    public void setHostId(int hostId) {
        this.hostId = hostId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getCityId() {
        return cityId;
    }
    
    public void setCityId(int cityId) {
        this.cityId = cityId;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public int getNumberOfRooms() {
        return numberOfRooms;
    }
    
    public void setNumberOfRooms(int numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }
    
    public int getMaxGuests() {
        return maxGuests;
    }
    
    public void setMaxGuests(int maxGuests) {
        this.maxGuests = maxGuests;
    }
    
    public int getBedrooms() {
        return bedrooms;
    }
    
    public void setBedrooms(int bedrooms) {
        this.bedrooms = bedrooms;
    }
    
    public int getBathrooms() {
        return bathrooms;
    }
    
    public void setBathrooms(int bathrooms) {
        this.bathrooms = bathrooms;
    }
    
    public String getAmenities() {
        return amenities;
    }
    
    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }
    
    public double getPricePerNight() {
        return pricePerNight;
    }
    
    public void setPricePerNight(double pricePerNight) {
        this.pricePerNight = pricePerNight;
    }
    
    public String getImages() {
        return images;
    }
    
    public void setImages(String images) {
        this.images = images;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
    
    public int getTotalBookings() {
        return totalBookings;
    }
    
    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }
    
    // Admin fields getters/setters
    public String getRejectionReason() {
        return rejectionReason;
    }
    
    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
    
    public Date getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(Date approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public Date getRejectedAt() {
        return rejectedAt;
    }
    
    public void setRejectedAt(Date rejectedAt) {
        this.rejectedAt = rejectedAt;
    }
    
    public Date getRevokedAt() {
        return revokedAt;
    }
    
    public void setRevokedAt(Date revokedAt) {
        this.revokedAt = revokedAt;
    }
    
    public boolean isAllowResubmit() {
        return allowResubmit;
    }
    
    public void setAllowResubmit(boolean allowResubmit) {
        this.allowResubmit = allowResubmit;
    }
    
    public boolean isDeleted() {
        return isDeleted;
    }
    
    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
    
    public String getDeleteReason() {
        return deleteReason;
    }
    
    public void setDeleteReason(String deleteReason) {
        this.deleteReason = deleteReason;
    }
    
    public Date getDeletedAt() {
        return deletedAt;
    }
    
    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }
    
    public Date getRestoredAt() {
        return restoredAt;
    }
    
    public void setRestoredAt(Date restoredAt) {
        this.restoredAt = restoredAt;
    }
    
    public Host getHost() {
        return host;
    }
    
    public void setHost(Host host) {
        this.host = host;
        if (host != null) {
            this.hostId = host.getUserId();
        }
    }
    
    public City getCity() {
        return city;
    }
    
    public void setCity(City city) {
        this.city = city;
        if (city != null) {
            this.cityId = city.getCityId();
        }
    }
    
    public String getHostName() {
        return hostName;
    }
    
    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
    
    public String getCityName() {
        return cityName;
    }
    
    public void setCityName(String cityName) {
        this.cityName = cityName;
    }
    
    public List<Review> getReviews() {
        return reviews;
    }
    
    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }
    
    public List<Booking> getBookings() {
        return bookings;
    }
    
    public void setBookings(List<Booking> bookings) {
        this.bookings = bookings;
    }
    
    // Helper methods
    
    /**
     * Get accommodation type in Vietnamese
     */
    public String getTypeText() {
        switch (type) {
            case "Homestay":
                return "Homestay";
            case "Hotel":
                return "Khách sạn";
            case "Resort":
                return "Resort";
            case "Guesthouse":
                return "Nhà nghỉ";
            default:
                return type;
        }
    }
    
    /**
     * Get status text
     */
    public String getStatusText() {
        if (isDeleted) return "Đã xóa";
        if (isActive) return "Đã duyệt";
        if (rejectionReason != null) return "Bị từ chối";
        return "Chờ duyệt";
    }
    
    /**
     * Get status for admin
     */
    public int getIsActive() {
        if (isDeleted) return -2; // Deleted
        if (rejectionReason != null && !isActive) return -1; // Rejected
        if (isActive) return 1; // Approved
        return 0; // Pending
    }
    
    /**
     * Get amenities as array
     */
    public String[] getAmenitiesList() {
        if (amenities == null || amenities.trim().isEmpty()) {
            return new String[0];
        }
        return amenities.split(",");
    }
    
    /**
     * Get images as array
     */
    public String[] getImageList() {
        if (images == null || images.trim().isEmpty()) {
            return new String[0];
        }
        return images.split(",");
    }
    
    /**
     * Get first image for preview
     */
    public String getFirstImage() {
        String[] imageList = getImageList();
        return imageList.length > 0 ? imageList[0].trim() : null;
    }
    
    /**
     * Check if has specific amenity
     */
    public boolean hasAmenity(String amenity) {
        if (amenities == null || amenities.trim().isEmpty()) {
            return false;
        }
        return amenities.toLowerCase().contains(amenity.toLowerCase());
    }
    
    /**
     * Check if has images
     */
    public boolean hasImages() {
        return images != null && !images.trim().isEmpty();
    }
    
    /**
     * Get formatted price
     */
    public String getFormattedPrice() {
        if (pricePerNight >= 1_000_000) {
            return String.format("%.1f triệu VNĐ", pricePerNight / 1_000_000);
        } else if (pricePerNight >= 1_000) {
            return String.format("%.0f nghìn VNĐ", pricePerNight / 1_000);
        } else {
            return String.format("%.0f VNĐ", pricePerNight);
        }
    }
    
    /**
     * Get rating text
     */
    public String getRatingText() {
        if (averageRating == 0) {
            return "Chưa có đánh giá";
        }
        return String.format("%.1f/5", averageRating);
    }
    
    /**
     * Check if this is a new accommodation
     */
    public boolean isNew() {
        if (createdAt == null) return false;
        
        Date now = new Date();
        long diffInMillies = now.getTime() - createdAt.getTime();
        long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
        
        return diffInDays <= 30; // New if created within 30 days
    }
    
    /**
     * Check if this is a popular accommodation
     */
    public boolean isPopular() {
        return totalBookings >= 10 && averageRating >= 4.0;
    }
    
    /**
     * Add review to accommodation
     */
    public void addReview(Review review) {
        if (this.reviews == null) {
            this.reviews = new ArrayList<>();
        }
        this.reviews.add(review);
        
        // Recalculate average rating
        double sum = 0;
        for (Review r : this.reviews) {
            sum += r.getRating();
        }
        this.averageRating = sum / this.reviews.size();
    }
    
    /**
     * Add booking to accommodation
     */
    public void addBooking(Booking booking) {
        if (this.bookings == null) {
            this.bookings = new ArrayList<>();
        }
        this.bookings.add(booking);
        this.totalBookings = this.bookings.size();
    }
    
    @Override
    public String toString() {
        return "Accommodation{" +
                "accommodationId=" + accommodationId +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", address='" + address + '\'' +
                ", pricePerNight=" + pricePerNight +
                ", isActive=" + isActive +
                ", averageRating=" + averageRating +
                ", totalBookings=" + totalBookings +
                '}';
    }

    public void setHost(User host) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
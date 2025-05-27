package model;

import java.util.Date;

public class Accommodation {
    private int accommodationId;
    private int hostId;
    private String name;
    private String description;
    private int cityId;
    private String address;
    private String type; // Homestay, Hotel, Resort, Guesthouse
    private int numberOfRooms;
    private String amenities; // Comma-separated amenities
    private double pricePerNight;
    private String images; // Comma-separated image URLs
    private Date createdAt;
    private boolean isActive;
    private double averageRating;
    private int totalBookings;
    
    // Related objects
    private City city;
    private User host;
    
    // Constructors
    public Accommodation() {}
    
    public Accommodation(String name, String description, int cityId, String address, 
                        String type, int numberOfRooms, double pricePerNight) {
        this.name = name;
        this.description = description;
        this.cityId = cityId;
        this.address = address;
        this.type = type;
        this.numberOfRooms = numberOfRooms;
        this.pricePerNight = pricePerNight;
        this.isActive = false; // Needs admin approval
        this.createdAt = new Date();
        this.averageRating = 0.0;
        this.totalBookings = 0;
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
    
    public City getCity() {
        return city;
    }
    
    public void setCity(City city) {
        this.city = city;
        if (city != null) {
            this.cityId = city.getCityId();
        }
    }
    
    public User getHost() {
        return host;
    }
    
    public void setHost(User host) {
        this.host = host;
        if (host != null) {
            this.hostId = host.getUserId();
        }
    }
    
    @Override
    public String toString() {
        return "Accommodation{" +
                "accommodationId=" + accommodationId +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", pricePerNight=" + pricePerNight +
                ", isActive=" + isActive +
                '}';
    }
}
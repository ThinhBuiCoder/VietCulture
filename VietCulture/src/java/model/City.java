package model;

public class City {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private int cityId;
    private String name;
    private String vietnameseName;
    private int regionId;
    private String description;
    private String imageUrl;
    private String attractions;
<<<<<<< HEAD

    // Related objects
    private Region region;

    // Constructors
    public City() {
    }

=======
    
    // Related objects
    private Region region;
    
    // Constructors
    public City() {}
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    public City(String name, String vietnameseName, int regionId) {
        this.name = name;
        this.vietnameseName = vietnameseName;
        this.regionId = regionId;
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Getters and Setters
    public int getCityId() {
        return cityId;
    }
<<<<<<< HEAD

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVietnameseName() {
        return vietnameseName;
    }

    public void setVietnameseName(String vietnameseName) {
        this.vietnameseName = vietnameseName;
    }

    public int getRegionId() {
        return regionId;
    }

    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getAttractions() {
        return attractions;
    }

    public void setAttractions(String attractions) {
        this.attractions = attractions;
    }

    public Region getRegion() {
        return region;
    }

=======
    
    public void setCityId(int cityId) {
        this.cityId = cityId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getVietnameseName() {
        return vietnameseName;
    }
    
    public void setVietnameseName(String vietnameseName) {
        this.vietnameseName = vietnameseName;
    }
    
    public int getRegionId() {
        return regionId;
    }
    
    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getAttractions() {
        return attractions;
    }
    
    public void setAttractions(String attractions) {
        this.attractions = attractions;
    }
    
    public Region getRegion() {
        return region;
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    public void setRegion(Region region) {
        this.region = region;
        if (region != null) {
            this.regionId = region.getRegionId();
        }
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Helper methods
    public String getDisplayName() {
        return vietnameseName != null ? vietnameseName : name;
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    public String[] getAttractionsList() {
        if (attractions == null || attractions.trim().isEmpty()) {
            return new String[0];
        }
        return attractions.split(",");
    }
<<<<<<< HEAD

    public boolean hasAttractions() {
        return attractions != null && !attractions.trim().isEmpty();
    }

    @Override
    public String toString() {
        return "City{"
                + "cityId=" + cityId
                + ", name='" + name + '\''
                + ", vietnameseName='" + vietnameseName + '\''
                + ", regionId=" + regionId
                + '}';
    }
}
=======
    
    public boolean hasAttractions() {
        return attractions != null && !attractions.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "City{" +
               "cityId=" + cityId +
               ", name='" + name + '\'' +
               ", vietnameseName='" + vietnameseName + '\'' +
               ", regionId=" + regionId +
               '}';
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b

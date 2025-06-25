package model;

public class City {

    private int cityId;
    private String name;
    private String vietnameseName;
    private int regionId;
    private String description;
    private String imageUrl;
    private String attractions;

    // Related objects
    private Region region;

    // Constructors
    public City() {
    }

    public City(String name, String vietnameseName, int regionId) {
        this.name = name;
        this.vietnameseName = vietnameseName;
        this.regionId = regionId;
    }

    // Getters and Setters
    public int getCityId() {
        return cityId;
    }

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

    public void setRegion(Region region) {
        this.region = region;
        if (region != null) {
            this.regionId = region.getRegionId();
        }
    }

    // Helper methods
    public String getDisplayName() {
        return vietnameseName != null ? vietnameseName : name;
    }

    public String[] getAttractionsList() {
        if (attractions == null || attractions.trim().isEmpty()) {
            return new String[0];
        }
        return attractions.split(",");
    }

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

package model;

public class Category {

    private int categoryId;
    private String name;
    private String description;
    private String iconUrl;

    // Constructors
    public Category() {
    }

    public Category(String name, String description, String iconUrl) {
        this.name = name;
        this.description = description;
        this.iconUrl = iconUrl;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
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

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    @Override
    public String toString() {
        return "Category{"
                + "categoryId=" + categoryId
                + ", name='" + name + '\''
                + ", description='" + description + '\''
                + ", iconUrl='" + iconUrl + '\''
                + '}';
    }
}

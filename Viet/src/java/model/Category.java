package model;

public class Category {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private int categoryId;
    private String name;
    private String description;
    private String iconUrl;
<<<<<<< HEAD

    // Constructors
    public Category() {
    }

=======
    
    // Constructors
    public Category() {}
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    public Category(String name, String description, String iconUrl) {
        this.name = name;
        this.description = description;
        this.iconUrl = iconUrl;
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }
<<<<<<< HEAD

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
=======
    
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
        return "Category{" +
                "categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", iconUrl='" + iconUrl + '\'' +
                '}';
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b

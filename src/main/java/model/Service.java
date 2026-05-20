package model;

/**
 * Represents a service offered by a business.
 * Maps to the 'services' table.
 */
public class Service {
    private int serviceId;
    private int businessId;
    private String serviceName;
    private int categoryId;
    private int durationMin;
    private double price;
    private String description;
    private boolean isActive;

    // Display-only fields (populated via JOIN)
    private String businessName;
    private String categoryName;

    public Service() {}

    // Constructor matching schema columns
    public Service(int serviceId, int businessId, String serviceName,
                   int categoryId, int durationMin, double price,
                   String description, boolean isActive) {
        this.serviceId   = serviceId;
        this.businessId  = businessId;
        this.serviceName = serviceName;
        this.categoryId  = categoryId;
        this.durationMin = durationMin;
        this.price       = price;
        this.description = description;
        this.isActive    = isActive;
    }

    // Getters
    public int getServiceId()        { return serviceId; }
    public int getBusinessId()       { return businessId; }
    public String getServiceName()   { return serviceName; }
    public int getCategoryId()       { return categoryId; }
    public int getDurationMin()      { return durationMin; }
    public double getPrice()         { return price; }
    public String getDescription()   { return description; }
    public boolean isActive()        { return isActive; }
    public String getBusinessName()  { return businessName; }
    public String getCategoryName()  { return categoryName; }

    // Backward-compatible getter
    public int getDurationMinutes()  { return durationMin; }

    // Setters
    public void setServiceId(int serviceId)            { this.serviceId = serviceId; }
    public void setBusinessId(int businessId)          { this.businessId = businessId; }
    public void setServiceName(String serviceName)     { this.serviceName = serviceName; }
    public void setCategoryId(int categoryId)          { this.categoryId = categoryId; }
    public void setDurationMin(int durationMin)        { this.durationMin = durationMin; }
    public void setPrice(double price)                 { this.price = price; }
    public void setDescription(String description)     { this.description = description; }
    public void setActive(boolean isActive)            { this.isActive = isActive; }
    public void setBusinessName(String businessName)   { this.businessName = businessName; }
    public void setCategoryName(String categoryName)   { this.categoryName = categoryName; }

    // Backward-compatible setter
    public void setDurationMinutes(int d)              { this.durationMin = d; }
    // Alias used by booking.jsp
    public int getDuration()                           { return durationMin; }
}
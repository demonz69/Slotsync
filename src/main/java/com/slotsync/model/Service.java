package com.slotsync.model;

public class Service {

    private int     serviceId;
    private int     businessId;
    private String  serviceName;
    private int     categoryId;
    private int     durationMin;
    private double  price;
    private String  description;
    private boolean isActive;

    // Empty constructor
    public Service() {}

    // Full constructor
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
    public int     getServiceId()   { return serviceId; }
    public int     getBusinessId()  { return businessId; }
    public String  getServiceName() { return serviceName; }
    public int     getCategoryId()  { return categoryId; }
    public int     getDurationMin() { return durationMin; }
    public double  getPrice()       { return price; }
    public String  getDescription() { return description; }
    public boolean isActive()       { return isActive; }

    // Setters
    public void setServiceId(int serviceId)     { this.serviceId   = serviceId; }
    public void setBusinessId(int businessId)   { this.businessId  = businessId; }
    public void setServiceName(String name)     { this.serviceName = name; }
    public void setCategoryId(int categoryId)   { this.categoryId  = categoryId; }
    public void setDurationMin(int durationMin) { this.durationMin = durationMin; }
    public void setPrice(double price)          { this.price       = price; }
    public void setDescription(String desc)     { this.description = desc; }
    public void setActive(boolean active)       { this.isActive    = active; }
}

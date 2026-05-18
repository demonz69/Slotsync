package model;

/**
 * Represents a wishlist entry for a client.
 * Maps to the 'wishlist' table (composite PK: client_id + service_id).
 */
public class Wishlist {

    private int clientId;
    private int serviceId;
    private String addedAt;

    // Display-only fields (populated via JOIN)
    private String serviceName;
    private double servicePrice;
    private String businessName;

    public Wishlist() {}

    public Wishlist(int clientId, int serviceId) {
        this.clientId  = clientId;
        this.serviceId = serviceId;
    }

    // Getters
    public int getClientId()          { return clientId; }
    public int getServiceId()         { return serviceId; }
    public String getAddedAt()        { return addedAt; }
    public String getServiceName()    { return serviceName; }
    public double getServicePrice()   { return servicePrice; }
    public String getBusinessName()   { return businessName; }

    // Setters
    public void setClientId(int clientId)              { this.clientId = clientId; }
    public void setServiceId(int serviceId)            { this.serviceId = serviceId; }
    public void setAddedAt(String addedAt)             { this.addedAt = addedAt; }
    public void setServiceName(String serviceName)     { this.serviceName = serviceName; }
    public void setServicePrice(double servicePrice)   { this.servicePrice = servicePrice; }
    public void setBusinessName(String businessName)   { this.businessName = businessName; }
}


package model;

public class Wishlist {

    private int wishlistId;
    private int clientId;
    private int serviceId;
    private String serviceName;
    private double servicePrice;
    private String addedDate;

    public Wishlist() {}

    public Wishlist(int clientId, int serviceId) {
        this.clientId  = clientId;
        this.serviceId = serviceId;
    }

    public int getWishlistId()                       { return wishlistId; }
    public void setWishlistId(int wishlistId)        { this.wishlistId = wishlistId; }
    public int getClientId()                         { return clientId; }
    public void setClientId(int clientId)            { this.clientId = clientId; }
    public int getServiceId()                        { return serviceId; }
    public void setServiceId(int serviceId)          { this.serviceId = serviceId; }
    public String getServiceName()                   { return serviceName; }
    public void setServiceName(String serviceName)   { this.serviceName = serviceName; }
    public double getServicePrice()                  { return servicePrice; }
    public void setServicePrice(double servicePrice) { this.servicePrice = servicePrice; }
    public String getAddedDate()                     { return addedDate; }
    public void setAddedDate(String addedDate)       { this.addedDate = addedDate; }
}
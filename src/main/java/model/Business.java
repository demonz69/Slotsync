package model;

public class Business {
    private int    businessId;
    private String name;        // business_name column
    private String ownerName;   // joined from users
    private String email;
    private String phone;
    private String address;
    private String description; // also used as category
    private String status;

    // ── Getters ────────────────────────────────────────────────────────────────

    public int    getBusinessId()   { return businessId; }
    public String getName()         { return name; }
    public String getOwnerName()    { return ownerName; }
    public String getEmail()        { return email; }
    public String getPhone()        { return phone; }
    public String getAddress()      { return address; }
    public String getDescription()  { return description; }
    public String getStatus()       { return status; }

    // Aliases expected by settings.jsp and admin JSPs
    public String getBusinessName() { return name; }
    public String getCategory()     { return description; }

    // ── Setters ────────────────────────────────────────────────────────────────

    public void setBusinessId(int businessId)     { this.businessId = businessId; }
    public void setName(String name)              { this.name = name; }
    public void setOwnerName(String ownerName)    { this.ownerName = ownerName; }
    public void setEmail(String email)            { this.email = email; }
    public void setPhone(String phone)            { this.phone = phone; }
    public void setAddress(String address)        { this.address = address; }
    public void setDescription(String description){ this.description = description; }
    public void setStatus(String status)          { this.status = status; }

    // Aliases expected by settings.jsp
    public void setBusinessName(String name)      { this.name = name; }
    public void setCategory(String category)      { this.description = category; }
}

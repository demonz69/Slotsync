package model;

public class Employee {

    private int employeeId;
    private int userId;
    private int businessId;
    private String designation;
    private String phone;
    private String status;
    private String createdAt;

    public Employee() {}

    public Employee(int employeeId, int userId, int businessId,
                    String designation, String phone,
                    String status, String createdAt) {
        this.employeeId  = employeeId;
        this.userId      = userId;
        this.businessId  = businessId;
        this.designation = designation;
        this.phone       = phone;
        this.status      = status;
        this.createdAt   = createdAt;
    }

    public int    getEmployeeId()  { return employeeId; }
    public int    getUserId()      { return userId; }
    public int    getBusinessId()  { return businessId; }
    public String getDesignation() { return designation; }
    public String getPhone()       { return phone; }
    public String getStatus()      { return status; }
    public String getCreatedAt()   { return createdAt; }

    public void setEmployeeId(int employeeId)      { this.employeeId  = employeeId; }
    public void setUserId(int userId)              { this.userId      = userId; }
    public void setBusinessId(int businessId)      { this.businessId  = businessId; }
    public void setDesignation(String designation) { this.designation = designation; }
    public void setPhone(String phone)             { this.phone       = phone; }
    public void setStatus(String status)           { this.status      = status; }
    public void setCreatedAt(String createdAt)     { this.createdAt   = createdAt; }

    @Override
    public String toString() {
        return "Employee{id=" + employeeId +
               ", userId=" + userId +
               ", businessId=" + businessId +
               ", designation='" + designation + "'" +
               ", status='" + status + "'}";
    }
}
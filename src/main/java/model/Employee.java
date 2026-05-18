package model;

public class Employee {
    private int employeeId;
    private int userId;
    private int businessId;
    private String designation;
    private String phone;
    private String status;       // "active" | "inactive"
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

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBusinessId() { return businessId; }
    public void setBusinessId(int businessId) { this.businessId = businessId; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // Display field
    private String fullName;
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    @Override
    public String toString() {
        return "Employee{id=" + employeeId +
               ", userId=" + userId +
               ", businessId=" + businessId +
               ", designation='" + designation + "'" +
               ", phone='" + phone + "'" +
               ", status='" + status + "'}";
    }
}

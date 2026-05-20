package model;

public class Appointment {
    private int appointmentId;
    private int userId;
    private int employeeId;
    private int serviceId;
    private int businessId;          // NAYA THAPEKO
    private String appointmentDate;
    private String slotTime;
    private String status;           // "pending" | "confirmed" | "cancelled" | "completed"
    private String notes;            // NAYA THAPEKO
    private String createdAt;

    public Appointment() {}

    public Appointment(int appointmentId, int userId, int employeeId, int serviceId,
                       int businessId, String appointmentDate, String slotTime,
                       String status, String notes, String createdAt) {
        this.appointmentId   = appointmentId;
        this.userId          = userId;
        this.employeeId      = employeeId;
        this.serviceId       = serviceId;
        this.businessId      = businessId;
        this.appointmentDate = appointmentDate;
        this.slotTime        = slotTime;
        this.status          = status;
        this.notes           = notes;
        this.createdAt       = createdAt;
    }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // Alias — DB column is "client_id", DAO/Servlet use this name
    public int getClientId() { return userId; }
    public void setClientId(int clientId) { this.userId = clientId; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getBusinessId() { return businessId; }
    public void setBusinessId(int businessId) { this.businessId = businessId; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getSlotTime() { return slotTime; }
    public void setSlotTime(String slotTime) { this.slotTime = slotTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // Display fields (populated via JOIN in DAO)
    private String serviceName;
    private String employeeName;
    private String businessName;
    private String clientName;
    private double price;

    public String getServiceName()  { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getClientName()   { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    // Alias — slotTime is the start time of the appointment
    public String getStartTime()    { return slotTime; }

    @Override
    public String toString() {
        return "Appointment{id=" + appointmentId +
               ", userId=" + userId +
               ", employeeId=" + employeeId +
               ", serviceId=" + serviceId +
               ", businessId=" + businessId +
               ", date='" + appointmentDate + "'" +
               ", slot='" + slotTime + "'" +
               ", status='" + status + "'}";
    }
}
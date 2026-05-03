package model;

public class Availability {
    private int availabilityId;
    private int employeeId;
    private String dayOfWeek;   
    private String startTime;   
    private String endTime;     
    private int slotDuration;   

    public Availability() {}

    public Availability(int availabilityId, int employeeId, String dayOfWeek,
                        String startTime, String endTime, int slotDuration) {
        this.availabilityId = availabilityId;
        this.employeeId = employeeId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.slotDuration = slotDuration;
    }

    public int getAvailabilityId() { return availabilityId; }
    public void setAvailabilityId(int availabilityId) { this.availabilityId = availabilityId; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public int getSlotDuration() { return slotDuration; }
    public void setSlotDuration(int slotDuration) { this.slotDuration = slotDuration; }
}
package model;

public class Feedback {
    private int feedbackId;
    private int appointmentId;
    private int clientId;
    private int businessId;
    private int rating;
    private String comment;
    private String createdAt;

    public Feedback() {}

    public Feedback(int feedbackId, int appointmentId, int clientId,
                    int businessId, int rating, String comment, String createdAt) {
        this.feedbackId    = feedbackId;
        this.appointmentId = appointmentId;
        this.clientId      = clientId;
        this.businessId    = businessId;
        this.rating        = rating;
        this.comment       = comment;
        this.createdAt     = createdAt;
    }

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public int getBusinessId() { return businessId; }
    public void setBusinessId(int businessId) { this.businessId = businessId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
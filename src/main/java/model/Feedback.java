package com.slotsync.model;

import java.sql.Timestamp;

public class Feedback {

    private int feedbackId;
    private int appointmentId;
    private int clientId;
    private int businessId;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String businessName;
    private String clientName;

    public Feedback() {}

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

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
}
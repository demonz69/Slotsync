package model;

/**
 * Represents a contact inquiry submitted via the contact page.
 * Maps to the 'contact_inquiries' table.
 */
public class ContactInquiry {

    private int inquiryId;
    private String fullName;
    private String email;
    private String subject;
    private String message;
    private boolean isRead;
    private String submittedAt;

    public ContactInquiry() {}

    public ContactInquiry(String fullName, String email,
                          String subject, String message) {
        this.fullName = fullName;
        this.email    = email;
        this.subject  = subject;
        this.message  = message;
        this.isRead   = false;
    }

    // Getters
    public int getInquiryId()       { return inquiryId; }
    public String getFullName()     { return fullName; }
    public String getEmail()        { return email; }
    public String getSubject()      { return subject; }
    public String getMessage()      { return message; }
    public boolean getIsRead()      { return isRead; }
    public String getSubmittedAt()  { return submittedAt; }

    // Setters
    public void setInquiryId(int inquiryId)         { this.inquiryId = inquiryId; }
    public void setFullName(String fullName)         { this.fullName = fullName; }
    public void setEmail(String email)               { this.email = email; }
    public void setSubject(String subject)           { this.subject = subject; }
    public void setMessage(String message)           { this.message = message; }
    public void setIsRead(boolean isRead)            { this.isRead = isRead; }
    public void setSubmittedAt(String submittedAt)   { this.submittedAt = submittedAt; }
}

package model;



public class ContactInquiry {

    private int inquiryId;
    private String fullName;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private String status;
    private String submittedAt;

    public ContactInquiry() {}

    public ContactInquiry(String fullName, String email, String phone,
                          String subject, String message) {
        this.fullName = fullName;
        this.email    = email;
        this.phone    = phone;
        this.subject  = subject;
        this.message  = message;
        this.status   = "unread";
    }

    public int getInquiryId()                        { return inquiryId; }
    public void setInquiryId(int inquiryId)          { this.inquiryId = inquiryId; }
    public String getFullName()                      { return fullName; }
    public void setFullName(String fullName)         { this.fullName = fullName; }
    public String getEmail()                         { return email; }
    public void setEmail(String email)               { this.email = email; }
    public String getPhone()                         { return phone; }
    public void setPhone(String phone)               { this.phone = phone; }
    public String getSubject()                       { return subject; }
    public void setSubject(String subject)           { this.subject = subject; }
    public String getMessage()                       { return message; }
    public void setMessage(String message)           { this.message = message; }
    public String getStatus()                        { return status; }
    public void setStatus(String status)             { this.status = status; }
    public String getSubmittedAt()                   { return submittedAt; }
    public void setSubmittedAt(String submittedAt)   { this.submittedAt = submittedAt; }
}
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ContactInquiry;

public class ContactDAO {

    private Connection con;

    public ContactDAO() {
        con = DBConnection.getConnection();
    }

    // Save a new contact inquiry submitted from the contact form
    public boolean saveInquiry(ContactInquiry inquiry) {
        try {
            String query = "INSERT INTO contact_inquiries (name, email, subject, message, status) VALUES (?, ?, ?, ?, 'pending')";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, inquiry.getName());
            ps.setString(2, inquiry.getEmail());
            ps.setString(3, inquiry.getSubject());
            ps.setString(4, inquiry.getMessage());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all contact inquiries (for admin view)
    public List<ContactInquiry> getAllInquiries() {
        List<ContactInquiry> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM contact_inquiries ORDER BY submitted_at DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ContactInquiry inquiry = new ContactInquiry();
                inquiry.setInquiryId(rs.getInt("inquiry_id"));
                inquiry.setName(rs.getString("name"));
                inquiry.setEmail(rs.getString("email"));
                inquiry.setSubject(rs.getString("subject"));
                inquiry.setMessage(rs.getString("message"));
                inquiry.setStatus(rs.getString("status"));
                inquiry.setSubmittedAt(rs.getTimestamp("submitted_at"));
                list.add(inquiry);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get a single inquiry by ID
    public ContactInquiry getInquiryById(int inquiryId) {
        ContactInquiry inquiry = null;
        try {
            String query = "SELECT * FROM contact_inquiries WHERE inquiry_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, inquiryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                inquiry = new ContactInquiry();
                inquiry.setInquiryId(rs.getInt("inquiry_id"));
                inquiry.setName(rs.getString("name"));
                inquiry.setEmail(rs.getString("email"));
                inquiry.setSubject(rs.getString("subject"));
                inquiry.setMessage(rs.getString("message"));
                inquiry.setStatus(rs.getString("status"));
                inquiry.setSubmittedAt(rs.getTimestamp("submitted_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return inquiry;
    }

    // Update inquiry status (e.g., mark as "read" or "replied")
    public boolean updateStatus(int inquiryId, String status) {
        try {
            String query = "UPDATE contact_inquiries SET status = ? WHERE inquiry_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, inquiryId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an inquiry by ID
    public boolean deleteInquiry(int inquiryId) {
        try {
            String query = "DELETE FROM contact_inquiries WHERE inquiry_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, inquiryId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

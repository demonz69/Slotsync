package dao;

import model.ContactInquiry;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for contact inquiries.
 * Adapted from Usha's branch — fixed table name and column alignment with schema.
 */
public class ContactDAO {

    /**
     * Submit a new contact inquiry.
     */
    public boolean submitInquiry(ContactInquiry inquiry) {
        String sql = "INSERT INTO contact_inquiries (full_name, email, subject, message) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inquiry.getFullName());
            ps.setString(2, inquiry.getEmail());
            ps.setString(3, inquiry.getSubject());
            ps.setString(4, inquiry.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactDAO] submitInquiry: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all contact inquiries, newest first.
     */
    public List<ContactInquiry> getAllInquiries() {
        List<ContactInquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_inquiries ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ContactDAO] getAllInquiries: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get unread inquiries only.
     */
    public List<ContactInquiry> getUnreadInquiries() {
        List<ContactInquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_inquiries WHERE is_read = FALSE ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ContactDAO] getUnreadInquiries: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get a single inquiry by ID.
     */
    public ContactInquiry getById(int inquiryId) {
        String sql = "SELECT * FROM contact_inquiries WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[ContactDAO] getById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Mark an inquiry as read.
     */
    public boolean markAsRead(int inquiryId) {
        String sql = "UPDATE contact_inquiries SET is_read = TRUE WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactDAO] markAsRead: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete an inquiry.
     */
    public boolean deleteInquiry(int inquiryId) {
        String sql = "DELETE FROM contact_inquiries WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactDAO] deleteInquiry: " + e.getMessage());
            return false;
        }
    }

    /**
     * Count unread inquiries (for admin badge).
     */
    public int countUnread() {
        String sql = "SELECT COUNT(*) FROM contact_inquiries WHERE is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ContactDAO] countUnread: " + e.getMessage());
        }
        return 0;
    }

    // Map a result row to ContactInquiry object
    private ContactInquiry mapRow(ResultSet rs) throws SQLException {
        ContactInquiry i = new ContactInquiry();
        i.setInquiryId(rs.getInt("inquiry_id"));
        i.setFullName(rs.getString("full_name"));
        i.setEmail(rs.getString("email"));
        i.setSubject(rs.getString("subject"));
        i.setMessage(rs.getString("message"));
        i.setIsRead(rs.getBoolean("is_read"));
        i.setSubmittedAt(rs.getString("submitted_at"));
        return i;
    }
}

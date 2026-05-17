
package dao;

import model.ContactInquiry;
import java.sql.*;
        import java.util.ArrayList;
import java.util.List;

public class ContactInquiryDAO {

    public boolean submitInquiry(ContactInquiry inquiry) {
        String sql = "INSERT INTO contact_inquiry (full_name, email, phone, subject, message, status, submitted_at) " +
                "VALUES (?, ?, ?, ?, ?, 'unread', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inquiry.getFullName());
            ps.setString(2, inquiry.getEmail());
            ps.setString(3, inquiry.getPhone());
            ps.setString(4, inquiry.getSubject());
            ps.setString(5, inquiry.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] submitInquiry: " + e.getMessage());
            return false;
        }
    }

    public List<ContactInquiry> getAllInquiries() {
        List<ContactInquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_inquiry ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] getAllInquiries: " + e.getMessage());
        }
        return list;
    }

    public List<ContactInquiry> getByStatus(String status) {
        List<ContactInquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_inquiry WHERE status = ? ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] getByStatus: " + e.getMessage());
        }
        return list;
    }

    public ContactInquiry getById(int inquiryId) {
        String sql = "SELECT * FROM contact_inquiry WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] getById: " + e.getMessage());
        }
        return null;
    }

    public boolean updateStatus(int inquiryId, String status) {
        String sql = "UPDATE contact_inquiry SET status = ? WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] updateStatus: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteInquiry(int inquiryId) {
        String sql = "DELETE FROM contact_inquiry WHERE inquiry_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactInquiryDAO] deleteInquiry: " + e.getMessage());
            return false;
        }
    }

    private ContactInquiry mapRow(ResultSet rs) throws SQLException {
        ContactInquiry i = new ContactInquiry();
        i.setInquiryId(rs.getInt("inquiry_id"));
        i.setFullName(rs.getString("full_name"));
        i.setEmail(rs.getString("email"));
        i.setPhone(rs.getString("phone"));
        i.setSubject(rs.getString("subject"));
        i.setMessage(rs.getString("message"));
        i.setStatus(rs.getString("status"));
        i.setSubmittedAt(rs.getString("submitted_at"));
        return i;
    }
}
package dao;

import model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the feedback/rating system.
 * Schema: feedback(feedback_id, appointment_id UNIQUE, client_id, rating 1-5, comment, created_at)
 */
public class FeedbackDAO {

    /**
     * Submit feedback for a completed appointment.
     */
    public boolean submitFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (appointment_id, client_id, rating, comment) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getAppointmentId());
            ps.setInt(2, feedback.getClientId());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] submitFeedback: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all feedback for a specific business.
     */
    public List<Feedback> getFeedbackByBusiness(int businessId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name AS client_name FROM feedback f " +
                     "JOIN appointments a ON f.appointment_id = a.appointment_id " +
                     "JOIN users u ON f.client_id = u.user_id " +
                     "WHERE a.business_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = mapRow(rs, businessId);
                    fb.setClientName(rs.getString("client_name"));
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] getFeedbackByBusiness: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get all feedback submitted by a client.
     */
    public List<Feedback> getFeedbackByClient(int clientId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, a.business_id, b.business_name FROM feedback f " +
                     "JOIN appointments a ON f.appointment_id = a.appointment_id " +
                     "JOIN businesses b ON a.business_id = b.business_id " +
                     "WHERE f.client_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = mapRow(rs, rs.getInt("business_id"));
                    fb.setBusinessName(rs.getString("business_name"));
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] getFeedbackByClient: " + e.getMessage());
        }
        return list;
    }

    /**
     * Check if a client already submitted feedback for a specific appointment.
     */
    public boolean hasFeedback(int appointmentId) {
        String sql = "SELECT 1 FROM feedback WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] hasFeedback: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get average rating for a business.
     */
    public double getAverageRating(int businessId) {
        String sql = "SELECT AVG(f.rating) FROM feedback f " +
                     "JOIN appointments a ON f.appointment_id = a.appointment_id " +
                     "WHERE a.business_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] getAverageRating: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Get total feedback count for a business.
     */
    public int countByBusiness(int businessId) {
        String sql = "SELECT COUNT(*) FROM feedback f " +
                     "JOIN appointments a ON f.appointment_id = a.appointment_id " +
                     "WHERE a.business_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] countByBusiness: " + e.getMessage());
        }
        return 0;
    }

    // Map ResultSet row to Feedback object
    private Feedback mapRow(ResultSet rs, int businessId) throws SQLException {
        return new Feedback(
            rs.getInt("feedback_id"),
            rs.getInt("appointment_id"),
            rs.getInt("client_id"),
            businessId,
            rs.getInt("rating"),
            rs.getString("comment"),
            rs.getString("created_at")
        );
    }
}

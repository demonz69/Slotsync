package com.slotsync.dao;

import com.slotsync.model.Feedback;
import com.slotsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (appointment_id, client_id, business_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getAppointmentId());
            ps.setInt(2, feedback.getClientId());
            ps.setInt(3, feedback.getBusinessId());
            ps.setInt(4, feedback.getRating());
            ps.setString(5, feedback.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getByClientId(int clientId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, b.business_name FROM feedback f JOIN business b ON f.business_id = b.business_id WHERE f.client_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Feedback getByAppointmentId(int appointmentId) {
        String sql = "SELECT f.*, b.business_name FROM feedback f JOIN business b ON f.business_id = b.business_id WHERE f.appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Feedback> getByBusinessId(int businessId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.name AS client_name FROM feedback f JOIN user u ON f.client_id = u.user_id WHERE f.business_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = mapRow(rs);
                fb.setClientName(rs.getString("client_name"));
                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasFeedback(int appointmentId, int clientId) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE appointment_id = ? AND client_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, clientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getAverageRating(int businessId) {
        String sql = "SELECT AVG(rating) FROM feedback WHERE business_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setFeedbackId(rs.getInt("feedback_id"));
        fb.setAppointmentId(rs.getInt("appointment_id"));
        fb.setClientId(rs.getInt("client_id"));
        fb.setBusinessId(rs.getInt("business_id"));
        fb.setRating(rs.getInt("rating"));
        fb.setComment(rs.getString("comment"));
        fb.setCreatedAt(rs.getTimestamp("created_at"));
        try { fb.setBusinessName(rs.getString("business_name")); } catch (SQLException ignored) {}
        return fb;
    }
}
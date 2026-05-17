package com.slotsync.dao;

import com.slotsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class StatsDAO {

    // Total number of appointments
    public int getTotalAppointments() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM appointments");
    }

    // Number of completed appointments
    public int getCompletedAppointments() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM appointments WHERE status = 'completed'");
    }

    // Number of active users
    public int getTotalActiveUsers() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM users WHERE status = 'active'");
    }

    // Total revenue from completed appointments
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(s.price), 0) FROM appointments a JOIN services s ON a.service_id = s.service_id WHERE a.status = 'completed'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    // Top 5 most booked services
    public List<Map<String, String>> getPopularServices() throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT s.service_name, COUNT(a.appointment_id) AS total_bookings, " +
                     "COALESCE(SUM(s.price), 0) AS revenue " +
                     "FROM appointments a JOIN services s ON a.service_id = s.service_id " +
                     "WHERE a.status = 'completed' " +
                     "GROUP BY s.service_id, s.service_name ORDER BY total_bookings DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("service_name",   rs.getString("service_name"));
                row.put("total_bookings", String.valueOf(rs.getInt("total_bookings")));
                row.put("revenue",        String.format("%.2f", rs.getDouble("revenue")));
                list.add(row);
            }
        }
        return list;
    }

    // Top 5 employees by appointments handled
    public List<Map<String, String>> getTopEmployees() throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT u.full_name, e.specialization, COUNT(a.appointment_id) AS total " +
                     "FROM appointments a JOIN employees e ON a.employee_id = e.employee_id " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "GROUP BY e.employee_id, u.full_name, e.specialization ORDER BY total DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("name",           rs.getString("full_name"));
                row.put("specialization", rs.getString("specialization"));
                row.put("total",          String.valueOf(rs.getInt("total")));
                list.add(row);
            }
        }
        return list;
    }

    // Count of appointments grouped by status
    public List<Map<String, String>> getAppointmentsByStatus() throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM appointments GROUP BY status ORDER BY cnt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("status", rs.getString("status"));
                row.put("count",  String.valueOf(rs.getInt("cnt")));
                list.add(row);
            }
        }
        return list;
    }

    // Average rating per service
    public List<Map<String, String>> getAverageRatings() throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT s.service_name, ROUND(AVG(f.rating), 1) AS avg_rating, COUNT(f.feedback_id) AS total_reviews " +
                     "FROM feedback f JOIN appointments a ON f.appointment_id = a.appointment_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "GROUP BY s.service_id, s.service_name ORDER BY avg_rating DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("service_name",  rs.getString("service_name"));
                row.put("avg_rating",    rs.getString("avg_rating"));
                row.put("total_reviews", String.valueOf(rs.getInt("total_reviews")));
                list.add(row);
            }
        }
        return list;
    }

    // Appointments per day for last 7 days
    public List<Map<String, String>> getAppointmentsLast7Days() throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT DATE(appt_date) AS day, COUNT(*) AS cnt FROM appointments " +
                     "WHERE appt_date >= CURDATE() - INTERVAL 7 DAY " +
                     "GROUP BY DATE(appt_date) ORDER BY day ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("day", rs.getString("day"));
                row.put("cnt", String.valueOf(rs.getInt("cnt")));
                list.add(row);
            }
        }
        return list;
    }

    // Helper: run a COUNT query and return the int result
    private int queryInt(String sql) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}

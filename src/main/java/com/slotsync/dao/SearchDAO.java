package com.slotsync.dao;

import com.slotsync.model.Service;
import com.slotsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SearchDAO {

    // Search services by name or description
    public List<Service> searchServices(String keyword) throws SQLException {
        List<Service> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) return list;
        String sql = "SELECT * FROM services WHERE (service_name LIKE ? OR description LIKE ?) AND is_active = TRUE ORDER BY service_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapService(rs));
            }
        }
        return list;
    }

    // Search services by category ID
    public List<Service> searchServicesByCategory(int categoryId) throws SQLException {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE category_id = ? AND is_active = TRUE ORDER BY service_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapService(rs));
            }
        }
        return list;
    }

    // Get all services offered by the business that employs this employee
    public List<Service> filterByEmployee(int employeeId) throws SQLException {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.* FROM services s " +
                     "JOIN employees e ON s.business_id = e.business_id " +
                     "WHERE e.employee_id = ? AND s.is_active = TRUE ORDER BY s.service_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapService(rs));
            }
        }
        return list;
    }

    // Search users by name or email
    public List<Map<String, String>> searchUsers(String keyword) throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) return list;
        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone, u.status, r.role_name " +
                     "FROM users u JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE u.full_name LIKE ? OR u.email LIKE ? ORDER BY u.full_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new LinkedHashMap<>();
                    row.put("user_id",   String.valueOf(rs.getInt("user_id")));
                    row.put("full_name", rs.getString("full_name"));
                    row.put("email",     rs.getString("email"));
                    row.put("phone",     rs.getString("phone"));
                    row.put("status",    rs.getString("status"));
                    row.put("role",      rs.getString("role_name"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    // Search businesses by name or address
    public List<Map<String, String>> searchBusinesses(String keyword) throws SQLException {
        List<Map<String, String>> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) return list;
        String sql = "SELECT business_id, business_name, address, phone, status " +
                     "FROM businesses WHERE business_name LIKE ? OR address LIKE ? ORDER BY business_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new LinkedHashMap<>();
                    row.put("business_id",   String.valueOf(rs.getInt("business_id")));
                    row.put("business_name", rs.getString("business_name"));
                    row.put("address",       rs.getString("address"));
                    row.put("phone",         rs.getString("phone"));
                    row.put("status",        rs.getString("status"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    // Helper: map row to Service
    private Service mapService(ResultSet rs) throws SQLException {
        return new Service(
            rs.getInt("service_id"),
            rs.getInt("business_id"),
            rs.getString("service_name"),
            rs.getInt("category_id"),
            rs.getInt("duration_min"),
            rs.getDouble("price"),
            rs.getString("description"),
            rs.getBoolean("is_active")
        );
    }
}

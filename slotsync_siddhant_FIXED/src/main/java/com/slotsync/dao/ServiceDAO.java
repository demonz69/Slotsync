package com.slotsync.dao;

import com.slotsync.model.Service;
import com.slotsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    // Get all services
    public List<Service> getAllServices() throws SQLException {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY service_id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    // Get services for one business
    public List<Service> getServicesByBusiness(int businessId) throws SQLException {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE business_id = ? ORDER BY service_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // Get one service by ID
    public Service getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // Insert new service
    public boolean addService(Service s) throws SQLException {
        String sql = "INSERT INTO services (business_id, service_name, category_id, duration_min, price, description, is_active) VALUES (?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, s.getBusinessId());
            ps.setString(2, s.getServiceName());
            ps.setInt(3, s.getCategoryId());
            ps.setInt(4, s.getDurationMin());
            ps.setDouble(5, s.getPrice());
            ps.setString(6, s.getDescription());
            ps.setBoolean(7, s.isActive());
            return ps.executeUpdate() > 0;
        }
    }

    // Update existing service
    public boolean updateService(Service s) throws SQLException {
        String sql = "UPDATE services SET service_name=?, category_id=?, duration_min=?, price=?, description=?, is_active=? WHERE service_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setInt(2, s.getCategoryId());
            ps.setInt(3, s.getDurationMin());
            ps.setDouble(4, s.getPrice());
            ps.setString(5, s.getDescription());
            ps.setBoolean(6, s.isActive());
            ps.setInt(7, s.getServiceId());
            return ps.executeUpdate() > 0;
        }
    }

    // Delete service
    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "DELETE FROM services WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Toggle active/inactive
    public boolean toggleActive(int serviceId, boolean active) throws SQLException {
        String sql = "UPDATE services SET is_active = ? WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Map ResultSet row to Service object
    private Service map(ResultSet rs) throws SQLException {
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

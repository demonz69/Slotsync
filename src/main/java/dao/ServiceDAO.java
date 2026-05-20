package dao;

import model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for service CRUD operations.
 * Updated to match the full schema: services(service_id, business_id, service_name,
 * category_id, duration_min, price, description, is_active).
 */
public class ServiceDAO {

    /**
     * Create a new service.
     */
    public boolean createService(Service service) {
        String sql = "INSERT INTO services (business_id, service_name, category_id, " +
                     "duration_min, price, description, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, service.getBusinessId());
            ps.setString(2, service.getServiceName());
            ps.setInt(3, service.getCategoryId());
            ps.setInt(4, service.getDurationMin());
            ps.setDouble(5, service.getPrice());
            ps.setString(6, service.getDescription());
            ps.setBoolean(7, service.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Backward-compatible alias
    public boolean addService(Service service) {
        return createService(service);
    }

    /**
     * Update an existing service.
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE services SET service_name=?, category_id=?, duration_min=?, " +
                     "price=?, description=? WHERE service_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setInt(2, service.getCategoryId());
            ps.setInt(3, service.getDurationMin());
            ps.setDouble(4, service.getPrice());
            ps.setString(5, service.getDescription());
            ps.setInt(6, service.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a service by ID.
     */
    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM services WHERE service_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Toggle a service's active status.
     */
    public boolean toggleActive(int serviceId, boolean active) {
        String sql = "UPDATE services SET is_active = ? WHERE service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all services across all businesses.
     */
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, b.business_name, sc.category_name " +
                     "FROM services s " +
                     "LEFT JOIN businesses b ON s.business_id = b.business_id " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.category_id " +
                     "ORDER BY s.service_name ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Service s = mapRow(rs);
                s.setBusinessName(rs.getString("business_name"));
                s.setCategoryName(rs.getString("category_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get all active services for a specific business.
     */
    public List<Service> getServicesByBusiness(int businessId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, sc.category_name FROM services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.category_id " +
                     "WHERE s.business_id = ? AND s.is_active = TRUE ORDER BY s.service_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = mapRow(rs);
                s.setCategoryName(rs.getString("category_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get a single service by ID.
     */
    public Service getServiceById(int serviceId) {
        String sql = "SELECT s.*, b.business_name, sc.category_name FROM services s " +
                     "LEFT JOIN businesses b ON s.business_id = b.business_id " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.category_id " +
                     "WHERE s.service_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Service s = mapRow(rs);
                s.setBusinessName(rs.getString("business_name"));
                s.setCategoryName(rs.getString("category_name"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Count services for a business.
     */
    public int countByBusiness(int businessId) {
        String sql = "SELECT COUNT(*) FROM services WHERE business_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Alias used by client/booking.jsp
    public List<Service> getAllActive() { return getAllServices(); }

    // Get all services for a business (all statuses — for owner management)
    public List<Service> getByBusinessId(int businessId) { return getServicesByBusiness(businessId); }
    public Service getById(int serviceId)                { return getServiceById(serviceId); }

    // Map a ResultSet row to a Service object
    private Service mapRow(ResultSet rs) throws SQLException {
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
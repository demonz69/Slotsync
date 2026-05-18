package dao;

import model.Wishlist;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the wishlist feature.
 * Adapted from Usha's branch — fixed column names to match schema.
 * Schema: wishlist(client_id, service_id, added_at) with composite PK.
 */
public class WishlistDAO {

    /**
     * Add a service to the client's wishlist.
     * Uses INSERT IGNORE to prevent duplicate entries.
     */
    public boolean addToWishlist(int clientId, int serviceId) {
        String sql = "INSERT IGNORE INTO wishlist (client_id, service_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[WishlistDAO] addToWishlist: " + e.getMessage());
            return false;
        }
    }

    /**
     * Remove a service from the client's wishlist.
     */
    public boolean removeFromWishlist(int clientId, int serviceId) {
        String sql = "DELETE FROM wishlist WHERE client_id = ? AND service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[WishlistDAO] removeFromWishlist: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all wishlist items for a client, with service and business details.
     */
    public List<Wishlist> getByClientId(int clientId) {
        List<Wishlist> wishlist = new ArrayList<>();
        String sql = "SELECT w.client_id, w.service_id, w.added_at, " +
                     "s.service_name, s.price, b.business_name " +
                     "FROM wishlist w " +
                     "JOIN services s ON w.service_id = s.service_id " +
                     "JOIN businesses b ON s.business_id = b.business_id " +
                     "WHERE w.client_id = ? ORDER BY w.added_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist item = new Wishlist();
                item.setClientId(rs.getInt("client_id"));
                item.setServiceId(rs.getInt("service_id"));
                item.setAddedAt(rs.getString("added_at"));
                item.setServiceName(rs.getString("service_name"));
                item.setServicePrice(rs.getDouble("price"));
                item.setBusinessName(rs.getString("business_name"));
                wishlist.add(item);
            }
        } catch (SQLException e) {
            System.err.println("[WishlistDAO] getByClientId: " + e.getMessage());
        }
        return wishlist;
    }

    /**
     * Check if a service is already in the client's wishlist.
     */
    public boolean isInWishlist(int clientId, int serviceId) {
        String sql = "SELECT 1 FROM wishlist WHERE client_id = ? AND service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[WishlistDAO] isInWishlist: " + e.getMessage());
            return false;
        }
    }

    /**
     * Count total wishlist items for a client.
     */
    public int countByClient(int clientId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE client_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[WishlistDAO] countByClient: " + e.getMessage());
        }
        return 0;
    }
}

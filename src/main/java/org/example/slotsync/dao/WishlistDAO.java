package org.example.slotsync.dao;

import org.example.slotsync.model.Wishlist;
import org.example.slotsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * WishlistDAO
 * Handles all database operations for the Wishlist feature.
 *

 */
public class WishlistDAO {


    /**
     * Adds a service to a client's wishlist.
     * Silently ignores duplicate entries (same client + service).
     *
     * @param clientId  the logged-in client's ID
     * @param serviceId the service being saved
     * @return true if successfully added, false otherwise
     */
    public boolean addToWishlist(int clientId, int serviceId) {
        String sql = "INSERT IGNORE INTO wishlist (client_id, service_id, added_date) VALUES (?, ?, CURDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[WishlistDAO] addToWishlist error: " + e.getMessage());
            return false;
        }
    }

    //  Remove from Wishlist
    /**
     * Removes a specific service from a client's wishlist.
     *
     * @param clientId  the logged-in client's ID
     * @param serviceId the service to remove
     * @return true if successfully removed, false otherwise
     */
    public boolean removeFromWishlist(int clientId, int serviceId) {
        String sql = "DELETE FROM wishlist WHERE client_id = ? AND service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[WishlistDAO] removeFromWishlist error: " + e.getMessage());
            return false;
        }
    }

    // Get by Client ID

    /**
     * Retrieves all wishlist entries for a given client,
     * joined with the services table to get service name and price.
     *
     * @param clientId the logged-in client's ID
     * @return list of Wishlist objects (with serviceName and servicePrice populated)
     */
    public List<Wishlist> getByClientId(int clientId) {
        List<Wishlist> wishlist = new ArrayList<>();

        String sql = "SELECT w.wishlist_id, w.client_id, w.service_id, " +
                "       s.service_name, s.price, w.added_date " +
                "FROM wishlist w " +
                "JOIN services s ON w.service_id = s.service_id " +
                "WHERE w.client_id = ? " +
                "ORDER BY w.added_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Wishlist item = new Wishlist();
                item.setWishlistId(rs.getInt("wishlist_id"));
                item.setClientId(rs.getInt("client_id"));
                item.setServiceId(rs.getInt("service_id"));
                item.setServiceName(rs.getString("service_name"));
                item.setServicePrice(rs.getDouble("price"));
                item.setAddedDate(rs.getString("added_date"));
                wishlist.add(item);
            }

        } catch (SQLException e) {
            System.err.println("[WishlistDAO] getByClientId error: " + e.getMessage());
        }

        return wishlist;
    }



    /**
     * Checks whether a service is already in the client's wishlist.
     * Useful for toggling the save button state in the UI.
     *
     * @param clientId  the logged-in client's ID
     * @param serviceId the service to check
     * @return true if already saved, false otherwise
     */
    public boolean isInWishlist(int clientId, int serviceId) {
        String sql = "SELECT 1 FROM wishlist WHERE client_id = ? AND service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.err.println("[WishlistDAO] isInWishlist error: " + e.getMessage());
            return false;
        }
    }
}
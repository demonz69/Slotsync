

package dao;

import model.Wishlist;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean addToWishlist(int clientId, int serviceId) {
        String sql = "INSERT IGNORE INTO wishlist (client_id, service_id, added_date) VALUES (?, ?, CURDATE())";
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

    public List<Wishlist> getByClientId(int clientId) {
        List<Wishlist> wishlist = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.client_id, w.service_id, " +
                "s.service_name, s.price, w.added_date " +
                "FROM wishlist w " +
                "JOIN services s ON w.service_id = s.service_id " +
                "WHERE w.client_id = ? ORDER BY w.added_date DESC";
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
            System.err.println("[WishlistDAO] getByClientId: " + e.getMessage());
        }
        return wishlist;
    }

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
}
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Business;

public class BusinessDAO {
    private Connection con;

    public BusinessDAO() {
        con = DBConnection.getConnection();
    }

    // Get all businesses with owner names
    public List<Business> getAllBusinesses() {
        List<Business> list = new ArrayList<>();
        try {
            String query = "SELECT b.*, u.full_name AS owner_name FROM businesses b JOIN users u ON b.owner_id = u.user_id ORDER BY b.business_id DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Business b = new Business();
                b.setBusinessId(rs.getInt("business_id"));
                b.setName(rs.getString("business_name"));
                b.setOwnerName(rs.getString("owner_name"));
                b.setAddress(rs.getString("address"));
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update business status
    public boolean updateStatus(int businessId, String status) {
        try {
            String query = "UPDATE businesses SET status=? WHERE business_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, businessId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete business
    public boolean deleteBusiness(int businessId) {
        try {
            String query = "DELETE FROM businesses WHERE business_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, businessId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count active businesses
    public int countActiveBusinesses() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM businesses WHERE status='active'";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Count all businesses
    public int countAllBusinesses() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM businesses";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Get businesses owned by a specific user
    public List<Business> getBusinessesByOwner(int ownerId) {
        List<Business> list = new ArrayList<>();
        try {
            String query = "SELECT b.*, u.full_name AS owner_name FROM businesses b " +
                           "JOIN users u ON b.owner_id = u.user_id WHERE b.owner_id = ? " +
                           "ORDER BY b.business_id DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Business b = new Business();
                b.setBusinessId(rs.getInt("business_id"));
                b.setName(rs.getString("business_name"));
                b.setOwnerName(rs.getString("owner_name"));
                b.setAddress(rs.getString("address"));
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count pending businesses
    public int countPendingBusinesses() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM businesses WHERE status='pending'";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}

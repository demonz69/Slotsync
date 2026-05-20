package dao;

import java.sql.*;
import model.User;

public class UserDAO {

    private Connection con;

    public UserDAO() {
        con = DBConnection.getConnection();
    }

    // Register User
    public boolean register(User user) {
        try {
            String query = "INSERT INTO users (full_name, email, phone, password, role_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setInt(5, user.getRoleId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Login user
    public User login(String email, String password) {
        User user = null;

        try {
            String query = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE u.email=? AND u.password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRoleId(rs.getInt("role_id"));
                user.setRole(rs.getString("role_name"));
                user.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // Check if user exists (email validation)
    public boolean isEmailExists(String email) {
        boolean exists = false;
        try {
            String query = "SELECT * FROM users WHERE email=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
    
    // Admin: Get all users
    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        try {
            String query = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id ORDER BY u.user_id DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRoleId(rs.getInt("role_id"));
                user.setRole(rs.getString("role_name"));
                user.setStatus(rs.getString("status"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Admin: Count users by status
    public int countByStatus(String status) {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM users WHERE status=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    // Admin: Update user status
    public boolean updateStatus(int userId, String status) {
        try {
            String query = "UPDATE users SET status=? WHERE user_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Admin: Count all users
    public int countAllUsers() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) FROM users";
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
    
    // Admin: Delete user
    public boolean deleteUser(int userId) {
        try {
            String query = "DELETE FROM users WHERE user_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update user profile (name, phone)
    public boolean updateUser(User user) {
        try {
            String query = "UPDATE users SET full_name=?, phone=? WHERE user_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get a single user by ID (used by client/profile.jsp)
    public User getUserById(int userId) {
        try {
            String query = "SELECT u.*, r.role_name FROM users u " +
                           "JOIN roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role_name"));
                user.setStatus(rs.getString("status"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Check if phone number already exists (for another user)
    public boolean isPhoneExists(String phone) {
        try {
            String query = "SELECT * FROM users WHERE phone=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
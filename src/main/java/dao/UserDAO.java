package dao;

import java.sql.*;
import model.User;

public class UserDAO {

    private Connection con;

    public UserDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/slotsync", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Register User
    public boolean register(User user) {
        try {
            String query = "INSERT INTO users (full_name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());

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
            String query = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
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
}
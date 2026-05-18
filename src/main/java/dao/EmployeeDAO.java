package dao;

import model.Employee;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    // Add a new employee to the system
    public boolean addEmployee(Employee emp) {
        String sql = "INSERT INTO employees (user_id, business_id, designation, phone, status) " +
                     "VALUES (?, ?, ?, ?, 'active')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, emp.getUserId());
            ps.setInt(2, emp.getBusinessId());
            ps.setString(3, emp.getDesignation());
            ps.setString(4, emp.getPhone());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all employees belonging to a specific business (for owner dashboard)
    public List<Employee> getByBusinessId(int businessId) {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT e.*, u.full_name FROM employees e " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "WHERE e.business_id = ? AND e.status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee emp = mapRow(rs);
                emp.setFullName(rs.getString("full_name"));
                list.add(emp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get one employee by their user_id (used after employee logs in)
    public Employee getByUserId(int userId) {
        String sql = "SELECT * FROM employees WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get one employee by employee_id (used in booking flow)
    public Employee getById(int employeeId) {
        String sql = "SELECT e.*, u.full_name FROM employees e " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "WHERE e.employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee emp = mapRow(rs);
                emp.setFullName(rs.getString("full_name"));
                return emp;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update employee designation and phone
    public boolean update(Employee emp) {
        String sql = "UPDATE employees SET designation = ?, phone = ? " +
                     "WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, emp.getDesignation());
            ps.setString(2, emp.getPhone());
            ps.setInt(3, emp.getEmployeeId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft delete — set status to inactive instead of deleting from DB
    public boolean delete(int employeeId) {
        String sql = "UPDATE employees SET status = 'inactive' WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Private helper — maps one DB row to an Employee object
    private Employee mapRow(ResultSet rs) throws SQLException {
        return new Employee(
            rs.getInt("employee_id"),
            rs.getInt("user_id"),
            rs.getInt("business_id"),
            rs.getString("designation"),
            rs.getString("phone"),
            rs.getString("status"),
            rs.getString("created_at")
        );
    }
}
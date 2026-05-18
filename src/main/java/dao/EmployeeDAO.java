package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Employee;

public class EmployeeDAO {

    private Connection con;

    public EmployeeDAO() {
        con = DBConnection.getConnection();
    }

    // Add a new employee record
    public boolean addEmployee(Employee employee) {
        try {
            String query = "INSERT INTO employees (user_id, business_id, position, status) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, employee.getUserId());
            ps.setInt(2, employee.getBusinessId());
            ps.setString(3, employee.getPosition());
            ps.setString(4, employee.getStatus());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all employees
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM employees";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Employee emp = mapRow(rs);
                list.add(emp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all employees for a specific business
    public List<Employee> getEmployeesByBusiness(int businessId) {
        List<Employee> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM employees WHERE business_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get a single employee by employee_id
    public Employee getEmployeeById(int employeeId) {
        Employee emp = null;
        try {
            String query = "SELECT * FROM employees WHERE employee_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                emp = mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }

    // Update employee position and status
    public boolean updateEmployee(Employee employee) {
        try {
            String query = "UPDATE employees SET position = ?, status = ? WHERE employee_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, employee.getPosition());
            ps.setString(2, employee.getStatus());
            ps.setInt(3, employee.getEmployeeId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an employee record
    public boolean deleteEmployee(int employeeId) {
        try {
            String query = "DELETE FROM employees WHERE employee_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, employeeId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: map ResultSet row to Employee object
    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setEmployeeId(rs.getInt("employee_id"));
        emp.setUserId(rs.getInt("user_id"));
        emp.setBusinessId(rs.getInt("business_id"));
        emp.setPosition(rs.getString("position"));
        emp.setStatus(rs.getString("status"));
        return emp;
    }
}

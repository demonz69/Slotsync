package dao;

import model.Appointment;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    // Book a new appointment
    public boolean bookAppointment(Appointment apt) {
        String sql = "INSERT INTO appointments " +
                     "(client_id, employee_id, service_id, business_id, " +
                     "appointment_date, slot_time, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'pending', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, apt.getClientId());
            ps.setInt(2, apt.getEmployeeId());
            ps.setInt(3, apt.getServiceId());
            ps.setInt(4, apt.getBusinessId());
            ps.setString(5, apt.getAppointmentDate());
            ps.setString(6, apt.getSlotTime());
            ps.setString(7, apt.getNotes());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cancel an appointment
    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'cancelled' " +
                     "WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all appointments for a specific client
    public List<Appointment> getAppointmentsByUser(int clientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE client_id = ? " +
                     "ORDER BY appointment_date DESC, slot_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all appointments for a specific employee
    public List<Appointment> getAppointmentsByEmployee(int employeeId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE employee_id = ? " +
                     "ORDER BY appointment_date DESC, slot_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all appointments for a business (owner view)
    public List<Appointment> getAppointmentsByBusiness(int businessId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE business_id = ? " +
                     "ORDER BY appointment_date DESC, slot_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all appointments — admin view
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments " +
                     "ORDER BY appointment_date DESC, slot_time ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update appointment status — confirmed / completed / cancelled
    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE appointments SET status = ? " +
                     "WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Assign or reassign employee to an appointment
    public boolean assignEmployee(int appointmentId, int employeeId) {
        String sql = "UPDATE appointments SET employee_id = ?, status = 'confirmed' " +
                     "WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get one appointment by ID
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT * FROM appointments WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Private helper — maps one DB row to Appointment object
    private Appointment mapRow(ResultSet rs) throws SQLException {
        return new Appointment(
            rs.getInt("appointment_id"),
            rs.getInt("client_id"),
            rs.getInt("employee_id"),
            rs.getInt("service_id"),
            rs.getInt("business_id"),
            rs.getString("appointment_date"),
            rs.getString("slot_time"),
            rs.getString("status"),
            rs.getString("notes"),
            rs.getString("created_at")
        );
    }
}
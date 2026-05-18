package dao;

import model.Appointment;
import dao.DBConnection;

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
        String sql = "SELECT a.*, s.service_name, s.price, u.full_name AS employee_name " +
                     "FROM appointments a " +
                     "LEFT JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN employees e ON a.employee_id = e.employee_id " +
                     "LEFT JOIN users u ON e.user_id = u.user_id " +
                     "WHERE a.client_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.slot_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment apt = mapRow(rs);
                apt.setServiceName(rs.getString("service_name"));
                apt.setPrice(rs.getDouble("price"));
                apt.setEmployeeName(rs.getString("employee_name"));
                list.add(apt);
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

    // Get available unbooked slots for an employee on a specific date
    public List<String> getAvailableSlots(int employeeId, String date) {

        // Step 1: Convert date to day name e.g. "2026-05-11" -> "Sunday"
        String dayName = "";
        try {
            java.time.LocalDate localDate = java.time.LocalDate.parse(date);
            dayName = localDate.getDayOfWeek()
                               .getDisplayName(
                                   java.time.format.TextStyle.FULL,
                                   java.util.Locale.ENGLISH
                               );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        // Step 2: Get employee shift for that day from availability table
        String availSql = "SELECT start_time, end_time, slot_duration " +
                          "FROM availability " +
                          "WHERE employee_id = ? AND day_of_week = ?";

        List<String> allSlots = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(availSql)) {

            ps.setInt(1, employeeId);
            ps.setString(2, dayName);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String start    = rs.getString("start_time");
                String end      = rs.getString("end_time");
                int    duration = rs.getInt("slot_duration");

                // Step 3: Generate all slots from start to end
                java.time.LocalTime current = java.time.LocalTime.parse(start);
                java.time.LocalTime endTime = java.time.LocalTime.parse(end);

                while (!current.plusMinutes(duration).isAfter(endTime)) {
                    allSlots.add(current.toString());
                    current = current.plusMinutes(duration);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Step 4: Remove already booked slots
        String bookedSql = "SELECT slot_time FROM appointments " +
                           "WHERE employee_id = ? " +
                           "AND appointment_date = ? " +
                           "AND status != 'cancelled'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(bookedSql)) {

            ps.setInt(1, employeeId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                allSlots.remove(rs.getString("slot_time"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Step 5: Return only free slots
        return allSlots;
    }

    public int countAllAppointments() {
        int count = 0;
        try {
            java.sql.Connection con = DBConnection.getConnection();
            java.sql.PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM appointments");
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Private helper — maps one DB row to an Appointment object
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
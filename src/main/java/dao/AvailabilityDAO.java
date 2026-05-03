package dao;

import model.Availability;
import util.DBConnection;

import java.sql.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AvailabilityDAO {

    // Add a new availability record for an employee
    public boolean addAvailability(Availability av) {
        String sql = "INSERT INTO availability (employee_id, day_of_week, start_time, end_time, slot_duration) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, av.getEmployeeId());
            ps.setString(2, av.getDayOfWeek());
            ps.setString(3, av.getStartTime());
            ps.setString(4, av.getEndTime());
            ps.setInt(5, av.getSlotDuration());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all availability records for a specific employee
    public List<Availability> getAvailabilityByEmployee(int employeeId) {
        List<Availability> list = new ArrayList<>();
        String sql = "SELECT * FROM availability WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Availability av = new Availability(
                    rs.getInt("availability_id"),
                    rs.getInt("employee_id"),
                    rs.getString("day_of_week"),
                    rs.getString("start_time"),
                    rs.getString("end_time"),
                    rs.getInt("slot_duration")
                );
                list.add(av);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update an existing availability record
    public boolean updateAvailability(Availability av) {
        String sql = "UPDATE availability SET day_of_week=?, start_time=?, end_time=?, slot_duration=? WHERE availability_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, av.getDayOfWeek());
            ps.setString(2, av.getStartTime());
            ps.setString(3, av.getEndTime());
            ps.setInt(4, av.getSlotDuration());
            ps.setInt(5, av.getAvailabilityId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an availability record
    public boolean deleteAvailability(int availabilityId) {
        String sql = "DELETE FROM availability WHERE availability_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, availabilityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Auto slot generation: generates list of "HH:mm" slots from start to end
    // based on slot_duration. These are candidate slots, not yet booked.
    public List<String> generateSlots(String startTime, String endTime, int slotDurationMinutes) {
        List<String> slots = new ArrayList<>();
        LocalTime current = LocalTime.parse(startTime);
        LocalTime end = LocalTime.parse(endTime);

        while (current.plusMinutes(slotDurationMinutes).compareTo(end) <= 0) {
            slots.add(current.toString());
            current = current.plusMinutes(slotDurationMinutes);
        }
        return slots;
    }

    // Get available (unbooked) slots for an employee on a specific date
    public List<String> getAvailableSlots(int employeeId, String date) {
        // Get the day name from the date (e.g. "Monday")
        String dayName = "";
        try {
            java.time.LocalDate localDate = java.time.LocalDate.parse(date);
            dayName = localDate.getDayOfWeek().getDisplayName(
                java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        // Get availability for that employee on that day
        String sql = "SELECT * FROM availability WHERE employee_id=? AND day_of_week=?";
        List<String> allSlots = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, dayName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String start = rs.getString("start_time");
                String end = rs.getString("end_time");
                int duration = rs.getInt("slot_duration");
                allSlots = generateSlots(start, end, duration);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Remove already booked slots
        String bookedSql = "SELECT slot_time FROM appointments WHERE employee_id=? AND appointment_date=? AND status != 'cancelled'";
        List<String> bookedSlots = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(bookedSql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookedSlots.add(rs.getString("slot_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        allSlots.removeAll(bookedSlots);
        return allSlots;
    }
}
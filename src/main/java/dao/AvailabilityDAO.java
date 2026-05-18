package dao;

import model.Availability;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvailabilityDAO {

    // Set availability — insert if new day, update if day already exists
    public boolean set(Availability av) {
        String checkSql = "SELECT availability_id FROM availability " +
                          "WHERE employee_id = ? AND day_of_week = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, av.getEmployeeId());
            checkPs.setString(2, av.getDayOfWeek());
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Already exists — update
                int existingId = rs.getInt("availability_id");
                String updateSql = "UPDATE availability " +
                                   "SET start_time = ?, end_time = ?, slot_duration = ? " +
                                   "WHERE availability_id = ?";

                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setString(1, av.getStartTime());
                    updatePs.setString(2, av.getEndTime());
                    updatePs.setInt(3, av.getSlotDuration());
                    updatePs.setInt(4, existingId);
                    return updatePs.executeUpdate() > 0;
                }

            } else {
                // New record — insert
                String insertSql = "INSERT INTO availability " +
                                   "(employee_id, business_id, day_of_week, " +
                                   "start_time, end_time, slot_duration) " +
                                   "VALUES (?, ?, ?, ?, ?, ?)";

                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, av.getEmployeeId());
                    insertPs.setInt(2, av.getBusinessId());
                    insertPs.setString(3, av.getDayOfWeek());
                    insertPs.setString(4, av.getStartTime());
                    insertPs.setString(5, av.getEndTime());
                    insertPs.setInt(6, av.getSlotDuration());
                    return insertPs.executeUpdate() > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all availability records for one employee
    public List<Availability> getByEmployeeId(int employeeId) {
        List<Availability> list = new ArrayList<>();
        String sql = "SELECT * FROM availability WHERE employee_id = ? " +
                     "ORDER BY FIELD(day_of_week, " +
                     "'Monday','Tuesday','Wednesday'," +
                     "'Thursday','Friday','Saturday','Sunday')";

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

    // Update an existing availability record by ID
    public boolean update(Availability av) {
        String sql = "UPDATE availability " +
                     "SET start_time = ?, end_time = ?, slot_duration = ? " +
                     "WHERE availability_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, av.getStartTime());
            ps.setString(2, av.getEndTime());
            ps.setInt(3, av.getSlotDuration());
            ps.setInt(4, av.getAvailabilityId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete one availability record by ID
    public boolean delete(int availabilityId) {
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

    // Private helper — maps one DB row to Availability object
    private Availability mapRow(ResultSet rs) throws SQLException {
        return new Availability(
            rs.getInt("availability_id"),
            rs.getInt("employee_id"),
            rs.getInt("business_id"),
            rs.getString("day_of_week"),
            rs.getString("start_time"),
            rs.getString("end_time"),
            rs.getInt("slot_duration")
        );
    }
}
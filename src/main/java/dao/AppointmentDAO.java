package dao;

import java.util.*;

public class AppointmentDAO {

    private List<String> booked = new ArrayList<>();

    public void book(String slot) { booked.add(slot); }

    public void cancel(String slot) { booked.remove(slot); }

    public List<String> getAll() { return booked; }

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
}
package dao;

import java.util.*;

public class AppointmentDAO {

    private List<String> booked = new ArrayList<>();

    public void book(String slot) { booked.add(slot); }

    public void cancel(String slot) { booked.remove(slot); }

    public List<String> getAll() { return booked; }
}
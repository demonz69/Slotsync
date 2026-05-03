package controller;

import dao.AppointmentDAO;

public class AppointmentController {

    private AppointmentDAO dao = new AppointmentDAO();

    public void bookAppointment(String slot) {
        dao.book(slot);
        System.out.println("Booked: " + slot);
    }

    public void cancelAppointment(String slot) {
        dao.cancel(slot);
        System.out.println("Cancelled: " + slot);
    }

    public void showAppointments() {
        System.out.println("Booked Slots:");
        for (String s : dao.getAll()) {
            System.out.println(s);
        }
    }
}
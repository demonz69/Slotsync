package controller;

import dao.AppointmentDAO;
import dao.AvailabilityDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AppointmentController")
public class AppointmentController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private AvailabilityDAO availabilityDAO = new AvailabilityDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        switch (action) {

            // Client: start booking - pick a service first
            case "book":
                List<Service> services = serviceDAO.getAllServices();
                request.setAttribute("services", services);
                request.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(request, response);
                break;

            // Get available slots for an employee on a date (called via AJAX or form)
            case "getSlots":
                int empId = Integer.parseInt(request.getParameter("employeeId"));
                String date = request.getParameter("date");
                List<String> slots = appointmentDAO.getAvailableSlots(empId, date);
                request.setAttribute("slots", slots);
                request.setAttribute("employeeId", empId);
                request.setAttribute("date", date);
                request.getRequestDispatcher("/WEB-INF/views/selectSlot.jsp").forward(request, response);
                break;

            // Client: view own appointments
            case "myAppointments":
                int userId = (int) session.getAttribute("userId");
                List<Appointment> myApts = appointmentDAO.getAppointmentsByUser(userId);
                request.setAttribute("appointments", myApts);
                request.getRequestDispatcher("/WEB-INF/views/myAppointments.jsp").forward(request, response);
                break;

            // Admin: view all appointments
            case "adminList":
                if (!"admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
                List<Appointment> allApts = appointmentDAO.getAllAppointments();
                request.setAttribute("appointments", allApts);
                request.getRequestDispatcher("/WEB-INF/views/adminAppointments.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        switch (action) {

            // Client: confirm and book an appointment
            case "confirm": {
                int userId = (int) session.getAttribute("userId");
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                String date = request.getParameter("date");
                String slotTime = request.getParameter("slotTime");

                Appointment apt = new Appointment();
                apt.setUserId(userId);
                apt.setServiceId(serviceId);
                apt.setEmployeeId(employeeId);
                apt.setAppointmentDate(date);
                apt.setSlotTime(slotTime);

                boolean success = appointmentDAO.bookAppointment(apt);
                if (success) {
                    response.sendRedirect(request.getContextPath() +
                        "/AppointmentController?action=myAppointments&msg=booked");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/AppointmentController?action=book&msg=error");
                }
                break;
            }

            // Client or Admin: cancel an appointment
            case "cancel": {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                Appointment apt = appointmentDAO.getAppointmentById(appointmentId);

                int sessionUserId = (int) session.getAttribute("userId");
                // Only the owner or admin can cancel
                if (apt != null && (apt.getUserId() == sessionUserId || "admin".equals(role))) {
                    appointmentDAO.cancelAppointment(appointmentId);
                    response.sendRedirect(request.getContextPath() +
                        "/AppointmentController?action=myAppointments&msg=cancelled");
                } else {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                }
                break;
            }

            // Admin: assign/reassign employee to an appointment
            case "assignEmployee": {
                if (!"admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                appointmentDAO.assignEmployee(appointmentId, employeeId);
                response.sendRedirect(request.getContextPath() +
                    "/AppointmentController?action=adminList&msg=assigned");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
package controller;

import dao.AppointmentDAO;
import dao.AvailabilityDAO;
import dao.EmployeeDAO;
import model.Appointment;
import model.Availability;
import model.Employee;
import util.SlotGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final AvailabilityDAO availabilityDAO = new AvailabilityDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    // ─────────────────────────────────────────────
    // doPost — handles book and cancel actions
    // ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check session — redirect to login if not logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "book":
                handleBook(request, response, session);
                break;

            case "cancel":
                handleCancel(request, response, session);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    // ─────────────────────────────────────────────
    // doGet — loads available slots for a date
    // ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "loadSlots":
                handleLoadSlots(request, response, session);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    // ─────────────────────────────────────────────
    // PRIVATE: handle booking a new appointment
    // ─────────────────────────────────────────────
    private void handleBook(HttpServletRequest request,
                            HttpServletResponse response,
                            HttpSession session)
            throws ServletException, IOException {

        try {
            // Get logged-in client ID from session
            int clientId = (int) session.getAttribute("userId");

            // Get form values
            String employeeIdStr = request.getParameter("employeeId");
            String serviceIdStr  = request.getParameter("serviceId");
            String businessIdStr = request.getParameter("businessId");
            String date          = request.getParameter("appointmentDate");
            String slotTime      = request.getParameter("slotTime");
            String notes         = request.getParameter("notes");

            // Basic validation — all fields must be filled
            if (employeeIdStr == null || serviceIdStr == null ||
                businessIdStr == null || date == null ||
                slotTime == null || date.isEmpty() || slotTime.isEmpty()) {

                session.setAttribute("errorMsg", "All fields are required.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/booking.jsp");
                return;
            }

            // Cannot book a past date
            if (SlotGenerator.isPastDate(date)) {
                session.setAttribute("errorMsg",
                                     "Cannot book an appointment in the past.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/booking.jsp");
                return;
            }

            int employeeId = Integer.parseInt(employeeIdStr);
            int serviceId  = Integer.parseInt(serviceIdStr);
            int businessId = Integer.parseInt(businessIdStr);

            // Build Appointment object
            Appointment apt = new Appointment();
            apt.setClientId(clientId);
            apt.setEmployeeId(employeeId);
            apt.setServiceId(serviceId);
            apt.setBusinessId(businessId);
            apt.setAppointmentDate(date);
            apt.setSlotTime(slotTime);
            apt.setNotes(notes != null ? notes : "");
            apt.setStatus("pending");

            // Save to database
            boolean success = appointmentDAO.bookAppointment(apt);

            if (success) {
                session.setAttribute("successMsg",
                                     "Appointment booked successfully!");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
            } else {
                session.setAttribute("errorMsg",
                                     "Booking failed. Please try again.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/booking.jsp");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid input. Please try again.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/client/booking.jsp");
        }
    }

    // ─────────────────────────────────────────────
    // PRIVATE: handle cancelling an appointment
    // ─────────────────────────────────────────────
    private void handleCancel(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws ServletException, IOException {

        try {
            int clientId       = (int) session.getAttribute("userId");
            String role        = (String) session.getAttribute("role");
            int appointmentId  = Integer.parseInt(
                                     request.getParameter("appointmentId"));

            // Get the appointment to verify ownership
            Appointment apt = appointmentDAO.getAppointmentById(appointmentId);

            if (apt == null) {
                session.setAttribute("errorMsg", "Appointment not found.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
                return;
            }

            // Only the client who booked OR owner/admin can cancel
            boolean isOwner  = "owner".equals(role) || "admin".equals(role);
            boolean isClient = apt.getClientId() == clientId;

            if (!isClient && !isOwner) {
                session.setAttribute("errorMsg",
                                     "You are not authorized to cancel this appointment.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
                return;
            }

            boolean success = appointmentDAO.cancelAppointment(appointmentId);

            if (success) {
                session.setAttribute("successMsg",
                                     "Appointment cancelled successfully.");
            } else {
                session.setAttribute("errorMsg",
                                     "Cancel failed. Please try again.");
            }

            // Redirect based on role
            if (isOwner) {
                response.sendRedirect(request.getContextPath() +
                                      "/views/owner/appointments.jsp");
            } else {
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid appointment ID.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/client/bookings.jsp");
        }
    }

    // ─────────────────────────────────────────────
    // PRIVATE: load available slots for employee+date
    // ─────────────────────────────────────────────
    private void handleLoadSlots(HttpServletRequest request,
                                 HttpServletResponse response,
                                 HttpSession session)
            throws ServletException, IOException {

        try {
            String employeeIdStr = request.getParameter("employeeId");
            String date          = request.getParameter("date");

            // Validate inputs
            if (employeeIdStr == null || date == null ||
                employeeIdStr.isEmpty() || date.isEmpty()) {

                request.setAttribute("errorMsg",
                                     "Please select an employee and date.");
                request.getRequestDispatcher(
                    "/views/client/booking.jsp").forward(request, response);
                return;
            }

            // Cannot load slots for past date
            if (SlotGenerator.isPastDate(date)) {
                request.setAttribute("errorMsg",
                                     "Please select a future date.");
                request.getRequestDispatcher(
                    "/views/client/booking.jsp").forward(request, response);
                return;
            }

            int employeeId = Integer.parseInt(employeeIdStr);

            // Get available slots from AppointmentDAO
            List<String> slots = appointmentDAO.getAvailableSlots(
                                     employeeId, date);

            // Get employee info to show on page
            Employee employee = employeeDAO.getByUserId(employeeId);

            // Send data to JSP
            request.setAttribute("slots",      slots);
            request.setAttribute("employee",   employee);
            request.setAttribute("date",       date);
            request.setAttribute("employeeId", employeeId);

            request.getRequestDispatcher(
                "/views/client/booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Invalid employee ID.");
            request.getRequestDispatcher(
                "/views/client/booking.jsp").forward(request, response);
        }
    }
}
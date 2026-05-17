package controller;

import dao.AppointmentDAO;
import dao.EmployeeDAO;
import model.Appointment;
import model.Employee;
import util.SlotGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final EmployeeDAO    employeeDAO    = new EmployeeDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

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
            case "assign":
                handleAssign(request, response, session);
                break;
            case "updateStatus":
                handleUpdateStatus(request, response, session);
                break;
            default:
                response.sendRedirect(
                    request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

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
                response.sendRedirect(
                    request.getContextPath() + "/index.jsp");
        }
    }

    private void handleBook(HttpServletRequest request,
                            HttpServletResponse response,
                            HttpSession session)
            throws IOException {
        try {
            int    clientId   = (int) session.getAttribute("userId");
            int    employeeId = Integer.parseInt(
                                    request.getParameter("employeeId"));
            int    serviceId  = Integer.parseInt(
                                    request.getParameter("serviceId"));
            int    businessId = Integer.parseInt(
                                    request.getParameter("businessId"));
            String date       = request.getParameter("appointmentDate");
            String slotTime   = request.getParameter("slotTime");
            String notes      = request.getParameter("notes");

            if (date == null || date.isEmpty() ||
                slotTime == null || slotTime.isEmpty()) {
                session.setAttribute("errorMsg", "All fields are required.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/booking.jsp");
                return;
            }

            if (SlotGenerator.isPastDate(date)) {
                session.setAttribute("errorMsg",
                                     "Cannot book a past date.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/booking.jsp");
                return;
            }

            Appointment apt = new Appointment();
            apt.setClientId(clientId);
            apt.setEmployeeId(employeeId);
            apt.setServiceId(serviceId);
            apt.setBusinessId(businessId);
            apt.setAppointmentDate(date);
            apt.setSlotTime(slotTime);
            apt.setNotes(notes != null ? notes : "");
            apt.setStatus("pending");

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
            session.setAttribute("errorMsg", "Invalid input.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/client/booking.jsp");
        }
    }

    private void handleCancel(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws IOException {
        try {
            int    clientId      = (int) session.getAttribute("userId");
            String role          = (String) session.getAttribute("role");
            int    appointmentId = Integer.parseInt(
                                       request.getParameter("appointmentId"));

            Appointment apt =
                appointmentDAO.getAppointmentById(appointmentId);

            if (apt == null) {
                session.setAttribute("errorMsg", "Appointment not found.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
                return;
            }

            boolean isOwner  = "owner".equals(role) || "admin".equals(role);
            boolean isClient = apt.getClientId() == clientId;

            if (!isClient && !isOwner) {
                session.setAttribute("errorMsg", "Not authorized.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
                return;
            }

            appointmentDAO.cancelAppointment(appointmentId);
            session.setAttribute("successMsg", "Appointment cancelled.");

            if (isOwner) {
                response.sendRedirect(request.getContextPath() +
                                      "/views/owner/appointments.jsp");
            } else {
                response.sendRedirect(request.getContextPath() +
                                      "/views/client/bookings.jsp");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid ID.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/client/bookings.jsp");
        }
    }

    private void handleAssign(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws IOException {
        try {
            String role = (String) session.getAttribute("role");
            if (!"owner".equals(role) && !"admin".equals(role)) {
                session.setAttribute("errorMsg", "Not authorized.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/owner/appointments.jsp");
                return;
            }
            int appointmentId = Integer.parseInt(
                                    request.getParameter("appointmentId"));
            int employeeId    = Integer.parseInt(
                                    request.getParameter("employeeId"));
            boolean success   =
                appointmentDAO.assignEmployee(appointmentId, employeeId);
            session.setAttribute(
                success ? "successMsg" : "errorMsg",
                success ? "Employee assigned." : "Assign failed.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/owner/appointments.jsp");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid data.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/owner/appointments.jsp");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request,
                                    HttpServletResponse response,
                                    HttpSession session)
            throws IOException {
        try {
            String role = (String) session.getAttribute("role");
            if (!"owner".equals(role) && !"admin".equals(role)) {
                session.setAttribute("errorMsg", "Not authorized.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/owner/appointments.jsp");
                return;
            }
            int    appointmentId = Integer.parseInt(
                                       request.getParameter("appointmentId"));
            String status        = request.getParameter("status");

            if (!status.equals("confirmed") &&
                !status.equals("completed") &&
                !status.equals("cancelled")) {
                session.setAttribute("errorMsg", "Invalid status.");
                response.sendRedirect(request.getContextPath() +
                                      "/views/owner/appointments.jsp");
                return;
            }
            boolean success =
                appointmentDAO.updateStatus(appointmentId, status);
            session.setAttribute(
                success ? "successMsg" : "errorMsg",
                success ? "Status updated to " + status + "."
                        : "Update failed.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/owner/appointments.jsp");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid data.");
            response.sendRedirect(request.getContextPath() +
                                  "/views/owner/appointments.jsp");
        }
    }

    private void handleLoadSlots(HttpServletRequest request,
                                 HttpServletResponse response,
                                 HttpSession session)
            throws ServletException, IOException {
        try {
            String employeeIdStr = request.getParameter("employeeId");
            String date          = request.getParameter("date");

            if (employeeIdStr == null || date == null ||
                employeeIdStr.isEmpty() || date.isEmpty()) {
                request.setAttribute("errorMsg",
                                     "Select employee and date.");
                request.getRequestDispatcher(
                    "/views/client/booking.jsp")
                    .forward(request, response);
                return;
            }

            if (SlotGenerator.isPastDate(date)) {
                request.setAttribute("errorMsg", "Select a future date.");
                request.getRequestDispatcher(
                    "/views/client/booking.jsp")
                    .forward(request, response);
                return;
            }

            int          employeeId = Integer.parseInt(employeeIdStr);
            List<String> slots      =
                appointmentDAO.getAvailableSlots(employeeId, date);
            Employee employee = employeeDAO.getByUserId(employeeId);

            request.setAttribute("slots",      slots);
            request.setAttribute("employee",   employee);
            request.setAttribute("date",       date);
            request.setAttribute("employeeId", employeeId);
            request.getRequestDispatcher(
                "/views/client/booking.jsp")
                .forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Invalid employee ID.");
            request.getRequestDispatcher(
                "/views/client/booking.jsp")
                .forward(request, response);
        }
    }
}
package controller;

import dao.AppointmentDAO;
import dao.AvailabilityDAO;
import dao.EmployeeDAO;
import model.Appointment;
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
                response.sendRedirect(request.getContextPath() + "/index.jsp");
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
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void handleBook(HttpServletRequest request,
                            HttpServletResponse response,
                            HttpSession session)
            throws ServletException, IOException {

        try {
            int clientId = (int) session.getAttribute("userId");

            String employeeIdStr = request.getParameter("employeeId");
            String serviceIdStr  = request.getParameter("serviceId");
            String businessIdStr = request.getParameter("businessId");
            String date          = request.getParameter("appointmentDate");
            String slotTime      = request.getParameter("slotTime");
            String notes         = request.getParameter("notes");

            if (employeeIdStr == null || serviceIdStr == null ||
                businessIdStr == null || date == null ||
                slotTime == null || date.isEmpty() || slotTime.isEmpty()) {

                session.setAttribute("errorMsg", "All fields are required.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/booking.jsp");
                return;
            }

            if (SlotGenerator.isPastDate(date)) {
                session.setAttribute("errorMsg", "Cannot book past date.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/booking.jsp");
                return;
            }

            Appointment apt = new Appointment();
            apt.setClientId(clientId);
            apt.setEmployeeId(Integer.parseInt(employeeIdStr));
            apt.setServiceId(Integer.parseInt(serviceIdStr));
            apt.setBusinessId(Integer.parseInt(businessIdStr));
            apt.setAppointmentDate(date);
            apt.setSlotTime(slotTime);
            apt.setNotes(notes != null ? notes : "");
            apt.setStatus("pending");

            boolean success = appointmentDAO.bookAppointment(apt);

            if (success) {
                session.setAttribute("successMsg", "Booked successfully.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/bookings.jsp");
            } else {
                session.setAttribute("errorMsg", "Booking failed.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/booking.jsp");
            }

        } catch (Exception e) {
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
            int appointmentId = Integer.parseInt(
                    request.getParameter("appointmentId"));

            Appointment apt = appointmentDAO.getAppointmentById(appointmentId);

            if (apt == null) {
                session.setAttribute("errorMsg", "Not found.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/bookings.jsp");
                return;
            }

            String role = (String) session.getAttribute("role");
            int clientId = (int) session.getAttribute("userId");

            boolean isOwner = "owner".equals(role) || "admin".equals(role);
            boolean isClient = apt.getClientId() == clientId;

            if (!isOwner && !isClient) {
                session.setAttribute("errorMsg", "Not allowed.");
                response.sendRedirect(request.getContextPath() +
                        "/views/client/bookings.jsp");
                return;
            }

            appointmentDAO.cancelAppointment(appointmentId);

            if (isOwner) {
                response.sendRedirect(request.getContextPath() +
                        "/views/owner/appointments.jsp");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/views/client/bookings.jsp");
            }

        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid request.");
            response.sendRedirect(request.getContextPath() +
                    "/views/client/bookings.jsp");
        }
    }

    private void handleLoadSlots(HttpServletRequest request,
                                 HttpServletResponse response,
                                 HttpSession session)
            throws ServletException, IOException {

        try {
            int employeeId = Integer.parseInt(
                    request.getParameter("employeeId"));

            String date = request.getParameter("date");

            List<String> slots =
                    appointmentDAO.getAvailableSlots(employeeId, date);

            Employee emp = employeeDAO.getByUserId(employeeId);

            request.setAttribute("slots", slots);
            request.setAttribute("employee", emp);
            request.setAttribute("date", date);

            request.getRequestDispatcher(
                    "/views/client/booking.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Invalid data.");
            request.getRequestDispatcher(
                    "/views/client/booking.jsp"
            ).forward(request, response);
        }
    }

    private void handleAssign(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws IOException {

        String role = (String) session.getAttribute("role");
        if (!"owner".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() +
                    "/views/owner/appointments.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(
                request.getParameter("appointmentId"));
        int employeeId = Integer.parseInt(
                request.getParameter("employeeId"));

        appointmentDAO.assignEmployee(appointmentId, employeeId);

        response.sendRedirect(request.getContextPath() +
                "/views/owner/appointments.jsp");
    }

    private void handleUpdateStatus(HttpServletRequest request,
                                    HttpServletResponse response,
                                    HttpSession session)
            throws IOException {

        String role = (String) session.getAttribute("role");
        if (!"owner".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() +
                    "/views/owner/appointments.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(
                request.getParameter("appointmentId"));
        String status = request.getParameter("status");

        appointmentDAO.updateStatus(appointmentId, status);

        response.sendRedirect(request.getContextPath() +
                "/views/owner/appointments.jsp");
    }
}
package controller;

import dao.StatsDAO;
import dao.ContactDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles admin dashboard — loads stats and reports data.
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private final StatsDAO statsDAO = new StatsDAO();
    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        try {
            switch (action) {
                case "dashboard":
                    request.setAttribute("totalAppointments", statsDAO.getTotalAppointments());
                    request.setAttribute("completedAppointments", statsDAO.getCompletedAppointments());
                    request.setAttribute("totalUsers", statsDAO.getTotalActiveUsers());
                    request.setAttribute("totalBusinesses", statsDAO.getTotalBusinesses());
                    request.setAttribute("totalRevenue", statsDAO.getTotalRevenue());
                    request.setAttribute("unreadInquiries", contactDAO.countUnread());
                    request.getRequestDispatcher("/views/admin/dashboard.jsp")
                           .forward(request, response);
                    break;

                case "reports":
                    request.setAttribute("popularServices", statsDAO.getPopularServices());
                    request.setAttribute("topEmployees", statsDAO.getTopEmployees());
                    request.setAttribute("appointmentsByStatus", statsDAO.getAppointmentsByStatus());
                    request.setAttribute("averageRatings", statsDAO.getAverageRatings());
                    request.setAttribute("last7Days", statsDAO.getAppointmentsLast7Days());
                    request.setAttribute("totalRevenue", statsDAO.getTotalRevenue());
                    request.getRequestDispatcher("/views/admin/reports.jsp")
                           .forward(request, response);
                    break;

                case "inquiries":
                    request.setAttribute("inquiries", contactDAO.getAllInquiries());
                    request.getRequestDispatcher("/views/admin/dashboard.jsp")
                           .forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data.");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
}

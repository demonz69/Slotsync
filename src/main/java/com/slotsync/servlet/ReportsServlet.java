package com.slotsync.servlet;

import com.slotsync.dao.StatsDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

public class ReportsServlet extends HttpServlet {

    private final StatsDAO dao = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            req.setAttribute("totalAppointments",     dao.getTotalAppointments());
            req.setAttribute("completedAppointments", dao.getCompletedAppointments());
            req.setAttribute("totalActiveUsers",      dao.getTotalActiveUsers());
            req.setAttribute("totalRevenue",          dao.getTotalRevenue());
            req.setAttribute("popularServices",       dao.getPopularServices());
            req.setAttribute("topEmployees",          dao.getTopEmployees());
            req.setAttribute("appointmentsByStatus",  dao.getAppointmentsByStatus());
            req.setAttribute("averageRatings",        dao.getAverageRatings());
            req.setAttribute("last7Days",             dao.getAppointmentsLast7Days());

            req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Failed to load reports: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }
}

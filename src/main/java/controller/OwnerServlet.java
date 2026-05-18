package controller;

import dao.BusinessDAO;
import dao.AppointmentDAO;
import dao.ServiceDAO;
import dao.EmployeeDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles owner dashboard data loading and owner-specific operations.
 */
@WebServlet("/owner")
public class OwnerServlet extends HttpServlet {

    private final BusinessDAO businessDAO = new BusinessDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"owner".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                // Load owner's business and today's appointments
                request.setAttribute("businesses",
                    businessDAO.getBusinessesByOwner(user.getUserId()));
                request.getRequestDispatcher("/views/owner/dashboard.jsp")
                       .forward(request, response);
                break;

            case "services":
                request.setAttribute("businesses",
                    businessDAO.getBusinessesByOwner(user.getUserId()));
                request.getRequestDispatcher("/views/owner/manage-services.jsp")
                       .forward(request, response);
                break;

            case "settings":
                request.setAttribute("businesses",
                    businessDAO.getBusinessesByOwner(user.getUserId()));
                request.getRequestDispatcher("/views/owner/settings.jsp")
                       .forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/owner?action=dashboard");
        }
    }
}

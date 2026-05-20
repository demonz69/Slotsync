package com.slotsync.servlet;

import dao.SearchDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final SearchDAO dao = new SearchDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String keyword = req.getParameter("q");
        String type    = req.getParameter("type");

        // Default type to services
        if (type == null || type.trim().isEmpty()) type = "services";

        req.setAttribute("type", type);
        req.setAttribute("keyword", keyword);

        // Only search if keyword is provided
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                switch (type) {
                    case "users":
                        req.setAttribute("results", dao.searchUsers(keyword));
                        break;
                    case "businesses":
                        req.setAttribute("results", dao.searchBusinesses(keyword));
                        break;
                    default:
                        req.setAttribute("results", dao.searchServices(keyword));
                        break;
                }
            } catch (SQLException e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/search.jsp").forward(req, resp);
    }
}

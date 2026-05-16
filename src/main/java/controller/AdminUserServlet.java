package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.UserDAO;
import model.User;

@WebServlet("/admin/user/*")
public class AdminUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Authorization check
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo(); // e.g., /activate, /deactivate, /delete
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/views/admin/manage-users.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/admin/manage-users.jsp");
            return;
        }

        int userId = Integer.parseInt(idParam);
        UserDAO dao = new UserDAO();
        String msg = "";

        if (pathInfo.equals("/activate")) {
            dao.updateStatus(userId, "active");
            msg = "activate";
        } else if (pathInfo.equals("/deactivate")) {
            dao.updateStatus(userId, "suspended");
            msg = "deactivate";
        } else if (pathInfo.equals("/delete")) {
            dao.deleteUser(userId);
            msg = "delete";
        }

        response.sendRedirect(request.getContextPath() + "/views/admin/manage-users.jsp?msg=" + msg);
    }
}

package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.BusinessDAO;
import model.User;

@WebServlet("/admin/business/*")
public class AdminBusinessServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Authorization check
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/views/admin/manage-businesses.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/admin/manage-businesses.jsp");
            return;
        }

        int businessId = Integer.parseInt(idParam);
        BusinessDAO dao = new BusinessDAO();
        String msg = "";

        if (pathInfo.equals("/approve")) {
            dao.updateStatus(businessId, "active");
            msg = "approve";
        } else if (pathInfo.equals("/suspend")) {
            dao.updateStatus(businessId, "suspended");
            msg = "suspend";
        } else if (pathInfo.equals("/reject")) {
            dao.deleteBusiness(businessId);
            msg = "reject";
        }

        response.sendRedirect(request.getContextPath() + "/views/admin/manage-businesses.jsp?msg=" + msg);
    }
}

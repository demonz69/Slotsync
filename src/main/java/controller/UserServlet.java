package com.slotsync.servlet;

import com.slotsync.dao.UserDAO;
import com.slotsync.model.User;
import com.slotsync.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/client/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String phone   = request.getParameter("phone");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Name cannot be empty.");
            doGet(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            doGet(request, response);
            return;
        }

        User user = new User();
        user.setUserId(userId);
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            session.setAttribute("userName", name.trim());
            session.setAttribute("userEmail", email.trim());
            request.setAttribute("success", "Profile updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update profile. Please try again.");
        }

        doGet(request, response);
    }
}
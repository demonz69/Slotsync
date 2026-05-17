package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Encrypt password before checking
        String encryptedPassword = PasswordUtil.encryptPassword(password);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(email, encryptedPassword);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Role-based redirect
            if (user.getRole().equals("admin")) {
                response.sendRedirect("views/admin/dashboard.jsp");
            } else if (user.getRole().equals("employee")) {
                response.sendRedirect("views/user/home.jsp");
            } else {
                response.sendRedirect("views/user/home.jsp");
            }

        } else {
            request.setAttribute("error", "Invalid email or password");
            RequestDispatcher rd = request.getRequestDispatcher("views/auth/login.jsp");
            rd.forward(request, response);
        }
    }
}
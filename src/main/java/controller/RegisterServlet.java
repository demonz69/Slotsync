package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import util.ValidationUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "client"; // default role

        // VALIDATION
        if (!ValidationUtil.isValidName(fullName)) {
            request.setAttribute("error", "Invalid name (only letters allowed)");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // DUPLICATE CHECK
        if (dao.isEmailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        // ENCRYPT PASSWORD
        String encryptedPassword = PasswordUtil.encryptPassword(password);

        // Create user object
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(encryptedPassword);
        user.setRole(role);

        // SAVE USER
        boolean success = dao.register(user);

        if (success) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
        }
    }
}
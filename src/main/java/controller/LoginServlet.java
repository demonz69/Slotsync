package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.BusinessDAO;
import dao.UserDAO;
import model.Business;
import model.User;
import util.PasswordUtil;
import java.util.List;

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
            session.setAttribute("user",   user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role",   user.getRole());

            // Cache businessId in session for owner accounts
            if ("owner".equals(user.getRole())) {
                List<Business> biz = new BusinessDAO().getBusinessesByOwner(user.getUserId());
                if (!biz.isEmpty()) {
                    session.setAttribute("businessId", biz.get(0).getBusinessId());
                }
            }

            // Remember Me Cookies
            String remember = request.getParameter("remember");
            if ("true".equals(remember)) {
                Cookie emailCookie = new Cookie("slotsync_email", email);
                emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                response.addCookie(emailCookie);

                Cookie pwdCookie = new Cookie("slotsync_pwd", password);
                pwdCookie.setMaxAge(30 * 24 * 60 * 60);
                response.addCookie(pwdCookie);
            } else {
                Cookie emailCookie = new Cookie("slotsync_email", "");
                emailCookie.setMaxAge(0);
                response.addCookie(emailCookie);

                Cookie pwdCookie = new Cookie("slotsync_pwd", "");
                pwdCookie.setMaxAge(0);
                response.addCookie(pwdCookie);
            }

            // Role-based redirect
            switch (user.getRole()) {
                case "admin":    response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");    break;
                case "owner":    response.sendRedirect(request.getContextPath() + "/views/owner/dashboard.jsp");    break;
                case "employee": response.sendRedirect(request.getContextPath() + "/views/employee/schedule.jsp");  break;
                default:         response.sendRedirect(request.getContextPath() + "/views/client/home.jsp");        break;
            }

        } else {
            request.setAttribute("error", "Invalid email or password");
            RequestDispatcher rd = request.getRequestDispatcher("views/auth/login.jsp");
            rd.forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Cookie[] cookies = request.getCookies();
        String savedEmail = null;
        String savedPwd = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("slotsync_email".equals(cookie.getName())) {
                    savedEmail = cookie.getValue();
                }
                if ("slotsync_pwd".equals(cookie.getName())) {
                    savedPwd = cookie.getValue();
                }
            }
        }
        
        if (savedEmail != null && savedPwd != null && !savedEmail.isEmpty()) {
            UserDAO userDAO = new UserDAO();
            String encryptedPassword = PasswordUtil.encryptPassword(savedPwd);
            User user = userDAO.login(savedEmail, encryptedPassword);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user",   user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role",   user.getRole());
                switch (user.getRole()) {
                    case "admin":    response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");   break;
                    case "owner":    response.sendRedirect(request.getContextPath() + "/views/owner/dashboard.jsp");   break;
                    case "employee": response.sendRedirect(request.getContextPath() + "/views/employee/schedule.jsp"); break;
                    default:         response.sendRedirect(request.getContextPath() + "/views/client/home.jsp");       break;
                }
                return;
            }
        }

        RequestDispatcher rd = request.getRequestDispatcher("views/auth/login.jsp");
        rd.forward(request, response);
    }
}
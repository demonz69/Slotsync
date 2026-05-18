package controller;

import dao.UserDAO;
import dao.AppointmentDAO;
import dao.WishlistDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles client user portal — profile, bookings, wishlist.
 */
@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) action = "profile";

        switch (action) {
            case "profile":
                request.setAttribute("userProfile", user);
                request.getRequestDispatcher("/views/client/profile.jsp")
                       .forward(request, response);
                break;

            case "bookings":
                request.setAttribute("bookings",
                    appointmentDAO.getAppointmentsByUser(user.getUserId()));
                request.getRequestDispatcher("/views/client/bookings.jsp")
                       .forward(request, response);
                break;

            case "wishlist":
                request.setAttribute("wishlist",
                    wishlistDAO.getByClientId(user.getUserId()));
                request.getRequestDispatcher("/views/client/wishlist.jsp")
                       .forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/user?action=profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        switch (action) {
            case "updateProfile":
                String fullName = request.getParameter("fullName");
                String phone    = request.getParameter("phone");

                user.setFullName(fullName);
                user.setPhone(phone);

                if (userDAO.updateUser(user)) {
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() +
                        "/user?action=profile&success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/user?action=profile&error=update_failed");
                }
                break;

            case "addWishlist":
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                wishlistDAO.addToWishlist(user.getUserId(), serviceId);
                response.sendRedirect(request.getContextPath() +
                    "/user?action=wishlist&success=added");
                break;

            case "removeWishlist":
                int removeId = Integer.parseInt(request.getParameter("serviceId"));
                wishlistDAO.removeFromWishlist(user.getUserId(), removeId);
                response.sendRedirect(request.getContextPath() +
                    "/user?action=wishlist&success=removed");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/user?action=profile");
        }
    }
}

package controller;

import dao.FeedbackDAO;
import dao.AppointmentDAO;
import model.Feedback;
import model.Appointment;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles feedback submission for completed appointments.
 */
@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        // Only clients can submit feedback
        if (!"client".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating range
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Rating must be between 1 and 5.");
                response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?error=invalid_rating");
                return;
            }

            // Check if feedback already exists
            if (feedbackDAO.hasFeedback(appointmentId)) {
                response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?error=already_reviewed");
                return;
            }

            Feedback feedback = new Feedback();
            feedback.setAppointmentId(appointmentId);
            feedback.setClientId(user.getUserId());
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment.trim() : "");

            if (feedbackDAO.submitFeedback(feedback)) {
                response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?success=feedback_submitted");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?error=feedback_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?error=invalid_input");
        }
    }
}

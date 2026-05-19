package com.slotsync.servlet;

import com.slotsync.dao.FeedbackDAO;
import com.slotsync.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String apptIdStr = request.getParameter("appointmentId");
        if (apptIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/views/client/home.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(apptIdStr);
        int clientId = (int) session.getAttribute("userId");

        if (feedbackDAO.hasFeedback(appointmentId, clientId)) {
            request.setAttribute("error", "You have already submitted feedback for this appointment.");
        }

        request.setAttribute("appointmentId", appointmentId);
        request.getRequestDispatcher("/views/client/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int clientId = (int) session.getAttribute("userId");

        String apptIdStr = request.getParameter("appointmentId");
        String bizIdStr  = request.getParameter("businessId");
        String ratingStr = request.getParameter("rating");
        String comment   = request.getParameter("comment");

        if (apptIdStr == null || bizIdStr == null || ratingStr == null) {
            request.setAttribute("error", "Missing required fields.");
            request.getRequestDispatcher("/views/client/feedback.jsp").forward(request, response);
            return;
        }

        int appointmentId = Integer.parseInt(apptIdStr);
        int businessId    = Integer.parseInt(bizIdStr);
        int rating        = Integer.parseInt(ratingStr);

        if (rating < 1 || rating > 5) {
            request.setAttribute("error", "Rating must be between 1 and 5.");
            request.setAttribute("appointmentId", appointmentId);
            request.getRequestDispatcher("/views/client/feedback.jsp").forward(request, response);
            return;
        }

        if (feedbackDAO.hasFeedback(appointmentId, clientId)) {
            request.setAttribute("error", "You have already submitted feedback for this appointment.");
            request.setAttribute("appointmentId", appointmentId);
            request.getRequestDispatcher("/views/client/feedback.jsp").forward(request, response);
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setAppointmentId(appointmentId);
        feedback.setClientId(clientId);
        feedback.setBusinessId(businessId);
        feedback.setRating(rating);
        feedback.setComment(comment != null ? comment.trim() : "");

        boolean saved = feedbackDAO.addFeedback(feedback);

        if (saved) {
            response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp?feedbackSuccess=1");
        } else {
            request.setAttribute("error", "Failed to submit feedback. Please try again.");
            request.setAttribute("appointmentId", appointmentId);
            request.getRequestDispatcher("/views/client/feedback.jsp").forward(request, response);
        }
    }
}
package controller;

import dao.ContactDAO;
import model.ContactInquiry;
import util.ValidationUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles contact form submissions from the public contact page.
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String subject  = request.getParameter("subject");
        String message  = request.getParameter("message");

        // Validate inputs
        if (!ValidationUtil.isValidName(fullName)) {
            request.setAttribute("error", "Please enter a valid name (letters and spaces only).");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }

        if (subject == null || subject.trim().isEmpty()) {
            request.setAttribute("error", "Subject is required.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }

        if (message == null || message.trim().length() < 10) {
            request.setAttribute("error", "Message must be at least 10 characters long.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }

        ContactInquiry inquiry = new ContactInquiry(fullName.trim(), email.trim(),
                                                     subject.trim(), message.trim());

        if (contactDAO.submitInquiry(inquiry)) {
            request.setAttribute("success", "Thank you! Your message has been submitted successfully.");
        } else {
            request.setAttribute("error", "Something went wrong. Please try again later.");
        }

        request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
    }
}

package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import dao.ContactDAO;
import model.ContactInquiry;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    // GET /contact → show the contact form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/contact.jsp").forward(request, response);
    }

    // POST /contact → save the submitted inquiry
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Basic validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {

            request.setAttribute("error", "Name, email, and message are required.");
            request.getRequestDispatcher("views/contact.jsp").forward(request, response);
            return;
        }

        // Build inquiry object
        ContactInquiry inquiry = new ContactInquiry();
        inquiry.setName(name.trim());
        inquiry.setEmail(email.trim());
        inquiry.setSubject(subject != null ? subject.trim() : "General Inquiry");
        inquiry.setMessage(message.trim());

        // Save to DB
        ContactDAO dao = new ContactDAO();
        boolean saved = dao.saveInquiry(inquiry);

        if (saved) {
            request.setAttribute("success", "Thank you! Your message has been sent.");
        } else {
            request.setAttribute("error", "Something went wrong. Please try again.");
        }

        request.getRequestDispatcher("views/contact.jsp").forward(request, response);
    }
}

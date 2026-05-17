package controller;

import dao.EmployeeDAO;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {

    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"owner".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                handleAdd(request, response, session);
                break;
            case "remove":
                handleRemove(request, response, session);
                break;
            default:
                response.sendRedirect(request.getContextPath() +
                    "/views/owner/manage-employees.jsp");
        }
    }

    private void handleAdd(HttpServletRequest request,
                           HttpServletResponse response,
                           HttpSession session)
            throws IOException {
        try {
            int    userId      = Integer.parseInt(
                                     request.getParameter("userId"));
            int    businessId  = Integer.parseInt(
                                     request.getParameter("businessId"));
            String designation =
                request.getParameter("designation").trim();
            String phone       =
                request.getParameter("phone").trim();

            if (designation.isEmpty() || phone.isEmpty()) {
                session.setAttribute("errorMsg",
                                     "All fields are required.");
                response.sendRedirect(request.getContextPath() +
                    "/views/owner/manage-employees.jsp");
                return;
            }

            Employee emp = new Employee();
            emp.setUserId(userId);
            emp.setBusinessId(businessId);
            emp.setDesignation(designation);
            emp.setPhone(phone);
            emp.setStatus("active");

            boolean success = employeeDAO.addEmployee(emp);
            session.setAttribute(
                success ? "successMsg" : "errorMsg",
                success ? "Employee added successfully."
                        : "Failed. Check User ID.");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid User ID.");
        }
        response.sendRedirect(request.getContextPath() +
            "/views/owner/manage-employees.jsp");
    }

    private void handleRemove(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws IOException {
        try {
            int employeeId = Integer.parseInt(
                                 request.getParameter("employeeId"));
            boolean success = employeeDAO.delete(employeeId);
            session.setAttribute(
                success ? "successMsg" : "errorMsg",
                success ? "Employee removed successfully."
                        : "Failed to remove employee.");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid employee ID.");
        }
        response.sendRedirect(request.getContextPath() +
            "/views/owner/manage-employees.jsp");
    }
}
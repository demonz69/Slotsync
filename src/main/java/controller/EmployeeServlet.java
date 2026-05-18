package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import dao.EmployeeDAO;
import model.Employee;

@WebServlet("/employee")
public class EmployeeServlet extends HttpServlet {

    // GET /employee?action=list&businessId=X → list employees for a business
    // GET /employee?action=view&id=X          → view a single employee
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        EmployeeDAO dao = new EmployeeDAO();

        switch (action) {

            case "view": {
                int employeeId = Integer.parseInt(request.getParameter("id"));
                Employee emp = dao.getEmployeeById(employeeId);
                request.setAttribute("employee", emp);
                request.getRequestDispatcher("views/employee/profile.jsp").forward(request, response);
                break;
            }

            case "list":
            default: {
                String bizIdParam = request.getParameter("businessId");
                List<Employee> employees;

                if (bizIdParam != null && !bizIdParam.isEmpty()) {
                    int businessId = Integer.parseInt(bizIdParam);
                    employees = dao.getEmployeesByBusiness(businessId);
                } else {
                    employees = dao.getAllEmployees();
                }

                request.setAttribute("employees", employees);
                request.getRequestDispatcher("views/employee/schedule.jsp").forward(request, response);
                break;
            }
        }
    }

    // POST /employee?action=add    → add a new employee
    // POST /employee?action=update → update employee details
    // POST /employee?action=delete → delete an employee
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        EmployeeDAO dao = new EmployeeDAO();

        switch (action) {

            case "add": {
                Employee emp = new Employee();
                emp.setUserId(Integer.parseInt(request.getParameter("userId")));
                emp.setBusinessId(Integer.parseInt(request.getParameter("businessId")));
                emp.setPosition(request.getParameter("position"));
                emp.setStatus("active");

                boolean added = dao.addEmployee(emp);

                if (added) {
                    request.setAttribute("success", "Employee added successfully.");
                } else {
                    request.setAttribute("error", "Failed to add employee. Please try again.");
                }

                response.sendRedirect(request.getContextPath() + "/employee?action=list");
                break;
            }

            case "update": {
                Employee emp = new Employee();
                emp.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
                emp.setPosition(request.getParameter("position"));
                emp.setStatus(request.getParameter("status"));

                boolean updated = dao.updateEmployee(emp);

                if (updated) {
                    request.setAttribute("success", "Employee updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update employee.");
                }

                response.sendRedirect(request.getContextPath() + "/employee?action=list");
                break;
            }

            case "delete": {
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                dao.deleteEmployee(employeeId);
                response.sendRedirect(request.getContextPath() + "/employee?action=list");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/employee?action=list");
                break;
        }
    }
}

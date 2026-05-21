package controller;

import dao.AvailabilityDAO;
import dao.EmployeeDAO;
import dao.UserDAO;
import model.Availability;
import model.Employee;
import model.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/EmployeeServlet", "/employee"})
public class EmployeeServlet extends HttpServlet {

    private final EmployeeDAO    employeeDAO    = new EmployeeDAO();
    private final AvailabilityDAO availDAO      = new AvailabilityDAO();
    private final UserDAO        userDAO        = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if ("employee".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/views/employee/schedule.jsp");
        } else if ("owner".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/views/owner/manage-employees.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String role   = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            // ── Owner actions ──────────────────────────────────────────────
            case "add":
                handleAdd(request, response, session);
                break;
            case "remove":
                handleRemove(request, response, session);
                break;

            // ── Employee self-service actions ──────────────────────────────
            case "saveAvailability":
                handleSaveAvailability(request, response, session);
                break;
            case "updateProfile":
                handleUpdateProfile(request, response, session);
                break;
            case "changePassword":
                handleChangePassword(request, response, session);
                break;

            default:
                response.sendRedirect(request.getContextPath() +
                    ("employee".equals(role)
                        ? "/views/employee/schedule.jsp"
                        : "/views/owner/manage-employees.jsp"));
        }
    }

    // Add new employee
    private void handleAdd(HttpServletRequest request,
                           HttpServletResponse response,
                           HttpSession session)
            throws IOException {

        try {
            int    userId      = Integer.parseInt(request.getParameter("userId"));
            int    businessId  = Integer.parseInt(request.getParameter("businessId"));
            String designation = request.getParameter("designation").trim();
            String phone       = request.getParameter("phone").trim();

            // Validation
            if (designation.isEmpty() || phone.isEmpty()) {
                session.setAttribute("errorMsg", "All fields are required.");
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

            if (success) {
                session.setAttribute("successMsg",
                                     "Employee added successfully.");
            } else {
                session.setAttribute("errorMsg",
                                     "Failed to add employee. Check User ID.");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid User ID.");
        }

        response.sendRedirect(request.getContextPath() +
                              "/views/owner/manage-employees.jsp");
    }

    // Remove employee (soft delete)
    private void handleRemove(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session)
            throws IOException {

        try {
            int employeeId = Integer.parseInt(
                                 request.getParameter("employeeId"));

            boolean success = employeeDAO.delete(employeeId);

            if (success) {
                session.setAttribute("successMsg",
                                     "Employee removed successfully.");
            } else {
                session.setAttribute("errorMsg",
                                     "Failed to remove employee.");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Invalid employee ID.");
        }

        response.sendRedirect(request.getContextPath() +
                              "/views/owner/manage-employees.jsp");
    }

    // ── Employee: save weekly availability ────────────────────────────────────
    private void handleSaveAvailability(HttpServletRequest request,
                                        HttpServletResponse response,
                                        HttpSession session)
            throws IOException {

        int userId = (int) session.getAttribute("userId");
        Employee emp = employeeDAO.getByUserId(userId);
        if (emp == null) {
            session.setAttribute("availError", "Employee record not found.");
            response.sendRedirect(request.getContextPath() + "/views/employee/availability.jsp");
            return;
        }

        // day_of_week in DB: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
        String[] dayKeys = {"sun","mon","tue","wed","thu","fri","sat"};

        for (int i = 0; i < dayKeys.length; i++) {
            String key      = dayKeys[i];
            boolean checked = request.getParameter("avail_" + key) != null;
            String start    = request.getParameter("start_" + key);
            String end      = request.getParameter("end_"   + key);
            if (start == null || start.isEmpty()) start = "09:00";
            if (end   == null || end.isEmpty())   end   = "17:00";

            Availability av = new Availability();
            av.setEmployeeId(emp.getEmployeeId());
            av.setBusinessId(emp.getBusinessId());
            av.setDayOfWeek(String.valueOf(i));   // 0–6 stored as string
            av.setStartTime(start);
            av.setEndTime(end);
            av.setSlotDuration(30);
            availDAO.set(av);
        }

        session.setAttribute("availSuccess", "Availability saved successfully.");
        response.sendRedirect(request.getContextPath() + "/views/employee/availability.jsp");
    }

    // ── Employee: update own profile ──────────────────────────────────────────
    private void handleUpdateProfile(HttpServletRequest request,
                                     HttpServletResponse response,
                                     HttpSession session)
            throws IOException {

        User user = (User) session.getAttribute("user");
        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("profileError", "Name cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
            return;
        }

        user.setFullName(fullName.trim());
        if (phone != null && !phone.trim().isEmpty()) user.setPhone(phone.trim());

        if (userDAO.updateUser(user)) {
            session.setAttribute("user", user);
            session.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            session.setAttribute("profileError", "Failed to update profile.");
        }
        response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
    }

    // ── Employee: change password ─────────────────────────────────────────────
    private void handleChangePassword(HttpServletRequest request,
                                      HttpServletResponse response,
                                      HttpSession session)
            throws IOException {

        User user        = (User) session.getAttribute("user");
        String current   = request.getParameter("currentPassword");
        String newPw     = request.getParameter("newPassword");
        String confirm   = request.getParameter("confirmPassword");

        String currentHash = PasswordUtil.encryptPassword(current != null ? current : "");
        if (!currentHash.equals(user.getPassword())) {
            session.setAttribute("pwError", "Current password is incorrect.");
            response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
            return;
        }
        if (newPw == null || newPw.length() < 6) {
            session.setAttribute("pwError", "New password must be at least 6 characters.");
            response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
            return;
        }
        if (!newPw.equals(confirm)) {
            session.setAttribute("pwError", "Passwords do not match.");
            response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
            return;
        }

        String newHash = PasswordUtil.encryptPassword(newPw);
        if (userDAO.updatePassword(user.getUserId(), newHash)) {
            user.setPassword(newHash);
            session.setAttribute("user", user);
            session.setAttribute("pwSuccess", "Password changed successfully.");
        } else {
            session.setAttribute("pwError", "Failed to change password.");
        }
        response.sendRedirect(request.getContextPath() + "/views/employee/profile.jsp");
    }
}
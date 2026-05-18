package controller;

import dao.ServiceDAO;
import model.Service;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Handles service CRUD operations for admin and owner roles.
 * Adapted from Siddhant's branch — repackaged from com.slotsync.servlet to controller.
 */
@WebServlet("/services")
public class ServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                if ("admin".equals(role)) {
                    request.setAttribute("services", serviceDAO.getAllServices());
                    request.getRequestDispatcher("/views/admin/manage-services.jsp")
                           .forward(request, response);
                } else if ("owner".equals(role)) {
                    User user = (User) session.getAttribute("user");
                    // Owner sees only their own business services
                    request.setAttribute("services", serviceDAO.getAllServices());
                    request.getRequestDispatcher("/views/owner/manage-services.jsp")
                           .forward(request, response);
                }
                break;

            case "edit":
                try {
                    int serviceId = Integer.parseInt(request.getParameter("id"));
                    Service service = serviceDAO.getServiceById(serviceId);
                    request.setAttribute("service", service);
                    if ("admin".equals(role)) {
                        request.getRequestDispatcher("/views/admin/manage-services.jsp")
                               .forward(request, response);
                    } else {
                        request.getRequestDispatcher("/views/owner/manage-services.jsp")
                               .forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/services?action=list");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/services?action=list");
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

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    Service newService = new Service();
                    newService.setBusinessId(Integer.parseInt(request.getParameter("businessId")));
                    newService.setServiceName(request.getParameter("serviceName"));
                    newService.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                    newService.setDurationMin(Integer.parseInt(request.getParameter("durationMin")));
                    newService.setPrice(Double.parseDouble(request.getParameter("price")));
                    newService.setDescription(request.getParameter("description"));
                    newService.setActive(true);

                    if (serviceDAO.createService(newService)) {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&success=created");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&error=create_failed");
                    }
                    break;

                case "update":
                    Service updService = new Service();
                    updService.setServiceId(Integer.parseInt(request.getParameter("serviceId")));
                    updService.setServiceName(request.getParameter("serviceName"));
                    updService.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                    updService.setDurationMin(Integer.parseInt(request.getParameter("durationMin")));
                    updService.setPrice(Double.parseDouble(request.getParameter("price")));
                    updService.setDescription(request.getParameter("description"));

                    if (serviceDAO.updateService(updService)) {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&success=updated");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&error=update_failed");
                    }
                    break;

                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("serviceId"));
                    if (serviceDAO.deleteService(deleteId)) {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&success=deleted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/services?action=list&error=delete_failed");
                    }
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/services?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services?action=list&error=invalid_input");
        }
    }
}

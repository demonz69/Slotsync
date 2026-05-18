package controller;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ServiceController")
public class ServiceController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        switch (action) {

            // Anyone can view services
            case "list":
                List<Service> services = serviceDAO.getAllServices();
                request.setAttribute("services", services);
                request.getRequestDispatcher("/WEB-INF/views/services.jsp").forward(request, response);
                break;

            // Admin: show form to add a new service
            case "addForm":
                if (!"admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/addService.jsp").forward(request, response);
                break;

            // Admin: show form to edit an existing service
            case "editForm":
                if (!"admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                Service service = serviceDAO.getServiceById(serviceId);
                request.setAttribute("service", service);
                request.getRequestDispatcher("/WEB-INF/views/editService.jsp").forward(request, response);
                break;

            // Admin: delete a service
            case "delete":
                if (!"admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
                int deleteId = Integer.parseInt(request.getParameter("serviceId"));
                serviceDAO.deleteService(deleteId);
                response.sendRedirect(request.getContextPath() +
                    "/ServiceController?action=list&msg=deleted");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        String name = request.getParameter("serviceName");
        String desc = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("durationMinutes"));

        switch (action) {

            // Admin: add a new service
            case "add": {
                Service service = new Service();
                service.setServiceName(name);
                service.setDescription(desc);
                service.setPrice(price);
                service.setDurationMinutes(duration);
                serviceDAO.addService(service);
                response.sendRedirect(request.getContextPath() +
                    "/ServiceController?action=list&msg=added");
                break;
            }

            // Admin: update an existing service
            case "update": {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                Service service = new Service();
                service.setServiceId(serviceId);
                service.setServiceName(name);
                service.setDescription(desc);
                service.setPrice(price);
                service.setDurationMinutes(duration);
                serviceDAO.updateService(service);
                response.sendRedirect(request.getContextPath() +
                    "/ServiceController?action=list&msg=updated");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
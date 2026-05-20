package com.slotsync.servlet;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/services")
public class ServiceServlet extends HttpServlet {

    private final ServiceDAO dao = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deleteService(id);
                resp.sendRedirect(req.getContextPath() + "/admin/services?msg=deleted");
                return;
            }

            if ("toggle".equals(action)) {
                int id     = Integer.parseInt(req.getParameter("id"));
                boolean on = Boolean.parseBoolean(req.getParameter("active"));
                dao.toggleActive(id, on);
                resp.sendRedirect(req.getContextPath() + "/admin/services?msg=updated");
                return;
            }

            // Default: load all services and show page
            List<Service> services = dao.getAllServices();
            req.setAttribute("services", services);

            String msg = req.getParameter("msg");
            if (msg != null) req.setAttribute("msg", msg);

            req.getRequestDispatcher("/WEB-INF/views/admin/manageServices.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        try {
            String name     = req.getParameter("serviceName") == null ? "" : req.getParameter("serviceName").trim();
            String catStr   = req.getParameter("categoryId");
            String durStr   = req.getParameter("durationMin");
            String priceStr = req.getParameter("price");
            String desc     = req.getParameter("description");

            // Basic validation
            if (name.isEmpty() || catStr == null || durStr == null || priceStr == null) {
                req.setAttribute("error", "All fields are required.");
                List<Service> services = dao.getAllServices();
                req.setAttribute("services", services);
                req.getRequestDispatcher("/WEB-INF/views/admin/manageServices.jsp").forward(req, resp);
                return;
            }

            int    categoryId  = Integer.parseInt(catStr);
            int    durationMin = Integer.parseInt(durStr);
            double price       = Double.parseDouble(priceStr);

            // businessId — get from session, default to 1 if not set yet
            Object bizObj = session.getAttribute("businessId");
            int businessId = (bizObj != null) ? (int) bizObj : 1;

            Service s = new Service();
            s.setServiceName(name);
            s.setCategoryId(categoryId);
            s.setDurationMin(durationMin);
            s.setPrice(price);
            s.setDescription(desc);
            s.setBusinessId(businessId);
            s.setActive(true);

            if ("add".equals(action)) {
                dao.addService(s);
                resp.sendRedirect(req.getContextPath() + "/admin/services?msg=added");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("serviceId"));
                s.setServiceId(id);
                dao.updateService(s);
                resp.sendRedirect(req.getContextPath() + "/admin/services?msg=updated");

            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/services");
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid number in form. Please check your input.");
            List<Service> services = dao.getAllServices();
            req.setAttribute("services", services);
            req.getRequestDispatcher("/WEB-INF/views/admin/manageServices.jsp").forward(req, resp);
        }
    }
}

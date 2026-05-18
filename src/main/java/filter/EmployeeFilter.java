package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Filter to restrict /views/employee/* pages to users with the 'employee' role.
 */
@WebFilter("/views/employee/*")
public class EmployeeFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        boolean isEmployee = (session != null &&
                             "employee".equals(session.getAttribute("role")));

        if (isEmployee) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}

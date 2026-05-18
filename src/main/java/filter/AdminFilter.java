package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Filter to restrict /views/admin/* pages to users with the 'admin' role.
 */
@WebFilter("/views/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        boolean isAdmin = (session != null &&
                          "admin".equals(session.getAttribute("role")));

        if (isAdmin) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}

package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Filter to restrict /views/owner/* pages to users with the 'owner' role.
 */
@WebFilter("/views/owner/*")
public class OwnerFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        boolean isOwner = (session != null &&
                          "owner".equals(session.getAttribute("role")));

        if (isOwner) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}

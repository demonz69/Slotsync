package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebFilter("/views/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);

        String requestURI = request.getRequestURI();
        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean authRequest = requestURI.contains("/views/auth/");

        if (loggedIn || authRequest) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}
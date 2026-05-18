<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<footer class="footer" id="site-footer">
    <div class="container">

        <%-- ===== Top: Brand + Columns ===== --%>
        <div class="footer-inner">

            <%-- Brand + tagline (left) --%>
            <div style="max-width:280px">
                <a href="<%= ctx %>/" class="brand" id="footer-brand">
                    <div class="brand-mark"></div>
                    <span>SlotSync</span>
                </a>
                <p class="muted small" style="margin-top:12px; line-height:1.6">
                    Booking infrastructure for modern service businesses.
                </p>
            </div>

            <%-- Link columns (right) --%>
            <div class="footer-cols">

                <div class="footer-col">
                    <h4>Product</h4>
                    <a href="<%= ctx %>/views/auth/register.jsp" id="footer-browse">Browse</a>
                    <a href="<%= ctx %>/views/auth/register.jsp" id="footer-owners">For owners</a>
                    <a href="<%= ctx %>/views/auth/login.jsp"    id="footer-signin">Sign in</a>
                </div>

                <div class="footer-col">
                    <h4>Company</h4>
                    <a href="<%= ctx %>/views/about.jsp"   id="footer-about">About</a>
                    <a href="<%= ctx %>/contact"           id="footer-contact">Contact</a>
                </div>

                <div class="footer-col">
                    <h4>Legal</h4>
                    <a href="#" id="footer-privacy">Privacy</a>
                    <a href="#" id="footer-terms">Terms</a>
                </div>

            </div>
        </div>

        <%-- ===== Bottom bar ===== --%>
        <div class="footer-bottom">
            <span>&copy; 2026 SlotSync, Inc. All rights reserved.</span>
            <span class="mono">v1.4.0</span>
        </div>

    </div>
</footer>

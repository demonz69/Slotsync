<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%@ page import="java.util.List, model.Wishlist, model.User, dao.WishlistDAO" %>
<%
    User wlUser = (User) session.getAttribute("user");
    if (wlUser == null || !"client".equals(wlUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    // Load wishlist directly if not already set by servlet
    if (request.getAttribute("wishlist") == null) {
        request.setAttribute("wishlist", new WishlistDAO().getByClientId(wlUser.getUserId()));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />
<div class="container" style="padding-top:40px;padding-bottom:60px;max-width:980px">
    <div class="dash-head" style="margin-bottom:24px">
        <div>
            <h1 style="font-size:26px;font-weight:600;letter-spacing:-0.01em;margin:0 0 4px">My Wishlist</h1>
            <div class="muted small">Services you've saved for later</div>
        </div>
        <a href="<%= ctx %>/views/client/home.jsp" class="btn btn-secondary btn-sm">Browse services</a>
    </div>

    <c:if test="${param.success == 'removed'}">
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px">
        Service removed from your wishlist.
    </div>
    </c:if>

    <c:choose>
    <c:when test="${empty wishlist}">
        <div class="card" style="padding:60px 24px;text-align:center;color:var(--text-2)">
            <div style="font-size:14px;margin-bottom:16px">Your wishlist is empty. Browse services and save the ones you like!</div>
            <a href="<%= ctx %>/views/client/home.jsp" class="btn btn-primary">Browse services</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="wish-grid">
        <c:forEach var="item" items="${wishlist}">
            <div class="wish-card">
                <div class="wish-thumb">service preview</div>
                <div class="between">
                    <div>
                        <div style="font-weight:600">${item.serviceName}</div>
                        <div class="muted tiny" style="margin-top:2px">Saved on ${item.addedAt}</div>
                    </div>
                </div>
                <div class="between" style="margin-top:12px">
                    <span class="mono" style="font-weight:600">&pound;<fmt:formatNumber value="${item.servicePrice}" pattern="#,##0.00"/></span>
                    <div class="row gap-2">
                        <a href="<%= ctx %>/views/client/booking.jsp?step=2&serviceId=${item.serviceId}"
                           class="btn btn-primary btn-sm">Book</a>
                        <form method="post" action="<%= ctx %>/user" onsubmit="return confirm('Remove from wishlist?')" style="display:inline">
                            <input type="hidden" name="action"    value="removeWishlist">
                            <input type="hidden" name="serviceId" value="${item.serviceId}">
                            <button class="btn btn-secondary btn-sm" type="submit">Remove</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        </div>
    </c:otherwise>
    </c:choose>
</div>
<jsp:include page="/views/common/footer.jsp" />
</body>
</html>

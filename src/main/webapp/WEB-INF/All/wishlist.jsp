<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
  Integer clientId = (Integer) session.getAttribute("userId");
  String role = (String) session.getAttribute("role");
  if (clientId == null || !"client".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  String successMsg = null;
  String errorMsg = null;
  String action = request.getParameter("action");
  String svcParam = request.getParameter("serviceId");

  if ("remove".equals(action) && svcParam != null) {
    int serviceId = Integer.parseInt(svcParam);
    WishlistDAO removeDAO = new WishlistDAO();
    boolean ok = removeDAO.removeFromWishlist(clientId, serviceId);
    if (ok) successMsg = "Service removed from your wishlist.";
    else errorMsg = "Could not remove item. Please try again.";
  }

  WishlistDAO wishlistDAO = new WishlistDAO();
  List<Wishlist> wishlist = wishlistDAO.getByClientId(clientId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Wishlist - SlotSync</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
    .page-header { max-width: 860px; margin: 0 auto 24px; }
    .page-header h1 { margin: 0; }
    .page-header p { color: #888; margin: 4px 0 0; font-size: 0.9rem; }
    .alert { max-width: 860px; margin: 0 auto 16px; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
    .alert-success { background: #d8ede4; color: #1b5e3b; }
    .alert-error { background: #fdecea; color: #c0392b; }
    .grid { max-width: 860px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); gap: 16px; }
    .wl-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .wl-name { font-weight: 700; font-size: 1.05rem; margin-bottom: 4px; }
    .wl-date { font-size: 0.8rem; color: #888; }
    .wl-price { font-size: 1.15rem; font-weight: 700; color: #2D6A4F; margin: 10px 0; }
    .btn-row { display: flex; gap: 8px; margin-top: 10px; }
    .btn-book { flex: 1; background: #1a1714; color: #fff; border: none; padding: 10px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; text-align: center; text-decoration: none; }
    .btn-remove { background: transparent; border: 1.5px solid #ddd; color: #888; padding: 10px 14px; border-radius: 8px; font-size: 0.85rem; cursor: pointer; }
    .btn-remove:hover { border-color: #c0392b; color: #c0392b; }
    .empty { max-width: 860px; margin: 0 auto; background: #fff; border-radius: 12px; padding: 60px 20px; text-align: center; color: #888; }
    .empty p { margin-bottom: 16px; }
    .btn-browse { background: #1a1714; color: #fff; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; }
  </style>
</head>
<body>

<div class="page-header">
  <h1>My Wishlist</h1>
  <p>Services you have saved for later</p>
</div>

<% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>
<% if (errorMsg != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>

<% if (wishlist == null || wishlist.isEmpty()) { %>
<div class="empty">
  <p>Your wishlist is empty. Browse services and save the ones you like!</p>
  <a href="searchResults.jsp" class="btn-browse">Browse Services</a>
</div>
<% } else { %>
<div class="grid">
  <% for (Wishlist item : wishlist) { %>
  <div class="wl-card">
    <div class="wl-name"><%= item.getServiceName() %></div>
    <div class="wl-date">Saved on <%= item.getAddedDate() %></div>
    <div class="wl-price">£<%= String.format("%.2f", item.getServicePrice()) %></div>
    <div class="btn-row">
      <a href="booking.jsp?step=2&serviceId=<%= item.getServiceId() %>" class="btn-book">Book Now</a>
      <form method="get" action="wishlist.jsp" onsubmit="return confirm('Remove from wishlist?')">
        <input type="hidden" name="action" value="remove"/>
        <input type="hidden" name="serviceId" value="<%= item.getServiceId() %>"/>
        <button type="submit" class="btn-remove">Remove</button>
      </form>
    </div>
  </div>
  <% } %>
</div>
<% } %>

</body>
</html>

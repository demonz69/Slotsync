<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
  Integer clientId = (Integer) session.getAttribute("userId");
  String role = (String) session.getAttribute("role");
  boolean isClient = (clientId != null && "client".equals(role));

  String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
  String category = request.getParameter("category") != null ? request.getParameter("category").trim() : "";
  String maxPriceParam = request.getParameter("maxPrice");
  double maxPrice = (maxPriceParam != null && !maxPriceParam.isEmpty()) ? Double.parseDouble(maxPriceParam) : 0;

  SearchDAO searchDAO = new SearchDAO();
  List<Service> results = searchDAO.searchServices(keyword, category, maxPrice);
  List<String> categories = searchDAO.getAllCategories();

  Set<Integer> wishlistIds = new java.util.HashSet<>();
  if (isClient) {
    WishlistDAO wDao = new WishlistDAO();
    List<Wishlist> wl = wDao.getByClientId(clientId);
    for (Wishlist w : wl) wishlistIds.add(w.getServiceId());
  }

  String toastMsg = null;
  String wAction = request.getParameter("wAction");
  String wSvcParam = request.getParameter("wServiceId");

  if (isClient && wAction != null && wSvcParam != null) {
    int wSvcId = Integer.parseInt(wSvcParam);
    WishlistDAO toggleDAO = new WishlistDAO();
    if ("add".equals(wAction)) {
      toggleDAO.addToWishlist(clientId, wSvcId);
      toastMsg = "Added to wishlist!";
      wishlistIds.add(wSvcId);
    } else if ("remove".equals(wAction)) {
      toggleDAO.removeFromWishlist(clientId, wSvcId);
      toastMsg = "Removed from wishlist.";
      wishlistIds.remove(wSvcId);
    }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Search Services - SlotSync</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
    .page-header { max-width: 960px; margin: 0 auto 24px; }
    .page-header h1 { margin: 0; }
    .page-header p { color: #888; margin: 4px 0 0; font-size: 0.9rem; }
    .filter-bar { max-width: 960px; margin: 0 auto 24px; background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); display: flex; flex-wrap: wrap; gap: 12px; align-items: flex-end; }
    .filter-group { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 150px; }
    .filter-group label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; color: #888; }
    .filter-group input, .filter-group select { border: 1.5px solid #eee; border-radius: 8px; padding: 9px 12px; font-size: 0.9rem; outline: none; }
    .filter-group input:focus, .filter-group select:focus { border-color: #2D6A4F; }
    .btn-search { background: #1a1714; color: #fff; border: none; padding: 10px 24px; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; }
    .results-meta { max-width: 960px; margin: 0 auto 16px; font-size: 0.88rem; color: #888; }
    .grid { max-width: 960px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
    .svc-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .svc-cat { display: inline-block; background: #d8ede4; color: #1b5e3b; font-size: 0.72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; margin-bottom: 8px; }
    .svc-name { font-weight: 700; font-size: 1.05rem; margin-bottom: 4px; }
    .svc-meta { font-size: 0.83rem; color: #888; }
    .svc-price { font-size: 1.15rem; font-weight: 700; color: #2D6A4F; margin: 10px 0; }
    .btn-row { display: flex; gap: 8px; margin-top: 10px; }
    .btn-book { flex: 1; background: #1a1714; color: #fff; border: none; padding: 10px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; text-align: center; text-decoration: none; }
    .btn-wish { background: transparent; border: 1.5px solid #eee; color: #888; padding: 10px 14px; border-radius: 8px; font-size: 0.9rem; cursor: pointer; text-decoration: none; }
    .btn-wish.saved { border-color: #e05c5c; color: #e05c5c; }
    .empty { max-width: 960px; margin: 0 auto; background: #fff; border-radius: 12px; padding: 60px 20px; text-align: center; color: #888; }
    .toast { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); background: #1a1714; color: #fff; padding: 12px 24px; border-radius: 30px; font-size: 0.88rem; font-weight: 500; }
  </style>
</head>
<body>

<div class="page-header">
  <h1>Browse Services</h1>
  <p>Find the right service for you</p>
</div>

<form method="get" action="searchResults.jsp">
  <div class="filter-bar">
    <div class="filter-group">
      <label>Search</label>
      <input type="text" name="keyword" placeholder="e.g. haircut, massage" value="<%= keyword %>"/>
    </div>
    <div class="filter-group">
      <label>Category</label>
      <select name="category">
        <option value="">All Categories</option>
        <% for (String cat : categories) { %>
        <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>><%= cat %></option>
        <% } %>
      </select>
    </div>
    <div class="filter-group" style="max-width:130px">
      <label>Max Price (&pound;)</label>
      <input type="number" name="maxPrice" placeholder="Any" min="0" step="0.01" value="<%= maxPrice > 0 ? maxPrice : "" %>"/>
    </div>
    <button type="submit" class="btn-search">Search</button>
  </div>
</form>

<div class="results-meta">
  Showing <strong><%= results.size() %></strong> service<%= results.size() != 1 ? "s" : "" %>
  <% if (!keyword.isEmpty()) { %> for "<strong><%= keyword %></strong>"<% } %>
  <% if (!category.isEmpty()) { %> in <strong><%= category %></strong><% } %>
</div>

<% if (results == null || results.isEmpty()) { %>
<div class="empty">No services matched your search. Try different keywords or remove filters.</div>
<% } else { %>
<div class="grid">
  <% for (Service svc : results) {
    boolean saved = wishlistIds.contains(svc.getServiceId()); %>
  <div class="svc-card">
    <span class="svc-cat"><%= svc.getCategory() %></span>
    <div class="svc-name"><%= svc.getServiceName() %></div>
    <div class="svc-meta"><%= svc.getDuration() %> min</div>
    <div class="svc-price">&pound;<%= String.format("%.2f", svc.getPrice()) %></div>
    <div class="btn-row">
      <% if (isClient) { %>
      <a href="booking.jsp?step=2&serviceId=<%= svc.getServiceId() %>" class="btn-book">Book Now</a>
      <a href="searchResults.jsp?keyword=<%= keyword %>&category=<%= category %>&maxPrice=<%= maxPrice > 0 ? maxPrice : "" %>&wAction=<%= saved ? "remove" : "add" %>&wServiceId=<%= svc.getServiceId() %>"
         class="btn-wish <%= saved ? "saved" : "" %>"><%= saved ? "ΓÖÑ" : "ΓÖí" %></a>
      <% } else { %>
      <a href="login.jsp" class="btn-book">Login to Book</a>
      <% } %>
    </div>
  </div>
  <% } %>
</div>
<% } %>

<% if (toastMsg != null) { %>
<div class="toast"><%= toastMsg %></div>
<% } %>

</body>
</html>

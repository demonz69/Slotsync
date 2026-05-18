<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    ╔══════════════════════════════════════════════════════════════════════╗
    ║  SHARED HEADER FRAGMENT — include at the TOP of every public page   ║
    ║                                                                      ║
    ║  Parameters (set as request attributes BEFORE including):           ║
    ║    pageTitle   (String) — <title> text, default "SlotSync"          ║
    ║    pageDesc    (String) — meta description                          ║
    ║    extraCss    (String) — optional extra <link> or <style> tag      ║
    ╚══════════════════════════════════════════════════════════════════════╝
--%>
<%
    String ctx      = request.getContextPath();
    String pgTitle  = (String) request.getAttribute("pageTitle");
    String pgDesc   = (String) request.getAttribute("pageDesc");
    String extraCss = (String) request.getAttribute("extraCss");

    if (pgTitle == null || pgTitle.isEmpty())
        pgTitle = "SlotSync | Modern Appointment Booking";
    if (pgDesc == null || pgDesc.isEmpty())
        pgDesc = "SlotSync — Booking infrastructure for modern service businesses.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<%= pgDesc %>">
    <title><%= pgTitle %></title>

    <!-- Shared stylesheet -->
    <link rel="stylesheet" href="<%= ctx %>/css/style.css?v=2">

    <!-- Optional page-specific CSS injected by the including page -->
    <% if (extraCss != null && !extraCss.isEmpty()) { %>
        <%= extraCss %>
    <% } %>
</head>
<body>

<%-- ===== Shared Navbar ===== --%>
<jsp:include page="/views/common/navbar.jsp" />

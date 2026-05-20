<%@ page language="java" %>
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    String pageDesc  = (String) request.getAttribute("pageDesc");
    if (pageTitle == null) pageTitle = "SlotSync";
    if (pageDesc  == null) pageDesc  = "Book appointments with local service businesses.";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<%= pageDesc %>">
    <title><%= pageTitle %></title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />

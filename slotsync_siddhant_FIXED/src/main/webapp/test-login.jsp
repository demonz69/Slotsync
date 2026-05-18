<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // FAKE LOGIN FOR TESTING ONLY - REMOVE BEFORE FINAL SUBMISSION
    session.setAttribute("userId", 1);
    session.setAttribute("role", "admin");
    session.setAttribute("businessId", 1);
    session.setAttribute("fullName", "Test Admin");
    response.sendRedirect(request.getContextPath() + "/admin/services");
%>

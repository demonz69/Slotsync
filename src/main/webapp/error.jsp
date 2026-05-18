<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:#f5f7fa;">
    <div style="text-align:center;max-width:400px;">
        <div style="font-size:48px;color:#0d9488;margin-bottom:12px;">&#9888;</div>
        <h2 style="margin-bottom:8px;">Something went wrong</h2>
        <p style="color:#64748b;margin-bottom:20px;">
            ${not empty error ? error : 'An unexpected error occurred. Please try again.'}
        </p>
        <a href="${pageContext.request.contextPath}/admin/services"
           style="display:inline-block;padding:9px 20px;background:#0d9488;color:#fff;border-radius:6px;text-decoration:none;font-size:13px;">
            Go back to Services
        </a>
    </div>
</body>
</html>

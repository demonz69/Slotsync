<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - SlotSync</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f7fa; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .card { background: #fff; border: 1px solid #e2e8f0; border-radius: 10px; padding: 36px; width: 360px; text-align: center; }
        .brand { font-size: 22px; font-weight: 700; color: #0d9488; margin-bottom: 6px; }
        .sub { color: #64748b; font-size: 13px; margin-bottom: 24px; }
        .btn { display: block; width: 100%; padding: 10px; background: #0d9488; color: #fff; border: none; border-radius: 6px; font-size: 14px; cursor: pointer; text-decoration: none; margin-top: 10px; }
        .btn:hover { background: #0f766e; }
        .note { margin-top: 16px; font-size: 11px; color: #94a3b8; }
    </style>
</head>
<body>
    <div class="card">
        <div class="brand">SlotSync</div>
        <div class="sub">Smart Scheduling Platform</div>
        <p style="font-size:13px;color:#475569;margin-bottom:20px;">
            Login page is handled by another team member.<br>
            Click below to test with a fake admin session.
        </p>
        <a href="${pageContext.request.contextPath}/test-login.jsp" class="btn">
            Test as Admin (Bypass Login)
        </a>
        <div class="note">⚠ Remove test-login.jsp before final submission</div>
    </div>
</body>
</html>

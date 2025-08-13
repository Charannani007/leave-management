<%@ page import="java.net.URLEncoder" %>
<html>
<head>
    <title>Add Employee</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f9f9fb; padding: 40px 0; }
        .top-bar { position: absolute; top: 20px; right: 30px; }
        .home-btn {
            background: #23395d; color: #fff; border: none; padding: 7px 18px; font-size: 1rem;
            border-radius: 6px; text-decoration: none; font-weight: 500; box-shadow: 0 1px 4px #0001;
            transition: background 0.2s; cursor: pointer;
        }
        .home-btn:hover { background: #3d5a80; }
        .form-container { max-width: 400px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 10px #0001; padding: 32px; }
        h2 { text-align: center; color: #23395d; }
        input[type="text"], input[type="email"], input[type="date"] {
            width: 100%; padding: 8px 6px; margin: 8px 0 16px 0; border: 1px solid #ccc; border-radius: 4px;
        }
        input[type="submit"], button { background: #23395d; color: #fff; border: none; padding: 10px 18px; border-radius: 4px; cursor: pointer; }
        .message { text-align: center; padding: 12px; margin-top: 10px; border-radius: 5px; }
        .success { background: #e2fbe2; color: #005700; }
        .error { background: #ffe2e2; color: #c20808; }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="index.jsp" class="home-btn">Home</a>
    </div>

    <div class="form-container">
        <h2>Add Employee</h2>

        <form action="addEmployee" method="post">
            <label>Name:</label>
            <input name="name" type="text" required/>
            <label>Email:</label>
            <input name="email" type="email" required/>
            <label>Department:</label>
            <input name="department" type="text" required/>
            <label>Joining Date:</label>
            <input name="joining_date" type="date" required/>
            <input type="submit" value="Add" />
        </form>

        <%
          String success = request.getParameter("success");
          String error = request.getParameter("error");

          if ("true".equals(success)) {
            out.print("<div class=\"message success\">Added successfully!</div>");
          }

          String popupMsg = null;
          if ("duplicateEmail".equals(error)) {
            out.print("<div class=\"message error\">Email already exists. Please use a different email.</div>");
            popupMsg = "Employee already exists with this email.";
          } else if ("duplicateNameEmail".equals(error)) {
            out.print("<div class=\"message error\">An employee with this Name and Email already exists.</div>");
            popupMsg = "Employee already exists (same name and email).";
          } else if ("invalid".equals(error)) {
            out.print("<div class=\"message error\">Invalid or missing input. Please verify all fields.</div>");
          } else if ("exception".equals(error) || "1".equals(error)) {
            out.print("<div class=\"message error\">Server error occurred. Please try again.</div>");
          }

          if (popupMsg != null) {
        %>
          <script>
            alert("<%= popupMsg.replace("\"", "\\\"") %>");
          </script>
        <%
          }
        %>
    </div>
</body>
</html>

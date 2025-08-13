<html>
<head>
    <title>Apply Leave</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f7faff; padding: 40px 0; }
        .top-bar {
            position: absolute;
            top: 20px;
            right: 30px;
        }
        .home-btn {
            background: #2b4d6d;
            color: #fff;
            border: none;
            padding: 7px 18px;
            font-size: 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            box-shadow: 0 1px 4px #0001;
            transition: background 0.2s;
            cursor: pointer;
        }
        .home-btn:hover {
            background: #466894;
        }
        .form-container { max-width: 400px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 10px #0001; padding: 32px; }
        h2 { text-align: center; color: #2b4d6d; }
        input[type="text"], input[type="email"], input[type="date"] { width: 100%; padding: 8px; margin: 8px 0 16px 0; border: 1px solid #ccc; border-radius: 4px; }
        input[type="submit"], button { background: #2b4d6d; color: #fff; border: none; padding: 10px 18px; border-radius: 4px; cursor: pointer; }
        .message { text-align: center; padding: 12px; margin-top: 10px; border-radius: 5px;}
        .success { background: #e2fbe2; color: #005700; }
        .error { background: #ffe2e2; color: #c20808; }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="index.jsp" class="home-btn">Home</a>
    </div>
    <div class="form-container">
        <h2>Apply for Leave</h2>
        <form action="applyLeave" method="post">
            <label>Email:</label>
            <input name="email" type="email" required/>
            <label>Start Date:</label>
            <input name="start_date" type="date" required/>
            <label>End Date:</label>
            <input name="end_date" type="date" required/>
            <label>Reason:</label>
            <input name="reason" type="text" required/>
            <input type="submit" value="Apply"/>
        </form>
        <%
          String success = request.getParameter("success");
          String error = request.getParameter("error");
          if ("true".equals(success)) out.print("<div class='message success'>Applied successfully!</div>");
          if ("notfound".equals(error)) out.print("<div class='message error'>Employee not found.</div>");
          if ("beforejoin".equals(error)) out.print("<div class='message error'>Start date before joining date.</div>");
          if ("invaliddates".equals(error)) out.print("<div class='message error'>Invalid date range.</div>");
          if ("insufficient".equals(error)) out.print("<div class='message error'>Insufficient leave balance.</div>");
          if ("overlap".equals(error)) out.print("<div class='message error'>Leave overlaps with existing approved leave.</div>");
          if ("exception".equals(error)) out.print("<div class='message error'>Server error occurred.</div>");
        %>
    </div>
</body>
</html>

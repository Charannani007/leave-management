<html>
<head>
    <title>Leave Balance</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f6fff6; padding: 40px 0; }
        .top-bar {
            position: absolute;
            top: 20px;
            right: 30px;
        }
        .home-btn {
            background: #18644e;
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
            background: #218c6a;
        }
        .form-container { max-width: 400px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 10px #0001; padding: 32px; }
        h2 { text-align: center; color: #18644e; }
        input[type="email"] { width: 100%; padding: 8px; margin: 8px 0 16px 0; border: 1px solid #ccc; border-radius: 4px; }
        input[type="submit"], button { background: #18644e; color: #fff; border: none; padding: 10px 18px; border-radius: 4px; cursor: pointer; }
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
        <h2>Check Leave Balance</h2>
        <form action="leaveBalance" method="get">
            <label>Email:</label>
            <input name="email" type="email" required/>
            <input type="submit" value="Check"/>
        </form>
        <%
          Integer balance = (Integer)request.getAttribute("balance");
          if (balance != null) {
            out.print("<div class='message success'>Leave balance: " + balance + "</div>");
          }
          String error = request.getParameter("error");
          if ("notfound".equals(error))
            out.print("<div class='message error'>Employee not found.</div>");
          if ("exception".equals(error))
            out.print("<div class='message error'>Server error.</div>");
        %>
    </div>
</body>
</html>

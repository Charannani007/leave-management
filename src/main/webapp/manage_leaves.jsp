<%@ page import="java.sql.*,java.util.*" %>
<html>
<head>
    <title>Manage Leave Requests</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f9fafd; padding: 40px 0; }
        .top-bar {
            position: absolute;
            top: 20px;
            right: 30px;
        }
        .home-btn {
            background: #24567a;
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
            background: #4177ab;
        }
        .container { max-width: 950px; margin: 30px auto; background: #fff; box-shadow: 0 2px 14px #0001; border-radius: 12px; padding: 30px;}
        h2 { text-align: center; color: #24567a; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0 0 0;}
        th, td { border: 1px solid #ccc; padding: 9px 8px; text-align: center; }
        th { background: #24567a; color: #fff;}
        tr:nth-child(even) { background: #f3f7fa;}
        .actions-col { padding: 0 !important; }
        .action-stack {
            display: flex;
            flex-direction: column;
            gap: 7px;
            align-items: center;
            justify-content: center;
            padding: 7px 0;
        }
        button { background: #24567a; color: #fff; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; width: 90px; }
        .message { text-align: center; padding: 12px; margin-top: 10px; border-radius: 5px;}
        .success { background: #e2fbe2; color: #005700; }
        .error { background: #ffe2e2; color: #c20808; }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="index.jsp" class="home-btn">Home</a>
    </div>
    <div class="container">
        <h2>Manage Leave Requests (HR)</h2>
        <%
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
            		"jdbc:mysql://sql12.freesqldatabase.com:3306/sql12794547", "sql12794547", "iGN3t12ytZ");
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
              "SELECT leave_request.id, employee.name, employee.email, leave_request.start_date, leave_request.end_date, leave_request.status, leave_request.reason "
              + "FROM leave_request INNER JOIN employee ON leave_request.employee_id = employee.id ORDER BY leave_request.id DESC");
        %>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Start</th>
                <th>End</th>
                <th>Status</th>
                <th>Reason</th>
                <th>Actions</th>
            </tr>
            <% while (rs.next()) { %>
                <tr>
                    <td><%=rs.getInt(1)%></td>
                    <td><%=rs.getString(2)%></td>
                    <td><%=rs.getString(3)%></td>
                    <td><%=rs.getDate(4)%></td>
                    <td><%=rs.getDate(5)%></td>
                    <td><%=rs.getString(6)%></td>
                    <td><%=rs.getString(7)%></td>
                    <td class="actions-col">
                    <%
                      String status = rs.getString(6);
                      if ("APPLIED".equals(status)) {
                    %>
                      <div class="action-stack">
                        <form action="approveLeave" method="post">
                          <input type="hidden" name="leave_id" value="<%=rs.getInt(1)%>"/>
                          <button type="submit">Approve</button>
                        </form>
                        <form action="rejectLeave" method="post">
                          <input type="hidden" name="leave_id" value="<%=rs.getInt(1)%>"/>
                          <button type="submit">Reject</button>
                        </form>
                      </div>
                    <%
                      } else {
                        out.print("--");
                      }
                    %>
                    </td>
                </tr>
            <% } %>
        </table>
        <%
            conn.close();
          } catch (Exception e) {
            out.print("<div class='message error'>Database error: " + e.getMessage() + "</div>");
            e.printStackTrace();
          }
          String success = request.getParameter("success");
          String error = request.getParameter("error");
          if ("approved".equals(success)) out.print("<div class='message success'>Leave approved!</div>");
          if ("rejected".equals(success)) out.print("<div class='message success'>Leave rejected!</div>");
          if ("invalidrequest".equals(error)) out.print("<div class='message error'>Invalid/Already processed.</div>");
          if ("exception".equals(error)) out.print("<div class='message error'>Server error.</div>");
        %>
    </div>
</body>
</html>

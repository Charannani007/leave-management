package saicharan.leave_management;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/leaveBalance")
public class LeaveBalanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");

        // Basic null/empty check
        if (email == null || email.trim().isEmpty()) {
            res.sendRedirect("leave_balance.jsp?error=invalid");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT leave_balance FROM employee WHERE email=?");
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("balance", rs.getInt("leave_balance"));
                req.getRequestDispatcher("leave_balance.jsp").forward(req, res);
            } else {
                res.sendRedirect("leave_balance.jsp?error=notfound");
            }
        } catch (Exception e) {
            res.sendRedirect("leave_balance.jsp?error=exception");
        }
    }
}

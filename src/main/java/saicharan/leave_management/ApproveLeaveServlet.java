package saicharan.leave_management;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/approveLeave")
public class ApproveLeaveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String leaveIdStr = req.getParameter("leave_id");
        if (leaveIdStr == null || leaveIdStr.trim().isEmpty()) {
            res.sendRedirect("manage_leaves.jsp?error=invalidrequest");
            return;
        }

        int leaveId;
        try {
            leaveId = Integer.parseInt(leaveIdStr);
        } catch (NumberFormatException ex) {
            res.sendRedirect("manage_leaves.jsp?error=invalidrequest");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); // Transaction for safety

            // Get leave request by ID
            PreparedStatement get =
                conn.prepareStatement("SELECT * FROM leave_request WHERE id=? FOR UPDATE");
            get.setInt(1, leaveId);
            ResultSet rs = get.executeQuery();
            if (!rs.next() || !"APPLIED".equals(rs.getString("status"))) {
                conn.rollback();
                res.sendRedirect("manage_leaves.jsp?error=invalidrequest"); return;
            }
            int empId = rs.getInt("employee_id");
            LocalDate start = rs.getDate("start_date").toLocalDate(), end = rs.getDate("end_date").toLocalDate();
            int days = (int) ChronoUnit.DAYS.between(start, end) + 1;

            // Defensive check: get employee and balance
            PreparedStatement getEmp = conn.prepareStatement("SELECT leave_balance FROM employee WHERE id=? FOR UPDATE");
            getEmp.setInt(1, empId);
            ResultSet empRs = getEmp.executeQuery();
            if (!empRs.next()) {
                conn.rollback();
                res.sendRedirect("manage_leaves.jsp?error=notfound"); return;
            }
            int currBalance = empRs.getInt("leave_balance");
            if (currBalance < days) {
                conn.rollback();
                res.sendRedirect("manage_leaves.jsp?error=insufficient"); return;
            }

            // Update leave balance
            PreparedStatement updateBal =
                conn.prepareStatement("UPDATE employee SET leave_balance = leave_balance - ? WHERE id = ?");
            updateBal.setInt(1, days);
            updateBal.setInt(2, empId);
            updateBal.executeUpdate();

            // Approve the leave request
            PreparedStatement approve =
                conn.prepareStatement("UPDATE leave_request SET status='APPROVED' WHERE id=?");
            approve.setInt(1, leaveId);
            approve.executeUpdate();

            conn.commit();
            res.sendRedirect("manage_leaves.jsp?success=approved");
        } catch (Exception e) {
            res.sendRedirect("manage_leaves.jsp?error=exception");
        }
    }
}

package saicharan.leave_management;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/applyLeave")
public class ApplyLeaveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String reason = req.getParameter("reason");
        String startStr = req.getParameter("start_date");
        String endStr = req.getParameter("end_date");

        // Input validation (null or badly formatted)
        if (email == null || email.trim().isEmpty() ||
                reason == null || reason.trim().isEmpty() ||
                startStr == null || endStr == null) {
            res.sendRedirect("apply_leave.jsp?error=invalidinput");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Edge: Employee not found
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM employee WHERE email=?");
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                res.sendRedirect("apply_leave.jsp?error=notfound"); return;
            }
            int empId = rs.getInt("id");
            int balance = rs.getInt("leave_balance");
            LocalDate joining = rs.getDate("joining_date").toLocalDate();

            LocalDate start, end;
            try {
                start = LocalDate.parse(startStr);
                end = LocalDate.parse(endStr);
            } catch (Exception e) {
                res.sendRedirect("apply_leave.jsp?error=invalidinput"); return;
            }

            // Edge: Invalid dates
            if (end.isBefore(start)) {
                res.sendRedirect("apply_leave.jsp?error=invaliddates"); return;
            }
            int days = (int) ChronoUnit.DAYS.between(start, end) + 1;
            if (days <= 0) { // Negative/Zero days
                res.sendRedirect("apply_leave.jsp?error=negativeduration"); return;
            }
            // Edge: Leave before joining date
            if (start.isBefore(joining)) {
                res.sendRedirect("apply_leave.jsp?error=beforejoin"); return;
            }
            // Edge: More days than balance
            if (days > balance) {
                res.sendRedirect("apply_leave.jsp?error=insufficient"); return;
            }
            // Edge: Request far in the past/future (example here: more than 1 year future or 1 month past)
            LocalDate today = LocalDate.now();
            if (start.isBefore(today.minusMonths(1)) || start.isAfter(today.plusYears(1))) {
                res.sendRedirect("apply_leave.jsp?error=outofrange"); return;
            }
            // Edge: Overlapping approved leave
            PreparedStatement overlap = conn.prepareStatement(
                "SELECT 1 FROM leave_request WHERE employee_id=? AND status='APPROVED' AND NOT (end_date < ? OR start_date > ?)");
            overlap.setInt(1, empId);
            overlap.setDate(2, java.sql.Date.valueOf(start));
            overlap.setDate(3, java.sql.Date.valueOf(end));
            if (overlap.executeQuery().next()) {
                res.sendRedirect("apply_leave.jsp?error=overlap"); return;
            }
            // All checks pass - add to DB
            PreparedStatement add = conn.prepareStatement(
                "INSERT INTO leave_request (employee_id,start_date,end_date,status,reason) VALUES (?,?,?,?,?)");
            add.setInt(1, empId);
            add.setDate(2, java.sql.Date.valueOf(start));
            add.setDate(3, java.sql.Date.valueOf(end));
            add.setString(4, "APPLIED");
            add.setString(5, reason.trim());
            add.executeUpdate();
            res.sendRedirect("apply_leave.jsp?success=true");
        } catch (Exception e) {
            res.sendRedirect("apply_leave.jsp?error=exception");
        }
    }
}

package saicharan.leave_management;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/rejectLeave")
public class RejectLeaveServlet extends HttpServlet {
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
            conn.setAutoCommit(false); // transactional safety

            // Confirm the leave request exists and is in APPLIED state
            PreparedStatement get =
                conn.prepareStatement("SELECT status FROM leave_request WHERE id=? FOR UPDATE");
            get.setInt(1, leaveId);
            ResultSet rs = get.executeQuery();
            if (!rs.next() || !"APPLIED".equals(rs.getString("status"))) {
                conn.rollback();
                res.sendRedirect("manage_leaves.jsp?error=invalidrequest");
                return;
            }

            // Reject the leave request
            PreparedStatement reject =
                conn.prepareStatement("UPDATE leave_request SET status='REJECTED' WHERE id=?");
            reject.setInt(1, leaveId);
            reject.executeUpdate();

            conn.commit();
            res.sendRedirect("manage_leaves.jsp?success=rejected");
        } catch (Exception e) {
            res.sendRedirect("manage_leaves.jsp?error=exception");
        }
    }
}

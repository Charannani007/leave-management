package saicharan.leave_management;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/addEmployee")
public class AddEmployeeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String dept = req.getParameter("department");
        String joiningDate = req.getParameter("joining_date");

        // Normalize and trim
        name = (name == null) ? null : name.trim();
        email = (email == null) ? null : email.trim().toLowerCase();
        dept = (dept == null) ? null : dept.trim();
        joiningDate = (joiningDate == null) ? null : joiningDate.trim();

        // Basic validation
        if (name == null || name.isEmpty()
                || email == null || email.isEmpty()
                || dept == null || dept.isEmpty()
                || joiningDate == null || joiningDate.isEmpty()) {
            res.sendRedirect("add_employee.jsp?error=invalid");
            return;
        }

        // Optional: light email format sanity check
        if (!email.contains("@") || !email.contains(".")) {
            res.sendRedirect("add_employee.jsp?error=invalid");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Check duplicate by email (primary rule)
            try (PreparedStatement check = conn.prepareStatement(
                    "SELECT 1 FROM employee WHERE LOWER(email)=?")) {
                check.setString(1, email);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        // Email already exists -> reject
                        res.sendRedirect("add_employee.jsp?error=duplicateEmail");
                        return;
                    }
                }
            }

            // Insert new employee if checks passed
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO employee (name, email, department, joining_date) VALUES (?, ?, ?, ?)")) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, dept);
                ps.setString(4, joiningDate); // yyyy-MM-dd expected
                ps.executeUpdate();
            }

            res.sendRedirect("add_employee.jsp?success=true");
        } catch (SQLIntegrityConstraintViolationException dup) {
            // If a UNIQUE(email) constraint exists, catch and map to a friendly error
            res.sendRedirect("add_employee.jsp?error=duplicateEmail");
        } catch (Exception e) {
            res.sendRedirect("add_employee.jsp?error=exception");
        }
    }
}

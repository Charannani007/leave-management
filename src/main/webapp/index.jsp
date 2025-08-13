<%@ page import="java.sql.*, java.time.*, java.util.*" %>
<html>
<head>
    <title>Leave Management Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-50 via-white to-blue-100 min-h-screen text-gray-700">
    <div class="max-w-7xl mx-auto px-6 py-12">
        <h1 class="text-center text-4xl font-extrabold mb-12 text-blue-900">Leave Management Dashboard</h1>

        <!-- Key Actions Section -->
        <section class="mb-12">
            <div class="bg-white rounded-3xl shadow-md p-8 max-w-4xl mx-auto border border-gray-200">
                <h2 class="text-2xl font-semibold mb-6 flex items-center gap-3 text-blue-700">
                    &#x1F4C4;
                    <span>Key Actions</span>
                </h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <a href="add_employee.jsp" class="block p-5 border-2 border-blue-300 rounded-xl text-center text-blue-700 font-semibold hover:bg-blue-50 transition">
                        Add Employee
                    </a>
                    <a href="apply_leave.jsp" class="block p-5 border-2 border-blue-300 rounded-xl text-center text-blue-700 font-semibold hover:bg-blue-50 transition">
                        Apply Leave
                    </a>
                    <a href="manage_leaves.jsp" class="block p-5 border-2 border-blue-300 rounded-xl text-center text-blue-700 font-semibold hover:bg-blue-50 transition">
                        Manage Leaves (HR)
                    </a>
                    <a href="leave_balance.jsp" class="block p-5 border-2 border-blue-300 rounded-xl text-center text-blue-700 font-semibold hover:bg-blue-50 transition">
                        Check Leave Balance
                    </a>
                </div>
            </div>
        </section>

        <!-- Upcoming Leaves Section -->
        <section class="bg-white rounded-3xl shadow-md p-8 max-w-6xl mx-auto border border-gray-200">
            <h2 class="text-2xl font-semibold mb-6 flex items-center gap-3 text-blue-700">
                &#x1F4C5;
                <span>Upcoming Leaves</span>
            </h2>
            <div class="overflow-auto rounded-xl">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gradient-to-r from-blue-300 to-blue-500 text-white">
                        <tr>
                            <th class="px-6 py-3 text-left text-lg font-semibold">Employee Name</th>
                            <th class="px-6 py-3 text-left text-lg font-semibold">Email</th>
                            <th class="px-6 py-3 text-left text-lg font-semibold">Start Date</th>
                            <th class="px-6 py-3 text-left text-lg font-semibold">End Date</th>
                            <th class="px-6 py-3 text-left text-lg font-semibold">Status</th>
                            <th class="px-6 py-3 text-left text-lg font-semibold">Reason</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 text-gray-700">
                        <% 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://sql12.freesqldatabase.com:3306/sql12794547", "sql12794547", "iGN3t12ytZ");
                            PreparedStatement ps = conn.prepareStatement(
                                "SELECT e.name, e.email, l.start_date, l.end_date, l.status, l.reason " +
                                "FROM leave_request l INNER JOIN employee e ON l.employee_id = e.id " +
                                "WHERE l.start_date >= CURDATE() AND l.status = 'APPROVED' " +
                                "ORDER BY l.start_date ASC");
                            ResultSet rs = ps.executeQuery();
                            boolean hasLeaves = false;
                            while (rs.next()) {
                                hasLeaves = true;
                        %>
                        <tr class="odd:bg-gray-50 even:bg-gray-100">
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString(1) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString(2) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getDate(3) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getDate(4) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString(5) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString(6) %></td>
                        </tr>
                        <% 
                            }
                            if (!hasLeaves) {
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap text-center italic text-gray-400" colspan="6">No upcoming leaves found.</td>
                        </tr>
                        <% }
                            conn.close();
                        } catch(Exception e) {
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap text-center text-red-600" colspan="6">Error loading upcoming leaves: <%= e.getMessage() %></td>
                        </tr>
                        <% }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</body>
</html>

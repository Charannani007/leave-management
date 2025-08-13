package saicharan.leave_management;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://sql12.freesqldatabase.com:3306/sql12794547", "sql12794547", "iGN3t12ytZ"
        );
    }
}

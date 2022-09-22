package java_class;
import java.sql.*;
import java.util.Calendar;
import java.util.Date;

public class Close {
	public static void close(PreparedStatement pstmt) {
		if(pstmt!=null) {
			try {
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	public static void close(ResultSet rs) {
		if(rs!=null) {
			try {
				rs.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	public static Date getDate(int year, int month, int date){
        Calendar cal = Calendar.getInstance();
        cal.set(year, month-1, date);
        return new Date(cal.getTimeInMillis());
	}
}

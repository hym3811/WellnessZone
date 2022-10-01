<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../DB.jsp"%>
<%@ page import="java_class.Close"%>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String ctg = request.getParameter("ctg");
	String id = request.getParameter("id");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = request.getParameter("day");
	
	try{
		String sql = "select systimestamp from dual";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String time = rs.getString(1).substring(11,16);
			
			if("enter".equals(ctg)){
				sql = "update wellness_work set enter=? where year=? and month=? and day=? and id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, time);
				pstmt.setString(2, year);
				pstmt.setString(3, month);
				pstmt.setString(4, day);
				pstmt.setString(5, id);
				pstmt.executeUpdate();
			}else if("exit".equals(ctg)){pstmt.close();
				sql = "update wellness_work set exit=? where year=? and month=? and day=? and id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, time);
				pstmt.setString(2, year);
				pstmt.setString(3, month);
				pstmt.setString(4, day);
				pstmt.setString(5, id);
				pstmt.executeUpdate();
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	Close.close(pstmt);
	Close.close(rs);
%>
<script>
location.href="attendance_manage.jsp?year=<%=year%>&month=<%=month%>&day=<%=day%>";
</script>
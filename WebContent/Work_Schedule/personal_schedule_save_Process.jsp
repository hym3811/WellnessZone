<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%@ page import = "java.util.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	int size = Integer.parseInt(request.getParameter("size"));
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	
	String[] week = request.getParameter("week_list").split(" ");
	String[] work = new String[size];
	
	for(int i=0;i<size;i++){
		work[i] = request.getParameter("work_"+i);
	}
	
	try{
		for(int i=0;i<size;i++){
			if(work[i]!=null){
				
				String sql = "select id from wellness_work where year=? and month=? and day=? and id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, year);
				pstmt.setString(2, month);
				pstmt.setInt(3, i+1);
				pstmt.setString(4, id);
				rs = pstmt.executeQuery();
				
				if(!rs.next()){
					pstmt.close();
					sql = "insert into wellness_work values(?,?,?,?,'','','',?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, i+1);
					pstmt.setString(4, id);
					pstmt.setString(5, work[i]);
					pstmt.executeUpdate();
				}else{
					pstmt.close();
					sql = "update wellness_work set work = ? where year=? and month=? and day=? and id=?";
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, work[i]);
					pstmt.setString(2, year);
					pstmt.setString(3, month);
					pstmt.setInt(4, i+1);
					pstmt.setString(5, id);
					pstmt.executeUpdate();
				}
			}
		}
		Close.close(pstmt);
		Close.close(rs);
		%>
		<script>
		location.href="work_schedule_main.jsp?year=<%=year%>&month=<%=month%>";
		</script>
		<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
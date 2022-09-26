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
	String[] team = new String[size];
	String[] harf = new String[size];
	
	for(int i=0;i<size;i++){
		work[i] = request.getParameter("work_"+i);
		team[i] = request.getParameter("team_"+i);
		harf[i] = request.getParameter("harf_"+i);
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
					sql = "insert into wellness_work values(?,?,?,?,?,'','',?,?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, i+1);
					pstmt.setString(4, id);
					pstmt.setString(5, team[i]);
					pstmt.setString(6, work[i]);
					pstmt.setString(7, harf[i]);
					pstmt.executeUpdate();
				}else{
					pstmt.close();
					sql = "update wellness_work set team = ?,work = ?,harf=? where year=? and month=? and day=? and id=?";
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, team[i]);
					pstmt.setString(2, work[i]);
					pstmt.setString(3, harf[i]);
					pstmt.setString(4, year);
					pstmt.setString(5, month);
					pstmt.setInt(6, i+1);
					pstmt.setString(7, id);
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
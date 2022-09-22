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
	
	System.out.println(year + " / " + month + " / " + id);
	System.out.println(Arrays.toString(week));
	
	for(int i=0;i<size;i++){
		work[i] = request.getParameter("work_"+i);
	}System.out.println(Arrays.toString(work));
	
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
				
					sql = "insert into wellness_work values(?,?,?,?,?,'','',?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, i+1);
					pstmt.setString(4, week[i]);
					pstmt.setString(5, id);
					pstmt.setString(6, work[i]);
					pstmt.executeUpdate();
				}else{
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
		alert("저장이 완료되었습니다.");
		location.href="work_schedule_main.jsp";
		</script>
		<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
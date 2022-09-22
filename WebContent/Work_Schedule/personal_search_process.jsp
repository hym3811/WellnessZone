<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String search_option = request.getParameter("search_option");
	
	try{
		
		if("name".equals(search_option)||"choice".equals(search_option)){
			String sql = "select id,name from wellness_account where name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, request.getParameter("search_input"));
		}
		else if("id".equals(search_option)){
			String sql = "select id,name from wellness_account where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, request.getParameter("search_input"));
		}
		
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			
			String year = request.getParameter("year");
			String month = request.getParameter("month");
			String id = rs.getString(1);
			String name = rs.getString(2);
			
			%>
			<script>
			location.href="personal_schedule.jsp?year=<%=year%>&month=<%=month%>&id=<%=id%>&name=<%=name%>";
			</script>
			<%
		}else{
			%>
			<script>
			alert("검색 결과가 없습니다.\n다시 검색해주세요.");
			history.back();
			</script>
			<%
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}
%>
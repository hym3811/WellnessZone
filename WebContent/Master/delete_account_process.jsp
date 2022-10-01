<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%
	PreparedStatement pstmt = null;
	String id = request.getParameter("id");

	try{
		String sql = "delete from wellness_account where id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, id);
		pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
	}

	Close.close(pstmt);
%>
<script>
location.href="master_main.jsp?page=1";
</script>
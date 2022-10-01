<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String id = request.getParameter("create_account_id");
	String pass = request.getParameter("create_account_pass");
	String name = request.getParameter("create_account_name");
	String rank = request.getParameter("create_account_rank");
	String position = request.getParameter("create_account_position");
	
	try{
		String sql = "insert into wellness_account values(?,?,?,?,?,sysdate,'9999-12-31')";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, id);
		pstmt.setString(2, pass);
		pstmt.setString(3, name);
		pstmt.setString(4, rank);
		pstmt.setString(5, position);
		pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
	}

	Close.close(pstmt);Close.close(rs);
%>
<script>
location.href="master_main.jsp";
</script>
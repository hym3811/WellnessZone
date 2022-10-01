<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%
	PreparedStatement pstmt = null;

	String id = request.getParameter("update_account_id");
	String pass = request.getParameter("update_account_pass");
	String name = request.getParameter("update_account_name");
	String rank = request.getParameter("update_account_rank");
	String position = request.getParameter("update_account_position");
	String sql = null;
	try{
		if(pass.equals("")){
			sql = "update wellness_account set name=?,rank=?,position=? where id=?";
		}
		else{
			sql = "update wellness_account set name=?,rank=?,position=?,pass=? where id=?";
		}
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setString(2, rank);
		pstmt.setString(3, position);
		if(pass.equals("")){
			pstmt.setString(4, id);
		}
		else{
			pstmt.setString(4, pass);
			pstmt.setString(5, id);
		}
		pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
	}
	
	Close.close(pstmt);
%>
<script>
location.href="master_main.jsp?page=1";
</script>
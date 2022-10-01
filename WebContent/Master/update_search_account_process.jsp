<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;	

	String id = request.getParameter("update_search_id");
	String pass = request.getParameter("update_search_pass");
	
	try{
		String sql = "select id,pass,name,rank,position from wellness_account where id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			if(pass.equals(rs.getString(2))){
				%>
				<script>
				location.href='master_main.jsp?page=3&update_id=<%=rs.getString(1)%>&update_name=<%=rs.getString(3)%>&update_rank=<%=rs.getString(4)%>&update_position=<%=rs.getString(5)%>';
				</script>
				<%
			}else{
				%>
				<script>
				alert('비밀번호 불일치');
				location.href='master_main.jsp?page=3';
				</script>
				<%
			}
		}else{
			%>
			<script>
			alert('아이디 조회 안됨');
			location.href='master_main.jsp?page=3';
			</script>
			<%
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
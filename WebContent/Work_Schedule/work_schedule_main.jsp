<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style.css">
</head>
<%@ include file="../DB.jsp" %>
<body>
<%@ include file="../header.jsp" %>
<%@ include file="../nav.jsp" %>
<section>
	<form name="form" method="post">
		<%
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try{
				String sql = "select sysdate from dual";
			}catch(Exception e){
				e.printStackTrace();
			}
		%>
	</form>
</section>
<%@ include file="../footer.jsp" %>
</body>
</html>
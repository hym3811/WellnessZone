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
			
			String today = null;
			String year = null;
			String month = null;
			
			if(request.getParameter("year")!=null){
				year = request.getParameter("year");
			}
			
			if(request.getParameter("month")!=null){
				month = request.getParameter("month");
			}
			
			try{
				String sql = "select sysdate from dual";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()){
					today = rs.getString(1).substring(0,10);
					
					if(year==null)	year = today.substring(0,4);
					if(month==null)	month = today.substring(5,7);
					
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		%>
		<h3 class="title">근무표</h3>
	</form>
</section>
<%@ include file="../footer.jsp" %>
</body>
</html>
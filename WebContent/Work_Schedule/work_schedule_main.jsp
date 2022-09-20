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
<%@ page import = "java.util.*" %>
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
			if(year==null){
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
			}
			try{//해당년도,해당월의 달력 정보 조회
				String sql = "select distinct day,(week-1) from wellness_work where year=? and month=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, year);
				pstmt.setString(2, month);
				rs = pstmt.executeQuery();
				
				ArrayList<Integer> day = new ArrayList<Integer>();
				ArrayList<Integer> week = new ArrayList<Integer>();
				while(rs.next()){
					day.add(rs.getInt(1));
					week.add(rs.getInt(2));
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		%>
		<h3 class="title">근무표</h3>
		
		<div class="schedule_line" style="height:50px!important;border:1px solid black;margin:20px auto;">
			<div class="schedule_btn">◀</div>
			<div class="schedule_select"><%=year %></div>
			<div class="schedule_btn" style="margin-right:150px;">▶</div>
			<div class="schedule_btn">▼</div>
			<div class="schedule_select"><%=month %></div>
			<div class="schedule_btn">▲</div>
		</div>
		
		<div class="schedule_line" style="height:30px!important;">
		<%
			String[] week_arr = {"일","월","화","수","목","금","토"};
			for(int i=0;i<7;i++){
				%>
				<div class="schedule_week"
				<%
					switch(i){
					case 0:
						%>style="color:red;"<%
						break;
					case 6:
						%>style="color:blue;"<%
						break;
						default:
							%>style="color:black;"<%
							break;
					}
				%>
				><%=week_arr[i] %></div>
				<%
			}
		%>
		</div>
	</form>
</section>
<%@ include file="../footer.jsp" %>
</body>
<script src="work_schedule.js"></script>
</html>
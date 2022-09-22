<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style.css">
<link rel="stylesheet" href="work_schedule.css">
</head>
<body>
<%@ include file="../header.jsp" %>
<%@ include file="../nav.jsp" %>
<%@ include file="../DB.jsp" %>
<%@ page import = "java_class.Close" %>
<%@ page import = "java.util.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String year = null;
	String month = null;
	String day = null;
	
	if(request.getParameter("choice_date")==null){
		year = request.getParameter("year");
		month = request.getParameter("month");
		day = request.getParameter("day");
	}else{
		String choice = request.getParameter("choice_date");
		
		year = choice.substring(0,4);
		month = choice.substring(5,7);
		day = Integer.toString(Integer.parseInt(choice.substring(8,10)));
	}
	
	String select_date = year + "-" + month + "-" + day;
	
	System.out.println(year + " / " + month + " / " + day);
	
	int size = 0;
	try{
		String sql = "select last_day('"+select_date+"') from dual";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if(rs.next()){
			size = Integer.parseInt(rs.getString(1).substring(8,10));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	System.out.println(size);
	
	String[] id = null;
	String[] name = null;
	int i = 0;
	
	try{
		String sql = "select id,name from wellness_account where joindate<=? and (outdate>=? or outdate='')";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, select_date);
		pstmt.setString(2, select_date);
		rs = pstmt.executeQuery();
		
		StringBuilder id_sb = new StringBuilder();
		StringBuilder name_sb = new StringBuilder();
		
		while(rs.next()){
			id_sb.append(rs.getString(1)).append(" ");
			name_sb.append(rs.getString(2)).append(" ");
			i++;
		}
		
		id = id_sb.toString().split(" ");
		name = name_sb.toString().split(" ");
		
	}catch(Exception e){
		e.printStackTrace();
	}System.out.println(Arrays.toString(id));System.out.println(Arrays.toString(name));
%>
<script>var size = <%=size%>;</script>
<section>
	<form name="form" method="post">
	<input type="hidden" name="year" value="<%=year %>">
	<input type="hidden" name="month" value="<%=month %>">
	<input type="hidden" name="day" value="<%=day %>">
		<h3 class="title">일별 근무 설정</h3>
		
		<div class="schedule_line" style="position:relative;height:50px!important;margin:20px auto;">
			<div class="schedule_btn" id="year_btn1" onclick="day_year(-1)">◀</div>
			<div class="schedule_select" id="year_select" style="color:blue;font-weight:bold;"><%=year %></div>
			<div class="schedule_btn" id="year_btn2" onclick="day_year(1)" style="margin-right:70px;">▶</div>
			<div class="schedule_btn" id="month_btn1" onclick="day_month(-1)">▼</div>
			<div class="schedule_select" id="month_select" style="color:purple;font-weight:bold;"><%=month %></div>
			<div class="schedule_btn" id="month_btn2" onclick="day_month(1)" style="margin-right:70px;">▲</div>
			<div class="schedule_btn" id="day_btn1" onclick="day_day(-1)">▼</div>
			<div class="schedule_select" id="day_select" style="color:purple;font-weight:bold;"><%=day %></div>
			<div class="schedule_btn" id="day_btn2" onclick="day_day(1)">▲</div>
			<div style="position:absolute;right:150px;top:-5px;font-weight:bold;">달력에서 직접 선택</div>
			<div style="position:absolute;right:150px;top:20px;">
				<input type="date" name="choice_date" onchange="calendar_choice()">
			</div>
		</div>
		
	</form>
</section>
<%
	Close.close(pstmt);
	Close.close(rs);
%>
<script src="work_schedule.js"></script>
<%@ include file="../footer.jsp" %>
</body>
<script>
	function calendar_choice(){
		var doc = document.form;
		doc.action = "day_schedule.jsp";
		doc.submit();
	}
</script>
</html>
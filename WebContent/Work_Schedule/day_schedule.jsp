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
<%@ page import = "java.text.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	String year = null;
	String month = null;
	String day = null;
	String week = null;
	
	if(request.getParameter("choice_date")==null){
		year = request.getParameter("year");
		month = Integer.toString(Integer.parseInt(request.getParameter("month")));
		day = request.getParameter("day");
	}else{
		String choice = request.getParameter("choice_date");
		
		year = choice.substring(0,4);
		month = Integer.toString(Integer.parseInt(choice.substring(5,7)));
		day = Integer.toString(Integer.parseInt(choice.substring(8,10)));
	}
	
	String select_date = year + "-" + month + "-" + day;
	String callendar_date = sdf.format(Close.getDate(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day)));
	
	//System.out.println(select_date);
	
	try{
		String sql = "select to_char(trunc(to_date('"+select_date+"','yyyy-mm-dd'),'mm')) from dual";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if(rs.next()){
			week = rs.getString(1);
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
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
	//System.out.println(size);
	
	String[] id = null;
	String[] name = null;
	String[] position = null;

	StringBuilder id_sb = new StringBuilder();
	StringBuilder name_sb = new StringBuilder();
	StringBuilder position_sb = new StringBuilder();
	
	int i = 0;
	
	try{
		String sql = "select id,name,position from wellness_account where rank>=3 and joindate<=? and (outdate>=? or outdate='') order by rank,name";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, select_date);
		pstmt.setString(2, select_date);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			id_sb.append(rs.getString(1)).append(" ");
			name_sb.append(rs.getString(2)).append(" ");
			position_sb.append(rs.getString(3)).append(" ");
			i++;
		}
		
		id = id_sb.toString().split(" ");
		name = name_sb.toString().split(" ");
		position = position_sb.toString().split(" ");
		
	}catch(Exception e){
		e.printStackTrace();
	}//System.out.println(Arrays.toString(id));System.out.println(Arrays.toString(name));System.out.println(Arrays.toString(position));
	
	String[] work = null;
	try{
		StringBuilder work_sb = new StringBuilder();
		
		for(int j=0;j<i;j++){
			String sql = "select work from wellness_work where year=? and month=? and day=? and id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			pstmt.setString(2, month);
			pstmt.setString(3, day);
			pstmt.setString(4, id[j]);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				work_sb.append(rs.getString(1)).append(" ");
			}else{
				work_sb.append("-").append(" ");
			}
		}
		work = work_sb.toString().split(" ");
	}catch(Exception e){
		e.printStackTrace();
	}//System.out.println(Arrays.toString(work));
%>
<script>var size = <%=size%>;</script>
<section>
	<form name="form" method="post">
	<input type="hidden" name="year" value="<%=year %>">
	<input type="hidden" name="month" value="<%=month %>">
	<input type="hidden" name="day" value="<%=day %>">
	<input type="hidden" name="week" value="<%=week %>">
	<input type="hidden" name="id_list" value="<%=id_sb.toString()%>">
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
				<input type="date" id="date_calender" name="choice_date" value="<%=request.getParameter("choice_date")==null ? callendar_date : request.getParameter("choice_date") %>" onchange="calendar_choice()">
			</div>
			<div style="margin-left:335px!important;" class="save_btn" onclick="calendar_choice()">초기화</div>
		</div>
		<table border=1 id="day_schedule_table">
			<tr>
				<th>직급</th>
				<th>이름</th>
				<th>상태</th>
			</tr>
		<%
			if(i>0){
				for(i=0;i<id.length;i++){
					%>
					<tr>
						<td><%=position[i] %></td>
						<td><%=name[i] %></td>
						<td>
							<label <%="0".equals(work[i]) ? "style='font-weight:bold;background-color:orange;'" : "style='font-weight:bold;'" %>>근무</label><input id="day_radio" type="radio" name="<%=id[i]%>_work" value="0" <%="0".equals(work[i]) ? "checked" : "" %>>
							<label <%="0.5".equals(work[i]) ? "style='font-weight:bold;color:blue;;background-color:orange;'" : "style='font-weight:bold;color:blue;'" %>>반차</label><input id="day_radio" type="radio" name="<%=id[i]%>_work" value="0.5" <%="0.5".equals(work[i]) ? "checked" : "" %>>
							<label <%="1".equals(work[i]) ? "style='font-weight:bold;color:red;;background-color:orange;'" : "style='font-weight:bold;color:red;'" %>>휴무</label><input id="day_radio" type="radio" name="<%=id[i]%>_work" value="1" <%="1".equals(work[i]) ? "checked" : "" %>>
						</td>
					</tr>
					<%
				}
			}else{
				%>
				<tr>
					<td colspan=3>근무 가능자 없음.</td>
				</tr>
				<%
			}
		%>
		</table>
		<div class="save_btn" onclick="day_schedule()">저장</div>
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
	function day_schedule(){
		var doc = document.form;
		doc.action = "day_schedule_save_Process.jsp";
		doc.submit();
	}
</script>
</html>
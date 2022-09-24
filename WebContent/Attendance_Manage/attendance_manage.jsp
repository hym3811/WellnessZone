<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style.css">
<link rel="stylesheet" href="attendance_manage.css">
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
	
	String today = null;;
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = request.getParameter("day");
	
	if(request.getParameter("year")==null){
		try{
			String sql = "select sysdate from dual";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				today = rs.getString(1).substring(0,10);
			}
			year = today.substring(0,4);
			month = today.substring(5,7);
			day = today.substring(8,10);
		}catch(Exception e){
			e.printStackTrace();
		}
	}else{
		today = year+"-"+month+"-"+day;
	}
	
	int size = 0;
	
	try{
		String sql = "select count(id) from wellness_work where year=? and month=? and day=? and work<1";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, year);
		pstmt.setString(2, month);
		pstmt.setString(3, day);
		rs = pstmt.executeQuery();
		if(rs.next()){
			size = rs.getInt(1);
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	ArrayList<String> team_list = new ArrayList<String>();
	ArrayList<String> team_name = new ArrayList<String>();
	ArrayList<String> enter_time = new ArrayList<String>();
	ArrayList<String> exit_time = new ArrayList<String>();
	
	try{
		String sql = "select team,team_name,enter_time,exit_time from wellness_team";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			team_list.add(rs.getString(1));
			team_name.add(rs.getString(2));
			enter_time.add(rs.getString(3));
			exit_time.add(rs.getString(4));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	String[] id = new String[size];
	String[] name = new String[size];
	String[] position = new String[size];
	int[] team = new int[size];
	String[] enter = new String[size];
	String[] exit = new String[size];
	String[] pass = new String[size];
	
	try{
		String sql = "select a.id,b.name,b.position,a.team,a.enter,a.exit,b.pass from wellness_work a join wellness_account b on a.id=b.id where year=? and month=? and day=? and work<1";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, year);
		pstmt.setString(2, month);
		pstmt.setString(3, day);
		rs = pstmt.executeQuery();
		
		int i = 0;
		while(rs.next()){
			
			id[i] = rs.getString(1);
			name[i] = rs.getString(2);
			position[i] = rs.getString(3);
			team[i] = rs.getInt(4);
			enter[i] = rs.getString(5);
			exit[i] = rs.getString(6);
			pass[i] = rs.getString(7);
			
			i++;
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
%>
<section style="position:relative;">
	<form name="form" method="post">
	<input type="hidden" name="year" value="<%=year%>">
	<input type="hidden" name="month" value="<%=month%>">
	<input type="hidden" name="day" value="<%=day%>">
		<h3 class="title">출퇴근 관리</h3>
		<div class="today"><h3 style="font-size:1.5em;text-align:right;margin-right:460px;"><%=today %></h3></div>
		<table border=1 class="attendance_table">
			<tr>
				<th>직급</th>
				<th>이름</th>
				<th>출근정보</th>
				<th>퇴근정보</th>
			</tr>
			<%
				if(size==0){
					%>
					<tr>
						<td colspan=4>근무 인원 없음</td>
					</tr>
					<%
				}else{
					for(int i=0;i<size;i++){
						%>
							<tr>
								<td style="width:150px;"><%=position[i] %></td>
								<td style="width:150px;"><%=name[i] %></td>
								<td style="width:300px;position:relative;">
									<%
										if(enter[i]==null){
											%>
												비밀번호 : <input type="password" name="enter_<%=id[i]%>">
												<input type="button" value="출근" onclick="if(document.form.enter_<%=id[i] %>.value!=<%=pass[i] %>){alert('비밀번호 확인');document.form.enter_<%=id[i] %>.focus();return false;}else{location.href='attendance_save_Process.jsp?ctg=enter&id=<%=id[i]%>&year=<%=year%>&month=<%=month%>&day=<%=day%>'}">
											<%
										}else{
											%><div><div style="float:left;margin-left:20px;"><%=team[i]==0 ? "없음" : team_name.get(team[i]-1) %></div><div style="float:left;margin-left:20px;background-color:black;color:white;font-weight:bold;"><%=enter[i].substring(11,16)%> 출근</div><div style="float:left;">&nbsp;&nbsp;&nbsp;</div><%
												if(team[i]!=0){

													int hour = Integer.parseInt(enter[i].substring(11,13));
													int minute = Integer.parseInt(enter[i].substring(14,16));
													int enter_hour = Integer.parseInt(enter_time.get(team[i]-1).substring(0,2));
													int enter_minute = Integer.parseInt(enter_time.get(team[i]-1).substring(3));
													
													
													if(hour-enter_hour==0){
														int diff = minute-enter_minute;
														if(diff>0){
															if(diff<=3){
																%><div class="enter_info" id="info_orange"> 0시간 <%=diff %>분<%
															}else if(diff>3){
																%><div class="enter_info" id="info_red"> 0시간 <%=diff %>분<%
															}%> 지각</div><%
														}
													}else if(hour-enter_hour>0){
														int temp = (hour-enter_hour)*60;
														if(minute-enter_minute>0){
															temp+=(minute-enter_minute);
														}else if(minute-enter_minute<0){
															temp = temp - 60 + minute + enter_minute;
														}
														if(temp<=3){
															%><div class="enter_info" id="info_orange"><%=temp/60 %>시간 <%=temp%60 %>분<%
														}else if(temp>3){
															%><div class="enter_info" id="info_red"><%=temp/60 %>시간 <%=temp%60 %>분<%
														}%> 지각</div><%
													}else{
														%><div class="enter_info" id="info_green">정상출근♡</div><%
													}
												}
										}
									%></div>
								</td>
								<td style="width:300px;">
									<%
										if(exit[i]==null){
											if(enter[i]!=null){
												%>
													비밀번호 : <input type="password" name="exit_<%=id[i]%>">
													<input type="button" value="퇴근" onclick="if(document.form.exit_<%=id[i] %>.value!=<%=pass[i] %>){alert('비밀번호 확인');document.form.exit_<%=id[i] %>.focus();return false;}else{location.href='attendance_save_Process.jsp?ctg=exit&id=<%=id[i]%>&year=<%=year%>&month=<%=month%>&day=<%=day%>'}">
												<%
											}else{
												%>
												출근 등록 필요
												<%
											}
										}else{
											%><%=exit[i].substring(11,19)%><%
										}
									%>
								</td>
							</tr>
						<%
					}
				}
			%>
		</table>
		<div class="btn_line" style="clear:both;">
		<div class="list_btn" style="margin-left:65%;width:100px!important;" onclick="location.href='../Work_Schedule/day_schedule.jsp?year=<%=year %>&month=<%=month %>&day=<%=day %>'">
			일근무 설정
		</div>
		<div class="list_btn" style="margin-left:50px;" onclick="location.href='attendance_main.jsp?year=<%=year%>&month=<%=month%>'">
			목록
		</div>
		</div>
	</form>
</section>
<%@ include file="../footer.jsp" %>
<%
	Close.close(pstmt);
	Close.close(rs);
%>
</body>
</html>
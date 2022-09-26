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
<%@ page import = "java.util.*" %>
<%@ page import = "java_class.Close" %>
<section>
	<form name="form" method="post">
		<h3 class="title">개인 근무 설정</h3>
		
		<%

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			%>
			<script>
			var a = "<%=id%>";
			var b = "<%=name%>";
			</script>
			<%
			String year = request.getParameter("year");
			String month = request.getParameter("month");
			
			String today = null;
			
			//year,month 매개변수가 있으면 받는다.
			if(request.getParameter("year")!=null){
				year = request.getParameter("year");
			}
			
			if(request.getParameter("month")!=null){
				month = request.getParameter("month");
			}
			
			//year,month 매개변수가 없으면 오늘 날짜기준 당월 조회
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
			
			//조회 년월의 일,요일 리스트
			ArrayList<Integer> day = new ArrayList<Integer>();
			ArrayList<Integer> week = new ArrayList<Integer>();
			String start = year+"-"+month+"-01";
			String week_list = null;
			StringBuilder sb = new StringBuilder();
			int i=0;
			try{
				while(true){
					// i변수를 더한 날짜와 그 날짜의 요일을 받아옴
					String sql = "select trunc(to_date('"+start+"','yyyy-mm-dd'),'mm')+"+i+",to_char(trunc(to_date('"+start+"','yyyy-mm-dd'),'mm')+"+i+",'d') from dual";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					String temp = null; // i변수를 더한 날짜
					int temp_week = 0; // 요일 값을 받아올 변수

					if(rs.next()){
						temp = rs.getString(1);
						temp_week = rs.getInt(2)-1;
						sb.append(temp_week).append(" ");
						
						if(Integer.parseInt(temp.substring(5,7))!=Integer.parseInt(month)){ //월이 달라지면 break
							break;
						}else{
							day.add(Integer.parseInt(temp.substring(8,10)));
							week.add(temp_week);
						}
					}
					i++;
				}week_list = sb.toString();
			}catch(Exception e){
				e.printStackTrace();
			}
			%>
			<script>var size = <%=day.size()%>;</script>
			<%
			ArrayList<Integer> work_cnt = new ArrayList<Integer>();
			
			try{//해당년도,해당월의 달력 정보 조회
				String sql = "select count(id),day from wellness_work where year=? and month=? group by day order by day";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, year);
				pstmt.setString(2, month);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					work_cnt.add(rs.getInt(1));
				}
			
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String[] work = new String[day.size()];
			String[] team = new String[day.size()];
			int[] harf = new int[day.size()];
			
			for(int k=0;k<day.size();k++){
				try{
					String sql = "select work,team,harf from wellness_work where year=? and month = ? and day=? and id = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, k+1);
					pstmt.setString(4, id);
					rs = pstmt.executeQuery();
					
					if(rs.next()){
						work[k] = rs.getString(1);
						team[k] = rs.getString(2);
						harf[k] = rs.getInt(3);
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			String position = null;
			try{
				String sql = "select position from wellness_account where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				if(rs.next()){
					position = rs.getString(1);
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
		%>
		<!-- 년/월 변경을 위한 히든변수 -->
		<input type="hidden" name="year" value="<%=year %>">
		<input type="hidden" name="month" value="<%=month %>">
		<input type="hidden" name="id" value="<%=id %>">
		<input type="hidden" name="name" value="<%=name %>">
		<input type="hidden" name="week_list" value="<%=week_list %>">
		
		<div class="schedule_line" style="height:50px!important;margin:20px auto;">
			<div class="schedule_btn" id="year_btn1" onclick="personal_year(-1,a,b)">◀</div>
			<div class="schedule_select" id="year_select" style="color:blue;font-weight:bold;"><%=year %></div>
			<div class="schedule_btn" id="year_btn2" onclick="personal_year(1,a,b)" style="margin-right:150px;">▶</div>
			<div class="schedule_btn" id="month_btn1" onclick="personal_month(-1,a,b)">▼</div>
			<div class="schedule_select" id="month_select" style="color:purple;font-weight:bold;"><%=month %></div>
			<div class="schedule_btn" id="month_btn2" onclick="personal_month(1,a,b)">▲</div>
			<div><h3 style="font-size:2em;color:blue;margin-left:150px;"><%=name %></h3></div>
			<div><h3 style="margin-left:20px;font-size:1.4em;line-height:55px;"><%=position %>님</h3></div>
			<div style="margin-left:140px!important;" class="save_btn" onclick="personal_reset()">초기화</div>
		</div>
		
		<div class="schedule_line" style="height:30px!important;">
		<%
			String[] week_arr = {"일","월","화","수","목","금","토"};
			for(int h=0;h<7;h++){
				%>
				<div class="schedule_week"
				<%
					switch(i){
					case 0:
						%>style="background-color:red;color:white;"<%
						break;
					case 6:
						%>style="background-color:green;color:white;"<%
						break;
						default:
							%>style="background-color:rgb(50,50,50);color:white;"<%
							break;
					}
				%>
				><%=week_arr[h] %></div>
				<%
			}
		%>
		</div><input type="hidden" name="size" value="<%=day.size()%>">
		<%
			if(day.size()>0){
				int week_start = week.get(0); //시작 요일
				
				boolean[] check = new boolean[2]; //cnt와 week_start가 같아진 순간 - 0: 시작점 / 1: 종료점
				
				int idx = 0; // day,week 리스트의 인덱스
				
				int cnt = 0;
				
				while(true){
					%>
					<div class="schedule_line">
						<%
						
						while(true){
							if(cnt==week_start){
								check[0] = true;
							}
							
							if(check[0]&&!check[1]){
								%>
								<div class="schedule_box" style="position:relative;">
									<div class="schedule_day" id="day_<%=day.get(idx) %>" onclick="location.href='day_schedule.jsp?year=<%=year %>&month=<%=month %>&day=<%=day.get(idx) %>'"
									<%
										if(week.get(idx)==0){
											%>style="background-color:red;"<%
										}else if(week.get(idx)==6){
											%>style="background-color:green;"<%
										}else{
											%>style="background-color:black;"<%
										}
									%>
									><%=day.get(idx) %></div>
									<ul class="worker_ul">
										<li class="personal_list" <%="0".equals(work[idx]) ? "style='background-color:orange;'" : "" %>>근무<input type="radio" value="0" name="work_<%=idx %>" id="work_<%=idx%>" <%="0".equals(work[idx]) ? "checked" : "" %>></li>
										<li class="personal_list" <%="0.5".equals(work[idx]) ? "style='background-color:orange;color:blue;'" : "" %> style="color:blue;">반차<input type="radio" value="0.5" name="work_<%=idx %>" id="work_<%=idx%>" <%="0.5".equals(work[idx]) ? "checked" : "" %>></li>
										<li class="personal_list" <%="1".equals(work[idx]) ? "style='background-color:orange;color:red;'" : "" %> style="color:red;">휴무<input type="radio" value="1" name="work_<%=idx %>" id="work_<%=idx%>" <%="1".equals(work[idx]) ? "checked" : "" %>></li>
									</ul>
									<div style="position:absolute;right:0;top:0;width:115px;height:78px;">
										<div style="position:relative;">
											<div class="work_harf">
												<select id="harf_<%=idx %>" name="harf_<%=idx %>"
												<%
													if(work[idx]==null||Float.parseFloat(work[idx])==1||Float.parseFloat(work[idx])!=0.5f){
														%>
														style="display:none;"
														<%
													}
												%>>
													<option value="0" <%=harf[idx]==0 ? "selected" : "" %>>오전
													<option value="1" <%=harf[idx]==1 ? "selected" : "" %>>오후
												</select>
											</div>
											<div class="work_team">
												<select id="team_<%=idx %>" name="team_<%=idx%>" 
												<%
													if(work[idx]==null||Float.parseFloat(work[idx])==1){
														%>
														style="display:none;"
														<%
													}
												%>>
													<option value="">근무조 선택
													<%	
														int time_idx = 0;
														for(int k=0;k<team_list.size();k++){
															if(team_list.get(k).equals(team[idx])){
																time_idx = k;
															}
															%>
															<option value="<%=team_list.get(k) %>" <%=team_list.get(k).equals(team[idx]) ? "selected" : "" %>>'<%=team_name.get(k) %>' 조 / <%=enter_time.get(k) %> ~
															<%
														}
													%>
												</select>
												<p id="time_<%=idx %>" style="font-size:0.9em;margin-top:5px;">
												<%
													if(work[idx]!=null&&Float.parseFloat(work[idx])<1){
														%>
														<%=enter_time.get(time_idx) %> ~ <%=exit_time.get(time_idx) %>
														<%
													}
												%>
												</p>
											</div>
										</div>
									</div>
								</div>
								<%
							}
							else if(!check[0]&&!check[1]){
								%>
								<div class="schedule_box" style="background-color:lightgray;"></div>
								<%
							}
							else if(check[0]&&check[1]){
								%>
								<div class="schedule_box" style="background-color:lightgray;"></div>
								<%
							}
							
							cnt++;
							if(idx==day.size()-1){
								check[1] = true;
							}
							if(check[0]&&!check[1])idx++;
							
							
							//한줄 7칸이 되면 종료
							if(cnt==7){
								cnt=0;
								break;
							}
						}
						
					%>
					</div>
					<%
						//배열을 모두 뱉어내면 종료
						if(idx==day.size()-1){
							break;
						}
				}
			}
		%>
		<div class="save_btn" onclick="personal_schedule()">저장</div>
	</form>
</section>
<%@ include file="../footer.jsp" %>
<%
	Close.close(pstmt);
	Close.close(rs);
%>
<script src="work_schedule.js"></script>
<script>
function personal_schedule(){
	document.form.action = "personal_schedule_save_Process.jsp";
	document.form.submit();
}
function personal_reset(){
	document.form.action = "personal_schedule.jsp";
	document.form.submit();
}
</script>
</body>
</html>
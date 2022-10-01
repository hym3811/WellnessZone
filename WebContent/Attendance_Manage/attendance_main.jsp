<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style.css">
<link rel="stylesheet" href="attendance.css">
</head>
<body>
<%@ include file="../header.jsp" %>
<%@ include file="../nav.jsp" %>
<%@ include file="../DB.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java_class.Close" %>
<script>sessionStorage.removeItem("possi");</script>
<%

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String today = null;
			String year = null;
			String month = null;
			
			//year,month 매개변수가 있으면 받는다.
			if(request.getParameter("year")!=null){
				year = request.getParameter("year");
			}
			
			if(request.getParameter("month")!=null){
				month = Integer.toString(Integer.parseInt(request.getParameter("month")));
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
						if(month==null)	month = Integer.toString(Integer.parseInt(today.substring(5,7)));
						
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			//조회 년월의 일,요일 리스트
			ArrayList<Integer> day = new ArrayList<Integer>();
			ArrayList<Integer> week = new ArrayList<Integer>();
			String start = year+"-"+month+"-01";
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
						
						if(Integer.parseInt(temp.substring(5,7))!=Integer.parseInt(month)){ //월이 달라지면 break
							break;
						}else{
							day.add(Integer.parseInt(temp.substring(8,10)));
							week.add(temp_week);
						}
					}
					i++;
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			//조회 년,월에 근무 가능한 이름 목록
			String last = year+"-"+month+"-"+Integer.toString(day.size());
			
			int[] work_cnt = new int[day.size()];
			try{//해당년도,해당월의 달력 정보 조회
				for(int x=0;x<day.size();x++){
					String sql = "select distinct day,count(id) from wellness_work where year=? and month=? and day=? and work<1 group by day";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, day.get(x));
					rs = pstmt.executeQuery();
					
					if(rs.next()){
						work_cnt[x] = rs.getInt(2);
					}
				}
			
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String[] team_name = new String[day.size()];
			String[] team_cnt = new String[day.size()];
			try{
				for(int x=0;x<day.size();x++){
					StringBuilder sb_team_name = new StringBuilder();
					StringBuilder sb_team_cnt = new StringBuilder();
					
					String sql = "select a.team,a.team_name,count(b.id) from wellness_team a join wellness_work b on a.team=b.team where year=? and month=? and day=? group by a.team,a.team_name order by a.team";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, x+1);
					rs = pstmt.executeQuery();
					
					while(rs.next()){
						sb_team_name.append(rs.getString(2)).append(" ");
						sb_team_cnt.append(rs.getString(3)).append(" ");
					}
					team_name[x] = sb_team_name.toString();
					team_cnt[x] = sb_team_cnt.toString();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		%>
<section>
	<form name="form" method="post">
		<!-- 년/월 변경을 위한 히든변수 -->
		<input type="hidden" name="year" value="<%=year %>">
		<input type="hidden" name="month" value="<%=month %>">
		
		<h3 class="title">출퇴근 관리</h3>
		
		<div class="schedule_line" style="position:relative;height:50px!important;margin:20px auto;">
			<div class="schedule_btn" id="year_btn1" onclick="year(-1)">◀</div>
			<div class="schedule_select" id="year_select" style="color:blue;font-weight:bold;"><%=year %></div>
			<div class="schedule_btn" id="year_btn2" onclick="year(1)" style="margin-right:150px;">▶</div>
			<div class="schedule_btn" id="month_btn1" onclick="month(-1)">▼</div>
			<div class="schedule_select" id="month_select" style="color:purple;font-weight:bold;"><%=month %></div>
			<div class="schedule_btn" id="month_btn2" onclick="month(1)">▲</div>
		</div>
		
		<div class="schedule_line" style="height:30px!important;">
		<%
			String[] week_arr = {"일","월","화","수","목","금","토"};
			for(int j=0;j<7;j++){
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
				><%=week_arr[j] %></div>
				<%
			}
		%>
		</div>
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
							if(check[0]==false){
								if(cnt==week_start){
										check[0] = true;
								}
							}
							
							if(check[0]&&!check[1]){
								%>
								<div class="schedule_box" onclick="location.href='attendance_manage.jsp?year=<%=year%>&month=<%=month%>&day=<%=day.get(idx)%>'">
									<div class="schedule_day" id="day_<%=day.get(idx) %>"
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
									<ul class="attendance_ul">
										<%
											int temp_head = 0;
											//System.out.println(idx+": "+team_name[idx]);
											
											if(!team_name[idx].equals("")){
												String[] temp_team = team_name[idx].split(" ");
												String[] temp_cnt = team_cnt[idx].split(" ");
												if(temp_team.length>0){
													for(int x=0;x<temp_team.length;x++){
														%>
														<li class="attendance_li"><label style="width:50px;"><%=temp_team[x] %>조</label><label style="width:40px;">: <%=temp_cnt[x] %>명</label></li>
														<%
														temp_head += Integer.parseInt(temp_cnt[x]);
													}
												}
											}
											
											if(work_cnt[idx]-temp_head>0){
												%>
												<li class="attendance_li"><label style="width:50px;">없음</label><label style="width:40px;">: <%=work_cnt[idx]-temp_head %>명</label></li>
												<%
											}
										%>
									</ul>
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
	</form>
</section>
<%@ include file="../footer.jsp" %>
<% Close.close(pstmt);Close.close(rs); %>
<script src="attendance.js"></script>
</body>
</html>
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
			ArrayList<Integer> work_cnt = new ArrayList<Integer>();
			
			try{//해당년도,해당월의 달력 정보 조회
				String sql = "select distinct day,(week-1),count(id) from wellness_work where year=? and month=? group by day,(week-1) order by day";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, year);
				pstmt.setString(2, month);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					day.add(rs.getInt(1));
					week.add(rs.getInt(2));
					work_cnt.add(rs.getInt(3));
				}
			
			}catch(Exception e){
				e.printStackTrace();
			}
			
			String[] work = new String[day.size()];
			
			try{
				String sql = "select work from wellness_work where year=? and month = ? and id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, year);
				pstmt.setString(2, month);
				pstmt.setString(3, id);
				rs = pstmt.executeQuery();
				
				int i=0;
				while(rs.next()){
					work[i] = rs.getString(1);
					i++;
				}
			}catch(Exception e){
				e.printStackTrace();
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
		%>
		<!-- 년/월 변경을 위한 히든변수 -->
		<input type="hidden" name="year" value="<%=year %>">
		<input type="hidden" name="month" value="<%=month %>">
		
		<div class="schedule_line" style="height:50px!important;margin:20px auto;">
			<div class="schedule_btn" id="year_btn1" onclick="personal_year(-1,a,b)">◀</div>
			<div class="schedule_select" id="year_select" style="color:blue;font-weight:bold;"><%=year %></div>
			<div class="schedule_btn" id="year_btn2" onclick="personal_year(1,a,b)" style="margin-right:150px;">▶</div>
			<div class="schedule_btn" id="month_btn1" onclick="personal_month(-1,a,b)">▼</div>
			<div class="schedule_select" id="month_select" style="color:purple;font-weight:bold;"><%=month %></div>
			<div class="schedule_btn" id="month_btn2" onclick="personal_month(1,a,b)">▲</div>
			<div><h3 style="font-size:2em;color:blue;margin-left:150px;"><%=name %></h3></div>
			<div><h3 style="margin-left:20px;font-size:1.4em;line-height:55px;"><%=position %>님</h3></div>
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
				><%=week_arr[i] %></div>
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
							if(cnt==week_start){
								check[0] = true;
							}
							
							if(check[0]&&!check[1]){
								%>
								<div class="schedule_box">
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
									<ul class="worker_ul">
										<li class="personal_list">근무<input type="radio" value="0" name="work_<%=idx %>" id="work_<%=idx%>" <%="0".equals(work[idx]) ? "checked" : "" %>></li>
										<li class="personal_list" style="color:blue;">반차<input type="radio" value="0.5" name="work_<%=idx %>" id="work_<%=idx%>" <%="0.5".equals(work[idx]) ? "checked" : "" %>></li>
										<li class="personal_list" style="color:red;">휴무<input type="radio" value="1" name="work_<%=idx %>" id="work_<%=idx%>" <%="1".equals(work[idx]) ? "checked" : "" %>></li>
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
		<div class="save_btn">저장</div>
	</form>
</section>
<%@ include file="../footer.jsp" %>
<%
	Close.close(pstmt);
	Close.close(rs);
%>
<script src="work_schedule.js"></script>
</body>
</html>
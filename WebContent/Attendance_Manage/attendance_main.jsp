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
			
			ArrayList<String> select_name = new ArrayList<String>();
			ArrayList<String> select_position = new ArrayList<String>();
			try{
				String sql = "select name,position from wellness_account where rank>=3 and joindate<=? and outdate>? order by joindate";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, start);
				pstmt.setString(2, last);
				rs = pstmt.executeQuery();
				while(rs.next()){
					select_name.add(rs.getString(1));
					select_position.add(rs.getString(2));
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			
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

			String[] id = new String[day.size()];
			String[] name = new String[day.size()];
			String[] work = new String[day.size()];
			
			try{
				for(int z=0;z<day.size();z++){
					String sql = "select a.id,b.name,a.day,a.work from wellness_work a join wellness_account b on a.id=b.id where year=? and month=? and day=? and b.rank>=3 order by a.day,b.name";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					pstmt.setInt(3, z+1);
					rs=pstmt.executeQuery();
					
					while(rs.next()){
						if(id[z]==null) id[z]=rs.getString(1); else id[z] = id[z] + " "+rs.getString(1);
						if(name[z]==null) name[z]=rs.getString(2); else name[z] = name[z] + " "+rs.getString(2);
						if(work[z]==null) work[z]=rs.getString(4); else work[z] = work[z] + " "+rs.getString(4);
					}
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
		
		<h3 class="title">근무표</h3>
		
		<div class="schedule_line" style="position:relative;height:50px!important;margin:20px auto;">
			<div class="schedule_btn" id="year_btn1" onclick="year(-1)">◀</div>
			<div class="schedule_select" id="year_select" style="color:blue;font-weight:bold;"><%=year %></div>
			<div class="schedule_btn" id="year_btn2" onclick="year(1)" style="margin-right:150px;">▶</div>
			<div class="schedule_btn" id="month_btn1" onclick="month(-1)">▼</div>
			<div class="schedule_select" id="month_select" style="color:purple;font-weight:bold;"><%=month %></div>
			<div class="schedule_btn" id="month_btn2" onclick="month(1)">▲</div>
			<div style="position:absolute;right:220px;top:-5px;font-weight:bold;">개인 근무표 설정</div>
			<div style="position:absolute;right:20px;top:20px;">
				<select name="search_option" onchange="searchOption()">
					<option value="">검색 조건 선택
					<option value="name" <%="name".equals(request.getParameter("search_option")) ? "selected" : "" %>>이름
					<option value="id" <%="id".equals(request.getParameter("search_option")) ? "selected" : "" %>>아이디
					<option value="choice" <%="choice".equals(request.getParameter("search_option")) ? "selected" : "" %>>직접 선택
				</select>
				<%
					if("choice".equals(request.getParameter("search_option"))){
						%>
						<select name="search_input" style="width:173px;">
							<option value="">직원 선택
							<%
								for(int p=0;p<select_name.size();p++){
									%>
									<option value="<%=select_name.get(p)%>"><%=select_name.get(p)%> <%=select_position.get(p) %>
									<%	
								}
							%>
						</select>
						<%
					}else{
						%>
						<input type="text" name="search_input">
						<%
					}
				%>
				<input type="button" value="이동" onclick="search_move()">
			</div>
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
								<div class="schedule_box">
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
</body>
</html>
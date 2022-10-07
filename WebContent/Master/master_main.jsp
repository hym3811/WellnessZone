<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../style.css">
<link rel="stylesheet" href="master.css">
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
	
	try{//권한 확인
		if(login_id==null){
			%>
			<script>
				alert("로그인이 필요합니다.");
				location.href="../login.jsp";
			</script>
			<%
		}
		String sql = "select rank,pass from wellness_account where id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, login_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			if(rs.getInt(1)>2){
				%>
				<script>
				alert("접근 권한이 없습니다.");
				history.back();
				</script>
				<%
			}else{
				%>
				<script>
				var pass = '<%=rs.getString(2)%>';
				var possi = sessionStorage.getItem("possi");
				if(!possi){
					if(prompt('비밀번호 입력하세요.')!=pass){
						alert("비밀번호 불일치");
						history.back();
					}else{
						sessionStorage.setItem("possi",true);
					}
				}
				</script>
				<%
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	int page_num = 0;
	if(request.getParameter("page")!=null){
		page_num = Integer.parseInt(request.getParameter("page"));
	}
	
	ArrayList<String> id_list = new ArrayList<String>();String script_id = "";
	ArrayList<String> pass_list = new ArrayList<String>();String script_pass = "";
	ArrayList<String> name_list = new ArrayList<String>();String script_name = "";
	ArrayList<Integer> rank_list = new ArrayList<Integer>();String script_rank = "";
	ArrayList<String> position_list = new ArrayList<String>();String script_position = "";
	ArrayList<String> joindate_list = new ArrayList<String>();String script_joindate = "";
	String[] rank_arr = {"마스터","관리자","직원","파트타임"};
	try{
		String sql = "select id,pass,name,rank,position,joindate from wellness_account order by rank";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			id_list.add(rs.getString(1));	script_id+=rs.getString(1)+" ";
			pass_list.add(rs.getString(2));	script_pass+=rs.getString(2)+" ";
			name_list.add(rs.getString(3));	script_name+=rs.getString(3)+" ";
			rank_list.add(rs.getInt(4));	script_rank+=rs.getString(4)+" ";
			position_list.add(rs.getString(5));	script_position+=rs.getString(5)+" ";
			joindate_list.add(rs.getString(6));	script_joindate+=rs.getString(6).substring(0,10)+" ";
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	ArrayList<String> team_list = new ArrayList<String>();
	ArrayList<String> teamname_list = new ArrayList<String>();
	ArrayList<String> entertime_list = new ArrayList<String>();
	ArrayList<String> exittime_list = new ArrayList<String>();
	try{
		String sql = "select team,team_name,enter_time,exit_time from wellness_team";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			team_list.add(rs.getString(1));
			teamname_list.add(rs.getString(2));
			entertime_list.add(rs.getString(3));
			exittime_list.add(rs.getString(4));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script>
let id_list = '<%=script_id%>'.split(" ");
</script>
<section style="position:relative;">
	<form name="form" method="post">
		<h3 class="title">관리자 페이지</h3>
		<table style="width:1000px;margin:0 auto;border-collapse:collapse;">
			<tr class="main_tr">
				<td class="main_ctg" style="letter-spacing:10px;margin-left:5px;">계정관리</td>
				<td>
					<input class="master_btn" type="button" value="계정 목록" onclick="view_page('select_account')">
					<input class="master_btn" type="button" value="계정 생성" onclick="view_page('create_account')">
					<input class="master_btn" type="button" value="계정 수정" onclick="view_page('update_account')">
				</td>
				<td class="main_ctg" style="letter-spacing:4px;border-left:1px dashed black;">근무조관리</td>
				<td>
					<input class="master_btn" type="button" value="근무조 목록" onclick="view_page('select_team')">
					<input class="master_btn" type="button" value="근무조 생성" onclick="view_page('create_team')">
				</td>
			</tr>
			<tr class="main_tr">
				<td class="main_ctg">프로그램 관리</td>
				<td>
					<input class="master_btn" type="button" value="프로그램 생성" onclick="view_page('create_program')">
					<input class="master_btn" type="button" value="프로그램 수정" onclick="view_page('update_program')">
					<input class="master_btn" type="button" value="프로그램 삭제" onclick="view_page('delete_program')">
				</td>
				<td class="main_ctg" style="letter-spacing:9px;border-left:1px dashed black;">결산관리</td>
				<td>
					<input class="master_btn" type="button" value="근무시간 결산" onclick="view_page('worktime_result')">
					<input class="master_btn" type="button" value="시급 입력" onclick="view_page('time_salary')">
					<input class="master_btn" type="button" value="급여 정산" onclick="view_page('salary_result')">
				</td>
			</tr>
			<tr class="main_tr"></tr>
		</table>
		
		<!-- @@@@@계정관리@@@@@ -->
		<!-- 계정생성 page_num=1 -->
		<div class="master_content" id="select_account" <%
			if(page_num==1){
				%>style="display:block;"<%
			}
		%>>
			<h4 class="content_title">계정 목록</h4>
			<table id="select_account_table">
				<tr>
					<th style="width:50px;">No.</th>
					<th style="width:150px;">아이디</th>
					<th style="width:100px;">이름</th>
					<th style="width:100px;">직급</th>
					<th style="width:100px;">직책</th>
					<th style="width:200px;">입사일</th>
					<th style="width:50px;border:none!important;">삭제</th>
				</tr>
				<%
					for(int i=0;i<id_list.size();i++){
						%>
						<tr>
							<td><%=i+1 %></td>
							<td><%=id_list.get(i) %></td>
							<td><%=name_list.get(i) %></td>
							<td><%=rank_arr[rank_list.get(i)-1]%></td>
							<td><%=position_list.get(i) %></td>
							<td><%=joindate_list.get(i).substring(0,10) %></td>
							<td id="delete_account_btn" style="border:none!important;" onclick="if(prompt('비밀번호 입력하세요.')!='<%=pass_list.get(i) %>'){alert('비밀번호 틀림');return false;}else{location.href='delete_account_process.jsp?id=<%=id_list.get(i)%>'}">삭제</td>
						</tr>
						<%
					}
				%>
			</table>
		</div>
		<!-- 계정생성 page_num=2 -->
		<div class="master_content" id="create_account">
			<h4 class="content_title">계정 생성</h4>
			
			<table id="create_account_table">
				<tr>
					<th style="width:120px;">이름</th>
					<td>
						<input type="text" name="create_account_name" placeholder="한글 네자리 또는 영어12자리">
					</td>
				</tr>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" name="create_account_id" placeholder="영어,숫자로만 12자리 / 한글 안됨">
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="create_account_pass">
					</td>
				</tr>
				<tr>
					<th>비번확인</th>
					<td>
						<input type="password" name="create_account_check">
					</td>
				</tr>
				<tr>
					<th>직급</th>
					<td>
						<select name="create_account_rank">
							<option value="">직급 선택
							<option value="2">관리자
							<option value="3">직원
							<option value="4">파트타임
						</select>
					</td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
						<input type="text" name="create_account_position" placeholder="예: 주임">
					</td>
				</tr>
			</table>
			<input type="button" value="계정 생성 저장" style="margin-left:600px;" onclick="fx_create_account()">
		</div>
		
		<!-- 계정수정 page_num=3 -->
		<div class="master_content" id="update_account" <%
			if(page_num==3){
				%>style="display:block;"<%
			}
		%>>
			<h4 class="content_title">계정 수정</h4>
			<table style="margin:0 auto;margin-top:20px;">
				<tr>
					<td>아이디</td><td><input type="text" name="update_search_id"></td>
					<td>비밀번호</td><td><input type="password" name="update_search_pass"></td>
					<td><input type="button" value="검색" onclick="update_search_account()"></td>
				</tr>
			</table>
				<script>
					function update_search_account(){
						var doc = document.form;
						if(doc.update_search_id.value==""){
							alert("검색할 아이디를 입력하세요.");
							doc.update_search_id.focus();
							return false;
						}
						if(doc.update_search_pass.value==""){
							alert("검색할 아이디의 비밀번호를 입력하세요.");
							doc.update_search_pass.focus();
							return false;
						}
						doc.action = "update_search_account_process.jsp";
						doc.submit();
					}
				</script>
			<table id="update_account_table">
				<tr>
					<th style="width:120px;">아이디</th>
					<td>
						<input type="text" id="update_account_id" readonly name="update_account_id"value="<%=request.getParameter("update_id")%>">
					</td>
				</tr>
				<tr>
					<th style="width:120px;">이름</th>
					<td>
						<input type="text" id="update_account_name" name="update_account_name" placeholder="한글 네자리 또는 영어12자리" value="<%=request.getParameter("update_name")%>">
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" id="update_account_pass" name="update_account_pass">
					</td>
				</tr>
				<tr>
					<th>비번확인</th>
					<td>
						<input type="password" id="update_account_check" name="update_account_check">
					</td>
				</tr>
				<tr>
					<th>직급</th>
					<td>
						<select name="update_account_rank" id="update_account_rank">
							<option value="">직급 선택
							<option value="2" <%=request.getParameter("update_rank")==null ? "" : (request.getParameter("update_rank").equals("2") ? "selected" : "") %>>관리자
							<option value="3" <%=request.getParameter("update_rank")==null ? "" : (request.getParameter("update_rank").equals("3") ? "selected" : "") %>>직원
							<option value="4" <%=request.getParameter("update_rank")==null ? "" : (request.getParameter("update_rank").equals("4") ? "selected" : "") %>>파트타임
						</select>
					</td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
						<input type="text" id="update_account_position" name="update_account_position" placeholder="예: 주임" value="<%=request.getParameter("update_position")%>">
					</td>
				</tr>
			</table>
			<input type="button" id="update_save_btn" value="계정 수정 저장" style="margin-left:600px;" onclick="fx_update_account()">
			<%
				if(request.getParameter("update_id")!=null){%>
				<script>
				$('#update_save_btn').css({
					"display":"block",
					"margin-left":"580px",
					"margin-top":"20px"
				})
				$('#update_account_table').css({
					"display":"block",
					"border-collapse":"collapse",
					"margin-top":"20px",
					"margin-left":"300px"
				})
				</script>
				<%}
			%>
		</div>
		<!-- @@@@@-@@@@@ -->
		
		
		
		<!-- @@@@@근무조관리@@@@@ -->
		<!-- 근무조 목록 page_num=4 -->
		<div class="master_content" id="select_team" <%
			if(page_num==4){
				%>style="display:block;"<%
			}
		%>>
			<h4 class="content_title">근무조 목록</h4>
			<table border=1 id="select_team_table">
				<tr>
					<th>근무조 코드</th>
					<th>근무조 이름</th>
					<th>출근시간</th>
					<th>퇴근시간</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				<%
					for(int i=0; i<team_list.size();i++){
						%>
						<tr>
							<td><%=team_list.get(i) %></td>
							<td><%=teamname_list.get(i) %></td>
							<td><%=entertime_list.get(i) %></td>
							<td><%=exittime_list.get(i) %></td>
							<td><a href="#" onclick="location.href='master_main.jsp?page=6&team=<%=team_list.get(i)%>'">수정</a></td>
							<td><a href="#" onclick="alert('<%=teamname_list.get(i)%>조: 삭제')">삭제</a></td>
						</tr>
						<%
					}
				%>
			</table>
		</div>
		
		<!-- 근무조 생성 -->
		<div class="master_content" id="create_team">
			<h4 class="content_title">근무조 생성</h4>
			/////////////
		</div>
		
		<!-- 근무조 수정 page_num=6 -->
		<div class="master_content" id="update_team" <%
			if(page_num==6){
				%>style="display:block;"<%
			}
		%>>
			<h4 class="content_title">근무조 수정</h4>
			<table border=1>
				<tr>
					<th>근무조 이름</th>
					<td>
						<input type="hidden" name="update_team" value="<%=request.getParameter("team")%>">
						<input type="text" name="update_teamname" value="<%=request.getParameter("team")!=null ? teamname_list.get(team_list.indexOf(request.getParameter("team"))) : ""%>">
					</td>
				</tr>
				<tr>
					<th>출근시간</th>
					<td>
						<select name="enter_hour">
							<option value="">시간 선택
							<%
								for(int i=6;i<24;i++){
									%>
									<option value="<%=i<10 ? "0"+Integer.toString(i) : i %>" <%=request.getParameter("team")!=null ? 
										(
												i<10 ?(("0"+Integer.toString(i)).equals(entertime_list.get(team_list.indexOf(request.getParameter("team"))).substring(0,2)) ? "selected" : ""):((Integer.toString(i)).equals(entertime_list.get(team_list.indexOf(request.getParameter("team"))).substring(0,2)) ? "selected" : "")
									) : ""%>><%=i<10 ? ("오전 "+Integer.toString(i)) : (i<12 ? "오전 "+Integer.toString(i) : (i==12 ? "오후 "+Integer.toString(i) : "오후 "+Integer.toString(i-12))) %> 시
									<%
								}
							%>
						</select>
						<select name="enter_minute">
							<option value="">분 선택
							<%
								for(int i=0;i<60;i+=5){
									%>
									<option value="<%=i<10 ? "0"+Integer.toString(i) : i %>" <%=request.getParameter("team")!=null ?
										(i<10 ? (	("0"+Integer.toString(i)).equals(entertime_list.get(team_list.indexOf(request.getParameter("team"))).substring(3)) ? "selected" : ""):((Integer.toString(i)).equals(entertime_list.get(team_list.indexOf(request.getParameter("team"))).substring(3)) ? "selected" : ""	)
									) : ""%>><%=i<10 ? "0"+Integer.toString(i) : i %> 분
									<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>퇴근시간</th>
					<td>
						<select name="exit_hour">
							<option value="">시간 선택
							<%
								for(int i=6;i<24;i++){
									%>
									<option value="<%=i<10 ? "0"+Integer.toString(i) : i %>" <%=request.getParameter("team")!=null ? 
										(
												i<10 ?(("0"+Integer.toString(i)).equals(exittime_list.get(team_list.indexOf(request.getParameter("team"))).substring(0,2)) ? "selected" : ""):((Integer.toString(i)).equals(exittime_list.get(team_list.indexOf(request.getParameter("team"))).substring(0,2)) ? "selected" : "")
									) : ""%>><%=i<10 ? ("오전 "+Integer.toString(i)) : (i<12 ? "오전 "+Integer.toString(i) : (i==12 ? "오후 "+Integer.toString(i) : "오후 "+Integer.toString(i-12))) %> 시
									<%
								}
							%>
						</select>
						<select name="exit_minute">
							<option value="">분 선택
							<%
								for(int i=0;i<60;i+=5){
									%>
									<option value="<%=i<10 ? "0"+Integer.toString(i) : i %>" <%=request.getParameter("team")!=null ?
										(i<10 ? (	("0"+Integer.toString(i)).equals(exittime_list.get(team_list.indexOf(request.getParameter("team"))).substring(3)) ? "selected" : ""):((Integer.toString(i)).equals(exittime_list.get(team_list.indexOf(request.getParameter("team"))).substring(3)) ? "selected" : ""	)
									) : ""%>><%=i<10 ? "0"+Integer.toString(i) : i %> 분
									<%
								}
							%>
						</select>
					</td>
				</tr>
			</table>
			<input type="button" value="저장" onclick="fx_update_team()">
		</div>
		
		<!-- @@@@@-@@@@@  -->
		
		<!-- @@@@@프로그램관리@@@@@ -->
		<!-- 프로그램 생성 -->
		<div class="master_content" id="create_program">
			<h4 class="content_title">프로그램 생성</h4>
			/////////////
		</div>
		
		<!-- 프로그램 수정 -->
		<div class="master_content" id="update_program">
			<h4 class="content_title">프로그램 수정</h4>
			/////////////
		</div>
		
		<!-- 프로그램 삭제 -->
		<div class="master_content" id="delete_program">
			<h4 class="content_title">프로그램 삭제</h4>
			/////////////
		</div>
		<!-- @@@@@-@@@@@ -->
		
		
		
		<!-- @@@@@결산관리@@@@@ -->
		<!-- 근무시간 결산 -->
		<div class="master_content" id="worktime_result">
			<h4 class="content_title">근무시간 결산</h4>
			/////////////
		</div>
		<!-- 시급 입력 -->
		<div class="master_content" id="time_salary">
			<h4 class="content_title">시급 입력</h4>
			/////////////
		</div>
		<!-- 급여 정산 -->
		<div class="master_content" id="salary_result">
			<h4 class="content_title">급여 정산</h4>
			/////////////
		</div>
		<!-- @@@@@-@@@@@ -->
	</form>
</section>
<%@ include file="../footer.jsp" %>
<script src="master.js"></script>
</body>
</html>
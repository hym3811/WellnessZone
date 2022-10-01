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
				var cnt = 3;
				var possi = <%=session.getAttribute("possi")%>
				if(!possi){
					while(true){
						if(prompt('비밀번호 입력하세요.')!=pass){
							cnt--;
							alert("비밀번호 불일치\n"+cnt+"회 남음");
						}else{
							break;
							<%
								session.setAttribute("possi", true);
							%>
						}
						if(cnt==0){
							break;
						}
					}
					if(cnt==0){
						history.back();
					}
				}
				</script>
				<%
			}
		}
	}catch(Exception e){
		e.printStackTrace();
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
			joindate_list.add(rs.getString(6));	script_joindate+=rs.getString(6)+" ";
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script>
let id_list = '<%=script_id%>'.split(" ");
let pass_list = '<%=script_pass%>'.split(" ");
let name_list = '<%=script_name%>'.split(" ");
let rank_list = '<%=script_rank%>'.split(" ");
let position_list = '<%=script_position%>'.split(" ");
let joindate_list = '<%=script_joindate%>'.split(" ");
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
					<input class="master_btn" type="button" value="계정 삭제" onclick="view_page('delete_account')">
				</td>
				<td class="main_ctg" style="letter-spacing:4px;border-left:1px dashed black;">근무조관리</td>
				<td>
					<input class="master_btn" type="button" value="근무조 생성" onclick="view_page('create_team')">
					<input class="master_btn" type="button" value="근무조 수정" onclick="view_page('update_team')">
					<input class="master_btn" type="button" value="근무조 삭제" onclick="view_page('delete_team')">
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
		<!-- 계정생성 -->
		<div class="master_content" id="select_account">
			<h4 class="content_title">계정 목록</h4>
			<table>
				<tr>
					<th>No.</th>
					<th>아이디</th>
					<th>이름</th>
					<th>직급</th>
					<th>직책</th>
					<th>입사일</th>
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
						</tr>
						<%
					}
				%>
			</table>
		</div>
		<!-- 계정생성 -->
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
		
		<!-- 계정수정 -->
		<div class="master_content" id="update_account">
			<h4 class="content_title">계정 수정</h4>
			/////////////
		</div>
		
		<!-- 계정삭제 -->
		<div class="master_content" id="delete_account">
			<h4 class="content_title">계정 삭제</h4>
			/////////////
		</div>
		<!-- @@@@@-@@@@@ -->
		
		
		
		<!-- @@@@@근무조관리@@@@@ -->
		<!-- 근무조 생성 -->
		<div class="master_content" id="create_team">
			<h4 class="content_title">근무조 생성</h4>
			/////////////
		</div>
		
		<!-- 근무조 수정 -->
		<div class="master_content" id="update_team">
			<h4 class="content_title">근무조 수정</h4>
			/////////////
		</div>
		
		<!-- 근무조 삭제 -->
		<div class="master_content" id="delete_team">
			<h4 class="content_title">근무조 삭제</h4>
			/////////////
		</div>
		<!-- @@@@@-@@@@@ -->
		
		
		
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
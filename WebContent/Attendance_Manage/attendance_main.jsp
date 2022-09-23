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
	
	try{
		String sql = "select sysdate from dual";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if(rs.next()){
			today = rs.getString(1).substring(0,10);
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	String year = today.substring(0,4);
	String month = today.substring(5,7);
	String day = today.substring(8,10);
	
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
	
	String[] id = new String[size];
	String[] name = new String[size];
	String[] position = new String[size];
	String[] enter = new String[size];
	String[] exit = new String[size];
	String[] pass = new String[size];
	
	try{
		String sql = "select a.id,b.name,b.position,a.enter,a.exit,b.pass from wellness_work a join wellness_account b on a.id=b.id where year=? and month=? and day=? and work<1";
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
			enter[i] = rs.getString(4);
			exit[i] = rs.getString(5);
			pass[i] = rs.getString(6);
			
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
				for(int i=0;i<size;i++){
					%>
						<tr>
							<td style="width:150px;"><%=position[i] %></td>
							<td style="width:150px;"><%=name[i] %></td>
							<td style="width:300px;">
								<%
									if(enter[i]==null){
										%>
											비밀번호 : <input type="password" name="enter_<%=id[i]%>">
											<input type="button" value="출근" onclick="if(document.form.enter_<%=id[i] %>.value!=<%=pass[i] %>){alert('비밀번호 틀림');return false;}else{location.href='attendance_save_Process.jsp?ctg=enter&id=<%=id[i]%>&year=<%=year%>&month=<%=month%>&day=<%=day%>'}">
										<%
									}else{
										%><%=enter[i].substring(11,19)%><%
									}
								%>
							</td>
							<td style="width:300px;">
								<%
									if(exit[i]==null){
										if(enter[i]!=null){
											%>
												비밀번호 : <input type="password" name="exit_<%=id[i]%>">
												<input type="button" value="퇴근" onclick="if(document.form.exit_<%=id[i] %>.value!=<%=pass[i] %>){alert('비밀번호 틀림');return false;}else{location.href='attendance_save_Process.jsp?ctg=exit&id=<%=id[i]%>&year=<%=year%>&month=<%=month%>&day=<%=day%>'}">
											<%
										}else{
											%>
											출근 정보 등록 필요
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
			%>
		</table>
	</form>
</section>
<%@ include file="../footer.jsp" %>
<%
	Close.close(pstmt);
	Close.close(rs);
%>
</body>
</html>
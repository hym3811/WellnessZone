<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%session.invalidate(); %>
<form name="form" method="post">
	<div class="login">
		<h1 style="text-align:center;">Wellness Zone</h1>
		<h1 style="text-align:center;">통합관리 시스템</h1>
		<div class="login_line" style="margin-top:20px;">
			<div class="login_lbl">아이디</div><div><input class="login_input" type="password" name="id"></div>
		</div>
		<div class="login_line">
			<div class="login_lbl">비밀번호</div><div><input class="login_input" type="password" name="pass"></div>
		</div>
		<div>
			<div class="login_btn" onclick="login()">로그인</div>
		</div>
	</div>
</form>
<script>
function login(){
	var doc = document.form;
	
	if(doc.id.value==""){
		alert("아이디를 입력하세요.");
		doc.id.focus();
		return false;
	}
	if(doc.pass.value==""){
		alert("비밀번호를 입력하세요.");
		doc.pass.focus();
		return false;
	}
	
	doc.action = "login_process.jsp";
	doc.submit();
}
</script>
</body>
</html>
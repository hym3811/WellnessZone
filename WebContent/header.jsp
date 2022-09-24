<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String login_id = (String) session.getAttribute("login_id");
	String login_name = (String) session.getAttribute("login_name");
%>
	<header>
		<h1>Wellness Zone</h1>
		<div style="width:350px;height:100px;position:absolute;right:0;top:0;background-color:black;">
			<div class = "header_name"><%=login_name %><label style="font-size:0.6em;"> 님 접속중...</label></div>
			<div class = "header_clock"></div>
		</div>
	</header>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
<script>
	
const clock = document.querySelector('.header_clock');


function getTime(){
    var time = new Date();
    var hour = time.getHours();
    var minutes = time.getMinutes();
    var seconds = time.getSeconds();
    var pm = false;
    
    if(hour<10){
    	hour = "0"+hour.toString();;
    }else if(hour>12){
    	hour = hour-12;
    	pm = true;
    	if(hour<10){
    		hour = "0"+hour.toString();
    	}
    }
    
    if(minutes<10){
    	minutes = "0"+minutes.toString();
    }
    if(seconds<10){
    	seconds = "0"+seconds.toString();
    }
    
    if(pm){
    	clock.innerHTML = hour +" : " + minutes + " : " + seconds + " (오후)";
    }else{
    	clock.innerHTML = hour +" : " + minutes + " : " + seconds + " (오전)";
    }
    
    
}


function init(){
    setInterval(getTime, 1000);
}

init();
	
</script>
</body>
</html>
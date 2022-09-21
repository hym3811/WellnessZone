function year(i){
	var doc = document.form;
	
	var year = parseInt(doc.year.value)+i;
	var month = doc.month.value;
	
	if(year<0){
		alert('년도는 0보다 작을수 없습니다.');
		return false;
	}
	
	location.href="work_schedule_main.jsp?year="+year+"&month="+month;
}
function month(i){
	var doc = document.form;
	
	var year = doc.year.value;
	var month = parseInt(doc.month.value)+i;
	
	if(month<1||month>12){
		alert('월은 1월~12월 범위내에서 조회해주세요.');
		return false;
	}
	
	location.href="work_schedule_main.jsp?year="+year+"&month="+month;
}

function personal_year(i,a,b){
	var doc = document.form;
	
	var year = parseInt(doc.year.value)+i;
	var month = doc.month.value;
	
	if(year<0){
		alert('년도는 0보다 작을수 없습니다.');
		return false;
	}
	
	location.href="personal_schedule.jsp?id="+a+"&name="+b+"&year="+year+"&month="+month;
}
function personal_month(i,a,b){
	var doc = document.form;
	
	var year = doc.year.value;
	var month = parseInt(doc.month.value)+i;
	
	if(month<1||month>12){
		alert('월은 1월~12월 범위내에서 조회해주세요.');
		return false;
	}
	
	location.href="personal_schedule.jsp?id="+a+"&name="+b+"&year="+year+"&month="+month;
}

function year_btn(){
	$('#year_select').css({
		"text-shadow": "2px 2px 0px gray",
		"transition":"0.3s"
	});
}
function year_btn2(){
	$('#year_select').css({
		"text-shadow": "none",
		"transition":"0.3s"
	});
}

$("#year_btn1").mouseover(function(){
	year_btn();
});
$("#year_btn2").mouseover(function(){
	year_btn();
});
$("#year_btn1").mouseout(function(){
	year_btn2();
});
$("#year_btn2").mouseout(function(){
	year_btn2();
});

function month_btn(){
	$('#month_select').css({
		"text-shadow": "2px 2px 0px gray",
		"transition":"0.3s"
	});
}
function month_btn2(){
	$('#month_select').css({
		"text-shadow": "none",
		"transition":"0.3s"
	});
}

$("#month_btn1").mouseover(function(){
	month_btn();
});
$("#month_btn2").mouseover(function(){
	month_btn();
});
$("#month_btn1").mouseout(function(){
	month_btn2();
});
$("#month_btn2").mouseout(function(){
	month_btn2();
});
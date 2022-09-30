function year(i){
	var doc = document.form;
	
	var year = parseInt(doc.year.value)+i;
	var month = doc.month.value;
	
	if(year<0){
		alert('년도는 0보다 작을수 없습니다.');
		return false;
	}
	
	location.href="attendance_main.jsp?year="+year+"&month="+month;
}
function month(i){
	var doc = document.form;
	
	var year = doc.year.value;
	var month = parseInt(doc.month.value)+i;
	
	if(month<1||month>12){
		alert('월은 1월~12월 범위내에서 조회해주세요.');
		return false;
	}
	
	location.href="attendance_main.jsp?year="+year+"&month="+month;
}
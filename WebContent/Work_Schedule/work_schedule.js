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

function day_year(i){
	var doc = document.form;
	
	var year = parseInt(doc.year.value)+i;
	var month = doc.month.value;
	var day = doc.day.value;
	
	if(year<0){
		alert('년도는 0보다 작을수 없습니다.');
		return false;
	}
	
	location.href="day_schedule.jsp?year="+year+"&month="+month+"&day="+day;
}
function day_month(i){
	var doc = document.form;
	
	var year = doc.year.value;
	var month = parseInt(doc.month.value)+i;
	var day = doc.day.value;
	
	if(month<1||month>12){
		alert('월은 1월~12월 범위내에서 조회해주세요.');
		return false;
	}
	
	location.href="day_schedule.jsp?year="+year+"&month="+month+"&day="+day;
}
function day_day(i){
	var doc = document.form;
	
	var year = doc.year.value;
	var month = doc.month.value;
	var day = parseInt(doc.day.value)+i;
	
	if(day<1||day>size){
		alert('일은 1일~'+size+'일 범위내에서 조회해주세요.');
		return false;
	}
	
	location.href="day_schedule.jsp?year="+year+"&month="+month+"&day="+day;
}

function day_btn(){
	$('#day_select').css({
		"text-shadow": "2px 2px 0px gray",
		"transition":"0.3s"
	});
}
function day_btn2(){
	$('#day_select').css({
		"text-shadow": "none",
		"transition":"0.3s"
	});
}

$("#day_btn1").mouseover(function(){
	day_btn();
});
$("#day_btn2").mouseover(function(){
	day_btn();
});
$("#day_btn1").mouseout(function(){
	day_btn2();
});
$("#day_btn2").mouseout(function(){
	day_btn2();
});

$("#year_select").click(function(){
	$("#year_select").css({
		"display":"none"
	})
})
$("#month_select").click(function(){
	$("#month_select").css({
		"display":"none"
	})
	
})

for(let i=0;i<31;i++){
	$("input[name='work_"+i+"']").change(function(){
		if(this.value<1){
			$("select[name='team_"+i+"'").css({
				"display":"block"
			})
			$("#time_"+i).css({
				"display":"block"
			})
		}else{
			$("select[name='team_"+i+"'").css({
				"display":"none"
			})
			$("#time_"+i).css({
				"display":"none"
			})
		}
		if(this.value==0.5){
			$("select[name='harf_"+i+"'").css({
				"display":"block"
			})
		}else{
			$("select[name='harf_"+i+"'").css({
				"display":"none"
			})
		}
	});
}

if(document.form.day_id_size.value!=""&&document.form.day_id_size.value!=null){
	var day_id_size = document.form.day_id_size.value;
	var day_id_list = document.form.id_list.value.split(" ");
}
for(let i=0;i<day_id_size;i++){
	$("input[name='"+day_id_list[i]+"_work']").change(function(){
		if(this.value<1){
			$("select[name='"+day_id_list[i]+"_team']").css({
				"display":"block",
				"position":"absolute",
				"right":"130px",
				"top":"5px"
			})
		}else{
			$("select[name='"+day_id_list[i]+"_team']").css({
				"display":"none"
			})
		}
		if(this.value==0.5){
			$("select[name='"+day_id_list[i]+"_harf']").css({
				"display":"block",
				"position":"absolute",
				"right":"60px",
				"top":"5px"
			})
		}else{
			$("select[name='"+day_id_list[i]+"_harf']").css({
				"display":"none"
			})
		}
	})
}
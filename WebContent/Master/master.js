function view_page(string){
	
	hide_all();hide_all();
	
	var page_val = $('#'+string);
	page_val.css({
		"display":"block"
	})
}

function hide_all(){
	$('#select_account').css({"display":"none"});
	$('#create_account').css({"display":"none"});
	$('#update_account').css({"display":"none"});
	$('#delete_account').css({"display":"none"});
	$('#create_team').css({"display":"none"});
	$('#update_team').css({"display":"none"});
	$('#delete_team').css({"display":"none"});
	$('#create_program').css({"display":"none"});
	$('#update_program').css({"display":"none"});
	$('#delete_program').css({"display":"none"});
	$('#worktime_result').css({"display":"none"});
	$('#salary_result').css({"display":"none"});
	$('#time_salary').css({"display":"none"});
}

var check_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
var check_eng = /[a-z|A-Z]/;
var check_num = /[0,1,2,3,4,5,6,7,8,9]/

function fx_create_account(){
	var doc = document.form;
	
	//이름 유효성 검사
	if(doc.create_account_name.value==""){
		alert("이름을 입력하세요.");
		doc.create_account_name.focus();
		return false;
	}
	if(check_num.test(doc.create_account_name.value)){
		alert("이름은 숫자가 포함될 수 없습니다.");
		doc.create_account_name.focus();
		return false;
	}
	if(check_kor.test(doc.create_account_name.value)){
		if(doc.create_account_name.value.length>4){
			alert("한글이름은 4글자 이하로 입력하세요.");
			doc.create_account_name.focus();
			return false;
		}
	}else{
		if(doc.create_account_name.value.length>12){
			alert("영어이름은 12글자 이하로 입력하세요.");
			doc.create_account_name.focus();
			return false;
		}
	}
	
	//아이디 유효성 검사
	for(let i=0;i<id_list.length;i++){
		if(id_list[i]==doc.create_account_id.value){
			alert("아이디가 중복됩니다.");
			doc.create_account_id.focus();
			return false;
			break;
		}
	}
	if(doc.create_account_id.value==""){
		alert("아이디를 입력하세요.");
		doc.create_account_id.focus();
		return false;
	}
	if(check_kor.test(doc.create_account_id.value)){
		alert("아이디는 한글을 포함할 수 없습니다.");
		doc.create_account_id.focus();
		return false;
	}
	if(!check_eng.test(doc.create_account_id.value)||!check_num.test(doc.create_account_id.value)){
		alert('아이디는 영어와 숫자를 조합해야합니다.');
		doc.create_account_id.focus();
		return false;
	}else{
		if(doc.create_account_id.value.length>12){
			alert("아이디는 12자리 이하로 입력하세요.");
			doc.create_account_id.focus();
			return false;
		}
	}
	
	//비밀번호 유효성 검사
	if(doc.create_account_pass.value==""){
		alert("비밀번호를 입력하세요.");
		doc.create_account_pass.focus();
		return false;
	}
	if(check_kor.test(doc.create_account_pass.value)){
		alert("비밀번호는 한글을 포함할 수 없습니다.");
		doc.create_account_pass.focus();
		return false;
	}
	if(!check_eng.test(doc.create_account_pass.value)||!check_num.test(doc.create_account_pass.value)){
		alert('비밀번호는 영어와 숫자를 조합해야합니다.');
		doc.create_account_pass.focus();
		return false;
	}else{
		if(doc.create_account_id.value.length>12){
			alert("비밀번호는 12자리 이하로 입력하세요.");
			doc.create_account_pass.focus();
			return false;
		}
	}
	
	//비번 확인 유효성 검사
	if(doc.create_account_check.value==""){
		alert("비번확인를 입력하세요.");
		doc.create_account_check.focus();
		return false;
	}
	if(check_kor.test(doc.create_account_check.value)){
		alert("비번확인는 한글을 포함할 수 없습니다.");
		doc.create_account_check.focus();
		return false;
	}
	if(!check_eng.test(doc.create_account_check.value)||!check_num.test(doc.create_account_check.value)){
		alert('비번확인는 영어와 숫자를 조합해야합니다.');
		doc.create_account_check.focus();
		return false;
	}else{
		if(doc.create_account_id.value.length>12){
			alert("비번확인는 12자리 이하로 입력하세요.");
			doc.create_account_check.focus();
			return false;
		}
	}
	
	//비번,비번확인 일치
	if(doc.create_account_pass.value!=doc.create_account_check.value){
		alert("비밀번호와 비번확인이 일치하지 않습니다.");
		doc.create_account_check.focus();
		return false;
	}
	
	//직급 유효성 검사
	if(doc.create_account_rank.value==""){
		alert("직급을 선택하세요.");
		doc.create_account_rank.focus();
		return false;
	}
	
	//직책 유효성 검사
	if(doc.create_account_position.value==""){
		alert("직책을 입력하세요.");
		doc.create_account_position.focus();
		return false;
	}
	
	doc.action="create_account_process.jsp";
	doc.submit();
}
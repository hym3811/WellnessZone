<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "DB.jsp"%>
<%@ page import = "java.util.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String login_id = request.getParameter("id");
	String pass = request.getParameter("pass");
	try{
		//계정 일치 확인
		String sql = "select pass from wellness_account where id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, login_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String pass_check = rs.getString(1);
			
			//비밀번호 틀림
			if(pass.equals(pass_check)==false){
				%>
				<script>
					alert("비밀번호가 틀렸습니다.");
					history.back();
				</script>
				<%
			//비밀번호 일치 => 로그인 성공
			}else{
				
				session.setAttribute(login_id, "login_id");
				
				%>
				<script>
				alert("로그인 성공");
				</script>
				<%
				
				//오늘 날짜 조회
				sql = "select sysdate from dual";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()){
					String now = rs.getString(1).substring(0,10);
					
					String year = now.substring(0,4); //당해
					String month = now.substring(5,7); //당월
					String day = now.substring(8,10); //당일
					
					//년도,월이 일치하는 데이터가 있는지 확인
					sql = "select year from wellness_work where year=? and month=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, year);
					pstmt.setString(2, month);
					rs = pstmt.executeQuery();
					
					//있으면 당월 테이블 생성되어있으므로 로그인 성공
					if(rs.next()){
						%>
						<script>
						location.href="Timestamp/timestamp_main.jsp";
						</script>
						<%
						
					//없으면 당월 테이블이 없으므로 당월 테이블 생성함
					}else{
						int i=1;	// 오늘 날짜의 일수에 더할 변수
						ArrayList<String> account = new ArrayList<String>();	// 마스터 계정을 제외한 계정의 id 리스트
						
						sql = "select id from wellness_account where rank>1";
						pstmt = conn.prepareStatement(sql);
						rs=pstmt.executeQuery();
						while(rs.next()){
							account.add(rs.getString(1));
						}
						
						while(true){
							// i변수를 더한 날짜와 그 날짜의 요일을 받아옴
							sql = "select sysdate+"+i+",to_char(sysdate+"+i+",'d') from dual";
							pstmt = conn.prepareStatement(sql);
							rs = pstmt.executeQuery();
							
							String temp = null; // i변수를 더한 날짜
							int week = 0; // 요일 값을 받아올 변수
							if(rs.next()){
								temp = rs.getString(1);
								week = rs.getInt(2);

								if(temp.subSequence(5, 7).equals(month)==false){ //월이 달라지면 break
									break;
								}else{
									
									for(int j = 0; j < account.size(); j++){ //아이디의 개수만큼 반복
										sql = "insert into wellness_work values(?,?,?,?,?,'','',?)";
										pstmt = conn.prepareStatement(sql);
										pstmt.setString(1, year);
										pstmt.setString(2, month);
										pstmt.setInt(3, Integer.parseInt(day)+i);
										pstmt.setInt(4, week);
										pstmt.setString(5, account.get(j));
										switch(week){
										case 2:
										case 3:
										case 4:
										case 5:
										case 6:
										case 7:
											pstmt.setString(6, "0");
											break;
										case 1:
											pstmt.setString(6, "1");
											break;
										}
										pstmt.executeUpdate();
									}
								}
							}
							i++;
						}
						%>
						<script>
						location.href="Timestamp/timestamp_main.jsp";
						</script>
						<%
					}
				}
				
			}
		}else{
			%>
			<script>
			alert('아이디가 존재하지 않습니다.');
			history.back();
			</script>
			<%
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
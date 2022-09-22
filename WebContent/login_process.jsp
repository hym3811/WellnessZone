<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "DB.jsp"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java_class.Close" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String login_id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String login_name = null;
	try{
		//계정 일치 확인
		String sql = "select pass,name from wellness_account where id=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, login_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			String pass_check = rs.getString(1);
			login_name = rs.getString(2);
			
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
				
				session.setAttribute("login_id",login_id);
				session.setAttribute("login_name",login_name);
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
					
					//있으면 당일 정보 생성되어있으므로 로그인 성공
					if(rs.next()){
						Close.close(pstmt);
						Close.close(rs);
						session.setAttribute(login_id, "id");
						%>
						<script>
						location.href="Timestamp/timestamp_main.jsp";
						</script>
						<%
						
					//없으면 당월 테이블이 없으므로 당월 테이블 생성함
					}else{
						ArrayList<String> account = new ArrayList<String>();	// 마스터 계정을 제외한 계정의 id 리스트
						
						sql = "select id from wellness_account where rank>1";
						pstmt = conn.prepareStatement(sql);
						rs=pstmt.executeQuery();
						while(rs.next()){
							account.add(rs.getString(1));
						}
						
						sql = "select sysdate,to_char(sysdate,'d') from dual";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						
						String temp = null; // 날짜 변수
						int week = 0; // 요일 값을 받아올 변수
						
						if(rs.next()){
							System.out.println(rs.getString(1));
							temp = rs.getString(1).substring(8,10);
							week = rs.getInt(2);

							for(int j = 0; j < account.size(); j++){ //아이디의 개수만큼 반복
								
								sql = "select id from wellness_work where year=? and month=? and day=? and id=?";
								pstmt = conn.prepareStatement(sql);
								pstmt.setString(1, year);
								pstmt.setString(2, month);
								pstmt.setString(3, temp);
								pstmt.setString(4, account.get(j));
								rs = pstmt.executeQuery();
								
								if(!rs.next()){ // 조회값이 없으면 근무표에 아이디 생성 요일에 따라 디폴트값 다름
									sql = "insert into wellness_work values(?,?,?,?,'','',?)";
									pstmt = conn.prepareStatement(sql);
									pstmt.setString(1, year);
									pstmt.setString(2, month);
									pstmt.setString(3, temp);
									pstmt.setString(4, account.get(j));
									switch(week){
									case 2:
										pstmt.setString(5, "0");
										break;
									case 3:
										pstmt.setString(5, "0");
										break;
									case 4:
										pstmt.setString(5, "0");
										break;
									case 5:
										pstmt.setString(5, "0");
										break;
									case 6:
										pstmt.setString(5, "0");
										break;
									case 7:
										pstmt.setString(5, "0");
										break;
									case 1:
										pstmt.setString(5, "1");
										break;
									}
									pstmt.executeUpdate();
								}
							}
						}
					
						Close.close(pstmt);
						Close.close(rs);
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="DB.jsp"%>
<%@ page import="java_class.Close"%>
<%@ page import = "java.util.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		String year = "2022";
		String month = "11";
		int i=0;	// 오늘 날짜의 일수에 더할 변수
		ArrayList<String> account = new ArrayList<String>();	// 마스터 계정을 제외한 계정의 id 리스트
		
		String sql = "select id from wellness_account where rank>1";
		pstmt = conn.prepareStatement(sql);
		rs=pstmt.executeQuery();
		while(rs.next()){
			account.add(rs.getString(1));
		}
		
		String start = year+"-"+month+"-01";
		
		while(true){
			// i변수를 더한 날짜와 그 날짜의 요일을 받아옴
			sql = "select trunc(to_date('"+start+"','yyyy-mm-dd'),'mm')+"+i+",to_char(trunc(to_date('"+start+"','yyyy-mm-dd'),'mm')+"+i+",'d') from dual";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			String temp = null; // i변수를 더한 날짜
			int week = 0; // 요일 값을 받아올 변수
			if(rs.next()){
				temp = rs.getString(1);
				week = rs.getInt(2);
				
				if(temp.substring(5,7).equals(month)==false){ //월이 달라지면 break
					break;
				}else{
					
					for(int j = 0; j < account.size(); j++){ //아이디의 개수만큼 반복
						sql = "insert into wellness_work values(?,?,?,?,?,'','',?)";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, year);
						pstmt.setString(2, month);
						pstmt.setInt(3, 1+i);
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
		}System.out.println("완료");
	}catch(Exception e){
		e.printStackTrace();
	}

	Close.close(pstmt);
	Close.close(rs);
%>
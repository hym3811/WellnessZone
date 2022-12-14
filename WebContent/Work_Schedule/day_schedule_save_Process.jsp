<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../DB.jsp"%>
<%@ page import = "java_class.Close"%>
<%@ page import = "java.util.*" %>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int day = Integer.parseInt(request.getParameter("day"));
	String[] id = request.getParameter("id_list").split(" ");
	String[] work = new String[id.length];
	String[] team = new String[id.length];
	String[] harf = new String[id.length];
	for(int i=0;i<id.length;i++){
		work[i] = request.getParameter(id[i]+"_work");
		team[i] = request.getParameter(id[i]+"_team");
		harf[i] = request.getParameter(id[i]+"_harf");
	}
	
	System.out.println(Arrays.toString(id));
	System.out.println(Arrays.toString(work));
	
	try{
		for(int i=0;i<id.length;i++){
			String sql = "select work from wellness_work where year=? and month=? and day=? and id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, year);
			pstmt.setInt(2, month);
			pstmt.setInt(3, day);
			pstmt.setString(4, id[i]);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				sql = "update wellness_work set work=?,team=?,harf=? where year=? and month=? and day=? and id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, work[i]);
				if(Float.parseFloat(work[i])<1){
					pstmt.setString(2, team[i]);
					pstmt.setString(3, harf[i]);
				}else{
					pstmt.setString(2, "");
					pstmt.setString(3, "");
				}
				pstmt.setInt(4, year);
				pstmt.setInt(5, month);
				pstmt.setInt(6, day);
				pstmt.setString(7, id[i]);
				pstmt.executeUpdate();
				
			}else{
				if(work[i]!=null){pstmt.close();
					sql = "insert into wellness_work values(?,?,?,?,?,'','',?,?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, year);
					pstmt.setInt(2, month);
					pstmt.setInt(3, day);
					pstmt.setString(4, id[i]);
					pstmt.setString(5, team[i]);
					pstmt.setString(6, work[i]);
					pstmt.setString(7, harf[i]);
					pstmt.executeUpdate();
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		%>
		<script>
			alert("????????? ???????????? ????????? ??? ????????????.");
			history.back();
		</script>
		<%
	}
	Close.close(pstmt);
	Close.close(rs);
%>
<script>
location.href="work_schedule_main.jsp?year=<%=year%>&month=<%=month%>";
</script>
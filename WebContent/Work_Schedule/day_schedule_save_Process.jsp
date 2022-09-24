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
	for(int i=0;i<id.length;i++){
		work[i] = request.getParameter(id[i]+"_work");
		team[i] = request.getParameter(id[i]+"_team");
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
				sql = "update wellness_work set work=?,team=? where year=? and month=? and day=? and id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, work[i]);
				pstmt.setString(2, team[i]);
				pstmt.setInt(3, year);
				pstmt.setInt(4, month);
				pstmt.setInt(5, day);
				pstmt.setString(6, id[i]);
				pstmt.executeUpdate();
				
			}else{
				if(work[i]!=null){pstmt.close();
					sql = "insert into wellness_work values(?,?,?,?,?,'','',?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, year);
					pstmt.setInt(2, month);
					pstmt.setInt(3, day);
					pstmt.setString(4, id[i]);
					pstmt.setString(5, team[i]);
					pstmt.setString(6, work[i]);
					pstmt.executeUpdate();
				}
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		%>
		<script>
			alert("오류가 발생해서 처리할 수 없습니다.");
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
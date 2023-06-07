<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<link href="style.css" rel="stylesheet" type="text/css">
<title>개별수강 이력</title>
</head>
<body>
	<%@include file="user.jsp"%>
	<%@ include file="top.jsp"%>
	<%
	if (session_id == null)
		response.sendRedirect("login.jsp");
	%>
	<br>
	<br>
	<br>
	<table width="70%" align="center" class = "deleteTable" border>
		<br>
		<tr>
			<th>수업번호</th>
			<th>과목명</th>
			<th>학년도</th>
			<th>학기</th>
			<th>학점</th>
		</tr>
		<%
		Connection myConn = null;
		Statement stmt = null;
		ResultSet myResultSet = null;
		String mySQL = "";
		int totalnum = 0;
		int totalnum2 = 0;
		
		PreparedStatement pstmt = null;
		int nYear = 0;
		int nSemester = 0;

		String dbdriver = "oracle.jdbc.OracleDriver";
		String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "leebk";
		String passwd = "1124";

		try {
			Class.forName(dbdriver);
			myConn = DriverManager.getConnection(dburl, user, passwd);
			stmt = myConn.createStatement();
			
			CallableStatement cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
			cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
			cstmt.execute();
			nYear = cstmt.getInt(1)-2000;
			
			CallableStatement cstmt2 = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
			cstmt2.registerOutParameter(1, java.sql.Types.INTEGER);
			cstmt2.execute();
			nSemester = cstmt2.getInt(1);
			%>
			<script>document.getElementById('enrollS').innerHTML = "<%=nYear%>년  <%=nSemester%>학기";</script>
			<%
		} catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
		
		%>

		<div>
			<input type="text" id="enrollS" align="center" style="font-weight: bold;"
				value="<%= nYear %>년 <%= nSemester %>학기" readonly></input>
		</div>
	
		<br>
		<br>


	<%

		mySQL = "select e.c_id, c.c_name, e.e_year, e.e_semester, h.h_score FROM history h, course c, enroll e where h.e_id = e.e_id and e.c_id = c.c_id and e.c_id_no = c.c_id_no and s_id = '"
				+ session_id + "'";

		myResultSet = stmt.executeQuery(mySQL);

		if (myResultSet != null) {
			while (myResultSet.next()) {
				String c_id = myResultSet.getString("c_id");
				String c_name = myResultSet.getString("c_name");
				int e_year = myResultSet.getInt("e_year");
				int e_semester = myResultSet.getInt("e_semester");
				String h_score = myResultSet.getString("h_score");

				CallableStatement cstmt = myConn.prepareCall("{call MajorCount(?,?,?)}");
				cstmt.setString(1, session_id);
				cstmt.registerOutParameter(2, java.sql.Types.INTEGER);
				cstmt.registerOutParameter(3, java.sql.Types.INTEGER);

				try {
				cstmt.execute();
				totalnum = cstmt.getInt(2);
				totalnum2 = cstmt.getInt(3);
		%>
		<%
		} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
		}
		%>
		<tr>
			<td><%=c_id%></td>
			<td><%=c_name%></td>
			<td><%=e_year%></td>
			<td><%=e_semester%></td>
			<td><%=h_score%></td>

		</tr>
		<%
		}
		}
		stmt.close();
		myConn.close();
		%>
	</table>
	<br>
	<br>

<div id="CountInfo" align="center" style="font-weight: bold;">
		총 이수 학점 <br><br> 전공 :
		<%=totalnum%>학점 &nbsp;&nbsp; /  &nbsp;&nbsp; 교양 :
		<%=totalnum2%>학점 &nbsp;&nbsp;&nbsp;
	</div>
	
</body>
</html>


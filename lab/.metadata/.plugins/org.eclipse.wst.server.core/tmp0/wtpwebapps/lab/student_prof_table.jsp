<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<link href="style.css?after" rel="stylesheet" type="text/css">
<meta charset="UTF-8">
<title>신청학생 조회</title>
</head>
<body>
	<%@ include file="user.jsp"%>
	<%@ include file="top_prof.jsp"%>

	<%
	session_id = (String)session.getAttribute("user");
	String tid = request.getParameter("tid"); 
	String c_name = request.getParameter("cname");
	%>

	<br>
	<table width="70%" align="center" class="deleteTable" border>
		<br>
		<tr>
			<th>학번</th>
			<th>이름</th>
			<th>학년</th>
			<th>전공</th>
			<th>전화번호</th>
			<th>이메일</th>
		</tr>

		<%
	Connection Conn = null;
	Statement stmt = null;
	ResultSet rset = null;
	
	String mySQL = "";
	PreparedStatement pstmt = null;
	int nYear = 0;
	int nSemester = 0;
	
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "leebk";
	String passwd = "1124";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";  
	
	try {
		Class.forName(dbdriver);
		Conn = DriverManager.getConnection(dburl, user, passwd);
		Conn.setAutoCommit(false);
		stmt = Conn.createStatement();
		
		CallableStatement cstmt = Conn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
		cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt.execute();
		nYear = cstmt.getInt(1)-2000;
		
		CallableStatement cstmt2 = Conn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
		cstmt2.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt2.execute();
		nSemester = cstmt2.getInt(1);
		%>
		<script>document.getElementById('semesterInfo').innerHTML = "<%=nYear%>년  <%=nSemester%>
			학기";
		</script>
		<%
	} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	} catch (ClassNotFoundException ex) {
		System.err.println("ClassNotFoundException: " + ex.getMessage());
	} finally{
	      if(stmt != null)
		         try{Conn.commit(); stmt.close();
		         }catch(SQLException e){System.err.println("SQLException: " + e.getMessage());}
		   }
	%>

		<br>
		<br>

		<div>
			<input type="text" id="semesterInfo"
				value="<%= nYear %>년 <%= nSemester %>학기" readonly></input>
		</div>

		<br>
		<br>

		<div>
			<%=c_name%>
			신청 학생
		</div>

		<br>
		<br>

		<%
 	mySQL = "select s.s_id, s.s_name, s.s_grade, s.s_major, s.s_phone, s.s_email from teach t, student s, enroll e where t.t_id = '" + tid + "' and t.p_id ='"
 			 + session_id + "' and e.t_id= t.t_id and e.s_id = s.s_id and t.t_year = ? and t.t_semester = ?";
	System.out.println("include: " + tid);
	
	pstmt = Conn.prepareStatement(mySQL);
	pstmt.setInt(1, nYear);
	pstmt.setInt(2, nSemester);
	rset = pstmt.executeQuery();
  	
	
	while (rset.next()) {
		String sid = rset.getString("s_id");
		String sname = rset.getString("s_name");
		int sgrade = rset.getInt("s_grade");
		String smajor = rset.getString("s_major");
		String sphone = rset.getString("s_phone");
		String semail = rset.getString("s_email");

	%>

		<tr>
			<td><%=sid%></td>
			<td><%=sname%></td>
			<td><%=sgrade%></td>
			<td><%=smajor%></td>
			<td><%=sphone%></td>
			<td><%=semail%></td>

		</tr>
		<%
	} %>


	</table>
</body>
</html>
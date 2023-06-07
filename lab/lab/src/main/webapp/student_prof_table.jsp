<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<link href="style.css" rel="stylesheet" type="text/css">
<meta charset="UTF-8">
<title>수강신청 학생 조회</title>
</head>
<body>
	<%@ include file="user.jsp"%>
	<%@ include file="top_prof.jsp"%>
	<br>
	<br>
	<br>
	<%
	Connection myConn = null;
	Statement stmt = null;
	ResultSet rs = null;
	ResultSet enrollSet = null;

	String mySQL = "";
	String nSQL = "";

	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;

	int nYear = 0;
	int nSemester = 0;
	int nEnrollStudent = 0;


	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "leebk";
	String passwd = "1124";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";

	try {
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
		myConn.setAutoCommit(false);
		stmt = myConn.createStatement();

		CallableStatement cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
		cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt.execute();
		nYear = cstmt.getInt(1) - 2000;

		CallableStatement cstmt2 = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
		cstmt2.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt2.execute();
		nSemester = cstmt2.getInt(1);
	%>
	<script>document.getElementById('semesterInfo').innerHTML = "<%=nYear%>년  <%=nSemester%>학기";
	</script>
	<%
	} catch (SQLException ex) {
	System.err.println("SQLException: " + ex.getMessage());
	} catch (ClassNotFoundException ex) {
	System.err.println("ClassNotFoundException: " + ex.getMessage());
	} finally {
	if (stmt != null)
		try {
			myConn.commit();
			stmt.close();
		} catch (SQLException e) {
			System.err.println("SQLException: " + e.getMessage());
		}
	}
	%>

	<br>
	<br>

	<div>
		<input type="text" id="semesterInfo"
			value="<%=nYear%>년 <%=nSemester%>학기" readonly></input>
	</div>

	<br>
	<br>

	<div>
	
	
	<%-- <script>document.getElementByName('course')[0].value = '<%=t_id%>';</script> --%>
		
	<%
	String t_id = request.getParameter("t_id");
	
	System.out.println(t_id);
	mySQL = "select c.c_id, c.c_id_no, c.c_name, s.s_id, s.s_name, s.s_major, t.t_id, t.t_max from enroll e, course c, student s, teach t where t.t_id='"
			+ t_id
			+ "' and e.t_id = t.t_id and t.c_id = c.c_id and t.c_id_no = c.c_id_no and e.s_id = s.s_id and e_year = ? and e_semester = ?";
	pstmt = myConn.prepareStatement(mySQL);
	pstmt.setInt(1, nYear);
	pstmt.setInt(2, nSemester);
	rs = pstmt.executeQuery();
	%>
	<table width="70%" align="center" class="deleteTable" border>
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>과목명</th>
			<th>학번</th>
			<th>이름</th>
			<th>전공</th>
			<th>수강정원</th>
			<th>신청인원</th>
		</tr>
		<%
		while (rs.next()) {
			String cid = rs.getString("c_id");
			Integer cidno = rs.getInt("c_id_no");
			String cname = rs.getString("c_name");
			String sid = rs.getString("s_id");
			String sname = rs.getString("s_name");
			String smajor = rs.getString("s_major");
			/* String t_id = rs.getString("t_id"); */
			Integer tmax = rs.getInt("t_max");

			nSQL = "select COUNT(*) cnt from enroll where t_id = '" + t_id + "' and e_year = ? and e_semester = ?";
			pstmt2 = myConn.prepareStatement(nSQL);
			pstmt2.setInt(1, nYear);
			pstmt2.setInt(2, nSemester);
			enrollSet = pstmt2.executeQuery();

			if (enrollSet != null) {
				while (enrollSet.next()) {
			nEnrollStudent = enrollSet.getInt("cnt");
				}
			}
		%>

		<tr>
			<td><%=cid%></td>
			<td><%=cidno%></td>
			<td><%=cname%></td>
			<td><%=sid%></td>
			<td><%=sname%></td>
			<td><%=smajor%></td>
			<td><%=tmax%></td>
			<td><%=nEnrollStudent%></td>
		</tr>
		<%
		}
		%>
	</table>

</body>
</html>
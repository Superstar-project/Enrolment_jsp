<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>수강신청 입력</title>
</head>
<body>

	<%
	String s_id = (String) session.getAttribute("user");
	String c_id = request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	%>
	<%
	Connection myConn = null;
	String result = null;
	String driver = "oracle.jdbc.driver.OracleDriver";
	   String url = "jdbc:oracle:thin:@localhost:1521:xe";
	   String user = "leebk";
	   String password = "1124";

	try {
		Class.forName(driver);
	      myConn = DriverManager.getConnection(url, user, password);
	      myConn.setAutoCommit(false);
	} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	}
	CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");
	cstmt.setString(1, s_id);
	cstmt.setString(2, c_id);
	cstmt.setInt(3, c_id_no);
	System.out.println("gogogo");
	cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
	try {
		cstmt.execute();
		result = cstmt.getString(4);
		System.out.println("🎁🎁🎁🎁🎁🎁🎁"+result + s_id +"\n" + c_id +"\n"+  c_id_no );
	%>
	<script>
		alert('<%=result%>');
		location.href = "insert.jsp";
	</script>

	<%
	} catch (SQLException ex) {
	System.err.println("SQLException: " + ex.getMessage());
	} finally {
	if (cstmt != null)
		try {
			myConn.commit();
			cstmt.close();
			myConn.close();
		} catch (SQLException ex) {
		}
	}
	%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<%
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "kimminjoo";
	String passwd = "1234"; // 비밀번호
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	try {
		Class.forName(dbdriver);
		out.println("jdbc driver 로딩 성공");
		DriverManager.getConnection(dburl, user, passwd);
		out.println("오라클 연결 성공");
	} catch (ClassNotFoundException e) {
		System.out.println("driver 로딩 실패");
	} catch (SQLException e) {
		System.out.println("오라클 연결 실패");
	}
	%>
</body>
</html>
<%@page import="board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<% request.setCharacterEncoding("EUC-KR"); %>

<jsp:useBean id="article" class="board.BoardDataBean" >
<jsp:setProperty name="article" property="*"/>
</jsp:useBean>


<% System.out.println(article); %>
<%	
	BoardDBBean dbPro=BoardDBBean.getInstance(); //인스턴스 가져옴
	article.setIp(request.getRemoteAddr());
	//ip주소 form 에서 안넘어 오기 때문에 request로 받아줌
	dbPro.insertArticle(article);
	//db에 데이터 삽입하는 부분

%>

</body>
</html>
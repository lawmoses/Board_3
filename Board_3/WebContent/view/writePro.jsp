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
	BoardDBBean dbPro=BoardDBBean.getInstance(); //�ν��Ͻ� ������
	article.setIp(request.getRemoteAddr());
	//ip�ּ� form ���� �ȳѾ� ���� ������ request�� �޾���
	dbPro.insertArticle(article);
	//db�� ������ �����ϴ� �κ�

%>

</body>
</html>
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

<!-- 업데이트폼에서 수정한 것을 업데이트Pro가 받아서 DB에 저장  -->
<!-- 보드 데이터를 모두 리퀘스트해야해. writePro와 비슷하다. -->
<!-- 이것을 다 뜯어서 하나 하나 다 이해해야한다. 아니면 프로젝트 하지 못한다. -->

<% request.setCharacterEncoding("EUC-KR"); %>

<%
//boardid 어떤 게시판인지 구분되어 form에서 값이 넘어가야함
//boardid가 뭐지?
	String boardid=request.getParameter("boardid");
	if(boardid==null) boardid="1";
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null || pageNum == "") {
		pageNum = "1";	}
%>

<jsp:useBean id="article" class="board.BoardDataBean" >
<jsp:setProperty name="article" property="*"/>
</jsp:useBean>


<% System.out.println(article); %>
<%	
	BoardDBBean dbPro = BoardDBBean.getInstance(); //인스턴스 가져옴
	int chk = dbPro.updateArticle(article); %> 
<% 
	//db에 데이터 삽입하는 부분
	if (chk==1) {
%>

<meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum %>">
	
<% } else { %>	
 
<script>
alert("비밀번호가 맞지 않습니다");
history.go(-1);
</script>

<% } %>
</body>
</html>
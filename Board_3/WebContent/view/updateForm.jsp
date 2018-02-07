<%@page import="board.BoardDBBean"%>
<%@page import="board.BoardDataBean"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% String boardid = request.getParameter("boardid");
	if (boardid==null) boardid = "1";
	String pageNum = request.getParameter("pageNum");
		if(pageNum == null || pageNum == "") {
			pageNum = "1";
		}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	try{
		BoardDBBean dbPro = BoardDBBean.getInstance();
		BoardDataBean article = dbPro.getArticle(num, boardid, "update");
%>
<body>
<p class="w3-left" style="padding-left: 30px;"></p>
<div class="w3-container">

<center><b>글수정</b>
<br>
<%-- 나의 실수 <form method="post" name="writeform" action="<%=request.getContextPath()%>/view/writePro.jsp" > --%>
<form method="post" name="writeform" action="<%=request.getContextPath()%>/view/updatePro.jsp" >
<input type="hidden" name="boardid" value="<%=boardid %>">
<input type="hidden" name="num" value="<%=num %>">
<input type="hidden" name="pageNum" value="<%=pageNum %>">	

<!-- boardid의 값을 따로 입력받지 않음 -->
<table class="w3-table-all"  style="width:70%;" >
   <tr>
    <td align="right" colspan="2" >
	    <a href="list.jsp"> 글수정</a> 
   </td>
   </tr>
   <tr>
    <td  width="70"   align="center">이 름</td>
    <td  width="330">
       <input type="text" size="10" maxlength="10" name="writer" value="<%=article.getWriter() %>"></td>
  </tr>
  <tr>
    <td  width="70"   align="center" >제 목
    </td>
    <td width="330">
       <input type="text" size="40" maxlength="50" name="subject" value="<%=article.getSubject()%>"></td>
  </tr>
  <tr>
    <td  width="70"   align="center">Email</td>
    <td  width="330">
       <input type="text" size="40" maxlength="30" name="email" value="<%=article.getEmail()%>"></td>
  </tr>
  <tr>
    <td  width="70"   align="center" >내 용</td>
    <td  width="330" >
     <textarea name="content" rows="13" cols="40"><%=article.getContent() %> </textarea> </td>
  </tr>
  <tr>
    <td  width="70"   align="center" >비밀번호</td>
    <td  width="330" >
     <input type="password" size="8" maxlength="12" name="passwd" value="<%= article.getPasswd()%>"> </td>
  </tr>
<tr>      
 <td colspan=2  align="center"> 
  <input type="submit" value="글쓰기" >  
  <input type="reset" value="다시작성">
  <input type="button" value="목록보기" OnClick="window.location='list.jsp'">
</td></tr></table>    
     
</form>  </center>

</div>
<% 
	}catch (Exception e) {} %>
</body>
</html>
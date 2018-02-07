<%@page import="board.BoardDataBean"%>
<%@page import="board.BoardDBBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"></head>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<% request.setCharacterEncoding("euc-kr"); %>
<% 
	String boardid=request.getParameter("boardid");
	if(boardid==null) 
		boardid="1";
%>
<%
	int pageSize=5;
	//한 페이지에 보여줄 글 개수
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String pageNum=request.getParameter("pageNum");
	//페이지 번호
	if(pageNum==null||pageNum==""){
		pageNum="1";
		//처음에 들어올때는 1번이 뜸 (넘어오는 pageNum이 없기 때문에)
	}
	int currentPage=Integer.parseInt(pageNum);
	int startRow=(currentPage-1)*pageSize+1;
	//db에서 가져올 데이터의 열(currentPage에 노출되는 가장 윗글)
	int endRow=currentPage*pageSize;
	//db에서 가져올 데이터의 마지막 열 (currentPage에 노출되는 가장 아래 글)
	int count=0;
	int number=0;
	List articleList=null;
	//글을 list로 받아줌
	BoardDBBean dbPro=BoardDBBean.getInstance();
	//DBBean내 생성된 객체 instance의 주소 값
	count=dbPro.getArticleCount(boardid); 
	//총 게시글 개수
	if(count>0){
		articleList=dbPro.getArticles(startRow,endRow,boardid);
	}
	number=count-(currentPage-1)*pageSize;
	//가져올 글 중 가장 최신글의 글 번호(current)
%>
	<p class="w3-left" style="padding-left:30px;">
	</p>
	<div class="w3-container">
		<span class="w3-center w3-large">
			<h3><%=boardid %>(전체 글 : <%=count %>)
			</h3>
		</span>
		<p class="w3-right w3-padding-right-large">
			<a href="writeForm.jsp">글쓰기</a>
		</p>
		<%
			if(count==0){
		%>
			<table class="table-boarded" width="700">
				<tr class="w3-grey">
					<td align="center">게시판에 저장된 글이 없습니다.</td>
				</tr>
			</table>
		
		<%	}else{ %>
		<table class="w3-table-all" width="700">
			<tr class="w3-grey">
			<td align="center" width="50">번호</td>
			<td align="center" width="250">제목</td>
			<td align="center" width="100">작성자</td>
			<td align="center" width="150">작성일</td>
			<td align="center" width="50">조회</td>
			<td align="center" width="100">IP</td>
			</tr>
		<%
		for(int i=0;i<articleList.size();i++){
			BoardDataBean article=(BoardDataBean)articleList.get(i); 
			//for문 돌면서 list안의 글 다 가져옴  %>
			<tr height="30">
			<td align="center" width="50"><%=number--%></td>
			<!-- 글 번호 표시 -->
			<td width="250">
			<% 	//답글 부분	*ref >같은 그룹 , re_level >답글 단 게시물에 +1, re_step >프린트 순서
				//ㄴ> 댓글모양 서식
				int wid=0;
				if(article.getRe_level()>0){
					wid=5*(article.getRe_level());//re_level 0이면 0됨
			%>
				<img src="images/level.gif width=<%=wid%>" height="16">
			<%
				}
			%><a href= "content.jsp?num=<%=article.getNum() %>&pageNum=<%=currentPage %>">
			<%-- 글 제목 클릭 시 내용보기로 넘어감 --%>
			<%=article.getSubject() %></a>
			<%
				 if(article.getReadcount()>=20){
					//조회수가 20보다 클 때 
					%>
					<img src="image/hot.gif" border="0" height="16">
					<%} %></td>
					<td align="center" width="100"><%=article.getWriter() %></td>
					<!-- 글쓴이 출력 -->
					<td align="center" width="150">
            	    <%=sdf.format(article.getReg_date()) %></td>
            		<!-- 글쓴 날짜 출력 -->	    
					<td align="center" width="50"><%=article.getReadcount() %></td>
 					<!-- 조회수 출력 -->
					<td align="center" width="100"><%=article.getIp() %></td>
					<!-- ip 출력 -->
					</tr>
					<%
				}//for 반복문 종료. articleList size만큼 글 출력됨
			%></table><%
		}
	%>
	</div>
<!-- 게시글 목록 페이지 하단의 페이지 이동 부분 [1][2][3]  -->
	<div class="w3-center">
	<% int bottomLine=3;
		//노출되는 하단 페이지 수 
		if(count>0){	//count<전체글 개수
			int pageCount=count/pageSize+(count%pageSize==0?0:1);
			//pageSize<한 페이지에 보여줄 글 개수
			//pageCount<총 페이지의 개수

			int startPage=1+(currentPage-1)/bottomLine*bottomLine;
			//1,4,7.. 
			int endPage=startPage+bottomLine-1;
			//3,6,9...
			if(endPage>pageCount)
				endPage=pageCount;
			//startPage로 계산된 endPage가 전체 페이지수 보다 크면 endPage=pageCount로 설정해줌
			if(startPage>bottomLine){
				//[이전] <- 표시되는 시점
				%>
					<a href="list.jsp?pageNum=<%=startPage-bottomLine %>">[이전]</a>				
					<!-- [이전] 누르면 4,5,6 이면 > 1,2,3 으로 이동함 -->
					<!-- 페이지 번호를 pageNum(String)으로 넘겨줌>CurrentPage에 들어감-->
				<%}%>
				<% for(int i=startPage;i<=endPage;i++)
					{ 
					// 하단 [1][2][3] 프린트
					%>
					<a href="list.jsp?pageNum=<%=i %>">
					<!-- pageNum넘김 -->
					<%	//현재 페이지일 경우 붉은색 폰트
						if(i!=currentPage)
							out.print("["+i+"]");
						else out.print("<font color='red'>["+i+"]</font>");						
					%>
					</a>			
				<%}
				if(endPage<pageCount){%>
					<a href="list.jsp?pageNum=<%=startPage+bottomLine%>">[다음]</a>
				<%					
				}	
			}
		
		%>
</div>
</body>
</html>
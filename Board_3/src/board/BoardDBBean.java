package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

//db에 넣어주기만 하는 프로그램. 모든 유저가 글쓰기시 새로 인스턴스를 생성할 필요가 없음. 
//싱글턴방식

public class BoardDBBean {
	
	//싱글턴
	private static BoardDBBean instance=new BoardDBBean();
	private BoardDBBean() {
		//외부에서 생성할 수 없도록 생성자 private로 막아놓음
	}
	public static BoardDBBean getInstance() {
		//instance객체의 주소 반환
		return instance;
	}	
	//getConnection메서드 > connection객체를 이 객체에서 만든 다는 것
	
	
	//연결시켜주는 커넥션 메소드
	public static Connection getConnection(){
		Connection con=null;
		try {
			String jdbcUrl="jdbc:oracle:thin:@localhost:1521:orcl";
			String dbID="scott";
			String dbPass="tiger";
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con=DriverManager.getConnection(jdbcUrl, dbID, dbPass);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return con;
	}
	
	//게시글 추가 메소드
	public void insertArticle(BoardDataBean article) {
		//db 데이터 삽입 메서드
		String sql="";
		Connection con=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null; //?
		int number=0;
		try {//serial number 진행시키기 위한 sql문 <-num컬럼 
			pstmt=con.prepareStatement("select boardser.nextval from dual");
			rs=pstmt.executeQuery();
			if(rs.next())
				number=rs.getInt(1)+1;
			else
				number=1;
			
			sql="insert into board(num,writer,email,subject,passwd,reg_date,"
					+ "ref,re_step,re_level,content,ip,boardid)"
					+ "values(?,?,?,?,?,sysdate,?,?,?,?,?,?)";
			pstmt=con.prepareStatement(sql);
			
			pstmt.setInt(1, number);
			pstmt.setString(2, article.getWriter());
			pstmt.setString(3, article.getEmail());
			pstmt.setString(4, article.getSubject());
			pstmt.setString(5, article.getPasswd());
			pstmt.setInt(6, number);
			pstmt.setInt(7, 0);
			pstmt.setInt(8, 0);
			pstmt.setString(9, article.getContent());
			pstmt.setString(10, article.getIp());
			pstmt.setString(11, article.getBoardid());
			pstmt.executeUpdate();
			
		}catch(SQLException e1) {
			e1.printStackTrace();
			
		}finally {
			close(con,rs,pstmt);	
			//닫는 메서드
			//매개변수가 있어야함. 열어놓은 것들 달고 들어가야함
		}
	}
	
	
	
	//화요일 게시글 카운팅 메소드
	public int getArticleCount(String boardid) {
		int x=0;
		String sql="select nvl(count(*),0) "
				+ "from board where boardid=?";
		//* 안들어감
		Connection con=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int number=0;
		
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, boardid);
			
			rs=pstmt.executeQuery();
			if(rs.next()) {
				x=rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(con,rs,pstmt);
		}
		return x;
	}
	
	//게시글 가져오는 메소드
	public List getArticles(int startRow,int endRow,String boardid) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List articleList=null;
		String sql="";
		try {
			conn=getConnection();
			sql="select*from"
					+ "(select rownum rnum,a.* from"
					+ "(select num,writer,email,subject,passwd,"
					+ "reg_date,readcount,ref,re_step,re_level,content,"
					+ "ip from board where boardid=? order by ref desc,re_step)"
					+ "a) where rnum between ? and ?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, boardid);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				articleList=new ArrayList();
				do {
					BoardDataBean article=new BoardDataBean();
					
					article.setNum(rs.getInt("num"));
					article.setWriter(rs.getString("writer"));
					article.setEmail(rs.getString("email"));
					article.setSubject(rs.getString("subject"));
					article.setPasswd(rs.getString("passwd"));
					article.setReg_date(rs.getTimestamp("reg_date"));
					article.setReadcount(rs.getInt("readcount"));
					article.setRef(rs.getInt("ref"));
					article.setRe_step(rs.getInt("re_step"));
					article.setRe_level(rs.getShort("re_level"));
					article.setContent(rs.getString("content"));
					article.setIp(rs.getString("ip"));
					articleList.add(article);
				}while(rs.next());
			}
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			close(conn,rs,pstmt);
		}
		return articleList;	
	}
	
	//게시판
	public BoardDataBean getArticle (int num, String boardid, String chk) {
	
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardDataBean article = null;
		String sql= "";
		try {
			conn = getConnection();
			
			if (chk.equals("content")) {
			sql = "update board set readcount=readcount+1 "
					+ "where num = ? and boardid = ?";
			//게시글 볼 떄 마다 리드카운트 증가
			//수정-업데이트 할 땐ㄴ
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, boardid);
			pstmt.executeUpdate();
			}
			
			
			
			sql="select * from board where num = ? and boardid = ?";
			pstmt = conn.prepareStatement(sql);
			//맵핑하기 전에 sql을 수정해야한다.
			pstmt.setInt(1, num);
			pstmt.setString(2, boardid);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				article=new BoardDataBean();
				
				article.setNum(rs.getInt("num"));
				article.setWriter(rs.getString("writer"));
				article.setEmail(rs.getString("email"));
				article.setSubject(rs.getString("subject"));
				article.setPasswd(rs.getString("passwd"));
				article.setReg_date(rs.getTimestamp("reg_date"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getShort("re_level"));
				article.setContent(rs.getString("content"));
				article.setIp(rs.getString("ip"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn, rs, pstmt);
		}
			return article;
	}
	
	//커넥션 닫는 메서드
	public void close(Connection con,ResultSet rs,PreparedStatement pstmt) {
		if(rs!=null)
			try {
				rs.close();
			}catch(SQLException ex) {}
		if(pstmt!=null)
			try {
				pstmt.close();
			}catch(SQLException ex) {}
		if(con!=null)
			try {
				con.close();
			}catch(SQLException ex) {}
	}
	
	public int updateArticle(BoardDataBean article) {
		
		Connection conn = null;
		PreparedStatement pstmt=null;
		int chk = 0;
		System.out.println("update");
		System.out.println(article);
		try {
			conn = getConnection();
			String sql = "update board set writer=?,email=?," + "subject=?,content=? where num=? and passwd= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getWriter());
			pstmt.setString(2, article.getEmail());
			pstmt.setString(3, article.getSubject());
			pstmt.setString(4, article.getContent());
			pstmt.setInt(5, article.getNum());
			pstmt.setString(6, article.getPasswd());
			chk = pstmt.executeUpdate(); //이게 뭐지??
			
			} catch (Exception e) {e.printStackTrace();
			} finally {close(conn, null, pstmt);}
				return chk; //chk가 1이면 0이면?? 업데이트 된 숫자가 리턴된다. updatePro 로 가자.
		
	}
	

}

package com.onlyone.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onlyone.model.MemberDAO;
import com.onlyone.model.MemberDTO;

@Controller
public class MemberController {
	
	@Autowired
	private MemberDAO dao;
	
	@RequestMapping("login.do")
	public String loginMain(Model model) {
		
		return "Login";
		
	}
	
	@RequestMapping("login_ok.do")
	public void loginOk(@RequestParam("id") String id, @RequestParam("pwd") String pwd,
			HttpServletResponse response, HttpServletRequest request, Model model) throws IOException {
		
		MemberDTO dto= this.dao.loginOk(id);
		
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = response.getWriter();
		
		HttpSession session = request.getSession();
		
		if(id == "") {
			
			out.println("<script>");
			out.println("alert('아이디를 입력해주세요')");
			out.println("history.back()");
			out.println("</script>");
			
		}else if(pwd == "") {
			
			out.println("<script>");
			out.println("alert('비밀번호를 입력해주세요')");
			out.println("history.back()");
			out.println("</script>");
			
		}else if(dto == null) {
			
			out.println("<script>");
			out.println("alert('아이디가 존재하지 않습니다.')");
			out.println("history.back()");
			out.println("</script>");
			
		}else if(dto.getMemberId() != null) {
			if(dto.getMemberId().equals(id)) { // 입력id와 데이터베이스 id와 같을 경우
				if(dto.getMemberPwd().equals(pwd)) {
					
					session.setAttribute("member_id", dto.getMemberId());
					session.setAttribute("member_pwd", dto.getMemberPwd());
					
					
					
					out.println("<script>");
					out.println("location.href='/'");
					out.println("</script>");
					
					
					
				}else { // 비밀번호가 틀린 경우
				
					out.println("<script>");
					out.println("alert('비밀번호가 틀립니다.')");
					out.println("history.back()");
					out.println("</script>");
				}
			}
		}
	} // loginOk() end문
		
	@RequestMapping("logout.do")
	public String logOut(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		
		session.invalidate();
		
		return "main";
		
	}
	
	@RequestMapping("join.do")
	public String join(Model model) {
		
		return "join";
	}
	
	
	@RequestMapping("joinOk.do")
	public void joinOk(MemberDTO dto, HttpServletResponse response) throws IOException {
		
		int check = this.dao.insertMember(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = response.getWriter();
		
		if(check > 0) {
			out.println("<script>");
			out.println("alert('회원가입 완료')");
			out.println("location.href='login.do'");
			out.println("<script>");
		}else {
			out.println("<script>");
			out.println("alert('회원가입 실패')");
			out.println("history.back()");
			out.println("<script>");
		}
		
	}
}
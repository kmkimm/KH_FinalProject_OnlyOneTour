<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/resources/css/join.css">
<script src="https://kit.fontawesome.com/27a0dd965d.js" crossorigin="anonymous"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">

// ajax를 사용하여 입력창 유효검사하기

$(function(){
	// 인풋 DOM 가져오기
	let input_memberId = $("#member_id");
	let input_memberEmail = $("#member_email");
	let input_memberPwd1 = $("#member_pwd1");
	let input_memberPwd2 = $("#member_pwd2");
	let input_memberPhone = $("#member_phone");
	
	
	// 텍스트 DOM 가져오기
	let textId1 = $(".text_id1");
	let textId2 = $(".text_id2");
	let textPwd1 = $(".text_pwd1");
	let textPwd2 = $(".text_pwd2");
	let textPwdReg = $(".text_pwdreg");
	
	// 버튼 DOM 가져오기
	let btn_memberId = $("#btn_userId");
	let btn_memberEmail = $("#btn_userEmail");
	let btn_memberPhont = $("#btn_userPhone");
	
	
	// 변수값에 이벤트 적용하기
	btn_memberId.click(userIdCheck);
	btn_memberEmail.click(userEmailCheck);
	btn_memberPhont.click(userPhoneCheck);
	
	input_memberId.keyup(userIdInput);
	input_memberPwd1.keyup(userPwdInput);
	input_memberPwd2.keyup(userPwdCheck);
	

	
	// 아이디4자 이상 입력시 이벤트 적용
	function userIdInput(){
		const memberId = input_memberId.val();
		if(memberId.length >= 4){
			textId1.css("color", "green");		
		}else{
			textId1.css("color","red");
		}
	}
	
	// ID 체크 ajax 구현하기
	function userIdCheck(){
		const memberId = input_memberId.val();
		// 정규식
		let userIdCheck = RegExp(/[^a-zA-Z0-9\s]$/); // 영어숫자만 입력가능
		
		$.ajax({
			type:"POST",
			url: "<%=request.getContextPath()%>/idCheck.do",
			data : {memberId : memberId},
			datatype: "text",
			success: function(data){
				if(data == 1){
					textId2.css("color", "red");
					swal("알림메시지", "중복된 아이디 입니다.");
					$("#user_id_check").val(0);
					$("#member_id").val('').focus();
				}else if(memberId.length < 4){
					swal("알림메시지", "아이디는 4자이상 입력해주세요.")
					$("#member_id").val('').focus();
				}else if(userIdCheck.test(memberId)){
					swal("알림메시지", "아이디는 영어와 숫자만 입력가능합니다.")
					$("#member_id").val('').focus();
				}
				else{
					textId2.css("color", "green");
					swal("알림메시지","사용가능한 아이디 입니다.");
					$("#user_id_check").val(1);
				}
			},
			error: function(data){
				alert("통신 오류입니다.")
			}
		});
	}
	
	
	// 비밀번호 8자 이상 입력하기 비밀번호는 정규식을 적용
	function userPwdInput(){
		const userPwd1 = input_memberPwd1.val();
		
	 	// 비밀번호 정규식
	 	let passwordRule = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,20}$/;
		
 		if(passwordRule.test(userPwd1)){
 			textPwd1.css("color", "green");
 		}else{
 			textPwd1.css("color", "red");
 		}
		
	}
	
	// 비밀번호 동일성 체크하기
	function userPwdCheck(){
		const userPwd1 = input_memberPwd1.val();
		const userPwd2 = input_memberPwd2.val();
		
		if(userPwd1 === userPwd2){
			textPwd2.css("color", "green");
		}else if(userPwd1 !== userPwd2){
			textPwd2.css("color", "red");
		}
	}
	
	// ajax 이메일 중복체크하기
	function userEmailCheck(){
		const userEmail = input_memberEmail.val();
		// 이메일 정규식
		let emailCheck = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
		
		$.ajax({
			type: "POST",
			url:"<%=request.getContextPath()%>/emailCheck.do",
			data: {memberEmail : userEmail},
			datatype: "text",
			success: function(data){
				if(data == 1){
					swal("알림메시지", "중복된 이메일 입니다.")
					$("#member_email").val('').focus();
					$("#member_email_check").val(0);
				}else if(!emailCheck.test(userEmail)){
					swal("알림메시지","잘못된 이메일 형식입니다.")
					$("#member_email").focus();
				}else{
					swal("알림메시지","사용 가능한 이메일 입니다.")
					$("#member_email_check").val(1);
				}
			},
			error: function(data){
				alert("통신오류입니다.")
			}
		});
	}
	
	// ajax 휴대폰 중복 체크하기
	function userPhoneCheck(){
		const phoneCheck = input_memberPhone.val();
		
		// 휴대폰 정규식
		let phoneRule = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/;
		
		$.ajax({
			type: "POST",
			url: "<%=request.getContextPath()%>/phoneCheck.do",
			data: {phoneCheck : phoneCheck},
			datatype: "text",
			success: function(data){
				if(data == 1){
					swal("알림메시지", "중복된 휴대폰번호 입니다.")
					$("#member_phone").val('').focus();
					$("#user_phone_check").val(0);
				}
				else if(!phoneRule.test(phoneCheck)){
					swal("알림메시지", "휴대폰 번호를 정확하게 입력해주세요.")
					$("#member_phone").val('').focus();
				}
				else{
					swal("알림메시지", "사용가능한 휴대폰번호 입니다.")
					$("#user_phone_check").val(1);
				}
			},
			error: function(data){
				alert("통신오류입니다.")
			}
		});
	}
	
	$('input[type="text"]').keydown(function() {
		  if (event.keyCode === 13) {
		    event.preventDefault();
		  };
	});
});


const autoHyphen2 = (target) => {
	 target.value = target.value
	   .replace(/[^0-9]/g, '')
	  .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
}


</script>

</head>
<body>
	
	
		<div class="join_main">
			<a href="/"><img alt="로고" src="/resources/image/로고.jpg"></a>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/joinOk.do" onsubmit="return submitCheck();">
			
			<!-- 아이디  -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-user"></i>&nbsp;아이디</span>
					<input type="text" maxlength="12" class="form-control" id="member_id" name="member_id" placeholder="아이디">
					<button type="button" id="btn_userId" class="btn btn-outline-secondary">중복확인</button>
					<input type="hidden" id="user_id_check" value="0">
					<div class="text_box1">
						<span class="text_id1">4자이상의 영문 및 숫자조합을 입력해주세요</span>
						<span class="text_id2">아이디 중복확인</span>
					</div>
			</div>
			
			<!-- 비밀번호  -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-unlock"></i>&nbsp;비밀번호</span>
					<input type="password" maxlength="16" class="form_control" id="member_pwd1" name="member_pwd" placeholder="패스워드"> 
					<div class="text_box2">
						<span class="text_pwd1">8자 이상 입력 (영문/숫자/특수문자 하나이상 포함)</span>
					</div>
			</div>
			
			<!-- 비밀번호 재확인 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-unlock-keyhole"></i>&nbsp;비밀번호 확인</span>
					<input type="password" maxlength="16" class="form_control" id="member_pwd2" name="member_pwd2" placeholder="패스워드 확인">
					<div class="text_box3">
						<span class="text_pwd2">동일한 비밀번호를 입력해주세요.</span>
					</div>
			</div>
			
			<!-- 이름 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-user-pen"></i>&nbsp;이름</span>
					<input type="text" maxlength="10" class="form_control" id="member_name" name="member_name" placeholder="이름">
				<div class="check_font" id="name_check"></div>		
			</div>
	
			<!-- 이메일 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-envelope"></i>&nbsp;이메일</span>
					<input type="email" class="form-control" name="member_email" id="member_email" placeholder="ex)email@email.com">
					<button type="button" id="btn_userEmail" class="btn btn-outline-secondary">중복확인</button>
					<input type="hidden" id="member_email_check" value="0">
			</div>
			
			<!-- 성별 -->
			<div class="form-group">
			<span class="main-text"><i class="fa-solid fa-person-half-dress"></i>&nbsp;성별</span>
				<div id="radio_box" class="form_toggle row-vh d-flex flex-row justify-content-between" >
					<div class="form_radio_btn radio_male">
						<input id="radio-1" type="radio" name="member_gender" value="남자" checked>
						<label for="radio-1">남자</label>
					</div>
											 
					<div class="form_radio_btn">
						<input id="radio-2" type="radio" name="member_gender" value="여자">
						<label for="radio-2">여자</label>
					</div>
				</div>
			</div>
			
			<!-- 휴대전화 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-phone"></i>&nbsp;전화번호</span>
				<input type="text" class="form-control" id="member_phone" name="member_phone" placeholder="휴대전화를 입력해주세요."
					oninput="autoHyphen2(this)" maxlength="13">
				<button type="button" id="btn_userPhone" class="btn btn-outline-secondary">중복확인</button>	
				<div class="check_font" id="phone_check"></div>
				<input type="hidden" id="user_phone_check" value="0">
			</div>
			
			<!-- 생년월일 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-cake-candles"></i>&nbsp;생년월일</span>
				<input type="text" name="member_birth" id="member_birth" placeholder="ex)19990101" maxlength="8">
				<div class="check_font" id="birth_check"></div>
			</div>
			
			<!-- 주소 -->
			<div class="form-group">
				<span class="main-text"><i class="fa-solid fa-address-book"></i>&nbsp;주소</span>
					<input type="text" id="sample6_postcode" placeholder="우편번호">
					<button type="button" class="search_addr" onclick="sample6_execDaumPostcode()">
						<i class="fa-solid fa-magnifying-glass fa-lg">주소 검색</i>
					</button><br>
					<input type="text" id="sample6_address" placeholder="주소" name="member_addr"><br>
					<input type="text" id="sample6_detailAddress" placeholder="상세주소" name="member_detailaddr">
					<input type="text" id="sample6_extraAddress" placeholder="참고항목">
			</div>
			
			<!-- 가입 버튼 -->
			<div class="reg_button">
				<button type="submit" class="btn btn-primary px-3" id="reg_submit">
					<i class="fa-solid fa-arrow-right-to-bracket">&nbsp;가입하기</i>
				</button>
				
				<a class="btn btn-danger px-3" href="${pageContext.request.contextPath}">
					<i class="fa-solid fa-arrow-rotate-right">&nbsp;취소하기</i>
				</a>&emsp;&emsp;
			</div>
		</form>
	
<script type="text/javascript" src="/resources/js/join.js"></script>
</body>
</html>
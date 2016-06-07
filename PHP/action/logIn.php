<?php 
/*
	路径：action/logIn
	提交方式：POST
	参数：
	username        账号（必填）
	password        密码（必填）
	password2		二次密码（必填）
	email        ｀｀邮箱（必填）
*/
	require_once('../Common.php');
	$post = $_POST;
	$username = $post['username'];
	$nickname = $post['nickname'];
	$password = $post['password'];
	$password2 = $post['password2'];
	$email = $post['email'];
	try {
		if (!filled_out($post)) {
			throw new Exception("信息不完善", 1);
		}
		if (!valid_email($email)) {
			throw new Exception("邮箱格式不正确", 2);
		}
		if ($password != $password2) {
			throw new Exception("两次输入的密码不相符", 3);
		}
		if ((strlen($password) < 6) || (strlen($password) > 16)) {
			throw new Exception("密码长度不符合规范", 4);
		}
		register($username,$nickname,$email,$password);
		$_SESSION['valid_user'] = $username;
		json(0,"注册成功",array());
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code,$message,array());
	}
	//注册
	function register($username, $nickname, $email ,$password) {

		$conn = db_connect();
		$result = $conn->query("select * from user where username='".$username."'");
		if (!$result) {
			throw new Exception("数据库操作错误",-1);
		}
		if ($result->num_rows > 0) {
			throw new Exception("用户名已被注册，请换个用户名重试",-1);
		}
		$result = $conn->query("select * from user where nickname='".$nickname."'");
		if (!$result) {
			throw new Exception("数据库操作错误",-1);
		}
		if ($result->num_rows > 0) {
			throw new Exception("昵称被占用",-1);
		}
		$result = $conn->query("INSERT INTO user (username, nickname, passwd, email) VALUES ('".$username."','".$nickname."',sha1('".$password."'),'".$email."')");
		if (!$result) {
			throw new Exception("数据库操作错误",-1);
		}
		return ture;
	}
 ?>
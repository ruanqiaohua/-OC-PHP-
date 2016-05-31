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
	$post = $_POST;
	$username = $post['username'];
	$password = $post['password'];
	$password2 = $post['password2'];
	$email = $post['email'];
	try {
		if (!filled_out($post)) {
			throw new Exception("信息不完善！", 1);
		}
		if (!valid_email($email)) {
			throw new Exception("邮箱格式不正确！", 2);
		}
		if ($password != $password2) {
			throw new Exception("两次输入的密码不相符！", 3);
		}
		if ((strlen($password) < 6) || (strlen($password) > 16)) {
			throw new Exception("密码长度不符合规范！", 4);
		}
		register($username,$email,$password);
		$_SESSION['valid_user'] = $username;
		json(0,"注册成功",array());
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code,$message,array());
	}
	//注册
	function register($username, $email ,$password) {

		$conn = db_connect();
		$result = $conn->query("select * from user where username='".$username."'");
		if (!$result) {
			throw new Exception("无法执行查询！",201);
		}
		if ($result->num_rows>0) {
			throw new Exception("用户名已被注册，请换个用户名重试！",202);
		}
		$result = $conn->query("insert into user values ('".$username."',sha1('".$password."'),'".$email."')");
		if (!result) {
			throw new Exception("无法在数据库中注册，请稍后再试！",203);
		}
		return ture;
	}
	//连接mysql中的数据库bookmarks
	function db_connect() {

		$result = new mysqli('127.0.0.1','root','62203957','bookmarks');
		if (!$result) {
			throw new Exception("连接服务器失败！",201);
		} else {
			return $result;
		}
	}
	//校验信息的完整性
	function filled_out($form_vars) {
		foreach ($form_vars as $key => $value) {
			if ((!isset($key)) || ($value == '')) {
				return false;
			}
		}
		return true;
	}
	//邮箱验证
	function valid_email($address) {
        if (ereg('^[a-zA-Z0-9\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$', $address)) {
            return ture;
        } else {
            return false;
        }
    }
	//返回json格式的数据
	function json($code, $message = '', $data = array()) {
		if (!is_numeric($code)) {
			return '';
		}
		$result = array(
			'code' => $code,
			'message' => $message,
			'data' => $data
			);
		echo json_encode($result);
		exit;
	}

 ?>
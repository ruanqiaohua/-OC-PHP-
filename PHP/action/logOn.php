<?php
	$post = $_POST;
	$username = $post['username'];
	$password = $post['password'];
	if ($username && $password) {
		try {
			login($username, $password);
			$_SESSION['valid_user'] = $username;
			json(0,"登录成功",array());
		} catch (Exception $e) {
			$code = $e->getCode();
			$message = $e->getMessage();
			json($code,$message,array());
		}
	}

	if (isset($_SESSION['valid_user'])) {
		json(0,"登录成功",array());
	} else {
		json(114,"未登录",array());
	}

	function login($username, $password) {
		$conn = db_connect();
		$result = $conn->query("select * from user where username = '".$username."' and passwd = sha1('".$password."') ");
		if (!$result) {
			throw new Exception("无法执行查询！",201);
		}
		if ($result->num_rows>0) {
			return true;
		} else {
			throw new Exception("登陆失败",204);
		}

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
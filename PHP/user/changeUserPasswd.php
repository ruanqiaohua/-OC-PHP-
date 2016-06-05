<?php
/*
请求地址：user/changeUserPasswd
请求方式：POST
参数:oldPasswd;
	newPasswd;
	newPasswd2;
返回结果：code = 0;
*/
	session_start();
	$username = $_SESSION['valid_user'];
	$oldPasswd = $_POST['oldPasswd'];
	$newPasswd = $_POST['newPasswd'];
	$newPasswd2 = $_POST['newPasswd2'];
	try {
		if (!$username) {
			throw new Exception("用户未登陆", 104);
		}
		if ($newPasswd != $newPasswd2) {
			throw new Exception("两次输入的密码不相符", 3);
		}
		if ((strlen($newPasswd) < 6) || (strlen($newPasswd) > 16)) {
			throw new Exception("密码长度不符合规范", 4);
		}
		if (!validOldPasswd()) {
			throw new Exception("密码错误", -1);
		}
		if (!changePasswd()) {
			throw new Exception("密码修改失败", -1);
		}
		json(0, "密码修改成功", array());
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}

	function validOldPasswd() {
		$conn = db_connect();
		$result = $conn->query("SELECT * FROM user WHERE username = '".$_SESSION['valid_user']."' AND passwd = sha1('".$_POST['oldPasswd']."') ");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}
		if ($result->num_rows > 0) {
			return ture;
		}
		return false;
	}
	//
	function changePasswd() {
		$conn = db_connect();
		$result = $conn->query("UPDATE user SET passwd = sha1('".$_POST['newPasswd']."') WHERE username = '".$_SESSION['valid_user']."' ");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}
		if ($result) {
			return ture;
		} 
		return false;
	}
	//连接mysql中的数据库bookmarks
	function db_connect() {

		$result = new mysqli('127.0.0.1','root','62203957','bookmarks');
		if (!$result) {
			throw new Exception("连接数据库失败",201);
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
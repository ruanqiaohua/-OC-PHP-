<?php
	require_once('../Common.php');
	$post = $_POST;
	$username = $post['username'];
	$password = $post['password'];
	session_start();
	try {
		if (!$username || !$password) {
			throw new Exception("请输入用户名和密码", 1);
		}
		if ($username == "" || $password == "") {
			throw new Exception("用户名和密码不能为空", 1);
		}
	  	$array = login($username, $password);
		$_SESSION['valid_user'] = $username;
		json(0,"登录成功",array(
				'uid' => $array['uid'],
			));
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code,$message,array());
	}

	function login($username, $password) {
		$conn = db_connect();
		$result = $conn->query("select * from user where username = '".$username."' ");
		if ($result->num_rows == 0) {
			throw new Exception("用户名不存在", 205);
		}
		$result = $conn->query("select * from user where username = '".$username."' and passwd = sha1('".$password."') ");
		if (!$result) {
			throw new Exception("数据库操作错误",201);
		}
		if ($result->num_rows > 0) {
			$row = mysqli_fetch_array($result);
			return $row;
		} else {
			throw new Exception("密码输入错误",204);
		}

	}
?>
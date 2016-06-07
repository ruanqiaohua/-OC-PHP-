<?php
 	require_once('../Common.php');
	session_start();
	try {
		$username = $_SESSION['valid_user'];
		if (!$username) {
			throw new Exception("用户未登陆", 104);
		}
		$array = selectUserInfo($username);
		if ($array) {
			json(0, "操作成功", $array);
		} else {
			json(1, "没有这个用户", array());
		}
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}
	//返回用户信息
	function selectUserInfo($username) {

		$conn = db_connect();
		$result = $conn->query("SELECT * FROM user WHERE username = '".$username."' ");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}
		if ($result->num_rows > 0) {
			$row = mysqli_fetch_array($result);
			$array = array('avatar'=>$row['avatar'],
				'username'=>$row['username'],
				'nickname'=>$row['nickname'],
				'avatar'=>$row['avatar'],
				);
			return $array;
		}
		return nil;
	}
	
?>
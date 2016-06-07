<?php
	require_once('../Common.php');
	session_start();
	try {
		$username = $_SESSION['valid_user'];
		if (!$username) {
			throw new Exception("用户未登陆", 1);
		}
		$array = getPhoto($username);
		json(0, '操作成功', $array);
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}
	//获取图片
	function getPhoto($username) {

		$conn = db_connect();
		$result = $conn->query("SELECT * FROM photo WHERE username = '".$username."'");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}
		$array = array();
		while ($row = mysqli_fetch_array($result)) {
			$photo = $row['image'];
			array_push($array, $photo);
		}
		return $array;
	}
?>
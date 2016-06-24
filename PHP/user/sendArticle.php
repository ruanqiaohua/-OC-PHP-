<?php
	require_once('../Common.php');
	session_start();
	try {
		$uid = $_SESSION['uid'];
		if (!$uid) {
			throw new Exception("用户为登陆", 1);
		}
		if (!filled_out($_POST)) {
			throw new Exception("信息校验错误", 2);
		}
		$content = $_POST['content'];
		saveActicle($uid, $content);
		json(0, "发表成功", array());
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}

	function saveActicle($uid, $content) {

		$conn = db_connect();
		$result = $conn->query("INSERT INTO articles (`uid`, `content`) VALUES('".$uid."', '".$content."')");
		if (!$result) {
			throw new Exception("数据库操作错误", 3);
		}
		return ture;
	}
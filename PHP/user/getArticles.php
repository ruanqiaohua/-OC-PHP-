<?php
	require_once('../Common.php');
	define(number, 10);
	$page = $_POST['page'];
	$index = $page * number;//开始位置

	$conn = db_connect();//连接数据库
	$result = $conn->query("SELECT * FROM articles ORDER BY `id` DESC LIMIT ".$index.",".number." ");
	if (!$result) {
		json( -1,"操作错误", array());
		die;
	}

	$articles = array();
	while ($row = mysqli_fetch_array($result)) {
		$userResult = $conn->query("SELECT `uid`, `nickname`, `avatar` FROM user WHERE uid = '".$row['uid']."' ");
		if (!$userResult) {
			json(-1,"数据库操作错误", array());
			die;
		}
		$userData = mysqli_fetch_array($userResult);
		$array = array(
			"articleId" => $row['id'],
			"uid" => $row['uid'],
			"nickname" => $userData['nickname'],
			"avatar" => $userData['avatar'],
			"content" => $row['content'],
			);
		array_push($articles, $array);
 	}
	json(0,"操作成功", $articles);

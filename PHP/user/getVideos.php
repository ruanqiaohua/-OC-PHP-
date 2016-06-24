<?php
	require_once('../Common.php');

	$page = $_POST['page'];
	try {
		$result = getVideos($page, 10);
		$videos = array();
		while ($row = mysqli_fetch_array($result)) {
			$array = array(
				"videoId" => $row['id'],
				"uid" => $row['uid'],
				"title" => $row['title'],
				"url" => $row['url'],
				"content" => $row['content'],
			);
			array_push($videos, $array);
		}
		json(0,"操作成功", $videos);
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}

	function getVideos($page, $count) {

		$index = $page * $count;//开始位置
		$conn = db_connect();
		$result = $conn->query(" SELECT * FROM `videos` ORDER BY `id` DESC LIMIT  ".$index.",".$count." ");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}
		
		return $result;
	}
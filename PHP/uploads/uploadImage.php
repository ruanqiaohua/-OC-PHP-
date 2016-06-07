<?php
	require_once('../Common.php');
	session_start();
	try {
		$uid = $_POST['uid'];
		$username = $_SESSION['valid_user'];
		if (!$username) {
			throw new Exception("用户未登陆", 104);
		}
		if (!$uid) {
			throw new Exception("用户ID不存在", -1);
		}
		if (!(($_FILES["file"]["type"] == "image/gif") || ($_FILES["file"]["type"] == "image/jpeg") ||($_FILES["file"]["type"] == "image/png") || ($_FILES["file"]["type"] == "image/pjpeg"))) {
			throw new Exception("文件类型不规范", -1);
		}
		if (($_FILES["file"]["size"] > 8000000)) {
			throw new Exception("文件太大了", -1);
		}
		if ($_FILES["file"]["error"] > 0) {
			$message = $_FILES["file"]["error"];
			throw new Exception($message, -1);
		}
		$image_name = generateRandomString().".jpg";
		$filePath = "image/" . $image_name;
		if (file_exists($filePath)) {
	   		throw new Exception('文件名已存在', -1);
	   	}
		move_uploaded_file($_FILES["file"]["tmp_name"], $filePath);
		saveImage($uid, $image_name, $username);//保存图片地址
		json(0, '上传成功', array('avatar'=>$image_name));
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}
	//保存图片
	function saveImage($uid, $image, $username) {

		$conn = db_connect();
		$result = $conn->query("INSERT INTO photo (uid, username, image) VALUES ('".$uid."', '".$username."', '".$image."')");
		if (!$result) {
			throw new Exception("数据库操作错误",201);
		}
		return ture;
	}
?>
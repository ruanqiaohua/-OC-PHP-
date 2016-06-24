<?php
	require_once('../Common.php');
	session_start();
	try {
		if (!$_SESSION['uid']) {
			throw new Exception("用户未登陆", 104);
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
		$filePath = "avatar/" . $image_name;
		if (file_exists($filePath)) {
	   		throw new Exception('文件已存在', -1);
	   	}
		move_uploaded_file($_FILES["file"]["tmp_name"], $filePath);
		unlinkUserAvatar();//删除原始图片
		saveUserAvatar($image_name);//保存头像地址
		json(0, '上传成功', array('avatar'=>$image_name));
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}
	//删除原始图片
	function unlinkUserAvatar() {

		$conn = db_connect();
		$result = $conn->query("select * from user where uid = '".$_SESSION['uid']."'");
		while($row = mysqli_fetch_array($result)) {
			if ($row['avatar']) {
				if (file_exists("avatar/".$row['avatar'])) {
					unlink("avatar/".$row['avatar']);
	   			}
			}
		}
	}
	//保存图片
	function saveUserAvatar($avatar) {

		$conn = db_connect();
		$result = $conn->query("update user set avatar = '".$avatar."' where uid = '".$_SESSION['uid']."'");
		if (!$result) {
			throw new Exception("数据库操作错误",201);
		}
		return ture;
	}
?>
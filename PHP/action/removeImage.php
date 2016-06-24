<?php
	require_once('../Common.php');
	session_start();
	try {
		$uid = $_SESSION['uid'];
		if (!$uid) {
			throw new Exception("用户ID不存在", -1);
		}
		$imageName = $_POST['imageName'];
		unlinkUserAvatar($uid, $imageName);
		delectData($uid, $imageName);
		json('0','操作成功', array());
	} catch (Exception $e) {
		$code = $e->getCode();
		$message = $e->getMessage();
		json($code, $message, array());
	}

	//删除原始图片
	function unlinkUserAvatar($uid, $imageName) {

		$conn = db_connect();
		$result = $conn->query("SELECT * FROM photo WHERE uid = '".$uid."' AND image = '".$imageName."' ");
		if (!$result) {
			throw new Exception("数据库操作错误", 1);
		}

		while($row = mysqli_fetch_array($result)) {
			if ($row['image']) {
				if (file_exists("image/".$row['image'])) {
					unlink("image/".$row['image']);
	   			}
			}
		}
	}

	function delectData($uid, $imageName)  {

		$conn = db_connect();
		//DELETE FROM user WHERE user.uid = 3
		$result = $conn->query("DELETE FROM photo WHERE uid = '".$uid."' AND image = '".$imageName."' ");
		if ($result) {
			return ture;
		} else {
			throw new Exception("删除文件错误", 2);
		}
	}

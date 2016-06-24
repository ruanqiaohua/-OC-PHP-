<?php
	require_once('../Common.php');
	session_start();
	$old_user = $_SESSION['uid'];

	unset($_SESSION['uid']);
	$result_dest = session_destroy();

	if (!empty($old_user)) {
		if ($result_dest) {
			json(0, "登出成功", array());
		} else {
			json(5, "登出失败", array());
		}
	} else {
		json(6,"您还没有登陆", array());
	}
?>
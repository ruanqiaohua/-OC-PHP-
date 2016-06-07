<?php
	//连接m数据库
	function db_connect() {

		$result = new mysqli('127.0.0.1','root','62203957','bookmarks');
		if (!$result) {
			throw new Exception("连接数据库失败",201);
		} else {
			return $result;
		}
	}
	//返回json格式的数据
	function json($code, $message = '', $data = array()) {
		if (!is_numeric($code)) {
			return '';
		}
		$result = array(
			'code' => $code,
			'message' => $message,
			'data' => $data
			);
		echo json_encode($result);
		exit;
	}
	//生成随机字符串
	function generateRandomString($length = 10) { 
	    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; 
	    $randomString = ''; 
	    for ($i = 0; $i < $length; $i++) { 
	        $randomString .= $characters[rand(0, strlen($characters) - 1)]; 
	    } 
    	return $randomString; 
	} 
	//校验信息的完整性
	function filled_out($form_vars) {
		foreach ($form_vars as $key => $value) {
			if ((!isset($key)) || ($value == '')) {
				return false;
			}
		}
		return true;
	}
	//邮箱验证
	function valid_email($address) {
        if (ereg('^[a-zA-Z0-9\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$', $address)) {
            return ture;
        } else {
            return false;
        }
    }
?>
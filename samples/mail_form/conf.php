<?php 

// メールアドレスが未入力の場合のみメールフォームTOPへ遷移させる
$email = $_POST['email'];
if (empty($email)) {
	header('Location: ./index.html');
	exit;
}


include('./conf.html');
?>
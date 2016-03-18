<?php

$ini_array = parse_ini_file("./mail.ini", true);

mb_language("Japanese");
mb_internal_encoding("UTF-8");

// テンプレートからメール本文の読み込み
ob_start();
require_once './template/admin.tpl';
$mailbody = ob_get_contents();
ob_end_clean();


ob_start();
require_once './template/user.tpl';
$mailbodyUser = ob_get_contents();
ob_end_clean();



// 問い合わせ内容整形
$name = $_POST['last_name'] . $_POST['first_name'];
$name_kana = $_POST['last_name_kana'] . $_POST['first_name_kana'];

$email = $_POST['email'];

// メールアドレスが未入力の場合のみメールフォームTOPへ遷移させる
if (empty($email)) {
	header('Location: ./index.html');
	exit;
}



$tel = $_POST['tel'];
$birthday = $_POST['year'] . '年' . $_POST['month'] . '月' . $_POST['day'] . '日';
$guard_name = $_POST['guard_last_name'] . $_POST['guard_first_name'];
$guard_name_kana = $_POST['guard_last_name_kana'] . $_POST['guard_first_name_kana'];
$relation = $_POST['relation'];
$zip = $_POST['zip1'] . '-' . $_POST['zip2'];
$pref = $_POST['pref'];
$addr = $_POST['addr'];
$addr2 = $_POST['addr2'];
$addr3 = $_POST['addr3'];

if ($_POST['qr'] == 1) {
	$qr = '受け取る';
} else {
    $qr = '受け取らない';
}

$pr = $_POST['pr'];
$msg = $_POST['msg'];

$riyu = null;
foreach ($_POST['riyu'] as $value) {
	$riyu .= $value . "\n";
}

$riyu_etc = $_POST['riyu_etc'];

// 管理者本文の文字列置き換え
$mailbody = str_replace ("%name%", $name, $mailbody);
$mailbody = str_replace ("%name_kana%", $name_kana, $mailbody);
$mailbody = str_replace ("%email%", $email, $mailbody);
$mailbody = str_replace ("%tel%", $tel, $mailbody);

// 管理者問い合わせ内容
$mailbody = str_replace ("%birthday%", $birthday, $mailbody);
$mailbody = str_replace ("%guard_name%", $guard_name, $mailbody);
$mailbody = str_replace ("%guard_name_kana%", $guard_name_kana, $mailbody);
$mailbody = str_replace ("%relation%", $relation, $mailbody);
$mailbody = str_replace ("%zip%", $zip, $mailbody);
$mailbody = str_replace ("%pref%", $pref, $mailbody);
$mailbody = str_replace ("%addr%", $addr, $mailbody);
$mailbody = str_replace ("%addr2%", $addr2, $mailbody);
$mailbody = str_replace ("%addr2%", $addr2, $mailbody);
$mailbody = str_replace ("%addr3%", $addr3, $mailbody);
$mailbody = str_replace ("%qr%", $qr, $mailbody);
$mailbody = str_replace ("%pr%", $pr, $mailbody);
$mailbody = str_replace ("%msg%", $msg, $mailbody);
$mailbody = str_replace ("%riyu%", $riyu, $mailbody);
$mailbody = str_replace ("%riyu_etc%", $riyu_etc, $mailbody);


// ユーザー本文の文字列置き換え
$mailbodyUser = str_replace ("%name%", $name, $mailbodyUser);
$mailbodyUser = str_replace ("%name_kana%", $name_kana, $mailbodyUser);
$mailbodyUser = str_replace ("%email%", $email, $mailbodyUser);
$mailbodyUser = str_replace ("%tel%", $tel, $mailbodyUser);

// ユーザー問い合わせ内容
$mailbodyUser = str_replace ("%birthday%", $birthday, $mailbodyUser);
$mailbodyUser = str_replace ("%guard_name%", $guard_name, $mailbodyUser);
$mailbodyUser = str_replace ("%guard_name_kana%", $guard_name_kana, $mailbodyUser);
$mailbodyUser = str_replace ("%relation%", $relation, $mailbodyUser);
$mailbodyUser = str_replace ("%zip%", $zip, $mailbodyUser);
$mailbodyUser = str_replace ("%pref%", $pref, $mailbodyUser);
$mailbodyUser = str_replace ("%addr%", $addr, $mailbodyUser);
$mailbodyUser = str_replace ("%addr2%", $addr2, $mailbodyUser);
$mailbodyUser = str_replace ("%addr2%", $addr2, $mailbodyUser);
$mailbodyUser = str_replace ("%addr3%", $addr3, $mailbodyUser);
$mailbodyUser = str_replace ("%qr%", $qr, $mailbodyUser);
$mailbodyUser = str_replace ("%pr%", $pr, $mailbodyUser);
$mailbodyUser = str_replace ("%msg%", $msg, $mailbodyUser);
$mailbodyUser = str_replace ("%riyu%", $riyu, $mailbodyUser);
$mailbodyUser = str_replace ("%riyu_etc%", $riyu_etc, $mailbodyUser);


// コースによって件名・本文を切り分け
if (isset($_POST['entrance'])) {
	$user_subject = $ini_array['user_entrance_title'];
	$mailbody = str_replace ("%course%", "受験対策コース", $mailbody);
} else if (isset($_POST['regularly'])) {
	$user_subject = $ini_array['user_regularly_title'];
	$mailbody = str_replace ("%course%", "定期テストコース", $mailbody);
} else {
	$user_subject = $ini_array['user_monitor_title'];
	$mailbody = str_replace ("%course%", "無料モニター", $mailbody);
}

// 管理者用メールの送信
$toMail = $ini_array['to_mail_admin'];
$header = 'From:' . $ini_array['from_mail'];

//var_dump($_POST);
//exit;

if (isset($ini_array['to_mail_admin_cc']) && count($ini_array['to_mail_admin_cc']) > 0) {
	for ($i = 0; count($ini_array['to_mail_admin_cc']) > $i; $i++) {
		$header .= "\n";
		$header .= "Cc:" . $ini_array['to_mail_admin_cc'][$i];
	}
}

if (!mb_send_mail($toMail, $ini_array['admin_title'], $mailbody, $header)) {
	echo 'メール送信失敗';
	exit;
}


$user_header = 'From:' . $ini_array['from_mail'];

// 利用者用メールの送信
if (!mb_send_mail($email, $user_subject, $mailbodyUser, $user_header)) {
	echo 'メール送信失敗';
	exit;
}

include('./finish.html');

?>
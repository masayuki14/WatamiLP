<?php 

// ���[���A�h���X�������͂̏ꍇ�̂݃��[���t�H�[��TOP�֑J�ڂ�����
$email = $_POST['email'];
if (empty($email)) {
	header('Location: ./index.html');
	exit;
}


include('./conf.html');
?>
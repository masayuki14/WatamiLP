$(function() {

	//必須チェック
	check();
	//セレクトボックス
	$("select").change(function() {
		check();
	});
	//input要素
	$("input").bind('keydown keyup keypress change', function() {
		check();
	});

	function check () {
		// 必須項目の設定
		var requiredForm = [
			"last_name", 
			"first_name",
			"last_name_kana",
			"first_name_kana",
			"year",
			"month",
			"day",
			"guard_last_name",
			"guard_first_name",
			"guard_last_name_kana",
			"guard_first_name_kana",
			"relation",
			"zip1",
			"zip2",
			"pref",
			"addr",
			"addr2",
			"tel",
			"email",
			"email_comf",
			"pr",
			"q1",
			"q2"
		];

		var requiredError = false;

		$.each(requiredForm, function() {
			if ($('#' + this).attr('type') == 'radio') {
				if (!$('input[name=' + this + ']:eq(0)').prop('checked') && !$('input[name=' + this + ']:eq(1)').prop('checked')) {
					requiredError = true;
				}
			} else if ($('#' + this).attr('type') == 'checkbox') {
				if (!$('#' + this).prop('checked')) {
					requiredError = true;
				}
			} else {
				if ($('#' + this).val().length == 0) {
					requiredError = true;
				}
			}
		});


		if (requiredError) {
			$('#submit').val('未入力の項目があります');
		} else {
			$('#submit').val('確認画面へ');
			$('.btn-sub-conf').css('background-color','#2EAB2E');
		}

	}

});
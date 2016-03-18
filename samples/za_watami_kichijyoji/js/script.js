$(function(){
	var $setElem = $('img'), // 切り替える画像
	pcName = '_pc',
	spName = '_sp',
	replaceWidth = 960; // 画像を切り替えるウィンドウ幅

	$setElem.each(function(){
		var $this = $(this);
		function imgSize(){
			var windowWidth = parseInt($(window).width());
			if(windowWidth >= replaceWidth) {
				$this.attr('src',$this.attr('src').replace(spName,pcName)).css({visibility:'visible'});
			} else if(windowWidth < replaceWidth) {
				$this.attr('src',$this.attr('src').replace(pcName,spName)).css({visibility:'visible'});
			}
		}
		$(window).resize(function(){imgSize();});
		imgSize();
	});
});

//pagetopボタン
$(function() {
	var topBtn = $('#page-top');	
	topBtn.hide();
	//スクロールが100に達したらボタン表示
	$(window).scroll(function () {
		if ($(this).scrollTop() > 100) {
			topBtn.fadeIn();
		} else {
			topBtn.fadeOut();
		}
	});
	//スクロールしてトップ
    topBtn.click(function () {
		$('body,html').animate({
			scrollTop: 0
		}, 500);
		return false;
    });
});

//Div全体をクリック
$(function(){
	$(".clickarea").click(function(){
    	window.location=$(this).find("a").attr("href");
    	return false;
    });
});

//アンカーリンク
$(function()
{
android_ss( $( 'a' ) );
});
function android_ss( a )
{
for ( var i = 0; i < a.size(); i++ )
{	
a.eq( i ).click(function()
{
var h = $( this ).attr( 'href' );
var p = $( h ).offset().top;
$( 'html, body' ).animate( {scrollTop: p}, 500, 'swing' );
return false;
});
var h = $( this ).removeAttr( 'href' );
}
}

<!-- 自動的に列の高さが揃う -->
 $(function(){
    $('.js-matchHeigtht').matchHeight();
  });
  
  
<!-- 可変グリッドレイアウト -->  
  $(function(){
	$('#menu01,#menu02,#menu03').masonry({
	    isAnimated: true,
	    itemSelector: '.item',
	    isFitWidth: true
	});
});  
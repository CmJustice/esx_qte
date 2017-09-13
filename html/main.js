
var button = null;
var time = null;
var active = false;

function load(btn, tm){
	active = true;
	$('.qte i').attr('class', 'fa fa-arrow-'+btn)
	$('.qte').fadeIn()

	$('.qte .loader .inside').css("width", "0%")
	$('.qte .loader .inside').css("background-color", "#8BC34A")
	$('.qte .loader .inside').animate({width: "100%", backgroundColor: "#f44336"}, tm)


	var pulseTime = 600;
	var kucuktur = tm/pulseTime
	for (var i = 0; i < kucuktur; i++) {
		setTimeout(function(){
			$('.pulse').animate({width: "150px", height: "150px", opacity: 0}, pulseTime-1)
			$('.pulse').animate({width: "0px", height: "0px", opacity: 1}, 1)
		}, i*pulseTime)
	}

	setTimeout(function(){
		if (active) {
			active = false;
			$('.qte').fadeOut();
		}
	}, tm)
}





$(function(){
	window.addEventListener('message', function(event) {
		$('.debug').html('I got the message!')
		if (event.data.type == "qte") {
			button = event.data.button;
			time = event.data.timee;
			$('.debug').html('I got the message!' + button + time)

			load(button, time)

		}
	});




	



	$(document).keydown(function(e){
		if (active){
			if (e.keyCode == 37 && button == "left" || e.keyCode == 38 && button == "up" || e.keyCode == 39 && button == "right" || e.keyCode == 40 && button == "down"){
				$.post('http://esx_qte/success');
				active = false;
				$('.qte').fadeOut();
			}else{
				$('.debug').html('Button was ' + button + ' but you clicked ' + e.keyCode)
			}
		}
	});
});
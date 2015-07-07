
(function($){ 
	$(document).ready(function(){
		$('A[rel="_blank"]').click(function(){
			window.open($(this).attr('href'));
			return false;
		});
	});
}());


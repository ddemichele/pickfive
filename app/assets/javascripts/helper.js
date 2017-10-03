$(document).ready(function() {
	$(".teamDisplay input[type=checkbox]").click( function() {
	  var _parent = $(this).parent()
	  if($(this).is(':checked')) {
		 _parent.addClass("sel_highlighted");
	  } else {
		  _parent.removeClass("sel_highlighted");	
	  }
	});
	
	// Activate the tooltips
	$(".game-tooltip").tooltip({ effect: "toggle", opacity: 1});
});
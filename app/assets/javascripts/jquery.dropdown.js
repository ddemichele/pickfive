$(function(){

    var config = {    
         sensitivity: 4, // number = sensitivity threshold (must be 1 or higher)    
         interval: 100,  // number = milliseconds for onMouseOver polling interval    
         over: doOpen,   // function = onMouseOver callback (REQUIRED)    
         timeout: 300,   // number = milliseconds delay before onMouseOut    
         out: doClose    // function = onMouseOut callback (REQUIRED)    
    };
    
    function doOpen() {
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
    }
 
    function doClose() {
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    }

    $(".navBar ul li").hoverIntent(config);
    
    $(".navBar ul li ul li:has(ul)").find("a:first").append(" &raquo; ");

});
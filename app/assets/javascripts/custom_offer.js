//animated bg

var scrollSpeed = 45; 		// Speed in milliseconds
var step = 1; 				// How many pixels to move per step
var current = 0;			// The current pixel row
var imageWidth = 6120;		// Background image width
var headerWidth = 680;		// How wide the header is.

//The pixel row where to start a new loop
var restartPosition = -(imageWidth - headerWidth);

function scrollBg() {
  //Go to next pixel row.
  current -= step;
  //If at the end of the image, then go to the top.
  if (current == restartPosition) {
    current = 0;
  }
  //Set the CSS of the header.
  $('#AnimatedBg').css("background-position", current + "px 0");
}



function loadOnLoad() {

  // top menu
  $(window).scroll(function () {
    var scrollTop = $(window).scrollTop();
    if (scrollTop != 0) {
      $("nav.navbar").addClass("nav-fixed");
      $(".scroll.top").fadeIn(1000);
      $(".submenu").slideUp(1000);
      return false;
    } else {
      $("nav.navbar").removeClass("nav-fixed");
      $(".scroll.top").fadeOut(1000);
      $(".submenu").slideDown(1000);
      return false;
    }
  });
  //Calls the scrolling function repeatedly
  var init = setInterval("scrollBg()", scrollSpeed);
  $('.formtastic').valtastic();

  $("ul.feature-two").each(function(){
    var $this = $(this),
        $window_w = $(window).width(),
        $gHeight = $this.height();

    $this.append("<span class='line'></span>");
    $("li", this).last().css("margin-bottom","-19px");
  });

}

$(document).on('ready', function () {
//    $colorboxOverlay = $('#cboxOverlay');
//    $colorboxBox = $('#colorbox');
  loadOnLoad();
});
$(document).on('page:load', function () {
//    $colorboxOverlay.appendTo('body');
//    $colorboxBox.appendTo('body');
  loadOnLoad();
});

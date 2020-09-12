// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets

$(function () {
  $(".slide").slick({
    arrows: false,
    dots: false,
    autoplay: true,
    autoplaySpeed: 5000,
    speed: 1500,
    fade: true,
    pauseOnFocus: false,
    pauseOnHover: false,
    pauseOnDotsHover: false,
  });

  $("#nav-toggle").on("click", function () {
    $("body").toggleClass("open");
  });

  $(".post__box").each(function (index, element) {
    var w = $(element).width();
    $(".post-index__cont").append(
      '<div style="height:0; width:' + w + 'px; margin:0px 10px;"></div>'
    );
  });
});

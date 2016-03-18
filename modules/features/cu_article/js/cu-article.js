(function( $ ){
  $(document).ready(function() {

    if ($('.has-feature-title-image .author-meta').length) {
      var byline = $('.has-feature-title-image .author-meta');
      $('.has-feature-title-image .author-meta').remove();
      $('.title-image-byline').html(byline);
    }
    if ($('.breadcrumb-wrapper').length) {
      var breadcrumb = $('.has-feature-title-image .breadcrumb-wrapper').contents();
      $('.has-feature-title-image .breadcrumb-wrapper').remove();
      $('.title-image-breadcrumbs').html(breadcrumb);
      $('.title-image-breadcrumbs-wrapper').show();
    }


  })

  $(window).scroll(function(){
    if($(document).scrollTop() > 200) {
      $('.feature-layout-title-image').addClass('layout-title-image-small');
    } else {
      $('.feature-layout-title-image').removeClass('layout-title-image-small');
    }
  });

})( jQuery );

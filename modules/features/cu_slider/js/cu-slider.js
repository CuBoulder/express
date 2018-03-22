(function( $ ){
  $(document).ready(function(){
    // Normal sliders
    $('.cu-slider').flickity({
      'wrapAround': true,
      'adaptiveHeight': true,
      'draggable': false,
      'autoPlay': 7000,
      arrowShape: {
        x0: 10,
        x1: 60, y1: 50,
        x2: 75, y2: 35,
        x3: 40
      }
    });
    // Sliders with thumbnails
    $('.cu-slider-has-thumbnails').each(function(){
      $(this).flickity({
        'wrapAround': true,
        'adaptiveHeight': true,
        'draggable': false,
        'autoPlay': 7000,
        'pageDots': false,
      });
    });
    $('.cu-slider-thumbnails').each(function(){
      var $slides = $('.field-name-field-slider-slide', this).length;
      var $width = 100/$slides;
      $('.field-name-field-slider-slide', this).css('width', $width + '%');
      var $controls = $(this).data('slider-controls');
      $(this).flickity({
        'asNavFor': '#' + $controls,
        'contain': true,
        'pageDots': false,
        'groupCells': false,
        'prevNextButtons':false,
      });
      // Stop Thumbnail slider if thumbnail is clicked/pressed
      $(this).on( 'pointerDown.flickity', function( event, pointer ) {
        var $controls = $(this).data('slider-controls');
        $('#' + $controls).flickity('stopPlayer');
      });

    });
    $('.cu-slider-thumbnails a').click(function(event) {
      event.preventDefault();
    });


  });
})( jQuery );

/**
 * @file
 * A JavaScript file for the theme.
 *
 * In order for this JavaScript to be loaded on pages, see the instructions in
 * the README.txt next to this file.
 */

// JavaScript should be made compatible with libraries other than jQuery by
// wrapping it with an "anonymous closure". See:
// - https://drupal.org/node/1446420
// - http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth
(function ($, Drupal, window, document, undefined) {
  $(document).ready(function(){
    $("#toggle").click(function(event) {
      event.preventDefault();
      $("#mobile-navigation-wrapper").slideToggle('fast');
      $("#toggle i.fa").toggleClass('fa-reorder');
      $("#toggle i.fa").toggleClass('fa-times');
      if ($(this).attr('aria-expanded') == 'true') {
        $(this).attr('aria-expanded', 'false');
      }
      else {
        $(this).attr('aria-expanded', 'true');
      }
    });
    // Add close messages area
    var closeMsgs = '<a href="#" class="close-msgs" tabindex="-1"><i class="fa fa-times-circle"></a>';
    $('.logged-in .express-messages').append(closeMsgs);
    $('a.close-msgs').click(function(event){
      event.preventDefault();
      $('.express-messages').hide();
    });
    $('#search-toggle').click(function(event){
      event.preventDefault();
      $('#search').fadeIn('fast');
      $('#edit-search-keys').focus();
      $(this).attr('aria-expanded', 'true');
    });
    $('#close-search').click(function(event){
      event.preventDefault();
      $('#search').hide();
      $('#header').focus();
      $('#search-toggle').attr('aria-expanded', 'false');
    });


    // Prepare Mega menus
    $("a.mega-menu-link").attr('aria-haspopup', true).attr('aria-expanded', false);
    $("a.mega-menu-link").each(function(i){
      $(this).attr('id', 'mm-' + i);
      $(this).next().attr('aria-labelledby', 'mm-' + i);
    });
    // Display mega menus
    $("a.mega-menu-link").click(function(event) {
      event.preventDefault();

      //$(this).next().toggle();
      if ($(this).next().css('display') == 'block') {
        $(this).next().hide();
        $(this).attr('aria-expanded', false);
      }
      else {
        $('.mega-menu-wrapper').hide();
        $("a.mega-menu-link").attr('aria-expanded', false);
        $(this).next().show();
        $(this).attr('aria-expanded', true);
      }
    });
    // Hide mega menus when clicked outside
    $('html').click(function() {
      $('.mega-menu-wrapper').hide();
      $("a.mega-menu-link").attr('aria-expanded', false);
    });

    $('nav').click(function(event){
        event.stopPropagation();
    });
  });
  $(window).on('resize', function(){
      var win = $(this);
      if (win.width() >= 960) {
        $("#mobile-navigation-wrapper").hide();
        $("#toggle i.fa").addClass('fa-reorder');
        $("#toggle i.fa").removeClass('fa-times');
      }
  });
})(jQuery, Drupal, this, this.document);

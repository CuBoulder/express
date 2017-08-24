(function ($) {
  $(document).ready(function(){
    $('.cu-search .form-text').attr('type', 'search');
    $('.search-options input').change(function(){
      var label = $(this).attr('data-placeholder');
      var action = $(this).attr('data-action');
      $('.cu-search .form-text').attr('placeholder', label)
      $('#search form, #mobile-search form').attr('action', action);
    });
  });
}(jQuery));

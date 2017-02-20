(function ($) {
  $(document).ready(function(){
    $(".bean-collection-grid .expand-trigger").each(function(i){
      //alert(i);
      $(this).addClass('xxx');
      var trigger = $(this).attr('href');
      var trigger2 = trigger + '-' + i;
      var target = trigger2.substring(1);


      $(this).attr('href', trigger2);
      $(this).next('.expand-content').attr('id', target);
    });
    $(".collection-items-categories").hide();

    $("ul.collection-items-navigation a").first().addClass('active');
    $("ul.collection-items-navigation a").click(function(){
      $(".collection-items").hide();
      var target = $(this).attr("href");
      $(target).fadeIn();
      $("ul.collection-items-navigation a").removeClass('active');
      $(this).addClass('active');
      return false;
    });

    $("select.collection-filter").change(function(){
      $(".collection-items").hide();
      var target = $(this).val();
      //alert(target);
      $(target).fadeIn();
    });
  });
})(jQuery);

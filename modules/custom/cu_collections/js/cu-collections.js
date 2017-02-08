(function ($) {
  $(document).ready(function(){
    $(".bean-collection-grid").each(function(){

    });
    $(".collection-items-categories").hide();

    $("ul.collection-items-navigation a").first().addClass('active');
    $("ul.collection-items-navigation a").click(function(){
      var collectionTarget = $(this).attr("data-collection");
      $("#" + collectionTarget + " .collection-item").removeClass('collection-item-disabled');
      $("#" + collectionTarget + " .collection-item").addClass('collection-item-visible');
      var target = $(this).attr("data-collection-category");

      $('#' + collectionTarget + ' .collection-item').not('.collection-category-' + target).addClass('collection-item-disabled');
      $('#' + collectionTarget + ' .collection-item').not('.collection-category-' + target).removeClass('collection-item-visible');

      $("ul.collection-items-navigation a").removeClass('active');
      $(this).addClass('active');
      return false;
    });
    $("ul.collection-items-navigation a.collection-category-all").click(function(){
      var collectionTarget = $(this).attr("data-collection");

      $("#" + collectionTarget + " .collection-item").removeClass('collection-item-disabled');

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

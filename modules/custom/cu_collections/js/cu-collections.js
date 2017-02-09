(function ($) {
  $(document).ready(function(){
    $(".bean-collection-grid").each(function(){

    });
    $(".collection-items-categories").hide();

    $("ul.collection-items-navigation a").first().addClass('active');
    $("ul.collection-items-navigation a").click(function(){
      // Get the collection to operate on
      var collectionTarget = $(this).attr("data-collection");
      // Remove disabled class from all items in collection
      $("#" + collectionTarget + " .collection-item").removeClass('collection-item-disabled');
      // Get the collection category
      var target = $(this).attr("data-collection-category");
      // Apply disabled class to all items not in category
      $('#' + collectionTarget + ' .collection-item').not('.collection-category-' + target).addClass('collection-item-disabled');
      // Remove active class from category links
      $("ul.collection-items-navigation a").removeClass('active');
      // Apply active class to the clicked link
      $(this).addClass('active');
      return false;
    });
    // Collection ALL link
    $("ul.collection-items-navigation a.collection-category-all").click(function(){
      // Get the collection to operate on
      var collectionTarget = $(this).attr("data-collection");
      // Remove disabled class from all items in collection
      $("#" + collectionTarget + " .collection-item").removeClass('collection-item-disabled');
      // Remove active class from category links
      $("ul.collection-items-navigation a").removeClass('active');
      // Apply active class to the clicked link
      $(this).addClass('active');
      return false;
    });
    $("select.collection-filter").change(function(){
      // Get the collection to operate on
      var collectionTarget = $(this).attr("data-collection");
      // Get the collection category
      var target = $(this).val();
      // Show all collection items
      $("#" + collectionTarget + " .collection-item").removeClass('collection-item-disabled');
      // Add disabled class to collection items that are not part of the category chosen
      $('#' + collectionTarget + ' .collection-item').not('.collection-category-' + target).addClass('collection-item-disabled');


    });
  });
})(jQuery);

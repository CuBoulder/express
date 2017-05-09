(function( $ ){
  jQuery(document).ready(function($){
    // Array of available block for autocomplete
    var blocks = new Array();

    // Layout state
    var layoutChanged = false;

    // Create new Dragster object
    var dragster = new window.Dragster({
        elementSelector: '.dragster-block',
        regionSelector: '.dragster-region',
        dragOnlyRegionCssClass: 'dragster-region--drag-only',
        cloneElements: true,
        updateRegionsHeight: false,
        onAfterDragDrop: function (e) {
          updateDragRegions();
        },
    });


    // Remove a block from a layout region
    $('a.operation-remove').click(function(event){
      event.preventDefault();
      $(this).parent().parent().fadeOut().remove();
      updateDragRegions();
    });


    // Get variable from Drupal of all available blocks
    var blockList = Drupal.settings.layoutBlocks;
    // Push them into a new array that is formatted properly
    for (var prop in blockList) {
      if (blockList.hasOwnProperty(prop)) {
        blocks.push(blockList[prop]);
      }
    }

    // Add autocomplete function to block search form
    $('input#layout-editor-block-filter-field').autocomplete({
      source: blocks,
      select: function(event, ui) {
        if(ui.item){
            $('input#layout-editor-block-filter-field').val(ui.item.value);
            //alert(ui.item.value);
            var search = ui.item.value;
            updateResults(search);
        }
      }
    }).autocomplete("widget").addClass('layout-edit-autocomplete');
    $('#layout-editor-filter-reset').click(function(){
      $('input#layout-editor-block-filter-field').val('');
      $('.block-tray .dragster-block').parent().removeClass('search-hidden').removeClass('search-found');
      $('.layout-editor-block-category').show();
    });

    // Toggle the visibility of the block tray
    $('a.block-tray-toggle').click(function(event){
      event.preventDefault();
      $('.block-tray-inner, .block-tray-minimal').toggle();
      $('.vertical-block-tray').toggleClass('block-tray-minimized');
      $('i.fa', this).toggleClass('fa-expand').toggleClass('fa-compress');
    })
  });

  // Update block search results
  function updateResults(search) {
    $('.block-tray .dragster-block').parent().addClass('search-hidden');
    $(".block-tray .dragster-block[data-block-combined*='" + search + "']").parent().removeClass('search-hidden').addClass('search-found');

    $('.layout-editor-block-category').each(function(){
      if ( !$('.dragster-draggable:visible', this).length ) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });


  }

  // Update block region fields
  function updateDragRegions() {
    $('.dragster-region').each(function(){
      $(this).css('height', 'auto');
      blocks = new Array();
      var regionName = $(this).attr('data-drag-block-region');
      regionName = regionName.replace(/_/g, '-');
      $('.dragster-block', this).each(function(){
        var id = $(this).attr('data-drag-block-id');
        blocks.push(id);
      });
      var blockIDs = blocks.join();
      $('#edit-field-' + regionName).val(blockIDs);
    });
    layoutChangedWarning();
  }

  // Display message if layout has been changed
  function layoutChangedWarning() {
    var link = '<a href="#" onclick="document.getElementById(\'express-layout-drag-form\').submit();"> Save changes</a>.';
    $('.layout-changed-warning').html('<i class="fa fa-exclamation-triangle"></i> You have made changes to this layout. Navigating away from this page without saving will discard those changes. ' + link).fadeIn();
  }
})( jQuery );

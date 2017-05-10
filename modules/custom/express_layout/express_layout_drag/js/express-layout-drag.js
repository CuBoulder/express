(function( $ ){
  var dragster;
  jQuery(document).ready(function($){
    // Array of available block for autocomplete
    var blocks = new Array();

    // Layout state
    var layoutChanged = false;

    // Create new Dragster object
    dragster = new window.Dragster({
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

    $('input.layout-edit-block-search').autocomplete({
      source: blocks,
      select: function(event, ui) {
        if(ui.item){
            $(this).val(ui.item.value);
            //alert(ui.item.value);
            //var search = ui.item.value;
            //updateResults(search);
            var instance = $(this).attr('id');
            insertBlock(instance, ui.item.value);
        }
      }
    }).autocomplete("widget");



    // Add autocomplete function to block search form
    $('input#layout-editor-block-filter-field').autocomplete({
      source: blocks,
      select: function(event, ui) {
        if(ui.item){
            $(this).val(ui.item.value);
            //alert(ui.item.value);
            var search = ui.item.value;
            updateResults(search);
        }
      }
    }).autocomplete("widget");
    $('#layout-editor-filter-reset').click(function(){
      $('input#layout-editor-block-filter-field').val('');
      $('.block-tray .dragster-block').parent().removeClass('search-hidden').removeClass('search-found');
      $('.layout-editor-block-category').show();
    });

    $('.ui-autocomplete').addClass('layout-edit-autocomplete');

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

    $('button.express-layout-editor-save').click(function(){
      $('form#express-layout-drag-form').submit();
    });
    $('button.express-layout-editor-cancel').click(function(){
      $('form#express-layout-drag-form #edit-cancel').click();
    });

    $('a.express-layout-edit-add-block-link').attr('aria-expanded', 'false');
    $('a.express-layout-edit-add-block-link').click(function(event){
      // https://www.w3.org/WAI/GL/wiki/Using_aria-expanded_to_indicate_the_state_of_a_collapsible_element

      event.preventDefault();
      if ($(this).attr('aria-expanded') == 'true') {
        $(this).attr('aria-expanded', 'false');
      } else {
        $(this).attr('aria-expanded', 'true');
      }
      $('input.layout-edit-block-search').val('');
      $('.express-layout-edit-add').hide();
      var target = $(this).attr('href');
      $(target).parent().fadeIn();
      $(target).focus();
    });
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
    $('.layout-edit-block-recent').hide();
    $('#block-tray').focus();
  }

  function insertBlock(instance, block) {
    var newBlock = $(".block-tray .dragster-block[data-block-combined*='" + block + "']").first();
    $('input.layout-edit-block-search').val('');
    $('.express-layout-edit-add').hide();
    $('#' + instance).parent().next().prepend(newBlock);
    dragster.update();
    updateDragRegions();
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
    var link = '<button style="float:right" class="btn btn-success" onclick="document.getElementById(\'express-layout-drag-form\').submit();"> Save Layout</button>';
    $('.layout-changed-warning').html('<i class="fa fa-exclamation-triangle warning-color"></i> You have made changes to this layout. Navigating away from this page without saving will discard those changes. ' + link).addClass('warning-background').fadeIn();
  }

})( jQuery );

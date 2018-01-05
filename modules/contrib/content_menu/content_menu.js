(function($){
    Drupal.behaviors.content_menu ={
        attach:function(context, settings){
            // Show menu item title input field when clicking on the trigger.
            $('.menu-overview-title-edit-trigger', context).click(function(e) {
                $(this).siblings('.form-type-textfield').show().children('input').focus();
                $(this).siblings('.menu-overview-title-link').hide();
                $(this).hide();
                e.stopPropagation();
                e.stopImmediatePropagation();
            });
        }
    };})(jQuery);

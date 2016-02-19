/**
 * @file
 * Javascript functionality for Backstretch module.
 */

(function ($) {

  Drupal.behaviors.backstretch = {
    attach: function (context, settings) {
      if (typeof settings.backstretch != 'undefined') {
        // Iterate all Backstretch configurations.
        $.each(settings.backstretch, function(id, options) {
          // Store the items.
          var items = options.items;

          // Pass items and options to Backstretch with the specific selector.
          if (typeof options.selector == 'undefined') {
            $.backstretch(items, options);
          }
          else {
            $(options.selector).backstretch(items, options);
          }
        });
      }
    }
  };

})(jQuery);

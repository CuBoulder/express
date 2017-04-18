(function ($) {

  Drupal.behaviors.cu_ab = {
    attach: function (context) {
      var wrapper, options, winningContent = [];
      var num, start, end, winner = Number(0);

      function getDecision(options) {
        // Generate random number between 0 and 100.
        num = getRandomInt(0, 99);

        // Sort options by percentage and return winner.
        start = 0;
        options.each(function(index, value) {
          // Get percentage option should be shown and make that the ending number for comparisons.
          end = start + Number(value.getAttribute('ab-percent'));

          // Check to see which option is the winner and return ID.
          if (num >= start && num < end) {
            // The index will be the ID of the block we want to display to user.
            winner = index;
          }

          // Make the beginning of subsequent counts the end of the previous count.
          start = end;
        });

        return winner;
      }

      function executeDecision(decision, wrapper) {
        // Replace A/B container with winner option.
        winningContent = $('.ab-block-option[ab-id="' + decision + '"]');
        wrapper.replaceWith(winningContent[0].innerHTML);
      }

      function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min)) + min;
      }

      // Look for A/B block wrapper and return if none.
      wrapper = $('.ab-block-wrapper');
      if (wrapper.length === 0) {
        return;
      }

      // Grab all block options.
      options = $('.ab-block-option');

      // Get ID of winner from evaluation function.
      winner = getDecision(options);

      // If the evaluation completed, replace content with winner.
      if (winner != null) {
        return executeDecision(winner, wrapper);
      }

      // Log message if something is broken.
      console.log('Condition could not be evaluated. Default A/B block rendered.');
    }
  };
})(jQuery);

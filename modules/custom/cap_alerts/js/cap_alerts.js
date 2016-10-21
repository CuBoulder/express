(function($) {

  $(document).ready(
    function alertWorker() {
      // @TODO: Add loop count or option to exit so this doesn't keep running after an 
      // active event has ended if someone leaves a browser open
      if ( Drupal.settings.cap_alerts_active_event == 1 ) {
				// Create our own rounded timestamp to limit paths cached by varnish
				var stamp = Math.ceil( $.now() / 10000 );
				//console.log(stamp);

				$.ajax({
					type: "GET",
					url: Drupal.settings.cap_alerts_url + "?stamp=" + stamp,
					dataType: "xml",
					//cache: false, // Causes Varnish to miss every request
					success: capAlertParser,
					complete: function() {
						// Schedule the next request when the current one's complete
						setTimeout(alertWorker, 10000);
					}
				});
			};
    });

    function capAlertParser(xml) {
      var alertPubtime = $(this).find("sent").text();
      $(xml).find("info").each(function () {
        if ($(this).find("instruction").text()) {
          link = $(this).find("instruction").text();
        } else {
          // @TODO: get url from jQuery.extend(Drupal.settings
          link = Drupal.settings.cap_alerts_deafult_read_more_url;
        }
        var stamp = Math.ceil( $.now() / 10000 );
        var alertTitle = $(this).find("description").text();
        
        $("#cap-alerts .alert").html(alertTitle + ' <a href="' + link + '" >' + 'Read More</a>');
        // data-alert-publish-time="' + alertPubtime + '" data-alert-timestamp="' + stamp + '"
        $("#cap-alerts .alert").attr('data-alert-publish-time', alertPubtime);
        $("#cap-alerts .alert").attr('data-alert-timestamp', stamp);
      });
    };

})(jQuery);

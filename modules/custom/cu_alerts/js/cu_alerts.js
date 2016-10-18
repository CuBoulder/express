(function($) {

  $(document).ready(
    function alertWorker() {
      if ( Drupal.settings.rave_alerts_active_event == 1 ) {
				// Create our own rounded timestamp to limit paths cached by varnish
				var stamp = Math.ceil( $.now() / 10000 );
				//console.log(stamp);

				$.ajax({
					type: "GET",
					url: Drupal.settings.rave_alerts_url + "?stamp=" + stamp,
					dataType: "xml",
					//cache: false, // Causes Varnish to miss every request
					success: rssParser,
					complete: function() {
						// Schedule the next request when the current one's complete
						setTimeout(alertWorker, 10000);
					}
				});
			};
    });

    function rssParser(xml) {
      $(xml).find("item").each(function () {
        if ($(this).find("link").text()) {
          feedLink = $(this).find("link").text();
        } else {
          // @TODO: get url from jQuery.extend(Drupal.settings
          feedLink = Drupal.settings.rave_alerts_site;
        }
        var stamp = Math.ceil( $.now() / 10000 );
        var alertTitle = $(this).find("title").text();
        var alertPubtime = $(this).find("pubDate").text();
        $("#cu-alerts .alert").html(alertTitle + ' <a href="' + feedLink + '" >' + 'Read More</a>');
        // data-alert-publish-time="' + alertPubtime + '" data-alert-timestamp="' + stamp + '"
        $("#cu-alerts .alert").attr('data-alert-publish-time', alertPubtime);
        $("#cu-alerts .alert").attr('data-alert-timestamp', stamp);
      });
    };

})(jQuery);

(function($) {

  $(document).ready(
    function alertWorker() {
      // Create our own timestamp
			var stamp = Math.ceil( $.now() / 10000 );
			//console.log(stamp);
			
			$.ajax({
			  type: "GET",
				// @TODO: get url from jQuery.extend(Drupal.settings
				url: "http://www.getrave.com.global.prod.fastly.net/rss/cuboulder/channel1?stamp=" + stamp,
				dataType: "xml",
				//cache: false, // Causes Varnish to miss every request
				success: rssParser,
				complete: function() {
				  // Schedule the next request when the current one's complete
					setTimeout(alertWorker, 10000);
				}
			});		
    });
   
    function rssParser(xml) {
      $(xml).find("item").each(function () {
        if ($(this).find("link").text()) {
          feedLink = $(this).find("link").text();
        } else {
          // @TODO: get url from jQuery.extend(Drupal.settings
          feedLink = 'http://alerts.colorado.edu';
        }
        
        $("#cu-alerts .alert").html('<a href="' + feedLink + '" style="color:#fff;">' + $(this).find("title").text() + '</a> - ' + $(this).find("pubDate").text());
      });
    }; 
       
})(jQuery);

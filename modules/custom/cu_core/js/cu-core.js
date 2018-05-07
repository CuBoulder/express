(function ($) {
  $(document).ready(function(){
    $('#navbar-bar').prepend('<div class="express-environment-indicator"><span class="express-environment-indicator-label"></span> <a href="#">Update Site Status</a></div>');
    
    // Prod New Launched
    $('.environment-production.infrastructure-new.status-launched .express-environment-indicator span').text('Live Site  - New Server Environment');
    // Prod New Staged
    $('.environment-production.infrastructure-new.status-staged span').text('Staged Site  - New Server Environment');
    // Prod Old Launched
    $('.environment-production.infrastructure-old.status-launched span').text('Live Site  - Old Server Environment');
    // Prod Old Launched
    $('.environment-production.infrastructure-old.status-staged span').text('Temporary Staging Site  - Old Server Environment');

    // Test Launched
    $('.environment-test.status-launched span').text('Testing Site');
    $('.environment-test.status-staged span').text('Temporary Training Site');
  });
}(jQuery));

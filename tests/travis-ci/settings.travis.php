<?php

// Ensure secure pages is enabled.
//$conf['securepages_enable'] = TRUE;

// Never allow updating modules through UI.
$conf['allow_authorize_operations'] = FALSE;

// Caching across all of wwwng.
$conf['cache'] = TRUE;
$conf['block_cache'] = TRUE;

// Compress cached pages always off; we use mod_deflate
$conf['page_compression'] = 0;

// Min cache lifetime 0, max 5 mins * 60 = 300 seconds.
$conf['cache_lifetime'] = 0;
$conf['page_cache_maximum_age'] = 300;

// Aggregate css and js files.
$conf['preprocess_css'] = TRUE;
$conf['preprocess_js'] = TRUE;

// Drupal doesn't cache if we invoke hooks during bootstrap.
$conf['page_cache_invoke_hooks'] = FALSE;

// Setup cache_form bin.
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';

// Disable poorman cron.
$conf['cron_safe_threshold'] = 0;

// No IP blocking from the UI, we'll take care of that at a higher level.
$conf['blocked_ips'] = array();

# Need to do this to until we can properly support SSL.
$conf['securepages_enable'] = FALSE;
$conf['ldap_servers_require_ssl_for_credentails'] = '0';

$databases = array(
  'default' => array(
    'default' => array(
      'database' => 'drupal',
      'username' => 'root',
      'password' => '',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

// Define tmp directory
$conf['file_temporary_path'] = '/tmp';

// Turn on error reporting only for serious errors.
// Warnings were causing dumb exceptions in Behat and the messages don't
// interfere with the tests.
error_reporting(E_ERROR | E_PARSE);

// Disable metatag for now.
$conf['metatag_enable_node'] = 0;
$conf['metatag_enable_file'] = 0;
$conf['metatag_enable_bean'] = 0;
$conf['metatag_enable_user'] = 0;
$conf['metatag_enable_taxonomy_term'] = 0;

// Can't make external requests on Travis CI.
$conf['drupal_http_request_fails'] = FALSE;

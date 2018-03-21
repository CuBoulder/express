<?php

/**
 * @file
 * Non administrative page callbacks for SimpleSamlPHP Auth module.
 */

/**
 * Returns markup for SimpleSAMLphp login page.
 *
 * Represents the Drupal page (saml_login), which triggers user authentication
 * against the SimpleSAMLphp service provider.
 */
function simplesamlphp_auth_loginpage() {

  // Get the simplesamlphp session.
  $loaded = _simplesaml_auth_autoload();
  if (!$loaded) {
    return FALSE;
  }

  global $user;
  global $base_url;
  global $_simplesamlphp_auth_as;
  global $_simplesamlphp_auth_saml_attributes;
  module_load_include('inc', 'simplesamlphp_auth');

  // The user is not logged into Drupal.
  if ($user->uid == 0) {
    _simplesaml_auth_login_register();
  }
  // The user is already logged into Drupal.
  else {
    simplesaml_auth_moderate_local_login();
  }

  $fail = NULL;
  $output = NULL;

  // Do some sanity checking before attempting anything.
  $config = SimpleSAML_Configuration::getInstance();
  $config_store_type = $config->getValue('store.type');

  // Make sure phpsession is NOT being used.
  if ($config_store_type == 'phpsession') {
    watchdog('simplesamlphp_auth', 'A user attempted to login using simplesamlphp but the store.type is phpsession, use memcache or sql for simplesamlphp session storage. See: simplesamlphp/config/config.php.', NULL, WATCHDOG_WARNING);
    $fail = TRUE;
  }

  // Make sure there is an instance of SimpleSAML_Auth_Simple.
  if (!$_simplesamlphp_auth_as) {
    watchdog('simplesamlphp_auth', 'A user attempted to login using this module but there was a problem.', NULL, WATCHDOG_WARNING);
    $fail = TRUE;
  }

  // There was a problem, we can't go on, but we don't want to tell the user any
  // specifics either.
  if ($fail) {
    drupal_set_message(t("We're sorry. There was a problem attempting login. The issue has been logged for the administrator."), 'error');
    drupal_goto('user/login');
  }

  $return_to = NULL;

  // Support for deep linking.

  // See if a URL has been explicitly provided in ReturnTo. If so, use it (as
  // long as it points to this site).
  if ((isset($_REQUEST['ReturnTo']) && $_REQUEST['ReturnTo']) &&
    (valid_url($_REQUEST['ReturnTo']) && stristr($_REQUEST['ReturnTo'], $base_url))) {

    $return_to = $_REQUEST['ReturnTo'];

    // If not, see if a REFERER URL is available. If so, use it (as long as it
    // points to this site).
  }
  elseif ((isset($_SERVER['HTTP_REFERER']) && $_SERVER['HTTP_REFERER']) &&
    (valid_url($_SERVER['HTTP_REFERER']) && stristr($_SERVER['HTTP_REFERER'], $base_url))
  ) {

    $return_to = $_SERVER['HTTP_REFERER'];
  }

  // If the user is anonymous, set the cookie (if we can) and require
  // authentication.
  if ($user->uid == 0) {

    if ($return_to) {
      // Set the cookie so we can deliver the user to the place they started.
      setrawcookie('simplesamlphp_auth_returnto', $return_to, time() + 60 * 60);
    }

    // Require the user to be authenticated.
    $_simplesamlphp_auth_as->requireAuth();

    // If the user is authenticated, send them along.
  }
  else {

    $go_to_url = NULL;

    // Check to see if we've set a cookie. If there is one, give it priority.
    if (isset($_COOKIE['simplesamlphp_auth_returnto']) && $_COOKIE['simplesamlphp_auth_returnto']) {
      // Use the cookie for the ReturnTo.
      $go_to_url = $_COOKIE['simplesamlphp_auth_returnto'];

      // Unset the cookie.
      setrawcookie('simplesamlphp_auth_returnto', '');

    }
    elseif ($return_to) {
      $go_to_url = $return_to;
    }

    // If a ReturnTo has been set.
    if ($go_to_url) {
      $parsed_gotourl = drupal_parse_url($go_to_url);
      drupal_goto($parsed_gotourl['path'], $parsed_gotourl);
    }
    else {
      drupal_goto('user/' . $user->uid);
    }

  }

  return $output;
}

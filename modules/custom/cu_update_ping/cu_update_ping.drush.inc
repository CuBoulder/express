<?php

/**
 * @file
 * Update ping module drush integration.
 */

/**
 * Implements hook_drush_command().
 *
 * @return array
 *   An associative array describing your command(s).
 *
 * @see drush_parse_command()
 */
function cu_update_ping_drush_command() {
  $items = array();

  $items['update-ping'] = array(
    'description' => "Update the Atlas Statistic item.",
    'options' => array(
      'modules' => "Only ping for these modules",
    ),
  );

  return $items;
}

/**
 * Implements hook_drush_help().
 */
function cu_update_ping_drush_help($section) {
  switch ($section) {
    case 'drush:update-ping':
      return dt("Sends pings to Drupal's update server to add to module useage stats.");
  }
}


/**
 * Command callback to ping all enabled modules or a passed list of modules.
 */
function drush_cu_update_ping_update_ping() {
  // Generate site key to send to drupal.org.
  // The site key is what adds a reported install to useage stats.
  global $base_url;
  $site_key = drupal_hmac_base64($base_url, drupal_get_private_key());

  if ($modules = drush_get_option('modules')) {
    $modules_list = db_query("SELECT name, filename FROM {system} WHERE type = 'module' AND status = 1 AND name IN (:modules)", array(':modules' => explode(',', $modules)))->fetchAll();
  }
  else {
    // Get enabled modules of site to report usage of.
    $modules_list = db_query("SELECT name, filename FROM {system} WHERE type = 'module' AND status = 1")->fetchAll();
  }

  // Loop through each module and ping d.o servers.
  foreach ($modules_list as $module) {
    // Reset counter.
    $failed_attempts = 0;

    $info = drupal_parse_info_file(str_replace('.module', '.info', $module->filename));

    // If project has no version or is core module, then skip the ping.
    if (!isset($info['version']) || $info['package'] == 'Core') {
      continue;
    }

    // This url was gathered from update.fetch.inc#152
    $url = 'http://updates.drupal.org/release-history/' . $module->name . '/7.x?site_key=' . $site_key . '&version=' . $info['version'] . '&list=' . $module->name;
    $xml = drupal_http_request($url);

    // If request fails, retry.
    while ($failed_attempts < 2 && $xml->status_message != 'OK') {
      $xml = drupal_http_request($url);
      $failed_attempts++;
    }

    // Write a watchdog message if request fails three times.
    if ($xml->status_message != 'OK') {
      watchdog('cu_update_ping', $module->name . ' didn\'t successfully ping Drupal\'s update servers.');
    }

    // Just in case the Drupal server is suspicious as I am.
    sleep(1);
  }
}

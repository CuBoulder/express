<?php

/**
 * @file
 * CTools Drush commands.
 */

/**
 * Implements hook_drush_command().
 */
function erus_drush_command() {
  $items = array();

  $items['erus-up'] = array(
    'aliases' => array('eup'),
    'callback' => 'erus_drush_update',
    'description' => 'Update all external update status modules with the latest recommended version.',
    'examples' => array(
      'drush eup' => 'Update all ERUS status modules.',
    ),
  );

  return $items;
}

/**
 * Implementation of hook_drush_help().
 */
function erus_drush_help($section) {
  switch ($section) {
    case 'meta:erus:title':
      return dt('Erus commands');

    case 'meta:erus:summary':
      return dt('Erus drush commands.');
  }
}

/**
 * A custom 'drush up' like command.
 *
 * @return bool
 *   Return early to not invoke process.
 */
function erus_drush_update() {

  $version = drush_core_version();
  if ($version < 6) {
    drush_log("Your drush version is too old. Please update to version 6.", "error");
    drush_user_abort();
    return FALSE;
  }

  drush_invoke_process('@self', 'pm-updatestatus');

  $continue = drush_confirm('Are you sure you want to continue with all updates?');
  if (!$continue) {
    drush_user_abort();
    return FALSE;
  }

  $args = array();
  $options = array('package-handler' => "erus_wget");
  drush_invoke_process('@self', 'pm-updatecode', $args, $options);
}

/**
 * Implementation of hook_drush_engine_type_info().
 */
function erus_drush_engine_type_info() {
  return array(
    'package_handler' => array(),
  );
}

/**
 * Used by dl and updatecode commands to determine how to download/update projects.
 */
function erus_drush_engine_package_handler() {
  return array(
    'erus_wget' => array(
      'description' => 'Download project packages using wget or curl.',
    ),
  );
}

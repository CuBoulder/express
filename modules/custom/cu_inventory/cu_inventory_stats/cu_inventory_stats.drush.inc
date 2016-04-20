<?php

/**
 * @file
 * Drush commands for inventory stats module.
 */

/**
 * Implements hook_drush_command().
 */
function cu_inventory_stats_drush_command() {
  $items = array();

  $items['atlas-update-stats'] = array(
    'callback' => 'drush_cu_inventory_stats_update_stats',
    'description' => 'Updates a site record with current statistics.',
    'aliases' => array('aus'),
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_FULL,
  );

  $items['atlas-clear-stats'] = array(
    'callback' => 'drush_cu_inventory_stats_atlas_clear_stats',
    'description' => 'Clears a site record of cached statistics.',
    'aliases' => array('acs'),
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_FULL,
  );

  return $items;
}

/**
 * Implements hook_drush_help().
 */
function cu_inventory_stats_drush_help($section) {
  switch ($section) {
    case 'drush:atlas-update-stats':
      return dt('Updates a site record with current statistics.');
      break;
    case 'drush:atlas-clear-stats':
      return dt('Clears a site record of cached statistics.');
      break;
  }
}

/**
 * Callback for drush:atlas-update-stats.
 *
 * Update site statistics via inventory.
 */
function drush_cu_inventory_stats_atlas_update_stats() {
  _cu_inventory_stats_validate_drush();
  module_load_include('inc', 'cu_inventory_stats', 'cu_inventory_stats');
  cu_inventory_stats_process_site_stats();
}

/**
 * Callback for drush:atlas-clear-stats.
 *
 * Clear site statistics via inventory.
 */
function drush_cu_inventory_stats_atlas_clear_stats() {
  _cu_inventory_stats_validate_drush();
  module_load_include('inc', 'cu_inventory_stats', 'cu_inventory_stats');
  cu_inventory_stats_empty_site_stats();
}

/**
 * Validation function to check if site statistics can be updated.
 */
function _cu_inventory_stats_validate_drush() {
  // If site has no sid, then exit with error.
  if (!$cu_sid = variable_get('cu_sid', FALSE)) {
    return drush_set_error('NO_SID', dt('Site has no inventory ID. Can\'t update site statistics.'));
  }

  // If inventory isn't up, then exit with an error.
  if (!cu_inventory_is_up()) {
    return drush_set_error('INVENTORY_NOT_UP', dt('Inventory is down. Can\'t update site statistics.'));
  }
}




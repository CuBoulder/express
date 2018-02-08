<?php

/**
 * Implements hook_drush_command().
 */
function cu_atlas_drush_command() {

  $commands['atlas_bundle'] = array(
    'description' => 'Get a bundle from Atlas.',
    'aliases' => array('atlas_bundle', 'atab'),
    'arguments' => array(
      'arg1' => 'Atlas ID of bundle (package).',
    ),
    'examples' => array(
      'drush atab' => 'Gets bundle from Atlas.',
      'drush atab 5931c1c435f7c3454f9ba7e3' => 'Argument value determines repo to be added via Atlas.',
    ),
  );

  return $commands;
}

/**
 * Drush command to add bundle to site. See cu_profile_module_manager.module for reference.
 *
 * @param $arg1
 */
function drush_cu_atlas_get_atlas_bundle($arg1) {
  preg_match('/^[a-zA-Z0-9_]*/', $arg1, $module);
  $package = _get_code_options($type = 'module', $name = $module[0]);

  $atlas_id = variable_get('atlas_id', NULL);
  $site_array = atlas_api_request('sites', $atlas_id);

  // Setup empty array for data that is changing.
  $request_data = array();

  // If the atlas form has been saved and set, then merge our arrays. Otherwise, override the non-existent array.
  if (!empty($arg1) && isset($site_array['code']['package'])) {
    $package_array = $site_array['code']['package'];
    $add_package = $package;
    $all_together_now = array_merge($package_array, $add_package);
    $request_data['code']['package'] = $all_together_now;
  } if (!empty($arg1) && !isset($site_array['code']['package'])) {
    $add_package = $package;
    $request_data['code']['package'] = $add_package;
  }

  // We only want to send a patch if something has changed.
  if (!empty($request_data)) {
    // Set the etag from the form.
    $request_data['_etag'] = $site_array['_etag'];
    atlas_api_request('sites', $atlas_id, 'PATCH', $request_data);
    drush_print(dt('@arg1 bundle has been requested from Atlas.', array('@arg1' => $module[0])));
  }
  else {
    drush_print(dt('No bundle was added, either request was empty or trouble connecting to Atlas.'), 'warning');
  }

}

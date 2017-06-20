<?php

/**
 * Page callback for admin/config/development/module-manager/settings
 */
function profile_module_manager_admin_settings() {
  $form = array();

  $form['profile_module_manager_disable_ui_lock'] = array(
    '#type' => 'checkbox',
    '#default_value' => variable_get('profile_module_manager_disable_ui_lock', 0),
    '#title' => t('Disable UI Lock'),
    '#description' => t('Disables the lock on ability enable or disable modules required by install profile through the user interface.  This also impacts drush.'),
  );
  $form['profile_module_manager_disable_enabling'] = array(
    '#type' => 'checkbox',
    '#default_value' => variable_get('profile_module_manager_disable_enabling', 0),
    '#title' => t('Disable the ability for users to enable bundles'),
    '#description' => t('Turns off the ability for users to enable bundles on the bundles list page.'),
  );
  $form['profile_module_manager_ignore_sites_all_bundle'] = array(
    '#title' => t('Hide all bundles from sites/all'),
    '#type' => 'checkbox',
    '#default_value' => variable_get('profile_module_manager_ignore_sites_all_bundle', FALSE),
    '#description' => t('Removes all bundles from bundle list page so that the output can be performed per module.'),
  );
  $form['profile_module_manager_disable_enabling_text'] = array(
    '#type' => 'textarea',
    '#cols' => 40,
    '#rows' => 5,
    '#default_value' => variable_get('profile_module_manager_disable_enabling_text'),
    '#title' => t('Bundles Disabled Text'),
    '#description' => t('Message that is displayed for users when they can\'t enable bundles.'),
    '#states' => array(
      'visible' => array(
        ':input[name="profile_module_manager_disable_enabling"]' => array('checked' => TRUE),
      ),
    ),
  );

  $bundles = array_keys(profile_module_manager_get_bundles('all'));
  $form['profile_module_manager_bundle_ignore'] = array(
    '#title' => t('Hidden Bundles'),
    '#type' => 'checkboxes',
    '#description' => t('You can select which bundles you want to be hidden from the end user on the bundles list page. This can be useful for soft launches or other use cases where you don\'t want certain users to be able to enable the bundle.'),
    '#default_value' => variable_get('profile_module_manager_bundle_ignore'),
    '#options' => drupal_map_assoc($bundles),
  );

  $form['actions'] = array(
    '#type' => 'actions',
    'submit' => array(
      '#type' => 'submit',
      '#value' => t('Save Configuration'),
    ),
  );

  return system_settings_form($form);
}

/**
 * Callback function for admin/settings/bundles/list/confirm/%
 */
function profile_module_manager_bundle_confirm($bundle_name) {
  $output = '';

  if (variable_get('profile_module_manager_disable_enabling', 0) == 1) {
    $output = '<p>' . variable_get('profile_module_manager_disable_enabling_text', 'The ability to enable bundles has been turned off.') . '</p>';
    return $output;
  }

  $bundle_path = drupal_get_path('module', $bundle_name);
  $bundle = drupal_parse_info_file($bundle_path . '/' . $bundle_name . '.info');

  // Only tell users about logout if bundle requires logout.
  if (isset($bundle['bundle_logout']) && $bundle['bundle_logout'] == 1) {
    // List all currently logged in users
    $interval = REQUEST_TIME - 900;
    $items = db_query('SELECT u.uid, u.name, MAX(s.timestamp) AS max_timestamp FROM {users} u INNER JOIN {sessions} s ON u.uid = s.uid WHERE s.timestamp >= :interval AND s.uid > 0 GROUP BY u.uid, u.name ORDER BY max_timestamp DESC', array(':interval' => $interval))->fetchAll();
    $users = '';
    $users_count = count($items) -1;
    foreach ($items as $key => $item) {
      if ($key == $users_count && $users_count != 0) {
        $users .= 'and ' . $item->name . ',';
      } else {
        $users .= $item->name . ', ';
      }
    }
    $output = '<p>You are about to enable the ' . $bundle['name'] . ' Bundle. <strong>NOTE: When this process starts it will logout all users, except: ' . $users . ' from editing the site until the process is complete.</strong></p>';
  } else {
    $output = '<p>You are about to enable the ' . $bundle['name'] . ' Bundle.</p>';
  }
  $output .= '<a href="' . $GLOBALS['base_url'] . '/admin/settings/bundles/list/enable/' . $bundle_name . '" title="Confirm"><div class="btn btn-primary">Confirm</div></a>';
  $output .= '<a href="' . $GLOBALS['base_url'] . '/admin/settings/bundles/list/" title="Cancel"><div class="btn btn-default">Cancel</div></a>';
  return $output;
}

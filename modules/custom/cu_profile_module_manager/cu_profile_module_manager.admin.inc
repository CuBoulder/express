<?php

function cu_profile_module_manager_bundles($enabled = FALSE, $type = NULL, $collection = NULL) {

  $output = array();
  $types = array('addon_bundles', 'request_bundles', 'beta_bundles', 'admin_bundles');

  // Get bundles that are available.
  $bundles = profile_module_manager_get_bundles($status = 'all');

  // Filter bundles.
  // Check for enabled/disabled.
  foreach ($bundles as $key => $bundle) {
    if($enabled) {
      if (!module_exists($key)) {
        unset($bundles[$key]);
      }
    }
    else {
      if (module_exists($key)) {
        unset($bundles[$key]);
      }
    }
  }

  $output['bundles'] = array();
  $output['bundles']['#prefix'] = '<div class="express-cards">';
  $output['bundles']['#suffix'] = '</div>';


  // Highlighted set?
  $set = isset($_GET['set']) ? check_plain($_GET['set']) : NULL;
  $highlight = isset($_GET['highlight']) ? check_plain($_GET['highlight']) : NULL;

  if ($set) {
    $set = cu_profile_module_manager_sets($set);
  }
  if($highlight) {
    $set = explode(',',$highlight);
  }


  // Loop through bundles.
  foreach ($bundles as $key => $bundle) {

    // Get content from .info file.
    $info_file = str_replace(".module", ".info", $bundle->filename);
    $info = drupal_parse_info_file($info_file);
    $type = !empty($info['bundle_group']) ? $info['bundle_group'] : NULL;

    // Build variables array for theming.
    $variables = array();

    $name = isset($info['name']) ? $info['name'] : $key;
    $name_lc = strtolower($name);
    $variables['name'] = $name;
    $variables['description'] = (isset($info['description']) ? $info['description'] : 'No description available.');

    $variables['enabled'] = module_exists($key) ? 1 : 0;


    // Only users with the "enable request bundles" permission can
    // directly enable request bundles.
    // All other users have a request submitted to support email for follow up.
    if ((!empty($info['bundle_group']) && $info['bundle_group'] == 'request_bundles') && !user_access('enable request bundles')) {
      $variables['enable_url'] = 'admin/settings/bundles/list/request/' . $name;
      $variables['enable_text'] = 'Request';
    }
    else {
      $variables['enable_url'] = 'admin/settings/bundles/list/confirm/' . $bundle->name;
      $variables['enable_text'] = 'Install';
    }
    // Demo url
    if (!empty($info['project_demo_url'])) {
      $variables['demo_url'] = $info['project_demo_url'];
    }

    // Add classes for bundle status, group, etc.
    $variables['bundle_classes'][] = module_exists($key) ? 'express-bundle-enabled' : 'express-bundle-disabled';
    $variables['bundle_classes'][] = (isset($info['bundle_group']) ? str_replace('_', '-', $info['bundle_group']) : 'no-bundle-group');

    // If bundles are being highlighted or filtered, add classes.
    if ($set) {
      if (in_array($name_lc, $set)) {
        $variables['bundle_classes'][] = 'highlighted-set';
      }
      else {
        $variables['bundle_classes'][] = 'set-excluded';
      }
    }
    // Don't add admin bundles if user can't enable them.
    if (
      (empty($info['bundle_group']))
      || (!empty($info['bundle_group']) && $info['bundle_group'] != 'admin_bundles')
      || user_access('enable admin bundles')
    ) {

      $output['bundles']['list'][$name_lc]['#markup'] = theme('express_bundle', $variables);
    }
  }
  // Sort bundles alphabetically
  ksort($output['bundles']['list']);
  return $output;
}

/**
 * Function to establish a collection of $bundles.
 * Array values should be lower case bundle names.
 */
function cu_profile_module_manager_sets($set = NULL) {
  $sets = array();
  $sets['blog'] = array('news and articles', 'social media', 'advanced content');


  if ($set) {
    return $sets[$set];
  }
  return FALSE;
}

/**
 * Implements hook_form().
 *
 * Form for requesting a bundle.
 * This emails the request to a support email account for follow up.
 */
function cu_profile_module_manager_request_bundle_form($form, &$form_state, $name) {
  $form = array();
  $name = check_plain($name);
  $form['confirmation'] = array(
    '#type' => 'markup',
    '#markup' => "<p>Are you sure you want to request the $name bundle be added to your site?</p>",
  );
  $form['bundle'] = array(
    '#type' => 'hidden',
    '#value' => $name,
  );
  $form['submit'] = array(
    '#type' => 'submit',
    '#value' => 'Request Bundle',
    '#submit' => array(
      'cu_profile_module_manger_send_request',
      'cu_profile_module_manager_request_bundle_form_submit'
    ),
  );


  $form['cancel'] = array(
    '#type' => 'submit',
    '#value' => 'Cancel',
    '#submit' => array('cu_profile_module_manager_request_bundle_form_cancel')
  );

  return $form;
}

/**
 * Submit function for cu_profile_module_manager_request_bundle_form().
 *
 * Notify user that request has been submitted and return them to bundle list.
 */
function cu_profile_module_manager_request_bundle_form_submit($form, &$form_state) {
  drupal_set_message('Your bundle request has been sent.');
  drupal_goto('admin/settings/bundles/list');
}

/**
 * Cancel function for bundle request form.
 */
function cu_profile_module_manager_request_bundle_form_cancel($form, &$form_state) {
  drupal_goto('admin/settings/bundles/list');
}

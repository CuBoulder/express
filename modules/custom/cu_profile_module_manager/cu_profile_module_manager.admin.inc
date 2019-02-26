<?php

function cu_profile_module_manager_bundles($enabled = FALSE, $type = NULL, $collection = NULL) {

  $output = array();

  // Get all bundles
  $bundles = profile_module_manager_get_bundles('all');

  // Filter bundle list based on whether we are displaying for enabled or avaiable.
  foreach ($bundles as $key => $bundle) {
    if($enabled != $bundle->status) {
      unset($bundles[$key]);
    }
  }

  if (count($bundles) == 0) {
    if ($enabled) {
      drupal_set_message(t("None of the available bundles have been enabled. Click the Available tab to see the list of bundles you can enable or request."), 'warning');
    } else {
      drupal_set_message(t("All available bundles have already been enabled."), 'warning');
    }
    return $output;
  }

  $output['bundles'] = array();
  $output['bundles']['#prefix'] = '<div class="express-cards">';
  $output['bundles']['#suffix'] = '</div>';

  // @TODO - do we need this?
  // Highlighted set?
  $set = isset($_GET['set']) ? check_plain($_GET['set']) : NULL;
  $highlight = isset($_GET['highlight']) ? check_plain($_GET['highlight']) : NULL;

  if ($set) {
    $set = cu_profile_module_manager_sets($set);
  }
  if($highlight) {
    $set = explode(',',$highlight);
  }

  // Loop through bundles and evaluate how they should be displayed
  foreach ($bundles as $key => $bundle) {

    // Get content from .info file.
    $info_file = str_replace(".module", ".info", $bundle->filename);
    $info = drupal_parse_info_file($info_file);

    $type = !empty($info['bundle_group']) ? $info['bundle_group'] : NULL;


    $request = !empty($info['bundle_request']) ? $info['bundle_request'] : 0;

    // Build variables array for theming.
    $variables = array();

    $name = isset($info['name']) ? $info['name'] : $key;
    $name_lc = strtolower($name);
    $variables['name'] = $name;
    $variables['description'] = (isset($info['description']) ? $info['description'] : 'No description available.');

    //$variables['enabled'] = module_exists($key) ? 1 : 0;

    // Users with the "skip bundle request step" permission can enable these
    // directly enable request bundles.
    // All other users have a request submitted to support email for follow up.
    if ($request && !user_access('skip bundle request step')) {
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

    // @TODO - Change to use role
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

    if (isset($info['bundle_roles']) && profile_module_manager_user_has_role($info['bundle_roles'])) {
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

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

  // Loop through bundles and evaluate how they should be displayed
  foreach ($bundles as $key => $bundle) {

    // Get content from .info file.
    $info_file = str_replace(".module", ".info", $bundle->filename);
    $info = drupal_parse_info_file($info_file);

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

    // Add classes for bundle group
    $variables['bundle_classes'][] = (isset($info['bundle_group']) ? str_replace('_', '-', $info['bundle_group']) : 'no-bundle-group');

    if (isset($info['bundle_roles']) && profile_module_manager_user_has_role($info['bundle_roles'])) {
      $output['bundles']['list'][$name_lc]['#markup'] = theme('express_bundle', $variables);
    }

  }
  // Sort bundles alphabetically
  ksort($output['bundles']['list']);

  return $output;
}




<?php

/**
 * @file
 * cu_ab_test.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function cu_ab_test_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "bean_admin_ui" && $api == "bean") {
    return array("version" => "5");
  }
}

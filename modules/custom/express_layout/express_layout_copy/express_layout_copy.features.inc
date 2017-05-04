<?php
/**
 * @file
 * express_layout_copy.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function express_layout_copy_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "bean_admin_ui" && $api == "bean") {
    return array("version" => "5");
  }
}

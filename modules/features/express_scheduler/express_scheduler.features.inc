<?php
/**
 * @file
 * express_scheduler.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function express_scheduler_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

<?php
/**
 * @file
 * express_layout_copy.bean.inc
 */

/**
 * Implements hook_bean_admin_ui_types().
 */
function express_layout_copy_bean_admin_ui_types() {
  $export = array();

  $bean_type = new stdClass();
  $bean_type->disabled = FALSE; /* Edit this to true to make a default bean_type disabled initially */
  $bean_type->api_version = 5;
  $bean_type->name = 'placeholder';
  $bean_type->label = 'Placeholder';
  $bean_type->options = '';
  $bean_type->description = '';
  $export['placeholder'] = $bean_type;

  return $export;
}

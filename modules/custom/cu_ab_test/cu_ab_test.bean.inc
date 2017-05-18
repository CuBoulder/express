<?php

/**
 * @file
 * cu_ab_test.bean.inc
 */

/**
 * Implements hook_bean_admin_ui_types().
 */
function cu_ab_test_bean_admin_ui_types() {
  $export = array();

  $bean_type = new stdClass();
  $bean_type->disabled = FALSE; /* Edit this to true to make a default bean_type disabled initially */
  $bean_type->api_version = 5;
  $bean_type->name = 'a_b_block';
  $bean_type->label = 'A/B Block';
  $bean_type->options = '';
  $bean_type->description = 'Display Blocks in a Multivariate Testing Way.';
  $export['a_b_block'] = $bean_type;

  return $export;
}

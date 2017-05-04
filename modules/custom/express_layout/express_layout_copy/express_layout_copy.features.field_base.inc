<?php
/**
 * @file
 * express_layout_copy.features.field_base.inc
 */

/**
 * Implements hook_field_default_field_bases().
 */
function express_layout_copy_field_default_field_bases() {
  $field_bases = array();

  // Exported field_base: 'field_express_layout_make_block'.
  $field_bases['field_express_layout_make_block'] = array(
    'active' => 1,
    'cardinality' => 1,
    'deleted' => 0,
    'entity_types' => array(),
    'field_name' => 'field_express_layout_make_block',
    'indexes' => array(
      'target_id' => array(
        0 => 'target_id',
      ),
    ),
    'locked' => 0,
    'module' => 'entityreference',
    'settings' => array(
      'handler' => 'views',
      'handler_settings' => array(
        'behaviors' => array(
          'views-select-list' => array(
            'status' => 0,
          ),
        ),
        'view' => array(
          'args' => array(),
          'display_name' => 'entityreference_1',
          'view_name' => 'express_layout_beans',
        ),
      ),
      'target_type' => 'bean',
    ),
    'translatable' => 0,
    'type' => 'entityreference',
  );

  return $field_bases;
}

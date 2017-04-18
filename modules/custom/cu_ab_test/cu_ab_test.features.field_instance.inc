<?php

/**
 * @file
 * cu_ab_test.features.field_instance.inc
 */

/**
 * Implements hook_field_default_field_instances().
 */
function cu_ab_test_field_default_field_instances() {
  $field_instances = array();

  // Exported field_instance: 'bean-a_b_block-field_block_option'.
  $field_instances['bean-a_b_block-field_block_option'] = array(
    'bundle' => 'a_b_block',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'above',
        'module' => 'field_collection',
        'settings' => array(
          'view_mode' => 'full',
        ),
        'type' => 'field_collection_fields',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'bean',
    'fences_wrapper' => 'div_div_div',
    'field_name' => 'field_block_option',
    'label' => 'Block Option',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'field_collection',
      'settings' => array(),
      'type' => 'field_collection_embed',
      'weight' => 31,
    ),
  );

  // Exported field_instance:
  // 'field_collection_item-field_block_option-field_block'.
  $field_instances['field_collection_item-field_block_option-field_block'] = array(
    'bundle' => 'field_block_option',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'above',
        'module' => 'entityreference',
        'settings' => array(
          'link' => FALSE,
        ),
        'type' => 'entityreference_label',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'field_collection_item',
    'fences_wrapper' => 'div_div_div',
    'field_name' => 'field_block',
    'label' => 'Block',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'entityreference',
      'settings' => array(
        'match_operator' => 'CONTAINS',
        'path' => '',
        'size' => 60,
      ),
      'type' => 'entityreference_autocomplete',
      'weight' => 1,
    ),
  );

  // Exported field_instance:
  // 'field_collection_item-field_block_option-field_counter'.
  $field_instances['field_collection_item-field_block_option-field_counter'] = array(
    'bundle' => 'field_block_option',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'above',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 2,
      ),
    ),
    'entity_type' => 'field_collection_item',
    'fences_wrapper' => 'div_div_div',
    'field_name' => 'field_counter',
    'label' => 'counter',
    'required' => 0,
    'settings' => array(
      'max' => '',
      'min' => 0,
      'prefix' => '',
      'suffix' => '',
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'number',
      'settings' => array(),
      'type' => 'number',
      'weight' => 3,
    ),
  );

  // Exported field_instance:
  // 'field_collection_item-field_block_option-field_percentage'.
  $field_instances['field_collection_item-field_block_option-field_percentage'] = array(
    'bundle' => 'field_block_option',
    'default_value' => array(
      0 => array(
        'value' => 50,
      ),
    ),
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'above',
        'module' => 'number',
        'settings' => array(
          'decimal_separator' => '.',
          'prefix_suffix' => TRUE,
          'scale' => 0,
          'thousand_separator' => '',
        ),
        'type' => 'number_integer',
        'weight' => 1,
      ),
    ),
    'entity_type' => 'field_collection_item',
    'fences_wrapper' => 'div_div_div',
    'field_name' => 'field_percentage',
    'label' => 'Percentage',
    'required' => 0,
    'settings' => array(
      'max' => 99,
      'min' => 1,
      'prefix' => '',
      'suffix' => '',
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'number',
      'settings' => array(),
      'type' => 'number',
      'weight' => 2,
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('Block');
  t('Block Option');
  t('Percentage');
  t('counter');

  return $field_instances;
}

<?php
/**
 * @file
 * express_layout_copy.features.field_instance.inc
 */

/**
 * Implements hook_field_default_field_instances().
 */
function express_layout_copy_field_default_field_instances() {
  $field_instances = array();

  // Exported field_instance:
  // 'bean-placeholder-field_express_layout_make_block'.
  $field_instances['bean-placeholder-field_express_layout_make_block'] = array(
    'bundle' => 'placeholder',
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
    'entity_type' => 'bean',
    'fences_wrapper' => 'div_div_div',
    'field_name' => 'field_express_layout_make_block',
    'label' => 'Block',
    'required' => 0,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'inline_entity_form',
      'settings' => array(
        'fields' => array(),
        'type_settings' => array(
          'allow_clone' => 0,
          'allow_existing' => 1,
          'allow_new' => 1,
          'delete_references' => 0,
          'label_plural' => 'entities',
          'label_singular' => 'entity',
          'match_operator' => 'CONTAINS',
          'override_labels' => 0,
        ),
      ),
      'type' => 'inline_entity_form',
      'weight' => 2,
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('Block');

  return $field_instances;
}

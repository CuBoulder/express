<?php
/**
 * @file
 * cu_page.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function cu_page_field_group_info() {
  $field_groups = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_intro|node|page|form';
  $field_group->group_name = 'group_intro';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'page';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Intro',
    'weight' => '1',
    'children' => array(
      0 => 'field_page_intro',
    ),
    'format_type' => 'fieldset',
    'format_settings' => array(
      'label' => 'Intro',
      'instance_settings' => array(
        'required_fields' => 1,
        'id' => '',
        'classes' => 'group-intro field-group-fieldset',
        'description' => 'Add a sub-head or introduction text.',
      ),
      'formatter' => 'collapsed',
    ),
  );
  $field_groups['group_intro|node|page|form'] = $field_group;

  // Translatables
  // Included for use with string extractors like potx.
  t('Intro');

  return $field_groups;
}

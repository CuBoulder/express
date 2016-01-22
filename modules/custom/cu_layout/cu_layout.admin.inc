<?php

/**
 * Manual form for migrating to entity layouts.
 */
function cu_layout_migrate_form($form, &$form_state) {
  $form = array();
  $form['migrate_layout'] = array(
    '#type' => 'hidden',
    '#value' => 'migrate_layouts',
  );
  $form['submit'] = array('#type' => 'submit', '#value' => t('Migrate Layout Settings'));
  $form['#submit'][] = 'cu_layout_migrate';
  return $form;
}
/**
 * Submit function for cu_layout_migrate_form.
 */
function cu_layout_migrate() {
  // Make sure all nodes have layout entities
  $nodes = entity_load('node');
  foreach ($nodes as $node) {
    cu_layout_migrate_create($node);
  }

  // Migrate fields to layout entities
  // The following code currently creates new records instead of updating
  // the current records. This still works but old records should be removed.
  $fields = field_info_instances('express_layout', 'express_layout');
  unset($fields['field_feature_layout_toggle']);
  foreach ($fields as $key => $field) {
    $data_field = 'field_data_' . $key;
    $result = db_query("SELECT * FROM {$data_field}");
    foreach ($result as $record) {
      $record->entity_type = 'express_layout';
      $record->bundle = 'express_layout';
      drupal_write_record ($data_field, $record);
      //drupal_set_message('Layout reference migrated');
    }
    $revision_field = 'field_revision_' . $key;
    $result = db_query("SELECT * FROM {$revision_field}");
    foreach ($result as $record) {
      $record->entity_type = 'express_layout';
      $record->bundle = 'express_layout';
      drupal_write_record ($revision_field, $record);
      //drupal_set_message('Layout reference revision migrated');
    }
  }
  // Update IEF fields.
  _cu_layout_update_fields();
  // Clear the caches so the migrated content shows.
  cache_clear_all();
  drupal_set_message('Layout migration completed.');
}

/**
 * Migrate function to create layouts for each node.
 */
function cu_layout_migrate_create($node) {
  $nid = $node->nid;
  if (!entity_load_single('express_layout', $nid)) {
    $values = array(
      'layout_id' => $nid,
      'title' => 'Layout: ' . $node->title,
      'node_type' => $node->type,
    );

    $layout = entity_create('express_layout', $values);
    entity_save('express_layout', $layout);
    //drupal_set_message('Layout: ' . $node->title . ' created. Layout ID:' . $nid);
  }
}

/**
 * Update IEF fields since view name has changed.
 */
function _cu_layout_update_fields() {
  $fields = array(
    'field_footer',
    'field_header',
    'field_intro',
    'field_sidebar_first',
    'field_sidebar_second',
    'field_slider',
    'field_wide_2',
    'field_inner_content_left',
    'field_inner_content_right',
  );
  foreach ($fields as $field) {
    $info = field_info_field($field);
    $info['settings']['handler_settings']['view']['view_name'] = 'express_layout_beans';
    field_update_field($info);
  }
}

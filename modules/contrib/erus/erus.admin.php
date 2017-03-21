<?php
/**
 * @file
 * Administrative interface functionality
 */

/**
 * List out all plugins and provide an edit link.
 */
function erus_admin_config_administration_erus() {
  $output = "";

  $plugins = erus_get_erus_plugin_info();
  drupal_set_title('ERUS Plugin List');

  $header = array('Plugin Name', 'Module', 'Operations');
  $rows = array();

  foreach ($plugins as $plugin_name => $values) {
    $row = array($plugin_name, $values['module'], l('edit', 'admin/config/administration/erus/' . $plugin_name));
    $rows[] = $row;
  }

  $table_element = array(
    '#theme' => 'table',
    '#header' => $header,
    '#rows' => $rows,
    '#empty' =>t('You have no plugins defined. Something is wrong.'),
  );

  $output .= drupal_render($table_element);

  return $output;
}


/**
 * Implements hook_form().
 */
function erus_plugin_configuration_form($node, &$form_state) {

  $plugin_name = arg(4);
  $plugin = erus_load_erus_plugin(array('plugin' => $plugin_name));

  if (!$plugin) {
    drupal_set_message('Could not find plugin by that name', 'error');
    return false;
  }

  drupal_set_title($plugin_name . ' ERUS plugin configuration form');

  $form = $plugin->get_configuration_form();

  if (empty($form)) {
    drupal_set_message('No configuration options for this plugin are available.');
    return;
  }

  $form['erus_hidden_plugin_name'] = array(
    '#type' => 'hidden',
    '#value' => $plugin_name,
  );

  $form['submit'] = array(
    '#type' => 'submit',
    '#value' => t('Submit'),
  );

  // Add default values from DB
  $values = variable_get('erus_' . $plugin_name, array());

  // Loop through the values.
  foreach ($values as $field_name => $value) {

    if (module_exists('encrypt') && $form[$field_name]['#type'] == "password") {
      $value = decrypt($value);
    }

    $form[$field_name]['#default_value'] = $value;
  }

  return $form;
}


/**
 * Submit handler for configuration_form
 * @param  [type] $form       [description]
 * @param  [type] $form_state [description]
 * @return [type]             [description]
 */
function erus_plugin_configuration_form_submit($form, $form_state) {

  $values = $form_state['values'];
  $plugin_name = check_plain($values['erus_hidden_plugin_name']);
  unset($values['erus_hidden_plugin_name']);

  // Quick sanitize
  foreach ($values as $key => $value) {
    $values[$key] = check_plain($value);
  }

  // If the encrypt module is available lets encrypt all password fields.
  if (module_exists('encrypt')) {
    foreach ($form as $k => $val) {
      if ($val['#type'] == "password") {
        $values[$k] = encrypt($values[$k]);
      }
    }
  }

  variable_set('erus_' . $plugin_name, $values);

  drupal_set_message('Configuration Options Saved');
}

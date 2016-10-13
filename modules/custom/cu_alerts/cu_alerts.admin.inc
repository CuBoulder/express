<?php
/**
 * @file
 * Administrative configurations for the cu_alerts module
 */

/**
 * Page callback for admin/config/system/cu_alerts.
 */
function cu_alerts_admin_settings_form() {
  $form = array();

  $form['rave_alerts_production_url'] = array(
    '#type' => 'textfield',
    '#title' => 'Rave Alerts Production URL',
    '#default_value' => variable_get('rave_alerts_production_url', ''),
  );
  $form['rave_alerts_testing_url'] = array(
    '#type' => 'textfield',
    '#title' => 'Rave Alerts Testing URL',
    '#default_value' => variable_get('rave_alerts_testing_url', ''),
  );

  $form['rave_alerts_environment'] = array(
    '#type' => 'select',
    '#title' => 'Environment',
    '#default_value' => variable_get('rave_alerts_environment', 'production'),
    '#required' => TRUE,
    '#options' => array(
      'production' => t('Production'),
      'test' => t('Test'),
    ),
    '#description' => t('Test mode will pull alerts from the development URL entered above.'),
  );
  $form['rave_alerts_message_off'] = array(
    '#type' => 'textfield',
    '#title' => 'Rave Alerts Off Message',
    '#default_value' => variable_get('rave_alerts_message_off', ''),
    '#description' => t('When this message is sent as a Rave Alert, the website alerts will stop displaying'),
  );

  return system_settings_form($form);
}

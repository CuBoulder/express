<?php
/**
 * @file
 * Administrative configurations for the RAVE Alerts module
 */

/**
 * Page callback for admin/config/system/cap_alerts.
 */
function cap_alerts_admin_settings_form() {
  $form = array();

  // @TODO: Add connection confirmation
  // @TODO: Add option to set all variables?

  if (variable_get('cap_alerts_url', FALSE)) {
    $data = cap_alerts_remote_data();
    dsm($data);
  }

  $form['cap_alerts_url'] = array(
    '#type' => 'textfield',
    '#title' => 'CAP URL',
    '#default_value' => variable_get('cap_alerts_url', 'http//www.getrave.com/cap/DemoUniversityAlert/channel8'),
  );
  $form['cap_alerts_deafult_read_more_url'] = array(
    '#type' => 'textfield',
    '#title' => 'Default Read More URL',
    '#default_value' => variable_get('cap_alerts_deafult_read_more_url', ''),
    '#description' => t('This will be included as a Read More link in the banner unless a link is provided from RSS')
  );
  $form['cap_alerts_network_fail_message'] = array(
    '#type' => 'textarea',
    '#cols' => 40,
    '#rows' => 5,
    '#default_value' => variable_get('cap_alerts_network_fail_message', 'Network Failure: Please go directly to http://alerts.colorado.edu or http://colorado.edu/alerts for current information.'),
    '#title' => t('Network Failure Message'),
    '#description' => t('This message is displayed when the CAP Alerts module cannot connect to the url of source.'),
  );

  // ADVANCED OPTIONS
  $form['cap_alerts_active_text'] = array(
    '#type' => 'textfield',
    '#title' => 'Active Mode Value',
    '#default_value' => variable_get('cap_alerts_active_text', 'Critical'),
    '#description' => t('When this text appears in the description field of a Rave Alert, the website alerts will switch to active mode'),
  );
  $form['cap_alerts_clear_text'] = array(
    '#type' => 'textfield',
    '#title' => 'Clear Text',
    '#default_value' => variable_get('cap_alerts_clear_text', 'All Clear'),
    '#description' => t('When this text appears in the headline element of a CAP formatted Alert, the website alerts will stop displaying the alert block'),
  );

  return system_settings_form($form);
}

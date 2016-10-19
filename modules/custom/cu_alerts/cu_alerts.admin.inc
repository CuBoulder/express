<?php
/**
 * @file
 * Administrative configurations for the RAVE Alerts module
 */

/**
 * Page callback for admin/config/system/cu_alerts.
 */
function cu_alerts_admin_settings_form() {
  $form = array();

  // @TODO: Add connection confirmation
  // @TODO: Add option to set all variables?

  if (variable_get('rave_alerts_rss_url', FALSE)) {
    $data = cu_alerts_remote_data();
    dsm($data);
  }

  $form['rave_alerts_rss_url'] = array(
    '#type' => 'textfield',
    '#title' => 'RAVE RSS URL',
    '#default_value' => variable_get('rave_alerts_rss_url', '//www.getrave.com/rss/DemoUniversityAlert/channel8'),
  );
  $form['rave_alerts_deafult_read_more_url'] = array(
    '#type' => 'textfield',
    '#title' => 'Default Read More URL',
    '#default_value' => variable_get('rave_alerts_deafult_read_more_url', ''),
    '#description' => t('This will be included as a Read More link in the banner unless a link is provided from RSS')
  );

  // ADVANCED OPTIONS
  $form['rave_alerts_active_text'] = array(
    '#type' => 'textfield',
    '#title' => 'Active Mode Text',
    '#default_value' => variable_get('rave_alerts_active_text', '[ACTIVE]'),
    '#description' => t('When this text appears in the description field of a Rave Alert, the website alerts will switch to active mode'),
  );
  $form['rave_alerts_clear_text'] = array(
    '#type' => 'textfield',
    '#title' => 'Clear Text',
    '#default_value' => variable_get('rave_alerts_clear_text', '[CELAR]'),
    '#description' => t('When this text appears in the description field of a Rave Alert, the website alerts will stop displaying'),
  );

  return system_settings_form($form);
}

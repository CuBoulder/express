<?php
function curise_form_system_theme_settings_alter(&$form, &$form_state) {
  $theme = $form_state['build_info']['args'][0];

  $form['expressbase_theme_settings']['banner'] = array(
		'#type' => 'fieldset',
		'#title' => t('Banner Color'),
		'#collapsible' => TRUE,
		'#collapsed' => TRUE,
	);
	$form['expressbase_theme_settings']['banner']['banner_color'] = array(
	  '#type' => 'select',
	  '#title' => t('Banner Color'),
	  '#default_value' => theme_get_setting('banner_color', 'curise') ? theme_get_setting('banner_color', 'curise') : 'black',
	  '#description' => t('Pick a banner color for your site.'),
	  '#options' => array(
      'dark' => t('Dark'),
      'light' => t('Light'),
    ),
	);
}

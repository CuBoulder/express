<?php

/**
 * Callback function for admin/theme/block-designer.
 *
 * Display a list of Block Designer Themes with edit/delete/preview links.
 */
function express_block_designer_themes_list() {
  drupal_set_title('Block Designer Themes');
  $output['description']['#markup'] = '<p>Block Designer Themes give you a quick and easy way to apply designs to blocks.</p>';
  $query = db_select('express_block_designer_themes', 'ebdt');
  $query->fields('ebdt', array('id', 'block_theme_name', 'block_settings'));
  $query->orderBy('block_theme_name', 'ASC');
  $results = $query->execute()->fetchAll();
  // Table headers.
  $header = array(
    'Block Designer Theme',
    'Operations',
  );
  $data = array();
  $path = current_path();
  // Loop through returned Block Designer Themes.
  foreach ($results as $result) {
    // Prepare operations links.
    $links = array();
    // Edit link.
    $links[] = l('Edit', 'admin/theme/block-designer/' . $result->id . '/edit', array('query' => array('destination' => $path)));
    // Delete link.
    $links[] = l('Delete', 'admin/theme/block-designer/' . $result->id . '/delete', array('query' => array('destination' => $path)));
    // Preview link.
    $links[] = l('Preview', 'express/preview/block-designer-themes/' . $result->id);
    // Prepare row for table output.
    $data[] = array(
      $result->block_theme_name,
      join(' | ', $links),
    );
  }
  // Render list of Block Designer Themes as a table.
  $output['block_themes']['#markup'] = theme('table', array('header' => $header, 'rows' => $data ));

  return $output;
}

/**
 * Implements hook_form().
 *
 * Form for editing Block Designer settings for a given block.
 */
function express_block_designer_form($form, &$form_state, $module, $delta) {
  $form = array();
  // Load block so we get all info we need.
  $block = block_load($module, $delta);
  $info = module_invoke($block->module, 'block_info');
  // Set page title as block delta.
  if (isset($info[$block->delta])) {
    drupal_set_title(t("Block Designer: '%name'", array('%name' => $info[$block->delta]['info'])), PASS_THROUGH);
    $delta = $block->delta;
    $module_delta = $module . '_' . $block->delta;
  }
  // Load Block Designer settings for this block.
  $saved = express_block_designer_load($module_delta);
  // Get settings
  $settings = $saved ? unserialize($saved->block_settings) : array();

  // If this is an existing config, add id.
  if ($saved) {
    $form['id']= array(
      '#type' => 'hidden',
      '#value' => $saved->id,
    );
  }

  // Block delta.
  $form['block_delta'] = array(
    '#type' => 'hidden',
    '#value' => $delta,
  );
  $form['module_block_delta'] = array(
    '#type' => 'hidden',
    '#value' => $module_delta,
  );

  // Block delta.
  $form['module'] = array(
    '#type' => 'hidden',
    '#value' => $module,
  );
  $description = file_get_contents(drupal_get_path('module', 'express_block_designer') . '/templates/express-block-designer-description.tpl.php');
  $form['block_designer_description'] = array(
    '#type' => 'markup',
    '#markup' => $description,
  );
  // Theme.
  $form['theme'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Theme',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );

  // Link to create a Block Designer Theme.
  $create_link = l('Create a Block Designer Theme', 'admin/theme/block-designer/add');

  // Link to preview Block Designer Themes.
  $preview_link = l('Preview Block Designer Themes', 'admin/theme/block-designer/preview');

  $block_theme_options = express_block_designer_theme_options();

  // If there are no block designer themes, just show create link.
  if (empty($block_theme_options)) {

    $form['theme']['no_block_themes'] = array(
      '#type' => 'markup',
      '#markup' => '<p>There are no Block Designer Themes available. $create_link.</p>'
    );
  }
  // Otherwise, show the select field of available themes, save button, etc.
  else {
    $form['theme']['block_theme'] = array(
      '#type' => 'select',
      '#title' => 'Theme',
      '#options' => $block_theme_options,
      '#description' => "<p>Choose a pre-configured theme for the block.
      <em>You can override the theme settings by configuring the options below.</em>.</p><p>$preview_link &bull; $create_link</p>",
      '#default_value' => isset($saved->block_theme) ? $saved->block_theme : 'none',
    );
    $inherit_values = variable_get('express_block_designer_inherit_values', array());
    if (is_array($inherit_values) && !empty($inherit_values)) {
      $form['theme']['theme_inherit']['description'] = array(
        '#type' => 'markup',
        '#markup' => '<p class="description">Set all configuration options to inherit the block theme settings.</p>',
        '#prefix' => '<div class="form-item">',

        '#suffix' => '</div>',
      );
      $form['theme']['theme_inherit']['inherit'] = array(
        '#type' => 'submit',
        '#value' => 'Save & Inherit Block Theme Settings',
        '#submit' => array('express_block_designer_form_inherit'),
      );
    }
  }

  // Icon.
  $form['icon'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Icon',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  // Icon style.
  $style_options = variable_get('express_block_designer_icon_style_options', array(
    'default' => 'Default',
    'inherit' => 'Inherit',
    'offset' => 'Offset',
    'top' => 'Top',
  ));
  $form['icon']['exbd_icon_style'] = array(
    '#title' => 'Style',
    '#type' => 'select',
    '#options' => $style_options,
    '#default_value' => isset($settings['exbd_icon_style']) ? $settings['exbd_icon_style'] : 'default',
  );
  // Icon color.
  $color_options = variable_get('express_block_designer_icon_color_options', array(
    'default' => 'Default',
    'inherit' => 'Inherit',
    'blue' => 'Blue',
    'gray' => 'Gray',
    'gold' => 'Gold',
    'green' => 'Green',
    'orange' => 'Orange',
    'purple' => 'Purple',
    'red' => 'Red',
    'yellow' => 'Yellow',
  ));
  $form['icon']['exbd_icon_color'] = array(
    '#title' => 'Icon Color',
    '#description' => t('Choose the icon color'),
    '#type' => 'select',
    '#options' => $color_options,
    '#default_value' => isset($settings['exbd_icon_color']) ? $settings['exbd_icon_color'] : 'default',
  );
  // If there are no color options, remove access to this field.
  if (empty($color_options)) {
    $form['icon']['exbd_icon_color']['#access'] = FALSE;
  }
  // Icon size.
  $form['icon']['exbd_icon_size'] = array(
    '#title' => 'Icon Size',
    '#description' => t('Choose the icon size'),
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'increase' => 'Increase',
    ),
    '#default_value' => isset($settings['exbd_icon_size']) ? $settings['exbd_icon_size'] : 'default',
  );

  // Icon list.
  $form['icon']['icon_list'] = array(
    '#type' => 'fieldset',
    '#title' => 'Icons',
    '#collapsible' => TRUE,
    '#collapsed' => TRUE,
  );
  $icon_options = array('none' => 'none');
  $icon_options = array_merge($icon_options, express_block_designer_icon_list($add_icon = TRUE));
  $form['icon']['icon_list']['exbd_icon'] = array(
    '#title' => 'Icon',
    '#type' => 'radios',
    '#options' => $icon_options,
    '#default_value' => isset($settings['exbd_icon']) ? $settings['exbd_icon'] : 'none',
  );

  // Heading
  $form['heading'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Heading',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $form['heading']['exbd_heading'] = array(
    '#title' => 'Heading',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default (H2)',
      'inherit' => 'Inherit',
      'h3' => 'H3',
      'h4' => 'H4',
      'h5' => 'H5',
      'h6' => 'H6',
      'strong' => 'Strong',
    ),
    '#default_value' => isset($settings['exbd_heading']) ? $settings['exbd_heading'] : 'default',
    '#description' => 'This setting should be used to put your content in the proper hierarchy, not to change the font size of the title.',
  );
  // Heading alignment.
  $form['heading']['exbd_heading_align'] = array(
    '#title' => 'Heading Alignment',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'centered' => 'Centered',
    ),
    '#default_value' => isset($settings['exbd_heading_align']) ? $settings['exbd_heading_align'] : 'default',
  );
  // Heading style.
  $form['style'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Style',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $form['style']['exbd_style'] = array(
    '#title' => 'Style',
    '#type' => 'radios',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'light_gray' => 'Light Gray',
      'dark_gray' => 'Dark Gray',
      'tan' => 'Tan',
      'lightblue' => 'Light Blue',
      'outline' => 'Outline',
      'underline' => 'Underline',
    ),
    '#default_value' => isset($settings['exbd_style']) ? $settings['exbd_style'] : 'default',
  );
  // Typography.
  $form['typography'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Typography',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  // Font scale block title.
  $form['typography']['exbd_font_scale_title'] = array(
    '#title' => 'Block Title Font Scale',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'increase' => 'Increase',
      'decrease' => 'Decrease',
    ),
    '#default_value' => isset($settings['exbd_font_scale_title']) ? $settings['exbd_font_scale_title'] : 'none',
  );
  // Font scale block content.
  $form['typography']['exbd_font_scale_content'] = array(
    '#title' => 'Block Content Font Scale',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'increase' => 'Increase',
      'decrease' => 'Decrease',
    ),
    '#default_value' => isset($settings['exbd_font_scale_content']) ? $settings['exbd_font_scale_content'] : 'none',
  );
  // Block menus.
  $form['menu'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Menu',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
    '#access' => FALSE,
  );
  $form['menu']['exbd_menu_style'] = array(
    '#title' => 'Menu Style',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'inherit' => 'Inherit',
      'style_1' => 'Style 1',
      'style_2' => 'Style 2',
    ),
    '#default_value' => isset($settings['exbd_menu_style']) ? $settings['exbd_menu_style'] : 'default',
  );
  // Examples of menus using #states.
  $form['menu']['examples']['menu_style_default'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Default Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'default'),
      ),
    ),
  );
  $form['menu']['examples']['menu_style_1'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Style 1 Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'style_1'),
      ),
    ),
  );
  $form['menu']['examples']['menu_style_2'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Style 2 Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'style_2'),
      ),
    ),
  );
  // Only visible if the block is a menu.
  if ($module == 'menu') {
    $form['menu']['#access'] = TRUE;
  }

  // Save
  $form['actions']['submit'] = array(
    '#type' => 'submit',
    '#value' => 'Save',
  );



  $default_values = variable_get('express_block_designer_default_values', array());

 /*
  if (is_array($default_values) && !empty($default_values)) {
    $form['actions']['default'] = array(
      '#type' => 'submit',
      '#value' => 'Set to Default',
      '#submit' => array('express_block_designer_form_default'),
    );
  }
  */

  if ($saved) {
    $form['actions']['delete'] = array(
      '#type' => 'submit',
      '#submit' => array('express_block_designer_form_delete'),
      '#value' => t('Remove Settings'),
    );
  }

  return $form;
}


/**
 * Implements hook_form().
 *
 * Block Designer Themes form.
 */
function express_block_designer_themes_form($form, &$form_state, $id = NULL) {
  $form = array();
  // Load the Block Designer Theme.
  $saved = express_block_designer_theme_load($id);

  // If loaded, this will be an update/delete, otherwise insert a new record.
  $settings = $saved ? unserialize($saved->block_settings) : array();

  // If not new, add Block Theme id.
  // If this is an existing config, add id.
  if ($saved) {
    $form['id']= array(
      '#type' => 'hidden',
      '#value' => $saved->id,
    );
  }
  // Theme name.
  $form['block_theme_name'] = array(
    '#type' => 'textfield',
    '#title' => 'Name',
    '#default_value' => isset($saved->block_theme_name) ? $saved->block_theme_name : '',
    '#description' => 'A name describing your block theme',
  );

  // Icon.
  $form['icon'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Icon',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $style_options = variable_get('express_block_designer_icon_style_options', array(
    'inline' => 'Inline',
    'offset' => 'Offset',
    'top' => 'Top',
  ));
  // Icon style.
  $form['icon']['exbd_icon_style'] = array(
    '#title' => 'Style',
    '#type' => 'select',
    '#options' => $style_options,
    '#default_value' => isset($settings['exbd_icon_style']) ? $settings['exbd_icon_style'] : 'default',
  );
  // Icon color.
  $color_options = variable_get('express_block_designer_icon_color_options', array(
    'default' => 'Default',
    'blue' => 'Blue',
    'gray' => 'Gray',
    'gold' => 'Gold',
    'green' => 'Green',
    'orange' => 'Orange',
    'purple' => 'Purple',
    'red' => 'Red',
    'yellow' => 'Yellow',
  ), array());
  $form['icon']['exbd_icon_color'] = array(
    '#title' => 'Icon Color',
    '#description' => t('Choose the icon color'),
    '#type' => 'select',
    '#options' => $color_options,
    '#default_value' => isset($settings['exbd_icon_color']) ? $settings['exbd_icon_color'] : 'default',
  );
  // Icon size.
  $form['icon']['exbd_icon_size'] = array(
    '#title' => 'Icon Size',
    '#description' => t('Choose the icon size'),
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'increase' => 'increase',
    ),
    '#default_value' => isset($settings['exbd_icon_size']) ? $settings['exbd_icon_size'] : 'default',
  );
  // Hide icon color field if there are no options.
  if (empty($color_options)) {
    $form['icon']['exbd_icon_color']['#access'] = FALSE;
  }

  // Heading.
  $form['heading'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Heading',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $form['heading']['exbd_heading'] = array(
    '#title' => 'Heading',
    '#type' => 'select',
    '#options' => array(
      'h2' => 'H2',
      'h3' => 'H3',
      'h4' => 'H4',
      'h5' => 'H5',
      'h6' => 'H6',
      'strong' => 'Strong',
    ),
    '#default_value' => isset($settings['exbd_heading']) ? $settings['exbd_heading'] : 'h2',
    '#description' => 'This setting should be used to put your content in the proper hierarchy, not to change the font size of the title.',
  );
  // Heading alignment.
  $form['heading']['exbd_heading_align'] = array(
    '#title' => 'Heading Alignment',
    '#type' => 'select',
    '#options' => array(
      'left' => 'Left',
      'centered' => 'Centered',
    ),
    '#default_value' => isset($settings['exbd_heading_align']) ? $settings['exbd_heading_align'] : 'left',
  );
  // Style.
  $form['style'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Style',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $form['style']['exbd_style'] = array(
    '#title' => 'Style',
    '#type' => 'radios',
    '#options' => array(
      'none' => 'none',
      'light_gray' => 'Light Gray',
      'dark_gray' => 'Dark Gray',
      'tan' => 'Tan',
      'lightblue' => 'Light Blue',
      'outline' => 'Outline',
      'underline' => 'Underline',
    ),
    '#default_value' => isset($settings['exbd_style']) ? $settings['exbd_style'] : 'none',
  );
  // Typography.
  $form['typography'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Typography',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  // Font scale title.
  $form['typography']['exbd_font_scale_title'] = array(
    '#title' => 'Block Title Font Scale',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'increase' => 'Increase',
      'decrease' => 'Decrease',
    ),
    '#default_value' => isset($settings['exbd_font_scale_title']) ? $settings['exbd_font_scale_title'] : 'default',
  );
  // Font scale content.
  $form['typography']['exbd_font_scale_content'] = array(
    '#title' => 'Block Content Font Scale',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'increase' => 'Increase',
      'decrease' => 'Decrease',
    ),
    '#default_value' => isset($settings['exbd_font_scale_content']) ? $settings['exbd_font_scale_content'] : 'default',
  );
  // Menu block.
  $form['menu'] = array(
    '#type' => 'fieldset',
    '#title' => 'Block Menu',
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );
  $form['menu']['exbd_menu_style'] = array(
    '#title' => 'Menu Style',
    '#type' => 'select',
    '#options' => array(
      'default' => 'Default',
      'style_1' => 'Style 1',
      'style_2' => 'Style 2',
    ),
    '#default_value' => isset($settings['exbd_menu_style']) ? $settings['exbd_menu_style'] : 'default',
  );
  // Examples using #states
  $form['menu']['examples']['menu_style_default'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Default Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'default'),
      ),
    ),
  );
  $form['menu']['examples']['menu_style_1'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Style 1 Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'style_1'),
      ),
    ),
  );
  $form['menu']['examples']['menu_style_2'] = array(
    '#type' => 'item',
    '#markup' => 'Menu Style 2 Example',
    '#states' => array(
      'visible' => array(
        ':input[name="exbd_menu_style"]' => array('value' => 'style_2'),
      ),
    ),
  );
  // Save.
  $form['actions']['submit'] = array(
    '#type' => 'submit',
    '#value' => 'Save',
  );
  // Cancel.
  $form['actions']['cancel'] = array(
    '#type'   => 'submit',
    '#value'  => t('Cancel'),
    '#submit' => array('express_block_designer_themes_form_cancel'),
    '#limit_validation_errors' => array(),
  );
  // Only add delete if it exists already
  if ($saved) {
    $form['actions']['delete'] = array(
      '#type' => 'submit',
      '#submit' => array('express_block_designer_themes_delete'),
      '#value' => t('Delete'),
    );
  }
  return $form;
}

function express_block_designer_list() {
  drupal_set_title('Blocks with Block Designer Settings');
  $query = db_select('express_block_designer', 'ebd');
  $query->fields('ebd', array('id', 'module', 'block_delta', 'block_theme'));
  $query->orderBy('block_delta', 'ASC');
  $query->join("express_block_designer_themes", "ebdt", "ebd.block_theme = ebdt.id");
  $query->fields('ebdt', array('block_theme_name'));
  $results = $query->execute()->fetchAll();

  // Table headers.
  $header = array(
    'Block Delta',
    'Block Designer Theme',
    'Operations',
  );
  $data = array();
  $path = current_path();
  // Loop through returned Block Designer Themes.
  foreach ($results as $result) {
    // Prepare operations links.
    $links = array();
    // Edit link.

    $links[] = l('Edit', 'block/' . $result->module .'/' . $result->block_delta . '/design', array('query' => array('destination' => $path)));

    // Prepare row for table output.
    $data[] = array(
      $result->block_delta,
      $result->block_theme_name,
      join(' | ', $links),
    );
  }
  // Render list of Block Designer Themes as a table.
  $output['block_themes']['#markup'] = theme('table', array('header' => $header, 'rows' => $data ));

  return $output;
}

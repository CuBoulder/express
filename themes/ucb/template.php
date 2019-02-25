<?php

function ucb_theme(&$existing, $type, $theme, $path) {
  $registry = array();
  $template_dir = drupal_get_path('theme', 'ucb') . '/templates';
  $registry['page_title_image'] = array(
    'template' => 'page-title-image',
    'path' => $template_dir,
  );
  $registry['site_name'] = array(
    'template' => 'site-name',
    'path' => $template_dir,
  );
  $registry['ucb_main_menu_links'] = array(
    'render element' => 'element',
    'function' => 'theme_ucb_main_menu_links',
    'variables' => array(),
  );
  $registry['ucb_secondary_menu_links'] = array(
    'render element' => 'element',
    'function' => 'theme_ucb_secondary_menu_links',
    'variables' => array(),
  );
  $registry['ucb_footer_menu_links'] = array(
    'render element' => 'element',
    'function' => 'theme_ucb_footer_menu_links',
    'variables' => array(),
  );
  return $registry;
}

/**
 * Implements hook_css_alter().
 *
 * Remove jquery UI styles, alter stylesheet type for better printing.
 */
function ucb_css_alter(&$css) {
  // Remove jquery ui stylesheet.
  unset($css['misc/ui/jquery.ui.theme.css']);
  // Set all non-print css to screen so print css is cleaner
  foreach ($css as $key => $stylesheet) {
    if ($stylesheet['media'] == 'all') {
      //swap these lines for browser debugging
      $css[$key]['media'] = 'screen';
      //unset($css[$key]);
    } elseif ($stylesheet['media'] == 'print') {
      // uncomment line below for browser debugging
      //$css[$key]['media'] = 'screen';
    }
  }
}

/**
 * Implements theme_page_alter();
 * Force regions to render even if empty
 */
function ucb_page_alter(&$page) {
  // Remove the wrapper from the main content block.
  if (!empty($page['content']['system_main'])) {
    $page['content']['system_main']['#theme_wrappers'] = array_diff($page['content']['system_main']['#theme_wrappers'], array('block'));
  }
  // Force these regions to print
  $regions = array('branding', 'secondary_menu', 'menu', 'site_info');
  foreach ($regions as $region) {
    if ( !isset($page[$region]) || empty($page[$region])) {
      $page[$region] = array(
        '#region' => $region,
        '#weight' => '-10',
        '#theme_wrappers' => array('region'),
      );
    }
  }
  $is_responsive = theme_get_setting('alpha_responsive', variable_get('theme_default', ''));
  if (!$is_responsive && user_access('administer express settings')) {
    $link['href'] = 'admin/theme/config/' . variable_get('theme_default' , '');
    $link['html'] = TRUE;
    $link['fragment'] = 'edit-ucb-theme-settings';
    $link['query']['responsive'] = 1;
    $link['attributes'] = array(
      'target' => 'parent',
    );
    $link = l('<i class="fa fa-cog"></i> Make your site mobile friendly', $link['href'], $link);
    $page['page_top']['notice']['warning']['#markup'] = '<p>This site is not responsive.</p>';
    $page['page_top']['notice']['link']['#markup'] = $link;
    $page['page_top']['notice']['#prefix'] = '<div class="responsive-notice">';
    $page['page_top']['notice']['#suffix'] = '</div>';
  }
}

/**
 * Implements theme_preprocess_html.
 */
function ucb_preprocess_html(&$vars) {
  global $base_url;
  // Add web fonts from fonts.com
  $element = array(
    '#tag' => 'link', // The #tag is the html tag - <link />
    '#attributes' => array( // Set up an array of attributes inside the tag
      'href' => '//fast.fonts.net/cssapi/86696b99-fb1a-4964-9676-9233fb4fca8f.css',
      'rel' => 'stylesheet',
      'type' => 'text/css',
    ),
  );
  // Don't include web fonts if variable is false
  if (variable_get('use_fonts', TRUE)) {
    drupal_add_html_head($element, 'web_fonts');
  }
  // Turn off IE Compatibility Mode
  $element = array(
    '#tag' => 'meta',
    '#attributes' => array(
      'http-equiv' => 'X-UA-Compatible',
      'content' => 'IE=edge',
    ),
  );
  drupal_add_html_head($element, 'ie_compatibility_mode');
  // Add apple touch icons
  $touch_icons = array(
    '57',
    '72',
    '114',
    '144',
  );
  foreach ($touch_icons as $touch_icon) {
    $sizes = $touch_icon . 'x' . $touch_icon;
    $href = $base_url . '/' . drupal_get_path('theme', 'ucb') . '/apple-icon-' . $sizes . '.png';
    $element = array(
      '#tag' => 'link',
      '#attributes' => array(
        'rel' => 'apple-touch-icon',
        'sizes' => $sizes,
        'href' => $href,
      ),
    );
    drupal_add_html_head($element, 'apple_touch_icons_' . $sizes);
  }
  // Build title array
  // Add Campus name to title
  $slogan_title = variable_get('site_slogan_title', 'University of Colorado Boulder');
  $vars['head_title_array']['slogan'] = $slogan_title;
  if (isset($vars['head_title']) && !drupal_is_front_page()) {
    $vars['head_title'] .= ' | ' . $slogan_title;
  }
  // set classes for theme configs
  $headings = theme_get_setting('headings') ? theme_get_setting('headings') : 'headings-bold';
  $vars['classes_array'][]=$headings;
  $page_title_image_background = theme_get_setting('page_title_image_background') ? theme_get_setting('page_title_image_background') : 'page-title-image-background-white';
  $vars['classes_array'][]=$page_title_image_background;
  $icon_color = theme_get_setting('block_icons_color') ? theme_get_setting('block_icons_color') : 'block-icons-inherit';
  $vars['classes_array'][]=$icon_color;
  // Attributes for html element.
  $vars['html_attributes_array'] = array(
    'lang' => $vars['language']->language,
    'dir' => $vars['language']->dir,
  );
  $vars['html_attributes'] = drupal_attributes($vars['html_attributes_array']);
  // Add variables and paths needed for HTML5 and responsive support.
  $vars['base_path'] = base_path();
  $vars['path_to_ucb'] = drupal_get_path('theme', 'ucb');
  // Add responsive, max width classes
  if (theme_get_setting('alpha_responsive')) {
    $vars['classes_array'][] = 'layout-responsive';
    $vars['classes_array'][] = 'max-width-1200';
  } else {
    $vars['classes_array'][] = 'layout-fixed';
    $vars['classes_array'][] = 'max-width-960';
  }
  // Add primary sidebar class
  $vars['classes_array'][] = theme_get_setting('primary_sidebar') ? theme_get_setting('primary_sidebar') : 'primary-sidebar-second';
  // Add focus js
  drupal_add_js(drupal_get_path('theme','ucb') .'/js/track-focus.js', array('scope' => 'footer'));
  // Add svg to png logo fallback
  $logo = theme_get_setting('logo');
  drupal_add_js('jQuery(document).ready(function () { if (!Modernizr.svgasimg) {
  jQuery("img#logo").attr("src", "' . $logo . '");} });',
    array('type' => 'inline', 'scope' => 'footer', 'weight' => 5)
  );
  // Set skip to link
  $vars['skip_link_anchor'] = 'main';
  $vars['skip_link_text'] = t('Skip to Content');

  // Add site type class
  $vars['classes_array'][] = 'express-site-type-' . variable_get('express_site_type', 'default');
  $vars['classes_array'][] = 'brand-fonts';
}

/**
 * Implements theme_preprocess_page().
 */
function ucb_preprocess_page(&$vars) {
  global $base_url;
  // Set site slogan so it can't be overriden
  $slogan_display = variable_get('site_slogan_display', 'University of Colorado <strong>Boulder</strong>');
  $vars['site_slogan'] = $slogan_display;
  $vars['site_name'] = variable_get('site_name', '');
  // add print logo
  $vars['print_logo'] = '<img src="' . $base_url . '/' . drupal_get_path('theme','ucb') . '/images/print-logo.png" alt="University of Colorado Boulder" />';
  // hide title on homepage
  if($vars['is_front'] == TRUE) {
    $vars['title_hidden'] = TRUE;
  }
  // add home icon to footer menu if needed
  ucb_home_icon($vars, 'footer_menu');
  // add footer menu color config
  $vars['footer_menu_color'] = theme_get_setting('footer_menu_color') ? theme_get_setting('footer_menu_color') : 'footer-menu-gray';
  if ($node = menu_get_object()) {
    $status = ($node->status == 1) ? 'published' : 'unpublished';
    $vars['classes_array'][] = 'node-' . $status;
  }
  // content and sidebar grid classes
  $primary_sidebar = theme_get_setting('primary_sidebar');
  $main_content_classes = array();
  $sidebar_first_classes = array();
  $sidebar_second_classes = array();
  // Two Sidebars
  if (!empty($vars['page']['sidebar_first']) && !empty($vars['page']['sidebar_second'])) {
    // Main content 6 cols on desktop, 8 on tablet, 12 on mobile
    $main_content_classes[] = 'col-lg-6 col-md-6 col-sm-8 col-xs-12';
    // Main content pushed 3 on desktop, pushed 0 on mobile
    $main_content_classes[] = 'order-md-2 order-xs-1';
    // Sidebar first 3 cols on dekstop, 12 on mobile
    $sidebar_first_classes[] = 'col-lg-3 col-md-3 col-xs-12';
    // Sidebar first order 1
    $sidebar_first_classes[] = 'order-md-1';
    // Sidebar second 3 cols on dekstop, 12 on mobile
    $sidebar_second_classes[] = 'col-lg-3 col-md-3 col-xs-12';
    // Sidebar second order 3
    $sidebar_second_classes[] = 'order-md-3';
    // Add additional classes depending on primary sidebar
    if ($primary_sidebar == 'primary-sidebar-first') {
      // Push main content on tablet to make room for left sidebar
      $main_content_classes[] = 'order-sm-2';
      // Sidebar first 4 colums on tablet
      $sidebar_first_classes[] = 'col-sm-4';
      // Sidebar second 4 columns on tablet
      $sidebar_second_classes[] = 'col-sm-8 offset-sm-4';
      $sidebar_first_classes[] = 'order-xs-2';
      // Reset pull of right column for desktop
      $sidebar_second_classes[] = 'offset-md-0 offset-lg-0';
      $sidebar_second_classes[] = 'order-sm-3 order-xs-3';
    } else {
      // Set sidebars to 4 columns on tablet
      $sidebar_first_classes[] = 'col-sm-8';
      $sidebar_second_classes[] = 'col-sm-4';

      $main_content_classes[] = 'order-sm-1';
      $sidebar_first_classes[] = 'order-sm-3 order-xs-3';
      $sidebar_second_classes[] = 'order-sm-2 order-xs-2';

    }
  }
  // Only first/left sidebar
  elseif (!empty($vars['page']['sidebar_first']) && empty($vars['page']['sidebar_second'])) {
    // Main content 8 columns on desktop, tablet, 12 columns on mobile
    $main_content_classes[] = 'col-lg-8 col-md-8 col-sm-8 col-xs-12';
    // Push main content to make room for left sidebar
    $main_content_classes[] = 'order-sm-2 order-xs-1';
    // Set sidebar to 4 cols on desktop, tablet, 12 on mobile
    $sidebar_first_classes[] = 'col-lg-4 col-md-4 col-sm-4 col-xs-12';
    // Pull sidebar to left column on desktop and tablet
    $sidebar_first_classes[] = 'order-sm-1 order-xs-2';
  }
  // Only second/right sidebar
  elseif (empty($vars['page']['sidebar_first']) && !empty($vars['page']['sidebar_second'])) {
    // Main content 8 columns on desktop, tablet, 12 columns on mobile
    $main_content_classes[] = 'col-lg-8 col-md-8 col-sm-8 col-xs-12';
    $main_content_classes[] = 'order-sm-1 order-xs-1';
    // Set sidebar to 4 cols on desktop, tablet, 12 on mobile
    $sidebar_second_classes[] = 'col-lg-4 col-md-4 col-sm-4 col-xs-12';
    $sidebar_second_classes[] = 'order-sm-2 order-xs-2';
  }
  // No sidebars
  else {
    // Set main content to 12 columns on desktop, tablet, mobile
    $main_content_classes[] = 'col-lg-12 col-md-12 col-sm-12 col-xs-12';
  }
  $vars['main_content_classes'] = join(' ', $main_content_classes);
  $vars['sidebar_first_classes'] = join(' ', $sidebar_first_classes);
  $vars['sidebar_second_classes'] = join(' ', $sidebar_second_classes);
  // Page title image settings
  if (isset($vars['title_image'])) {
    $vars['classes_array'][] = 'has-page-title-image';
  }
  $page_title_image_width = theme_get_setting('page_title_image_width') ? theme_get_setting('page_title_image_width') : 'page-title-image-width-content';
  if ($page_title_image_width == 'page-title-image-width-content') {
    $vars['title_image_wrapper_class'] = 'element-max-width-padding';
    $vars['title_image_title_class'] = '';
    $vars['title_image_width'] = 'title-image-content-width';
  } else {
    $vars['title_image_wrapper_class'] = 'full-width';
    $vars['title_image_title_class'] = 'element-max-width-padding';
    $vars['title_image_width'] = 'title-image-full-width';
  }

  // Load search blocks.
  $block = block_load('cu_search', 'cu_search');
  $vars['search_desktop'] = _block_get_renderable_array(_block_render_blocks(array($block)));

  $block = block_load('cu_search', 'cu_search_mobile');
  $vars['search_mobile'] = _block_get_renderable_array(_block_render_blocks(array($block)));

  // Section classes
  $vars['section']['slider']['class'] = theme_get_setting('slider_class');
  $vars['section']['after-content2']['class'] = theme_get_setting('after_content2_class');
  $vars['section']['footer-section']['class'] = theme_get_setting('footer_section_class');
  $vars['section']['footer']['class'] = '';
  $vars['section']['site-info']['class'] = theme_get_setting('site_info_class');


  // Get region column settings
  if (theme_get_setting('after_content_columns')) {
    $after_content_columns = theme_get_setting('after_content_columns') ? theme_get_setting('after_content_columns') : 1;
    $after_content_columns = (isset($vars['page']['after_content']['#column_override']) && ($vars['page']['after_content']['#column_override'] != 'no-change')) ? $vars['page']['after_content']['#column_override'] : $after_content_columns;
  }
  if (theme_get_setting('lower_columns')) {
    $lower_columns = theme_get_setting('lower_columns') ? theme_get_setting('lower_columns') : 1;
    $lower_columns = (isset($vars['page']['lower']['#column_override']) && ($vars['page']['lower']['#column_override'] != 'no-change')) ? $vars['page']['lower']['#column_override'] : $lower_columns;
  }
  if (theme_get_setting('footer_columns')) {
    $footer_columns = theme_get_setting('footer_columns') ? theme_get_setting('footer_columns') : 1;
    $footer_columns = (isset($vars['page']['footer']['#column_override']) && ($vars['page']['footer']['#column_override'] != 'no-change')) ? $vars['page']['footer']['#column_override'] : $footer_columns;
  }
  // Add column classes to blocks in each of the regions
  $classes = ucb_size_column_classes();

  // After Content region
  $grid_classes = array();
  $grid_classes[] = $classes['xs'][$after_content_columns];
  $grid_classes[] = $classes['sm'][$after_content_columns];
  $grid_classes[] = $classes['md'][$after_content_columns];
  $grid_classes[] = $classes['lg'][$after_content_columns];
  $grid_classes = join(' ', $grid_classes);
  $children = element_children($vars['page']['after_content']);
  foreach ($children as $child) {
    $vars['page']['after_content'][$child]['#prefix'] = '<div class="block-column-wrapper ' . $grid_classes . '">';
    $vars['page']['after_content'][$child]['#suffix'] = '</div>';
  }

  // Lower region
  $grid_classes = array();
  $grid_classes[] = $classes['xs'][$lower_columns];
  $grid_classes[] = $classes['sm'][$lower_columns];
  $grid_classes[] = $classes['md'][$lower_columns];
  $grid_classes[] = $classes['lg'][$lower_columns];
  $grid_classes = join(' ', $grid_classes);
  $children = element_children($vars['page']['lower']);
  foreach ($children as $child) {
    $vars['page']['lower'][$child]['#prefix'] = '<div class="' . $grid_classes . '">';
    $vars['page']['lower'][$child]['#suffix'] = '</div>';
  }

  // Footer region
  $grid_classes = array();
  $grid_classes[] = $classes['xs'][$footer_columns];
  $grid_classes[] = $classes['sm'][$footer_columns];
  $grid_classes[] = $classes['md'][$footer_columns];
  $grid_classes[] = $classes['lg'][$footer_columns];
  $grid_classes = join(' ', $grid_classes);
  $children = element_children($vars['page']['footer']);
  foreach ($children as $child) {
    $vars['page']['footer'][$child]['#prefix'] = '<div class="' . $grid_classes . '">';
    $vars['page']['footer'][$child]['#suffix'] = '</div>';
  }


}

/**
 * Implements theme_preprocess_node().
 */
function ucb_preprocess_node(&$vars) {
  // Custom display templates will be called node--[type]--[viewmode].tpl.php
  $vars['theme_hook_suggestions'][] = 'node__' . $vars['type'] . '__' . $vars['view_mode'];

  // Making comments appear at the bottom of $content
  $vars['content']['comments']['#weight'] = 1000;

  // Don't print link variables
  unset($vars['content']['links']);

  // Add node title class to node titles
  $vars['title_attributes_array']['class'][] = 'node-title';
}

/**
 * Implements theme_preprocess_region().
 */
function ucb_preprocess_region(&$vars) {
  global $base_url;
  // add classes to regions and blocks for column configuration
  $columns = array(
    '1' => 'region-one-column',
    '2' => 'region-two-columns',
    '3' => 'region-three-columns',
    '4' => 'region-four-columns',
    '5' => 'region-five-columns',
    '6' => 'region-six-columns',
  );
  // Get column theme settings
  $after_content_columns = theme_get_setting('after_content_columns') ? theme_get_setting('after_content_columns') : '1';
  $lower_columns = theme_get_setting('lower_columns') ? theme_get_setting('lower_columns') : '1';
  $footer_columns = theme_get_setting('footer_columns') ? theme_get_setting('footer_columns') : '1';
  // Add variables to regions
  switch ($vars['region']) {
    case 'branding':
      $vars['logo'] = theme_get_setting('logo');
      $vars['svg_logo'] = $base_url . '/' . drupal_get_path('theme', 'ucb') . '/images/cu-logo.svg';
      $vars['front_page'] = url('<front>');
      if (variable_get('site_name_2', '')) {
        $vars['site_name'] = '<span class="site-name-two-lines">' . variable_get('site_name_1', NULL) . '<br />' . variable_get('site_name_2', NULL) . '</span>';
      } else {
        $vars['site_name'] = variable_get('site_name', NULL);
      }
      $slogan_display = variable_get('site_slogan_display', 'University of Colorado <strong>Boulder</strong>');
      $vars['site_slogan'] = $slogan_display;
      $vars['print_logo'] = '<img src="' . $base_url . '/' . drupal_get_path('theme','ucb') . '/images/print-logo.png" alt="University of Colorado Boulder" />';
      break;
    case 'secondary_menu':
      $vars['secondary_menu'] = menu_secondary_menu();
      $vars['secondary_menu_heading'] = theme_get_setting('secondary_menu_label') ? theme_get_setting('secondary_menu_label') : '';
      break;
    case 'menu':
      $vars['main_menu'] = menu_main_menu();
      ucb_home_icon($vars, 'main_menu');
      $vars['secondary_menu'] = menu_secondary_menu();
      if (theme_get_setting('use_action_menu')) {
        $color = theme_get_setting('action_menu_color') ? theme_get_setting('action_menu_color') : 'action-blue';
        $vars['classes_array'][] = $color;
      }
      break;
    case 'after_content':
      $vars['classes_array'][] = $columns[$after_content_columns];
      $vars['classes_array'][] = 'block-column-container';
      $vars['classes_array'][] = 'row';
      break;
    case 'lower':
      $vars['classes_array'][] = $columns[$lower_columns];
      $vars['classes_array'][] = 'block-column-container';
      $vars['classes_array'][] = 'row';
      break;
    case 'footer':
      $vars['classes_array'][] = $columns[$footer_columns];
      $vars['classes_array'][] = 'block-column-container';
      $vars['classes_array'][] = 'row';
      break;
    case 'site_info':
      $vars['base_url'] = $base_url;
      $vars['beboulder']['color'] = 'white';
      $vars['classes_array'][] = !empty($vars['content']) ? 'footer-2col' : 'footer-1col';
      break;
    case 'sidebar_first':
      //$vars['classes_array'][] = 'sidebar';
      //$vars['classes_array'][] = 'col-lg-4 col-md-4';
      break;
    case 'sidebar_second':
      //$vars['classes_array'][] = 'sidebar';
      //$vars['classes_array'][] = 'col-lg-4 col-md-4';
      break;
    case 'content':
      break;
  }
}


/**
 * Override or insert variables into the block templates.
 */
function ucb_process_block(&$vars) {
  // Drupal 7 should use a $title variable instead of $block->subject.
  $vars['title'] = isset($vars['block']->subject) ? $vars['block']->subject : '';
}

/**
 * Implements hook_preprocess_block).
 */
function ucb_preprocess_block(&$vars) {
  // Add class for block titles
  $vars['title_attributes_array']['class'][] = 'block-title';
  $vars['classes_array'][] = !empty($vars['block']->subject) ? 'has-block-title'
  : '';
  // If the block is a bean, add bundle as a class
  if ($vars['block']->module == 'bean') {
    // Get the bean elements.
    if (isset($vars['elements']['bean'])) {
      $beans = $vars['elements']['bean'];
      // There is only 1 bean per block.
      $children = element_children($beans);
      $bean = $beans[current(element_children($beans))];
      // Add bean type classes to the parent block.
      $vars['classes_array'][] = drupal_html_class('block-bean-type-' . $bean['#bundle']);
    }
  }
  if(isset($vars['elements']['content']) && isset($vars['elements']['content']['bean'])) {
    $bean = $vars['elements']['content']['bean'];
    $children = array_intersect_key($bean, array_flip(element_children($bean)));
    $the_bean = current($children);
    $bean_type = $the_bean['#bundle'];
    $vars['classes_array'][] = 'bean-type-' . $bean_type;
    $vars['classes_array'][] = drupal_html_class('block-bean-type-' . $bean_type);
  }

}

/**
 * Implements theme_menu_link().
 * adds icons, allows hiding of menu text for icon only navigation
 * This is for sidebar navigation
 */
function ucb_menu_link(array $vars) {
  $element = $vars['element'];
  if (isset($element['#localized_options']['icon']) && ($element['#localized_options']['icon'] != 'none') && strlen($element['#localized_options']['icon']) > 3 ) {
    $element['#localized_options']['html'] = TRUE;
    $hide = isset($element['#localized_options']['hide_text']) ? $element['#localized_options']['hide_text'] : 0;
    $hide_class = $hide ? 'hide-text' : '';
    $space = $hide ? '' : ' ';
    $element['#title'] = '<i class="fa fa-fw ' . $element['#localized_options']['icon'] . '"></i>' . $space . '<span class="menu-icon-text ' . $hide_class . '">' . $element['#title']  . '</span>';
    $element['#localized_options']['attributes']['class'][] = 'menu__link__icon';
  }
  $sub_menu = '';
  if ($element['#below']) {
    $sub_menu = drupal_render($element['#below']);
  }
  $element['#localized_options']['attributes']['class'][] = 'menu__link';
  $output = l($element['#title'], $element['#href'], $element['#localized_options']);
  return '<li' . drupal_attributes($element['#attributes']) . '>' . $output . $sub_menu . "</li>\n";
}
/**
 * Implements theme_links__system_main_menu().
 * Markup/Classes for main menu
 */
function theme_ucb_main_menu_links($vars) {
  $classes = join(' ',$vars['attributes']['class']);

  // Build menu heading.
  if ( !empty($vars['heading']) && !empty($vars['heading']['text']) && !empty($vars['heading']['level'])  && !empty($vars['heading']['class'])) {
    $nav_heading = '<' . $vars['heading']['level'] . ' class="' . join(' ', $vars['heading']['class']) . '">' . $vars['heading']['text'] . '</' . $vars['heading']['level'] . '>';
  }
  else {
    $nav_heading = '';
  }

  $html = $nav_heading . '  <ul class="' . $classes . '" id="' . $vars['attributes']['id'] . '">';

  // Add first and last classes to first and last list items
  reset($vars['links']);
  $first = key($vars['links']);
  end($vars['links']);
  $last = key($vars['links']);
  reset($vars['links']);

  $vars['links'][$first]['attributes']['class'][] = 'first';
  $vars['links'][$last]['attributes']['class'][] = 'last';
  foreach ($vars['links'] as $link) {
    // Reset for each link.
    $below = '';
    $mega_menu = NULL;
    // Check to see if a mega menu is added and enabled.
    if (!empty($link['mega_menu_enable']) && $link['mega_menu_enable'] && !empty($link['mega_menu_reference'])) {
      // Load mega menu entity.
      if ($mega_menu = entity_load('cu_mega_menu', array($link['mega_menu_reference']))) {
        //$mega_menu = current($mega_menu);
        $mm_config = entity_view('cu_mega_menu', $mega_menu);
        //$mm_config = current(current($mega_menu));
        $mm_config = array_intersect_key($mm_config, array_flip(element_children($mm_config)));
        // Add the href of the main link to the mega menu variables.
        $mm_config['href'] = $link['href'];
        $below = theme('cu_mega_menu', $mm_config);
        $link['attributes']['class'][] = 'mega-menu-link';
        $link['attributes']['role'] = 'button';
      }
    }
    $classes = '';
    if (!empty($link['attributes']['class'])) {
      $classes = join(' ', $link['attributes']['class']);
    }
    if (isset($link['icon']) && ($link['icon'] != 'none') && strlen($link['icon']) > 3) {
      $link['html'] = TRUE;
      $hide = isset($link['hide_text']) ? $link['hide_text'] : 0;
      $hide_class = $hide ? 'hide-text' : '';
      $space = $hide ? '' : ' ';
      $title = '<i class="fa fa-fw '. $link['icon'] . '"></i>' . $space . '<span class="' . $hide_class . '">' . $link['title'] . '</span>';
      $html .= '<li class="' . $classes .'">'.l($title, $link['href'], $link) . $below . '</li>';
    }
    else if (isset($link['title']) && isset($link['href'])) {
      $html .= '<li class="' . $classes .'">'.l($link['title'], $link['href'], $link) . $below . '</li>';
    }
  }
  $html .= "  </ul>";
  return $html;
}
/**
 * Implements theme_links__system_secondary_menu().
 * Markup/Classes for secondary menu
 */
function theme_ucb_secondary_menu_links($vars) {
  // Prepare label - set by more_menus.module
  $classes = join(' ',$vars['attributes']['class']);

  $label = variable_get('secondary_menu_label', NULL) ? '<h2 class="inline secondary-menu-label">' . variable_get('secondary_menu_label') . '</h2>': '<h2 class="element-invisible">Secondary Menu</h2>';

  $html = '  <ul class="' . $classes . '">';

  if (theme_get_setting('use_action_menu') && !isset($vars['mobile'])) {
    $html = '<h2 class="element-invisible">Secondary Menu</h2> <ul id="action-menu" class="' . $classes . '">';
  } else {
    $html = $label . '  <ul class="' . $classes . '">';
  }

  // Add first and last classes to first and last list items
  reset($vars['links']);
  $first = key($vars['links']);
  end($vars['links']);
  $last = key($vars['links']);
  reset($vars['links']);
  $vars['links'][$first]['attributes']['class'][] = 'first';
  $vars['links'][$last]['attributes']['class'][] = 'last';

  foreach ($vars['links'] as $link) {
    $classes = '';
    if (!empty($link['attributes']['class'])) {
      $classes = join(' ', $link['attributes']['class']);
    }
    if (isset($link['icon']) && ($link['icon'] != 'none') && strlen($link['icon']) > 3) {
      $link['html'] = TRUE;
      $hide = isset($link['hide_text']) ? $link['hide_text'] : 0;
      $hide_class = $hide ? 'hide-text' : '';
      $space = $hide ? '' : ' ';
      $title = '<i class="fa fa-fw '. $link['icon'] . '"></i>' . $space . '<span class="' . $hide_class . '">' . $link['title'] . '</span>';
      $html .= '<li class="' . $classes .'">'.l($title, $link['href'], $link).'</li>';
    }
    else if (isset($link['title']) && isset($link['href'])) {
      $html .= '<li class="' . $classes .'">'.l($link['title'], $link['href'], $link).'</li>';
    }
  }
  $html .= "  </ul>";
  return $html;
}
/**
 * Implements theme_links__footer_menu().
 * Markup/Classes for footer menu
 */
function theme_ucb_footer_menu_links($vars) {
  $classes = join(' ',$vars['attributes']['class']);

  // Build menu heading.
  if ( !empty($vars['heading']) && !empty($vars['heading']['text']) && !empty($vars['heading']['level'])  && !empty($vars['heading']['class'])) {
    $nav_heading = '<' . $vars['heading']['level'] . ' class="' . join(' ', $vars['heading']['class']) . '">' . $vars['heading']['text'] . '</' . $vars['heading']['level'] . '>';
  }
  else {
    $nav_heading = '';
  }

  $html = $nav_heading . ' <ul id="footer-menu-links" class="' . $classes . '">';

  // Add first and last classes to first and last list items
  reset($vars['links']);
  $first = key($vars['links']);
  end($vars['links']);
  $last = key($vars['links']);
  reset($vars['links']);

  $vars['links'][$first]['attributes']['class'][] = 'first';
  $vars['links'][$last]['attributes']['class'][] = 'last';
  foreach ($vars['links'] as $link) {
    $classes = '';
    if (!empty($link['attributes']['class'])) {
      $classes = join(' ', $link['attributes']['class']);
    }
    if (isset($link['icon']) && ($link['icon'] != 'none') && strlen($link['icon']) > 3) {
      $link['html'] = TRUE;
      $hide = isset($link['hide_text']) ? $link['hide_text'] : 0;
      $hide_class = $hide ? 'hide-text' : '';
      $space = $hide ? '' : ' ';
      $title = '<i class="fa fa-fw '. $link['icon'] . '"></i>' . $space . '<span class="' . $hide_class . '">' . $link['title'] . '</span>';
      $html .= '<li class="' . $classes .'">'.l($title, $link['href'], $link).'</li>';
    }
    else if (isset($link['title']) && isset($link['href'])) {
      $html .= '<li class="' . $classes .'">'.l($link['title'], $link['href'], $link).'</li>';
    }
  }
  $html .= "  </ul>";
  return $html;
}

/**
 * Overrides theme_menu_local_tasks().
 * Add classes to primary tab links
 */
function ucb_menu_local_tasks(&$vars) {
  $output = '';
  if (!empty($vars['primary'])) {
    foreach($vars['primary'] as $menu_item_key => $menu_attributes) {
      $vars['primary'][$menu_item_key]['#link']['localized_options']['attributes']['class'][] = strtolower(str_replace(' ','-', $menu_attributes['#link']['title']));
    }
    $vars['primary']['#prefix'] = '<h2 class="element-invisible">' . t('Primary tabs') . '</h2>';
    $vars['primary']['#prefix'] .= '<ul class="primary">';
    $vars['primary']['#suffix'] = '</ul>';
    $output .= drupal_render($vars['primary']);
  }
  return $output;
}

/**
 * Theme function to output tablinks for classic Quicktabs style tabs.
 */
function ucb_qt_quicktabs_tabset($vars) {
  $variables = array(
    'attributes' => array(
      'class' => 'clearfix quicktabs-tabs quicktabs-style-' . $vars['tabset']['#options']['style'],
    ),
    'items' => array(),
  );
  foreach (element_children($vars['tabset']['tablinks']) as $key) {
    $item = array();
    if (is_array($vars['tabset']['tablinks'][$key])) {
      $tab = $vars['tabset']['tablinks'][$key];
      if ($key == $vars['tabset']['#options']['active']) {
        $item['class'] = array('active');
      }
      $item['data'] = drupal_render($tab);
      $variables['items'][] = $item;
    }
  }
  return theme('item_list', $variables);
}

/**
 * Function to provide column classes.
 * Use this when amount of columns changes depending on display.
 * 4 columns on desktop collapses to 2 columns on tablet, 1 column on mobile.
 */
function ucb_size_column_classes() {
  $classes = array();
  $classes['xs'] = array(
    1 => 'col-xs-12',
    2 => 'col-xs-12',
    3 => 'col-xs-12',
    4 => 'col-xs-12',
    6 => 'col-xs-12'
  );
  $classes['sm'] = array(
    1 => 'col-sm-12',
    2 => 'col-sm-6',
    3 => 'col-sm-4',
    4 => 'col-sm-6',
    6 => 'col-sm-4'
  );
  $classes['md'] = array(
    1 => 'col-md-12',
    2 => 'col-md-6',
    3 => 'col-md-4',
    4 => 'col-md-3',
    6 => 'col-md-2'
  );
  $classes['lg'] = array(
    1 => 'col-lg-12',
    2 => 'col-lg-6',
    3 => 'col-lg-4',
    4 => 'col-lg-3',
    6 => 'col-lg-2'
  );
  return $classes;
}

/**
 * Function to add home icon to menu items set to <front>.
 */
function ucb_home_icon(&$vars, $menu) {
  if (isset($vars[$menu])) {
    foreach ($vars[$menu] as $key => $value) {
      if($vars[$menu][$key]['href'] == '<front>') {
        $vars[$menu][$key]['html'] = TRUE;
        $vars[$menu][$key]['title'] = '<i class="fa fa-home"></i><span class="element-invisible">Home</span>';
        $vars[$menu][$key]['attributes']['id'] = 'home-link';
        $vars[$menu][$key]['attributes']['class'][] = 'home-link';
      }
    }
  }
}

/**
 * Implements theme_image_style().
 */
function ucb_image_style(&$vars) {
  // Determine the dimensions of the styled image.
  $dimensions = array(
    'width' => $vars['width'],
    'height' => $vars['height'],
  );
  image_style_transform_dimensions($vars['style_name'], $dimensions);
  $vars['width'] = $dimensions['width'];
  $vars['height'] = $dimensions['height'];
  // Determine the url for the styled image.
  $vars['path'] = image_style_url($vars['style_name'], $vars['path']);
  $vars['attributes']['class'] = array('image-' . $vars['style_name']);
  return theme('image', $vars);
}

function ucb_affiliation($site_type = NULL, $value = NULL) {
  $affiliations = array(
    'sport_club' => array(
      'label' => 'A CU Boulder Sport Club',
      'url' => 'https://www.colorado.edu/recreation'
    ),
    'student_group' => array(
      'label' => 'A CU Boulder Student Group',
      'url' => 'https://www.colorado.edu/involvement/'
    ),
  );
  if ($site_type && !empty($affiliations[$site_type])) {
    if ($value == 'label') {
      return $affiliations[$site_type]['label'];
    }
    elseif ($value == 'link') {
      return $affiliations[$site_type]['label'];
    }
    else {
      return $affiliations[$site_type];
    }
  }
  return FALSE;
}

/**
 * Implements theme_breadcrumb().
 */
function ucb_breadcrumb($vars = NULL) {
  $breadcrumb = !empty($vars['breadcrumb']) ? $vars['breadcrumb'] : drupal_get_breadcrumb();
  $theme = variable_get('theme_default','');
  if (!empty($breadcrumb) && theme_get_setting('use_breadcrumbs', $theme)) {
    if (count($breadcrumb) < 2) {
      return '';
    }

    // Replace the Home breadcrumb with a Home icon
    //$breadcrumb[0] = str_replace('Home','<i class="fa fa-home"></i> <span class="home-breadcrumb element-invisible">Home</span>',$breadcrumb[0]);
    // Get current page title and add to breadcrumb array
    $breadcrumb[] = '<span class="current-breadcrumb">' . drupal_get_title() . '</span>';
    // Provide a navigational heading to give context for breadcrumb links to
    // screen-reader users. Make the heading invisible with .element-invisible.
    $output = '<h2 class="element-invisible">' . t('Breadcrumb') . '</h2>';
    $output .= '<div class="breadcrumb">' . implode(' <i class="fa fa-angle-right"></i> ', $breadcrumb) . '</div>';
    return $output;
  }
}

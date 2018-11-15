<?php
  $custom_logo = array();
  // Load logo files
  if (variable_get('custom_white_logo', NULL) && variable_get('custom_black_logo', NULL)) {
    $custom_logo = array(
      'white' => file_load(variable_get('custom_white_logo')),
      'black' => file_load(variable_get('custom_black_logo')),
    );
    // Create img markup
    $custom_logo['white']->markup = '<img class="custom-logo custom-logo-white" src="' . file_create_url($custom_logo['white']->uri) . '" alt="' . check_plain($site_name) . ' logo" />';
    $custom_logo['black']->markup = '<img class="custom-logo custom-logo-black" src="' . file_create_url($custom_logo['black']->uri) . '" alt="' . check_plain($site_name) . ' logo" />';
  }
?>
<?php if (!empty($custom_logo)):?>
  <<?php print $site_name_tag; ?> class="site-name">
    <a href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>" class="custom-logo-black" rel="home"><span><?php print $custom_logo['black']->markup; ?></span></a>
    <a href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>" class="custom-logo-white" rel="home"><span><?php print $custom_logo['white']->markup; ?></span></a>
  </<?php print $site_name_tag; ?>>
<?php else: ?>

  <?php if ($site_name): ?>
    <<?php print $site_name_tag; ?> class="site-name">
      <a href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>" class="header__site-link" rel="home"><span><?php print $site_name; ?></span></a>
    </<?php print $site_name_tag; ?>>
  <?php endif; ?>
<?php endif; ?>
<?php
  $site_type = variable_get('express_site_type', NULL);

  $affilation_enable = variable_get('cu_affilation_enable', FALSE);
  $affilation = variable_get('cu_site_affiliation_options', NULL);
  $affiliation_title = NULL;
  $affilation_url = NULL;
  if ($site_type) {
    $affilation = cu_core_site_affiliation_options($site_type);
    $affiliation_title = $affilation['label'];
    $affiliation_url = $affilation['url'];
  }
  elseif ($affilation == 'custom') {
    $affiliation_title = variable_get('express_site_affiliation_title', NULL);
    $affiliation_url = variable_get('express_site_affiliation_url', NULL);
  }
  elseif (!empty($affilation)) {
    $affilation = cu_core_site_affiliation_options($affilation);
    $affiliation_title = $affilation['label'];
    $affiliation_url = $affilation['url'];
  }

  //$affiliation = variable_get('cu_site_affiliation', ucb_affiliation($site_type, 'label'));
  //$affiliation_link = variable_get('cu_site_affiliation_link', ucb_affiliation($site_type, 'link'));
?>

<?php if ($affilation_enable && $affiliation): ?>

  <div class="affiliation">
    <?php
      if ($affiliation_title && !$affiliation_url) {
        print $affiliation_title;
      }
      elseif ($affiliation_title && $affiliation_url) {
        print l($affiliation_title, $affiliation_url, array('html' => TRUE));
      }
    ?>
  </div>
<?php endif; ?>

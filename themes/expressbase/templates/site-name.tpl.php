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
    <?php
      $affiliation = variable_get('express_site_affiliation', NULL);
      $cu_affiliation = variable_get('cu_site_affiliation_options', NULL);
    ?>

    <?php if ($affiliation || $cu_affiliation): ?>

      <div class="affiliation">
        <?php
          if (!empty($affiliation) && $cu_affiliation == 'custom') {
            if (!empty($affiliation['url'])) {
              print l($affiliation['title'], $affiliation['url'], array('html' => TRUE));
            }
            else {
              print $affiliation['title'];
            }
          }
          elseif ($cu_affiliation != 'custom') {
            $affiliation = cu_core_site_affiliation_options($cu_affiliation);
            print l($affiliation['label'], $affiliation['url'], array('html' => TRUE));
          }
        ?>
      </div>
    <?php endif; ?>
  <?php endif; ?>
<?php endif; ?>

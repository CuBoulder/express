<div class="express-bundle express-card col-lg-3 col-md-4 col-sm-6 col-xs-12 <?php print join(' ', $bundle_classes); ?>">

  <div class="content">
    <h2><?php print $name; ?></h2>
    <div class="express-bundle-description">
      <?php print $description; ?>
    </div>
    <div class="express-bundle-actions">
      <?php
        $links = array();
        if (isset($enable_url)) {
          $links[] =  l(t($enable_text), $enable_url, array('attributes' => array('class' => array('express-bundle-enable-link btn btn-primary')), 'html' => TRUE));
        }
        if (isset($demo_url)) {
          $links[] = l(t('More Information'), $demo_url, array('attributes' => array('class' => array('express-bundle-demo-link btn btn-default'), 'target' => '_blank'), 'html' => TRUE));
        }
        print join(' ', $links);
      ?>
    </div>
  </div>
</div>

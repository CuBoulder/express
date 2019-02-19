<?php if ($secondary_menu): ?>
  <nav class="header__secondary-menu" id="secondary-menu" role="navigation">
    <?php print theme('ucb_secondary_menu_links', array(
      'links' => $secondary_menu,
      'attributes' => array(
        'class' => array('links', 'inline', 'clearfix'),
        'id' => 'secondary-menu',
      ),
      'heading' => array(
        'text' => $secondary_menu_heading,
        'level' => 'h2',
        'class' => array('element-invisible'),
      ),
    )); ?>
  </nav>
<?php endif; ?>

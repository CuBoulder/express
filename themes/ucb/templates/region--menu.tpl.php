<?php if ($main_menu): ?>
  <nav role="navigation" tabindex="-1" class="<?php print $classes; ?>">

    <div>
      <?php
      // This code snippet is hard to modify. We recommend turning off the
      // "Main menu" on your sub-theme's settings form, deleting this PHP
      // code block, and, instead, using the "Menu block" module.
      // @see https://drupal.org/project/menu_block
      print theme('ucb_main_menu_links', array(
        'links' => $main_menu,
        'attributes' => array(
          'class' => array('links', 'inline', 'clearfix'),
          'id' => 'main-menu',
        ),
        'heading' => array(
          'text' => t('Main menu'),
          'level' => 'h2',
          'class' => array('element-invisible'),
        ),
      )); ?>
    </div>

    <?php if (theme_get_setting('use_action_menu') && !empty($secondary_menu)): ?>
      <div class="action-menu-wrapper">
        <?php print theme('ucb_secondary_menu_links', array(
              'links' => $secondary_menu,
              'attributes' => array(
                'class' => array('links', 'inline', 'clearfix', 'action-menu'),
              ),
            )); ?>
      </div>
    <?php endif; ?>

  </nav>
<?php endif; ?>

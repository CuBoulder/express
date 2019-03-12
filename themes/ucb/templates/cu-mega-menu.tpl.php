<?php
  $count = !empty($variables['field_mega_menu_links']) ? count($variables['field_mega_menu_links']['#items']) : 0;
  $columns = ($count < 3) ? 'col-lg-4 col-md-4 col-sm-6 col-xs-12' : 'col-lg-3 col-md-3 col-sm-6 col-xs-12';
?>

<div class="mega-menu-wrapper background-white padding shadow-medium">
  <div class="mega-menu-inner">
    <h2 class="h5"><?php print l(render($variables['field_mega_menu_label']), $variables['href']); ?></h2>
    <div class="row">

      <?php if (!empty($variables['field_mega_menu_text_above'])): ?>
        <div class="<?php print $columns; ?> content margin-bottom mega-menu-text-above text-minify">
          <?php print render($variables['field_mega_menu_text_above']); ?>
        </div>
      <?php endif; ?>
      <?php if (!empty($variables['field_mega_menu_links'])): ?>
        <?php foreach ($variables['field_mega_menu_links']['#items'] as $key => $list): ?>
          <div class="<?php print $columns; ?> margin-bottom">
            <?php print render($variables['field_mega_menu_links'][$key]); ?>
          </div>
      <?php endforeach; ?>
    <?php endif; ?>
    </div>
    <?php if (!empty($variables['field_mega_menu_text_below'])): ?>
      <div class="content border-top padding-top mega-menu-text-below text-minify">
        <?php print render($variables['field_mega_menu_text_below']); ?>
      </div>
    <?php endif; ?>
  </div>
</div>

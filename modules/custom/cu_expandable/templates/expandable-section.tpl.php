<?php
  $label = trim(render($variables['expandable']['label']));
?>

<div id="<?php print cu_expandable_system_label($label); ?>" class="js-tabcontent">
  <?php print render($variables['expandable']['text']); ?>
  <?php
    $block = cu_expandable_bean_render($variables['expandable']['block']['#items'][0]['target_id']);
    print render($block);
  ?>
</div>

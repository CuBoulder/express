<?php //dpm($variables['layout_edit']);
  if ($variables['layout_edit']['field']['field_name'] == 'field_header') {
    $region = 'header';
  }
  elseif ($variables['layout_edit']['field']['field_name'] == 'field_footer') {
    $region = 'footer';
  }
  else {
    $region = $variables['layout_edit']['field']['settings']['field'];
  }
?>

<div class="layout-area dragster-region dragster-region-<?php print $region; ?>" data-drag-block-region="<?php print $region; ?>">
  <h3 class="express-layout-edit-region-label"><?php print $variables['layout_edit']['field']['settings']['label']; ?></h3>
  <?php
    if (!empty($variables['layout_edit']['blocks'])) {
      foreach ($variables['layout_edit']['blocks'][LANGUAGE_NONE] as $block) {
        $bid = $block['target_id'];
        $block_vars = express_layout_drag_bean_information($bid);
        $type = current($block_vars)->type;
        current($block_vars)->type_label = express_layout_drag_get_bean_type_name($type);
        print theme('express_layout_editor_block', array('layout_edit' => $block_vars, 'bid' => $bid));
      }
    }
  ?>

</div>

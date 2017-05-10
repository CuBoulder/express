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
  $current = current_path();
  $add_new = url('block/add', array('query' => array('destination' => $current)));



?>

<div class="layout-editor-region-wrapper">
  <div class="express-layout-edit-region-label-wrapper">
    <h3 class="express-layout-edit-region-label"><?php print $variables['layout_edit']['field']['settings']['label']; ?></h3>
    <a href="#layout-editor-block-filter-field-<?php print $region; ?>"  class="express-layout-edit-add-block-link"><i class="fa fa-plus"></i> Add Existing Block</a>
  </div>
  <div class="express-layout-edit-add">
    <input class="form-text layout-edit-block-search" name="layout-editor-block-filter-field" type="text" id="layout-editor-block-filter-field-<?php print $region; ?>" placeholder="Search by block label or title" size="40"/>
  </div>
  <div class="layout-area dragster-region dragster-region-<?php print $region; ?>" data-drag-block-region="<?php print $region; ?>">
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
</div>

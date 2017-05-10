<?php
  //dpm($variables);
  $bid = $variables['bid'];
  $title = $variables['layout_edit'][$bid]->title;
  $label = $variables['layout_edit'][$bid]->label;
  $combined = array($label, $title);
?>

<div class="dragster-block" data-drag-block-id="<?php print $bid ; ?>" id="dragster-block-<?php print $bid; ?>" data-block-title="<?php print $title; ?>" data-block-label="<?php print $label; ?>" data-block-combined="<?php print join(' | ', $combined); ?>">
  <?php

    $label = array();
    $label[] = $variables['layout_edit'][$bid]->label;
    if ($variables['layout_edit'][$bid]->label != '') {
      $label[] = $variables['layout_edit'][$bid]->type_label;
    }
    $edit = url('block/' . $variables['layout_edit'][$bid]->delta . '/edit', array('query' => array('destination' => current_path())));

  ?>
  <strong><?php print join(' &bull; ', $label); ?></strong>
  <span class="operations">
    <a href="<?php print $edit; ?>" class="operation-edit"><i class="fa fa-pencil"></i><span class="element-invisible">edit</span></a> <a href="#" class="operation-remove"><i class="fa fa-times"></i><span class="element-invisible">remove</span></a>
  </span>
</div>

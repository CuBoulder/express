<?php
  $layout_config = array();
  if (isset($variables['layout_edit']['node']->type)) {
      $layout_config = variable_get('express_layout_settings_' . $variables['layout_edit']['node']->type, array());
      $variables['layout_config'] = $layout_config;
  }

  function express_layout_drag_get_field($field, $variables) {
    $fields = $variables['layout_edit']['fields'];
    $region_vars = array();
    $region_vars['field'] = array('field_name' =>$field, 'settings' => $fields[$field]);
    $region_vars['blocks'] = $variables['layout_edit']['layout']->{$field};
    if ($variables['layout_config'][$field]) {
      print theme('express_layout_editor_region', array('layout_edit' => $region_vars));
    }
  }
?>

<div class="express-layout-editor express-layout-editor-vertical">
  <div class="layout-changed-warning"></div>
  <div class="row clearfix vertical-block-tray">
    <a href="#" class="block-tray-toggle"><i class="fa fa-compress"></i> <span class="element-invisible">Toggle Block Tray Visibility</span></a>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 block-tray-minimal">
      <h2>Blocks</h2>

    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 block-tray-inner">
      <div class="row clearfix">
        <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
          <h2>Blocks</h2>
        </div>
        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">

          <button class="btn btn-success express-layout-editor-save">Save Layout</button> <button class="btn btn-default express-layout-editor-cancel">Cancel</button>
        </div>
      </div>
      <P>
        Drag blocks from below to the region you want it to appear in.
      </P>
      <P>
        <a href="<?php print $variables['layout_edit']['add_block_link']; ?>" class="btn btn-primary"><i class="fa fa-plus-square"></i> Add Block</a>
      </P>

      <div class="row clearfix">



        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
          <div class="layout-editor-block-filter">
            <h3 class="element-invisible">Block Search</h3>
            <label class="express-layout-edit-region-label" for="layout-editor-block-filter-field">
              Search Blocks by title or label:
            </label>
            <input class="form-text" name="layout-editor-block-filter-field" type="text" id="layout-editor-block-filter-field" placeholder="Search" size="40"/>
            <button id="layout-editor-filter-reset">Reset</button>
          </div>
        </div>
      </div>


      <div class="dragster-region dragster-region--drag-only block-tray" data-drag-block-region="block-tray">

        <?php
        $beans = express_layout_drag_latest_blocks();
        print '<div class="layout-editor-block-category layout-edit-block-recent"><h3 class="express-layout-edit-region-label">New/Recently Updated</h3><div class="block-category">';
        foreach ($beans as $bean) {
          $block_vars = express_layout_drag_bean_information($bean->bid);
          $type = current($block_vars)->type;
          current($block_vars)->type_label = express_layout_drag_get_bean_type_name($type);
          print theme('express_layout_editor_block', array('layout_edit' => $block_vars, 'bid' => $bean->bid));
        }
        print '</div></div>';
        ?>

        <?php
          foreach ($variables['layout_edit']['beans'] as $label => $beans) {
            usort($beans, 'sort_blocks_alpha');
            print '<div class="layout-editor-block-category"><h3 class="express-layout-edit-region-label">' . $label . '</h3><div class="block-category">';
            foreach ($beans as $bean) {
              $block_vars = express_layout_drag_bean_information($bean->bid);
              $type = current($block_vars)->type;
              current($block_vars)->type_label = express_layout_drag_get_bean_type_name($type);
              print theme('express_layout_editor_block', array('layout_edit' => $block_vars, 'bid' => $bean->bid));
            }
            print '</div></div>';
          }
        ?>
      </div>
    </div>
  </div>

  <div class="layout-region-map row clearfix">
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      <?php express_layout_drag_get_field('field_intro', $variables); ?>
    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      <?php express_layout_drag_get_field('field_slider', $variables); ?>
    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      <div class="row clearfix">
        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
          <?php express_layout_drag_get_field('field_sidebar_first', $variables); ?>
        </div>
        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
          <?php express_layout_drag_get_field('field_header', $variables); ?>

          <div class="row clearfix">
            <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
              <?php express_layout_drag_get_field('field_inner_content_left', $variables); ?>
            </div>
            <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 col-lg-offset-2 col-md-offset-2 col-sm-offset-2">
              <?php express_layout_drag_get_field('field_inner_content_right', $variables); ?>
            </div>
          </div>

          <div class="layout-region-disabled">
            <p class="express-layout-edit-region-label">
              Main Content
            </p>
          </div>

          <?php express_layout_drag_get_field('field_content_bottom', $variables); ?>

          <?php express_layout_drag_get_field('field_footer', $variables); ?>
        </div>
        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
          <?php express_layout_drag_get_field('field_sidebar_second', $variables); ?>
        </div>
      </div>

    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      <?php express_layout_drag_get_field('field_wide_2', $variables); ?>
    </div>
  </div>

  <?php print render($variables['layout_edit']['form']); ?>


</div>

<div class="express-layout-editor">
  <div class="row layout-edit-operations clearfix">
    <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12">
      <a href="<?php print $variables['layout_edit']['add_block_link']; ?>" class="btn btn-primary"><i class="fa fa-plus-square"></i> Add Block</a>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">

      <?php print render($variables['layout_edit']['form']); ?>

    </div>
  </div>

  <div class="row">
    <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12">
      <h2>Blocks</h2>
      <P>
        Drag blocks from below to the region you want it to appear in.
      </P>
      <div class="layout-editor-block-filter">
        <label for="layout-editor-block-filter-field">
          Search Blocks by title or label:
        </label>
        <input class="form-text" name="layout-editor-block-filter-field" type="text" id="layout-editor-block-filter-field" placeholder="Search" />
        <button id="layout-editor-filter-reset">Reset</button>
      </div>
      <div class="dragster-region dragster-region--drag-only block-tray" data-drag-block-region="block-tray">
        <?php
          foreach ($variables['layout_edit']['beans'] as $label => $beans) {
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
    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">

      <div class="layout-editor-regions-wrapper">

      <div class="layout-editor-regions">
        <h2>Regions
          <?php
            $theme = variable_get('theme_default', NULL);
            if ($theme) {
              print l('Preview Regions', 'express-layout-region-demo', array(
                'query' => array('destination' => current_path()),
                'attributes' => array('class' => array('preview-regions-link'))
              ));
            }
          ?>
        </h2>
        <?php
          $layout_config = array();
          if (isset($variables['layout_edit']['node']->type)) {
              $layout_config = variable_get('express_layout_settings_' . $variables['layout_edit']['node']->type, array());
          }
          foreach ($variables['layout_edit']['fields'] as $key => $field) {
            $region_vars = array();
            $region_vars['field'] = array('field_name' =>$key, 'settings' => $field);
            $region_vars['blocks'] = $variables['layout_edit']['layout']->{$key};
            if ($layout_config[$key]) {
              print theme('express_layout_editor_region', array('layout_edit' => $region_vars));
            }
          }
        ?>
      </div>
      </div>
    </div>
  </div>
</div>

<div class="express-admin-page row">
  <?php
  // Put blocks in their places.
    $block_container = array('left' => array(), 'right' => array());
    foreach ($blocks as $key => $block) {
      if ($block_output = theme('admin_block', array('block' => $block))) {
        $position = $block['position'];
        $block_container[$position][$key]['#markup'] = $block_output;
        if ($position == 'right') {
          $block_container[$position][$key]['#prefix'] = '<div class="col-lg-6 col-md-12 col-sm-12 col-xs-12">';
          $block_container[$position][$key]['#suffix'] = '</div>';
        }
      }
    }
    // Add some wrapping elements
    $block_container['left']['#prefix'] = '<div class="col-lg-5 col-md-6 col-sm-6 col-xs-12 express-admin-page-column">';
    $block_container['left']['#suffix'] = '</div>';
    $block_container['right']['#prefix'] = '<div class="col-lg-7 col-md-6 col-sm-6 col-xs-12"><div class="row express-admin-page-column-right">';
    $block_container['right']['#suffix'] = '</div></div>';

    print render($block_container);
  ?>
</div>

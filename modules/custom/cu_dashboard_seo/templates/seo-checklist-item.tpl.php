<?php
  if ($indicator) {
    $icon = '<i class="fa fa-check"></i>';
  }
  else {
    $icon = '<i class="fa fa-times"></i>';
  }
?>
<div class="seo-checklist-item">
  <h3><?php print $icon; ?> <?php print $title; ?></h3>
  <div class="seo-checklist-description">
    <p>


    <?php
      if ($indicator) {
        print $description[1];
      }
      else {
        print $description[0];
      }
    ?>
    </p>
      <?php
        if ($edit) {
          print l($edit, $path, array('attributes' => array(
            'class' => array(
              'btn',
              'btn-xs',
              'btn-default'
            )
          )));
        }
        ?>
  </div>
</div>

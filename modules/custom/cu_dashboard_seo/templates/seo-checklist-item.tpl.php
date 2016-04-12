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
    <?php print $description; ?>
  </div>
</div>

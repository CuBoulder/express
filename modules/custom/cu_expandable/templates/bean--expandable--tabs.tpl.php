<div class="expandable expandable-tabs skltbs">
  <ul class="expandable-tablist skltbs-tab-group" role="tablist">
    <?php foreach ($content['labels'] as $label):?>
      <?php
        $label = trim(render($label));
      ?>
      <li class="expandable-tablist-item skltbs-tab-item" role="presentation">
        <a href="#<?php print cu_expandable_system_label($label); ?>" id="label_<?php print cu_expandable_system_label($label); ?>" class="expandable-tablist-link skltbs-tab" role="tab"><?php print render($label); ?></a>
      </li>
    <?php endforeach; ?>

  </ul>
  <div class="skltbs-panel-group">

  <?php foreach ($content['sections'] as $section):?>
    <?php print theme('expandable_section_tabs', array('expandable' => $section)); ?>
  <?php endforeach; ?>
  </div>
</div>

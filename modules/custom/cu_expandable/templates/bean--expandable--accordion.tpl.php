<div class="js-tabs">
  <ul class="js-tablist">
    <?php foreach ($content['labels'] as $label):?>
      <?php
        $label = trim(render($label));
      ?>
      <li class="js-tablist__item">
        <a href="#<?php print cu_expandable_system_label($label); ?>" id="label_<?php print cu_expandable_system_label($label); ?>" class="js-tablist__link"><?php print render($label); ?></a>
      </li>
    <?php endforeach; ?>

  </ul>
  <?php foreach ($content['sections'] as $section):?>
    <?php print theme('expandable_section_accordion', array('expandable' => $section)); ?>
  <?php endforeach; ?>
</div>

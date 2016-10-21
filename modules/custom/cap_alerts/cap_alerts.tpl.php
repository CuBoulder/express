<?php

/**
 * @file
 * RAVE Alerts block template.
 */
?>
<div id="cu-alerts" data-remote-url="<?php print $remote_url ?>">
  <?php if (variable_get('rave_alerts_enable', 1) && variable_get('rave_alerts_display', 1)): ?>
    <div class="alert">
      <?php print $data['info']['description']; ?>
      <?php if (!empty($data['info']['instruction'])) : ?>
        <?php print l('Read More &raquo;', $data['info']['instruction'], array('html' => TRUE)); ?>
      <?php elseif ($rave_alerts_site = variable_get('rave_alerts_enable', NULL)): ?>
        <?php print l('Read More &raquo;', $rave_alerts_site, array('html' => TRUE)); ?>
      <?php endif; ?>
    </div>
  <?php endif; ?>
</div>

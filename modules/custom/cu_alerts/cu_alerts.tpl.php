<?php

/**
 * @file
 * CU Alerts template.
 */

 $message_off = variable_get('rave_alerts_message_off', '');
 $show_alerts = FALSE;
?>
<div id="cu-alerts" data-remote-url="<?php print $remote_url ?>">
<?php if (!empty($data['channel']['item'])) : ?>
  <?php if ($data['channel']['item']['title'] != $message_off): ?>
    <?php $show_alerts = TRUE; ?>
    <div class="alert">
      <?php print $data['channel']['item']['title']; ?>
      <?php if (!empty($data['channel']['item']['link'])) : ?>
        <?php print l('Read More &raquo;', $data['channel']['item']['link'], array('html' => TRUE)); ?>
      <?php elseif ($rave_alerts_site = variable_get('rave_alerts_site', NULL)): ?>
        <?php print l('Read More &raquo;', $rave_alerts_site, array('html' => TRUE)); ?>
      <?php endif; ?>
    </div>
  <?php endif; ?>
<?php endif; ?>
</div>

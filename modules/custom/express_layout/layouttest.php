<?php

$start = microtime(TRUE);

for ($i = 1; $i <= 70; $i++) {
  if (entity_load_single('bean', $i)) {
    $loaded++;
  }
}

$duration = microtime(TRUE) - $start;
// If it's less than 1 second, display in milliseconds.
if ($duration < 1) {
  $time        = ceil($duration * 1000);
  $granularity = 'milliseconds';
}
// Otherwise, use seconds.
else {
  $time        = ceil($duration);
  $granularity = 'seconds';
}

$dt_args = array(
  '!count'       => $loaded,
  '!time'        => $time,
  '@granularity' => $granularity,
);
drush_log(dt('!count beans were loaded in !time @granularity.', $dt_args), 'ok');

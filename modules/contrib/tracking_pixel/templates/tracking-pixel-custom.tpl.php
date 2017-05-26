<?php
// Since this role is only given to trusted users, we aren't sanitizing input.
if (isset($variables['code'])) {
  print $variables['code'];
}
?>

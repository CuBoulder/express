<?php

if (isset($_SERVER['TRAVIS'])) {
  print 'on Travis.';
} else {
  print 'not on Travis.';
}

if (isset($_SERVER['LANDO'])) {
  print 'on Lando.';
} else {
  print 'not on Lando.';
}

if (defined('PANTHEON_ENVIRONMENT')) {
  print 'on Pantheon.';
} else {
  print 'not on Pantheon.';
}

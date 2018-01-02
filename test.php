<?php

if (isset($_SERVER['TRAVIS'])) {
  print 'on Travis.';
} else {
  print 'did not work.';
}

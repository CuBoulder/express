<?php

/**
 * @file
 * Constant definitions for AutoSlave
 */

if (defined('AUTOSLAVE_VERSION')) {
  return;
}

/**
 * Current AutoSlave version (use for session bc).
 */
define('AUTOSLAVE_VERSION', '1.4');

/**
 * Default setting for global replication lag.
 */
define('AUTOSLAVE_GLOBAL_REPLICATION_LAG', TRUE);

/**
 * Default replication lag assumed (2 seconds).
 */
define('AUTOSLAVE_WATCHDOG_ON_SHUTDOWN', FALSE);

/**
 * Default replication lag assumed (2 seconds).
 */
define('AUTOSLAVE_ASSUMED_REPLICATION_LAG', 2);


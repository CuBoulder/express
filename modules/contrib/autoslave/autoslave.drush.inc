<?php

/**
 * @file Drush sql commands
 */

/**
 * Implementation of hook_drush_help().
 */
function autoslave_drush_help($section) {
  switch ($section) {
    case 'meta:autoslave:title':
      return dt('AutoSlave commands');
    case 'meta:autoslave:summary':
      return dt('Examine and modify your Drupal database via AutoSlave.');
  }
}

/**
 * Implementation of hook_drush_command().
 */
function autoslave_drush_command() {
  $items['autoslave-affected-tables'] = array(
    'description' => "Show current status of affected tables.",
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('afta'),
    'examples' => array(
      'drush autoslave-affected-tables' => "Show current status of affected tables.",
    ),
  );
  $items['autoslave-sql-cli'] = array(
    'description' => "Open a SQL command-line interface to the master database.",
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'options' => array(
      'A' => 'Skip reading table information. This gives a quicker start of mysql.',
    ),
    'aliases' => array('asqlc'),
    'examples' => array(
      'drush autoslave-sql-cli' => "Open a SQL command-line interface to the master database.",
    ),
  );
  return $items;
}

function drush_autoslave_affected_tables() {
  $active = array();
  $inactive = array();
  global $databases;
  foreach ($databases as $key => $targets) {
    foreach ($targets as $target => $conninfos) {
      if (isset($conninfos['driver'])) {
        $conninfos = array($conninfos);
      }
      foreach ($conninfos as $conninfo) {
        if ($conninfo['driver'] !== 'autoslave' || (isset($conninfo['global replication lag']) && !$conninfo['global replication lag'])) {
          continue;
        }
        try {
          $tables = Database::getConnection($target, $key)->getAffectedTables(time());
          foreach ($tables as $row) {
            $desc = t('in @expires_in seconds', array('@expires_in' => $row['expires'] - time()));
            $row['expires'] = date('Y-m-d H:i:s', $row['expires']) . " ($desc)";

            $desc = t('@age seconds ago', array('@age' => time() - $row['invalidated']));
            $row['invalidated'] = date('Y-m-d H:i:s', $row['invalidated']) . " ($desc)";

            $active[$row['db_key'] . ':' . $row['db_target'] . ':' . $row['affected_table']] = array(
              'key' => $row['db_key'],
              'target' => $row['db_target'],
              'table' => $row['affected_table'],
              'invalidated' => $row['invalidated'],
              'expires' => $row['expires'],
              'in_sync' => isset($row['wcnt1_slave']) ? ($row['wcnt1_slave'] === $row['wcnt1'] ? t('Yes') : t('No')) : t('N/A'),
            );
          }
        }
        catch (Exception $e) {
          drush_set_error(dt('Error connecting to: [@key][@target]', array(
            '@key' => $conninfo['key'],
            '@target' => $conninfo['target']
          )), 'error');
        }
      }
    }
  }

  $header = array('Key', 'Target', 'Table', 'Invalidated', 'Expires', 'In sync.');
  array_unshift($active, $header);
  drush_print_table($active);
}

function drush_autoslave_sql_cli() {
  drush_sql_bootstrap_further();
  $db_spec = NULL;
  $connection = Database::getConnection();
  if ($connection->driver() == 'autoslave') {
    $master_id = $connection->determineMaster();
    $pool = $connection->getPool();
    $db_spec = $pool['all'][$master_id];
  }
  drush_shell_proc_open(_drush_sql_connect($db_spec));
}


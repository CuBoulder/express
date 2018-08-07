<?php

$class = 'AutoslaveAffectedTablesDatabaseAccurate2';

class AutoslaveAffectedTablesDatabaseAccurate2 extends AutoslaveAffectedTables {
  private $tables = array();
  private $writes = 0;

  function __destruct() {
    foreach ($this->tables as $key => $targets) {
      foreach ($targets as $target => $tables) {
        $this->writes++;
        $rows = $this->connection->update('autoslave_affected_tables')
          ->expression('wcnt1', 'wcnt1 + 1')
          ->expression('wcnt2', "wcnt2 - 1")
          ->condition('db_key', $key)
          ->condition('db_target', $target)
          ->condition('affected_table', array_keys($tables), 'IN')
          ->execute();
      }
    }
    error_log("Extra writes: $this->writes");
  }

  function update($target, $key, $tables, $expires) {
    if ($this->connection->inTransaction()) {
      $multi = array(0 => $tables);
    }
    else {
      $multi = array();
      foreach ($tables as $table) {
        if (isset($this->tables[$key][$target][$table])) {
          $multi[0][] = $table;
        }
        else {
          $this->tables[$key][$target][$table] = 1;
          $multi[1][] = $table;
        }
      }
    }
    $time = time();
    foreach ($multi as $wcnt2 => $tables) {
      $retry = array();
      $this->writes++;
      $rows = $this->connection->update('autoslave_affected_tables')
        ->fields(array(
          'expires' => $expires,
          'invalidated' => $time,
        ))
        ->expression('wcnt1', 'wcnt1 + 1')
        ->expression('wcnt2', "wcnt2 + $wcnt2")
        ->condition('db_key', $key)
        ->condition('db_target', $target)
        ->condition('affected_table', $tables, 'IN')
        ->execute();

      if ($rows < count($tables)) {
        foreach ($tables as $table) {
          try {
            $this->writes++;
            $this->connection->insert('autoslave_affected_tables')
              ->fields(array(
                'db_key' => $key,
                'db_target' => $target,
                'affected_table' => $table,
                'expires' => $expires,
                'invalidated' => time(),
                'wcnt2' => $wcnt2,
              ))
              ->execute();
          }
          catch (Exception $e) {
            // Possible race condition, let's try updating it again.
            $retry[] = $table;
          }
        }
      }

      if ($retry) {
        // @todo Retry tables in $retry, but without potentially double-bumping wcnt2
        // $this->update($target, $key, array($table), $expires, TRUE);
      }
    }
  }

  function get($expires = 0) {
    // Load status from master
    $master_tables = $this->connection->select('autoslave_affected_tables', 'a')
                ->fields('a')
                ->execute()
                ->fetchAll(PDO::FETCH_ASSOC);

    // Load status from slave
    $slave_tables = $this->connection->getSlaveConnection(TRUE)->select('autoslave_affected_tables', 'a')
                ->fields('a')
                ->execute()
                ->fetchAll(PDO::FETCH_ASSOC);
    
    // Prepare slave data for comparison
    foreach ($slave_tables as $idx => $table) {
      $key = $table['db_key'] . ':' . $table['db_target'] . ':' . $table['affected_table'];
      $slave_tables[$key] = $table;
      unset($slave_tables[$idx]);
    }

    // Compare status from master and slave.
    // If write counters are identical and table was invalidated more than the "replication lag" ago,
    // consider the table slave-safe.
    $tables = array();
    foreach ($master_tables as $idx => $table) {
      $key = $table['db_key'] . ':' . $table['db_target'] . ':' . $table['affected_table'];
      $table['wcnt1_slave'] = 0;
      if ($table['wcnt2'] == 0 && !empty($slave_tables[$key])) {
        if (
          $slave_tables[$key]['wcnt1'] === $table['wcnt1'] &&
          $table['invalidated'] + $this->connection->getReplicationLag() < time()
        ) {
          continue;
        }
        $table['wcnt1_slave'] = $slave_tables[$key]['wcnt1'];
      }
      $tables[] = $table;
    }

    return $tables;
  }
}

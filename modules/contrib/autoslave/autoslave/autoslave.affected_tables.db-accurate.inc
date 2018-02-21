<?php

$class = 'AutoslaveAffectedTablesDatabaseAccurate';

class AutoslaveAffectedTablesDatabaseAccurate extends AutoslaveAffectedTables {
  function update($target, $key, $tables, $expires) {
    $time = time();
    $lag = (int)($expires - $time);
    $lag = $lag < 0 ? 0 : $lag;
            
    // If this is a transactional commit, we update current invalidated tables with the lag,
    // to mitigate the potential race-condition effect of the non-transactional writes to
    // autoslave_affected_tables
    if (!$this->connection->transactionalizeWrite(TRUE) && $this->connection->inTransaction()) {
      $this->connection->getMasterConnection()->update('autoslave_affected_tables')
        ->expression('expires', 'expires + :lag', array(':lag' => $lag + $this->connection->getReplicationLag()))
        ->condition('db_key', $key)
        ->condition('db_target', $target)
        ->condition('affected_table', $tables, 'NOT IN')
        ->condition('expires', time() + $this->connection->getReplicationLag(), '>=')
        ->execute();
    }

    $rows = $this->connection->getMasterConnection()->update('autoslave_affected_tables')
      ->fields(array(
        'expires' => $expires,
        'invalidated' => $time,
      ))
      ->expression('wcnt1', 'wcnt1 + 1')
      ->condition('db_key', $key)
      ->condition('db_target', $target)
      ->condition('affected_table', $tables, 'IN')
      ->execute();

    if ($rows < count($tables)) {
      foreach ($tables as $table) {
        try {
          $this->connection->getMasterConnection()->insert('autoslave_affected_tables')
            ->fields(array(
              'db_key' => $key,
              'db_target' => $target,
              'affected_table' => $table,
              'expires' => $expires,
              'invalidated' => time(),
            ))
            ->execute();
        }
        catch (Exception $e) {
          // Ignore error if trying to re-insert previously updated row.
        }
      }
    }
  }

  function get($expires = 0) {
    // Load status from master
    $master_tables = $this->connection->getMasterConnection()->select('autoslave_affected_tables', 'a')
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
      $table['wcnt1_slave'] = '';
      if (!empty($slave_tables[$key])) {
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

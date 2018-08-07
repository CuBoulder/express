<?php

$class = 'AutoslaveAffectedTablesDatabase';

class AutoslaveAffectedTablesDatabase extends AutoslaveAffectedTables {
  function update($target, $key, $tables, $expires, $update_only = FALSE) {
    $lag = (int)($expires - time());
    $lag = $lag < 0 ? 0 : $lag;

    // If this is a transactional commit, we update current invalidated tables with the lag,
    // to mitigate the potential race-condition effect of the non-transactional writes to
    // autoslave_affected_tables
    if ($this->connection->inTransaction()) {
      db_query("UPDATE {autoslave_affected_tables}
      SET expires = expires + :lag
      WHERE db_key = :key
      AND db_target = :target
      AND affected_table NOT IN (:tables)
      AND expires >= :expires
      ", array(
        ':key' => $key,
        ':target' => $target,
        ':lag' => $lag + $this->connection->getReplicationLag(),
        ':tables' => $tables,
        ':expires' => time() + $this->connection->getReplicationLag()
      ));
    }

    // Set expiration to either the specified $expires OR the highest expiration
    // currenty in progress + the lag. We do not use a placeholder for $lag, since
    // we ensure it's an integer and we don't want it quoted in any way.
    $rows = db_query("UPDATE {autoslave_affected_tables}
    SET invalidated = :time, 
        wcnt1 = wcnt1 + 1,
        expires = (
          SELECT (CASE WHEN m.max_expires > :expires THEN max_expires + $lag ELSE :expires2 END) AS max_expires 
          FROM (
            SELECT MAX(expires) AS max_expires
            FROM {autoslave_affected_tables}
            WHERE db_key = :key2
            AND db_target = :target2
          ) m
        )
    WHERE db_key = :key
    AND db_target = :target
    AND affected_table IN (:tables)
    ", array(
      ':key' => $key,
      ':key2' => $key,
      ':target' => $target,
      ':target2' => $target,
      ':expires' => $expires,
      ':expires2' => $expires,
      ':time' => time(),
      ':tables' => $tables,
    ))->rowCount();

    if (!$update_only && $rows < count($tables)) {
      foreach ($tables as $table) {
        try {
          $this->connection->insert('autoslave_affected_tables')
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
          // Possible race condition, let's try updating it again.
          $this->update($target, $key, array($table), $expires, TRUE);
        }
      }
    }
  }

  function get($expires = 0) {
    return $this->connection->select('autoslave_affected_tables', 'a')
      ->fields('a')
      ->condition('a.expires', $expires, '>')
      ->execute()
      ->fetchAll(PDO::FETCH_ASSOC);
  }
}

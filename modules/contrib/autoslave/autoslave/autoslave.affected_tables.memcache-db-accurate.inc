<?php

include_once 'autoslave.affected_tables.db-accurate.inc';
$class = 'AutoslaveAffectedTablesMemcache';

class AutoslaveAffectedTablesMemcache extends AutoslaveAffectedTablesDatabaseAccurate {
  private $cacheobj;
  private $last_offset = -1;
  private $tables = array();


  function __construct($connection) {
    parent::__construct($connection);
  }

  function update($target, $key, $tables, $expires) {
    parent::update($target, $key, $tables, $expires);
    $offset = $this->dmemcache_inc('master_tables_offset', 1, 0, 0, 'autoslave_affected_tables');

    // We might as well update our internal status if possible, to avoid reloading table status.
    // This is only possible, if there has been no updates in between (i.e. delta offset === 1).
    if ($offset - $this->last_offset === 1) {
      $this->last_offset = $offset;
    }

    // Cleanup after ourselves. 50 caches back ...
    $offset -= 50;
    if ($offset >= 0) {
      dmemcache_delete("master_tables_$offset", 'autoslave_affected_tables');
    }
  }

  function get($expires = 0) {
    // Load status from master
    $cache = NULL;
    $offset = dmemcache_get('master_tables_offset', 'autoslave_affected_tables');
    if (!is_numeric($offset)) {
      $offset = $this->dmemcache_inc('master_tables_offset', 1, 0, 0, 'autoslave_affected_tables');
    }

    // No need to "sync"
    if ($this->last_offset === $offset) {
      return $this->tables;
    }
    $this->last_offset = $offset;

    // Get cached tables
    $cache = dmemcache_get("master_tables_$offset", 'autoslave_affected_tables');

    // Get from DB unless proper cache data exists
    if (is_array($cache)) {
      $master_tables = $cache;
    }
    else {
      $master_tables = $this->connection->getMasterConnection()->select('autoslave_affected_tables', 'a')
                  ->fields('a')
                  ->execute()
                  ->fetchAll(PDO::FETCH_ASSOC);
      dmemcache_set("master_tables_$offset", $master_tables, 0, 'autoslave_affected_tables');
    }

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
    $this->tables = array();
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
      $this->tables[] = $table;
    }

    return $this->tables;
  }

  function dmemcache_inc($key, $offset = 1, $init_value = 0, $exp = 0, $bin = 'cache', $mc = NULL) {
    global $_memcache_statistics;
    $full_key = dmemcache_key($key, $bin);
    $_memcache_statistics[] = array('inc', $bin, $full_key, '');
    if ($mc || ($mc = dmemcache_object($bin))) {
      if ($mc instanceof Memcached) {
        return $mc->increment($full_key, $offset);
      }
      else {
        $mc->add($full_key, $init_value, FALSE, $exp);
        return $mc->increment($full_key, $offset);
      }
    }
    return FALSE;
  }

}

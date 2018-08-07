<?php

$class = 'AutoslaveAffectedTablesMemcache';

class AutoslaveAffectedTablesMemcache extends AutoslaveAffectedTables {
  private $cacheobj;

  function __construct($connection) {
    $this->cacheobj = new MemCacheDrupal('autoslave_affected_tables');
    parent::__construct($connection);
  }

  function update($target, $key, $tables, $expires) {
    $lag = (int)($expires - time());
    $lag = $lag < 0 ? 0 : $lag;

    // Attempt to update max expires atomically.
    $lock = lock_acquire('autoslave_affected_tables_memcache_expires');
    $expire = microtime(TRUE) + 5;
    while (!$lock && microtime(TRUE) < $expire) {
      lock_wait('autoslave_affected_tables_memcache_expires', 1);
      $lock = lock_acquire('autoslave_affected_tables_memcache_expires');
    }

    // If we didn't get the lock, then we'll just go ahead and update it anyways
    $cache = $this->cacheobj->get("autoslave_affected_tables_memcache_max_expires");
    $expires = $cache && $cache->data > $expires ? $cache->data + $lag : $expires;
    $this->cacheobj->set("autoslave_affected_tables_memcache_max_expires", $expires);
    if ($lock) {
      lock_release('autoslave_affected_tables_memcache_expires');
    }

    $newkeys = array();
    // Store affected tables in memcache, one key per entry 
    foreach ($tables as $table) {
      $newkey = "$key:$target:$table";
      $newkeys[] = $newkey;
      $this->cacheobj->set($newkey, $expires);
    }

    // Should we update the list of keys?
    $keys = $this->getKeys();
    $newkeys = array_unique(array_merge($keys, $newkeys));
    // Once the list of keys has been populated with all known tables and targets,
    // the list will not need updating anymore. The following lock will only be
    // acquired during cold cache.
    if ($keys !== $newkeys) { 
      // Yes, lets lock and reload.
      $lock = lock_acquire('autoslave_affected_tables_memcache');
      $expire = microtime(TRUE) + 5;
      while (!$lock && microtime(TRUE) < $expire) {
        lock_wait('autoslave_affected_tables_memcache', 1);
        $lock = lock_acquire('autoslave_affected_tables_memcache');
      }

      if ($lock) {
        $keys = $this->getKeys();
        $newkeys = array_unique(array_merge($keys, $newkeys));
        $this->setKeys($newkeys);
        lock_release('autoslave_affected_tables_memcache');
      }
      else {
        // No lock! Either stale or race-condition.
      }
    }
  }

  function get($expires = 0) {
    $tables = array();
    if ($keys = $this->getKeys()) {
      if ($cache = $this->cacheobj->getMultiple($keys)) {
        foreach ($cache as $key => $data) {
          if ($data->data >= $expires) {
            list($key, $target, $table) = explode(':', $key);
            $tables[] = array(
              'db_key' => $key,
              'db_target' => $target,
              'affected_table' => $table,
              'expires' => $data->data,
              'invalidated' => $data->created,
            );
          }
        }
      }
    }
    return $tables;
  }

  function setKeys($keys) {
    $this->cacheobj->set('keys', $keys);
  }

  function getKeys() {
    $keys = array();
    if (($cache = $this->cacheobj->get('keys')) && is_array($cache->data) && !empty($cache->data)) {
      $keys = $cache->data;
    }
    return $keys;
  }
}

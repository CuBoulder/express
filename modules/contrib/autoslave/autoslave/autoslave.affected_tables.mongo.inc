<?php

$mongodb_module = variable_get('autoslave_mongodb_module', 'sites/all/modules/mongodb/mongodb.module');
require_once $mongodb_module;

$class = 'AutoslaveAffectedTablesMongo';

class AutoslaveAffectedTablesMongo extends AutoslaveAffectedTables {
  function update($target, $key, $tables, $expires) {
    $lag = (int)($expires - time());
    $lag = $lag < 0 ? 0 : $lag;

    $collection = mongodb_collection('autoslave_affected_tables');

    // Attempt to update max expires atomically.
    $lock = lock_acquire('autoslave_affected_tables_mongo_expires');
    $expire = microtime(TRUE) + 5;
    while (!$lock && microtime(TRUE) < $expire) {
      lock_wait('autoslave_affected_tables_mongo_expires', 1);
      $lock = lock_acquire('autoslave_affected_tables_mongo_expires');
    }

    // If we didn't get the lock, then we'll just go ahead and update it anyways
    $document = $collection->find()->sort(array('expires' => -1))->limit(1)->getNext();
    $max_expires = $document ? $document['expires'] : 0;
    $expires = $max_expires > $expires ? $max_expires + $lag : $expires;

    // @todo Is it possible to do a multi-update instead?
    foreach ($tables as $table) {
      $entry = array(
        'db_key' => $key,
        'db_target' => $target,
        'affected_table' => $table,
        'expires' => $expires,
        'invalidated' => time(),
        '_id' => "$key:$target:$table",
      );
      // Don't update entry with a lesser expires value.
      $criteria = array('_id' => $entry['_id'], 'expires' => array('$lt' => $expires));
      $options = array('upsert' => TRUE);
      $collection->update($criteria, $entry, $options);
    }

    if ($lock) {
      lock_release('autoslave_affected_tables_memcache_expires');
    }
  }

  function get($expires = 0) {
    $collection = mongodb_collection('autoslave_affected_tables');
    $query = array(
      'expires' => array('$gt' => $expires)
    );
    $result =  $collection->find($query);
    $tables = array();
    foreach ($result as $document) {
      $table = (array)$document;
      unset($table['_id']);
      $tables[] = $table;
    }
    return $tables;
  }
}

<?php
/**
 * @file
 * Cache class wrapper for non-transactional backend
 */

class AutoslaveCache implements DrupalCacheInterface {
  protected $backend = NULL;
  protected $bin;
  static protected $buffer = array();
  static protected $backends = array();
  static protected $globalBuffering = FALSE;
  protected $useBuffering;

  /**
   * Constructor.
   *
   * Initialize bin.
   */
  public function __construct($bin) {
    $this->bin = $bin;

    // Let our parent do his work.
    $class = variable_get('autoslave_cache_class_' . $bin);
    if (!isset($class)) {
      $class = variable_get('autoslave_cache_default_class', 'DrupalDatabaseCache');
    }

    // Just in case of misconfiguration.
    $this->useBuffering = $class != 'DrupalDatabaseCache';

    $this->backend = new $class($bin);
    self::$backends[$bin] = $this->backend;
  }

  /**
   * Destructor.
   *
   * Flush remaining buffers, if any.
   */
  public function __destruct() {
    self::flushBuffers();
  }

  /**
   * Implements DrupalCacheInterface::get().
   */
  public function get($cid) {
    $cids = array($cid);
    $cache = $this->getMultiple($cids);
    return reset($cache);
  }

  /**
   * Find an entry in the buffer that matches the $cid.
   *
   * ... with or without wildcard.
   */
  protected function matchKey($cid) {
    if (!empty(self::$buffer[$this->bin])) {
      if (isset(self::$buffer[$this->bin][$cid])) {
        return self::$buffer[$this->bin][$cid];
      }

      // Wildcard check. Only relevant for clear().
      foreach (self::$buffer[$this->bin] as $args) {
        switch ($args[0]) {
          case 'clear':
            if ($args[2] && strpos($cid, $args[1]) === 0) {
              return $args;
            }
        }
      }
    }
  }

  /**
   * Implements DrupalCacheInterface::getMultiple().
   *
   * Get multiple cache entries taking buffer into account.
   */
  public function getMultiple(&$cids) {
    if (!self::$globalBuffering && !$this->useBuffering) {
      return $this->backend->getMultiple($cids);
    }
    $ocids = $cids;
    $return = $this->backend->getMultiple($cids);

    // If buffer is not empty, then check for changes in $cids requested.
    if (!empty(self::$buffer[$this->bin])) {
      $cids = array_flip($cids);
      foreach ($ocids as $cid) {
        if ($args = $this->matchKey($cid)) {
          switch ($args[0]) {
            case 'set':
              $return[$cid] = (object) array(
                'cid' => $cid,
                'data' => $args[2],
                'created' => time(),
                'headers' => NULL,
                'flushes' => 0,
                'expire' => $args[3],
              );
              unset($cids[$cid]);
              break;

            case 'clear':
              unset($return[$cid]);
              $cids[$cid] = TRUE;
              break;

          }
        }
      }
      $cids = array_keys($cids);
    }
    if (!empty($cids)) {
      $connection = Database::getConnection();
      if ($connection->driver() == 'autoslave') {
        $options = $connection->getConnectionOptions();
        if ($options['debug']) {
          watchdog('cache_miss', "CIDS: " . join(', ', $cids), array(), WATCHDOG_DEBUG);
        }
        if ($options['resync on cache miss']) {
          $connection->resyncAffectedTables();
        }
      }
    }
    return $return;
  }

  /**
   * Implements DrupalCacheInterface::set().
   *
   * Buffer cache operation if inside transaction.
   */
  public function set($cid, $data, $expire = CACHE_PERMANENT) {
    if (
      !self::$globalBuffering &&
      (!$this->useBuffering || Database::getConnection()->transactionDepth() == 0)
    ) {
      return $this->backend->set($cid, $data, $expire);
    }
    else {
      self::$buffer[$this->bin][$cid] = array('set', $cid, $data, $expire);
    }
  }

  /**
   * Implements DrupalCacheInterface::clear().
   *
   * Buffer cache operation if inside transaction.
   */
  public function clear($cid = NULL, $wildcard = FALSE) {
    if ($this->backend instanceOf MemcacheDrupal) {
      $backtrace = debug_backtrace();
      if ($cid == MEMCACHE_CONTENT_CLEAR || (isset($backtrace[2]) && $backtrace[2]['function'] == 'cache_clear_all' && empty($backtrace[2]['args']))) {
        $cid = MEMCACHE_CONTENT_CLEAR;
      }
    }
    if (
      !self::$globalBuffering &&
      (!$this->useBuffering || Database::getConnection()->transactionDepth() == 0)
    ) {
      return $this->backend->clear($cid, $wildcard);
    }
    else {
      $cids = is_array($cid) ? $cid : array($cid);
      foreach ($cids as $cid) {
        self::$buffer[$this->bin][$cid] = array('clear', $cid, $wildcard);
      }
    }
  }

  /**
   * Implements DrupalCacheInterface::isEmpty().
   */
  public function isEmpty() {
    if (!self::$globalBuffering && !$this->useBuffering) {
      return $this->backend->isEmpty();
    }
    // Check buffer first.
    if (!empty(self::$buffer[$this->bin])) {
      foreach (self::$buffer[$this->bin] as $cids) {
        foreach ($cids as $args) {
          if ($args[0] == 'set') {
            return FALSE;
          }
        }
      }
    }
    // Then the backend.
    // @todo Check clear operations from buffer?
    return $this->backend->isEmpty();
  }

  /**
   * Clear cache operation buffer.
   *
   * Clear all affected cids from cache, just for safety in
   * order to keep cache properly in sync with data stored in db.
   * This is called only during rollback scenarios.
   */
  static public function clearBuffers() {
    // We must force buffering during the flush, to ensure that
    // the cache operations are performed in the right order.
    self::$globalBuffering = TRUE;

    while ($element = self::array_kshift(self::$buffer)) {
      list($bin, $cids) = $element;
      $backend = self::$backends[$bin];
      $clear_cids = array();
      while ($args = array_shift($cids)) {
        $method = array_shift($args);

        if ($method == 'set') {
          $method = 'clear';
          $args = array($args[0], FALSE);
        }
        if ($method == 'clear') {
          if (!$args[1]) {
            $clear_cids[] = $args[0];
          }
          else {
            call_user_func_array(array($backend, $method), $args);
          }
        }
      }
      if ($clear_cids) {
        $backend->clear($clear_cids, FALSE);
      }
    }
    self::$globalBuffering = FALSE;
  }

  /**
   * Flush cache operation buffer.
   */
  static public function flushBuffers() {
    // We must force buffering during the flush, to ensure that
    // the cache operations are performed in the right order.
    self::$globalBuffering = TRUE;

    while ($element = self::array_kshift(self::$buffer)) {
      list($bin, $cids) = $element;
      $backend = self::$backends[$bin];
      $clear_cids = array();
      while ($args = array_shift($cids)) {
        $method = array_shift($args);

        // If no wildcard on clear, let's pile up the cid and do multi clear.
        if ($method == 'clear' && !$args[1]) {
          $clear_cids[] = $args[0];
        }
        else {
          call_user_func_array(array($backend, $method), $args);
        }
      }

      // Multiple clear.
      if ($clear_cids) {
        $backend->clear($clear_cids, FALSE);
      }
    }
    self::$globalBuffering = FALSE;
  }

  /**
   * Like array_shift() but for key AND value.
   *
   * @param array $array
   *   Array to shift key and value from.
   *
   * @return array
   *   Key and value.
   *
   * @see http://dk1.php.net/manual/en/function.array-shift.php
   */
  static public function array_kshift(&$array) {
    if ($array) {
      list($key) = array_keys($array);
      $value = $array[$key];
      unset($array[$key]);
      return array($key, $value);
    }
    return array();
  }
}

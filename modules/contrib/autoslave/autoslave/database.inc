<?php

/**
 * @file
 * Database interface code for automatic slave selection depending on type of
 * query.
 *
 * @todo Ensure default method arguments will work if they differ from what's
 *       defined in class Database.
 */

include_once 'defines.inc';

class AutoslaveAffectedTables {
  protected $connection = NULL;

  function __construct($connection) {
    $this->connection = $connection;
  }
}

/**
 * @ingroup database
 * @{
 */

/**
 * Specific auto slave implementation of DatabaseConnection.
 */
class DatabaseConnection_autoslave extends DatabaseConnection {

  /**
   * List of tables that should always use "master" as target
   */
  protected $__master_tables = array();

  /**
   * List of tables that should use "master" as target in the current request
   */
  protected $__tables = array();
  public $__affected_tables = array();

  /**
   * Chosen master and slave
   */
  protected $__master;
  protected $__slave;
  protected $__system;
  public $max_expires = 0;

  /**
   * Force queries to master
   */
  private $__force_master = 0;
  private $__transaction = 0;

  /**
   * Setup booleans
   */
  private $__setup_session = FALSE;
  private $__setup_global = FALSE;

  /**
   * Automatic id assigment counter
   */
  static private $autoslave_id = 1;

  /**
   * Pool of connections
   */
  private $__pool = array();

  /**
   * Watchdog messages to log
   */
  private $__watchdog = array();

  /**
   * System is in read-only mode
   */
  protected $__readonly = FALSE;

  protected $__exception = FALSE;

  public $__transactionsRolledBack = FALSE;
  private $__affected_tables_backend = NULL;
  static private $__affected_tables_backend_classes = array();

  /**
   * Constructor.
   */
  public function __construct(array $connection_options = array()) {

    // If salt is empty, we generate a salt before autoslave mangles the
    // $databases array. This way we get a consistent salt for the site
    // like it was intended.
    global $drupal_hash_salt, $databases;
    if (empty($drupal_hash_salt)) {
      $drupal_hash_salt = hash('sha256', serialize($databases));
    }

    // Sanitize connection options
    $connection_options['master'] = !empty($connection_options['master']) ? $connection_options['master'] : array('master');
    if (!is_array($connection_options['master'])) {
      $connection_options['master'] = array($connection_options['master']);
    }

    $connection_options['slave'] = !empty($connection_options['slave']) ? $connection_options['slave'] : array('autoslave');
    if (!is_array($connection_options['slave'])) {
      $connection_options['slave'] = array($connection_options['slave']);
    }
    $connection_options['watchdog on shutdown'] = isset($connection_options['watchdog on shutdown']) ? $connection_options['watchdog on shutdown'] : AUTOSLAVE_WATCHDOG_ON_SHUTDOWN;
    $connection_options['replication lag'] = isset($connection_options['replication lag']) ? $connection_options['replication lag'] : variable_get('autoslave_assumed_replication_lag', AUTOSLAVE_ASSUMED_REPLICATION_LAG);
    $connection_options['global replication lag'] = isset($connection_options['global replication lag']) ?  $connection_options['global replication lag'] : AUTOSLAVE_GLOBAL_REPLICATION_LAG;
    $connection_options['invalidation path'] = isset($connection_options['invalidation path']) ?  $connection_options['invalidation path'] : NULL;

    $connection_options['init_commands'] = isset($connection_options['init_commands']) ?  $connection_options['init_commands'] : array();
    $connection_options['use autoslave schema'] = isset($connection_options['use autoslave schema']) ?  $connection_options['use autoslave schema'] : TRUE;
    $connection_options['affected tables backend'] = isset($connection_options['affected tables backend']) ?  $connection_options['affected tables backend'] : 'autoslave.affected_tables.db-accurate.inc';
    $connection_options['bypass page cache'] = isset($connection_options['bypass page cache']) ?  $connection_options['bypass page cache'] : 0;
    $connection_options['preconnect'] = isset($connection_options['preconnect']) ?  $connection_options['preconnect'] : FALSE;
    $connection_options['flag all tables'] = isset($connection_options['flag all tables']) ?  $connection_options['flag all tables'] : FALSE;
    $connection_options['resync on cache miss'] = isset($connection_options['resync on cache miss']) ?  $connection_options['resync on cache miss'] : TRUE;
    $connection_options['transactionalize writes'] = isset($connection_options['transactionalize writes']) ?  $connection_options['transactionalize writes'] : TRUE;
    $connection_options['debug'] = isset($connection_options['debug']) ?  $connection_options['debug'] : FALSE;

    $this->__tables = isset($connection_options['tables']) ? $connection_options['tables'] : array('sessions', 'semaphore', 'watchdog');
    $this->__tables[] = 'autoslave_affected_tables';

    $this->connectionOptions = $connection_options;

    // Load affected tables backend
    $class = NULL;
    require_once $connection_options['affected tables backend'];
    if ($class) {
      self::$__affected_tables_backend_classes[$connection_options['affected tables backend']] = $class;
    }
    else {
      $class = self::$__affected_tables_backend_classes[$connection_options['affected tables backend']];
    }
    $this->__affected_tables_backend = new $class($this);


    // Initialize and prepare the connection prefix.
    $this->setPrefix(isset($this->connectionOptions['prefix']) ? $this->connectionOptions['prefix'] : '');

    // Initialize force master tables
    if (!empty($this->__tables)) {
      $this->__master_tables = $this->__tables = array_combine($this->__tables, $this->__tables);
    }

    // Has master been forced before Database bootstrapping?
    if (!empty($GLOBALS['autoslave_pre_bootstrap_force_master'])) {
      $this->forceMaster(1);
    }

    drupal_register_shutdown_function(array($this, 'logWatchdogMessages'));
  }

  /**
   * Set key is called immediatly after the constructor, so
   * now we can set up the connections.
   */
  function setKey($key) {
    if (!isset($this->key)) {
      $this->key = $key;
      $this->setupConnections();
      if (drupal_valid_test_ua()) {
        $this->connectionOptions['replication lag'] = 0;
        $this->connectionOptions['global replication lag'] = FALSE;
        return;
      }
    }
  }

  /**
   * Dispatch all methods defined in class PDO to the appropiate backend
   */
  public function beginTransaction() { return $this->getMasterConnection()->beginTransaction(); }
  public function errorCode() { return $this->getMasterConnection()->errorCode(); }
  public function errorInfo() { return $this->getMasterConnection()->errorInfo(); }
  public function exec($statement) { return $this->getMasterConnection()->exec($statement); }
  public function getAttribute($attribute) { return $this->getMasterConnection()->getAttribute($attribute); }
  public function lastInsertId($name = NULL) { return $this->getMasterConnection()->lastInsertId($name); }
  public function quote($string, $paramtype = NULL) { return $this->getMasterConnection()->quote($string, $paramtype); }
  public function setAttribute($attribute, $value) { return $this->getMasterConnection()->setAttribute($attribute, $value); }

  /**
   * Dispatch all methods defined in class Database to the appropiate backend
   */
  /**
   * "master" functions
   */
  public function inTransaction() { return $this->getMasterConnection()->inTransaction(); }
  public function transactionDepth() { return $this->getMasterConnection()->transactionDepth(); }
  public function rollback($savepoint_name = 'drupal_transaction') { return $this->getMasterConnection()->rollback($savepoint_name); }
  public function pushTransaction($name) { return $this->getMasterConnection()->pushTransaction($name); }
  public function popTransaction($name) { return $this->getMasterConnection()->popTransaction($name); }
  protected function popCommittableTransactions() { return $this->getMasterConnection()->popCommittableTransactions(); }
  protected function generateTemporaryTableName() { return $this->getMasterConnection()->generateTemporaryTableName(); }
  public function supportsTransactions() { return $this->getMasterConnection()->supportsTransactions(); }
  public function supportsTransactionalDDL() { return $this->getMasterConnection()->supportsTransactionalDDL(); }
  function commit() { return $this->getMasterConnection()->commit(); }

  /**
   * "slave" functions
   */
  protected function defaultOptions($full = TRUE) { 
    $options = $full ? $this->getSlaveConnection()->defaultOptions() : array(); 
    if ($this->__readonly) {
      $options['throw_exception'] = FALSE;
    }
    return $options;
  }
  public function prefixTables($sql) { return $this->getSlaveConnection()->prefixTables($sql); }
  public function tablePrefix($table = 'default') { return $this->getSlaveConnection()->tablePrefix($table); }
  public function prepareQuery($query) { return $this->getSlaveConnection()->prepareQuery($query); }
  public function makeSequenceName($table, $field) { return $this->getSlaveConnection()->makeSequenceName($table, $field); }
  public function makeComment($comments) { return $this->getSlaveConnection()->makeComment($comments); }
  protected function filterComment($comment = '') { return $this->getSlaveConnection()->filterComment($comment); }
  protected function expandArguments(&$query, &$args) { return $this->getSlaveConnection()->expandArguments($query, $args); }

  public function transactionalizeWrite($option_only = FALSE) {
    if ($option_only) {
      return $this->connectionOptions['transactionalize writes'];
    }
    else {
      return $this->connectionOptions['transactionalize writes'] && !$this->__transaction;
    }
  }
  /**
   * The following methods are absolutely necessary to overload manually (at least for MySQL)
   */
  public function version() { return $this->getSlaveConnection()->version(); }
  public function schema() { return $this->connectionOptions['use autoslave schema'] ? parent::schema() : $this->getMasterConnection()->schema(); }
  public function driver() { return 'autoslave'; }
  public function databaseType() { return $this->getSlaveConnection()->databaseType(); }
  public function query($query, array $args = array(), $options = array()) { 
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->deriveTargetFromQuery($query);
    }
    $tx = NULL;
    $is_write_query = $this->isWriteQuery($query);
    if ($this->transactionalizeWrite() && $is_write_query) {
      $tx = db_transaction();
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->query($query, $args, $options);

    $updated = TRUE;
    if ($tx && $is_write_query) {
      // If no rows were updated, we don't need to add affected table.
      $temp_options = $options + array(
        'return' => Database::RETURN_STATEMENT
      );
      switch ($temp_options['return']) {
        case Database::RETURN_AFFECTED:
          $updated = $result > 0;
          break;

        case Database::RETURN_STATEMENT:
          $updated = $result->rowCount() > 0;
          break;

        case Database::RETURN_INSERT_ID:
        case Database::RETURN_NULL:
          break;

        default:
          throw new PDOException('Invalid return directive: ' . $temp_options['return']);
      }
    }

    if ($tx) {
      $this->deriveBackendFromQuery($query, $updated);
      unset($tx);
    }
    return $result;
  }
  public function queryRange($query, $from, $count, array $args = array(), array $options = array()) { 
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->deriveTargetFromQuery($query);
    }
    return DatabaseSafeConnection::create($this, $options['target'])->queryRange($query, $from, $count, $args, $options);
  }
  public function queryTemporary($query, array $args = array(), array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
    }
    $table = DatabaseSafeConnection::create($this, $options['target'])->queryTemporary($query, $args, $options);
    if ($table) {
      $this->addAffectedTable($table, FALSE);
    }
    return $table;
  }
  public function mapConditionOperator($operator) { return $this->getMasterConnection()->mapConditionOperator($operator); }
  public function nextId($existing_id = 0) { return $this->getMasterConnection()->nextId($existing_id); }

  public function select($table, $alias = NULL, array $options = array()) {
    // If target "slave" is explicitely specified, we do not want to do a late query alter.
    $addtag = (isset($options['target']) && $options['target'] == 'slave') ? FALSE : TRUE;

    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->getTargetForTable($table);
    }
    $conn = DatabaseSafeConnection::create($this, $options['target']);
    $query = $conn->select($table, $alias, $options);

    // If we're before or inside the variables bootstrap phase, then we can't support 
    // db_select()->join() due to recursiveness.
    // It should be safe to bail out though. Only if lock or cache backend uses db_select()
    // with a followin join, then we're in trouble. Fortunately core doesn't do that.
    if (!$addtag || drupal_bootstrap(NULL, FALSE) <= DRUPAL_BOOTSTRAP_VARIABLES) {
      return $query;
    }
    drupal_bootstrap(DRUPAL_BOOTSTRAP_VARIABLES, FALSE);
    $query->addMetaData('autoslave_connection', array($this->getTarget(), $this->getKey()));
    return $query->addTag('autoslave');
  }

  public function changeQueryConnection($query, $connection) {
    $prop = new ReflectionProperty($query, 'connection');
    $prop->setAccessible(TRUE);
    $prop->setValue($query, $connection);
  }

  public function insert($table, array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
      if (!$this->transactionalizeWrite()) {
        $this->addAffectedTable($table);
      }
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->insert($table, $options);
    if ($this->transactionalizeWrite()) {
      $this->changeQueryConnection($result, $this);
    }
    return $result;
  }

  public function merge($table, array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
      if (!$this->transactionalizeWrite()) {
        $this->addAffectedTable($table);
      }
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->merge($table, $options);
    if ($this->transactionalizeWrite()) {
      $this->changeQueryConnection($result, $this);
    }
    return $result;
  }

  public function update($table, array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
      if (!$this->transactionalizeWrite()) {
        $this->addAffectedTable($table);
      }
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->update($table, $options);
    if ($this->transactionalizeWrite()) {
      $this->changeQueryConnection($result, $this);
    }
    return $result;
  }

  public function delete($table, array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
      if (!$this->transactionalizeWrite()) {
        $this->addAffectedTable($table);
      }
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->delete($table, $options);
    if ($this->transactionalizeWrite()) {
      $this->changeQueryConnection($result, $this);
    }
    return $result;
  }

  public function truncate($table, array $options = array()) {
    if (!$this->prepareAutoslaveTarget($options)) {
      $options['target'] = $this->determineMasterTarget();
      if (!$this->transactionalizeWrite()) {
        $this->addAffectedTable($table);
      }
    }
    $result = DatabaseSafeConnection::create($this, $options['target'])->truncate($table, $options);
    if ($this->transactionalizeWrite()) {
      $this->changeQueryConnection($result, $this);
    }
    return $result;
  }

  /**
   * Magic methods. Supports propeties/functions/methods not defined by the Database class
   */
  public static function __callStatic($method, $args) {
    return call_user_func_array(array($this->getMasterConnection()->get_class_name(), $method), $args);
  }

  public function __call($method, $args) {
    return call_user_func_array(array($this->getMasterConnection(), $method), $args);
  }

  public function __get($key) {
    return $this->getMasterConnection()->$key;
  }

  public function __set($key, $value) {
    $this->getMasterConnection()->$key = $value;
  }






  /**
   * Internal autoslave functions
   */

  /**
   * Get the current pool of available targets
   */
  function getPool() {
    return $this->__pool;
  }

  /**
   * Get the assumed maximum replication lag
   */
  function getReplicationLag() {
    return intval($this->connectionOptions['replication lag']);
  }

  /**
   * Get the global replication lag setting
   */
  function getGlobalReplicationLag() {
    return $this->connectionOptions['global replication lag'];
  }

  /**
   * Check if a connection is available.
   *
   * @param $id
   *   Autoslave ID
   * @return mixed
   *   Exception object if error
   *   TRUE if available
   *   FALSE if available but flagged as down
   *   NULL if connection does not exist
   */
  function checkConnection($id) {
    $status = NULL;
    if (isset($this->__pool['all'][$id])) {
      $conninfo = &$this->__pool['all'][$id];
      if (isset($conninfo['status']) && is_object($conninfo['status'])) {
        $status = $conninfo['status'];
      }
      elseif (!isset($conninfo['status']) || $conninfo['status'] === FALSE) {
        // Try it out ...
        $key = $conninfo['key'];
        $c = &DatabaseInternals::getConnections();
        $d = &DatabaseInternals::getDatabaseInfo();
        try {
          $d[$key]['autoslave_check'] = $conninfo;
          Database::getConnection('autoslave_check', $key);
          $databases = $this->loadInvalidationFile($key);
          $status = isset($databases[$key][$conninfo['target']][$conninfo['idx']]['status']) ? FALSE : TRUE;
        }
        catch (Exception $e) {
          $status = $e;
        }
        unset($d[$key]['autoslave_check']);
        unset($c[$key]['autoslave_check']);
      }
      else {
        $status = TRUE;
      }
    }
    return $status;
  }

  /**
   * Return the Autoslave ID for a given target.
   *
   * @param $target
   *   Name of target
   */
  function getAutoslaveId($target) {
    $d = DatabaseInternals::getDatabaseInfo();
    return isset($d[$this->getKey()][$target]['autoslave_id']) ? $d[$this->getKey()][$target]['autoslave_id'] : NULL;
  }

  function loadInvalidationFile($key) {
    $databases = array();
    if (isset($this->connectionOptions['invalidation path'])) {
      $file = $this->connectionOptions['invalidation path'] . "/autoslave-invalidation-$key.inc";
      if (file_exists($file)) {
        include $file;
      }
    }
    return $databases;
  }

  /**
   * Update invalidation file
   */
  function updateInvalidationFile($key, $target, $idx, $status) {
    if (isset($this->connectionOptions['invalidation path'])) {
      $databases = $this->loadInvalidationFile($key);
      $file = $this->connectionOptions['invalidation path'] . "/autoslave-invalidation-$key.inc";
      if (!isset($databases[$key][$target][$idx]['status'])) {
        if (!$status) {
          $databases[$key][$target][$idx]['status'] = FALSE;
        }
        else {
          return;
        }
      }
      else {
        if ($databases[$key][$target][$idx]['status'] === $status) {
          return;
        }
      }

      if ($status) {
        unset($databases[$key][$target][$idx]['status']);
      }
      else {
        $databases[$key][$target][$idx]['status'] = FALSE;
      }
      $output = '<' . '?php' . "\n";
      if (!is_numeric($idx)) {
        watchdog('autoslave', "[$key][$target][$idx] is not a valid connection!", array(), WATCHDOG_ERROR);
        return;
      }
      if (!empty($databases[$key])) {
        foreach ($databases[$key] as $target => $conninfos) {
          foreach ($conninfos as $idx => $conninfo) {
            if (isset($databases[$key][$target][$idx]['status'])) {
              $output .= '$databases["' . $key . '"]["' . $target . '"][' . $idx . ']["status"] = FALSE;' . "\n";
            }
          }
        }
      }
      $temp_name = tempnam(sys_get_temp_dir(), 'file');
      file_put_contents($temp_name, $output);
      rename($temp_name, $file);
    }
  }

  /**
   * Assign id's to connections, sanitize slave probabilities
   * and populate pools.
   */
  function setupConnections() {
    $key = $this->getKey();

    global $databases;

    $this->__pool = array(
      'master' => array(),
      'slave' => array(),
      'all' => array(),
    );

    $backends = array(
      'master' => $this->connectionOptions['master'], 
      'slave' => $this->connectionOptions['slave'],
    );

    foreach ($backends as $backend => $targets) {
      foreach ($targets as $target) {
        if (empty($databases[$key][$target])) {
          $conninfos = array();
        }
        elseif (empty($databases[$key][$target]['driver'])) {
          $conninfos = &$databases[$key][$target];
        }
        else {
          $databases[$key][$target] = array($databases[$key][$target]);
          $conninfos = &$databases[$key][$target];
        }

        foreach ($conninfos as $idx => &$conninfo) {
          if (empty($conninfo['autoslave_id'])) {
            $conninfo['target'] = $target;
            $conninfo['key'] = $key;
            $conninfo['idx'] = $idx;
            $conninfo['autoslave_id'] = self::$autoslave_id++;
            $conninfo['weight'] = isset($conninfo['weight']) ? intval($conninfo['weight']) : 100;

            // Parse the prefix information.
            if (!isset($conninfo['prefix'])) {
              // Default to an empty prefix.
              $conninfo['prefix'] = array(
                'default' => '',
              );
            }
            elseif (!is_array($conninfo['prefix'])) {
              // Transform the flat form into an array form.
              $conninfo['prefix'] = array(
                'default' => $conninfo['prefix'],
              );
            }

            $this->__pool['all'][$conninfo['autoslave_id']] = &$conninfo;
          }
          $this->__pool[$backend][$target][$conninfo['autoslave_id']] = &$this->__pool['all'][$conninfo['autoslave_id']];
        }
      }
    }
    $this->__pool['registered'] = $this->__pool['all'];

    if (isset($this->connectionOptions['invalidation path'])) {
      $target = $this->getTarget();
      $file = $this->connectionOptions['invalidation path'] . "/autoslave-invalidation-$key.inc";
      if (file_exists($file)) {
        include $file;
      }
    }

    // At this level, using Exceptions may result in endless loops ... so we die!
    if (empty($this->__pool['master'])) {
      die('There are no masters defined for AutoSlave. Please configure settings.php');
    }
    if (empty($this->__pool['slave'])) {
      die('There are no slaves defined for AutoSlave. Please configure settings.php');
    }

    $this->determineMaster();
    $this->determineSlave();

    if ($this->connectionOptions['preconnect']) {
      DatabaseSafeConnection::create($this, $this->determineMasterTarget())->getConnection();
      DatabaseSafeConnection::create($this, $this->determineSlaveTarget())->getConnection();
    }

    return;
  }

  /**
   * Determine the slave to be used, and includes the master in the selection
   * if necessary.
   */
  function determineConnection($backend) {
    $targets = $this->__pool[$backend];
    foreach ($targets as $target => $conninfos) {
      // Gather weights
      $values = array();
      $weights = array();
      foreach ($conninfos as $conninfo) {
        // If we stumble upon an already connected connection, then use that one.
        if (isset($conninfo['connected'])) {
          if ($conninfo['connected'] === TRUE) {
            return $conninfo;
          }
          continue;
        }

        // Don't try an already failed one
        if (isset($conninfo['status']) && $conninfo['status'] !== TRUE) {
          continue;
        }

        $values[] = $conninfo;
        $weights[] = $conninfo['weight'];
      }

      // If no connection infos for this target, then try the next
      if (!$values) {
        continue;
      }

      // Weighted random selection!
      $conninfo = $this->rand_weighted($values, $weights);

      $d = &DatabaseInternals::getDatabaseInfo();
      $d[$conninfo['key']][$conninfo['target']] = $conninfo;
      return $conninfo;
    }

    if ($backend == 'master') {
      $this->goReadOnly();
    }

    $this->fatalThrow(new Exception("There are no connections available in the pool: $backend"));
  }

  /**
   * Throw an exception and disable watchdog on shutdown if necessary.
   */
  function fatalThrow($exception) {
    if (!$this->__exception) {
      // We remove any watchdog hooks, as they may cause a double-fault upon logging.
      if (!$this->connectionOptions['watchdog on shutdown']) {
        $implementations = &drupal_static('module_implements');
        $implementations['watchdog'] = array();
      }

      $this->__exception = $exception;
    }
    throw $exception;
  }

  /**
   * Put system into read only mode.
   */
  function goReadOnly() {
    $this->__readonly = TRUE;
    drupal_set_message(t('The system is currently in read-only mode. Any changes you make will not be saved!'), 'error');
  }

  /**
   * Determine the master to be use
   */
  function determineMaster($reload = FALSE) {
    if ($reload || !isset($this->__master)) {
      $this->__master = NULL;
      $conninfo = $this->determineConnection('master');
      $this->__master = $conninfo['autoslave_id'];
      if (!empty($conninfo['readonly'])) {
        $this->goReadOnly();
      }
    }
    return $this->__master;
  }

  /**
   * Determine the master target
   */
  function determineMasterTarget() {
    if (!$this->__master) {
      $this->fatalThrow(new Exception("No master connection has been chosen"));
    }
    $conninfo = $this->__pool['all'][$this->__master];
    return $conninfo['target'];
  }

  /**
   * Determine the slave
   */
  function determineSlave($reload = FALSE) {
    if ($reload || !isset($this->__slave)) {
      $this->__slave = NULL;
      $conninfo = $this->determineConnection('slave');
      $this->__slave = $conninfo['autoslave_id'];
    }
    return $this->__slave;
  }

  /**
   * Determine the slave to be used, and includes the master in the selection
   * if necessary.
   */
  function determineSlaveTarget() {
    if (!$this->__slave) {
      $this->fatalThrow(new Exception("No slave connection has been chosen"));
    }
    $conninfo = $this->__pool['all'][$this->__slave];
    return $conninfo['target'];
  }

  /**
   * Store watchdog message for later ... watchdogging!?
   */
  function watchdog($name, $msg, $args, $level) {
    $this->__watchdog[] = array($name, $msg, $args, $level);
  }

  /**
   * Log all registered messages to watchdog
   */
  function logWatchdogMessages() {
    foreach ($this->__watchdog as $log) {
      call_user_func_array('watchdog', $log);
    }
  }


  /**
   * Invalidate a connection, so that a failover connection may be attempted.
   */
  function invalidateConnection($id) {
    $conninfo = $this->__pool['all'][$id];
    $key = $conninfo['key'];
    $target = $conninfo['target'];
    $idx = $conninfo['idx'];

    $database_info = &DatabaseInternals::getDatabaseInfo();
    $conninfo = $database_info[$key][$target];
    global $databases;

    unset($databases[$key][$target][$idx]);
    if (empty($databases[$key][$target])) {
      // No more slaves, remove completely
      unset($database_info[$key][$target]);
      unset($databases[$key][$target]);
    }
    else {
      // Reindex target array for random select purposes
      $targets = array_values($databases[$key][$target]);
      $database_info[$key][$target] = $targets[mt_rand(0, count($targets) - 1)];
    }

    $this->updateInvalidationFile($key, $target, $idx, FALSE);

    $this->watchdog('autoslave', "Invalidated connection [@key][@target]@idx", array(
      '@key' => $key,
      '@target' => $target,
      '@idx' => isset($idx) ? "[$idx]" : '',
    ), WATCHDOG_ALERT);

    if ($id == $this->__slave) {
      $this->determineSlave(TRUE);
      $target = $this->determineSlaveTarget();
    }
    if ($id == $this->__master) {
      $this->determineMaster(TRUE);
      $target = $this->determineMasterTarget();
    }
    return $target;
  }

  /**
   * Get a connection for the given target.
   * Invalidates and redetermines if necessary.
   */
  function getSafeConnection($target) {
    $key = $this->getKey();
    if (!$this->isTargetAvailable($target)) {
      #throw new Exception("Connection [$key][$target] is not available");
    }
    $id = $this->getAutoslaveId($target);
    try {
      $ignoreTargets = &DatabaseInternals::getIgnoreTargets();
      unset($ignoreTargets[$key][$target]);
      $result = Database::getConnection($target, $key);
      if ($id) {
        $this->__pool['all'][$id]['connected'] = TRUE;
        $this->__pool['all'][$id]['status'] = TRUE;
      }
      return $result;
    }
    catch (Exception $e) {
      if ($id) {
        $this->__pool['all'][$id]['connected'] = FALSE;
        $this->__pool['all'][$id]['status'] = $e;
        $target = $this->invalidateConnection($id);
        try {
          return $this->getSafeConnection($target, $key);
        }
        catch (Exception $e) {
          throw $e;
        }
      }
      throw $e;
    }
  }

  /**
   * Get the master connection
   *
   * @return DatabaseConnection
   */
  function getMasterConnection() {
    return DatabaseSafeConnection::create($this, $this->determineMasterTarget())->getConnection();
  }

  /**
   * Get the slave connection
   *
   * @return DatabaseConnection
   */
  function getSlaveConnection($force = FALSE) {
    if (!$force && $this->forceMaster()) {
      return $this->getMasterConnection();
    }
    else {
      return DatabaseSafeConnection::create($this, $this->determineSlaveTarget())->getConnection();
    }
  }

  /**
   * Check if a database target is available
   *
   * @param $target
   *   Database target
   * @param $key
   *   Database key
   *
   * @return boolean
   *   TRUE if target is available.
   */
  public function isTargetAvailable($target) {
    $d = DatabaseInternals::getDatabaseInfo();
    $result = isset($d[$this->getKey()][$target]);
    return $result;
  }

  /**
   * Prepare options array for autoslave determination.
   *
   * @param &$options
   *   Connection options for a query.
   */
  function prepareAutoslaveTarget(&$options) {
    $options += $this->defaultOptions(FALSE);
    if (empty($options['target'])) { 
      $options['target'] = $this->getTarget();
      return FALSE;
    }
    if ($options['target'] == 'slave') {
      // Direct to the autoslave if 'slave' is explicitely chosen.
      $options['target'] = $this->determineSlaveTarget();
    }
    if (!$this->isTargetAvailable($options['target'])) {
      $options['target'] = $this->getTarget();
      return FALSE;
    }
    if ($options['target'] == $this->getTarget()) {
      return FALSE;
    }
    return TRUE;
  }

  /**
   * Get the target for a given query
   */
  function deriveTargetFromQuery($query) {
    switch ($this->deriveBackendFromQuery($query)) {
      case 'master':
        return $this->determineMasterTarget();
      case 'slave':
        return $this->determineSlaveTarget();
      default:
        $this->fatalThrow(new Exception("Unexpected error! No target found for query! This exception should never be thrown!"));
    }
  }

  private function isWriteQuery($query) {
    return preg_match('/^\s*('.
      'UPDATE|INSERT|REPLACE|DELETE|'.
      'ALTER|CREATE|DROP|TRUNCATE|RENAME|'.
      'BEGIN|START\s+TRANSACTION|COMMIT|ROLLBACK|'.
      'RELEASE|SAVEPOINT|'.
      '(.*FOR UPDATE$)|(.*LOCK IN SHARE MODE$)'.
    ')\b/is', $query);
  }

  /**
   * Determine the backend to use based on a query.
   *
   * @param $query
   *   The query to examine.
   */
  private function deriveBackendFromQuery($query, $updated = TRUE) {
    $this->ensureAffectedTables();

    // Find all tables used in the query.
    preg_match_all('@\{(\w+)\}@', $query, $matches);
    $tables = $matches[1] ? array_combine($matches[1], $matches[1]) : array();

    if ($this->isWriteQuery($query)) { 
      // Even if forceMaster() is true, we still need to tag tables that have been written to,
      // in case we go back to forceMaster() false later on.
      if ($updated && $tables) {
        // Only add the first table, since it's not possible to do multi-table insert/update anyways.
        // ... at least not if using ANSI-SQL ... There are engine specific syntax for this though,
        // which is why we provide the "flag all tables" option if necessary.
        if (!$this->connectionOptions['flag all tables']) {
          $tables = array(reset($tables));
        }
        $this->addAffectedTables($tables);
      }
      return 'master';
    }
    elseif ($this->forceMaster()) {
      return 'master';
    }
    else {
      return array_intersect($tables, $this->__tables) ? 'master' : 'slave';
    }
  }

  /**
   * Get the target for a table
   *
   * @param $table
   *   Table to get target for
   * @return string
   *   Target
   */
  public function getTargetForTable($table) {
    $this->ensureAffectedTables();
    if ($this->forceMaster()) {
      return $this->determineMasterTarget();
    }
    elseif (is_string($table)) {
      return isset($this->__tables[$table]) ? $this->determineMasterTarget() : $this->determineSlaveTarget();      
    }
    elseif ($table instanceOf SelectQueryInterface) {
      $tables = $this->findTablesInQuery($table);
      return array_intersect($tables, $this->__tables) ? $this->determineMasterTarget() : $this->determineSlaveTarget();
    }
    else {
      // Don't know what to do ... use master just to be safe.
      return $this->determineMasterTarget();
    }
  }

  /**
   * Get/set force master counter
   *
   * @param $force_master
   *   Number to increase force master counter with
   */
  public function forceMaster($force_master = NULL, $transaction = FALSE) {
    if (isset($force_master)) {
      $this->__force_master += $force_master;
      if ($transaction) {
        $this->__transaction += $force_master;
      }
    }
    return $this->__force_master;
  }

  /**
   * Redeclare the master target as the default target.
   */
  public function hardSwitch() {
    // @todo Revisit this again, since it probably doesn't work anymore ...
    $connection_info = $this->__pool['all'];
    Database::renameConnection('default', 'autoslave_original_default');
    Database::addConnectionInfo('default', 'default', $connection_info[$this->__master]);
  }

  /**
   * Get list of affected tables.
   */
  public function getInternalAffectedTables() {
    return $this->__tables;
  }

  public function getAffectedTables($expires = 0) {
    $tables = $this->__affected_tables_backend->get($expires - $this->getReplicationLag());
    foreach ($tables as &$row) {
      $row['expires'] += $this->getReplicationLag();
    }
    return $tables;
  }

  public function updateAffectedTables($target, $key, $tables, $expires) {
    return $this->__affected_tables_backend->update($target, $key, $tables, $expires);
  }

  function bufferAffectedTable($target, $key, $table, $expires) {
    if (!isset($this->__affected_tables[$key][$target][$table]) || abs($this->__affected_tables[$key][$target][$table]) < $expires) {
      $this->__affected_tables[$key][$target][$table] = -$expires;
    }
  }

  function flushAffectedTables($commit = TRUE) {
    $flushed = array();
    foreach ($this->__affected_tables as $key => $targets) {
      foreach ($targets as $target => $tables) {
        foreach ($tables as $table => $expires) {
          if ($expires < 0) {
            $expires = $this->__affected_tables[$key][$target][$table] = -$expires;
            if (!$commit) {
              // Adjust expiration, in case a new bufferAffectedTable() is called
              $this->__affected_tables[$key][$target][$table]--;
            }
            else {
              $this->max_expires = $this->max_expires < $expires ? $expires : $this->max_expires;
              if ($this->getGlobalReplicationLag()) {
                $flushed[$key][$target][$expires][] = $table;
              }
              else {
                $_SESSION['autoslave_affected_tables'][$key][$target][$table] = $expires;
                $_SESSION['autoslave_affected_tables_version'] = AUTOSLAVE_VERSION;
              }
            }
          }
        }
      }
    }
    
    // Update multiple rows in one statement if possible.
    if ($flushed) {
      foreach ($flushed as $key => $targets) {
        foreach ($targets as $target => $expire) {
          foreach ($expire as $expires => $tables) {
            try {
              $this->updateAffectedTables($target, $key, $tables, $expires);
            }
            catch (Exception $e) {
              // Ignore duplicate key errors on race conditions...
            }
          }
        }
      }
    }

    if ($commit) {
      if ($this->connectionOptions['bypass page cache'] > 0) {
        $_SESSION['bypass_page_cache'] = time() + $this->connectionOptions['bypass page cache'];
      }
    }
    if ($this->transactionalizeWrite(TRUE)) {
      $this->__affected_tables = array();
    }
  }

  /**
   * Add tables to list of affected tables.
   *
   * @param $tables
   *   Array of tables affected by write
   * @param $update_session
   *   Update session with new expiration for replication lag mitigation
   */
  public function addAffectedTables($tables, $update_session = TRUE) {
    // Only session-track tables that are not already on "always-master"
    $tables = array_diff($tables, $this->__master_tables);
    $this->__tables = array_unique(array_merge($this->__tables, $tables));

    $time = microtime(TRUE);
    if ($tables && $update_session) {
      $key = $this->getKey();
      $target = $this->getTarget();
      foreach ($tables as $table) {
        // Reflag tables with timestamp later, if we're inside a transaction.
        $expires = ceil($time);
        $this->bufferAffectedTable($target, $key, $table, $expires);
      }
      if ($this->transactionDepth() == 0) {
        $this->flushAffectedTables(TRUE);
      }
    }
    return $this->__tables;
  }

  /**
   * Add one affected table
   *
   * @param $table
   *   Table affected by write
   * @param $update_session
   *   Update session with new expiration for replication lag mitigation
   */
  public function addAffectedTable($table, $update_session = TRUE) {
    return $this->addAffectedTables(array($table => $table), $update_session);
  }

  function resyncAffectedTables() {
    $this->__setup_global = FALSE;
    $this->ensureAffectedTables();
  }

  /**
   * Ensure that tables affected by write from previous requests are flagged,
   * so that queries for these tables will go to the master.
   */
  function ensureAffectedTables() {
    $key = $this->getKey();

    // Load globally affected tables
    if (!$this->__setup_global) {
      $this->__setup_global = TRUE;

      if ($this->getGlobalReplicationLag()) {
        $tables = array();
        try {
          $tables = $this->getAffectedTables(time());
        }
        catch (Exception $e) {
          // Just ignore error for now
        }
        foreach ($tables as $table) {
          $connection = Database::getConnection($table['db_target'], $table['db_key']);
          $connection->addAffectedTable($table['affected_table'], FALSE);
        }
      }
    }

    // Use connection to master for affected tables within the given assumed lag time interval.
    if (!$this->__setup_session &&
      function_exists('drupal_session_started') &&
      drupal_session_started()
    ) {
      $this->__setup_session = TRUE;

      if (isset($_SESSION['bypass_page_cache']) && $_SESSION['bypass_page_cache'] < $_SERVER['REQUEST_TIME']) {
        unset($_SESSION['bypass_page_cache']);
      }

      if ($this->getGlobalReplicationLag()) {
        $_SESSION['autoslave_affected_tables'] = NULL;
        $_SESSION['autoslave_affected_tables_version'] = NULL;
        unset($_SESSION['autoslave_affected_tables']);
        unset($_SESSION['autoslave_affected_tables_version']);
      }
      elseif (!empty($_SESSION['autoslave_affected_tables'])) {
        // Ensure BC for running sessions.
        $version = isset($_SESSION['autoslave_affected_tables_version']) ? $_SESSION['autoslave_affected_tables_version'] : '1.3';
        if (version_compare($version, '1.3', '<=')) {
          $_SESSION['autoslave_affected_tables'] = array(
            'default' => $_SESSION['autoslave_affected_tables']
          );
          $_SESSION['autoslave_affected_tables_version'] = AUTOSLAVE_VERSION;
        }

        if (isset($_SESSION['autoslave_affected_tables'][$key])) {
          // We use server request time instead of time() for the sake of db's with isolation level snapshots.
          foreach ($_SESSION['autoslave_affected_tables'][$key] as $target => $tables) {
            $connection = Database::getConnection($target, $key);
            if ($connection->driver() != 'autoslave') {
              continue;
            }

            foreach ($tables as $table => $expires) {
              if ($_SERVER['REQUEST_TIME'] <= $expires) {
                $connection->addAffectedTable($table, FALSE);
              }
              else {
                unset($_SESSION['autoslave_affected_tables'][$key][$target][$table]);
              }
            }
            // If no affected tables, remove the variable from session.
            if (empty($_SESSION['autoslave_affected_tables'][$key][$target])) {
              unset($_SESSION['autoslave_affected_tables'][$key][$target]);
            }
          }
          // If no affected tables, remove the variable from session.
          if (empty($_SESSION['autoslave_affected_tables'][$key])) {
            unset($_SESSION['autoslave_affected_tables'][$key]);
          }
        }

        // If no affected tables, remove the variable from session.
        if (empty($_SESSION['autoslave_affected_tables'])) {
          unset($_SESSION['autoslave_affected_tables']);
          unset($_SESSION['autoslave_affected_tables_version']);
        }
      }
    }
  }

  /**
   * weighted_random_simple() from http://w-shadow.com/blog/2008/12/10/fast-weighted-random-choice-in-php/
   * modified by Thomas Gielfeldt to presort by weights.
   * Pick a random item based on weights.
   *
   * @param array $values Array of elements to choose from 
   * @param array $weights An array of weights. Weight must be a positive number.
   * @return mixed Selected element.
   */
  function rand_weighted($values, $weights){
    asort($weights);
    $num = mt_rand(1, array_sum($weights));
    $n = 0;
    foreach ($weights as $i => $weight) {
      $n += $weights[$i];
      if($n >= $num){
        return $values[$i];
      }
    }
    return NULL;
  }

  /**
   * Recursively collect used tables in a SelectQuery.
   *
   * @param SelectQueryInterface $query
   *
   * @return array
   *   Tables present in query.
   */
  function findTablesInQuery($query) {
    $tables = array();
    foreach ($query->getTables() as $tableinfo) {
      if ($tableinfo['table'] instanceOf SelectQueryInterface) {
        $tables = array_merge($tables, $this->findTablesInQuery($tableinfo['table']));
      }
      else {
        $tables[] = $tableinfo['table'];
      }
    }
    return $tables;
  }

}

/**
 * Handle force master for transactions
 */
class DatabaseTransaction_autoslave extends DatabaseTransaction {
  protected $parent;
  private $started;

  public function __construct(DatabaseConnection $connection, $name = NULL) {
    $this->name = $name;
    $this->connection = $connection;
    $this->connection->forceMaster(1, TRUE);
    $this->parent = $this->connection->getMasterConnection()->startTransaction($name);
    $this->started = microtime(TRUE);
  }

  public function __destruct() {
    if ($this->connection->__transactionsRolledBack || $this->parent->rolledBack) {
      // This transaction was rolled back
      $this->connection->flushAffectedTables(FALSE);

      // Do the actual "rollback"
      unset($this->parent);
      $this->connection->forceMaster(-1, TRUE);

      // Now that the transaction has been rolled back, we want to clear the cache buffer
      if (is_callable(array('AutoslaveCache', 'clearBuffers'))) {
        AutoslaveCache::clearBuffers();
      }
    }
    elseif ($this->connection->transactionDepth() <= 1) {
      if ($this->connection->transactionDepth() == 0) {
        // This should never be zero?
        watchdog('autoslave', "Transaction committed when it shouldn't be? @debug", array('@debug' => print_r(debug_backtrace(), TRUE)), WATCHDOG_DEBUG);
      }
      // This transaction was committed 
      $key = $this->connection->getKey();
      $target = $this->connection->getTarget();
      $affected_tables = $this->connection->__affected_tables;
      
      $lag = ceil(microtime(TRUE) - $this->started);

      // We need to check if the array exist, just in case some opened and closed a transaction without
      // performing any write queries.
      if (!empty($affected_tables[$key][$target])) {
        foreach ($affected_tables[$key][$target] as $table => &$expires) {
          // If tables were flagged inside a transaction, update their timestamp to the commit time.
          $new_expires = time() + $lag;
          $this->connection->bufferAffectedTable($target, $key, $table, $new_expires);
        }
      }

      // Make sure affected tables are written to database if necessary.
      $this->connection->flushAffectedTables();

      // Do the actual commit
      unset($this->parent);
      $this->connection->forceMaster(-1, TRUE);

      // Now that the transaction has been committed, we can flush cache buffer.
      if (is_callable(array('AutoslaveCache', 'flushBuffers'))) {
        AutoslaveCache::flushBuffers();
      }

      // In case of database cache, affected tables may have been re-populated.
      // Make sure affected tables are written to database if necessary.
      $this->connection->flushAffectedTables();
    }
    else {
      // Soft commit
      unset($this->parent);
      $this->connection->forceMaster(-1, TRUE);
    }
  }

  public function name() { return $this->parent->name(); }
  public function rollback() { return $this->parent->rollback(); }
}

/**
 * Get access to Database internal properties
 */
class DatabaseInternals extends Database {
  static function &getDatabaseInfo() {
    return self::$databaseInfo;
  }

  static function &getConnections() {
    return self::$connections;
  }

  static function &getIgnoreTargets() {
    return self::$ignoreTargets;
  }
}

class DatabaseSafeConnection {
  private $target;
  private $connection;

  function __construct($connection, $target) {
    $this->connection = $connection;
    $this->target = $target;
  }

  static function create($connection, $target) {
    return new DatabaseSafeConnection($connection, $target);
  }

  function getConnection() {
    try {
      $conn = $this->connection->getSafeConnection($this->target);
      return $conn;
    }
    catch (Exception $e) {
      // @todo Handle nested autoslave connection invalidation.
      throw $e;
    }
  }

  function __call($method, $args) {
    try {
      $conn = $this->getConnection();
      switch ($method) {
        case 'merge': 
        case 'update': 
        case 'truncate': 
        case 'insert': 
          return $conn->$method($args[0], $args[1]);
        case 'select': 
        case 'query':
          return $conn->$method($args[0], $args[1], $args[2]);
        case 'queryRange':
          return $conn->$method($args[0], $args[1], $args[2], $args[3], $args[4]);
        default:
          return call_user_func_array(array($conn, $method), $args);
      }
    }
    catch (Exception $e) {
      // Handle deadlock wrt transactional safe cache.
      // @fixme Too MySQL specific.
      if (strpos($e->getMessage(), 'General error: 1205') !== FALSE) {
        $this->connection->__transactionsRolledBack = TRUE;
      }
      if (strpos($e->getMessage(), 'General error: 1213') !== FALSE) {
        $this->_connection->_transactionsRolledBack = TRUE;
      }
      throw $e;
    }
  }
}


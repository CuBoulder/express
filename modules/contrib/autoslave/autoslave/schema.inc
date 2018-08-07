<?php

/**
 * @file
 * Generic Database schema code.
 */

class DatabaseSchema_autoslave extends DatabaseSchema {
  protected function getPrefixInfo($table = 'default', $add_prefix = TRUE) {
    return $this->connection->getSafeConnection($this->connection->getTargetForTable($table))->schema()->getPrefixInfo($table, $add_prefix);
  }

  function prefixNonTable($table) {
    return $this->connection->getSafeConnection($this->connection->getTargetForTable($table))->schema()->prefixNonTable($table);
  }

  protected function buildTableNameCondition($table_name, $operator = '=', $add_prefix = TRUE) {
    return $this->connection->getSafeConnection($this->connection->getTargetForTable($table))->schema()->buildTableNameCondition($table_name, $operator, $add_prefix);
  }

  public function tableExists($table) {
    return $this->connection->getSafeConnection($this->connection->getTargetForTable($table))->schema()->tableExists($table);
  }

  public function findTables($table_expression) {
    return $this->connection->getMasterConnection()->schema()->findTables($table_expression);
  }

  public function fieldExists($table, $column) {
    return $this->connection->getSafeConnection($this->connection->getTargetForTable($table))->schema()->fieldExists($table, $column);
  }

  public function getFieldTypeMap() {
    return $this->connection->getMasterConnection()->schema()->getFieldTypeMap();
  }

  public function createTable($name, $table) {
    $this->connection->addAffectedTable($name);
    return $this->connection->getMasterConnection()->schema()->createTable($name, $table);
  }

  public function renameTable($table, $new_name) {
    $this->connection->addAffectedTable($table);
    $this->connection->addAffectedTable($new_name);
    return $this->connection->getMasterConnection()->schema()->renameTable($table, $new_name);
  }

  public function dropTable($table) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->dropTable($table);
  }

  public function addField($table, $field, $spec, $keys_new = array()) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->addField($table, $field, $spec, $keys_new);
  }

  public function dropField($table, $field) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->dropField($table, $field);
  }

  public function fieldSetDefault($table, $field, $default) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->fieldSetDefault($table, $field, $default);
  }

  public function fieldSetNoDefault($table, $field) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->fieldSetNoDefault($table, $field);
  }

  public function indexExists($table, $name) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->indexExists($table, $name);
  }

  public function addPrimaryKey($table, $fields) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->addPrimaryKey($table, $fields);
  }

  public function dropPrimaryKey($table) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->dropPrimaryKey($table);
  }

  public function addUniqueKey($table, $name, $fields) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->addUniqueKey($table, $name, $fields);
  }

  public function dropUniqueKey($table, $name) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->dropUniqueKey($table, $name);
  }

  public function addIndex($table, $name, $fields) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->addIndex($table, $name, $fields);
  }

  public function dropIndex($table, $name) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->dropIndex($table, $name);
  }

  public function changeField($table, $field, $field_new, $spec, $keys_new = array()) {
    $this->connection->addAffectedTable($table);
    return $this->connection->getMasterConnection()->schema()->changeField($table, $field, $field_new, $spec, $keys_new);
  }

  protected function createTableSql($name, $table) {
    $schema = $this->connection->getMasterConnection()->schema();
    $method = new ReflectionMethod($schema, 'createTableSql');
    $method->setAccessible(TRUE);
    return $method->invoke($schema, $name, $table);
  }

  public function __call($method, $args) {
    return call_user_func_array(array($this->connection->getMasterConnection()->schema(), $args));
  }
}


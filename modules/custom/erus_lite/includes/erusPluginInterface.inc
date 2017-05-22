<?php
/**
 * @file
 * erusPluginInterface
 */

interface erusPluginInterface {
  /**
   * The One function to rule them all.
   * @param  array $settings Erus settings
   * @return array drupal update status array
   */
  public function process($data);

}

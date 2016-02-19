<?php

/**
 * @file
 * Contains context integration.
 */

/**
 * Implements hook_context_registry().
 */
function backstretch_context_registry() {
  return array(
    'reactions' => array(
      'backstretch' => array(
        'title' => t('Backstretch'),
        'plugin' => 'backstretch',
      ),
    ),
  );
}

/**
 * Implmenets hook_context_plugins().
 */
function backstretch_context_plugins() {
  $plugins = array();

  $plugins['backstretch'] = array(
    'handler' => array(
      'path' => drupal_get_path('module', 'backstretch') . '/plugins',
      'file' => 'backstretch_context_reaction_backstretch.inc',
      'class' => 'backstretch_context_reaction_backstretch',
      'parent' => 'context_reaction',
    ),
  );

  return $plugins;
}

/**
 * Implements hook_context_page_reaction().
 */
function backstretch_context_page_reaction() {
  if ($plugin = context_get_plugin('reaction', 'backstretch')) {
    $plugin->execute();
  }
}

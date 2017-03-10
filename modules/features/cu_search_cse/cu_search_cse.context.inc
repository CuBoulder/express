<?php
/**
 * @file
 * Context reaction for cu_search_cse module.
 */

/**
 * Implements hook_context_default_contexts().
 */
function cu_search_cse_context_default_contexts() {
  $export = array();

  $context = new stdClass();
  $context->disabled = FALSE; /* Edit this to true to make a default context disabled initially */
  $context->api_version = 3;
  $context->name = 'search';
  $context->description = '';
  $context->tag = '';
  $context->conditions = array(
    'path' => array(
      'values' => array(
        'search' => variable_get('cu_search_cse_page', 'search'),
      ),
    ),
  );
  $context->reactions = array(
    'block' => array(
      'blocks' => array(
        'cu_search_cse-cse_content_search_form' => array(
          'module' => 'cu_search_cse',
          'delta' => 'cse_content_search_form',
          'region' => 'content',
          'weight' => '-10',
        ),
        'cu_search_cse-cse_search_results' => array(
          'module' => 'cu_search_cse',
          'delta' => 'cse_search_results',
          'region' => 'content',
          'weight' => '-9',
        ),
      ),
    ),
  );
  $context->condition_mode = 0;
  $export['search'] = $context;

  return $export;
}

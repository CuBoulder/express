<?php

/**
 * Implements hook_context_default_contexts().
 */
function cu_share_context_default_contexts() {
  $export = array();
  $context = new stdClass();
  $context->disabled = FALSE; /* Edit this to true to make a default context disabled initially */
  $context->api_version = 3;
  $context->name = 'social_sharing_links';
  $context->description = 'Decide which pages Social Sharing links should appear on.';
  $context->tag = 'social_sharing_links';
  $context->conditions = array(
    'path' => array(
      'values' => array(
        '~<front>' => '~<front>',
        '*' => '*',
        '~admin' => '~admin',
        '~admin/*' => '~admin/*',
        '~/user' => '~/user',
        '~/user/*' => '~/user/*',
        '~node/*/edit' => '~node/*/edit',
        '~block/*/edit' => '~block/*/edit',
        '~taxonomy/term/*/edit' => '~taxonomy/term/*/edit',
        '~node/*/delete' => '~node/*/delete',
        '~block/*/delete' => '~block/*/delete',
        '~taxonomy/term/*/delete' => '~taxonomy/term/*/delete',
        '~node/*/webform*' => '~node/*/webform*',
        '~node/*/webform-results' => '~node/*/webform-results',
        '~media/browser' => '~media/browser',
        '~node/*/blocks' => '~node/*/blocks',
      ),
    ),
  );
  $context->reactions = array(
    'cu_share' => array(
      'cu_share' => 1,
    ),
  );
  $context->condition_mode = 0;
// Translatables
// Included for use with string extractors like potx.
  t('Decide which pages Social Sharing links should appear on');
  $export['cu_share'] = $context;
  return $export;
}

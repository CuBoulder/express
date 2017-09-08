<?php
/**
 * @file
<<<<<<< HEAD
 * cu_sitewide_required.context.inc
=======
 * cu_sitewide.context.inc
>>>>>>> 942b465... adding pc2tr40fz12bx context to cu_sitewide_required #1516
 */

/**
 * Implements hook_context_default_contexts().
 */
function cu_sitewide_required_context_default_contexts() {
  $export = array();

  $context = new stdClass();
  $context->disabled = FALSE; /* Edit this to true to make a default context disabled initially */
  $context->api_version = 3;
  $context->name = 'pc2tr40fz12bx';
  $context->description = 'Sitewide context - name hashed for security by obscurity.';
  $context->tag = 'locked';
  $context->conditions = array(
<<<<<<< HEAD
    'sitewide_public' => array(
      'values' => array(
        1 => 1,
=======
    'path' => array(
      'values' => array(
        '*' => '*',
        '~admin' => '~admin',
        '~admin/*' => '~admin/*',
        '~user' => '~user',
        '~user/*' => '~user/*',
        '~node/*/edit' => '~node/*/edit',
        '~block/*/edit' => '~block/*/edit',
        '~taxonomy/term/*/edit' => '~taxonomy/term/*/edit',
        '~node/*/delete' => '~node/*/delete',
        '~block/*/delete' => '~block/*/delete',
        '~taxonomy/term/*/delete' => '~taxonomy/term/*/delete',
        '~node/*/webform*' => '~node/*/webform*',
        '~node/*/webform-results' => '~node/*/webform-results',
        '~media/browser/' => '~media/browser',
        '~node/*/blocks' => '~node/*/blocks',
>>>>>>> 942b465... adding pc2tr40fz12bx context to cu_sitewide_required #1516
      ),
    ),
  );
  $context->reactions = array(
    'block' => array(
      'blocks' => array(
<<<<<<< HEAD
        'system-main' => array(
          'module' => 'system',
          'delta' => 'main',
          'region' => 'content',
          'weight' => '0',
        ),
=======
>>>>>>> 942b465... adding pc2tr40fz12bx context to cu_sitewide_required #1516
        'google_appliance-ga_block_search_form' => array(
          'module' => 'google_appliance',
          'delta' => 'ga_block_search_form',
          'region' => 'search_box',
          'weight' => '-10',
        ),
        'system-help' => array(
          'module' => 'system',
          'delta' => 'help',
          'region' => 'help',
          'weight' => '-10',
        ),
<<<<<<< HEAD
=======
        'system-main' => array(
          'module' => 'system',
          'delta' => 'main',
          'region' => 'content',
          'weight' => '0',
        ),
>>>>>>> 942b465... adding pc2tr40fz12bx context to cu_sitewide_required #1516
        'cu_site_info-site_info' => array(
          'module' => 'cu_site_info',
          'delta' => 'site_info',
          'region' => 'site_info',
          'weight' => '0',
        ),
      ),
    ),
  );
  $context->condition_mode = 1;

  // Translatables
  // Included for use with string extractors like potx.
  t('Sitewide context - name hashed for security by obscurity.');
  t('locked');
  $export['pc2tr40fz12bx'] = $context;

  return $export;
}

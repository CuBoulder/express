<?php
/**
 * @file
 * cu_advagg.strongarm.inc
 */

/**
 * Implements hook_strongarm().
 */
function cu_advagg_strongarm() {
  $export = array();

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_admin_mode';
  $strongarm->value = '4';
  $export['advagg_admin_mode'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_ajax_render_alter';
  $strongarm->value = 1;
  $export['advagg_ajax_render_alter'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_brotli';
  $strongarm->value = FALSE;
  $export['advagg_brotli'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_cache_level';
  $strongarm->value = '3';
  $export['advagg_cache_level'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_combine_css_media';
  $strongarm->value = 1;
  $export['advagg_combine_css_media'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_convert_absolute_to_protocol_relative_path';
  $strongarm->value = 1;
  $export['advagg_convert_absolute_to_protocol_relative_path'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_convert_absolute_to_relative_path';
  $strongarm->value = 1;
  $export['advagg_convert_absolute_to_relative_path'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_core_groups';
  $strongarm->value = 0;
  $export['advagg_core_groups'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_cron_frequency';
  $strongarm->value = '82800';
  $export['advagg_cron_frequency'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_css_absolute_path';
  $strongarm->value = 0;
  $export['advagg_css_absolute_path'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_css_fix_type';
  $strongarm->value = 1;
  $export['advagg_css_fix_type'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_css_remove_empty_files';
  $strongarm->value = 1;
  $export['advagg_css_remove_empty_files'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_disable_on_admin';
  $strongarm->value = 0;
  $export['advagg_disable_on_admin'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_disable_on_listed_pages';
  $strongarm->value = '';
  $export['advagg_disable_on_listed_pages'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_enabled';
  $strongarm->value = 1;
  $export['advagg_enabled'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_force_https_path';
  $strongarm->value = 0;
  $export['advagg_force_https_path'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_gzip';
  $strongarm->value = 1;
  $export['advagg_gzip'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_htaccess_symlinksifownermatch';
  $strongarm->value = 0;
  $export['advagg_htaccess_symlinksifownermatch'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_ie_css_selector_limiter';
  $strongarm->value = 0;
  $export['advagg_ie_css_selector_limiter'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_ie_css_selector_limiter_value';
  $strongarm->value = 4095;
  $export['advagg_ie_css_selector_limiter_value'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_include_base_url';
  $strongarm->value = 1;
  $export['advagg_include_base_url'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_js_fix_type';
  $strongarm->value = 1;
  $export['advagg_js_fix_type'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_js_remove_empty_files';
  $strongarm->value = 1;
  $export['advagg_js_remove_empty_files'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_remove_missing_files_from_db_time';
  $strongarm->value = '1209600';
  $export['advagg_remove_missing_files_from_db_time'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_remove_old_unused_aggregates_time';
  $strongarm->value = '3888000';
  $export['advagg_remove_old_unused_aggregates_time'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_dns_prefetch';
  $strongarm->value = 1;
  $export['advagg_resource_hints_dns_prefetch'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_location';
  $strongarm->value = '1';
  $export['advagg_resource_hints_location'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_preconnect';
  $strongarm->value = 1;
  $export['advagg_resource_hints_preconnect'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_preload';
  $strongarm->value = 0;
  $export['advagg_resource_hints_preload'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_preload_settings';
  $strongarm->value = array(
    'style' => array(
      '#weight' => '-10',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
    'font' => array(
      '#weight' => '-9',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
    'script' => array(
      '#weight' => '-8',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
    'svg' => array(
      '#weight' => '-7',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
    'image' => array(
      '#weight' => '-6',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
    'all_others' => array(
      '#weight' => '-5',
      'enabled' => 1,
      'external' => 1,
      'local' => 1,
      'push' => 0,
    ),
  );
  $export['advagg_resource_hints_preload_settings'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_resource_hints_use_immutable';
  $strongarm->value = 1;
  $export['advagg_resource_hints_use_immutable'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_scripts_scope_anywhere';
  $strongarm->value = 0;
  $export['advagg_scripts_scope_anywhere'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_skip_file_create_url_inside_css';
  $strongarm->value = 1;
  $export['advagg_skip_file_create_url_inside_css'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'advagg_use_httprl';
  $strongarm->value = 1;
  $export['advagg_use_httprl'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'cache_flush_cache_advagg_aggregates';
  $strongarm->value = 1549044254;
  $export['cache_flush_cache_advagg_aggregates'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'cache_flush_cache_advagg_info';
  $strongarm->value = 1549043659;
  $export['cache_flush_cache_advagg_info'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_background_callback';
  $strongarm->value = 1;
  $export['httprl_background_callback'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_connect_timeout';
  $strongarm->value = '5';
  $export['httprl_connect_timeout'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_dns_timeout';
  $strongarm->value = '5';
  $export['httprl_dns_timeout'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_global_timeout';
  $strongarm->value = '120';
  $export['httprl_global_timeout'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_non_blocking_fclose_delay';
  $strongarm->value = '0';
  $export['httprl_non_blocking_fclose_delay'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_server_addr';
  $strongarm->value = '-1';
  $export['httprl_server_addr'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_server_hostname';
  $strongarm->value = 'express.local';
  $export['httprl_server_hostname'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_server_port';
  $strongarm->value = '';
  $export['httprl_server_port'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_server_schema';
  $strongarm->value = '2';
  $export['httprl_server_schema'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_timeout';
  $strongarm->value = '30';
  $export['httprl_timeout'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'httprl_ttfb_timeout';
  $strongarm->value = '20';
  $export['httprl_ttfb_timeout'] = $strongarm;

  return $export;
}

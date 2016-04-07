<?php

/**
 * Implements hook_express_dashboard().
 */
function hook_express_dashboard($variables) {
  $variables['user'] = array(
    'title' => 'User Dashboard',
    'callback' => 'express_dashboard_user_content',
    'weight' => -99,
    'access arguments' => array('use user dashboard'),
  );
  $variables['seo'] = array(
    'title' => 'SEO Dashboard',
    'callback' => 'express_dashboard_user_content',
    'access arguments' => array('use seo dashboard'),
  );
  return $variables;
}

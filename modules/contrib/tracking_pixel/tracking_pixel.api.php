<?php

/**
 * @file
 * API hooks for the Tracking Pixel module.
 */

/**
 * Add your custom tracking pixels.
 *
 * array $custom_pixel
 *   - label: The human-readable name of your tracking pixel.
 *   - options: These keys will be rendered in the tracking pixel template.
 *       The value is the description shown to the user on tracking pixel creation.
 *   - custom_template: You need to enter the full path to your template file.
 *
 * @return array
 */
function hook_tracking_pixel_add_custom() {
  $custom_pixels = array();

  $custom_pixels['my_pixel'] = array(
    'label' => 'My Pixel',
    'options' => array(
      'id' => 'The ID of tracking pixel.',
      'action' => 'Activity being tracked, e.g. "Pageview". If more than one action, place in comma separated list.',
    ),
    'custom_template' => NULL,
  );

  return $custom_pixels;
}

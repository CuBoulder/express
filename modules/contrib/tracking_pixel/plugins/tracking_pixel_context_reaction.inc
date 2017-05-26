<?php

/**
 * @file
 * Contains code for tracking_pixel context reaction.
 */

/**
 * Class tracking_pixel_context_reaction.
 */
class tracking_pixel_context_reaction extends context_reaction {

  /**
   * Provide form to enter tracking pixels.
   *
   * @param $context
   * @return array
   */
  function options_form($context) {
    return array(
      'tracking_pixels' => array(
        '#type' => 'select',
        '#options' => $this->getPixels(),
        '#title' => t('Tracking Pixels'),
        '#description' => t('Select the tracking pixels you wish to appear on selected pages.'),
      ),
    );
  }

  /**
   * Capture selected tracking pixels to send to execute function.
   *
   * @param $values
   * @return array
   */
  function options_form_submit($values) {
    return array('tracking_pixels' => $values['tracking_pixels']);
  }

  /**
   * Add pixel code to page.
   *
   * @return array
   */
  function execute() {
    foreach ($this->get_contexts() as $context) {
      if (!empty($context->reactions[$this->plugin])) {

        $id = $context->reactions[$this->plugin]['tracking_pixels'];
        $pixel = entity_load_single('tracking_pixel', $id);

        $js = _tracking_pixel_get_js($pixel);
        drupal_add_js($js, array(
          'type' => 'inline',
          'scope' => $pixel->position,
        ));
      }
    }
    return array();
  }

  /**
   * Get all published pixels and return as select list options.
   *
   * @return array
   */
  function getPixels() {
    $options = array();

    // Get published pixel names.
    $names = db_select('tracking_pixel', 'tp')
      ->fields('tp')
      ->condition('status', 1, '=')
      ->execute()
      ->fetchallAssoc('name');

    // Return names for select list.
    if ($names) {
      foreach ($names as $name) {
        $options[$name->id] = $name->name;
      }
      return $options;
    }

    // Return no options if no published pixels.
    return $options;
  }
}

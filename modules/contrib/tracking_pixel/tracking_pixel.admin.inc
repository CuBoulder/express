<?php

/**
 * @file
 * Form functions for tracking_pixels module.
 */

/**
 * A listing of tracking pixels.
 *
 * @param array $form
 * @param array $form_state
 * @return array
 */
function tracking_pixels_overview_form($form, &$form_state) {
  // If set to delete pixels, then return confirmation form.
  if (isset($form_state['storage']['confirm'])) {
    // Hacky way to get action link to not display...I hate myself.
    drupal_add_css('ul.action-links {display: none;}', array('type' => 'inline'));
    return tracking_pixel_confirm($form, $form_state);
  }

  // Initialize form array.
  $form = array();

  // Set title since it doesn't stick.
  drupal_set_title('Tracking Pixels');

  // If search has been performed, then return pixels from the search.
  if (isset($form_state['storage']['search_pixels'])) {
    $tracking_pixels = $form_state['storage']['search_pixels'];
  } else {
    // Get existing tracking pixels.
    $tracking_pixels = tracking_pixel_get_pixels();
  }

  // Build table only if tracking pixels exist.
  if (!empty($tracking_pixels)) {

    // Place tracking pixels in $form_state for submission processing.
    $form_state['tracking_pixels'] = $tracking_pixels;

    // Add search fieldset.
    $form['search'] = array(
      '#type' => 'fieldset',
      '#title' => 'Search',
    );

    // Search by tracking pixel name.
    $form['search']['name'] = array(
      '#title' => t('Tracking Pixel Name'),
      '#description' => t('Search for tracking pixel by name.'),
      '#type' => 'textfield',
      '#default_value' => isset($form_state['storage']['search_name']) ? $form_state['storage']['search_name'] : '',
    );

    // Search by path.
    $form['search']['path'] = array(
      '#title' => t('Tracking Pixel Path'),
      '#description' => t('Search for tracking pixel by path alias.'),
      '#type' => 'textfield',
      '#default_value' => isset($form_state['storage']['search_path']) ? $form_state['storage']['search_path'] : '',
    );

    $form['search']['search'] = array(
      '#type' => 'submit',
      '#value' => t('Search'),
      '#submit' => array('tracking_pixels_overview_form_submit'),
    );

    // Add container for operations functionality.
    $form['operations'] = array(
      '#type' => 'fieldset',
      '#title' => 'Operations',
    );

    // Add select list for choosing operations.
    $select_options = array(
      'unpublish' => 'Unpublish Tracking Pixels',
      'publish' => 'Publish Tracking Pixels',
      'delete' => 'Delete Tracking Pixels',
    );

    $form['operations']['select'] = array(
      '#type' => 'select',
      '#options' => $select_options,
      '#default_value' => $select_options['unpublish'],
    );

    // Add submit button for operations.
    $form['operations']['submit'] = array(
      '#type' => 'submit',
      '#value' => t('Submit'),
    );

    // Add table for listing tracking pixels.
    $headers = array(
      'id' => t('ID'),
      'name' => t('Name'),
      'type' => t('Type'),
      'path' => t('Path'),
      'status' => t('Status'),
      'edit' => t('Edit'),
    );

    $rows = array();
    foreach ($tracking_pixels as $result) {
      $status = $result->status == 1 ? 'Published' : 'Unpublished';
      $edit_link = l(t('Edit'), 'admin/content/trackingpixels/edit/' . $result->id);

      $rows[] = array(
        'id' => $result->id,
        'name' => $result->name,
        'type' => $result->type,
        'path' => l(drupal_get_path_alias($result->path), $result->path),
        'status' => $status,
        'edit' => $edit_link,
      );
    }

    $form['table'] = array(
      '#type' => 'tableselect',
      '#header' => $headers,
      '#options' => $rows,
      '#suffix' => empty($rows) ? 'No pending invites.' : '',
      '#weight' => 10,
    );

    $form['pager'] = array(
      '#theme' => 'pager',
      '#weight' => 11,
    );
  }
  else {
    drupal_set_message(t('No tracking pixels exist. You can create one by clicking the action link below.'), 'warning');
  }
  return $form;
}

/**
 * Form submission for tracking pixel overview form.
 *
 * @param $form
 * @param $form_state
 *
 * @return mixed
 */
function tracking_pixels_overview_form_submit(&$form, &$form_state) {

  // If input for search, then pass to search function.
  if ($form_state['values']['op'] == 'Search') {
    $name = !empty($form_state['values']['name']) ? $form_state['values']['name'] : NULL;
    $path = !empty($form_state['values']['path']) ? $form_state['values']['path'] : NULL;

    if ($name || $path) {
      return tracking_pixel_form_search($form_state, $name, $path);
    } else {
      drupal_set_message('No search terms entered.', 'error');
      return '';
    }
  }


  // Make sure to make the user confirm they want to proceed with bulk operation.
  if (!isset($form_state['storage']['confirm'])) {
    // @todo Don't put in whole form_state array since it adds recursively.
    $form_state['storage']['form_state'] = $form_state;
    $form_state['storage']['form'] = $form;
    // This will cause the form to be rebuilt returning to the confirm part of the form.
    $form_state['storage']['confirm'] = TRUE;
    $form_state['rebuild'] = TRUE;
    return $form_state;
  }

  // Perform bulk operation on entities stored in $form_state from confirmation function.
  switch ($form_state['values']['op']) {
    case 'Unpublish':
      foreach ($form_state['tracking_pixels'] as $pixel) {
        $pixel->status = 0;
        entity_save('tracking_pixel', $pixel);
      }
      break;
    case 'Publish':
      foreach ($form_state['tracking_pixels'] as $pixel) {
        $pixel->status = 1;
        entity_save('tracking_pixel', $pixel);
      }
      break;
    case 'Delete':
      foreach ($form_state['tracking_pixels'] as $pixel) {
        entity_delete('tracking_pixel', $pixel->id);
      }
      break;
  }
}

/**
 * Callback for searching for tracking pixels from overview page.
 *
 * @param $form
 * @param $form_state
 */
function tracking_pixel_form_search(&$form_state, $name = NULL, $path = NULL) {

  // Need to combine name and path search into one.
  $or = db_or();
  if ($name != NULL) {
    $or->condition('tp.name', '%' . db_like($name) . '%', 'LIKE');
  }

  // Finding system paths is a little more difficult.
  // May need to add conditions for other alias tables.
  if ($path != NULL && $path != false) {
    $path_results = db_select('url_alias', 'al')
      ->fields('al', array('source'))
      ->condition('al.alias', '%' . db_like($path) . '%', 'LIKE')
      ->execute()
      ->fetchCol();

    if ($path_results != false) {
      foreach ($path_results as $system_path) {
        $or->condition('tp.path', '%' . db_like($system_path) . '%', 'LIKE');
      }
    }
  }

  // Search for tracking pixels based on paths and names.
  $results = db_select('tracking_pixel', 'tp')
    ->fields('tp')
    ->condition($or)
    ->execute()
    ->fetchAllAssoc('id');

  // Load tracking pixels to send back to form.
  if ($results) {
    $tracking_pixels = entity_load('tracking_pixel', array_keys($results));
    $form_state['storage']['search_pixels'] = $tracking_pixels;
    $form_state['storage']['search_path'] = $path;
    $form_state['storage']['search_name'] = $name;
    $form_state['rebuild'] = TRUE;
  }

  return $form_state;
}

/**
 * Form for adding tracking pixels.
 *
 * @param $form
 * @param $form_state
 * @param null $tracking_pixel_id
 *
 * @return array
 */
function tracking_pixel_form($form, &$form_state, $tracking_pixel_id = NULL) {
  // If set to delete pixels, then return that form.
  if (isset($form_state['storage']['confirm'])) {
    return tracking_pixel_confirm($form, $form_state);
  }

  // Initialize default form variables.
  $form = array();
  $label = $path = '';
  $position = 'footer';
  $status = 1;
  $type = 0;
  $data = array();

  // Load tracking pixel if it exists.
  if ($tracking_pixel_id != NULL && $tracking_pixel = entity_load_single('tracking_pixel', $tracking_pixel_id)) {
    // Grab existing values to place in form.
    $label = $tracking_pixel->name;
    $path = $tracking_pixel->path;
    $position = $tracking_pixel->position;
    $status = $tracking_pixel->status;
    $type = $tracking_pixel->type;
    $data = unserialize($tracking_pixel->data);

    // Store tracking pixel in form for form submission processing.
    $form_state['tracking_pixels'] = $tracking_pixel;

    // @todo Deal with tracking pixel entity not loading?
  }

  $form['pixel'] = array(
    '#type' => 'fieldset',
    '#title' => t('Tracking Pixel'),
    '#weight' => 9,
  );

  $form['pixel']['label'] = array(
    '#title' => t('Label'),
    '#description' => t('Administrative label used in overview screen.'),
    '#type' => 'textfield',
    '#default_value' => $label,
  );

  // Search field for existing paths.
  $form['pixel']['path'] = array(
    '#title' => t('Path'),
    '#description' => 'The page you will add the tracking pixel to. To add pixels to multiple pages, please leave blank and use the Context module.',
    '#type' => 'textfield',
    '#autocomplete_path' => 'titles/autocomplete',
    '#default_value' => $path,
  );

  // Get pixel type names for select list.
  $pixel_types = tracking_pixel_get_pixel_types();
  $pixel_options = array_map(function ($a) {
    return $a['label'];
  }, $pixel_types);

  // Add custom option if user has permission.
  if (user_access('create custom tracking pixels')) {
    $pixel_options = array_merge($pixel_options, array('custom' => 'Custom'));
  }

  $form['pixel']['types'] = array(
    '#title' => t('Type'),
    '#type' => 'select',
    '#options' => $pixel_options,
    '#description' => t('Choose the type of tracking pixel you wish to create.'),
    '#default_value' => $type,
  );

  // Add specific options for types.
  foreach ($pixel_types as $key => $item) {

    // Create text fields from keys.
    $options = array();
    foreach ($item['options'] as $title => $description) {
      $options[$key . '_' . $title] = array(
        '#title' => t($title),
        '#description' => t($description),
        '#type' => 'textfield',
        '#default_value' => isset($data[$key]) ? $data[$key][$key . '_' . $title] : '',
      );
    }

    $form['pixel'][$key] = array(
      '#type' => 'fieldset',
      '#title' => t('Options'),
      '#states' => array(
        'visible' => array(
          ':input[name="types"]' => array('value' => $key),
        ),
      ),
    );
    $form['pixel'][$key]['options'] = $options;
  }

  // Add custom option if user has permission.
  if (user_access('create custom tracking pixels')) {
    $form['pixel']['custom'] = array(
      '#type' => 'fieldset',
      '#title' => t('Options'),
      '#states' => array(
        'visible' => array(
          ':input[name="types"]' => array('value' => 'custom'),
        ),
      ),
    );

    $form['pixel']['custom']['code'] = array(
      '#title' => t('Tracking pixel code'),
      '#description' => t('Enter custom tracking pixel code.'),
      '#type' => 'textarea',
      '#default_value' => isset($data['custom']['code']) ? $data['custom']['code'] : '',
    );
  }

  // Add positioning options.
  $form['settings'] = array(
    '#type' => 'fieldset',
    '#title' => t('Settings'),
    '#weight' => 10,
  );
  $position_options = array(
    'top' => 'Top',
    'bottom' => 'Bottom',
  );
  $form['settings']['position'] = array(
    '#title' => t('Location'),
    '#type' => 'select',
    '#options' => $position_options,
    '#description' => t('Choose where on the page the pixel is placed. Look at the tracking pixel instructions to determine where it should be placed.'),
    '#default_value' => $position,
  );

  // Add options for publishing.
  $form['publish_settings'] = array(
    '#type' => 'fieldset',
    '#title' => t('Publishing Options'),
    '#weight' => 11,
  );
  $form['publish_settings']['status'] = array(
    '#title' => t('Published'),
    '#type' => 'checkbox',
    '#default_value' => $status,
  );

  // Add options for save and cancel.
  $form['actions'] = array(
    '#type' => 'actions',
    'submit' => array(
      '#type' => 'submit',
      '#value' => t('Save'),
    ),
  );
  $form['actions']['cancel'] = array(
    '#type' => 'submit',
    '#value' => t('Cancel'),
    '#submit' => array('trackingpixel_form_cancel'),
    '#limit_validation_errors' => array(),
  );

  // Add delete button only if editing a tracking pixel.
  if (isset($tracking_pixel)) {
    $form['actions']['delete'] = array(
      '#type' => 'submit',
      '#submit' => array('tracking_pixel_form_submit'),
      '#value' => t('Delete'),
    );
  }

  return $form;
}

/**
 * Submit function for adding or editing a tracking pixel.
 *
 * @param $form
 * @param $form_state
 *
 * @return mixed
 */
function tracking_pixel_form_submit(&$form, &$form_state) {

  // If the user has chosen the delete operation, then try to delete tracking pixel.
  // Otherwise, go about trying to save tracking pixel information.
  if ($form_state['input']['op'] == 'Delete') {
    // If the user hasn't confirmed, they want to delete items, send them to confirm form.
    if (!isset($form_state['storage']['confirm'])) {
      // @todo Don't have recursive $form_state. Probably only store part of the array I need.
      $form_state['storage']['form_state'] = $form_state;
      $form_state['storage']['form'] = $form;
      // This will cause the form to be rebuilt returning to the confirm part of the form.
      $form_state['storage']['confirm'] = TRUE;
      $form_state['rebuild'] = TRUE;
      return $form_state;
    }
    else {
      // Finally delete tracking pixel and redirect to the tracking pixel overview form.
      entity_delete('tracking_pixel', $form_state['tracking_pixels']->id);
      $form_state['redirect'] = 'admin/content/trackingpixels';
    }
  }
  else {


    // Build data array for serialization by grabbing form values for pixel type.
    $type = $form_state['values']['types'];
    $data = array();
    foreach ($form_state['values'] as $key => $value) {
      if (strpos($key, $type . '_') === 0) {
        $data[$type][$key] = $value;
      }
    }

    // Account for custom tracking pixel code.
    if (!empty($form_state['values']['code'])) {
      $data['custom']['code'] = $form_state['values']['code'];
    }

    // Account for pixels with no paths. Used for Context.
    $path = !empty($form_state['values']['path']) ? $form_state['values']['path'] : '<none>';

    // If editing a tracking pixel, add data to existing pixel object.
    // Otherwise, make a new tracking pixel entity.
    if (isset($form_state['tracking_pixels']->id)) {
      $tracking_pixel = $form_state['tracking_pixels'];
      $tracking_pixel->name = $form_state['values']['label'];
      $tracking_pixel->path = $path;
      $tracking_pixel->type = $type;
      $tracking_pixel->position = $form_state['values']['position'];
      $tracking_pixel->status = $form_state['values']['status'];
      $tracking_pixel->data = serialize($data);
    }
    else {
      $values = array(
        'name' => $form_state['values']['label'],
        'path' => $path,
        'type' => $type,
        'position' => $form_state['values']['position'],
        'status' => $form_state['values']['status'],
        'data' => serialize($data),
      );
      $tracking_pixel = entity_create('tracking_pixel', $values);
    }

    // Redirect to overview page if successful.
    // Otherwise, show error to user.
    $success = $tracking_pixel->save();
    if ($success) {
      $form_state['redirect'] = 'admin/content/trackingpixels';
    }
    else {
      drupal_set_message('Tracking pixel could not be saved. Please try again.', 'error');
    }
  }
}

/**
 * Callback for canceling addition of tracking pixels.
 *
 * @param $form
 * @param $form_state
 */
function trackingpixel_form_cancel($form, &$form_state) {
  $form_state['redirect'] = 'admin/content/trackingpixels';
}

/**
 * Form callback for confirming operations performed on tracking pixel entities.
 *
 * @param $form
 * @param $form_state
 *
 * @return array|mixed|null
 */
function tracking_pixel_confirm(&$form, &$form_state) {
  // Initialize default variables.
  $path = 'admin/content/trackingpixels';
  $form = array();
  // The operation key differs depending on whether coming from edit or overview form.
  $op = isset($form_state['input']['select']) ? ucfirst($form_state['input']['select']) : ucfirst($form_state['input']['op']);

  // Make sure there are tracking pixels to operation on.
  if (isset($form_state['tracking_pixels'])) {
    // If only one tracking pixel...
    if (isset($form_state['tracking_pixels']->name)) {
      $pixel_names = array($form_state['tracking_pixels']->name);
    }
    else {
      // For multiple pixels, we need to match array key positions with tracking pixel IDs.
      $table_options = $form_state['storage']['form']['table']['#options'];
      $selected_options = $form_state['storage']['form_state']['input']['table'];

      // Loop through selected rows and add pixel name.
      $pixel_names = array();
      foreach ($selected_options as $key => $option) {
        if ($option != NULL) {
          $pixel_names[] = $table_options[$key]['name'];
        }
        else {
          // Replace tracking pixels in form_state array with selected tracking pixels.
          unset($form_state['tracking_pixels'][$table_options[$key]['id']]);
        }
      }
    }

    // Build confirm form that is sent back to user.
    $list = theme_item_list(array(
      'items' => $pixel_names,
      'title' => NULL,
      'type' => 'ul',
      'attributes' => array()
    ));

    return confirm_form(
      $form,
      t('Do you really want to !op the following tracking pixels?', array('!op' => $op)),
      $path,
      $list,
      $op,
      'Cancel'
    );
  }

  // Account for the case where somehow no tracking pixel entities made it to the confirm function.
  return drupal_set_message(t('No tracking pixels selected for operations. Please take appropriate action from the !link.', array('!link' => l('tracking pixel overview page', $path))), 'error');
}

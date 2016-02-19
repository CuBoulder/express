<?php

/**
 * @file
 * Backstretch reaction class for Context integration.
 */

class backstretch_context_reaction_backstretch extends context_reaction {
  function options_form($context) {
    // Fetching saved values.
    $values = $this->fetch_from_context($context);
    $form = array();

    $form['source'] = array(
      '#type' => 'fieldset',
      '#title' => t('Source'),
    );

    $sources = array(
      'entity' => t('Entity'),
      'path' => t('Path'),
    );

    $form['source']['type'] = array(
      '#type' => 'select',
      '#title' => t('Type'),
      '#options' => $sources,
      '#default_value' => isset($values['source']) ? $values['source'] : '',
    );

    // Getting all entity types.
    $entities = entity_get_info();
    $entity_types = array();

    // Iterate all entity types and prepare an array with entity type
    // and their label.
    foreach ($entities as $entity => $entity_info) {
      $entity_types[$entity] = $entity_info['label'];
    }

    // Getting all field instances.
    $field_instances = field_info_instances();
    $image_fields = array();

    // Prepare an array with all image fields and their label.
    foreach ($field_instances as $entity_type => $bundles) {
      foreach ($bundles as $bundle_name => $fields) {
        foreach ($fields as $field_name => $field_info) {
          $info = field_info_field($field_name);
          if ($info['type'] != 'image') {
            continue;
          }

          $field_entity_types = array_keys($info['bundles']);
          foreach ($field_entity_types as $field_entity_type) {
            $image_fields[$field_entity_type][$field_name] = $field_info['label'];
          }
        }
      }
    }

    $form['source']['entity']['entity_type'] = array(
      '#type' => 'select',
      '#title' => t('Entity type'),
      '#options' => $entity_types,
      '#default_value' => isset($values['source']['entity']['entity_type']) ? $values['source']['entity']['entity_type'] : '',
      '#empty_option' => t('Select entity type'),
      '#states' => array(
        'visible' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
        ),
        'required' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
        ),
      ),
    );

    foreach ($entity_types as $entity_type => $entity_type_name) {
      // We can skip the file entity type because it has no extra field
      // for an image, the file ID is enough.
      if ($entity_type == 'file') {
        continue;
      }
      // Display a message to the user if the selected entity type has
      // no image fields.
      elseif (!isset($image_fields[$entity_type])) {
        $form['source']['entity'][$entity_type]['field'] = array(
          '#type' => 'item',
          '#markup' => '<div class="messages warning">' . t("No image fields were found for entity type %entity-type. Please add an image field first otherwise you won't see a Backstretch.", array('%entity-type' => $entity_type_name)) . '</div>',
          '#states' => array(
            'visible' => array(
              ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
              ':input[name$="[backstretch][source][entity][entity_type]"]' => array('value' => $entity_type),
            ),
          ),
        );
        continue;
      }

      $form['source']['entity'][$entity_type]['field'] = array(
        '#type' => 'select',
        '#title' => t('Image field'),
        '#options' => $image_fields[$entity_type],
        '#default_value' => isset($values['source']['entity']['field']) ? $values['source']['entity']['field'] : '',
        '#description' => t('Select the image field which holds the image(s). Note that all image fields are listed here.'),
        '#states' => array(
          'visible' => array(
            ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
            ':input[name$="[backstretch][source][entity][entity_type]"]' => array('value' => $entity_type),
          ),
          'required' => array(
            ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
          ),
        ),
      );
    }

    $entity_ids_description = array(t('Enter comma-seperated entity IDs (e.g. 1,2,3).'));

    // If entity type and entity id is available, we can display the entity
    // label as description for entity ID field.
    if (isset($values['source']['entity']['entity_type']) && $values['source']['entity']['entity_type'] && isset($values['source']['entity']['ids']) && $values['source']['entity']['ids']) {
      $entity_type = $values['source']['entity']['entity_type'];
      $entity_ids = $values['source']['entity']['ids'];
      $entity_ids = explode(',', $entity_ids);

      $entities = entity_load($entity_type, $entity_ids);

      foreach ($entities as $entity) {
        list($id, $vid, $bundle) = entity_extract_ids($entity_type, $entity);
        $label = entity_label($entity_type, $entity);
        $entity_ids_description[] = t('@label (@id)', array('@label' => $label, '@id' => $id));
      }

    }

    $entity_ids_description = implode('<br />', $entity_ids_description);

    $form['source']['entity']['ids'] = array(
      '#type' => 'textfield',
      '#title' => t('Entity ID'),
      '#default_value' => isset($values['source']['entity']['ids']) ? $values['source']['entity']['ids'] : '',
      '#description' => $entity_ids_description,
      '#states' => array(
        'visible' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
          ':input[name$="[backstretch][source][entity][entity_type]"]' => array('!value' => ''),
        ),
        'required' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'entity'),
        ),
      ),
      // @TODO: Add element_validate for comma seperated IDs.
    );

    $form['source']['path'] = array(
      '#type' => 'textarea',
      '#title' => t('Path'),
      '#default_value' => isset($values['source']['path']) ? $values['source']['path'] : '',
      '#description' => t('Enter one path per line. It can be relative to Drupal root or absolute.'),
      '#states' => array(
        'visible' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'path'),
        ),
        'required' => array(
          ':input[name$="[backstretch][source][type]"]' => array('value' => 'path'),
        ),
      ),
    );

    $image_styles = image_style_options(FALSE);
    $form['image_style'] = array(
      '#title' => t('Image style'),
      '#type' => 'select',
      '#default_value' => isset($values['image_style']) ? $values['image_style'] : '',
      '#options' => $image_styles,
      '#empty_option' => t('None (original image)'),
      '#description' => t('Image style for the images.'),
    );

    $form['element'] = array(
      '#type' => 'select',
      '#title' => t('Attach to'),
      '#default_value' => isset($values['element']) ? $values['element'] : '',
      '#options' => array(
        'other' => t('Other element'),
      ),
      '#empty_option' => t('Whole page'),
      '#description' => t('Where the Backstretch should be attached to.'),
    );

    $form['element_other'] = array(
      '#type' => 'textfield',
      '#title' => t('Other element'),
      '#default_value' => isset($values['element_other']) ? $values['element_other'] : '',
      '#description' => t('Enter the CSS selector for the element.'),
      '#states' => array(
        'visible' => array(
          ':input[name$="[element]"]' => array('value' => 'other'),
        ),
      ),
    );

    /*
     * We have to figure out which tokens should be supported because in the
     * Context reaction you can also use a path to the image so let us discuss
     * this in https://drupal.org/node/2140009.

    $form['tokens'] = array(
      '#type' => 'container',
      '#theme' => 'token_tree',
      '#token_types' => array($entity_type),
      '#dialog' => TRUE,
      '#states' => array(
        'visible' => array(
          ':input[name$="[element]"]' => array('value' => 'other'),
        ),
      ),
    );*/

    $form['duration'] = array(
      '#type' => 'textfield',
      '#title' => t('Duration'),
      '#default_value' => isset($values['duration']) ? $values['duration'] : 5000,
      '#description' => t('Amount of time in between slides.'),
      '#size' => 10,
      '#field_suffix' => 'ms',
      '#element_validate' => array('element_validate_integer_positive'),
    );

    $form['fade'] = array(
      '#type' => 'textfield',
      '#title' => t('Fade'),
      '#default_value' => isset($values['fade']) ? $values['fade'] : 0,
      '#description' => t('Speed of fade transition between slides.'),
      '#size' => 10,
      '#field_suffix' => 'ms',
      '#element_validate' => array('backstretch_element_validate_duration'),
    );

    $form['center_x'] = array(
      '#type' => 'checkbox',
      '#title' => t('Horizontal centered'),
      '#default_value' => isset($values['center_x']) ? $values['center_x'] : TRUE,
      '#description' => t('Should we center the image on the X axis?'),
    );

    $form['center_y'] = array(
      '#type' => 'checkbox',
      '#title' => t('Vertically centered'),
      '#default_value' => isset($values['center_y']) ? $values['center_y'] : TRUE,
      '#description' => t('Should we center the image on the Y axis?'),
    );

    $form['random'] = array(
      '#type' => 'checkbox',
      '#title' => t('Random'),
      '#default_value' => isset($values['random']) ? $values['random'] : FALSE,
      '#description' => t('Check when a random image should be displayed instead of a slideshow.'),
    );

    return $form;
  }

  function options_form_submit($values) {
    // Modify settings if entity was selected as source.
    if ($values['source']['type'] == 'entity') {
      $entity_type = $values['source']['entity']['entity_type'];
      // Move the field setting for non file entity types.
      if ($entity_type != 'file') {
        $values['source']['entity']['field'] = $values['source']['entity'][$entity_type]['field'];
      }
      // Remove all unnecessary settings from the values.
      foreach ($values['source']['entity'] as $key => $value) {
        if (!in_array($key , array('entity_type', 'ids', 'field'))) {
          unset($values['source']['entity'][$key]);
        }
      }
    }

    return $values;
  }

  function execute() {
    foreach ($this->get_contexts() as $context) {
      if (!empty($context->reactions[$this->plugin])) {
        // We need an unique id for every Backstretch.
        static $id = 1;
        // Getting context settings.
        $settings = $context->reactions[$this->plugin];
        // Store the source stuff here.
        $source = $settings['source']['type'];

        // We store the default values from Backstretch formatter here.
        $formatters = backstretch_field_formatter_info();
        $default = $formatters['backstretch']['settings'];

        // We need the js variable name.
        $options_info = backstretch_formatter_options();
        // Here we store all options later.
        $options = array();

        foreach ($settings as $name => $value) {
          if (array_key_exists($name, $options_info)) {
            $option = $options_info[$name];
            $js = isset($option['js']) ? $option['js'] : '';

            // We need some special handling with the element settings.
            if ($name == 'element' || ($name == 'element_other' && $settings['element'] == '')) {
              continue;
            }

            /*
             * We have to figure out which tokens should be supported because in
             * the Context reaction you can also use a path to the image so let
             * us discuss this in https://drupal.org/node/2140009.

            // Replace tokens in the "Other element" field.
            if ($name == 'element_other') {
              $value = token_replace($value, array($entity_type => $entity));
            }*/

            // We only put the setting into $options when it is
            // not the default value.
            if ($value != $default[$name] && $js) {
              $options[$js] = $value;
            }

            // The fade option has to be an integer otherwise it doesn't work.
            if ($name == 'fade' && $value != $default[$name] && is_numeric($value) && intval($value) == $value) {
              $options[$name] = (int) $options[$name];
            }
          }
        }

        // We need special handling for every source type.
        switch ($source) {
          case 'entity':
            // We store the entity info.
            $entity_type = $settings['source']['entity']['entity_type'];
            $field = isset($settings['source']['entity']['field']) ? $settings['source']['entity']['field'] : '';
            $entity_ids = $settings['source']['entity']['ids'];
            $entity_ids = explode(',', $entity_ids);

            // We cannot continue without an entity type and an entity ID.
            if (!$entity_type || !$entity_ids) {
              return;
            }

            $entities = entity_load($entity_type, $entity_ids);

            foreach ($entities as $entity) {
              // If there is a file ID we can guess that we have a file here.
              if (isset($entity->fid) && isset($entity->uri)) {
                $options['items'][] = file_create_url($entity->uri);
                continue;
              }
              // Getting the field items.
              $items = field_get_items($entity_type, $entity, $field);
              // Iterate all items and store the absolute url to it.
              foreach ($items as &$item) {
                $uri = $item['uri'];
                // Get url to image styled image if a image style was set.
                if ($settings['image_style']) {
                  $url = image_style_url($settings['image_style'], $uri);
                }
                // Otherwise just get the url.
                else {
                  $url = file_create_url($uri);
                }
                $options['items'][] = $url;
              }
            }

            break;

          case 'path':
            // Just storing the path info.
            $paths = $settings['source']['path'];
            // We need an array for processing the paths.
            $paths = explode("\n", $paths);

            foreach ($paths as $key => $path) {
              $path = trim($path);
              // Just build an url for the path.
              $paths[$key] = url($path);
              // If an image style was set we try to image style the image.
              if ($settings['image_style']) {
                $uri = file_build_uri(drupal_basename($path));
                $paths[$key] = image_style_url($settings['image_style'], $uri);
              }
            }

            $options['items'] = $paths;
            break;
        }

        if ($settings['random']) {
          $random_key = array_rand($options['items']);
          $options['items'] = array($options['items'][$random_key]);
        }

        // Prepare a renderable array.
        $element = array(
          '#theme' => 'backstretch',
          '#id' => 'backstretch-' . $id,
          '#options' => $options,
        );

        // Increasing the id.
        $id++;

        // Return the rendered element.
        return drupal_render($element);
      }
    }
  }
}

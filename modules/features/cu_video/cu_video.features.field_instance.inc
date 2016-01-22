<?php
/**
 * @file
 * cu_video.features.field_instance.inc
 */

/**
 * Implements hook_field_default_field_instances().
 */
function cu_video_field_default_field_instances() {
  $field_instances = array();

  // Exported field_instance: 'node-video-body'
  $field_instances['node-video-body'] = array(
    'bundle' => 'video',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 0,
      ),
      'embed' => array(
        'label' => 'hidden',
        'module' => 'smart_trim',
        'settings' => array(
          'more_link' => 1,
          'more_text' => 'Read more »',
          'summary_handler' => 'full',
          'trim_length' => 50,
          'trim_options' => array(
            'text' => 'text',
          ),
          'trim_suffix' => '...',
          'trim_type' => 'words',
        ),
        'type' => 'smart_trim_format',
        'weight' => 0,
      ),
      'sidebar' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 1,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'smart_trim',
        'settings' => array(
          'more_link' => 1,
          'more_text' => 'Watch video »',
          'summary_handler' => 'full',
          'trim_length' => 50,
          'trim_options' => array(
            'text' => 'text',
          ),
          'trim_suffix' => '...',
          'trim_type' => 'words',
        ),
        'type' => 'smart_trim_format',
        'weight' => 1,
      ),
      'title' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'body',
    'label' => 'Body',
    'required' => FALSE,
    'settings' => array(
      'display_summary' => TRUE,
      'text_processing' => 1,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'module' => 'text',
      'settings' => array(
        'rows' => 20,
        'summary_rows' => 5,
      ),
      'type' => 'text_textarea_with_summary',
      'weight' => 31,
    ),
  );

  // Exported field_instance: 'node-video-field_video'
  $field_instances['node-video-field_video'] = array(
    'bundle' => 'video',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'This field work with YouTube, Google, Blip.TV, Revver, MySpace, MetaCafe, Last.fm, JumpCut, SevenLoad, Spike TV, Daily Motion, Veoh, Vimeo, Tudou, imeem, Guba, Yahoo Music Video, and Live Video.',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'module' => 'video_embed_field',
        'settings' => array(
          'description' => 0,
          'video_style' => 'normal',
        ),
        'type' => 'video_embed_field',
        'weight' => 1,
      ),
      'embed' => array(
        'label' => 'hidden',
        'module' => 'video_embed_field',
        'settings' => array(
          'description' => 0,
          'video_style' => 'normal',
        ),
        'type' => 'video_embed_field',
        'weight' => 1,
      ),
      'sidebar' => array(
        'label' => 'hidden',
        'module' => 'video_embed_field',
        'settings' => array(
          'description' => 0,
          'image_link' => 'node',
          'image_style' => 'square_thumbnail',
        ),
        'type' => 'video_embed_field_thumbnail',
        'weight' => 0,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'video_embed_field',
        'settings' => array(
          'description' => 0,
          'image_link' => 'node',
          'image_style' => 'square_thumbnail',
        ),
        'type' => 'video_embed_field_thumbnail',
        'weight' => 0,
      ),
      'title' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 1,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_video',
    'label' => 'Video',
    'required' => 0,
    'settings' => array(
      'allowed_providers' => array(
        0 => 'youtube',
        1 => 'vimeo',
      ),
      'description_field' => 1,
      'description_length' => 128,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'video_embed_field',
      'settings' => array(),
      'type' => 'video_embed_field_video',
      'weight' => 32,
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('Body');
  t('This field work with YouTube, Google, Blip.TV, Revver, MySpace, MetaCafe, Last.fm, JumpCut, SevenLoad, Spike TV, Daily Motion, Veoh, Vimeo, Tudou, imeem, Guba, Yahoo Music Video, and Live Video.');
  t('Video');

  return $field_instances;
}

<?php

for ($i = 1; $i <= 100; $i++) {
    $label = 'test-bean-' . $i;
    $values = array(
      'delta' => $label,
      'label' => $label,
      'title' => $label,
      'type' => 'block',
      'view_mode' => 'default',
    );

    $values['field_block_text'][LANGUAGE_NONE][0]['value'] = '';
    $values['field_block_text'][LANGUAGE_NONE][0]['format'] = 'wysiwyg';
    $bean = bean_create($values);
    $bean->save();


  }

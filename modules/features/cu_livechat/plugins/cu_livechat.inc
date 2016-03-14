<?php

class context_reaction_livechat extends context_reaction {

  function editor_form($context) {
  }

  function options_form($context) {
    $values = $this->fetch_from_context($context);
    $default = isset($values['livechat']) ? $values['livechat'] : 0;

    $form = array();

    $form['livechat'] = array(
      '#type' => 'checkbox',
      '#title' => t('Enable LiveChat'),
      '#default_value' => $default,
    );

    return $form;
  }

  function execute(&$page) {
    foreach ($this->get_contexts() as $k => $v) {
      if (isset($v->reactions[$this->plugin]['livechat'])) {
        return TRUE;
      }
    }
  }
}

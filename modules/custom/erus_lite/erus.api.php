<?php
/**
 * API FUNCS
 */

/**
 * Return an array of plugin information
 * @return [type] [description]
 */
function hook_erus_plugin_info() {
  $plugins = array();

  $plugins['my_plugin'] = array(
    'file' => 'plugins/myExamplePlugin.inc',
    'name' => 'myExamplePluginName',
    'module' => 'my_module_name',
  );

  return $plugins;
}

/**
 * Alter plugin information
 * @param  [type] $plugins [description]
 * @return [type]          [description]
 */
function hook_erus_plugin_info_alter(&$plugins) {

}


//////////////////////////////////////////////////////////////////////////
// Extending and creating plugins
//////////////////////////////////////////////////////////////////////////

/**
 * All ERUS plugins must extend the erusPlugin class.
 * All ERUS plugins must declare the process() method.
 *
 *
 *
 */

/**
 * Example Erus Plugin
 */
class erusExample extends erusPlugin {

  /**
   * - Optional Method -
   *
   * Creates a configuration form at:
   * admin/config/administration/erus/[-plugin_name-]
   *
   * A default submit handler is provided that saves all the form values
   * into the variables table for you at variable_get('erus_[plugin_name]');
   *
   * @return [array] [config form]
   */
  public function get_configuration_form() {
    $form = array();

    // Your form items here.

    return $form;
  }

  /**
   *  - Required Method -
   *
   * The meat of your plugin goes in here. It is passed in update data for a
   * module that has been validated to use this plugin. Add your logic here.
   *
   * @param  [array] $data Update Data
   * @return [array]
   */
  public function process($data) {

    // Do your stuff here.
    // ...

    // A guzzle client is available to you.
    $client = $this->get_client();

    // Get the configuration form settings

    return $data;
  }


}

<?php
/**
 * @file
 * Erus abstract plugin class
 */

use Guzzle\Http\Client as GuzzleClient;

abstract class erusPlugin implements erusPluginInterface {

  protected $storage = array();
  protected $client = null;
  protected $endpoint = null;
  protected $settings = array();
  protected $update_data = array();
  protected $plugin_name = null;

  /**
   * [__construct description]
   */
  public function __construct($settings) {
    $this->set_settings($settings);
  }

  /**
   * The meat
   * @param  $data  [description]
   * @return [type]           [description]
   */
  public function process($data) {
    // You need to override this one.
  }

  /**
   * This function is called for the configuration form page.
   * Declare this in your plugin class to have it work.
   * @return [type] [description]
   */
  public function get_configuration_form() {

    /**
     * eg:
     *
     * $form = array();
     * $form['username'] = array(
     *  '#type' => 'text',
     *  '#title' => 'GitHub Username',
     *  ...
     *
     * return $form;
     */

    return FALSE;
  }

  /**
   * Gets the settings from the configuration form page.
   * @return array
   */
  public function get_configuration_settings() {
    $plugin_name = $this->get_plugin_name();
    return variable_get('erus_' . $plugin_name, array());
  }

  /**
   * [get_plugin_name description]
   * @return [type] [description]
   */
  public function get_plugin_name() {
    return $this->plugin_name;
  }

  /**
   * [set_plugin_name description]
   */
  public function set_plugin_name($name) {
    $this->plugin_name = $name;
  }

  /**
   * [set_update_data description]
   * @param [type] $data [description]
   */
  protected function set_update_data($data) {
    $this->update_data = $data;
  }

  /**
   * [get_update_data description]
   * @return [type] [description]
   */
  protected function get_update_data() {
    return $this->update_data;
  }

  /**
   * Setter
   * @param [type] $set [description]
   */
  protected function set_settings($set) {
    $this->settings = $set;
  }

  /**
   * Getter
   * @return [type] [description]
   */
  protected function get_settings() {
    return $this->settings;
  }

  /**
   * Remove status information from data array
   */
  protected function sanitize_info_data(&$data) {
    unset($data['project_status']);
    unset($data['status']);
    unset($data['reason']);
  }

  /**
   * [set_storage description]
   * @param [type] $storage [description]
   */
  protected function set_storage($storage) {
    $this->storage = $storage;
  }

  /**
   * [get_storage description]
   * @return [type] [description]
   */
  protected function get_storage() {
    return $this->storage;
  }

  /**
   * Set the http client
   * @param [type] $client [description]
   */
  public function set_client($client) {
    $this->client = $client;
  }

  /**
   * [get_client description]
   * @return [type] [description]
   */
  protected function get_client() {
    if (in_null($this->client)) {
      $client = new GuzzleClient();
      $this->set_client($client);
    }
    return $this->client;
  }

  /**
   * [set_enpoint description]
   * @param [type] $endpoint [description]
   */
  protected function set_endpoint($endpoint) {
    $this->endpoint = $endpoint;
  }

  /**
   * [get_endpoint description]
   * @return [type] [description]
   */
  protected function get_endpoint() {
    return $this->endpoint;
  }

  /**
   * [get_project_name description]
   * @return [type] [description]
   */
  protected function get_project_name() {
    $settings = $this->get_settings();
    return $settings['project'];
  }

  /**
   * [get_account description]
   * @return [type] [description]
   */
  protected function get_account() {
    $settings = $this->get_settings();
    return $settings['account'];
  }





}

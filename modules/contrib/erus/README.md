# ERUS

### External Repository Update Status.

For connecting with external repository services such as github or bitbucket in
order to obtain update status information for custom work.


## INSTALLATION AND CONFIGURATION

By default ERUS will pick up any module that uses the project status url option
in the .info file of the module or feature.

	project status url = 'http://www.example.com'

ERUS module will attempt to gather information from the update status url in order to check the external service. ERUS comes with a built in github.com plugin. All
you would need to add to your features that are stored on github is the path
to the github project page. EG: for ERUS

	project status url = 'https://github.com/SU-SWS/erus'


You may also add specific configuration settings for each of your modules and
features no matter where they are hosted. Add the following to the .info file of
the project that is hosted with an external repository service.

	erus[plugin] = plugin_name
	erus[account] = remote-account-name
	erus[project] = *optional_project_name*

eg: for https://github.com/SU-SWS/stanford_person

	erus[plugin] = github.com
	erus[account] = SU-SWS
	erus[project] = stanford_person

## Plugins
[GitHub](plugins/README.md)    
A plugin to connect with GitHub's release functionalty. See [plugin documentation](plugins/README.md)
for more information.

## API

see [erus.api.php](erus.api.php)

	/**
	* Define your own plugins
	* /
	hook_erus_plugin_info()


	/**
	* Alter existing plugin information
	*/
	hook_erus_plugin_info_alter()


## Example Plugin

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

## Drush
**WARNING** This module will break your 'drush up' command unless all used plugins provide a valid md5 checksum and the download file unpacks with the exact same name as the module.

If your 'drush up' fails to validate md5 checksums or replaces module directories with invalid names you can use the included package-handler to remedy those ailments.

	eg: drush up --package-handler=erus_wget

By providing the --package-handler option you will be able to continue to use drush up.

Also included in this module is a wrapper for the above. Simply use the drush eup command to accomplish the same thing.

	eg: drush eup

## TODO

 * Development versions
 * Non Drupal naming convention releases
 * Many bug fixes and code clean up.
 * Multiple places for configuration (info & plugin)



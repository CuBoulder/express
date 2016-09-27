# Integrations
Listing of documentation around how Express can integrate with other services. 

## Pantheon
There is a separate version of Express that Pantheon users can pull in to start an Express site.

### Pantheon drop stuff...

### Site audit report
Pantheon has a nice feature where you can check best practices on a site from the Pantheon dashboard. There are several checks that can't be fixed on an Express site. So, Pantheon has some variables excluding these checks that can be placed in settings.php.

    $conf['site_audit']['opt_out']['ExtensionsUnrecommended'] = TRUE;

A list of the checks that can be added as exclusions exists here: [list of checks](http://cgit.drupalcode.org/site_audit/tree/Check).
To add a check, you combine the name of the parent directory and then the name of the PHP check file. So from the example above, "Extensions" is the parent directory and "Unrecommended" is the name of the PHP file in that directory. These checks map to the site report more or less but not word-for-word.

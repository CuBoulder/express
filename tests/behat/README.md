
## Local Setup

While it is ideal to use VMs or Docker images to share local development environments that are used to run tests, maintaining those VMs can be a huge PITA and requires a decent amount of Docker knowledge. Abstraction layers, like Lando, can be slow as hell and contain a bunch of cruft you don't need.

So, for now it is easiest to setup a local environment on you MacOS laptop to use for running tests at least, if not day-to-day development.

You will need:
- PHP 7 - [Homebrew works well for this step](https://github.com/Homebrew/homebrew-php).
- MySQL - [Homebrew can be used also here](https://gist.github.com/nrollr/3f57fc15ded7dddddcc4e82fe137b58e).
- Composer - Once PHP is installed, [you can install Composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx) locally or globally.
- Drush - Once Composer is installed, `composer global require "drush/drush:8.*"` to install Drush globally. 

You can check the versions of what you have locally, but for this tutorial the versions are as follows:
- PHP `7.1.10`
- MySQL `Server version: 5.7.19 Homebrew`
- Composer `1.5.2`
- Drush `8.1.12`

## Running Tests

You can now install an Express site by downloading Drupal, cloning in the Express profile, and installing the site. 

```bash
ROOT=$(pwd)

# Add Drupal.
drush dl drupal-7.56
mv drupal-7.56 testing

# Make files folder and copy settings.php file.
cd ${ROOT}/testing/sites/default
cp default.settings.php settings.php && chmod 777 settings.php
mkdir files && chmod -R 777 files

# Add the Express profile.
cd ${ROOT}/testing/profiles
git clone git@github.com:CuBoulder/express.git

# Install site. Need to use your db credentials created when installing MySQL.
drush si express --db-url=mysql://root:@127.0.0.1/testing

```

When Express installs, environmental variables are used to determine which "core" to install.

```bash
drush vset ldap_servers_require_ssl_for_credentials 0
```

You will need to install Behat's dependencies as well as export an environmental variable in order to run the Behat tests.

```bash
cd site-path/profiles/express/tests/behat
mv composer

composer install
```

Rather than having you change the behat.yml configuration file, it easier to change environmental variables and have Behat pickup on those. This way environmental variables can be used on the CI setup without changing the configuration files as well.

```bash

export BEHAT_PARAMS='{"extensions":{"Drupal\\DrupalExtension":{"drupal":{"drupal_root":"BUILD_TOP/drupal"}},"Behat\\MinkExtension":{"base_url":"http://127.0.0.1:8888/","files_path":"BUILD_TOP/drupal/profiles/express/tests/behat/assets/"}}}'

```

To run tests...

```bash
# Chrome is installed already...
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
chrome --disable-gpu --headless --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 > /dev/null 2>&1 &

./bin/behat --config behat.local.yml --verbose --tags '~@exclude_all_bundles&&~broken'
```

## Fixing Broken Tests

The headless Chrome driver is used to run tests on Travis. Selenium was dropped due to its brittle nature of not playing nice with different combinations of Chrome/Firefox as Travis updated the default versions of Chrome and Firefox periodically. Many projects have switched to the method we now use on Travis; however, you will need to use Selenium if a JS test is breaking and you want to maunally inspect why. 

You will need to..
- [Download standalone server](http://docs.seleniumhq.org/download/)
- [Download latest Chrome webdriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)

```bash
# Startup Selenium webserver with the proper version of "selenium-server-standalone-3.4.0.jar".
java -Dwebdriver.chrome.driver=chromedriver -jar selenium-server-standalone-3.4.0.jar > /dev/null 2>&1 &` 

# Run tests using selenium configuration. 
./bin/behat --config behat.selenium.yml --verbose --tags '~@exclude_all_bundles&&~broken'
```

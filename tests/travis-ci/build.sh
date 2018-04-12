#!/usr/bin/env bash

# Install latest Drush 8.
# No travis_retry command found outside of .travis.yml.
composer self-update && composer --version
composer global require "drush/drush:8.*"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Build Behat dependencies
cd /tests/behat
travis_retry composer install --prefer-dist --no-interaction
cd ../../../

# Build Codebase
drush cc drush
pwd
ls -al
exit 1
drush dl drupal-7.58
mkdir drupal
mv drupal-7.58/* drupal/
mkdir profiles
mv express drupal/profiles/

# Harden Codebase
cd drupal
cd modules
rm -rf php aggregator blog book color contact translation dashboard forum locale openid overlay poll rdf search statistics toolbar tracker trigger
cd ../..

# Setup files
mkdir -p drupal/sites/default/files/styles/preview/public/gallery/
chmod -R 777 drupal/sites
mkdir tmp
chmod -R 777 tmp

# Disable sendmail
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Bump up max execution time.
echo "max_execution_time=60" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Increase the MySQL connection timeout on the PHP end.
echo "mysql.connect_timeout=3000" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "default_socket_timeout=3000" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Increase the MySQL server timetout and packet size.
mysql -e "SET GLOBAL wait_timeout = 36000;"
mysql -e "SET GLOBAL max_allowed_packet = 33554432;"

# Sauce starts connection to the tunnel here, but concurrent sessions aren't used until a JS test is reached.

# Disable XDebug to speed up test runs.
phpenv config-rm xdebug.ini || true

# Do the site install after removing Xdebug. Speeds up site install...maybe...but install is slower in Travis install phase.
mysql -e 'create database drupal;'
cd drupal
cp profiles/express/tests/travis-ci/settings.travis.php sites/default/settings.php
drush si express --db-url=mysql://root:@127.0.0.1/drupal --account-name=admin --account-pass=admin --site-mail=admin@example.com --site-name="Express" --yes

# Check and see if testing core module is enabled.
drush pm-info travis_hosting
drush pm-info cu_core
drush pm-info cu_ldap
drush pm-info ldap_authentication

# Export db so it can be imported after every suite run.
# Test runs that fill up the db with nodes can impact other tests.
drush sql-dump --result-file=$HOME/cache/express.sql

# Start server...
drush runserver 127.0.0.1:8057 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8057; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8057..."; nc -zvv localhost 8057; out=$?; sleep 5; done

# Setting Behat environment variables is now done in behat.travis.yml for simplicity.

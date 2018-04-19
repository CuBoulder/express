#!/usr/bin/env bash

# Disable XDebug to speed up test runs.
phpenv config-rm xdebug.ini

# Add database and settings.php file.
mysql -e 'create database drupal;'
echo ----
echo ----
echo Exit Code is: $?
if [ "$?" = "1" ]; then exit 1 ; fi
echo ---
echo ---
cp $ROOT_DIR/drupal/profiles/express/tests/travis-ci/settings.travis.php $ROOT_DIR/drupal/sites/default/settings.php

# Disable sendmail from https://www.drupal.org/project/phpconfig/issues/1826652.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Add PHP config that somewhat matches current prod.
phpenv config-add $ROOT_DIR/drupal/profiles/express/tests/travis-ci/config/express-php.ini
echo ----
echo ----
echo Exit Code is: $?
if [ "$?" = "1" ]; then exit 1 ; fi
echo ---
echo ---

# Change InnoDB settings that speed things up.
# https://www.percona.com/blog/2015/02/24/mysqls-innodb_file_per_table-slowing/.
mysql -e "SET @@global.innodb_file_per_table=0;"

# https://dba.stackexchange.com/questions/12611/is-it-safe-to-use-innodb-flush-log-at-trx-commit-2.
mysql -e "SET @@global.innodb_flush_log_at_trx_commit=2;"
echo ----
echo ----
echo Exit Code is: $?
if [ "$?" = "1" ]; then exit 1 ; fi
echo ---
echo ---

# Echo out some system info.
php -i | grep memory
cat /proc/meminfo

exit 0

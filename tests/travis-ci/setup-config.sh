#!/usr/bin/env bash

# Disable XDebug to speed up test runs.
phpenv config-rm xdebug.ini

# Disable sendmail from https://www.drupal.org/project/phpconfig/issues/1826652.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Add PHP config that somewhat matches current prod.
phpenv config-add travis-ci/config/express-php.ini

# Change InnoDB settings that speed things up.
# https://www.percona.com/blog/2015/02/24/mysqls-innodb_file_per_table-slowing/.
mysql -e "SET @@global.innodb_file_per_table=0;"

# https://dba.stackexchange.com/questions/12611/is-it-safe-to-use-innodb-flush-log-at-trx-commit-2.
mysql -e "SET @@global.innodb_flush_log_at_trx_commit=2;"

# Echo out some system info.
php -i | grep memory
cat /proc/meminfo

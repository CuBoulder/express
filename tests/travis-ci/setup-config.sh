#!/usr/bin/env bash

# Disable XDebug to speed up test runs.
phpenv config-rm xdebug.ini

# Disable sendmail.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Bump up max execution time.
echo "max_execution_time=60" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Increase the MySQL connection timeout on the PHP end.
echo "mysql.connect_timeout=3000" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "default_socket_timeout=3000" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

# Increase the MySQL server timetout and packet size.
mysql -e "SET GLOBAL wait_timeout = 36000;"
mysql -e "SET GLOBAL max_allowed_packet = 33554432;"

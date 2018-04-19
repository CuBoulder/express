#!/usr/bin/env bash

# Start server.
cd $ROOT_DIR/drupal
$HOME/.composer/vendor/bin/drush runserver 127.0.0.1:8057 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8057; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8057..."; nc -zvv localhost 8057; out=$?; sleep 5; done
echo ----
echo ----
if [ "$?" == "1" ]; then exit 1 ; fi
echo Exit Code is: $?
echo ---
echo ---

# Setting Behat environment variables is now done in behat.travis.yml for simplicity.

# Run headless Behat tests.
${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&~@javascript'
echo ----
echo ----
if [ "$?" == "1" ]; then exit 1 ; fi
echo Exit Code is: $?
echo ---
echo ---

# Run JS Behat tests if merged into dev.
${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/run-js-tests.sh
echo ----
echo ----
if [ "$?" == "1" ]; then exit 1 ; fi
echo Exit Code is: $?
echo ---
echo ---

# Output performance logging data.
$HOME/.composer/vendor/bin/drush scr ${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/log-express-performance.php

exit 0

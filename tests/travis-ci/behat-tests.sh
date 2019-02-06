#!/usr/bin/env bash

# Start server.
cd ${ROOT_DIR}/drupal
$HOME/.composer/vendor/bin/drush runserver 127.0.0.1:8031 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8031; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8031..."; nc -zvv localhost 8031; out=$?; sleep 5; done
earlyexit

if [ "${BUNDLE_NAME}" != "null" ]; then
  cd ${ROOT_DIR}/drupal/sites/all/modules/${BUNDLE_NAME}
else
  cd ${ROOT_DIR}/drupal/profiles/express
fi

# Run the bundle tests first to get more immediate feedback on failures.
# Express tests take longer and bundle tests are more important to run during development.
if [ "${BUNDLE_NAME}" != "null" ]; then

  # Enable bundle.
  cd $ROOT_DIR/drupal
  echo Enabling bundle module...
  $HOME/.composer/vendor/bin/drush en $BUNDLE_NAME -y

  # Enable any additional modules used during test runs.
  echo Enabling additional testings modules...
  $HOME/.composer/vendor/bin/drush en $ADD_MODULES -y
  $HOME/.composer/vendor/bin/drush cc all

  # Run any database updates.
  # Express db updates have already been run at this point.
  echo Running pending database updates...
  $HOME/.composer/vendor/bin/drush updb -y

  echo "Running ${BUNDLE_NAME} bundle tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.bundle.yml --verbose --tags ${BUNDLE_BEHAT_TAGS}
  earlyexit
fi

# Setting Behat environment variables is now done in behat.travis.yml for simplicity.

# Run Behat Express tests when in a bundle repo if commit flag is set.
SKIP_EXPRESS_TESTS="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '!==express')"
if [ ! "${SKIP_EXPRESS_TESTS}" ]; then

  echo "Running Express headless tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.travis.yml --verbose --tags ${EXPRESS_HEADLESS_BEHAT_TAGS}
  earlyexit

  # Run JS Behat tests if merged into dev.
  ${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/run-js-tests.sh
  earlyexit

fi

# Output performance logging data.
$HOME/.composer/vendor/bin/drush scr ${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/log-express-performance.php

exit 0

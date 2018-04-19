#!/usr/bin/env bash

# Start server.
cd $ROOT_DIR/drupal
$HOME/.composer/vendor/bin/drush runserver 127.0.0.1:8057 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8057; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8057..."; nc -zvv localhost 8057; out=$?; sleep 5; done
earlyexit

cd $ROOT_DIR/drupal/profiles/express
SKIP_EXPRESS_TESTS="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '!==express')"
echo "Build Express? - ${SKIP_EXPRESS_TESTS}"

# Setting Behat environment variables is now done in behat.travis.yml for simplicity.

# Run headless Behat tests.
if [ ! "${SKIP_EXPRESS_TESTS}" ]; then
    echo "Running Express headless tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&~@javascript'
  earlyexit

  # Run JS Behat tests if merged into dev.
  ${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/run-js-tests.sh
  earlyexit
fi

# Run bundle tests.
echo "printing bundle name: ${BUNDLE_NAME}"
if [ "${BUNDLE_NAME}" != "null" ]; then
  echo "Running bundle tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.bundle.yml --verbose --tags '~@exclude_all_bundles&&~@broken'
  earlyexit
fi

# Output performance logging data.
$HOME/.composer/vendor/bin/drush scr ${ROOT_DIR}/drupal/profiles/express/tests/travis-ci/log-express-performance.php

exit 0

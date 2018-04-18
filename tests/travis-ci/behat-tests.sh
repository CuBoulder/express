#!/usr/bin/env bash

# Start server.
drush runserver 127.0.0.1:8057 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8057; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8057..."; nc -zvv localhost 8057; out=$?; sleep 5; done

# Setting Behat environment variables is now done in behat.travis.yml for simplicity.

# Run headless Behat tests.
cd behat
./bin/behat --config behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&~@javascript'

# Run JS Behat tests if merged into dev.
../travis-ci/run-js-tests.sh

# Output performance logging data.
drush scr profiles/express/tests/travis-ci/log-express-performance.php

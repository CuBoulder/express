#!/usr/bin/env bash

# If the Behat tags include JavaScript, then start Sauce Connect.
if [ "${BEHAT_TAGS}" == "@javascript&&~exclude_all_bundles&&~broken" ]; then
  sc -u $SAUCE_USERNAME -k $SAUCE_ACCESS_KEY > /dev/null 2>&1 &
  nc -zvv 127.0.0.1 4445; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit Selenium port 4445..."; nc -zvv localhost 4445; out=$?; sleep 5; done
fi

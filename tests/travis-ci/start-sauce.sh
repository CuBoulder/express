#!/usr/bin/env bash

# If the Behat tags include JavaScript, then start Sauce Connect.
if [ "${BEHAT_TAGS}" == "@javascript&&~exclude_all_bundles&&~broken" ]; then

  # Connect to Sauce proxy and write output to file in the background.
  touch foo.txt
  sc -u $SAUCE_USERNAME -k $SAUCE_ACCESS_KEY > foo.txt > /dev/null 2>&1

  # While the process is starting, look for the line that tells you Sauce is up and then continue.
  COUNT=0
  while [ -z "$(tail -1 foo.txt | head | grep 'Sauce Connect is up, you may start your tests.')" ] && [ "${COUNT}" -lt "10" ]; do
    echo "Retry hit Sauce Connect..."
    COUNT=$((${COUNT} + 1))
    echo "Count is ${COUNT}"
    sleep 5
  done
  echo "Sauce Connect is up..."
fi

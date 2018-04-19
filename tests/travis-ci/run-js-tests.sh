#!/usr/bin/env bash

cd $ROOT_DIR/drupal/profiles/express
EXPRESS_COMMIT_HAS_JS="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '===js')"
echo "commit has JS? - ${EXPRESS_COMMIT_HAS_JS}"

# Run JS tests if merging PR into dev or has JS in it.
if [ "${TRAVIS_EVENT_TYPE}" == "push" ] || [ "${EXPRESS_COMMIT_HAS_JS}" ]; then
  echo "Running JS tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&@javascript'
  echo ----
  echo ----
  echo Exit Code is: $?
  if [ "$?" = "1" ]; then exit 1 ; fi
  echo ---
  echo ---
else
  echo "Not Running JS tests..."
fi

exit 0

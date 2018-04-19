#!/usr/bin/env bash

EXPRESS_COMMIT_HAS_JS="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '===js')"
echo "commit has JS? - ${EXPRESS_COMMIT_HAS_JS}"

# Run JS tests if merging PR into dev or has JS in it.
if [ "${TRAVIS_EVENT_TYPE}" == "push" ] || [ "${EXPRESS_COMMIT_HAS_JS}" ]; then
  echo "Running JS tests..."
  ${ROOT_DIR}/drupal/profiles/express/tests/behat/bin/behat --config ${ROOT_DIR}/drupal/profiles/express/tests/behat/behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&@javascript'
else
  echo "Not Running JS tests..."
fi

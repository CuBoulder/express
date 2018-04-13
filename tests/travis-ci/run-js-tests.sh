#!/usr/bin/env bash

EXPRESS_COMMIT_HAS_JS="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '===js')"
echo "commit has JS? - ${EXPRESS_COMMIT_HAS_JS}"

EXPRESS_COMMIT_HAS_MERGE="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep 'Merge pull request')"
echo "commit has JS? - ${EXPRESS_COMMIT_HAS_JS}"

# Run JS tests if merging PR into dev or has JS in it.
if [ "${EXPRESS_COMMIT_HAS_MERGE}" ] || [ "${EXPRESS_COMMIT_HAS_JS}" ]; then
  echo "Running JS tests..."
  ./bin/behat --config behat.travis.yml --verbose --tags '~@exclude_all_bundles&&~@broken&&@javascript'
else
  echo "Not Running JS tests..."
fi

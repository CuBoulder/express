#!/usr/bin/env bash

EXPRESS_COMMIT_HAS_BUILD="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '===build')"
echo "Build Express? - ${EXPRESS_COMMIT_HAS_BUILD}"

EXPRESS_COMMIT_HAS_MERGE="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep 'Merge pull request')"
echo "commit merged to dev? - ${EXPRESS_COMMIT_HAS_MERGE}"

# Build Express if no db export or commit is "merged into dev".
if [ ! -f $HOME/cache/express.sql ] || [ "${EXPRESS_COMMIT_HAS_BUILD}" ] || [ "${EXPRESS_COMMIT_HAS_MERGE}" ]; then

  # Install site like normal.
  echo Installing Express...
  drush si express --db-url=mysql://root:@127.0.0.1/drupal --account-name=admin --account-pass=admin --site-mail=admin@example.com --site-name="Express" --yes

  # Export db so it can be imported after every suite run.
  # Test runs that fill up the db with nodes can impact other tests.
  echo Exporting database...
  drush sql-dump --result-file=$HOME/cache/express.sql
else

  # Import db if it is already built.
  echo Importing Express database...
  drush sql-cli < $HOME/cache/express.sql
fi

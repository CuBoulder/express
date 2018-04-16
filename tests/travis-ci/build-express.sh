#!/usr/bin/env bash

EXPRESS_COMMIT_HAS_BUILD="$(git log -2 --pretty=%B | awk '/./{line=$0} END{print line}' | grep '===build')"
echo "Build Express? - ${EXPRESS_COMMIT_HAS_BUILD}"

# https://docs.travis-ci.com/user/caching/
# Travis takes the cache of the default branch if the PR branch doesn't have one.
# So, if this is a merge into dev, we need to delete the db export.
if [  "${TRAVIS_EVENT_TYPE}" == "push" ]; then
  echo Removing cached db on merge into dev...
  rm -f $HOME/cache/express.sql
fi

# Build Express if no db export or commit is "merged into dev".
if [ ! -f $HOME/cache/express.sql ] || [ "${EXPRESS_COMMIT_HAS_BUILD}" ]; then

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

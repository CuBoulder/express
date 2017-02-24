#!/bin/bash
# Try to run branch-related tests.

# Under Gitflow the branch will always be after the last slash.
BRANCH=$(echo $TRAVIS_PULL_REQUEST_BRANCH | awk -F/ '{print $NF}')

# Try to run tests with branch tag.
RESULT=$(./bin/behat --config behat.yml --verbose --tags @$BRANCH)
echo "$RESULT"

# If no branch tests are found, run the whole suite.
SCENARIO=${RESULT:0:12}
if [ "$SCENARIO" = "No scenarios" ]
then
  printf "\n\nRunning whole test suite\n\n"
  ./bin/behat --config behat.yml --verbose --tags '~@exclude_all_bundles'
fi

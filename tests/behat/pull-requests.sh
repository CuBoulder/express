#!/bin/bash
# Try to run branch-related tests.

# Under Gitflow the branch will always be after the last slash.
BRANCH=$(echo $TRAVIS_PULL_REQUEST_BRANCH | awk -F/ '{print $NF}')
echo "$BRANCH"

# Try to run tests with branch tag.
BRANCH_RESULT=$(./bin/behat --config behat.yml --verbose --tags @$BRANCH)
echo "$BRANCH_RESULT"

# If no branch tests are found, run the whole suite.
SCENARIO=${BRANCH_RESULT:0:12}
if [ "$SCENARIO" = "No scenarios" ]
  then
  printf "\n\nRunning whole test suite\n\n"
  FULL_RESULT=$(./bin/behat --config behat.yml --verbose --tags '~@exclude_all_bundles')
  if [[ "$FULL_RESULT" == *"failed)"* ]]
    then
    exit 1
  fi
elif [[ "$BRANCH_RESULT" == *"failed)"* ]]
  then
  exit 1
fi

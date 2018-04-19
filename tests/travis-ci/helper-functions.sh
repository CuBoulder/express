#!/usr/bin/env bash

# This function takes the output of the last command and exits if it failed.
earlyexit() {
  CODE="$?"
  echo ----
  echo ----
  if [ "${CODE}" != "0" ]; then
    echo ---
    echo Exiting on failure...
    echo ---
    exit 1
  fi
  echo Exit Code is: ${?}
  echo ---
  echo ---
}

export -f earlyexit

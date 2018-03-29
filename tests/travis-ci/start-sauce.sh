#!/usr/bin/env bash

# If the Behat tags include JavaScript, then start Sauce Connect.
if [ "${BEHAT_TAGS}" == "@javascript&&~exclude_all_bundles&&~broken" ]; then sc -u $SAUCE_USERNAME -k $SAUCE_ACCESS_KEY ; fi

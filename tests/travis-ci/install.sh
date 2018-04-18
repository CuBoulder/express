#!/usr/bin/env bash

# Install latest Drush 8.
travis_retry composer global require "drush/drush:8.*"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Build Behat dependencies.
cd ./tests/behat
travis_retry composer install --prefer-dist --no-interaction
cd ../../../

# Build Codebase.
drush dl drupal-7.58
mkdir drupal && mv drupal-7.58/* drupal/
mkdir profiles && mv express drupal/profiles/

# Harden Codebase.
cd drupal/modules
rm -rf php aggregator blog book color contact translation dashboard forum locale openid overlay poll rdf search statistics toolbar tracker trigger
cd ../

# Setup files.
mkdir -p sites/default/files/styles/preview/public/gallery/ && chmod -R 777 sites
mkdir ../tmp && chmod -R 777 ../tmp

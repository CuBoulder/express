#!/usr/bin/env bash

# Install latest Drush 8.
composer global require "drush/drush:8.*"
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---
export PATH="$HOME/.composer/vendor/bin:$PATH"
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---

# Build Behat dependencies.
cd $ROOT_DIR/express/tests/behat
composer install --prefer-dist --no-interaction
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---

# Build Codebase.
cd $ROOT_DIR
drush dl drupal-7.58
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---
mkdir drupal && mv drupal-7.58/* drupal/
mkdir profiles && mv express drupal/profiles/

# Harden Codebase.
cd $ROOT_DIR/drupal/modules
rm -rf php aggregator blog book color contact translation dashboard forum locale openid overlay poll rdf search statistics toolbar tracker trigger
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---

# Setup files.
mkdir -p $ROOT_DIR/drupal/sites/default/files/styles/preview/public/gallery/ && chmod -R 777 $ROOT_DIR/drupal/sites
mkdir $ROOT_DIR/tmp && chmod -R 777 $ROOT_DIR/tmp
echo ----
echo ----
echo Exit Code is: $?
echo ---
echo ---

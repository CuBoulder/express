#!/usr/bin/env bash


# Check if backup already exists.
# Travis keeps a cache directory per branch.
if [ ! -f $HOME/cache/express.sql  ]; then
    echo "Importing backup..."

    drush sql-cli < $HOME/cache/express.sql
    echo "Backup imported."
else
    echo "Installing Express..."

    drush si express --db-url=mysql://root:@127.0.0.1/drupal --account-name=admin --account-pass=admin --site-mail=admin@example.com --site-name="Express" express_profile_configure_form.express_core_version=cu_testing_core --yes
    drush sql-dump --result-file=$HOME/cache/express.sql
    echo "Backup exported."
fi

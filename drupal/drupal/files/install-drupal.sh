#!/bin/bash

rm sites/default/settings.php
vendor/bin/drush site:install -y --account-pass=admin --db-url=mysql://root:@localhost/drupal

# Enable api-first modules
vendor/bin/drupal moi -y \
  basic_auth \
  graphql_core \
  jsonapi \
  # Circular reference detected for service "multiversion.manager"
  # https://www.drupal.org/project/multiversion/issues/2905566
  #relaxed \
  restui
  #simple_oauth

# Configuration management
vendor/bin/drupal moi -y config_rewrite

# Enable memcache modules
vendor/bin/drupal moi -y \
  memcache
echo "include \$app_root . '/' . \$site_path . '/settings.memcache.php';" >> sites/default/settings.php

# Enable varnish_purge
vendor/bin/drupal moi -y \
  varnish_purger

vendor/bin/drupal moi -y \
  r4032login

vendor/bin/drupal site:mode prod

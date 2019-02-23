#!/bin/bash

rm sites/default/settings.php
vendor/bin/drush site:install -y --account-pass=admin --db-url=mysql://root:@localhost/drupal

# Uninstall modules
vendor/bin/drush pmu -y \
  contact \
  dblog \
  toolbar

# Enable api-first modules
vendor/bin/drupal moi -y \
  basic_auth \
  graphql_core \
  restui
  # jsonapi issue: Uncaught TypeError: Argument 2 passed to Drupal\jsonapi\Routing\Routes::Drupal\jsonapi\Routing\{closure}() must be an instance of Drupal\jsonapi\ResourceType\ResourceType, null given in
  # https://www.drupal.org/project/jsonapi/issues/3034592
  #jsonapi \
  # relaxed issue: Circular reference detected for service "multiversion.manager"
  # https://www.drupal.org/project/multiversion/issues/2905566
  #relaxed \
  #simple_oauth

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
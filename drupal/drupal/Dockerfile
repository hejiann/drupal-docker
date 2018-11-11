FROM jianhe/debian
MAINTAINER Jian He <hejian.he@gmail.com>

# Install system packages
RUN apt-get install -y \
  git \
  unzip \
  wget

# Mysql server config
COPY 60-drupal.cnf /etc/mysql/conf.d/60-drupal.cnf

# Install Drupal
RUN rm -rf /var/www/html
RUN git clone -b 8.6.x git://git.drupal.org/project/drupal.git /var/www/html

WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT 1200
RUN composer install

# Patch: Allow Tours to be taken by users that cannot access the Toolbar
# https://www.drupal.org/project/drupal/issues/2069073
#RUN wget https://www.drupal.org/files/issues/2069073-38.patch && \
#  patch -p1 < 2069073-38.patch && \
#  rm 2069073-38.patch

# Patch: View output is not used for entityreference options
# https://www.drupal.org/node/2174633
#RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
#  patch -p1 < 2174633-143-entity-reference.patch && \
#  rm 2174633-143-entity-reference.patch

# Patch: Can't create comments when comment is a base field
# https://www.drupal.org/project/drupal/issues/2855068
RUN wget https://www.drupal.org/files/issues/2855068-8_0.patch && \
  patch -p1 < 2855068-8_0.patch && \
  rm 2855068-8_0.patch

# Patch: Allow updating modules with new service dependencies
# https://www.drupal.org/project/drupal/issues/2863986
RUN wget https://www.drupal.org/files/issues/2863986-2-49.patch && \
  patch -p1 < 2863986-2-49.patch && \
  rm 2863986-2-49.patch

# Patch: Enable block contextual link
# https://www.drupal.org/project/drupal/issues/2940015
RUN wget https://www.drupal.org/files/issues/2940015-block-contextual-link-2.patch && \
  patch -p1 < 2940015-block-contextual-link-2.patch && \
  rm 2940015-block-contextual-link-2.patch

# Patch: TypeError: Argument 1 passed to _editor_get_file_uuids_by_field() must implement interface Drupal\\Core\\Entity\\EntityInterface
# https://www.drupal.org/project/drupal/issues/2974156
RUN wget https://www.drupal.org/files/issues/2018-11-08/2974156-editor-typeerror-9.patch && \
  patch -p1 < 2974156-editor-typeerror-9.patch && \
  rm 2974156-editor-typeerror-9.patch

# Install Drupal modules
RUN composer require \
  drupal/r4032login \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_class \
  drupal/conditional_fields \
  drupal/custom_formatters \
  drupal/facets \
  drupal/features \
  drupal/field_formatter_class \
  drupal/field_group \
  drupal/inline_entity_form \
  drupal/pinyin \
  drupal/quicktabs \
  drupal/reference_table_formatter \
  drupal/rules \
  drupal/search_api_solr \
  drupal/token \
  drupal/token_filter \
  drupal/views_slideshow

# If PHP filter is empty, module should return TRUE and not execute code
# https://www.drupal.org/project/php/issues/2678430
#RUN cd modules/contrib/php && \
#  wget https://www.drupal.org/files/issues/php_condition_check_empty-2678430-13.patch && \
#  patch -p1 < php_condition_check_empty-2678430-13.patch && \
#  rm php_condition_check_empty-2678430-13.patch

# Install charts
RUN composer require drupal/charts
RUN mkdir libraries -p && \
  wget https://github.com/d3/d3/archive/v3.5.17.zip && \
  unzip v3.5.17.zip && \
  mv d3-3.5.17 libraries/d3 && \
  wget https://github.com/c3js/c3/archive/v0.4.18.zip && \
  unzip v0.4.18.zip && \
  mv c3-0.4.18 libraries/c3

# Install entity_print
RUN composer require drupal/entity_print \
  mikehaertl/phpwkhtmltopdf
# PDF generation errors with DomPDF due to drupalSettings
# https://www.drupal.org/project/entity_print/issues/2969184
RUN cd modules/contrib/entity_print && \
  wget https://www.drupal.org/files/issues/2018-05-03/entity_print-dompdf-2969184.patch && \
  patch -p1 < entity_print-dompdf-2969184.patch && \
  rm entity_print-dompdf-2969184.patch

# Install latest eva
RUN git clone git://git.drupal.org/project/eva.git -b 8.x-1.x /var/www/html/modules/eva

# Install field_widget_class
#RUN composer require drupal/field_widget_class
RUN git clone git://git.drupal.org/project/field_widget_class.git -b 8.x-1.x /var/www/html/modules/field_widget_class
# Patch: No hook alter to override Field Widget wrappers created by WidgetBase::form
RUN wget https://www.drupal.org/files/issues/2872162-field-widget-hook-3.patch && \
  patch -p1 < 2872162-field-widget-hook-3.patch && \
  rm 2872162-field-widget-hook-3.patch

# Patch: Fatal error: Call to a member function buildMultiple() on null in EntityToTableRenderer.php
# https://www.drupal.org/project/reference_table_formatter/issues/2866712
RUN cd modules/contrib/reference_table_formatter && \
  wget https://www.drupal.org/files/issues/2866712-call-to-a-member-function-on-null-4.patch && \
  patch -p1 < 2866712-call-to-a-member-function-on-null-4.patch && \
  rm 2866712-call-to-a-member-function-on-null-4.patch

# Install drush
RUN composer require drush/drush

# Install Drupal site
RUN mkdir -p /var/www/html/sites/default/files && \
  chmod a+rw /var/www/html/sites/default -R && \
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php && \
  cp /var/www/html/sites/default/default.services.yml /var/www/html/sites/default/services.yml && \
  chmod a+rw /var/www/html/sites/default/settings.php && \
  chmod a+rw /var/www/html/sites/default/services.yml && \
  chown -R www-data:www-data /var/www/html/

RUN mkdir -p /var/www/private && \
  chown -R www-data:www-data /var/www/private && \
  echo "\$settings['file_private_path'] = '/var/www/private';" >> /var/www/html/sites/default/settings.php

RUN /etc/init.d/mysql start && \
  vendor/bin/drush si -y --account-pass=admin --db-url=mysql://root:@localhost/drupal

RUN composer require drupal/console

# Issue: "side:mode prod" cause 'Unable to parse at line 130 (near "{}")' issue on most recent drupal 8.5.x
# https://github.com/hechoendrupal/drupal-console/issues/3749
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal site:mode prod

# Install migrate modules
RUN composer require \
  drupal/csv_serialization \
  drupal/default_content \
  #drupal/migrate_plus \
  drupal/migrate_source_csv \
  drupal/migrate_source_xls
  #drupal/migrate_tools
# Install recent migrate_tools
RUN git clone git://git.drupal.org/project/migrate_tools.git /var/www/html/modules/migrate_tools
# Install recent migrate_plus module
RUN git clone git://git.drupal.org/project/migrate_plus.git /var/www/html/modules/migrate_plus
# PATCH: EntityGenerate does not process the values correctly
# https://www.drupal.org/node/2975266
RUN cd modules/migrate_plus && \
  wget https://www.drupal.org/files/issues/2018-05-25/2975266-values-2.patch && \
  patch -p1 < 2975266-values-2.patch && \
  rm 2975266-values-2.patch
# PATCH: migrate_source_xls does not support constants defined in migration configuration
# https://www.drupal.org/project/migrate_source_xls/issues/2954477
RUN cd modules/contrib/migrate_source_xls && \
  wget https://www.drupal.org/files/issues/2018-03-20/2954477-constants-2.patch && \
  patch -p1 < 2954477-constants-2.patch && \
  rm 2954477-constants-2.patch

# Install layout modules
RUN composer require \
  drupal/page_manager \
  drupal/panels \
  drupal/panelizer

# Page variants cannot be selected
# https://www.drupal.org/project/page_manager/issues/2868216
RUN cd modules/contrib/page_manager && \
  wget https://www.drupal.org/files/issues/page_manager-page_variants_selection-2868216-7.patch && \
  patch -p1 < page_manager-page_variants_selection-2868216-7.patch && \
  rm page_manager-page_variants_selection-2868216-7.patch

# 8.5.x
# Service 'page_manager.variant_route_filter' for consumer 'router.no_access_checks' does not implement Drupal\Core\Routing\FilterInterface
# https://www.drupal.org/node/2918564
#RUN cd modules/contrib/page_manager && \
#  wget https://www.drupal.org/files/issues/page_manager_variant_route_filter-2918564.patch && \
#  patch -p1 < page_manager_variant_route_filter-2918564.patch && \
#  rm page_manager_variant_route_filter-2918564.patch

# Patch: Custom attributes in panels blocks
# https://www.drupal.org/node/2849867
RUN cd modules/contrib/panels && \
  wget https://www.drupal.org/files/issues/2849867-custom_attributes_in_panels_blocks-11.patch && \
  patch -p1 < 2849867-custom_attributes_in_panels_blocks-11.patch && \
  rm 2849867-custom_attributes_in_panels_blocks-11.patch

# Install api-first modules
RUN composer require \
  #drupal/graphql \
  drupal/jsonapi \
  drupal/relaxed \
  drupal/restui
  # [ERROR] Incomplete or missing schema for simple_oauth.oauth2_token.bundle.
  #drupal/simple_oauth

# Add missing @group annotations for several test classes.
# https://github.com/drupal-graphql/graphql/pull/679
RUN composer require webonyx/graphql-php && \
  git clone https://github.com/drupal-graphql/graphql.git /var/www/html/modules/graphql

# Enable api-first modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    basic_auth \
    graphql \
    jsonapi \
    # Circular reference detected for service "multiversion.manager"
    # https://www.drupal.org/project/multiversion/issues/2905566
    #relaxed \
    restui
    #simple_oauth

# Configuration management
RUN composer require drupal/config_rewrite && \
  /etc/init.d/mysql restart && \
  vendor/bin/drupal moi -y config_rewrite

# Install data modeling modules
#RUN composer require \
#  drupal/eck
# Enable data modeling modules
#RUN /etc/init.d/mysql start && \
#  vendor/bin/drupal moi -y \
#    eck

# eck issue: Tests are failed
#RUN cd modules/contrib/eck && \
#  wget https://www.drupal.org/files/issues/eck-tests_failed_D8.6-2937133-2-D8.patch && \
#  patch -p1 < eck-tests_failed_D8.6-2937133-2-D8.patch && \
#  rm eck-tests_failed_D8.6-2937133-2-D8.patch

# Install memcache modules
RUN composer require \
  drupal/memcache
# Enable memcache modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    memcache
COPY settings.local.php sites/default/settings.local.php
RUN echo "include \$app_root . '/' . \$site_path . '/settings.local.php';" >> sites/default/settings.php

# Enable modlues
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    r4032login

# Install varnish_purge
RUN composer require \
  drupal/purge \
  drupal/varnish_purge
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    varnish_purger

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n


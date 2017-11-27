FROM jianhe/debian
MAINTAINER Jian He <hejian.he@gmail.com>

# Install Drupal
RUN rm -rf /var/www/html
ENV DRUPAL_VERSION 20171126
RUN git clone git://git.drupal.org/project/drupal.git /var/www/html

WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT 1200
RUN composer install

#RUN cd core && yarn install

# Patch: View output is not used for entityreference options
# https://www.drupal.org/node/2174633
#RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
#  patch -p1 < 2174633-143-entity-reference.patch && \
#  rm 2174633-143-entity-reference.patch

# Patch: Allow blocks to be added to entity displays in Field UI
# https://www.drupal.org/project/drupal/issues/2878685
RUN wget https://www.drupal.org/files/issues/2878685-block-field_ui-26.patch && \
  patch -p1 < 2878685-block-field_ui-26.patch && \
  rm 2878685-block-field_ui-26.patch

# Install Drupal modules
RUN composer require \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_class \
  drupal/custom_formatters \
  drupal/features \
  drupal/field_formatter_class \
  drupal/field_group \
  drupal/inline_entity_form \
  drupal/menu_block \
  drupal/php \
  drupal/quicktabs \
  drupal/reference_table_formatter \
  drupal/rules \
  drupal/token \
  drupal/views_slideshow

# Install charts
RUN composer require drupal/charts && \
  cd modules/contrib/charts/modules/charts_c3 && \
  composer install

# Install latest eva
RUN git clone git://git.drupal.org/project/eva.git -b 8.x-1.x /var/www/html/modules/eva

# Install field_widget_class
#RUN composer require drupal/field_widget_class
RUN git clone git://git.drupal.org/project/field_widget_class.git -b 8.x-1.x /var/www/html/modules/field_widget_class
# Patch: No hook alter to override Field Widget wrappers created by WidgetBase::form
RUN wget https://www.drupal.org/files/issues/2872162-field-widget-hook-3.patch && \
  patch -p1 < 2872162-field-widget-hook-3.patch && \
  rm 2872162-field-widget-hook-3.patch

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

RUN /etc/init.d/mysql start && \
  vendor/bin/drush site-install -y --account-pass=admin --db-url=mysql://root:@localhost/drupal

RUN composer require drupal/console

#RUN /etc/init.d/mysql start && \
#  vendor/bin/drush cset -y system.performance css.preprocess 0 && \
#  vendor/bin/drush cset -y system.performance js.preprocess 0
#RUN sed -i 's/debug: false/debug: true/' /var/www/html/sites/default/services.yml && \
#  sed -i 's/auto_reload: null/auto_reload: true/' /var/www/html/sites/default/services.yml
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal site:mode dev

# Enable modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    ajax_links_api \
    #big_pipe will let page_manager not work: https://www.drupal.org/node/2868216
    block_place \
    charts \
    charts_c3 \
    custom_formatters \
    eva \
    features_ui \
    field_formatter_class \
    field_group \
    menu_block \
    php \
    quicktabs \
    reference_table_formatter \
    rules \
    settings_tray \
    views_slideshow \
    views_slideshow_cycle

# Install migrate modules
RUN composer require \
  drupal/default_content \
  #drupal/migrate_plus \
  drupal/migrate_source_csv
  #drupal/migrate_tools
# Install recent migrate_tools
RUN git clone git://git.drupal.org/project/migrate_tools.git /var/www/html/modules/migrate_tools
# Install recent migrate_plus module
RUN git clone git://git.drupal.org/project/migrate_plus.git /var/www/html/modules/migrate_plus

# Enable migrate modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    default_content \
    migrate_tools

# Install layout modules
RUN composer require \
  drupal/ds \
  drupal/page_manager \
  drupal/panels \
  drupal/panelizer

# 8.5.x
# Service 'page_manager.variant_route_filter' for consumer 'router.no_access_checks' does not implement Drupal\Core\Routing\FilterInterface
# https://www.drupal.org/node/2918564
RUN cd modules/contrib/page_manager && \
  wget https://www.drupal.org/files/issues/page_manager_variant_route_filter-2918564.patch && \
  patch -p1 < page_manager_variant_route_filter-2918564.patch && \
  rm page_manager_variant_route_filter-2918564.patch

# Install panels
#RUN git clone git://git.drupal.org/project/panels.git -b 8.x-4.x /var/www/html/modules/panels
# Patch: Custom attributes in panels blocks
# https://www.drupal.org/node/2849867
RUN cd modules/contrib/panels && \
  wget https://www.drupal.org/files/issues/2849867-custom_attributes_in_panels_blocks-11.patch && \
  patch -p1 < 2849867-custom_attributes_in_panels_blocks-11.patch && \
  rm 2849867-custom_attributes_in_panels_blocks-11.patch

# Enable layout modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    ds \
    page_manager_ui \
    panelizer \
    panels

# Install api-first modules
RUN composer require \
  drupal/graphql \
  #drupal/jsonapi \
  drupal/restui
# jsonapi on Drpual 8.5.x
# Fatal error on 8.5.x: RelationshipItemNormalizer implements RefinableCacheableDependencyInterface, but should not
# https://www.drupal.org/project/jsonapi/issues/2926291
RUN git clone git://git.drupal.org/project/jsonapi.git /var/www/html/modules/jsonapi
# Enable api-first modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    basic_auth \
    graphql \
    jsonapi \
    restui

# Install data modeling modules
RUN composer require \
  drupal/eck
# Enable data modeling modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    eck

# Install dev tool modules
RUN git clone git://git.drupal.org/project/config_inspector.git /var/www/html/modules/config_inspector
# Enable dev tools modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    config_inspector \
    simpletest

# Install drupal themes
RUN composer require \
  drupal/radix

# Install memcache modules
RUN composer require \
  drupal/memcache \
  drupal/memcache_storage
# Enable memcache modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    memcache \
    memcache_storage
COPY settings.local.php sites/default/settings.local.php
RUN echo "include \$app_root . '/' . \$site_path . '/settings.local.php';" >> sites/default/settings.php

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n


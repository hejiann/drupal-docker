FROM jianhe/debian
MAINTAINER Jian He <hejian.he@gmail.com>

# Install Drupal
RUN rm -rf /var/www/html
ENV DRUPAL_VERSION 20171110
RUN git clone git://git.drupal.org/project/drupal.git /var/www/html -b 8.4.x

WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT 1200
RUN composer install

#RUN cd core && yarn install

# Patch: View output is not used for entityreference options
# https://www.drupal.org/node/2174633
#RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
#  patch -p1 < 2174633-143-entity-reference.patch && \
#  rm 2174633-143-entity-reference.patch

# Install Drupal modules
RUN composer require \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_class \
  drupal/custom_formatters \
  drupal/default_content \
  drupal/eck \
  drupal/features \
  drupal/field_formatter_class \
  drupal/field_group \
  drupal/inline_entity_form \
  drupal/menu_block \
  drupal/paragraphs \
  drupal/php \
  drupal/quicktabs \
  drupal/reference_table_formatter \
  drupal/rules \
  drupal/token \
  drupal/views_slideshow

# 8.5.x
# Service 'page_manager.variant_route_filter' for consumer 'router.no_access_checks' does not implement Drupal\Core\Routing\FilterInterface
# https://www.drupal.org/node/2918564
#RUN cd modules/contrib/page_manager && \
#  wget https://www.drupal.org/files/issues/page_manager_variant_route_filter-2918564.patch && \
#  patch -p1 < page_manager_variant_route_filter-2918564.patch && \
#  rm page_manager_variant_route_filter-2918564.patch

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

# Install dev tool modules
RUN git clone git://git.drupal.org/project/config_inspector.git /var/www/html/modules/config_inspector

# Install migrate modules
RUN composer require \
  #drupal/migrate_plus \
  drupal/migrate_source_csv \
  drupal/migrate_tools
# Install recent migrate_tools
#RUN git clone git://git.drupal.org/project/migrate_tools.git -b 8.x-4.x /var/www/html/modules/migrate_tools
# Install recent migrate_plus module
RUN git clone git://git.drupal.org/project/migrate_plus.git /var/www/html/modules/migrate_plus

# Install layout modules
RUN composer require \
  drupal/ds \
  drupal/page_manager

# Install display suite
#RUN git clone git://git.drupal.org/project/ds.git -b 8.x-3.x /var/www/html/modules/ds

# Install panels
RUN git clone git://git.drupal.org/project/panels.git -b 8.x-4.x /var/www/html/modules/panels
# Patch: Custom attributes in panels blocks
RUN cd /var/www/html/modules/panels && \
  wget https://www.drupal.org/files/issues/2849867-custom_attributes_in_panels_blocks-11.patch && \
  patch -p1 < 2849867-custom_attributes_in_panels_blocks-11.patch && \
  rm 2849867-custom_attributes_in_panels_blocks-11.patch

# Install api-first modules
RUN composer require \
  drupal/graphql \
  drupal/jsonapi \
  drupal/restui

# Install drupal themes
RUN composer require \
  drupal/radix

# Install drush
RUN composer require drush/drush
#RUN composer require drush/drush:dev-master

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
    default_content \
    eck \
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

# Enable migrate modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    migrate_tools

# Enable layout modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    ds \
    page_manager_ui \
    panels

# Enable api-first modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    basic_auth \
    jsonapi \
    restui

# Enable dev tool modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drupal moi -y \
    config_inspector \
    simpletest

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n


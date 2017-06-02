FROM jianhe/debian
MAINTAINER Jian He <hejian.he@gmail.com>

# Install Drupal
RUN rm -rf /var/www/html
ENV DRUPAL_VERSION 20170531
RUN git clone git://git.drupal.org/project/drupal.git -b 8.3.x /var/www/html

WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT 1200
RUN composer install

# Clearing cache via UI in translated language resets config translation of field labels to default language
# https://www.drupal.org/node/2650434
RUN wget https://www.drupal.org/files/issues/clearing_cache_via_ui-2650434-128.patch && \
  patch -p1 < clearing_cache_via_ui-2650434-128.patch && \
  rm clearing_cache_via_ui-2650434-128.patch

# Patch: View output is not used for entityreference options
#RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
#  patch -p1 < 2174633-143-entity-reference.patch && \
#  rm 2174633-143-entity-reference.patch

# Install Drupal modules
RUN composer require \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_class \
  drupal/bootstrap \
  drupal/default_content \
  drupal/eck \
  drupal/features \
  drupal/field_formatter_class \
  drupal/inline_entity_form \
  drupal/jsonapi \
  drupal/menu_block \
  drupal/migrate_source_csv \
  drupal/page_manager \
  drupal/paragraphs \
  drupal/php \
  drupal/quicktabs \
  drupal/restui \
  drupal/rules \
  drupal/state_machine \
  drupal/token \
  drupal/views_slideshow \
  drush/drush:dev-master

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

# Install recent migrate_tools
RUN git clone git://git.drupal.org/project/migrate_tools.git -b 8.x-4.x /var/www/html/modules/migrate_tools

# Install panels
RUN git clone git://git.drupal.org/project/panels.git -b 8.x-4.x /var/www/html/modules/panels
# Patch: Custom attributes in panels blocks
RUN cd /var/www/html/modules/panels && \
  wget https://www.drupal.org/files/issues/2849867-custom_attributes_in_panels_blocks-11.patch && \
  patch -p1 < 2849867-custom_attributes_in_panels_blocks-11.patch && \
  rm 2849867-custom_attributes_in_panels_blocks-11.patch

# Install display suite
RUN git clone git://git.drupal.org/project/ds.git -b 8.x-3.x /var/www/html/modules/ds

# Install Drupal site
RUN mkdir -p /var/www/html/sites/default/files && \
  chmod a+rw /var/www/html/sites/default -R && \
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php && \
  cp /var/www/html/sites/default/default.services.yml /var/www/html/sites/default/services.yml && \
  chmod a+rw /var/www/html/sites/default/settings.php && \
  chmod a+rw /var/www/html/sites/default/services.yml && \
  chown -R www-data:www-data /var/www/html/

# Install drupal console
RUN apt-get install -y php5-sqlite && \
  curl https://drupalconsole.com/installer -L -o drupal.phar && \
  mv drupal.phar /usr/local/bin/drupal && \
  chmod +x /usr/local/bin/drupal

RUN /etc/init.d/mysql start && \
  vendor/bin/drush site-install -y --account-pass=admin --db-url=mysql://root:@localhost/drupal

#RUN composer require drupal/console

# Enable modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y \
    ajax_links_api \
    basic_auth \
  # big_pipe will let page_manager not work: https://www.drupal.org/node/2868216
    charts \
    charts_c3 \
    default_content \
    ds \
    eck \
    eva \
    features_ui \
    field_formatter_class \
    jsonapi \
    migrate_tools \
    page_manager_ui \
    panels \
    php \
    quicktabs \
    restui \
    rules \
    simpletest \
    views_slideshow \
    views_slideshow_cycle

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n


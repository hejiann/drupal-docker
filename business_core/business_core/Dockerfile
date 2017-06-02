FROM jianhe/drupal
MAINTAINER Jian He <hejian.he@gmail.com>

# Install business modules
ENV BUSINESS_CORE_VERSION 20170510
RUN git clone git://git.drupal.org/project/business_core.git /var/www/html/modules/business_core
RUN git clone git://git.drupal.org/project/admin_lte.git /var/www/html/modules/admin_lte

RUN cd modules/business_core/modules/reactjs && \
  yarn install && \
  node_modules/.bin/webpack

RUN /etc/init.d/mysql start && \
  vendor/bin/drush site-install -y business --account-pass=admin --db-url=mysql://root:@localhost/drupal

RUN composer require drupal/console

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

# Enable business modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y jsonapi \
    quick_code \
    simple_box

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n


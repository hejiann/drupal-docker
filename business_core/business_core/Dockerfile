FROM jianhe/drupal
MAINTAINER Jian He <hejian.he@gmail.com>

# Install business module
ENV BUSINESS_CORE_VERSION 20170516
RUN git clone git://git.drupal.org/project/business_core.git /var/www/html/modules/business_core

RUN cd modules/business_core/modules/reactjs && \
  yarn install && \
  node_modules/.bin/webpack

RUN cd modules/business_core/modules/reactjs/node_modules/redux-json-api && \
  ../.bin/webpack lib/jsonapi.js dist/jsonapi.js

# Install admin_lte theme
RUN git clone git://git.drupal.org/project/admin_lte.git /var/www/html/themes/admin_lte
RUN cd themes/admin_lte && \
  yarn install
RUN npm install -g bower
RUN cd themes/admin_lte && \
  bower install --allow-root
RUN cd themes/admin_lte && \
  node_modules/.bin/gulp css

# Enable business modules
RUN /etc/init.d/mysql start && \
  vendor/bin/drush en -y \
    outside_in_plus \
    reactjs_page \
    quick_code \
    simple_box

# Enable admin_lte theme
RUN /etc/init.d/mysql start && \
  vendor/bin/drush then admin_lte && \
  vendor/bin/drush cset -y system.theme default admin_lte

# Setup site name
RUN /etc/init.d/mysql start && \
  vendor/bin/drush cset -y system.site name "Business core"

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

